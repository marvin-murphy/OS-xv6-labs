
user/_sysinfotest：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <sinfo>:
#include "kernel/sysinfo.h"
#include "user/user.h"


void
sinfo(struct sysinfo *info) {
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if (sysinfo(info) < 0) {
   8:	00000097          	auipc	ra,0x0
   c:	672080e7          	jalr	1650(ra) # 67a <sysinfo>
  10:	00054663          	bltz	a0,1c <sinfo+0x1c>
    printf("FAIL: sysinfo failed");
    exit(1);
  }
}
  14:	60a2                	ld	ra,8(sp)
  16:	6402                	ld	s0,0(sp)
  18:	0141                	addi	sp,sp,16
  1a:	8082                	ret
    printf("FAIL: sysinfo failed");
  1c:	00001517          	auipc	a0,0x1
  20:	ae450513          	addi	a0,a0,-1308 # b00 <malloc+0xec>
  24:	00001097          	auipc	ra,0x1
  28:	938080e7          	jalr	-1736(ra) # 95c <printf>
    exit(1);
  2c:	4505                	li	a0,1
  2e:	00000097          	auipc	ra,0x0
  32:	594080e7          	jalr	1428(ra) # 5c2 <exit>

0000000000000036 <countfree>:
//
// use sbrk() to count how many free physical memory pages there are.
//
int
countfree()
{
  36:	7139                	addi	sp,sp,-64
  38:	fc06                	sd	ra,56(sp)
  3a:	f822                	sd	s0,48(sp)
  3c:	f426                	sd	s1,40(sp)
  3e:	f04a                	sd	s2,32(sp)
  40:	ec4e                	sd	s3,24(sp)
  42:	e852                	sd	s4,16(sp)
  44:	0080                	addi	s0,sp,64
  uint64 sz0 = (uint64)sbrk(0);
  46:	4501                	li	a0,0
  48:	00000097          	auipc	ra,0x0
  4c:	602080e7          	jalr	1538(ra) # 64a <sbrk>
  50:	8a2a                	mv	s4,a0
  struct sysinfo info;
  int n = 0;
  52:	4481                	li	s1,0

  while(1){
    if((uint64)sbrk(PGSIZE) == 0xffffffffffffffff){
  54:	597d                	li	s2,-1
      break;
    }
    n += PGSIZE;
  56:	6985                	lui	s3,0x1
  58:	a019                	j	5e <countfree+0x28>
  5a:	009984bb          	addw	s1,s3,s1
    if((uint64)sbrk(PGSIZE) == 0xffffffffffffffff){
  5e:	6505                	lui	a0,0x1
  60:	00000097          	auipc	ra,0x0
  64:	5ea080e7          	jalr	1514(ra) # 64a <sbrk>
  68:	ff2519e3          	bne	a0,s2,5a <countfree+0x24>
  }
  sinfo(&info);
  6c:	fc040513          	addi	a0,s0,-64
  70:	00000097          	auipc	ra,0x0
  74:	f90080e7          	jalr	-112(ra) # 0 <sinfo>
  if (info.freemem != 0) {
  78:	fc043583          	ld	a1,-64(s0)
  7c:	e58d                	bnez	a1,a6 <countfree+0x70>
    printf("FAIL: there is no free mem, but sysinfo.freemem=%d\n",
      info.freemem);
    exit(1);
  }
  sbrk(-((uint64)sbrk(0) - sz0));
  7e:	4501                	li	a0,0
  80:	00000097          	auipc	ra,0x0
  84:	5ca080e7          	jalr	1482(ra) # 64a <sbrk>
  88:	40aa053b          	subw	a0,s4,a0
  8c:	00000097          	auipc	ra,0x0
  90:	5be080e7          	jalr	1470(ra) # 64a <sbrk>
  return n;
}
  94:	8526                	mv	a0,s1
  96:	70e2                	ld	ra,56(sp)
  98:	7442                	ld	s0,48(sp)
  9a:	74a2                	ld	s1,40(sp)
  9c:	7902                	ld	s2,32(sp)
  9e:	69e2                	ld	s3,24(sp)
  a0:	6a42                	ld	s4,16(sp)
  a2:	6121                	addi	sp,sp,64
  a4:	8082                	ret
    printf("FAIL: there is no free mem, but sysinfo.freemem=%d\n",
  a6:	00001517          	auipc	a0,0x1
  aa:	a7250513          	addi	a0,a0,-1422 # b18 <malloc+0x104>
  ae:	00001097          	auipc	ra,0x1
  b2:	8ae080e7          	jalr	-1874(ra) # 95c <printf>
    exit(1);
  b6:	4505                	li	a0,1
  b8:	00000097          	auipc	ra,0x0
  bc:	50a080e7          	jalr	1290(ra) # 5c2 <exit>

00000000000000c0 <testmem>:

void
testmem() {
  c0:	7179                	addi	sp,sp,-48
  c2:	f406                	sd	ra,40(sp)
  c4:	f022                	sd	s0,32(sp)
  c6:	ec26                	sd	s1,24(sp)
  c8:	e84a                	sd	s2,16(sp)
  ca:	1800                	addi	s0,sp,48
  struct sysinfo info;
  uint64 n = countfree();
  cc:	00000097          	auipc	ra,0x0
  d0:	f6a080e7          	jalr	-150(ra) # 36 <countfree>
  d4:	84aa                	mv	s1,a0
  
  sinfo(&info);
  d6:	fd040513          	addi	a0,s0,-48
  da:	00000097          	auipc	ra,0x0
  de:	f26080e7          	jalr	-218(ra) # 0 <sinfo>

  if (info.freemem!= n) {
  e2:	fd043583          	ld	a1,-48(s0)
  e6:	04959e63          	bne	a1,s1,142 <testmem+0x82>
    printf("FAIL: free mem %d (bytes) instead of %d\n", info.freemem, n);
    exit(1);
  }
  
  if((uint64)sbrk(PGSIZE) == 0xffffffffffffffff){
  ea:	6505                	lui	a0,0x1
  ec:	00000097          	auipc	ra,0x0
  f0:	55e080e7          	jalr	1374(ra) # 64a <sbrk>
  f4:	57fd                	li	a5,-1
  f6:	06f50463          	beq	a0,a5,15e <testmem+0x9e>
    printf("sbrk failed");
    exit(1);
  }

  sinfo(&info);
  fa:	fd040513          	addi	a0,s0,-48
  fe:	00000097          	auipc	ra,0x0
 102:	f02080e7          	jalr	-254(ra) # 0 <sinfo>
    
  if (info.freemem != n-PGSIZE) {
 106:	fd043603          	ld	a2,-48(s0)
 10a:	75fd                	lui	a1,0xfffff
 10c:	95a6                	add	a1,a1,s1
 10e:	06b61563          	bne	a2,a1,178 <testmem+0xb8>
    printf("FAIL: free mem %d (bytes) instead of %d\n", n-PGSIZE, info.freemem);
    exit(1);
  }
  
  if((uint64)sbrk(-PGSIZE) == 0xffffffffffffffff){
 112:	757d                	lui	a0,0xfffff
 114:	00000097          	auipc	ra,0x0
 118:	536080e7          	jalr	1334(ra) # 64a <sbrk>
 11c:	57fd                	li	a5,-1
 11e:	06f50a63          	beq	a0,a5,192 <testmem+0xd2>
    printf("sbrk failed");
    exit(1);
  }

  sinfo(&info);
 122:	fd040513          	addi	a0,s0,-48
 126:	00000097          	auipc	ra,0x0
 12a:	eda080e7          	jalr	-294(ra) # 0 <sinfo>
    
  if (info.freemem != n) {
 12e:	fd043603          	ld	a2,-48(s0)
 132:	06961d63          	bne	a2,s1,1ac <testmem+0xec>
    printf("FAIL: free mem %d (bytes) instead of %d\n", n, info.freemem);
    exit(1);
  }
}
 136:	70a2                	ld	ra,40(sp)
 138:	7402                	ld	s0,32(sp)
 13a:	64e2                	ld	s1,24(sp)
 13c:	6942                	ld	s2,16(sp)
 13e:	6145                	addi	sp,sp,48
 140:	8082                	ret
    printf("FAIL: free mem %d (bytes) instead of %d\n", info.freemem, n);
 142:	8626                	mv	a2,s1
 144:	00001517          	auipc	a0,0x1
 148:	a0c50513          	addi	a0,a0,-1524 # b50 <malloc+0x13c>
 14c:	00001097          	auipc	ra,0x1
 150:	810080e7          	jalr	-2032(ra) # 95c <printf>
    exit(1);
 154:	4505                	li	a0,1
 156:	00000097          	auipc	ra,0x0
 15a:	46c080e7          	jalr	1132(ra) # 5c2 <exit>
    printf("sbrk failed");
 15e:	00001517          	auipc	a0,0x1
 162:	a2250513          	addi	a0,a0,-1502 # b80 <malloc+0x16c>
 166:	00000097          	auipc	ra,0x0
 16a:	7f6080e7          	jalr	2038(ra) # 95c <printf>
    exit(1);
 16e:	4505                	li	a0,1
 170:	00000097          	auipc	ra,0x0
 174:	452080e7          	jalr	1106(ra) # 5c2 <exit>
    printf("FAIL: free mem %d (bytes) instead of %d\n", n-PGSIZE, info.freemem);
 178:	00001517          	auipc	a0,0x1
 17c:	9d850513          	addi	a0,a0,-1576 # b50 <malloc+0x13c>
 180:	00000097          	auipc	ra,0x0
 184:	7dc080e7          	jalr	2012(ra) # 95c <printf>
    exit(1);
 188:	4505                	li	a0,1
 18a:	00000097          	auipc	ra,0x0
 18e:	438080e7          	jalr	1080(ra) # 5c2 <exit>
    printf("sbrk failed");
 192:	00001517          	auipc	a0,0x1
 196:	9ee50513          	addi	a0,a0,-1554 # b80 <malloc+0x16c>
 19a:	00000097          	auipc	ra,0x0
 19e:	7c2080e7          	jalr	1986(ra) # 95c <printf>
    exit(1);
 1a2:	4505                	li	a0,1
 1a4:	00000097          	auipc	ra,0x0
 1a8:	41e080e7          	jalr	1054(ra) # 5c2 <exit>
    printf("FAIL: free mem %d (bytes) instead of %d\n", n, info.freemem);
 1ac:	85a6                	mv	a1,s1
 1ae:	00001517          	auipc	a0,0x1
 1b2:	9a250513          	addi	a0,a0,-1630 # b50 <malloc+0x13c>
 1b6:	00000097          	auipc	ra,0x0
 1ba:	7a6080e7          	jalr	1958(ra) # 95c <printf>
    exit(1);
 1be:	4505                	li	a0,1
 1c0:	00000097          	auipc	ra,0x0
 1c4:	402080e7          	jalr	1026(ra) # 5c2 <exit>

00000000000001c8 <testcall>:

void
testcall() {
 1c8:	1101                	addi	sp,sp,-32
 1ca:	ec06                	sd	ra,24(sp)
 1cc:	e822                	sd	s0,16(sp)
 1ce:	1000                	addi	s0,sp,32
  struct sysinfo info;
  
  if (sysinfo(&info) < 0) {
 1d0:	fe040513          	addi	a0,s0,-32
 1d4:	00000097          	auipc	ra,0x0
 1d8:	4a6080e7          	jalr	1190(ra) # 67a <sysinfo>
 1dc:	02054163          	bltz	a0,1fe <testcall+0x36>
    printf("FAIL: sysinfo failed\n");
    exit(1);
  }

  if (sysinfo((struct sysinfo *) 0xeaeb0b5b00002f5e) !=  0xffffffffffffffff) {
 1e0:	00001517          	auipc	a0,0x1
 1e4:	af053503          	ld	a0,-1296(a0) # cd0 <__SDATA_BEGIN__>
 1e8:	00000097          	auipc	ra,0x0
 1ec:	492080e7          	jalr	1170(ra) # 67a <sysinfo>
 1f0:	57fd                	li	a5,-1
 1f2:	02f51363          	bne	a0,a5,218 <testcall+0x50>
    printf("FAIL: sysinfo succeeded with bad argument\n");
    exit(1);
  }
}
 1f6:	60e2                	ld	ra,24(sp)
 1f8:	6442                	ld	s0,16(sp)
 1fa:	6105                	addi	sp,sp,32
 1fc:	8082                	ret
    printf("FAIL: sysinfo failed\n");
 1fe:	00001517          	auipc	a0,0x1
 202:	99250513          	addi	a0,a0,-1646 # b90 <malloc+0x17c>
 206:	00000097          	auipc	ra,0x0
 20a:	756080e7          	jalr	1878(ra) # 95c <printf>
    exit(1);
 20e:	4505                	li	a0,1
 210:	00000097          	auipc	ra,0x0
 214:	3b2080e7          	jalr	946(ra) # 5c2 <exit>
    printf("FAIL: sysinfo succeeded with bad argument\n");
 218:	00001517          	auipc	a0,0x1
 21c:	99050513          	addi	a0,a0,-1648 # ba8 <malloc+0x194>
 220:	00000097          	auipc	ra,0x0
 224:	73c080e7          	jalr	1852(ra) # 95c <printf>
    exit(1);
 228:	4505                	li	a0,1
 22a:	00000097          	auipc	ra,0x0
 22e:	398080e7          	jalr	920(ra) # 5c2 <exit>

0000000000000232 <testproc>:

void testproc() {
 232:	7139                	addi	sp,sp,-64
 234:	fc06                	sd	ra,56(sp)
 236:	f822                	sd	s0,48(sp)
 238:	f426                	sd	s1,40(sp)
 23a:	0080                	addi	s0,sp,64
  struct sysinfo info;
  uint64 nproc;
  int status;
  int pid;
  
  sinfo(&info);
 23c:	fd040513          	addi	a0,s0,-48
 240:	00000097          	auipc	ra,0x0
 244:	dc0080e7          	jalr	-576(ra) # 0 <sinfo>
  nproc = info.nproc;
 248:	fd843483          	ld	s1,-40(s0)

  pid = fork();
 24c:	00000097          	auipc	ra,0x0
 250:	36e080e7          	jalr	878(ra) # 5ba <fork>
  if(pid < 0){
 254:	02054c63          	bltz	a0,28c <testproc+0x5a>
    printf("sysinfotest: fork failed\n");
    exit(1);
  }
  if(pid == 0){
 258:	ed21                	bnez	a0,2b0 <testproc+0x7e>
    sinfo(&info);
 25a:	fd040513          	addi	a0,s0,-48
 25e:	00000097          	auipc	ra,0x0
 262:	da2080e7          	jalr	-606(ra) # 0 <sinfo>
    if(info.nproc != nproc+1) {
 266:	fd843583          	ld	a1,-40(s0)
 26a:	00148613          	addi	a2,s1,1
 26e:	02c58c63          	beq	a1,a2,2a6 <testproc+0x74>
      printf("sysinfotest: FAIL nproc is %d instead of %d\n", info.nproc, nproc+1);
 272:	00001517          	auipc	a0,0x1
 276:	98650513          	addi	a0,a0,-1658 # bf8 <malloc+0x1e4>
 27a:	00000097          	auipc	ra,0x0
 27e:	6e2080e7          	jalr	1762(ra) # 95c <printf>
      exit(1);
 282:	4505                	li	a0,1
 284:	00000097          	auipc	ra,0x0
 288:	33e080e7          	jalr	830(ra) # 5c2 <exit>
    printf("sysinfotest: fork failed\n");
 28c:	00001517          	auipc	a0,0x1
 290:	94c50513          	addi	a0,a0,-1716 # bd8 <malloc+0x1c4>
 294:	00000097          	auipc	ra,0x0
 298:	6c8080e7          	jalr	1736(ra) # 95c <printf>
    exit(1);
 29c:	4505                	li	a0,1
 29e:	00000097          	auipc	ra,0x0
 2a2:	324080e7          	jalr	804(ra) # 5c2 <exit>
    }
    exit(0);
 2a6:	4501                	li	a0,0
 2a8:	00000097          	auipc	ra,0x0
 2ac:	31a080e7          	jalr	794(ra) # 5c2 <exit>
  }
  wait(&status);
 2b0:	fcc40513          	addi	a0,s0,-52
 2b4:	00000097          	auipc	ra,0x0
 2b8:	316080e7          	jalr	790(ra) # 5ca <wait>
  sinfo(&info);
 2bc:	fd040513          	addi	a0,s0,-48
 2c0:	00000097          	auipc	ra,0x0
 2c4:	d40080e7          	jalr	-704(ra) # 0 <sinfo>
  if(info.nproc != nproc) {
 2c8:	fd843583          	ld	a1,-40(s0)
 2cc:	00959763          	bne	a1,s1,2da <testproc+0xa8>
      printf("sysinfotest: FAIL nproc is %d instead of %d\n", info.nproc, nproc);
      exit(1);
  }
}
 2d0:	70e2                	ld	ra,56(sp)
 2d2:	7442                	ld	s0,48(sp)
 2d4:	74a2                	ld	s1,40(sp)
 2d6:	6121                	addi	sp,sp,64
 2d8:	8082                	ret
      printf("sysinfotest: FAIL nproc is %d instead of %d\n", info.nproc, nproc);
 2da:	8626                	mv	a2,s1
 2dc:	00001517          	auipc	a0,0x1
 2e0:	91c50513          	addi	a0,a0,-1764 # bf8 <malloc+0x1e4>
 2e4:	00000097          	auipc	ra,0x0
 2e8:	678080e7          	jalr	1656(ra) # 95c <printf>
      exit(1);
 2ec:	4505                	li	a0,1
 2ee:	00000097          	auipc	ra,0x0
 2f2:	2d4080e7          	jalr	724(ra) # 5c2 <exit>

00000000000002f6 <main>:

int
main(int argc, char *argv[])
{
 2f6:	1141                	addi	sp,sp,-16
 2f8:	e406                	sd	ra,8(sp)
 2fa:	e022                	sd	s0,0(sp)
 2fc:	0800                	addi	s0,sp,16
  printf("sysinfotest: start\n");
 2fe:	00001517          	auipc	a0,0x1
 302:	92a50513          	addi	a0,a0,-1750 # c28 <malloc+0x214>
 306:	00000097          	auipc	ra,0x0
 30a:	656080e7          	jalr	1622(ra) # 95c <printf>
  testcall();
 30e:	00000097          	auipc	ra,0x0
 312:	eba080e7          	jalr	-326(ra) # 1c8 <testcall>
  testmem();
 316:	00000097          	auipc	ra,0x0
 31a:	daa080e7          	jalr	-598(ra) # c0 <testmem>
  testproc();
 31e:	00000097          	auipc	ra,0x0
 322:	f14080e7          	jalr	-236(ra) # 232 <testproc>
  printf("sysinfotest: OK\n");
 326:	00001517          	auipc	a0,0x1
 32a:	91a50513          	addi	a0,a0,-1766 # c40 <malloc+0x22c>
 32e:	00000097          	auipc	ra,0x0
 332:	62e080e7          	jalr	1582(ra) # 95c <printf>
  exit(0);
 336:	4501                	li	a0,0
 338:	00000097          	auipc	ra,0x0
 33c:	28a080e7          	jalr	650(ra) # 5c2 <exit>

0000000000000340 <strcpy>:



char*
strcpy(char *s, const char *t)
{
 340:	1141                	addi	sp,sp,-16
 342:	e422                	sd	s0,8(sp)
 344:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 346:	87aa                	mv	a5,a0
 348:	0585                	addi	a1,a1,1 # fffffffffffff001 <__global_pointer$+0xffffffffffffdb38>
 34a:	0785                	addi	a5,a5,1
 34c:	fff5c703          	lbu	a4,-1(a1)
 350:	fee78fa3          	sb	a4,-1(a5)
 354:	fb75                	bnez	a4,348 <strcpy+0x8>
    ;
  return os;
}
 356:	6422                	ld	s0,8(sp)
 358:	0141                	addi	sp,sp,16
 35a:	8082                	ret

000000000000035c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 35c:	1141                	addi	sp,sp,-16
 35e:	e422                	sd	s0,8(sp)
 360:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 362:	00054783          	lbu	a5,0(a0)
 366:	cb91                	beqz	a5,37a <strcmp+0x1e>
 368:	0005c703          	lbu	a4,0(a1)
 36c:	00f71763          	bne	a4,a5,37a <strcmp+0x1e>
    p++, q++;
 370:	0505                	addi	a0,a0,1
 372:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 374:	00054783          	lbu	a5,0(a0)
 378:	fbe5                	bnez	a5,368 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 37a:	0005c503          	lbu	a0,0(a1)
}
 37e:	40a7853b          	subw	a0,a5,a0
 382:	6422                	ld	s0,8(sp)
 384:	0141                	addi	sp,sp,16
 386:	8082                	ret

0000000000000388 <strlen>:

uint
strlen(const char *s)
{
 388:	1141                	addi	sp,sp,-16
 38a:	e422                	sd	s0,8(sp)
 38c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 38e:	00054783          	lbu	a5,0(a0)
 392:	cf91                	beqz	a5,3ae <strlen+0x26>
 394:	0505                	addi	a0,a0,1
 396:	87aa                	mv	a5,a0
 398:	4685                	li	a3,1
 39a:	9e89                	subw	a3,a3,a0
 39c:	00f6853b          	addw	a0,a3,a5
 3a0:	0785                	addi	a5,a5,1
 3a2:	fff7c703          	lbu	a4,-1(a5)
 3a6:	fb7d                	bnez	a4,39c <strlen+0x14>
    ;
  return n;
}
 3a8:	6422                	ld	s0,8(sp)
 3aa:	0141                	addi	sp,sp,16
 3ac:	8082                	ret
  for(n = 0; s[n]; n++)
 3ae:	4501                	li	a0,0
 3b0:	bfe5                	j	3a8 <strlen+0x20>

00000000000003b2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3b2:	1141                	addi	sp,sp,-16
 3b4:	e422                	sd	s0,8(sp)
 3b6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 3b8:	ca19                	beqz	a2,3ce <memset+0x1c>
 3ba:	87aa                	mv	a5,a0
 3bc:	1602                	slli	a2,a2,0x20
 3be:	9201                	srli	a2,a2,0x20
 3c0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 3c4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 3c8:	0785                	addi	a5,a5,1
 3ca:	fee79de3          	bne	a5,a4,3c4 <memset+0x12>
  }
  return dst;
}
 3ce:	6422                	ld	s0,8(sp)
 3d0:	0141                	addi	sp,sp,16
 3d2:	8082                	ret

