
user/_find：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <search>:
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
 
void search(char *path, char *name)
{
   0:	d8010113          	addi	sp,sp,-640
   4:	26113c23          	sd	ra,632(sp)
   8:	26813823          	sd	s0,624(sp)
   c:	26913423          	sd	s1,616(sp)
  10:	27213023          	sd	s2,608(sp)
  14:	25313c23          	sd	s3,600(sp)
  18:	25413823          	sd	s4,592(sp)
  1c:	25513423          	sd	s5,584(sp)
  20:	25613023          	sd	s6,576(sp)
  24:	23713c23          	sd	s7,568(sp)
  28:	23813823          	sd	s8,560(sp)
  2c:	0500                	addi	s0,sp,640
  2e:	892a                	mv	s2,a0
  30:	89ae                	mv	s3,a1
    struct dirent de;
    struct stat st;
    char buf[512], *p;
    int fd;
 
    if ((fd = open(path, 0)) < 0)
  32:	4581                	li	a1,0
  34:	00000097          	auipc	ra,0x0
  38:	4ce080e7          	jalr	1230(ra) # 502 <open>
  3c:	06054a63          	bltz	a0,b0 <search+0xb0>
  40:	84aa                	mv	s1,a0
    {
        fprintf(2, "find: cannot open %s\n", path);
        return;
    }
 
    if (fstat(fd, &st) < 0)
  42:	f8840593          	addi	a1,s0,-120
  46:	00000097          	auipc	ra,0x0
  4a:	4d4080e7          	jalr	1236(ra) # 51a <fstat>
  4e:	06054c63          	bltz	a0,c6 <search+0xc6>
        fprintf(2, "find: cannot stat %s\n", path);
        close(fd);
        return;
    }
 
    switch (st.type)
  52:	f9041783          	lh	a5,-112(s0)
  56:	0007869b          	sext.w	a3,a5
  5a:	4705                	li	a4,1
  5c:	08e68563          	beq	a3,a4,e6 <search+0xe6>
  60:	4709                	li	a4,2
  62:	00e69b63          	bne	a3,a4,78 <search+0x78>
    {
    case T_FILE:
        printf("find: %s is a file instead of a path.\n", path);
  66:	85ca                	mv	a1,s2
  68:	00001517          	auipc	a0,0x1
  6c:	9a850513          	addi	a0,a0,-1624 # a10 <malloc+0x11c>
  70:	00000097          	auipc	ra,0x0
  74:	7cc080e7          	jalr	1996(ra) # 83c <printf>
                break;
            }
        }
        break;
    }
    close(fd);
  78:	8526                	mv	a0,s1
  7a:	00000097          	auipc	ra,0x0
  7e:	470080e7          	jalr	1136(ra) # 4ea <close>
}
  82:	27813083          	ld	ra,632(sp)
  86:	27013403          	ld	s0,624(sp)
  8a:	26813483          	ld	s1,616(sp)
  8e:	26013903          	ld	s2,608(sp)
  92:	25813983          	ld	s3,600(sp)
  96:	25013a03          	ld	s4,592(sp)
  9a:	24813a83          	ld	s5,584(sp)
  9e:	24013b03          	ld	s6,576(sp)
  a2:	23813b83          	ld	s7,568(sp)
  a6:	23013c03          	ld	s8,560(sp)
  aa:	28010113          	addi	sp,sp,640
  ae:	8082                	ret
        fprintf(2, "find: cannot open %s\n", path);
  b0:	864a                	mv	a2,s2
  b2:	00001597          	auipc	a1,0x1
  b6:	92e58593          	addi	a1,a1,-1746 # 9e0 <malloc+0xec>
  ba:	4509                	li	a0,2
  bc:	00000097          	auipc	ra,0x0
  c0:	752080e7          	jalr	1874(ra) # 80e <fprintf>
        return;
  c4:	bf7d                	j	82 <search+0x82>
        fprintf(2, "find: cannot stat %s\n", path);
  c6:	864a                	mv	a2,s2
  c8:	00001597          	auipc	a1,0x1
  cc:	93058593          	addi	a1,a1,-1744 # 9f8 <malloc+0x104>
  d0:	4509                	li	a0,2
  d2:	00000097          	auipc	ra,0x0
  d6:	73c080e7          	jalr	1852(ra) # 80e <fprintf>
        close(fd);
  da:	8526                	mv	a0,s1
  dc:	00000097          	auipc	ra,0x0
  e0:	40e080e7          	jalr	1038(ra) # 4ea <close>
        return;
  e4:	bf79                	j	82 <search+0x82>
        if (strlen(path) + 1 + DIRSIZ + 1 > sizeof(buf))
  e6:	854a                	mv	a0,s2
  e8:	00000097          	auipc	ra,0x0
  ec:	1b6080e7          	jalr	438(ra) # 29e <strlen>
  f0:	2541                	addiw	a0,a0,16
  f2:	20000793          	li	a5,512
  f6:	00a7fb63          	bgeu	a5,a0,10c <search+0x10c>
            printf("find: path too long!\n");
  fa:	00001517          	auipc	a0,0x1
  fe:	93e50513          	addi	a0,a0,-1730 # a38 <malloc+0x144>
 102:	00000097          	auipc	ra,0x0
 106:	73a080e7          	jalr	1850(ra) # 83c <printf>
            break;
 10a:	b7bd                	j	78 <search+0x78>
        strcpy(buf, path);
 10c:	85ca                	mv	a1,s2
 10e:	d8840513          	addi	a0,s0,-632
 112:	00000097          	auipc	ra,0x0
 116:	144080e7          	jalr	324(ra) # 256 <strcpy>
        p = buf + strlen(path);
 11a:	854a                	mv	a0,s2
 11c:	00000097          	auipc	ra,0x0
 120:	182080e7          	jalr	386(ra) # 29e <strlen>
 124:	1502                	slli	a0,a0,0x20
 126:	9101                	srli	a0,a0,0x20
 128:	d8840793          	addi	a5,s0,-632
 12c:	00a78a33          	add	s4,a5,a0
        *p++ = '/';
 130:	001a0b93          	addi	s7,s4,1
 134:	02f00793          	li	a5,47
 138:	00fa0023          	sb	a5,0(s4)
            if (!strcmp(de.name, ".") || !strcmp(de.name, "..") || de.inum == 0)
 13c:	00001a97          	auipc	s5,0x1
 140:	914a8a93          	addi	s5,s5,-1772 # a50 <malloc+0x15c>
 144:	00001b17          	auipc	s6,0x1
 148:	914b0b13          	addi	s6,s6,-1772 # a58 <malloc+0x164>
 14c:	4c05                	li	s8,1
        while (read(fd, &de, sizeof(de)) == sizeof(de))
 14e:	4641                	li	a2,16
 150:	fa040593          	addi	a1,s0,-96
 154:	8526                	mv	a0,s1
 156:	00000097          	auipc	ra,0x0
 15a:	384080e7          	jalr	900(ra) # 4da <read>
 15e:	47c1                	li	a5,16
 160:	f0f51ce3          	bne	a0,a5,78 <search+0x78>
            if (!strcmp(de.name, ".") || !strcmp(de.name, "..") || de.inum == 0)
 164:	85d6                	mv	a1,s5
 166:	fa240513          	addi	a0,s0,-94
 16a:	00000097          	auipc	ra,0x0
 16e:	108080e7          	jalr	264(ra) # 272 <strcmp>
 172:	dd71                	beqz	a0,14e <search+0x14e>
 174:	85da                	mv	a1,s6
 176:	fa240513          	addi	a0,s0,-94
 17a:	00000097          	auipc	ra,0x0
 17e:	0f8080e7          	jalr	248(ra) # 272 <strcmp>
 182:	d571                	beqz	a0,14e <search+0x14e>
 184:	fa045783          	lhu	a5,-96(s0)
 188:	d3f9                	beqz	a5,14e <search+0x14e>
            memmove(p, de.name, DIRSIZ);
 18a:	4639                	li	a2,14
 18c:	fa240593          	addi	a1,s0,-94
 190:	855e                	mv	a0,s7
 192:	00000097          	auipc	ra,0x0
 196:	27e080e7          	jalr	638(ra) # 410 <memmove>
            p[DIRSIZ] = 0;
 19a:	000a07a3          	sb	zero,15(s4)
            if (stat(buf, &st) < 0)
 19e:	f8840593          	addi	a1,s0,-120
 1a2:	d8840513          	addi	a0,s0,-632
 1a6:	00000097          	auipc	ra,0x0
 1aa:	1dc080e7          	jalr	476(ra) # 382 <stat>
 1ae:	04054063          	bltz	a0,1ee <search+0x1ee>
            switch (st.type)
 1b2:	f9041783          	lh	a5,-112(s0)
 1b6:	0007871b          	sext.w	a4,a5
 1ba:	05870563          	beq	a4,s8,204 <search+0x204>
 1be:	87ba                	mv	a5,a4
 1c0:	4709                	li	a4,2
 1c2:	f8e796e3          	bne	a5,a4,14e <search+0x14e>
                if (!strcmp(de.name, name))
 1c6:	85ce                	mv	a1,s3
 1c8:	fa240513          	addi	a0,s0,-94
 1cc:	00000097          	auipc	ra,0x0
 1d0:	0a6080e7          	jalr	166(ra) # 272 <strcmp>
 1d4:	fd2d                	bnez	a0,14e <search+0x14e>
                    printf("%s\n", buf, path);
 1d6:	864a                	mv	a2,s2
 1d8:	d8840593          	addi	a1,s0,-632
 1dc:	00001517          	auipc	a0,0x1
 1e0:	89c50513          	addi	a0,a0,-1892 # a78 <malloc+0x184>
 1e4:	00000097          	auipc	ra,0x0
 1e8:	658080e7          	jalr	1624(ra) # 83c <printf>
 1ec:	b78d                	j	14e <search+0x14e>
                printf("find: cannot stat %s", buf);
 1ee:	d8840593          	addi	a1,s0,-632
 1f2:	00001517          	auipc	a0,0x1
 1f6:	86e50513          	addi	a0,a0,-1938 # a60 <malloc+0x16c>
 1fa:	00000097          	auipc	ra,0x0
 1fe:	642080e7          	jalr	1602(ra) # 83c <printf>
                continue;
 202:	b7b1                	j	14e <search+0x14e>
                search(buf, name);
 204:	85ce                	mv	a1,s3
 206:	d8840513          	addi	a0,s0,-632
 20a:	00000097          	auipc	ra,0x0
 20e:	df6080e7          	jalr	-522(ra) # 0 <search>
                break;
 212:	bf35                	j	14e <search+0x14e>

