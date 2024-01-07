#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "user/user.h"

int MAX = 35;

void filter(int c, int p[][2], int start, int end) {

    if(fork() == 0) {
        // Close all non used channels
        for(int i = 0; i <= end; i++) {
            if(i != c + 1) {
                close(p[i][1]);
            }
            if(i != c) {
                close(p[i][0]);
            }
        }
        
        // Compute prime
        char buff[2];
        read(p[c][0], buff, 2);
        
        int sl = atoi(buff);
        
        if(sl > 0) {
            fprintf(1, "prime %d\n", atoi(buff));
        }

        // Read data from pipe c
        while(read(p[c][0], buff, 2) > 0) {
            // Write data to pipe c + 1
            if(sl > 0 && c <= end && atoi(buff) % sl) {
                write(p[c + 1][1], buff, 2);

                // All multiples of MAX / 2 have been computed, return remaining primes
                if(sl >= MAX / 2) {
                    fprintf(1, "prime %d\n", atoi(buff));
                }
            }
        }

        // Close remaining pipes
        close(p[c][0]);
        close(p[c + 1][1]);

        exit(0);       
    }
    else {
        close(p[c][1]);

        // Apply filter to pipe c + 1
        if(c + 1 <= end / 3) {
            filter(c + 1, p, start, end);
        }        

        close(p[c][0]);
    }
}

void print_primes(int start, int end) {

    // Outside of computation bounds
    if(end > MAX) {
        fprintf(2, "exceeded index bounds of 35\n");
        return;
    }

    int p[end + 1][2]; // Pipeline

    for(int i = 0; i <= end; i++) {
        pipe(p[i]);
    }

    // Feed to pipeline
    int sl = start;

    fprintf(1, "prime %d\n", sl);

    int c = 0;
    
    for(int i = sl + 1; i <= end; i++) {
        if(i % sl) {
            int dig1 = i / 10;
            int dig2 = i - dig1 * 10;
            char stl[2];
            stl[0] = dig1 + '0';
            stl[1] = dig2 + '0';
            write(p[c][1], stl, 2);
        }
    }    

    close(p[c][1]); 

    // Apply filter
    filter(0, p, start, end);

    for(int i = 0; i <= end; i++) {
        wait(0);
    }

    for(int i = 0; i <= end; i++) {
        close(p[i][0]);
        close(p[i][1]);
    }
}

int main(int argc, char * argv[]) {

    const int END = 35;
    const int START = 2;

    print_primes(START, END);

    exit(0);
}