00000000000003d4 <strchr>:

char*
strchr(const char *s, char c)
{
 3d4:	1141                	addi	sp,sp,-16
 3d6:	e422                	sd	s0,8(sp)
 3d8:	0800                	addi	s0,sp,16
  for(; *s; s++)
 3da:	00054783          	lbu	a5,0(a0)
 3de:	cb99                	beqz	a5,3f4 <strchr+0x20>
    if(*s == c)
 3e0:	00f58763          	beq	a1,a5,3ee <strchr+0x1a>
  for(; *s; s++)
 3e4:	0505                	addi	a0,a0,1
 3e6:	00054783          	lbu	a5,0(a0)
 3ea:	fbfd                	bnez	a5,3e0 <strchr+0xc>
      return (char*)s;
  return 0;
 3ec:	4501                	li	a0,0
}
 3ee:	6422                	ld	s0,8(sp)
 3f0:	0141                	addi	sp,sp,16
 3f2:	8082                	ret
  return 0;
 3f4:	4501                	li	a0,0
 3f6:	bfe5                	j	3ee <strchr+0x1a>

00000000000003f8 <gets>:

char*
gets(char *buf, int max)
{
 3f8:	711d                	addi	sp,sp,-96
 3fa:	ec86                	sd	ra,88(sp)
 3fc:	e8a2                	sd	s0,80(sp)
 3fe:	e4a6                	sd	s1,72(sp)
 400:	e0ca                	sd	s2,64(sp)
 402:	fc4e                	sd	s3,56(sp)
 404:	f852                	sd	s4,48(sp)
 406:	f456                	sd	s5,40(sp)
 408:	f05a                	sd	s6,32(sp)
 40a:	ec5e                	sd	s7,24(sp)
 40c:	1080                	addi	s0,sp,96
 40e:	8baa                	mv	s7,a0
 410:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 412:	892a                	mv	s2,a0
 414:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 416:	4aa9                	li	s5,10
 418:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 41a:	89a6                	mv	s3,s1
 41c:	2485                	addiw	s1,s1,1
 41e:	0344d863          	bge	s1,s4,44e <gets+0x56>
    cc = read(0, &c, 1);
 422:	4605                	li	a2,1
 424:	faf40593          	addi	a1,s0,-81
 428:	4501                	li	a0,0
 42a:	00000097          	auipc	ra,0x0
 42e:	1b0080e7          	jalr	432(ra) # 5da <read>
    if(cc < 1)
 432:	00a05e63          	blez	a0,44e <gets+0x56>
    buf[i++] = c;
 436:	faf44783          	lbu	a5,-81(s0)
 43a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 43e:	01578763          	beq	a5,s5,44c <gets+0x54>
 442:	0905                	addi	s2,s2,1
 444:	fd679be3          	bne	a5,s6,41a <gets+0x22>
  for(i=0; i+1 < max; ){
 448:	89a6                	mv	s3,s1
 44a:	a011                	j	44e <gets+0x56>
 44c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 44e:	99de                	add	s3,s3,s7
 450:	00098023          	sb	zero,0(s3) # 1000 <__BSS_END__+0x310>
  return buf;
}
 454:	855e                	mv	a0,s7
 456:	60e6                	ld	ra,88(sp)
 458:	6446                	ld	s0,80(sp)
 45a:	64a6                	ld	s1,72(sp)
 45c:	6906                	ld	s2,64(sp)
 45e:	79e2                	ld	s3,56(sp)
 460:	7a42                	ld	s4,48(sp)
 462:	7aa2                	ld	s5,40(sp)
 464:	7b02                	ld	s6,32(sp)
 466:	6be2                	ld	s7,24(sp)
 468:	6125                	addi	sp,sp,96
 46a:	8082                	ret

000000000000046c <stat>:

int
stat(const char *n, struct stat *st)
{
 46c:	1101                	addi	sp,sp,-32
 46e:	ec06                	sd	ra,24(sp)
 470:	e822                	sd	s0,16(sp)
 472:	e426                	sd	s1,8(sp)
 474:	e04a                	sd	s2,0(sp)
 476:	1000                	addi	s0,sp,32
 478:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 47a:	4581                	li	a1,0
 47c:	00000097          	auipc	ra,0x0
 480:	186080e7          	jalr	390(ra) # 602 <open>
  if(fd < 0)
 484:	02054563          	bltz	a0,4ae <stat+0x42>
 488:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 48a:	85ca                	mv	a1,s2
 48c:	00000097          	auipc	ra,0x0
 490:	18e080e7          	jalr	398(ra) # 61a <fstat>
 494:	892a                	mv	s2,a0
  close(fd);
 496:	8526                	mv	a0,s1
 498:	00000097          	auipc	ra,0x0
 49c:	152080e7          	jalr	338(ra) # 5ea <close>
  return r;
}
 4a0:	854a                	mv	a0,s2
 4a2:	60e2                	ld	ra,24(sp)
 4a4:	6442                	ld	s0,16(sp)
 4a6:	64a2                	ld	s1,8(sp)
 4a8:	6902                	ld	s2,0(sp)
 4aa:	6105                	addi	sp,sp,32
 4ac:	8082                	ret
    return -1;
 4ae:	597d                	li	s2,-1
 4b0:	bfc5                	j	4a0 <stat+0x34>

00000000000004b2 <atoi>:

int
atoi(const char *s)
{
 4b2:	1141                	addi	sp,sp,-16
 4b4:	e422                	sd	s0,8(sp)
 4b6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4b8:	00054683          	lbu	a3,0(a0)
 4bc:	fd06879b          	addiw	a5,a3,-48
 4c0:	0ff7f793          	zext.b	a5,a5
 4c4:	4625                	li	a2,9
 4c6:	02f66863          	bltu	a2,a5,4f6 <atoi+0x44>
 4ca:	872a                	mv	a4,a0
  n = 0;
 4cc:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 4ce:	0705                	addi	a4,a4,1
 4d0:	0025179b          	slliw	a5,a0,0x2
 4d4:	9fa9                	addw	a5,a5,a0
 4d6:	0017979b          	slliw	a5,a5,0x1
 4da:	9fb5                	addw	a5,a5,a3
 4dc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 4e0:	00074683          	lbu	a3,0(a4)
 4e4:	fd06879b          	addiw	a5,a3,-48
 4e8:	0ff7f793          	zext.b	a5,a5
 4ec:	fef671e3          	bgeu	a2,a5,4ce <atoi+0x1c>
  return n;
}
 4f0:	6422                	ld	s0,8(sp)
 4f2:	0141                	addi	sp,sp,16
 4f4:	8082                	ret
  n = 0;
 4f6:	4501                	li	a0,0
 4f8:	bfe5                	j	4f0 <atoi+0x3e>

00000000000004fa <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4fa:	1141                	addi	sp,sp,-16
 4fc:	e422                	sd	s0,8(sp)
 4fe:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 500:	02b57463          	bgeu	a0,a1,528 <memmove+0x2e>
    while(n-- > 0)
 504:	00c05f63          	blez	a2,522 <memmove+0x28>
 508:	1602                	slli	a2,a2,0x20
 50a:	9201                	srli	a2,a2,0x20
 50c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 510:	872a                	mv	a4,a0
      *dst++ = *src++;
 512:	0585                	addi	a1,a1,1
 514:	0705                	addi	a4,a4,1
 516:	fff5c683          	lbu	a3,-1(a1)
 51a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 51e:	fee79ae3          	bne	a5,a4,512 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 522:	6422                	ld	s0,8(sp)
 524:	0141                	addi	sp,sp,16
 526:	8082                	ret
    dst += n;
 528:	00c50733          	add	a4,a0,a2
    src += n;
 52c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 52e:	fec05ae3          	blez	a2,522 <memmove+0x28>
 532:	fff6079b          	addiw	a5,a2,-1
 536:	1782                	slli	a5,a5,0x20
 538:	9381                	srli	a5,a5,0x20
 53a:	fff7c793          	not	a5,a5
 53e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 540:	15fd                	addi	a1,a1,-1
 542:	177d                	addi	a4,a4,-1
 544:	0005c683          	lbu	a3,0(a1)
 548:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 54c:	fee79ae3          	bne	a5,a4,540 <memmove+0x46>
 550:	bfc9                	j	522 <memmove+0x28>

0000000000000552 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 552:	1141                	addi	sp,sp,-16
 554:	e422                	sd	s0,8(sp)
 556:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 558:	ca05                	beqz	a2,588 <memcmp+0x36>
 55a:	fff6069b          	addiw	a3,a2,-1
 55e:	1682                	slli	a3,a3,0x20
 560:	9281                	srli	a3,a3,0x20
 562:	0685                	addi	a3,a3,1
 564:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 566:	00054783          	lbu	a5,0(a0)
 56a:	0005c703          	lbu	a4,0(a1)
 56e:	00e79863          	bne	a5,a4,57e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 572:	0505                	addi	a0,a0,1
    p2++;
 574:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 576:	fed518e3          	bne	a0,a3,566 <memcmp+0x14>
  }
  return 0;
 57a:	4501                	li	a0,0
 57c:	a019                	j	582 <memcmp+0x30>
      return *p1 - *p2;
 57e:	40e7853b          	subw	a0,a5,a4
}
 582:	6422                	ld	s0,8(sp)
 584:	0141                	addi	sp,sp,16
 586:	8082                	ret
  return 0;
 588:	4501                	li	a0,0
 58a:	bfe5                	j	582 <memcmp+0x30>