0000000000000214 <main>:
 
int main(int argc, char *argv[])
{
 214:	1141                	addi	sp,sp,-16
 216:	e406                	sd	ra,8(sp)
 218:	e022                	sd	s0,0(sp)
 21a:	0800                	addi	s0,sp,16
    if (argc < 3)
 21c:	4709                	li	a4,2
 21e:	02a74063          	blt	a4,a0,23e <main+0x2a>
    {
        fprintf(2, "usage: find rootpath filename.\n");
 222:	00001597          	auipc	a1,0x1
 226:	85e58593          	addi	a1,a1,-1954 # a80 <malloc+0x18c>
 22a:	4509                	li	a0,2
 22c:	00000097          	auipc	ra,0x0
 230:	5e2080e7          	jalr	1506(ra) # 80e <fprintf>
        exit(1);
 234:	4505                	li	a0,1
 236:	00000097          	auipc	ra,0x0
 23a:	28c080e7          	jalr	652(ra) # 4c2 <exit>
 23e:	87ae                	mv	a5,a1
    }
 
    search(argv[1], argv[2]);
 240:	698c                	ld	a1,16(a1)
 242:	6788                	ld	a0,8(a5)
 244:	00000097          	auipc	ra,0x0
 248:	dbc080e7          	jalr	-580(ra) # 0 <search>
    exit(0);
 24c:	4501                	li	a0,0
 24e:	00000097          	auipc	ra,0x0
 252:	274080e7          	jalr	628(ra) # 4c2 <exit>

0000000000000256 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 256:	1141                	addi	sp,sp,-16
 258:	e422                	sd	s0,8(sp)
 25a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 25c:	87aa                	mv	a5,a0
 25e:	0585                	addi	a1,a1,1
 260:	0785                	addi	a5,a5,1
 262:	fff5c703          	lbu	a4,-1(a1)
 266:	fee78fa3          	sb	a4,-1(a5)
 26a:	fb75                	bnez	a4,25e <strcpy+0x8>
    ;
  return os;
}
 26c:	6422                	ld	s0,8(sp)
 26e:	0141                	addi	sp,sp,16
 270:	8082                	ret

