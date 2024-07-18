#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define READ 0
#define WRITE 1
 
int main()
{
    int fd[2];
    pipe(fd); // create pipe
    
    int fdc[2];
    pipe(fdc);
    int ret = fork(); // get child pid

    if (ret == -1) 
    {
        printf("fork error\n");
        close(fdc[READ]);
        close(fdc[WRITE]);
        close(fd[READ]);
        close(fd[WRITE]);
        exit(1);
    } 
    else if(ret == 0) // child process
    {
        int buf[8] = {'\0'};

        close(fd[WRITE]); 
        read(fd[READ], buf, 5);
        printf("%d: receive %s", getpid(), buf);
 
        close(fdc[READ]);
        write(fdc[WRITE], "pong\n", 5);

        close(fd[READ]); 
        close(fdc[WRITE]); 
        exit(0);   
 
    } 
    else // parent process
    {
        int buf[8] = {'\0'};

        close(fd[READ]); 
        write(fd[WRITE], "ping\n", 5);
 
 
        close(fdc[1]);
        read(fdc[READ], buf, 5);
        printf("%d: receive %s", getpid(), buf);
        
        close(fd[WRITE]); 
        close(fdc[READ]); 
        exit(0);  
    }
    return 0;
}