000000000000058c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 58c:	1141                	addi	sp,sp,-16
 58e:	e406                	sd	ra,8(sp)
 590:	e022                	sd	s0,0(sp)
 592:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 594:	00000097          	auipc	ra,0x0
 598:	f66080e7          	jalr	-154(ra) # 4fa <memmove>
}
 59c:	60a2                	ld	ra,8(sp)
 59e:	6402                	ld	s0,0(sp)
 5a0:	0141                	addi	sp,sp,16
 5a2:	8082                	ret

00000000000005a4 <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
 5a4:	1141                	addi	sp,sp,-16
 5a6:	e422                	sd	s0,8(sp)
 5a8:	0800                	addi	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
 5aa:	040007b7          	lui	a5,0x4000
}
 5ae:	17f5                	addi	a5,a5,-3 # 3fffffd <__global_pointer$+0x3ffeb34>
 5b0:	07b2                	slli	a5,a5,0xc
 5b2:	4388                	lw	a0,0(a5)
 5b4:	6422                	ld	s0,8(sp)
 5b6:	0141                	addi	sp,sp,16
 5b8:	8082                	ret

00000000000005ba <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 5ba:	4885                	li	a7,1
 ecall
 5bc:	00000073          	ecall
 ret
 5c0:	8082                	ret