0000000000000272 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 272:	1141                	addi	sp,sp,-16
 274:	e422                	sd	s0,8(sp)
 276:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 278:	00054783          	lbu	a5,0(a0)
 27c:	cb91                	beqz	a5,290 <strcmp+0x1e>
 27e:	0005c703          	lbu	a4,0(a1)
 282:	00f71763          	bne	a4,a5,290 <strcmp+0x1e>
    p++, q++;
 286:	0505                	addi	a0,a0,1
 288:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 28a:	00054783          	lbu	a5,0(a0)
 28e:	fbe5                	bnez	a5,27e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 290:	0005c503          	lbu	a0,0(a1)
}
 294:	40a7853b          	subw	a0,a5,a0
 298:	6422                	ld	s0,8(sp)
 29a:	0141                	addi	sp,sp,16
 29c:	8082                	ret

000000000000029e <strlen>:

uint
strlen(const char *s)
{
 29e:	1141                	addi	sp,sp,-16
 2a0:	e422                	sd	s0,8(sp)
 2a2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2a4:	00054783          	lbu	a5,0(a0)
 2a8:	cf91                	beqz	a5,2c4 <strlen+0x26>
 2aa:	0505                	addi	a0,a0,1
 2ac:	87aa                	mv	a5,a0
 2ae:	4685                	li	a3,1
 2b0:	9e89                	subw	a3,a3,a0
 2b2:	00f6853b          	addw	a0,a3,a5
 2b6:	0785                	addi	a5,a5,1
 2b8:	fff7c703          	lbu	a4,-1(a5)
 2bc:	fb7d                	bnez	a4,2b2 <strlen+0x14>
    ;
  return n;
}
 2be:	6422                	ld	s0,8(sp)
 2c0:	0141                	addi	sp,sp,16
 2c2:	8082                	ret
  for(n = 0; s[n]; n++)
 2c4:	4501                	li	a0,0
 2c6:	bfe5                	j	2be <strlen+0x20>

00000000000002c8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2c8:	1141                	addi	sp,sp,-16
 2ca:	e422                	sd	s0,8(sp)
 2cc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2ce:	ca19                	beqz	a2,2e4 <memset+0x1c>
 2d0:	87aa                	mv	a5,a0
 2d2:	1602                	slli	a2,a2,0x20
 2d4:	9201                	srli	a2,a2,0x20
 2d6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2da:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2de:	0785                	addi	a5,a5,1
 2e0:	fee79de3          	bne	a5,a4,2da <memset+0x12>
  }
  return dst;
}
 2e4:	6422                	ld	s0,8(sp)
 2e6:	0141                	addi	sp,sp,16
 2e8:	8082                	ret

00000000000002ea <strchr>:

char*
strchr(const char *s, char c)
{
 2ea:	1141                	addi	sp,sp,-16
 2ec:	e422                	sd	s0,8(sp)
 2ee:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2f0:	00054783          	lbu	a5,0(a0)
 2f4:	cb99                	beqz	a5,30a <strchr+0x20>
    if(*s == c)
 2f6:	00f58763          	beq	a1,a5,304 <strchr+0x1a>
  for(; *s; s++)
 2fa:	0505                	addi	a0,a0,1
 2fc:	00054783          	lbu	a5,0(a0)
 300:	fbfd                	bnez	a5,2f6 <strchr+0xc>
      return (char*)s;
  return 0;
 302:	4501                	li	a0,0
}
 304:	6422                	ld	s0,8(sp)
 306:	0141                	addi	sp,sp,16
 308:	8082                	ret
  return 0;
 30a:	4501                	li	a0,0
 30c:	bfe5                	j	304 <strchr+0x1a>

000000000000030e <gets>:

