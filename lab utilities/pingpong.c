#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "user/user.h"

int main(int argc, char * argv[]) {

    int p1[2];
    int p2[2];

    pipe(p1);
    pipe(p2);

    if(fork() == 0) {
        char buff[32];
        int nb = read(p1[0], buff, 1);
        while(nb != 1) { nb = read(p1[0], buff, 1); }
        int pid = getpid();
        fprintf(1, "%d", pid);
        fprintf(1, ": received ping\n");
        close(p1[0]);
        close(p1[1]);
        write(p2[1], "d", 1);
        close(p2[0]);
        close(p2[1]);
        exit(0);
    }
    else {
        char buff[32];
        write(p1[1], "c", 1);
        close(p1[0]);
        close(p1[1]);
        int nb = read(p2[0], buff, 1);
        while(nb != 1) { nb = read(p2[0], buff, 1); }
        int pid = getpid();
        fprintf(1, "%d", pid);
        fprintf(1, ": received pong\n");
        close(p2[0]);
        close(p2[1]);
        exit(0);
    }

    return 0;
}