00000000000005c2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 5c2:	4889                	li	a7,2
 ecall
 5c4:	00000073          	ecall
 ret
 5c8:	8082                	ret

00000000000005ca <wait>:
.global wait
wait:
 li a7, SYS_wait
 5ca:	488d                	li	a7,3
 ecall
 5cc:	00000073          	ecall
 ret
 5d0:	8082                	ret

00000000000005d2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 5d2:	4891                	li	a7,4
 ecall
 5d4:	00000073          	ecall
 ret
 5d8:	8082                	ret

00000000000005da <read>:
.global read
read:
 li a7, SYS_read
 5da:	4895                	li	a7,5
 ecall
 5dc:	00000073          	ecall
 ret
 5e0:	8082                	ret

00000000000005e2 <write>:
.global write
write:
 li a7, SYS_write
 5e2:	48c1                	li	a7,16
 ecall
 5e4:	00000073          	ecall
 ret
 5e8:	8082                	ret

00000000000005ea <close>:
.global close
close:
 li a7, SYS_close
 5ea:	48d5                	li	a7,21
 ecall
 5ec:	00000073          	ecall
 ret
 5f0:	8082                	ret

00000000000005f2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 5f2:	4899                	li	a7,6
 ecall
 5f4:	00000073          	ecall
 ret
 5f8:	8082                	ret