char*
gets(char *buf, int max)
{
 30e:	711d                	addi	sp,sp,-96
 310:	ec86                	sd	ra,88(sp)
 312:	e8a2                	sd	s0,80(sp)
 314:	e4a6                	sd	s1,72(sp)
 316:	e0ca                	sd	s2,64(sp)
 318:	fc4e                	sd	s3,56(sp)
 31a:	f852                	sd	s4,48(sp)
 31c:	f456                	sd	s5,40(sp)
 31e:	f05a                	sd	s6,32(sp)
 320:	ec5e                	sd	s7,24(sp)
 322:	1080                	addi	s0,sp,96
 324:	8baa                	mv	s7,a0
 326:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 328:	892a                	mv	s2,a0
 32a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 32c:	4aa9                	li	s5,10
 32e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 330:	89a6                	mv	s3,s1
 332:	2485                	addiw	s1,s1,1
 334:	0344d863          	bge	s1,s4,364 <gets+0x56>
    cc = read(0, &c, 1);
 338:	4605                	li	a2,1
 33a:	faf40593          	addi	a1,s0,-81
 33e:	4501                	li	a0,0
 340:	00000097          	auipc	ra,0x0
 344:	19a080e7          	jalr	410(ra) # 4da <read>
    if(cc < 1)
 348:	00a05e63          	blez	a0,364 <gets+0x56>
    buf[i++] = c;
 34c:	faf44783          	lbu	a5,-81(s0)
 350:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 354:	01578763          	beq	a5,s5,362 <gets+0x54>
 358:	0905                	addi	s2,s2,1
 35a:	fd679be3          	bne	a5,s6,330 <gets+0x22>
  for(i=0; i+1 < max; ){
 35e:	89a6                	mv	s3,s1
 360:	a011                	j	364 <gets+0x56>
 362:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 364:	99de                	add	s3,s3,s7
 366:	00098023          	sb	zero,0(s3)
  return buf;
}
 36a:	855e                	mv	a0,s7
 36c:	60e6                	ld	ra,88(sp)
 36e:	6446                	ld	s0,80(sp)
 370:	64a6                	ld	s1,72(sp)
 372:	6906                	ld	s2,64(sp)
 374:	79e2                	ld	s3,56(sp)
 376:	7a42                	ld	s4,48(sp)
 378:	7aa2                	ld	s5,40(sp)
 37a:	7b02                	ld	s6,32(sp)
 37c:	6be2                	ld	s7,24(sp)
 37e:	6125                	addi	sp,sp,96
 380:	8082                	ret

0000000000000382 <stat>:

int
stat(const char *n, struct stat *st)
{
 382:	1101                	addi	sp,sp,-32
 384:	ec06                	sd	ra,24(sp)
 386:	e822                	sd	s0,16(sp)
 388:	e426                	sd	s1,8(sp)
 38a:	e04a                	sd	s2,0(sp)
 38c:	1000                	addi	s0,sp,32
 38e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 390:	4581                	li	a1,0
 392:	00000097          	auipc	ra,0x0
 396:	170080e7          	jalr	368(ra) # 502 <open>
  if(fd < 0)
 39a:	02054563          	bltz	a0,3c4 <stat+0x42>
 39e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3a0:	85ca                	mv	a1,s2
 3a2:	00000097          	auipc	ra,0x0
 3a6:	178080e7          	jalr	376(ra) # 51a <fstat>
 3aa:	892a                	mv	s2,a0
  close(fd);
 3ac:	8526                	mv	a0,s1
 3ae:	00000097          	auipc	ra,0x0
 3b2:	13c080e7          	jalr	316(ra) # 4ea <close>
  return r;
}
 3b6:	854a                	mv	a0,s2
 3b8:	60e2                	ld	ra,24(sp)
 3ba:	6442                	ld	s0,16(sp)
 3bc:	64a2                	ld	s1,8(sp)
 3be:	6902                	ld	s2,0(sp)
 3c0:	6105                	addi	sp,sp,32
 3c2:	8082                	ret
    return -1;
 3c4:	597d                	li	s2,-1
 3c6:	bfc5                	j	3b6 <stat+0x34>

00000000000003c8 <atoi>:

int
atoi(const char *s)
{
 3c8:	1141                	addi	sp,sp,-16
 3ca:	e422                	sd	s0,8(sp)
 3cc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3ce:	00054683          	lbu	a3,0(a0)
 3d2:	fd06879b          	addiw	a5,a3,-48
 3d6:	0ff7f793          	zext.b	a5,a5
 3da:	4625                	li	a2,9
 3dc:	02f66863          	bltu	a2,a5,40c <atoi+0x44>
 3e0:	872a                	mv	a4,a0
  n = 0;
 3e2:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 3e4:	0705                	addi	a4,a4,1
 3e6:	0025179b          	slliw	a5,a0,0x2
 3ea:	9fa9                	addw	a5,a5,a0
 3ec:	0017979b          	slliw	a5,a5,0x1
 3f0:	9fb5                	addw	a5,a5,a3
 3f2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3f6:	00074683          	lbu	a3,0(a4)
 3fa:	fd06879b          	addiw	a5,a3,-48
 3fe:	0ff7f793          	zext.b	a5,a5
 402:	fef671e3          	bgeu	a2,a5,3e4 <atoi+0x1c>
  return n;
}
 406:	6422                	ld	s0,8(sp)
 408:	0141                	addi	sp,sp,16
 40a:	8082                	ret
  n = 0;
 40c:	4501                	li	a0,0
 40e:	bfe5                	j	406 <atoi+0x3e>

0000000000000410 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 410:	1141                	addi	sp,sp,-16
 412:	e422                	sd	s0,8(sp)
 414:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 416:	02b57463          	bgeu	a0,a1,43e <memmove+0x2e>
    while(n-- > 0)
 41a:	00c05f63          	blez	a2,438 <memmove+0x28>
 41e:	1602                	slli	a2,a2,0x20
 420:	9201                	srli	a2,a2,0x20
 422:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 426:	872a                	mv	a4,a0
      *dst++ = *src++;
 428:	0585                	addi	a1,a1,1
 42a:	0705                	addi	a4,a4,1
 42c:	fff5c683          	lbu	a3,-1(a1)
 430:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 434:	fee79ae3          	bne	a5,a4,428 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 438:	6422                	ld	s0,8(sp)
 43a:	0141                	addi	sp,sp,16
 43c:	8082                	ret
    dst += n;
 43e:	00c50733          	add	a4,a0,a2
    src += n;
 442:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 444:	fec05ae3          	blez	a2,438 <memmove+0x28>
 448:	fff6079b          	addiw	a5,a2,-1
 44c:	1782                	slli	a5,a5,0x20
 44e:	9381                	srli	a5,a5,0x20
 450:	fff7c793          	not	a5,a5
 454:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 456:	15fd                	addi	a1,a1,-1
 458:	177d                	addi	a4,a4,-1
 45a:	0005c683          	lbu	a3,0(a1)
 45e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 462:	fee79ae3          	bne	a5,a4,456 <memmove+0x46>
 466:	bfc9                	j	438 <memmove+0x28>

0000000000000468 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 468:	1141                	addi	sp,sp,-16
 46a:	e422                	sd	s0,8(sp)
 46c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 46e:	ca05                	beqz	a2,49e <memcmp+0x36>
 470:	fff6069b          	addiw	a3,a2,-1
 474:	1682                	slli	a3,a3,0x20
 476:	9281                	srli	a3,a3,0x20
 478:	0685                	addi	a3,a3,1
 47a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 47c:	00054783          	lbu	a5,0(a0)
 480:	0005c703          	lbu	a4,0(a1)
 484:	00e79863          	bne	a5,a4,494 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 488:	0505                	addi	a0,a0,1
    p2++;
 48a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 48c:	fed518e3          	bne	a0,a3,47c <memcmp+0x14>
  }
  return 0;
 490:	4501                	li	a0,0
 492:	a019                	j	498 <memcmp+0x30>
      return *p1 - *p2;
 494:	40e7853b          	subw	a0,a5,a4
}
 498:	6422                	ld	s0,8(sp)
 49a:	0141                	addi	sp,sp,16
 49c:	8082                	ret
  return 0;
 49e:	4501                	li	a0,0
 4a0:	bfe5                	j	498 <memcmp+0x30>

