
user/_primes：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
 
#define READ 0
#define WRITE 1

int main()
{
   0:	7131                	addi	sp,sp,-192
   2:	fd06                	sd	ra,184(sp)
   4:	f922                	sd	s0,176(sp)
   6:	f526                	sd	s1,168(sp)
   8:	f14a                	sd	s2,160(sp)
   a:	ed4e                	sd	s3,152(sp)
   c:	e952                	sd	s4,144(sp)
   e:	0180                	addi	s0,sp,192
    int buff[34], p[2], size = 34;
    for (int i = 0; i < 34; ++i)
  10:	fd040693          	addi	a3,s0,-48
{
  14:	f4840793          	addi	a5,s0,-184
  18:	4709                	li	a4,2
        buff[i] = i + 2;
  1a:	c398                	sw	a4,0(a5)
    for (int i = 0; i < 34; ++i)
  1c:	2705                	addiw	a4,a4,1
  1e:	0791                	addi	a5,a5,4
  20:	fed79de3          	bne	a5,a3,1a <main+0x1a>
    pipe(p);
  24:	f4040513          	addi	a0,s0,-192
  28:	00000097          	auipc	ra,0x0
  2c:	398080e7          	jalr	920(ra) # 3c0 <pipe>
    write(p[WRITE], buff, size * sizeof(int));
  30:	08800613          	li	a2,136
  34:	f4840593          	addi	a1,s0,-184
  38:	f4442503          	lw	a0,-188(s0)
  3c:	00000097          	auipc	ra,0x0
  40:	394080e7          	jalr	916(ra) # 3d0 <write>
    close(p[WRITE]);
  44:	f4442503          	lw	a0,-188(s0)
  48:	00000097          	auipc	ra,0x0
  4c:	390080e7          	jalr	912(ra) # 3d8 <close>
    int buff[34], p[2], size = 34;
  50:	02200493          	li	s1,34
        if (fork() == 0)
        {
            read(p[READ], buff, size * sizeof(int));
            close(p[READ]);
            pipe(p); // create new child process
            printf("prime %d\n", buff[0]);
  54:	00001997          	auipc	s3,0x1
  58:	87498993          	addi	s3,s3,-1932 # 8c8 <malloc+0xe6>
  5c:	f4c40913          	addi	s2,s0,-180
  60:	a091                	j	a4 <main+0xa4>
  62:	0791                	addi	a5,a5,4
            int cnt = 0, prime = buff[0]; // use the first one as prime
            for (int i = 0; i < size; ++i)
  64:	00c78f63          	beq	a5,a2,82 <main+0x82>
                if (buff[i] % prime != 0)
  68:	4398                	lw	a4,0(a5)
  6a:	02b766bb          	remw	a3,a4,a1
  6e:	daf5                	beqz	a3,62 <main+0x62>
                    buff[cnt++] = buff[i]; // save the number that cannot be divided exactly
  70:	00249693          	slli	a3,s1,0x2
  74:	fd068693          	addi	a3,a3,-48
  78:	96a2                	add	a3,a3,s0
  7a:	f6e6ac23          	sw	a4,-136(a3)
  7e:	2485                	addiw	s1,s1,1
  80:	b7cd                	j	62 <main+0x62>
            size = cnt;
            write(p[WRITE], buff, cnt * sizeof(int));
  82:	0024961b          	slliw	a2,s1,0x2
  86:	f4840593          	addi	a1,s0,-184
  8a:	f4442503          	lw	a0,-188(s0)
  8e:	00000097          	auipc	ra,0x0
  92:	342080e7          	jalr	834(ra) # 3d0 <write>
            close(p[WRITE]);
  96:	f4442503          	lw	a0,-188(s0)
  9a:	00000097          	auipc	ra,0x0
  9e:	33e080e7          	jalr	830(ra) # 3d8 <close>
    while(size)
  a2:	ccc1                	beqz	s1,13a <main+0x13a>
        if (fork() == 0)
  a4:	00000097          	auipc	ra,0x0
  a8:	304080e7          	jalr	772(ra) # 3a8 <fork>
  ac:	8a2a                	mv	s4,a0
  ae:	ed29                	bnez	a0,108 <main+0x108>
            read(p[READ], buff, size * sizeof(int));
  b0:	0024961b          	slliw	a2,s1,0x2
  b4:	f4840593          	addi	a1,s0,-184
  b8:	f4042503          	lw	a0,-192(s0)
  bc:	00000097          	auipc	ra,0x0
  c0:	30c080e7          	jalr	780(ra) # 3c8 <read>
            close(p[READ]);
  c4:	f4042503          	lw	a0,-192(s0)
  c8:	00000097          	auipc	ra,0x0
  cc:	310080e7          	jalr	784(ra) # 3d8 <close>
            pipe(p); // create new child process
  d0:	f4040513          	addi	a0,s0,-192
  d4:	00000097          	auipc	ra,0x0
  d8:	2ec080e7          	jalr	748(ra) # 3c0 <pipe>
            printf("prime %d\n", buff[0]);
  dc:	f4842583          	lw	a1,-184(s0)
  e0:	854e                	mv	a0,s3
  e2:	00000097          	auipc	ra,0x0
  e6:	648080e7          	jalr	1608(ra) # 72a <printf>
            int cnt = 0, prime = buff[0]; // use the first one as prime
  ea:	f4842583          	lw	a1,-184(s0)
            for (int i = 0; i < size; ++i)
  ee:	02905763          	blez	s1,11c <main+0x11c>
  f2:	f4c40793          	addi	a5,s0,-180
  f6:	fff4861b          	addiw	a2,s1,-1
  fa:	02061713          	slli	a4,a2,0x20
  fe:	01e75613          	srli	a2,a4,0x1e
 102:	964a                	add	a2,a2,s2
            int cnt = 0, prime = buff[0]; // use the first one as prime
 104:	84d2                	mv	s1,s4
 106:	bfb9                	j	64 <main+0x64>
        }
        else
        {
            wait(0);
 108:	4501                	li	a0,0
 10a:	00000097          	auipc	ra,0x0
 10e:	2ae080e7          	jalr	686(ra) # 3b8 <wait>
            exit(0);
 112:	4501                	li	a0,0
 114:	00000097          	auipc	ra,0x0
 118:	29c080e7          	jalr	668(ra) # 3b0 <exit>
            write(p[WRITE], buff, cnt * sizeof(int));
 11c:	4601                	li	a2,0
 11e:	f4840593          	addi	a1,s0,-184
 122:	f4442503          	lw	a0,-188(s0)
 126:	00000097          	auipc	ra,0x0
 12a:	2aa080e7          	jalr	682(ra) # 3d0 <write>
            close(p[WRITE]);
 12e:	f4442503          	lw	a0,-188(s0)
 132:	00000097          	auipc	ra,0x0
 136:	2a6080e7          	jalr	678(ra) # 3d8 <close>
        }
    }
    exit(0);
 13a:	4501                	li	a0,0
 13c:	00000097          	auipc	ra,0x0
 140:	274080e7          	jalr	628(ra) # 3b0 <exit>

0000000000000144 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 144:	1141                	addi	sp,sp,-16
 146:	e422                	sd	s0,8(sp)
 148:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 14a:	87aa                	mv	a5,a0
 14c:	0585                	addi	a1,a1,1
 14e:	0785                	addi	a5,a5,1
 150:	fff5c703          	lbu	a4,-1(a1)
 154:	fee78fa3          	sb	a4,-1(a5)
 158:	fb75                	bnez	a4,14c <strcpy+0x8>
    ;
  return os;
}
 15a:	6422                	ld	s0,8(sp)
 15c:	0141                	addi	sp,sp,16
 15e:	8082                	ret