00000000000005fa <exec>:
.global exec
exec:
 li a7, SYS_exec
 5fa:	489d                	li	a7,7
 ecall
 5fc:	00000073          	ecall
 ret
 600:	8082                	ret

0000000000000602 <open>:
.global open
open:
 li a7, SYS_open
 602:	48bd                	li	a7,15
 ecall
 604:	00000073          	ecall
 ret
 608:	8082                	ret

000000000000060a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 60a:	48c5                	li	a7,17
 ecall
 60c:	00000073          	ecall
 ret
 610:	8082                	ret

0000000000000612 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 612:	48c9                	li	a7,18
 ecall
 614:	00000073          	ecall
 ret
 618:	8082                	ret

000000000000061a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 61a:	48a1                	li	a7,8
 ecall
 61c:	00000073          	ecall
 ret
 620:	8082                	ret

0000000000000622 <link>:
.global link
link:
 li a7, SYS_link
 622:	48cd                	li	a7,19
 ecall
 624:	00000073          	ecall
 ret
 628:	8082                	ret

000000000000062a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 62a:	48d1                	li	a7,20
 ecall
 62c:	00000073          	ecall
 ret
 630:	8082                	ret

0000000000000632 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 632:	48a5                	li	a7,9
 ecall
 634:	00000073          	ecall
 ret
 638:	8082                	ret

000000000000063a <dup>:
.global dup
dup:
 li a7, SYS_dup
 63a:	48a9                	li	a7,10
 ecall
 63c:	00000073          	ecall
 ret
 640:	8082                	ret

0000000000000642 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 642:	48ad                	li	a7,11
 ecall
 644:	00000073          	ecall
 ret
 648:	8082                	ret

000000000000064a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 64a:	48b1                	li	a7,12
 ecall
 64c:	00000073          	ecall
 ret
 650:	8082                	ret

0000000000000652 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 652:	48b5                	li	a7,13
 ecall
 654:	00000073          	ecall
 ret
 658:	8082                	ret

000000000000065a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 65a:	48b9                	li	a7,14
 ecall
 65c:	00000073          	ecall
 ret
 660:	8082                	ret

0000000000000662 <connect>:
.global connect
connect:
 li a7, SYS_connect
 662:	48f5                	li	a7,29
 ecall
 664:	00000073          	ecall
 ret
 668:	8082                	ret

000000000000066a <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
 66a:	48f9                	li	a7,30
 ecall
 66c:	00000073          	ecall
 ret
 670:	8082                	ret

0000000000000672 <trace>:
.global trace
trace:
 li a7, SYS_trace
 672:	48d9                	li	a7,22
 ecall
 674:	00000073          	ecall
 ret
 678:	8082                	ret