00000000000004a2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4a2:	1141                	addi	sp,sp,-16
 4a4:	e406                	sd	ra,8(sp)
 4a6:	e022                	sd	s0,0(sp)
 4a8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4aa:	00000097          	auipc	ra,0x0
 4ae:	f66080e7          	jalr	-154(ra) # 410 <memmove>
}
 4b2:	60a2                	ld	ra,8(sp)
 4b4:	6402                	ld	s0,0(sp)
 4b6:	0141                	addi	sp,sp,16
 4b8:	8082                	ret

00000000000004ba <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4ba:	4885                	li	a7,1
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4c2:	4889                	li	a7,2
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <wait>:
.global wait
wait:
 li a7, SYS_wait
 4ca:	488d                	li	a7,3
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4d2:	4891                	li	a7,4
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <read>:
.global read
read:
 li a7, SYS_read
 4da:	4895                	li	a7,5
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <write>:
.global write
write:
 li a7, SYS_write
 4e2:	48c1                	li	a7,16
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <close>:
.global close
close:
 li a7, SYS_close
 4ea:	48d5                	li	a7,21
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	8082                	ret

00000000000004f2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4f2:	4899                	li	a7,6
 ecall
 4f4:	00000073          	ecall
 ret
 4f8:	8082                	ret

00000000000004fa <exec>:
.global exec
exec:
 li a7, SYS_exec
 4fa:	489d                	li	a7,7
 ecall
 4fc:	00000073          	ecall
 ret
 500:	8082                	ret

0000000000000502 <open>:
.global open
open:
 li a7, SYS_open
 502:	48bd                	li	a7,15
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 50a:	48c5                	li	a7,17
 ecall
 50c:	00000073          	ecall
 ret
 510:	8082                	ret

0000000000000512 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 512:	48c9                	li	a7,18
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 51a:	48a1                	li	a7,8
 ecall
 51c:	00000073          	ecall
 ret
 520:	8082                	ret

0000000000000522 <link>:
.global link
link:
 li a7, SYS_link
 522:	48cd                	li	a7,19
 ecall
 524:	00000073          	ecall
 ret
 528:	8082                	ret

000000000000052a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 52a:	48d1                	li	a7,20
 ecall
 52c:	00000073          	ecall
 ret
 530:	8082                	ret

0000000000000532 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 532:	48a5                	li	a7,9
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <dup>:
.global dup
dup:
 li a7, SYS_dup
 53a:	48a9                	li	a7,10
 ecall
 53c:	00000073          	ecall
 ret
 540:	8082                	ret

0000000000000542 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 542:	48ad                	li	a7,11
 ecall
 544:	00000073          	ecall
 ret
 548:	8082                	ret

000000000000054a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 54a:	48b1                	li	a7,12
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 552:	48b5                	li	a7,13
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 55a:	48b9                	li	a7,14
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 562:	1101                	addi	sp,sp,-32
 564:	ec06                	sd	ra,24(sp)
 566:	e822                	sd	s0,16(sp)
 568:	1000                	addi	s0,sp,32
 56a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 56e:	4605                	li	a2,1
 570:	fef40593          	addi	a1,s0,-17
 574:	00000097          	auipc	ra,0x0
 578:	f6e080e7          	jalr	-146(ra) # 4e2 <write>
}
 57c:	60e2                	ld	ra,24(sp)
 57e:	6442                	ld	s0,16(sp)
 580:	6105                	addi	sp,sp,32
 582:	8082                	ret

0000000000000584 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 584:	7139                	addi	sp,sp,-64
 586:	fc06                	sd	ra,56(sp)
 588:	f822                	sd	s0,48(sp)
 58a:	f426                	sd	s1,40(sp)
 58c:	f04a                	sd	s2,32(sp)
 58e:	ec4e                	sd	s3,24(sp)
 590:	0080                	addi	s0,sp,64
 592:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 594:	c299                	beqz	a3,59a <printint+0x16>
 596:	0805c963          	bltz	a1,628 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 59a:	2581                	sext.w	a1,a1
  neg = 0;
 59c:	4881                	li	a7,0
 59e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5a2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5a4:	2601                	sext.w	a2,a2
 5a6:	00000517          	auipc	a0,0x0
 5aa:	55a50513          	addi	a0,a0,1370 # b00 <digits>
 5ae:	883a                	mv	a6,a4
 5b0:	2705                	addiw	a4,a4,1
 5b2:	02c5f7bb          	remuw	a5,a1,a2
 5b6:	1782                	slli	a5,a5,0x20
 5b8:	9381                	srli	a5,a5,0x20
 5ba:	97aa                	add	a5,a5,a0
 5bc:	0007c783          	lbu	a5,0(a5)
 5c0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5c4:	0005879b          	sext.w	a5,a1
 5c8:	02c5d5bb          	divuw	a1,a1,a2
 5cc:	0685                	addi	a3,a3,1
 5ce:	fec7f0e3          	bgeu	a5,a2,5ae <printint+0x2a>
  if(neg)
 5d2:	00088c63          	beqz	a7,5ea <printint+0x66>
    buf[i++] = '-';
 5d6:	fd070793          	addi	a5,a4,-48
 5da:	00878733          	add	a4,a5,s0
 5de:	02d00793          	li	a5,45
 5e2:	fef70823          	sb	a5,-16(a4)
 5e6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5ea:	02e05863          	blez	a4,61a <printint+0x96>
 5ee:	fc040793          	addi	a5,s0,-64
 5f2:	00e78933          	add	s2,a5,a4
 5f6:	fff78993          	addi	s3,a5,-1
 5fa:	99ba                	add	s3,s3,a4
 5fc:	377d                	addiw	a4,a4,-1
 5fe:	1702                	slli	a4,a4,0x20
 600:	9301                	srli	a4,a4,0x20
 602:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 606:	fff94583          	lbu	a1,-1(s2)
 60a:	8526                	mv	a0,s1
 60c:	00000097          	auipc	ra,0x0
 610:	f56080e7          	jalr	-170(ra) # 562 <putc>
  while(--i >= 0)
 614:	197d                	addi	s2,s2,-1
 616:	ff3918e3          	bne	s2,s3,606 <printint+0x82>
}
 61a:	70e2                	ld	ra,56(sp)
 61c:	7442                	ld	s0,48(sp)
 61e:	74a2                	ld	s1,40(sp)
 620:	7902                	ld	s2,32(sp)
 622:	69e2                	ld	s3,24(sp)
 624:	6121                	addi	sp,sp,64
 626:	8082                	ret
    x = -xx;
 628:	40b005bb          	negw	a1,a1
    neg = 1;
 62c:	4885                	li	a7,1
    x = -xx;
 62e:	bf85                	j	59e <printint+0x1a>

