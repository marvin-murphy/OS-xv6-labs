#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
 
#define READ 0
#define WRITE 1

int main()
{
    int buff[34], p[2], size = 34;
    for (int i = 0; i < 34; ++i)
        buff[i] = i + 2;
    pipe(p);
    write(p[WRITE], buff, size * sizeof(int));
    close(p[WRITE]);
 
    while(size)
    {
        if (fork() == 0)
        {
            read(p[READ], buff, size * sizeof(int));
            close(p[READ]);
            pipe(p); // create new child process
            printf("prime %d\n", buff[0]);
            int cnt = 0, prime = buff[0]; // use the first one as prime
            for (int i = 0; i < size; ++i)
                if (buff[i] % prime != 0)
                    buff[cnt++] = buff[i]; // save the number that cannot be divided exactly
            size = cnt;
            write(p[WRITE], buff, cnt * sizeof(int));
            close(p[WRITE]);
        }
        else
        {
            wait(0);
            exit(0);
        }
    }
    exit(0);
}