000000000000067a <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 67a:	48dd                	li	a7,23
 ecall
 67c:	00000073          	ecall
 ret
 680:	8082                	ret

0000000000000682 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 682:	1101                	addi	sp,sp,-32
 684:	ec06                	sd	ra,24(sp)
 686:	e822                	sd	s0,16(sp)
 688:	1000                	addi	s0,sp,32
 68a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 68e:	4605                	li	a2,1
 690:	fef40593          	addi	a1,s0,-17
 694:	00000097          	auipc	ra,0x0
 698:	f4e080e7          	jalr	-178(ra) # 5e2 <write>
}
 69c:	60e2                	ld	ra,24(sp)
 69e:	6442                	ld	s0,16(sp)
 6a0:	6105                	addi	sp,sp,32
 6a2:	8082                	ret

00000000000006a4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6a4:	7139                	addi	sp,sp,-64
 6a6:	fc06                	sd	ra,56(sp)
 6a8:	f822                	sd	s0,48(sp)
 6aa:	f426                	sd	s1,40(sp)
 6ac:	f04a                	sd	s2,32(sp)
 6ae:	ec4e                	sd	s3,24(sp)
 6b0:	0080                	addi	s0,sp,64
 6b2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 6b4:	c299                	beqz	a3,6ba <printint+0x16>
 6b6:	0805c963          	bltz	a1,748 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 6ba:	2581                	sext.w	a1,a1
  neg = 0;
 6bc:	4881                	li	a7,0
 6be:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 6c2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 6c4:	2601                	sext.w	a2,a2
 6c6:	00000517          	auipc	a0,0x0
 6ca:	5f250513          	addi	a0,a0,1522 # cb8 <digits>
 6ce:	883a                	mv	a6,a4
 6d0:	2705                	addiw	a4,a4,1
 6d2:	02c5f7bb          	remuw	a5,a1,a2
 6d6:	1782                	slli	a5,a5,0x20
 6d8:	9381                	srli	a5,a5,0x20
 6da:	97aa                	add	a5,a5,a0
 6dc:	0007c783          	lbu	a5,0(a5)
 6e0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 6e4:	0005879b          	sext.w	a5,a1
 6e8:	02c5d5bb          	divuw	a1,a1,a2
 6ec:	0685                	addi	a3,a3,1
 6ee:	fec7f0e3          	bgeu	a5,a2,6ce <printint+0x2a>
  if(neg)
 6f2:	00088c63          	beqz	a7,70a <printint+0x66>
    buf[i++] = '-';
 6f6:	fd070793          	addi	a5,a4,-48
 6fa:	00878733          	add	a4,a5,s0
 6fe:	02d00793          	li	a5,45
 702:	fef70823          	sb	a5,-16(a4)
 706:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 70a:	02e05863          	blez	a4,73a <printint+0x96>
 70e:	fc040793          	addi	a5,s0,-64
 712:	00e78933          	add	s2,a5,a4
 716:	fff78993          	addi	s3,a5,-1
 71a:	99ba                	add	s3,s3,a4
 71c:	377d                	addiw	a4,a4,-1
 71e:	1702                	slli	a4,a4,0x20
 720:	9301                	srli	a4,a4,0x20
 722:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 726:	fff94583          	lbu	a1,-1(s2)
 72a:	8526                	mv	a0,s1
 72c:	00000097          	auipc	ra,0x0
 730:	f56080e7          	jalr	-170(ra) # 682 <putc>
  while(--i >= 0)
 734:	197d                	addi	s2,s2,-1
 736:	ff3918e3          	bne	s2,s3,726 <printint+0x82>
}
 73a:	70e2                	ld	ra,56(sp)
 73c:	7442                	ld	s0,48(sp)
 73e:	74a2                	ld	s1,40(sp)
 740:	7902                	ld	s2,32(sp)
 742:	69e2                	ld	s3,24(sp)
 744:	6121                	addi	sp,sp,64
 746:	8082                	ret
    x = -xx;
 748:	40b005bb          	negw	a1,a1
    neg = 1;
 74c:	4885                	li	a7,1
    x = -xx;
 74e:	bf85                	j	6be <printint+0x1a>