0000000000000160 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 160:	1141                	addi	sp,sp,-16
 162:	e422                	sd	s0,8(sp)
 164:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 166:	00054783          	lbu	a5,0(a0)
 16a:	cb91                	beqz	a5,17e <strcmp+0x1e>
 16c:	0005c703          	lbu	a4,0(a1)
 170:	00f71763          	bne	a4,a5,17e <strcmp+0x1e>
    p++, q++;
 174:	0505                	addi	a0,a0,1
 176:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 178:	00054783          	lbu	a5,0(a0)
 17c:	fbe5                	bnez	a5,16c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 17e:	0005c503          	lbu	a0,0(a1)
}
 182:	40a7853b          	subw	a0,a5,a0
 186:	6422                	ld	s0,8(sp)
 188:	0141                	addi	sp,sp,16
 18a:	8082                	ret

000000000000018c <strlen>:

uint
strlen(const char *s)
{
 18c:	1141                	addi	sp,sp,-16
 18e:	e422                	sd	s0,8(sp)
 190:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 192:	00054783          	lbu	a5,0(a0)
 196:	cf91                	beqz	a5,1b2 <strlen+0x26>
 198:	0505                	addi	a0,a0,1
 19a:	87aa                	mv	a5,a0
 19c:	4685                	li	a3,1
 19e:	9e89                	subw	a3,a3,a0
 1a0:	00f6853b          	addw	a0,a3,a5
 1a4:	0785                	addi	a5,a5,1
 1a6:	fff7c703          	lbu	a4,-1(a5)
 1aa:	fb7d                	bnez	a4,1a0 <strlen+0x14>
    ;
  return n;
}
 1ac:	6422                	ld	s0,8(sp)
 1ae:	0141                	addi	sp,sp,16
 1b0:	8082                	ret
  for(n = 0; s[n]; n++)
 1b2:	4501                	li	a0,0
 1b4:	bfe5                	j	1ac <strlen+0x20>

00000000000001b6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1b6:	1141                	addi	sp,sp,-16
 1b8:	e422                	sd	s0,8(sp)
 1ba:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1bc:	ca19                	beqz	a2,1d2 <memset+0x1c>
 1be:	87aa                	mv	a5,a0
 1c0:	1602                	slli	a2,a2,0x20
 1c2:	9201                	srli	a2,a2,0x20
 1c4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1c8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1cc:	0785                	addi	a5,a5,1
 1ce:	fee79de3          	bne	a5,a4,1c8 <memset+0x12>
  }
  return dst;
}
 1d2:	6422                	ld	s0,8(sp)
 1d4:	0141                	addi	sp,sp,16
 1d6:	8082                	ret

00000000000001d8 <strchr>:

char*
strchr(const char *s, char c)
{
 1d8:	1141                	addi	sp,sp,-16
 1da:	e422                	sd	s0,8(sp)
 1dc:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1de:	00054783          	lbu	a5,0(a0)
 1e2:	cb99                	beqz	a5,1f8 <strchr+0x20>
    if(*s == c)
 1e4:	00f58763          	beq	a1,a5,1f2 <strchr+0x1a>
  for(; *s; s++)
 1e8:	0505                	addi	a0,a0,1
 1ea:	00054783          	lbu	a5,0(a0)
 1ee:	fbfd                	bnez	a5,1e4 <strchr+0xc>
      return (char*)s;
  return 0;
 1f0:	4501                	li	a0,0
}
 1f2:	6422                	ld	s0,8(sp)
 1f4:	0141                	addi	sp,sp,16
 1f6:	8082                	ret
  return 0;
 1f8:	4501                	li	a0,0
 1fa:	bfe5                	j	1f2 <strchr+0x1a>

