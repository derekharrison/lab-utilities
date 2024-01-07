#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/fcntl.h"

char*
fmtname(char *path)
{
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
    ;
  p++;

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
    return p;
  
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  
  return buf;
}

char * getname(char * path) {

    int count = 0;

    for(int i = 0; i < DIRSIZ; i++) {
        if(path[i] != ' ')
            count++;
    }

    char * buf = (char *) malloc(sizeof(char) * count);

    for(int i = 0; i < count; i++) {
        buf[i] = path[i];
    }

    return buf;
}

void
find(char * path, char * ref)
{
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, O_RDONLY)) < 0){
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  case T_DEVICE:
  case T_FILE:
    break;

  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
      printf("ls: path too long\n");
      break;
    }
    
    strcpy(buf, path);
    
    p = buf+strlen(buf);
    
    *p++ = '/';

    while(read(fd, &de, sizeof(de)) == sizeof(de)){
      if(de.inum == 0)
        continue;
      
      memmove(p, de.name, DIRSIZ);
      p[DIRSIZ] = 0;
      
      if(stat(buf, &st) < 0){
        printf("ls: cannot stat %s\n", buf);
        continue;
      }

      if(st.type == T_DIR) {
        if(strcmp(getname(fmtname(buf)), ".") == 0 || strcmp(getname(fmtname(buf)), "..") == 0) {

        } 
        else {
            
            char * str = getname(fmtname(buf));
            int newsize = strlen(path) + strlen(str) + 1;
            char * bufl = (char *) malloc(sizeof(char) * newsize);
            
            for(int i = 0; i < strlen(path); i++) {
                bufl[i] = path[i];
            }
           
            bufl[strlen(path)] = '/';

            for(int i = 0; i < strlen(str); i++) {
                bufl[i + strlen(path) + 1] = str[i];
            }

            find(bufl, ref);            
        }
      }
      if(st.type == T_FILE) {
        if(strcmp(getname(fmtname(buf)), ref) == 0) {
            printf("%s\n", buf);
        }             
      }
    } 
    break;
  }
  close(fd);
}

int
main(int argc, char *argv[])
{

  if(argc < 2){
    exit(0);
  }

  find(argv[1], argv[2]);
  
  exit(0);
}