0000000000000750 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 750:	7119                	addi	sp,sp,-128
 752:	fc86                	sd	ra,120(sp)
 754:	f8a2                	sd	s0,112(sp)
 756:	f4a6                	sd	s1,104(sp)
 758:	f0ca                	sd	s2,96(sp)
 75a:	ecce                	sd	s3,88(sp)
 75c:	e8d2                	sd	s4,80(sp)
 75e:	e4d6                	sd	s5,72(sp)
 760:	e0da                	sd	s6,64(sp)
 762:	fc5e                	sd	s7,56(sp)
 764:	f862                	sd	s8,48(sp)
 766:	f466                	sd	s9,40(sp)
 768:	f06a                	sd	s10,32(sp)
 76a:	ec6e                	sd	s11,24(sp)
 76c:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 76e:	0005c903          	lbu	s2,0(a1)
 772:	18090f63          	beqz	s2,910 <vprintf+0x1c0>
 776:	8aaa                	mv	s5,a0
 778:	8b32                	mv	s6,a2
 77a:	00158493          	addi	s1,a1,1
  state = 0;
 77e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 780:	02500a13          	li	s4,37
 784:	4c55                	li	s8,21
 786:	00000c97          	auipc	s9,0x0
 78a:	4dac8c93          	addi	s9,s9,1242 # c60 <malloc+0x24c>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 78e:	02800d93          	li	s11,40
  putc(fd, 'x');
 792:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 794:	00000b97          	auipc	s7,0x0
 798:	524b8b93          	addi	s7,s7,1316 # cb8 <digits>
 79c:	a839                	j	7ba <vprintf+0x6a>
        putc(fd, c);
 79e:	85ca                	mv	a1,s2
 7a0:	8556                	mv	a0,s5
 7a2:	00000097          	auipc	ra,0x0
 7a6:	ee0080e7          	jalr	-288(ra) # 682 <putc>
 7aa:	a019                	j	7b0 <vprintf+0x60>
    } else if(state == '%'){
 7ac:	01498d63          	beq	s3,s4,7c6 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 7b0:	0485                	addi	s1,s1,1
 7b2:	fff4c903          	lbu	s2,-1(s1)
 7b6:	14090d63          	beqz	s2,910 <vprintf+0x1c0>
    if(state == 0){
 7ba:	fe0999e3          	bnez	s3,7ac <vprintf+0x5c>
      if(c == '%'){
 7be:	ff4910e3          	bne	s2,s4,79e <vprintf+0x4e>
        state = '%';
 7c2:	89d2                	mv	s3,s4
 7c4:	b7f5                	j	7b0 <vprintf+0x60>
      if(c == 'd'){
 7c6:	11490c63          	beq	s2,s4,8de <vprintf+0x18e>
 7ca:	f9d9079b          	addiw	a5,s2,-99
 7ce:	0ff7f793          	zext.b	a5,a5
 7d2:	10fc6e63          	bltu	s8,a5,8ee <vprintf+0x19e>
 7d6:	f9d9079b          	addiw	a5,s2,-99
 7da:	0ff7f713          	zext.b	a4,a5
 7de:	10ec6863          	bltu	s8,a4,8ee <vprintf+0x19e>
 7e2:	00271793          	slli	a5,a4,0x2
 7e6:	97e6                	add	a5,a5,s9
 7e8:	439c                	lw	a5,0(a5)
 7ea:	97e6                	add	a5,a5,s9
 7ec:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 7ee:	008b0913          	addi	s2,s6,8
 7f2:	4685                	li	a3,1
 7f4:	4629                	li	a2,10
 7f6:	000b2583          	lw	a1,0(s6)
 7fa:	8556                	mv	a0,s5
 7fc:	00000097          	auipc	ra,0x0
 800:	ea8080e7          	jalr	-344(ra) # 6a4 <printint>
 804:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 806:	4981                	li	s3,0
 808:	b765                	j	7b0 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 80a:	008b0913          	addi	s2,s6,8
 80e:	4681                	li	a3,0
 810:	4629                	li	a2,10
 812:	000b2583          	lw	a1,0(s6)
 816:	8556                	mv	a0,s5
 818:	00000097          	auipc	ra,0x0
 81c:	e8c080e7          	jalr	-372(ra) # 6a4 <printint>
 820:	8b4a                	mv	s6,s2
      state = 0;
 822:	4981                	li	s3,0
 824:	b771                	j	7b0 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 826:	008b0913          	addi	s2,s6,8
 82a:	4681                	li	a3,0
 82c:	866a                	mv	a2,s10
 82e:	000b2583          	lw	a1,0(s6)
 832:	8556                	mv	a0,s5
 834:	00000097          	auipc	ra,0x0
 838:	e70080e7          	jalr	-400(ra) # 6a4 <printint>
 83c:	8b4a                	mv	s6,s2
      state = 0;
 83e:	4981                	li	s3,0
 840:	bf85                	j	7b0 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 842:	008b0793          	addi	a5,s6,8
 846:	f8f43423          	sd	a5,-120(s0)
 84a:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 84e:	03000593          	li	a1,48
 852:	8556                	mv	a0,s5
 854:	00000097          	auipc	ra,0x0
 858:	e2e080e7          	jalr	-466(ra) # 682 <putc>
  putc(fd, 'x');
 85c:	07800593          	li	a1,120
 860:	8556                	mv	a0,s5
 862:	00000097          	auipc	ra,0x0
 866:	e20080e7          	jalr	-480(ra) # 682 <putc>
 86a:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 86c:	03c9d793          	srli	a5,s3,0x3c
 870:	97de                	add	a5,a5,s7
 872:	0007c583          	lbu	a1,0(a5)
 876:	8556                	mv	a0,s5
 878:	00000097          	auipc	ra,0x0
 87c:	e0a080e7          	jalr	-502(ra) # 682 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 880:	0992                	slli	s3,s3,0x4
 882:	397d                	addiw	s2,s2,-1
 884:	fe0914e3          	bnez	s2,86c <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 888:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 88c:	4981                	li	s3,0
 88e:	b70d                	j	7b0 <vprintf+0x60>
        s = va_arg(ap, char*);
 890:	008b0913          	addi	s2,s6,8
 894:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 898:	02098163          	beqz	s3,8ba <vprintf+0x16a>
        while(*s != 0){
 89c:	0009c583          	lbu	a1,0(s3)
 8a0:	c5ad                	beqz	a1,90a <vprintf+0x1ba>
          putc(fd, *s);
 8a2:	8556                	mv	a0,s5
 8a4:	00000097          	auipc	ra,0x0
 8a8:	dde080e7          	jalr	-546(ra) # 682 <putc>
          s++;
 8ac:	0985                	addi	s3,s3,1
        while(*s != 0){
 8ae:	0009c583          	lbu	a1,0(s3)
 8b2:	f9e5                	bnez	a1,8a2 <vprintf+0x152>
        s = va_arg(ap, char*);
 8b4:	8b4a                	mv	s6,s2
      state = 0;
 8b6:	4981                	li	s3,0
 8b8:	bde5                	j	7b0 <vprintf+0x60>
          s = "(null)";
 8ba:	00000997          	auipc	s3,0x0
 8be:	39e98993          	addi	s3,s3,926 # c58 <malloc+0x244>
        while(*s != 0){
 8c2:	85ee                	mv	a1,s11
 8c4:	bff9                	j	8a2 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 8c6:	008b0913          	addi	s2,s6,8
 8ca:	000b4583          	lbu	a1,0(s6)
 8ce:	8556                	mv	a0,s5
 8d0:	00000097          	auipc	ra,0x0
 8d4:	db2080e7          	jalr	-590(ra) # 682 <putc>
 8d8:	8b4a                	mv	s6,s2
      state = 0;
 8da:	4981                	li	s3,0
 8dc:	bdd1                	j	7b0 <vprintf+0x60>
        putc(fd, c);
 8de:	85d2                	mv	a1,s4
 8e0:	8556                	mv	a0,s5
 8e2:	00000097          	auipc	ra,0x0
 8e6:	da0080e7          	jalr	-608(ra) # 682 <putc>
      state = 0;
 8ea:	4981                	li	s3,0
 8ec:	b5d1                	j	7b0 <vprintf+0x60>
        putc(fd, '%');
 8ee:	85d2                	mv	a1,s4
 8f0:	8556                	mv	a0,s5
 8f2:	00000097          	auipc	ra,0x0
 8f6:	d90080e7          	jalr	-624(ra) # 682 <putc>
        putc(fd, c);
 8fa:	85ca                	mv	a1,s2
 8fc:	8556                	mv	a0,s5
 8fe:	00000097          	auipc	ra,0x0
 902:	d84080e7          	jalr	-636(ra) # 682 <putc>
      state = 0;
 906:	4981                	li	s3,0
 908:	b565                	j	7b0 <vprintf+0x60>
        s = va_arg(ap, char*);
 90a:	8b4a                	mv	s6,s2
      state = 0;
 90c:	4981                	li	s3,0
 90e:	b54d                	j	7b0 <vprintf+0x60>
    }
  }
}
 910:	70e6                	ld	ra,120(sp)
 912:	7446                	ld	s0,112(sp)
 914:	74a6                	ld	s1,104(sp)
 916:	7906                	ld	s2,96(sp)
 918:	69e6                	ld	s3,88(sp)
 91a:	6a46                	ld	s4,80(sp)
 91c:	6aa6                	ld	s5,72(sp)
 91e:	6b06                	ld	s6,64(sp)
 920:	7be2                	ld	s7,56(sp)
 922:	7c42                	ld	s8,48(sp)
 924:	7ca2                	ld	s9,40(sp)
 926:	7d02                	ld	s10,32(sp)
 928:	6de2                	ld	s11,24(sp)
 92a:	6109                	addi	sp,sp,128
 92c:	8082                	ret

000000000000092e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 92e:	715d                	addi	sp,sp,-80
 930:	ec06                	sd	ra,24(sp)
 932:	e822                	sd	s0,16(sp)
 934:	1000                	addi	s0,sp,32
 936:	e010                	sd	a2,0(s0)
 938:	e414                	sd	a3,8(s0)
 93a:	e818                	sd	a4,16(s0)
 93c:	ec1c                	sd	a5,24(s0)
 93e:	03043023          	sd	a6,32(s0)
 942:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 946:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 94a:	8622                	mv	a2,s0
 94c:	00000097          	auipc	ra,0x0
 950:	e04080e7          	jalr	-508(ra) # 750 <vprintf>
}
 954:	60e2                	ld	ra,24(sp)
 956:	6442                	ld	s0,16(sp)
 958:	6161                	addi	sp,sp,80
 95a:	8082                	ret

000000000000095c <printf>:

void
printf(const char *fmt, ...)
{
 95c:	711d                	addi	sp,sp,-96
 95e:	ec06                	sd	ra,24(sp)
 960:	e822                	sd	s0,16(sp)
 962:	1000                	addi	s0,sp,32
 964:	e40c                	sd	a1,8(s0)
 966:	e810                	sd	a2,16(s0)
 968:	ec14                	sd	a3,24(s0)
 96a:	f018                	sd	a4,32(s0)
 96c:	f41c                	sd	a5,40(s0)
 96e:	03043823          	sd	a6,48(s0)
 972:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 976:	00840613          	addi	a2,s0,8
 97a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 97e:	85aa                	mv	a1,a0
 980:	4505                	li	a0,1
 982:	00000097          	auipc	ra,0x0
 986:	dce080e7          	jalr	-562(ra) # 750 <vprintf>
}
 98a:	60e2                	ld	ra,24(sp)
 98c:	6442                	ld	s0,16(sp)
 98e:	6125                	addi	sp,sp,96
 990:	8082                	ret

0000000000000992 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 992:	1141                	addi	sp,sp,-16
 994:	e422                	sd	s0,8(sp)
 996:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 998:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 99c:	00000797          	auipc	a5,0x0
 9a0:	33c7b783          	ld	a5,828(a5) # cd8 <freep>
 9a4:	a02d                	j	9ce <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 9a6:	4618                	lw	a4,8(a2)
 9a8:	9f2d                	addw	a4,a4,a1
 9aa:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 9ae:	6398                	ld	a4,0(a5)
 9b0:	6310                	ld	a2,0(a4)
 9b2:	a83d                	j	9f0 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 9b4:	ff852703          	lw	a4,-8(a0)
 9b8:	9f31                	addw	a4,a4,a2
 9ba:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 9bc:	ff053683          	ld	a3,-16(a0)
 9c0:	a091                	j	a04 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9c2:	6398                	ld	a4,0(a5)
 9c4:	00e7e463          	bltu	a5,a4,9cc <free+0x3a>
 9c8:	00e6ea63          	bltu	a3,a4,9dc <free+0x4a>
{
 9cc:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9ce:	fed7fae3          	bgeu	a5,a3,9c2 <free+0x30>
 9d2:	6398                	ld	a4,0(a5)
 9d4:	00e6e463          	bltu	a3,a4,9dc <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9d8:	fee7eae3          	bltu	a5,a4,9cc <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 9dc:	ff852583          	lw	a1,-8(a0)
 9e0:	6390                	ld	a2,0(a5)
 9e2:	02059813          	slli	a6,a1,0x20
 9e6:	01c85713          	srli	a4,a6,0x1c
 9ea:	9736                	add	a4,a4,a3
 9ec:	fae60de3          	beq	a2,a4,9a6 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 9f0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9f4:	4790                	lw	a2,8(a5)
 9f6:	02061593          	slli	a1,a2,0x20
 9fa:	01c5d713          	srli	a4,a1,0x1c
 9fe:	973e                	add	a4,a4,a5
 a00:	fae68ae3          	beq	a3,a4,9b4 <free+0x22>
    p->s.ptr = bp->s.ptr;
 a04:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a06:	00000717          	auipc	a4,0x0
 a0a:	2cf73923          	sd	a5,722(a4) # cd8 <freep>
}
 a0e:	6422                	ld	s0,8(sp)
 a10:	0141                	addi	sp,sp,16
 a12:	8082                	ret

0000000000000a14 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a14:	7139                	addi	sp,sp,-64
 a16:	fc06                	sd	ra,56(sp)
 a18:	f822                	sd	s0,48(sp)
 a1a:	f426                	sd	s1,40(sp)
 a1c:	f04a                	sd	s2,32(sp)
 a1e:	ec4e                	sd	s3,24(sp)
 a20:	e852                	sd	s4,16(sp)
 a22:	e456                	sd	s5,8(sp)
 a24:	e05a                	sd	s6,0(sp)
 a26:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a28:	02051493          	slli	s1,a0,0x20
 a2c:	9081                	srli	s1,s1,0x20
 a2e:	04bd                	addi	s1,s1,15
 a30:	8091                	srli	s1,s1,0x4
 a32:	0014899b          	addiw	s3,s1,1
 a36:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 a38:	00000517          	auipc	a0,0x0
 a3c:	2a053503          	ld	a0,672(a0) # cd8 <freep>
 a40:	c515                	beqz	a0,a6c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a42:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a44:	4798                	lw	a4,8(a5)
 a46:	02977f63          	bgeu	a4,s1,a84 <malloc+0x70>
 a4a:	8a4e                	mv	s4,s3
 a4c:	0009871b          	sext.w	a4,s3
 a50:	6685                	lui	a3,0x1
 a52:	00d77363          	bgeu	a4,a3,a58 <malloc+0x44>
 a56:	6a05                	lui	s4,0x1
 a58:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a5c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a60:	00000917          	auipc	s2,0x0
 a64:	27890913          	addi	s2,s2,632 # cd8 <freep>
  if(p == (char*)-1)
 a68:	5afd                	li	s5,-1
 a6a:	a895                	j	ade <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 a6c:	00000797          	auipc	a5,0x0
 a70:	27478793          	addi	a5,a5,628 # ce0 <base>
 a74:	00000717          	auipc	a4,0x0
 a78:	26f73223          	sd	a5,612(a4) # cd8 <freep>
 a7c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a7e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a82:	b7e1                	j	a4a <malloc+0x36>
      if(p->s.size == nunits)
 a84:	02e48c63          	beq	s1,a4,abc <malloc+0xa8>
        p->s.size -= nunits;
 a88:	4137073b          	subw	a4,a4,s3
 a8c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a8e:	02071693          	slli	a3,a4,0x20
 a92:	01c6d713          	srli	a4,a3,0x1c
 a96:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a98:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a9c:	00000717          	auipc	a4,0x0
 aa0:	22a73e23          	sd	a0,572(a4) # cd8 <freep>
      return (void*)(p + 1);
 aa4:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 aa8:	70e2                	ld	ra,56(sp)
 aaa:	7442                	ld	s0,48(sp)
 aac:	74a2                	ld	s1,40(sp)
 aae:	7902                	ld	s2,32(sp)
 ab0:	69e2                	ld	s3,24(sp)
 ab2:	6a42                	ld	s4,16(sp)
 ab4:	6aa2                	ld	s5,8(sp)
 ab6:	6b02                	ld	s6,0(sp)
 ab8:	6121                	addi	sp,sp,64
 aba:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 abc:	6398                	ld	a4,0(a5)
 abe:	e118                	sd	a4,0(a0)
 ac0:	bff1                	j	a9c <malloc+0x88>
  hp->s.size = nu;
 ac2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 ac6:	0541                	addi	a0,a0,16
 ac8:	00000097          	auipc	ra,0x0
 acc:	eca080e7          	jalr	-310(ra) # 992 <free>
  return freep;
 ad0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 ad4:	d971                	beqz	a0,aa8 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ad6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 ad8:	4798                	lw	a4,8(a5)
 ada:	fa9775e3          	bgeu	a4,s1,a84 <malloc+0x70>
    if(p == freep)
 ade:	00093703          	ld	a4,0(s2)
 ae2:	853e                	mv	a0,a5
 ae4:	fef719e3          	bne	a4,a5,ad6 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 ae8:	8552                	mv	a0,s4
 aea:	00000097          	auipc	ra,0x0
 aee:	b60080e7          	jalr	-1184(ra) # 64a <sbrk>
  if(p == (char*)-1)
 af2:	fd5518e3          	bne	a0,s5,ac2 <malloc+0xae>
        return 0;
 af6:	4501                	li	a0,0
 af8:	bf45                	j	aa8 <malloc+0x94>
