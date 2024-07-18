#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
 
void search(char *path, char *name)
{
    struct dirent de;
    struct stat st;
    char buf[512], *p;
    int fd;
 
    if ((fd = open(path, 0)) < 0)
    {
        fprintf(2, "find: cannot open %s\n", path);
        return;
    }
 
    if (fstat(fd, &st) < 0)
    {
        fprintf(2, "find: cannot stat %s\n", path);
        close(fd);
        return;
    }
 
    switch (st.type)
    {
    case T_FILE:
        printf("find: %s is a file instead of a path.\n", path);
        break;
    case T_DIR:
        if (strlen(path) + 1 + DIRSIZ + 1 > sizeof(buf))
        {
            printf("find: path too long!\n");
            break;
        }
        strcpy(buf, path);
        p = buf + strlen(path);
        *p++ = '/';
 
        while (read(fd, &de, sizeof(de)) == sizeof(de))
        {
            if (!strcmp(de.name, ".") || !strcmp(de.name, "..") || de.inum == 0)
                continue;
            memmove(p, de.name, DIRSIZ);
            p[DIRSIZ] = 0;
            if (stat(buf, &st) < 0)
            {
                printf("find: cannot stat %s", buf);
                continue;
            }
            switch (st.type)
            {
            case T_DIR:
                search(buf, name);
                break;
            case T_FILE:
                if (!strcmp(de.name, name))
                    printf("%s\n", buf, path);
                break;
            default:
                break;
            }
        }
        break;
    }
    close(fd);
}
 
int main(int argc, char *argv[])
{
    if (argc < 3)
    {
        fprintf(2, "usage: find rootpath filename.\n");
        exit(1);
    }
 
    search(argv[1], argv[2]);
    exit(0);
}