00000000000001fc <gets>:

char*
gets(char *buf, int max)
{
 1fc:	711d                	addi	sp,sp,-96
 1fe:	ec86                	sd	ra,88(sp)
 200:	e8a2                	sd	s0,80(sp)
 202:	e4a6                	sd	s1,72(sp)
 204:	e0ca                	sd	s2,64(sp)
 206:	fc4e                	sd	s3,56(sp)
 208:	f852                	sd	s4,48(sp)
 20a:	f456                	sd	s5,40(sp)
 20c:	f05a                	sd	s6,32(sp)
 20e:	ec5e                	sd	s7,24(sp)
 210:	1080                	addi	s0,sp,96
 212:	8baa                	mv	s7,a0
 214:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 216:	892a                	mv	s2,a0
 218:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 21a:	4aa9                	li	s5,10
 21c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 21e:	89a6                	mv	s3,s1
 220:	2485                	addiw	s1,s1,1
 222:	0344d863          	bge	s1,s4,252 <gets+0x56>
    cc = read(0, &c, 1);
 226:	4605                	li	a2,1
 228:	faf40593          	addi	a1,s0,-81
 22c:	4501                	li	a0,0
 22e:	00000097          	auipc	ra,0x0
 232:	19a080e7          	jalr	410(ra) # 3c8 <read>
    if(cc < 1)
 236:	00a05e63          	blez	a0,252 <gets+0x56>
    buf[i++] = c;
 23a:	faf44783          	lbu	a5,-81(s0)
 23e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 242:	01578763          	beq	a5,s5,250 <gets+0x54>
 246:	0905                	addi	s2,s2,1
 248:	fd679be3          	bne	a5,s6,21e <gets+0x22>
  for(i=0; i+1 < max; ){
 24c:	89a6                	mv	s3,s1
 24e:	a011                	j	252 <gets+0x56>
 250:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 252:	99de                	add	s3,s3,s7
 254:	00098023          	sb	zero,0(s3)
  return buf;
}
 258:	855e                	mv	a0,s7
 25a:	60e6                	ld	ra,88(sp)
 25c:	6446                	ld	s0,80(sp)
 25e:	64a6                	ld	s1,72(sp)
 260:	6906                	ld	s2,64(sp)
 262:	79e2                	ld	s3,56(sp)
 264:	7a42                	ld	s4,48(sp)
 266:	7aa2                	ld	s5,40(sp)
 268:	7b02                	ld	s6,32(sp)
 26a:	6be2                	ld	s7,24(sp)
 26c:	6125                	addi	sp,sp,96
 26e:	8082                	ret

0000000000000270 <stat>:

int
stat(const char *n, struct stat *st)
{
 270:	1101                	addi	sp,sp,-32
 272:	ec06                	sd	ra,24(sp)
 274:	e822                	sd	s0,16(sp)
 276:	e426                	sd	s1,8(sp)
 278:	e04a                	sd	s2,0(sp)
 27a:	1000                	addi	s0,sp,32
 27c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 27e:	4581                	li	a1,0
 280:	00000097          	auipc	ra,0x0
 284:	170080e7          	jalr	368(ra) # 3f0 <open>
  if(fd < 0)
 288:	02054563          	bltz	a0,2b2 <stat+0x42>
 28c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 28e:	85ca                	mv	a1,s2
 290:	00000097          	auipc	ra,0x0
 294:	178080e7          	jalr	376(ra) # 408 <fstat>
 298:	892a                	mv	s2,a0
  close(fd);
 29a:	8526                	mv	a0,s1
 29c:	00000097          	auipc	ra,0x0
 2a0:	13c080e7          	jalr	316(ra) # 3d8 <close>
  return r;
}
 2a4:	854a                	mv	a0,s2
 2a6:	60e2                	ld	ra,24(sp)
 2a8:	6442                	ld	s0,16(sp)
 2aa:	64a2                	ld	s1,8(sp)
 2ac:	6902                	ld	s2,0(sp)
 2ae:	6105                	addi	sp,sp,32
 2b0:	8082                	ret
    return -1;
 2b2:	597d                	li	s2,-1
 2b4:	bfc5                	j	2a4 <stat+0x34>

00000000000002b6 <atoi>:

int
atoi(const char *s)
{
 2b6:	1141                	addi	sp,sp,-16
 2b8:	e422                	sd	s0,8(sp)
 2ba:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2bc:	00054683          	lbu	a3,0(a0)
 2c0:	fd06879b          	addiw	a5,a3,-48
 2c4:	0ff7f793          	zext.b	a5,a5
 2c8:	4625                	li	a2,9
 2ca:	02f66863          	bltu	a2,a5,2fa <atoi+0x44>
 2ce:	872a                	mv	a4,a0
  n = 0;
 2d0:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2d2:	0705                	addi	a4,a4,1
 2d4:	0025179b          	slliw	a5,a0,0x2
 2d8:	9fa9                	addw	a5,a5,a0
 2da:	0017979b          	slliw	a5,a5,0x1
 2de:	9fb5                	addw	a5,a5,a3
 2e0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2e4:	00074683          	lbu	a3,0(a4)
 2e8:	fd06879b          	addiw	a5,a3,-48
 2ec:	0ff7f793          	zext.b	a5,a5
 2f0:	fef671e3          	bgeu	a2,a5,2d2 <atoi+0x1c>
  return n;
}
 2f4:	6422                	ld	s0,8(sp)
 2f6:	0141                	addi	sp,sp,16
 2f8:	8082                	ret
  n = 0;
 2fa:	4501                	li	a0,0
 2fc:	bfe5                	j	2f4 <atoi+0x3e>

00000000000002fe <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2fe:	1141                	addi	sp,sp,-16
 300:	e422                	sd	s0,8(sp)
 302:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 304:	02b57463          	bgeu	a0,a1,32c <memmove+0x2e>
    while(n-- > 0)
 308:	00c05f63          	blez	a2,326 <memmove+0x28>
 30c:	1602                	slli	a2,a2,0x20
 30e:	9201                	srli	a2,a2,0x20
 310:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 314:	872a                	mv	a4,a0
      *dst++ = *src++;
 316:	0585                	addi	a1,a1,1
 318:	0705                	addi	a4,a4,1
 31a:	fff5c683          	lbu	a3,-1(a1)
 31e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 322:	fee79ae3          	bne	a5,a4,316 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 326:	6422                	ld	s0,8(sp)
 328:	0141                	addi	sp,sp,16
 32a:	8082                	ret
    dst += n;
 32c:	00c50733          	add	a4,a0,a2
    src += n;
 330:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 332:	fec05ae3          	blez	a2,326 <memmove+0x28>
 336:	fff6079b          	addiw	a5,a2,-1
 33a:	1782                	slli	a5,a5,0x20
 33c:	9381                	srli	a5,a5,0x20
 33e:	fff7c793          	not	a5,a5
 342:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 344:	15fd                	addi	a1,a1,-1
 346:	177d                	addi	a4,a4,-1
 348:	0005c683          	lbu	a3,0(a1)
 34c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 350:	fee79ae3          	bne	a5,a4,344 <memmove+0x46>
 354:	bfc9                	j	326 <memmove+0x28>

0000000000000356 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 356:	1141                	addi	sp,sp,-16
 358:	e422                	sd	s0,8(sp)
 35a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 35c:	ca05                	beqz	a2,38c <memcmp+0x36>
 35e:	fff6069b          	addiw	a3,a2,-1
 362:	1682                	slli	a3,a3,0x20
 364:	9281                	srli	a3,a3,0x20
 366:	0685                	addi	a3,a3,1
 368:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 36a:	00054783          	lbu	a5,0(a0)
 36e:	0005c703          	lbu	a4,0(a1)
 372:	00e79863          	bne	a5,a4,382 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 376:	0505                	addi	a0,a0,1
    p2++;
 378:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 37a:	fed518e3          	bne	a0,a3,36a <memcmp+0x14>
  }
  return 0;
 37e:	4501                	li	a0,0
 380:	a019                	j	386 <memcmp+0x30>
      return *p1 - *p2;
 382:	40e7853b          	subw	a0,a5,a4
}
 386:	6422                	ld	s0,8(sp)
 388:	0141                	addi	sp,sp,16
 38a:	8082                	ret
  return 0;
 38c:	4501                	li	a0,0
 38e:	bfe5                	j	386 <memcmp+0x30>

