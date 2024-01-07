#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/fcntl.h"
#include "kernel/param.h"

#define NUM 32

int main(int argc, char * argv[]) {

    char buff[1];
    char * bufl = (char *) malloc(sizeof(char) * NUM);
    
    if(argc < 3) {
        printf("not enough parameters\n");
        exit(0);
    }

    for(int i = 0; i < NUM; i++) {
        bufl[i] = '?';
    }

    int count = 0;
    int numargs = 0;

    while(read(0, buff, 1) == 1) { 
        bufl[count] = buff[0];
        count++;
        if(buff[0] == (char) 10) {
            numargs++;
        }
    }    

    char ** argsb = (char **) malloc(sizeof(char *) * numargs);

    int sz = 0;

    for(int k = 0; k < count; k++) {
        if(bufl[k] == (char) 10) { break; }
        else { sz++; }
    }

    argsb[0] = (char *) malloc(sizeof(char) * sz);

    int arg = 0;
    int index = 0;

    for(int k = 0; k < count; k++) {
        if(bufl[k] == (char) 10) {
            arg++;
            argsb[arg] = (char *) malloc(sizeof(char) * index);
            index = 0;
        }
        else {
            argsb[arg][index] = bufl[k];
            index++;
        }
    }

    for(int le = 0; le < numargs; le++) {
        if(fork() == 0) {
            char ** argvl = (char **) malloc(sizeof(char *) * 3);

            for(int k = 0; k < 3; k++) {
                argvl[k] = (char *) malloc(sizeof(char) * NUM);
            }
            argvl[0] = argv[1];  
            argvl[1] = argv[2]; 
            argvl[2] = argsb[le];
            exec(argv[1], argvl);
            exit(0);
        }
    }

    for(int i = 0; i < numargs; i++) { wait(0); }
    
    exit(0);
}