0000000000000630 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 630:	7119                	addi	sp,sp,-128
 632:	fc86                	sd	ra,120(sp)
 634:	f8a2                	sd	s0,112(sp)
 636:	f4a6                	sd	s1,104(sp)
 638:	f0ca                	sd	s2,96(sp)
 63a:	ecce                	sd	s3,88(sp)
 63c:	e8d2                	sd	s4,80(sp)
 63e:	e4d6                	sd	s5,72(sp)
 640:	e0da                	sd	s6,64(sp)
 642:	fc5e                	sd	s7,56(sp)
 644:	f862                	sd	s8,48(sp)
 646:	f466                	sd	s9,40(sp)
 648:	f06a                	sd	s10,32(sp)
 64a:	ec6e                	sd	s11,24(sp)
 64c:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 64e:	0005c903          	lbu	s2,0(a1)
 652:	18090f63          	beqz	s2,7f0 <vprintf+0x1c0>
 656:	8aaa                	mv	s5,a0
 658:	8b32                	mv	s6,a2
 65a:	00158493          	addi	s1,a1,1
  state = 0;
 65e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 660:	02500a13          	li	s4,37
 664:	4c55                	li	s8,21
 666:	00000c97          	auipc	s9,0x0
 66a:	442c8c93          	addi	s9,s9,1090 # aa8 <malloc+0x1b4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 66e:	02800d93          	li	s11,40
  putc(fd, 'x');
 672:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 674:	00000b97          	auipc	s7,0x0
 678:	48cb8b93          	addi	s7,s7,1164 # b00 <digits>
 67c:	a839                	j	69a <vprintf+0x6a>
        putc(fd, c);
 67e:	85ca                	mv	a1,s2
 680:	8556                	mv	a0,s5
 682:	00000097          	auipc	ra,0x0
 686:	ee0080e7          	jalr	-288(ra) # 562 <putc>
 68a:	a019                	j	690 <vprintf+0x60>
    } else if(state == '%'){
 68c:	01498d63          	beq	s3,s4,6a6 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 690:	0485                	addi	s1,s1,1
 692:	fff4c903          	lbu	s2,-1(s1)
 696:	14090d63          	beqz	s2,7f0 <vprintf+0x1c0>
    if(state == 0){
 69a:	fe0999e3          	bnez	s3,68c <vprintf+0x5c>
      if(c == '%'){
 69e:	ff4910e3          	bne	s2,s4,67e <vprintf+0x4e>
        state = '%';
 6a2:	89d2                	mv	s3,s4
 6a4:	b7f5                	j	690 <vprintf+0x60>
      if(c == 'd'){
 6a6:	11490c63          	beq	s2,s4,7be <vprintf+0x18e>
 6aa:	f9d9079b          	addiw	a5,s2,-99
 6ae:	0ff7f793          	zext.b	a5,a5
 6b2:	10fc6e63          	bltu	s8,a5,7ce <vprintf+0x19e>
 6b6:	f9d9079b          	addiw	a5,s2,-99
 6ba:	0ff7f713          	zext.b	a4,a5
 6be:	10ec6863          	bltu	s8,a4,7ce <vprintf+0x19e>
 6c2:	00271793          	slli	a5,a4,0x2
 6c6:	97e6                	add	a5,a5,s9
 6c8:	439c                	lw	a5,0(a5)
 6ca:	97e6                	add	a5,a5,s9
 6cc:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 6ce:	008b0913          	addi	s2,s6,8
 6d2:	4685                	li	a3,1
 6d4:	4629                	li	a2,10
 6d6:	000b2583          	lw	a1,0(s6)
 6da:	8556                	mv	a0,s5
 6dc:	00000097          	auipc	ra,0x0
 6e0:	ea8080e7          	jalr	-344(ra) # 584 <printint>
 6e4:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6e6:	4981                	li	s3,0
 6e8:	b765                	j	690 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ea:	008b0913          	addi	s2,s6,8
 6ee:	4681                	li	a3,0
 6f0:	4629                	li	a2,10
 6f2:	000b2583          	lw	a1,0(s6)
 6f6:	8556                	mv	a0,s5
 6f8:	00000097          	auipc	ra,0x0
 6fc:	e8c080e7          	jalr	-372(ra) # 584 <printint>
 700:	8b4a                	mv	s6,s2
      state = 0;
 702:	4981                	li	s3,0
 704:	b771                	j	690 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 706:	008b0913          	addi	s2,s6,8
 70a:	4681                	li	a3,0
 70c:	866a                	mv	a2,s10
 70e:	000b2583          	lw	a1,0(s6)
 712:	8556                	mv	a0,s5
 714:	00000097          	auipc	ra,0x0
 718:	e70080e7          	jalr	-400(ra) # 584 <printint>
 71c:	8b4a                	mv	s6,s2
      state = 0;
 71e:	4981                	li	s3,0
 720:	bf85                	j	690 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 722:	008b0793          	addi	a5,s6,8
 726:	f8f43423          	sd	a5,-120(s0)
 72a:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 72e:	03000593          	li	a1,48
 732:	8556                	mv	a0,s5
 734:	00000097          	auipc	ra,0x0
 738:	e2e080e7          	jalr	-466(ra) # 562 <putc>
  putc(fd, 'x');
 73c:	07800593          	li	a1,120
 740:	8556                	mv	a0,s5
 742:	00000097          	auipc	ra,0x0
 746:	e20080e7          	jalr	-480(ra) # 562 <putc>
 74a:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 74c:	03c9d793          	srli	a5,s3,0x3c
 750:	97de                	add	a5,a5,s7
 752:	0007c583          	lbu	a1,0(a5)
 756:	8556                	mv	a0,s5
 758:	00000097          	auipc	ra,0x0
 75c:	e0a080e7          	jalr	-502(ra) # 562 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 760:	0992                	slli	s3,s3,0x4
 762:	397d                	addiw	s2,s2,-1
 764:	fe0914e3          	bnez	s2,74c <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 768:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 76c:	4981                	li	s3,0
 76e:	b70d                	j	690 <vprintf+0x60>
        s = va_arg(ap, char*);
 770:	008b0913          	addi	s2,s6,8
 774:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 778:	02098163          	beqz	s3,79a <vprintf+0x16a>
        while(*s != 0){
 77c:	0009c583          	lbu	a1,0(s3)
 780:	c5ad                	beqz	a1,7ea <vprintf+0x1ba>
          putc(fd, *s);
 782:	8556                	mv	a0,s5
 784:	00000097          	auipc	ra,0x0
 788:	dde080e7          	jalr	-546(ra) # 562 <putc>
          s++;
 78c:	0985                	addi	s3,s3,1
        while(*s != 0){
 78e:	0009c583          	lbu	a1,0(s3)
 792:	f9e5                	bnez	a1,782 <vprintf+0x152>
        s = va_arg(ap, char*);
 794:	8b4a                	mv	s6,s2
      state = 0;
 796:	4981                	li	s3,0
 798:	bde5                	j	690 <vprintf+0x60>
          s = "(null)";
 79a:	00000997          	auipc	s3,0x0
 79e:	30698993          	addi	s3,s3,774 # aa0 <malloc+0x1ac>
        while(*s != 0){
 7a2:	85ee                	mv	a1,s11
 7a4:	bff9                	j	782 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 7a6:	008b0913          	addi	s2,s6,8
 7aa:	000b4583          	lbu	a1,0(s6)
 7ae:	8556                	mv	a0,s5
 7b0:	00000097          	auipc	ra,0x0
 7b4:	db2080e7          	jalr	-590(ra) # 562 <putc>
 7b8:	8b4a                	mv	s6,s2
      state = 0;
 7ba:	4981                	li	s3,0
 7bc:	bdd1                	j	690 <vprintf+0x60>
        putc(fd, c);
 7be:	85d2                	mv	a1,s4
 7c0:	8556                	mv	a0,s5
 7c2:	00000097          	auipc	ra,0x0
 7c6:	da0080e7          	jalr	-608(ra) # 562 <putc>
      state = 0;
 7ca:	4981                	li	s3,0
 7cc:	b5d1                	j	690 <vprintf+0x60>
        putc(fd, '%');
 7ce:	85d2                	mv	a1,s4
 7d0:	8556                	mv	a0,s5
 7d2:	00000097          	auipc	ra,0x0
 7d6:	d90080e7          	jalr	-624(ra) # 562 <putc>
        putc(fd, c);
 7da:	85ca                	mv	a1,s2
 7dc:	8556                	mv	a0,s5
 7de:	00000097          	auipc	ra,0x0
 7e2:	d84080e7          	jalr	-636(ra) # 562 <putc>
      state = 0;
 7e6:	4981                	li	s3,0
 7e8:	b565                	j	690 <vprintf+0x60>
        s = va_arg(ap, char*);
 7ea:	8b4a                	mv	s6,s2
      state = 0;
 7ec:	4981                	li	s3,0
 7ee:	b54d                	j	690 <vprintf+0x60>
    }
  }
}
 7f0:	70e6                	ld	ra,120(sp)
 7f2:	7446                	ld	s0,112(sp)
 7f4:	74a6                	ld	s1,104(sp)
 7f6:	7906                	ld	s2,96(sp)
 7f8:	69e6                	ld	s3,88(sp)
 7fa:	6a46                	ld	s4,80(sp)
 7fc:	6aa6                	ld	s5,72(sp)
 7fe:	6b06                	ld	s6,64(sp)
 800:	7be2                	ld	s7,56(sp)
 802:	7c42                	ld	s8,48(sp)
 804:	7ca2                	ld	s9,40(sp)
 806:	7d02                	ld	s10,32(sp)
 808:	6de2                	ld	s11,24(sp)
 80a:	6109                	addi	sp,sp,128
 80c:	8082                	ret

000000000000080e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 80e:	715d                	addi	sp,sp,-80
 810:	ec06                	sd	ra,24(sp)
 812:	e822                	sd	s0,16(sp)
 814:	1000                	addi	s0,sp,32
 816:	e010                	sd	a2,0(s0)
 818:	e414                	sd	a3,8(s0)
 81a:	e818                	sd	a4,16(s0)
 81c:	ec1c                	sd	a5,24(s0)
 81e:	03043023          	sd	a6,32(s0)
 822:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 826:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 82a:	8622                	mv	a2,s0
 82c:	00000097          	auipc	ra,0x0
 830:	e04080e7          	jalr	-508(ra) # 630 <vprintf>
}
 834:	60e2                	ld	ra,24(sp)
 836:	6442                	ld	s0,16(sp)
 838:	6161                	addi	sp,sp,80
 83a:	8082                	ret

000000000000083c <printf>:

void
printf(const char *fmt, ...)
{
 83c:	711d                	addi	sp,sp,-96
 83e:	ec06                	sd	ra,24(sp)
 840:	e822                	sd	s0,16(sp)
 842:	1000                	addi	s0,sp,32
 844:	e40c                	sd	a1,8(s0)
 846:	e810                	sd	a2,16(s0)
 848:	ec14                	sd	a3,24(s0)
 84a:	f018                	sd	a4,32(s0)
 84c:	f41c                	sd	a5,40(s0)
 84e:	03043823          	sd	a6,48(s0)
 852:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 856:	00840613          	addi	a2,s0,8
 85a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 85e:	85aa                	mv	a1,a0
 860:	4505                	li	a0,1
 862:	00000097          	auipc	ra,0x0
 866:	dce080e7          	jalr	-562(ra) # 630 <vprintf>
}
 86a:	60e2                	ld	ra,24(sp)
 86c:	6442                	ld	s0,16(sp)
 86e:	6125                	addi	sp,sp,96
 870:	8082                	ret

0000000000000872 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 872:	1141                	addi	sp,sp,-16
 874:	e422                	sd	s0,8(sp)
 876:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 878:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 87c:	00000797          	auipc	a5,0x0
 880:	29c7b783          	ld	a5,668(a5) # b18 <freep>
 884:	a02d                	j	8ae <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 886:	4618                	lw	a4,8(a2)
 888:	9f2d                	addw	a4,a4,a1
 88a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 88e:	6398                	ld	a4,0(a5)
 890:	6310                	ld	a2,0(a4)
 892:	a83d                	j	8d0 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 894:	ff852703          	lw	a4,-8(a0)
 898:	9f31                	addw	a4,a4,a2
 89a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 89c:	ff053683          	ld	a3,-16(a0)
 8a0:	a091                	j	8e4 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a2:	6398                	ld	a4,0(a5)
 8a4:	00e7e463          	bltu	a5,a4,8ac <free+0x3a>
 8a8:	00e6ea63          	bltu	a3,a4,8bc <free+0x4a>
{
 8ac:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ae:	fed7fae3          	bgeu	a5,a3,8a2 <free+0x30>
 8b2:	6398                	ld	a4,0(a5)
 8b4:	00e6e463          	bltu	a3,a4,8bc <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8b8:	fee7eae3          	bltu	a5,a4,8ac <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8bc:	ff852583          	lw	a1,-8(a0)
 8c0:	6390                	ld	a2,0(a5)
 8c2:	02059813          	slli	a6,a1,0x20
 8c6:	01c85713          	srli	a4,a6,0x1c
 8ca:	9736                	add	a4,a4,a3
 8cc:	fae60de3          	beq	a2,a4,886 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8d0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8d4:	4790                	lw	a2,8(a5)
 8d6:	02061593          	slli	a1,a2,0x20
 8da:	01c5d713          	srli	a4,a1,0x1c
 8de:	973e                	add	a4,a4,a5
 8e0:	fae68ae3          	beq	a3,a4,894 <free+0x22>
    p->s.ptr = bp->s.ptr;
 8e4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8e6:	00000717          	auipc	a4,0x0
 8ea:	22f73923          	sd	a5,562(a4) # b18 <freep>
}
 8ee:	6422                	ld	s0,8(sp)
 8f0:	0141                	addi	sp,sp,16
 8f2:	8082                	ret

00000000000008f4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8f4:	7139                	addi	sp,sp,-64
 8f6:	fc06                	sd	ra,56(sp)
 8f8:	f822                	sd	s0,48(sp)
 8fa:	f426                	sd	s1,40(sp)
 8fc:	f04a                	sd	s2,32(sp)
 8fe:	ec4e                	sd	s3,24(sp)
 900:	e852                	sd	s4,16(sp)
 902:	e456                	sd	s5,8(sp)
 904:	e05a                	sd	s6,0(sp)
 906:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 908:	02051493          	slli	s1,a0,0x20
 90c:	9081                	srli	s1,s1,0x20
 90e:	04bd                	addi	s1,s1,15
 910:	8091                	srli	s1,s1,0x4
 912:	0014899b          	addiw	s3,s1,1
 916:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 918:	00000517          	auipc	a0,0x0
 91c:	20053503          	ld	a0,512(a0) # b18 <freep>
 920:	c515                	beqz	a0,94c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 922:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 924:	4798                	lw	a4,8(a5)
 926:	02977f63          	bgeu	a4,s1,964 <malloc+0x70>
 92a:	8a4e                	mv	s4,s3
 92c:	0009871b          	sext.w	a4,s3
 930:	6685                	lui	a3,0x1
 932:	00d77363          	bgeu	a4,a3,938 <malloc+0x44>
 936:	6a05                	lui	s4,0x1
 938:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 93c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 940:	00000917          	auipc	s2,0x0
 944:	1d890913          	addi	s2,s2,472 # b18 <freep>
  if(p == (char*)-1)
 948:	5afd                	li	s5,-1
 94a:	a895                	j	9be <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 94c:	00000797          	auipc	a5,0x0
 950:	1d478793          	addi	a5,a5,468 # b20 <base>
 954:	00000717          	auipc	a4,0x0
 958:	1cf73223          	sd	a5,452(a4) # b18 <freep>
 95c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 95e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 962:	b7e1                	j	92a <malloc+0x36>
      if(p->s.size == nunits)
 964:	02e48c63          	beq	s1,a4,99c <malloc+0xa8>
        p->s.size -= nunits;
 968:	4137073b          	subw	a4,a4,s3
 96c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 96e:	02071693          	slli	a3,a4,0x20
 972:	01c6d713          	srli	a4,a3,0x1c
 976:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 978:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 97c:	00000717          	auipc	a4,0x0
 980:	18a73e23          	sd	a0,412(a4) # b18 <freep>
      return (void*)(p + 1);
 984:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 988:	70e2                	ld	ra,56(sp)
 98a:	7442                	ld	s0,48(sp)
 98c:	74a2                	ld	s1,40(sp)
 98e:	7902                	ld	s2,32(sp)
 990:	69e2                	ld	s3,24(sp)
 992:	6a42                	ld	s4,16(sp)
 994:	6aa2                	ld	s5,8(sp)
 996:	6b02                	ld	s6,0(sp)
 998:	6121                	addi	sp,sp,64
 99a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 99c:	6398                	ld	a4,0(a5)
 99e:	e118                	sd	a4,0(a0)
 9a0:	bff1                	j	97c <malloc+0x88>
  hp->s.size = nu;
 9a2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9a6:	0541                	addi	a0,a0,16
 9a8:	00000097          	auipc	ra,0x0
 9ac:	eca080e7          	jalr	-310(ra) # 872 <free>
  return freep;
 9b0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9b4:	d971                	beqz	a0,988 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9b6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9b8:	4798                	lw	a4,8(a5)
 9ba:	fa9775e3          	bgeu	a4,s1,964 <malloc+0x70>
    if(p == freep)
 9be:	00093703          	ld	a4,0(s2)
 9c2:	853e                	mv	a0,a5
 9c4:	fef719e3          	bne	a4,a5,9b6 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 9c8:	8552                	mv	a0,s4
 9ca:	00000097          	auipc	ra,0x0
 9ce:	b80080e7          	jalr	-1152(ra) # 54a <sbrk>
  if(p == (char*)-1)
 9d2:	fd5518e3          	bne	a0,s5,9a2 <malloc+0xae>
        return 0;
 9d6:	4501                	li	a0,0
 9d8:	bf45                	j	988 <malloc+0x94>