0000000000000390 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 390:	1141                	addi	sp,sp,-16
 392:	e406                	sd	ra,8(sp)
 394:	e022                	sd	s0,0(sp)
 396:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 398:	00000097          	auipc	ra,0x0
 39c:	f66080e7          	jalr	-154(ra) # 2fe <memmove>
}
 3a0:	60a2                	ld	ra,8(sp)
 3a2:	6402                	ld	s0,0(sp)
 3a4:	0141                	addi	sp,sp,16
 3a6:	8082                	ret

00000000000003a8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3a8:	4885                	li	a7,1
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3b0:	4889                	li	a7,2
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3b8:	488d                	li	a7,3
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3c0:	4891                	li	a7,4
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <read>:
.global read
read:
 li a7, SYS_read
 3c8:	4895                	li	a7,5
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <write>:
.global write
write:
 li a7, SYS_write
 3d0:	48c1                	li	a7,16
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <close>:
.global close
close:
 li a7, SYS_close
 3d8:	48d5                	li	a7,21
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3e0:	4899                	li	a7,6
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3e8:	489d                	li	a7,7
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <open>:
.global open
open:
 li a7, SYS_open
 3f0:	48bd                	li	a7,15
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3f8:	48c5                	li	a7,17
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 400:	48c9                	li	a7,18
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 408:	48a1                	li	a7,8
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <link>:
.global link
link:
 li a7, SYS_link
 410:	48cd                	li	a7,19
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 418:	48d1                	li	a7,20
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 420:	48a5                	li	a7,9
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <dup>:
.global dup
dup:
 li a7, SYS_dup
 428:	48a9                	li	a7,10
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 430:	48ad                	li	a7,11
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 438:	48b1                	li	a7,12
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 440:	48b5                	li	a7,13
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 448:	48b9                	li	a7,14
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 450:	1101                	addi	sp,sp,-32
 452:	ec06                	sd	ra,24(sp)
 454:	e822                	sd	s0,16(sp)
 456:	1000                	addi	s0,sp,32
 458:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 45c:	4605                	li	a2,1
 45e:	fef40593          	addi	a1,s0,-17
 462:	00000097          	auipc	ra,0x0
 466:	f6e080e7          	jalr	-146(ra) # 3d0 <write>
}
 46a:	60e2                	ld	ra,24(sp)
 46c:	6442                	ld	s0,16(sp)
 46e:	6105                	addi	sp,sp,32
 470:	8082                	ret

0000000000000472 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 472:	7139                	addi	sp,sp,-64
 474:	fc06                	sd	ra,56(sp)
 476:	f822                	sd	s0,48(sp)
 478:	f426                	sd	s1,40(sp)
 47a:	f04a                	sd	s2,32(sp)
 47c:	ec4e                	sd	s3,24(sp)
 47e:	0080                	addi	s0,sp,64
 480:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 482:	c299                	beqz	a3,488 <printint+0x16>
 484:	0805c963          	bltz	a1,516 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 488:	2581                	sext.w	a1,a1
  neg = 0;
 48a:	4881                	li	a7,0
 48c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 490:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 492:	2601                	sext.w	a2,a2
 494:	00000517          	auipc	a0,0x0
 498:	4a450513          	addi	a0,a0,1188 # 938 <digits>
 49c:	883a                	mv	a6,a4
 49e:	2705                	addiw	a4,a4,1
 4a0:	02c5f7bb          	remuw	a5,a1,a2
 4a4:	1782                	slli	a5,a5,0x20
 4a6:	9381                	srli	a5,a5,0x20
 4a8:	97aa                	add	a5,a5,a0
 4aa:	0007c783          	lbu	a5,0(a5)
 4ae:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4b2:	0005879b          	sext.w	a5,a1
 4b6:	02c5d5bb          	divuw	a1,a1,a2
 4ba:	0685                	addi	a3,a3,1
 4bc:	fec7f0e3          	bgeu	a5,a2,49c <printint+0x2a>
  if(neg)
 4c0:	00088c63          	beqz	a7,4d8 <printint+0x66>
    buf[i++] = '-';
 4c4:	fd070793          	addi	a5,a4,-48
 4c8:	00878733          	add	a4,a5,s0
 4cc:	02d00793          	li	a5,45
 4d0:	fef70823          	sb	a5,-16(a4)
 4d4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4d8:	02e05863          	blez	a4,508 <printint+0x96>
 4dc:	fc040793          	addi	a5,s0,-64
 4e0:	00e78933          	add	s2,a5,a4
 4e4:	fff78993          	addi	s3,a5,-1
 4e8:	99ba                	add	s3,s3,a4
 4ea:	377d                	addiw	a4,a4,-1
 4ec:	1702                	slli	a4,a4,0x20
 4ee:	9301                	srli	a4,a4,0x20
 4f0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4f4:	fff94583          	lbu	a1,-1(s2)
 4f8:	8526                	mv	a0,s1
 4fa:	00000097          	auipc	ra,0x0
 4fe:	f56080e7          	jalr	-170(ra) # 450 <putc>
  while(--i >= 0)
 502:	197d                	addi	s2,s2,-1
 504:	ff3918e3          	bne	s2,s3,4f4 <printint+0x82>
}
 508:	70e2                	ld	ra,56(sp)
 50a:	7442                	ld	s0,48(sp)
 50c:	74a2                	ld	s1,40(sp)
 50e:	7902                	ld	s2,32(sp)
 510:	69e2                	ld	s3,24(sp)
 512:	6121                	addi	sp,sp,64
 514:	8082                	ret
    x = -xx;
 516:	40b005bb          	negw	a1,a1
    neg = 1;
 51a:	4885                	li	a7,1
    x = -xx;
 51c:	bf85                	j	48c <printint+0x1a>

000000000000051e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 51e:	7119                	addi	sp,sp,-128
 520:	fc86                	sd	ra,120(sp)
 522:	f8a2                	sd	s0,112(sp)
 524:	f4a6                	sd	s1,104(sp)
 526:	f0ca                	sd	s2,96(sp)
 528:	ecce                	sd	s3,88(sp)
 52a:	e8d2                	sd	s4,80(sp)
 52c:	e4d6                	sd	s5,72(sp)
 52e:	e0da                	sd	s6,64(sp)
 530:	fc5e                	sd	s7,56(sp)
 532:	f862                	sd	s8,48(sp)
 534:	f466                	sd	s9,40(sp)
 536:	f06a                	sd	s10,32(sp)
 538:	ec6e                	sd	s11,24(sp)
 53a:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 53c:	0005c903          	lbu	s2,0(a1)
 540:	18090f63          	beqz	s2,6de <vprintf+0x1c0>
 544:	8aaa                	mv	s5,a0
 546:	8b32                	mv	s6,a2
 548:	00158493          	addi	s1,a1,1
  state = 0;
 54c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 54e:	02500a13          	li	s4,37
 552:	4c55                	li	s8,21
 554:	00000c97          	auipc	s9,0x0
 558:	38cc8c93          	addi	s9,s9,908 # 8e0 <malloc+0xfe>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 55c:	02800d93          	li	s11,40
  putc(fd, 'x');
 560:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 562:	00000b97          	auipc	s7,0x0
 566:	3d6b8b93          	addi	s7,s7,982 # 938 <digits>
 56a:	a839                	j	588 <vprintf+0x6a>
        putc(fd, c);
 56c:	85ca                	mv	a1,s2
 56e:	8556                	mv	a0,s5
 570:	00000097          	auipc	ra,0x0
 574:	ee0080e7          	jalr	-288(ra) # 450 <putc>
 578:	a019                	j	57e <vprintf+0x60>
    } else if(state == '%'){
 57a:	01498d63          	beq	s3,s4,594 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 57e:	0485                	addi	s1,s1,1
 580:	fff4c903          	lbu	s2,-1(s1)
 584:	14090d63          	beqz	s2,6de <vprintf+0x1c0>
    if(state == 0){
 588:	fe0999e3          	bnez	s3,57a <vprintf+0x5c>
      if(c == '%'){
 58c:	ff4910e3          	bne	s2,s4,56c <vprintf+0x4e>
        state = '%';
 590:	89d2                	mv	s3,s4
 592:	b7f5                	j	57e <vprintf+0x60>
      if(c == 'd'){
 594:	11490c63          	beq	s2,s4,6ac <vprintf+0x18e>
 598:	f9d9079b          	addiw	a5,s2,-99
 59c:	0ff7f793          	zext.b	a5,a5
 5a0:	10fc6e63          	bltu	s8,a5,6bc <vprintf+0x19e>
 5a4:	f9d9079b          	addiw	a5,s2,-99
 5a8:	0ff7f713          	zext.b	a4,a5
 5ac:	10ec6863          	bltu	s8,a4,6bc <vprintf+0x19e>
 5b0:	00271793          	slli	a5,a4,0x2
 5b4:	97e6                	add	a5,a5,s9
 5b6:	439c                	lw	a5,0(a5)
 5b8:	97e6                	add	a5,a5,s9
 5ba:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5bc:	008b0913          	addi	s2,s6,8
 5c0:	4685                	li	a3,1
 5c2:	4629                	li	a2,10
 5c4:	000b2583          	lw	a1,0(s6)
 5c8:	8556                	mv	a0,s5
 5ca:	00000097          	auipc	ra,0x0
 5ce:	ea8080e7          	jalr	-344(ra) # 472 <printint>
 5d2:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5d4:	4981                	li	s3,0
 5d6:	b765                	j	57e <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d8:	008b0913          	addi	s2,s6,8
 5dc:	4681                	li	a3,0
 5de:	4629                	li	a2,10
 5e0:	000b2583          	lw	a1,0(s6)
 5e4:	8556                	mv	a0,s5
 5e6:	00000097          	auipc	ra,0x0
 5ea:	e8c080e7          	jalr	-372(ra) # 472 <printint>
 5ee:	8b4a                	mv	s6,s2
      state = 0;
 5f0:	4981                	li	s3,0
 5f2:	b771                	j	57e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 5f4:	008b0913          	addi	s2,s6,8
 5f8:	4681                	li	a3,0
 5fa:	866a                	mv	a2,s10
 5fc:	000b2583          	lw	a1,0(s6)
 600:	8556                	mv	a0,s5
 602:	00000097          	auipc	ra,0x0
 606:	e70080e7          	jalr	-400(ra) # 472 <printint>
 60a:	8b4a                	mv	s6,s2
      state = 0;
 60c:	4981                	li	s3,0
 60e:	bf85                	j	57e <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 610:	008b0793          	addi	a5,s6,8
 614:	f8f43423          	sd	a5,-120(s0)
 618:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 61c:	03000593          	li	a1,48
 620:	8556                	mv	a0,s5
 622:	00000097          	auipc	ra,0x0
 626:	e2e080e7          	jalr	-466(ra) # 450 <putc>
  putc(fd, 'x');
 62a:	07800593          	li	a1,120
 62e:	8556                	mv	a0,s5
 630:	00000097          	auipc	ra,0x0
 634:	e20080e7          	jalr	-480(ra) # 450 <putc>
 638:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 63a:	03c9d793          	srli	a5,s3,0x3c
 63e:	97de                	add	a5,a5,s7
 640:	0007c583          	lbu	a1,0(a5)
 644:	8556                	mv	a0,s5
 646:	00000097          	auipc	ra,0x0
 64a:	e0a080e7          	jalr	-502(ra) # 450 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 64e:	0992                	slli	s3,s3,0x4
 650:	397d                	addiw	s2,s2,-1
 652:	fe0914e3          	bnez	s2,63a <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 656:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 65a:	4981                	li	s3,0
 65c:	b70d                	j	57e <vprintf+0x60>
        s = va_arg(ap, char*);
 65e:	008b0913          	addi	s2,s6,8
 662:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 666:	02098163          	beqz	s3,688 <vprintf+0x16a>
        while(*s != 0){
 66a:	0009c583          	lbu	a1,0(s3)
 66e:	c5ad                	beqz	a1,6d8 <vprintf+0x1ba>
          putc(fd, *s);
 670:	8556                	mv	a0,s5
 672:	00000097          	auipc	ra,0x0
 676:	dde080e7          	jalr	-546(ra) # 450 <putc>
          s++;
 67a:	0985                	addi	s3,s3,1
        while(*s != 0){
 67c:	0009c583          	lbu	a1,0(s3)
 680:	f9e5                	bnez	a1,670 <vprintf+0x152>
        s = va_arg(ap, char*);
 682:	8b4a                	mv	s6,s2
      state = 0;
 684:	4981                	li	s3,0
 686:	bde5                	j	57e <vprintf+0x60>
          s = "(null)";
 688:	00000997          	auipc	s3,0x0
 68c:	25098993          	addi	s3,s3,592 # 8d8 <malloc+0xf6>
        while(*s != 0){
 690:	85ee                	mv	a1,s11
 692:	bff9                	j	670 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 694:	008b0913          	addi	s2,s6,8
 698:	000b4583          	lbu	a1,0(s6)
 69c:	8556                	mv	a0,s5
 69e:	00000097          	auipc	ra,0x0
 6a2:	db2080e7          	jalr	-590(ra) # 450 <putc>
 6a6:	8b4a                	mv	s6,s2
      state = 0;
 6a8:	4981                	li	s3,0
 6aa:	bdd1                	j	57e <vprintf+0x60>
        putc(fd, c);
 6ac:	85d2                	mv	a1,s4
 6ae:	8556                	mv	a0,s5
 6b0:	00000097          	auipc	ra,0x0
 6b4:	da0080e7          	jalr	-608(ra) # 450 <putc>
      state = 0;
 6b8:	4981                	li	s3,0
 6ba:	b5d1                	j	57e <vprintf+0x60>
        putc(fd, '%');
 6bc:	85d2                	mv	a1,s4
 6be:	8556                	mv	a0,s5
 6c0:	00000097          	auipc	ra,0x0
 6c4:	d90080e7          	jalr	-624(ra) # 450 <putc>
        putc(fd, c);
 6c8:	85ca                	mv	a1,s2
 6ca:	8556                	mv	a0,s5
 6cc:	00000097          	auipc	ra,0x0
 6d0:	d84080e7          	jalr	-636(ra) # 450 <putc>
      state = 0;
 6d4:	4981                	li	s3,0
 6d6:	b565                	j	57e <vprintf+0x60>
        s = va_arg(ap, char*);
 6d8:	8b4a                	mv	s6,s2
      state = 0;
 6da:	4981                	li	s3,0
 6dc:	b54d                	j	57e <vprintf+0x60>
    }
  }
}
 6de:	70e6                	ld	ra,120(sp)
 6e0:	7446                	ld	s0,112(sp)
 6e2:	74a6                	ld	s1,104(sp)
 6e4:	7906                	ld	s2,96(sp)
 6e6:	69e6                	ld	s3,88(sp)
 6e8:	6a46                	ld	s4,80(sp)
 6ea:	6aa6                	ld	s5,72(sp)
 6ec:	6b06                	ld	s6,64(sp)
 6ee:	7be2                	ld	s7,56(sp)
 6f0:	7c42                	ld	s8,48(sp)
 6f2:	7ca2                	ld	s9,40(sp)
 6f4:	7d02                	ld	s10,32(sp)
 6f6:	6de2                	ld	s11,24(sp)
 6f8:	6109                	addi	sp,sp,128
 6fa:	8082                	ret

00000000000006fc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6fc:	715d                	addi	sp,sp,-80
 6fe:	ec06                	sd	ra,24(sp)
 700:	e822                	sd	s0,16(sp)
 702:	1000                	addi	s0,sp,32
 704:	e010                	sd	a2,0(s0)
 706:	e414                	sd	a3,8(s0)
 708:	e818                	sd	a4,16(s0)
 70a:	ec1c                	sd	a5,24(s0)
 70c:	03043023          	sd	a6,32(s0)
 710:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 714:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 718:	8622                	mv	a2,s0
 71a:	00000097          	auipc	ra,0x0
 71e:	e04080e7          	jalr	-508(ra) # 51e <vprintf>
}
 722:	60e2                	ld	ra,24(sp)
 724:	6442                	ld	s0,16(sp)
 726:	6161                	addi	sp,sp,80
 728:	8082                	ret

000000000000072a <printf>:

void
printf(const char *fmt, ...)
{
 72a:	711d                	addi	sp,sp,-96
 72c:	ec06                	sd	ra,24(sp)
 72e:	e822                	sd	s0,16(sp)
 730:	1000                	addi	s0,sp,32
 732:	e40c                	sd	a1,8(s0)
 734:	e810                	sd	a2,16(s0)
 736:	ec14                	sd	a3,24(s0)
 738:	f018                	sd	a4,32(s0)
 73a:	f41c                	sd	a5,40(s0)
 73c:	03043823          	sd	a6,48(s0)
 740:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 744:	00840613          	addi	a2,s0,8
 748:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 74c:	85aa                	mv	a1,a0
 74e:	4505                	li	a0,1
 750:	00000097          	auipc	ra,0x0
 754:	dce080e7          	jalr	-562(ra) # 51e <vprintf>
}
 758:	60e2                	ld	ra,24(sp)
 75a:	6442                	ld	s0,16(sp)
 75c:	6125                	addi	sp,sp,96
 75e:	8082                	ret

0000000000000760 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 760:	1141                	addi	sp,sp,-16
 762:	e422                	sd	s0,8(sp)
 764:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 766:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 76a:	00000797          	auipc	a5,0x0
 76e:	1e67b783          	ld	a5,486(a5) # 950 <freep>
 772:	a02d                	j	79c <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 774:	4618                	lw	a4,8(a2)
 776:	9f2d                	addw	a4,a4,a1
 778:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 77c:	6398                	ld	a4,0(a5)
 77e:	6310                	ld	a2,0(a4)
 780:	a83d                	j	7be <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 782:	ff852703          	lw	a4,-8(a0)
 786:	9f31                	addw	a4,a4,a2
 788:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 78a:	ff053683          	ld	a3,-16(a0)
 78e:	a091                	j	7d2 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 790:	6398                	ld	a4,0(a5)
 792:	00e7e463          	bltu	a5,a4,79a <free+0x3a>
 796:	00e6ea63          	bltu	a3,a4,7aa <free+0x4a>
{
 79a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 79c:	fed7fae3          	bgeu	a5,a3,790 <free+0x30>
 7a0:	6398                	ld	a4,0(a5)
 7a2:	00e6e463          	bltu	a3,a4,7aa <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a6:	fee7eae3          	bltu	a5,a4,79a <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7aa:	ff852583          	lw	a1,-8(a0)
 7ae:	6390                	ld	a2,0(a5)
 7b0:	02059813          	slli	a6,a1,0x20
 7b4:	01c85713          	srli	a4,a6,0x1c
 7b8:	9736                	add	a4,a4,a3
 7ba:	fae60de3          	beq	a2,a4,774 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7be:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7c2:	4790                	lw	a2,8(a5)
 7c4:	02061593          	slli	a1,a2,0x20
 7c8:	01c5d713          	srli	a4,a1,0x1c
 7cc:	973e                	add	a4,a4,a5
 7ce:	fae68ae3          	beq	a3,a4,782 <free+0x22>
    p->s.ptr = bp->s.ptr;
 7d2:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7d4:	00000717          	auipc	a4,0x0
 7d8:	16f73e23          	sd	a5,380(a4) # 950 <freep>
}
 7dc:	6422                	ld	s0,8(sp)
 7de:	0141                	addi	sp,sp,16
 7e0:	8082                	ret

00000000000007e2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7e2:	7139                	addi	sp,sp,-64
 7e4:	fc06                	sd	ra,56(sp)
 7e6:	f822                	sd	s0,48(sp)
 7e8:	f426                	sd	s1,40(sp)
 7ea:	f04a                	sd	s2,32(sp)
 7ec:	ec4e                	sd	s3,24(sp)
 7ee:	e852                	sd	s4,16(sp)
 7f0:	e456                	sd	s5,8(sp)
 7f2:	e05a                	sd	s6,0(sp)
 7f4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7f6:	02051493          	slli	s1,a0,0x20
 7fa:	9081                	srli	s1,s1,0x20
 7fc:	04bd                	addi	s1,s1,15
 7fe:	8091                	srli	s1,s1,0x4
 800:	0014899b          	addiw	s3,s1,1
 804:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 806:	00000517          	auipc	a0,0x0
 80a:	14a53503          	ld	a0,330(a0) # 950 <freep>
 80e:	c515                	beqz	a0,83a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 810:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 812:	4798                	lw	a4,8(a5)
 814:	02977f63          	bgeu	a4,s1,852 <malloc+0x70>
 818:	8a4e                	mv	s4,s3
 81a:	0009871b          	sext.w	a4,s3
 81e:	6685                	lui	a3,0x1
 820:	00d77363          	bgeu	a4,a3,826 <malloc+0x44>
 824:	6a05                	lui	s4,0x1
 826:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 82a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 82e:	00000917          	auipc	s2,0x0
 832:	12290913          	addi	s2,s2,290 # 950 <freep>
  if(p == (char*)-1)
 836:	5afd                	li	s5,-1
 838:	a895                	j	8ac <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 83a:	00000797          	auipc	a5,0x0
 83e:	11e78793          	addi	a5,a5,286 # 958 <base>
 842:	00000717          	auipc	a4,0x0
 846:	10f73723          	sd	a5,270(a4) # 950 <freep>
 84a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 84c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 850:	b7e1                	j	818 <malloc+0x36>
      if(p->s.size == nunits)
 852:	02e48c63          	beq	s1,a4,88a <malloc+0xa8>
        p->s.size -= nunits;
 856:	4137073b          	subw	a4,a4,s3
 85a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 85c:	02071693          	slli	a3,a4,0x20
 860:	01c6d713          	srli	a4,a3,0x1c
 864:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 866:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 86a:	00000717          	auipc	a4,0x0
 86e:	0ea73323          	sd	a0,230(a4) # 950 <freep>
      return (void*)(p + 1);
 872:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 876:	70e2                	ld	ra,56(sp)
 878:	7442                	ld	s0,48(sp)
 87a:	74a2                	ld	s1,40(sp)
 87c:	7902                	ld	s2,32(sp)
 87e:	69e2                	ld	s3,24(sp)
 880:	6a42                	ld	s4,16(sp)
 882:	6aa2                	ld	s5,8(sp)
 884:	6b02                	ld	s6,0(sp)
 886:	6121                	addi	sp,sp,64
 888:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 88a:	6398                	ld	a4,0(a5)
 88c:	e118                	sd	a4,0(a0)
 88e:	bff1                	j	86a <malloc+0x88>
  hp->s.size = nu;
 890:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 894:	0541                	addi	a0,a0,16
 896:	00000097          	auipc	ra,0x0
 89a:	eca080e7          	jalr	-310(ra) # 760 <free>
  return freep;
 89e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8a2:	d971                	beqz	a0,876 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8a6:	4798                	lw	a4,8(a5)
 8a8:	fa9775e3          	bgeu	a4,s1,852 <malloc+0x70>
    if(p == freep)
 8ac:	00093703          	ld	a4,0(s2)
 8b0:	853e                	mv	a0,a5
 8b2:	fef719e3          	bne	a4,a5,8a4 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 8b6:	8552                	mv	a0,s4
 8b8:	00000097          	auipc	ra,0x0
 8bc:	b80080e7          	jalr	-1152(ra) # 438 <sbrk>
  if(p == (char*)-1)
 8c0:	fd5518e3          	bne	a0,s5,890 <malloc+0xae>
        return 0;
 8c4:	4501                	li	a0,0
 8c6:	bf45                	j	876 <malloc+0x94>
