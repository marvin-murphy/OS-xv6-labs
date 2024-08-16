
user/_uthread：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <thread_init>:
struct thread *current_thread;
extern void thread_switch(uint64, uint64);
              
void 
thread_init(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e422                	sd	s0,8(sp)
   4:	0800                	addi	s0,sp,16
  // main() is thread 0, which will make the first invocation to
  // thread_schedule().  it needs a stack so that the first thread_switch() can
  // save thread 0's state.  thread_schedule() won't run the main thread ever
  // again, because its state is set to RUNNING, and thread_schedule() selects
  // a RUNNABLE thread.
  current_thread = &all_thread[0];
   6:	00001797          	auipc	a5,0x1
   a:	d8a78793          	addi	a5,a5,-630 # d90 <all_thread>
   e:	00001717          	auipc	a4,0x1
  12:	d6f73923          	sd	a5,-654(a4) # d80 <current_thread>
  current_thread->state = RUNNING;
  16:	4785                	li	a5,1
  18:	00003717          	auipc	a4,0x3
  1c:	d6f72c23          	sw	a5,-648(a4) # 2d90 <__global_pointer$+0x182f>
}
  20:	6422                	ld	s0,8(sp)
  22:	0141                	addi	sp,sp,16
  24:	8082                	ret

0000000000000026 <thread_schedule>:

void 
thread_schedule(void)
{
  26:	1141                	addi	sp,sp,-16
  28:	e406                	sd	ra,8(sp)
  2a:	e022                	sd	s0,0(sp)
  2c:	0800                	addi	s0,sp,16
  struct thread *t, *next_thread;

  /* Find another runnable thread. */
  next_thread = 0;
  t = current_thread + 1;
  2e:	00001317          	auipc	t1,0x1
  32:	d5233303          	ld	t1,-686(t1) # d80 <current_thread>
  36:	6589                	lui	a1,0x2
  38:	07858593          	addi	a1,a1,120 # 2078 <__global_pointer$+0xb17>
  3c:	959a                	add	a1,a1,t1
  3e:	4791                	li	a5,4
  for(int i = 0; i < MAX_THREAD; i++){
    if(t >= all_thread + MAX_THREAD)
  40:	00009817          	auipc	a6,0x9
  44:	f3080813          	addi	a6,a6,-208 # 8f70 <base>
      t = all_thread;
    if(t->state == RUNNABLE) {
  48:	6689                	lui	a3,0x2
  4a:	4609                	li	a2,2
      next_thread = t;
      break;
    }
    t = t + 1;
  4c:	07868893          	addi	a7,a3,120 # 2078 <__global_pointer$+0xb17>
  50:	a809                	j	62 <thread_schedule+0x3c>
    if(t->state == RUNNABLE) {
  52:	00d58733          	add	a4,a1,a3
  56:	4318                	lw	a4,0(a4)
  58:	02c70963          	beq	a4,a2,8a <thread_schedule+0x64>
    t = t + 1;
  5c:	95c6                	add	a1,a1,a7
  for(int i = 0; i < MAX_THREAD; i++){
  5e:	37fd                	addiw	a5,a5,-1
  60:	cb81                	beqz	a5,70 <thread_schedule+0x4a>
    if(t >= all_thread + MAX_THREAD)
  62:	ff05e8e3          	bltu	a1,a6,52 <thread_schedule+0x2c>
      t = all_thread;
  66:	00001597          	auipc	a1,0x1
  6a:	d2a58593          	addi	a1,a1,-726 # d90 <all_thread>
  6e:	b7d5                	j	52 <thread_schedule+0x2c>
  }

  if (next_thread == 0) {
    printf("thread_schedule: no runnable threads\n");
  70:	00001517          	auipc	a0,0x1
  74:	b8050513          	addi	a0,a0,-1152 # bf0 <malloc+0xe8>
  78:	00001097          	auipc	ra,0x1
  7c:	9d8080e7          	jalr	-1576(ra) # a50 <printf>
    exit(-1);
  80:	557d                	li	a0,-1
  82:	00000097          	auipc	ra,0x0
  86:	654080e7          	jalr	1620(ra) # 6d6 <exit>
  }

  if (current_thread != next_thread) {         /* switch threads?  */
  8a:	02b30263          	beq	t1,a1,ae <thread_schedule+0x88>
    next_thread->state = RUNNING;
  8e:	6509                	lui	a0,0x2
  90:	00a587b3          	add	a5,a1,a0
  94:	4705                	li	a4,1
  96:	c398                	sw	a4,0(a5)
    t = current_thread;
    current_thread = next_thread;
  98:	00001797          	auipc	a5,0x1
  9c:	ceb7b423          	sd	a1,-792(a5) # d80 <current_thread>
    /* YOUR CODE HERE
     * Invoke thread_switch to switch from t to next_thread:
     * thread_switch(??, ??);
     */
    thread_switch((uint64) &t->ctx, (uint64) &current_thread->ctx);
  a0:	0521                	addi	a0,a0,8 # 2008 <__global_pointer$+0xaa7>
  a2:	95aa                	add	a1,a1,a0
  a4:	951a                	add	a0,a0,t1
  a6:	00000097          	auipc	ra,0x0
  aa:	35a080e7          	jalr	858(ra) # 400 <thread_switch>
  } else
    next_thread = 0;
}
  ae:	60a2                	ld	ra,8(sp)
  b0:	6402                	ld	s0,0(sp)
  b2:	0141                	addi	sp,sp,16
  b4:	8082                	ret

00000000000000b6 <thread_create>:

void 
thread_create(void (*func)())
{
  b6:	1141                	addi	sp,sp,-16
  b8:	e422                	sd	s0,8(sp)
  ba:	0800                	addi	s0,sp,16
  struct thread *t;

  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  bc:	00001797          	auipc	a5,0x1
  c0:	cd478793          	addi	a5,a5,-812 # d90 <all_thread>
    if (t->state == FREE) break;
  c4:	6689                	lui	a3,0x2
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  c6:	07868593          	addi	a1,a3,120 # 2078 <__global_pointer$+0xb17>
  ca:	00009617          	auipc	a2,0x9
  ce:	ea660613          	addi	a2,a2,-346 # 8f70 <base>
    if (t->state == FREE) break;
  d2:	00d78733          	add	a4,a5,a3
  d6:	4318                	lw	a4,0(a4)
  d8:	c701                	beqz	a4,e0 <thread_create+0x2a>
  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
  da:	97ae                	add	a5,a5,a1
  dc:	fec79be3          	bne	a5,a2,d2 <thread_create+0x1c>
  }
  t->state = RUNNABLE;
  e0:	6709                	lui	a4,0x2
  e2:	97ba                	add	a5,a5,a4
  e4:	4709                	li	a4,2
  e6:	c398                	sw	a4,0(a5)
  // YOUR CODE HERE
  t->ctx.ra = (uint64) func;
  e8:	e788                	sd	a0,8(a5)
  t->ctx.sp = (uint64) t->stack + STACK_SIZE;
  ea:	eb9c                	sd	a5,16(a5)
}
  ec:	6422                	ld	s0,8(sp)
  ee:	0141                	addi	sp,sp,16
  f0:	8082                	ret

00000000000000f2 <thread_yield>:

void 
thread_yield(void)
{
  f2:	1141                	addi	sp,sp,-16
  f4:	e406                	sd	ra,8(sp)
  f6:	e022                	sd	s0,0(sp)
  f8:	0800                	addi	s0,sp,16
  current_thread->state = RUNNABLE;
  fa:	00001797          	auipc	a5,0x1
  fe:	c867b783          	ld	a5,-890(a5) # d80 <current_thread>
 102:	6709                	lui	a4,0x2
 104:	97ba                	add	a5,a5,a4
 106:	4709                	li	a4,2
 108:	c398                	sw	a4,0(a5)
  thread_schedule();
 10a:	00000097          	auipc	ra,0x0
 10e:	f1c080e7          	jalr	-228(ra) # 26 <thread_schedule>
}
 112:	60a2                	ld	ra,8(sp)
 114:	6402                	ld	s0,0(sp)
 116:	0141                	addi	sp,sp,16
 118:	8082                	ret

000000000000011a <thread_a>:
volatile int a_started, b_started, c_started;
volatile int a_n, b_n, c_n;

void 
thread_a(void)
{
 11a:	7179                	addi	sp,sp,-48
 11c:	f406                	sd	ra,40(sp)
 11e:	f022                	sd	s0,32(sp)
 120:	ec26                	sd	s1,24(sp)
 122:	e84a                	sd	s2,16(sp)
 124:	e44e                	sd	s3,8(sp)
 126:	e052                	sd	s4,0(sp)
 128:	1800                	addi	s0,sp,48
  int i;
  printf("thread_a started\n");
 12a:	00001517          	auipc	a0,0x1
 12e:	aee50513          	addi	a0,a0,-1298 # c18 <malloc+0x110>
 132:	00001097          	auipc	ra,0x1
 136:	91e080e7          	jalr	-1762(ra) # a50 <printf>
  a_started = 1;
 13a:	4785                	li	a5,1
 13c:	00001717          	auipc	a4,0x1
 140:	c4f72023          	sw	a5,-960(a4) # d7c <a_started>
  while(b_started == 0 || c_started == 0)
 144:	00001497          	auipc	s1,0x1
 148:	c3448493          	addi	s1,s1,-972 # d78 <b_started>
 14c:	00001917          	auipc	s2,0x1
 150:	c2890913          	addi	s2,s2,-984 # d74 <c_started>
 154:	a029                	j	15e <thread_a+0x44>
    thread_yield();
 156:	00000097          	auipc	ra,0x0
 15a:	f9c080e7          	jalr	-100(ra) # f2 <thread_yield>
  while(b_started == 0 || c_started == 0)
 15e:	409c                	lw	a5,0(s1)
 160:	2781                	sext.w	a5,a5
 162:	dbf5                	beqz	a5,156 <thread_a+0x3c>
 164:	00092783          	lw	a5,0(s2)
 168:	2781                	sext.w	a5,a5
 16a:	d7f5                	beqz	a5,156 <thread_a+0x3c>
  
  for (i = 0; i < 100; i++) {
 16c:	4481                	li	s1,0
    printf("thread_a %d\n", i);
 16e:	00001a17          	auipc	s4,0x1
 172:	ac2a0a13          	addi	s4,s4,-1342 # c30 <malloc+0x128>
    a_n += 1;
 176:	00001917          	auipc	s2,0x1
 17a:	bfa90913          	addi	s2,s2,-1030 # d70 <a_n>
  for (i = 0; i < 100; i++) {
 17e:	06400993          	li	s3,100
    printf("thread_a %d\n", i);
 182:	85a6                	mv	a1,s1
 184:	8552                	mv	a0,s4
 186:	00001097          	auipc	ra,0x1
 18a:	8ca080e7          	jalr	-1846(ra) # a50 <printf>
    a_n += 1;
 18e:	00092783          	lw	a5,0(s2)
 192:	2785                	addiw	a5,a5,1
 194:	00f92023          	sw	a5,0(s2)
    thread_yield();
 198:	00000097          	auipc	ra,0x0
 19c:	f5a080e7          	jalr	-166(ra) # f2 <thread_yield>
  for (i = 0; i < 100; i++) {
 1a0:	2485                	addiw	s1,s1,1
 1a2:	ff3490e3          	bne	s1,s3,182 <thread_a+0x68>
  }
  printf("thread_a: exit after %d\n", a_n);
 1a6:	00001597          	auipc	a1,0x1
 1aa:	bca5a583          	lw	a1,-1078(a1) # d70 <a_n>
 1ae:	00001517          	auipc	a0,0x1
 1b2:	a9250513          	addi	a0,a0,-1390 # c40 <malloc+0x138>
 1b6:	00001097          	auipc	ra,0x1
 1ba:	89a080e7          	jalr	-1894(ra) # a50 <printf>

  current_thread->state = FREE;
 1be:	00001797          	auipc	a5,0x1
 1c2:	bc27b783          	ld	a5,-1086(a5) # d80 <current_thread>
 1c6:	6709                	lui	a4,0x2
 1c8:	97ba                	add	a5,a5,a4
 1ca:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 1ce:	00000097          	auipc	ra,0x0
 1d2:	e58080e7          	jalr	-424(ra) # 26 <thread_schedule>
}
 1d6:	70a2                	ld	ra,40(sp)
 1d8:	7402                	ld	s0,32(sp)
 1da:	64e2                	ld	s1,24(sp)
 1dc:	6942                	ld	s2,16(sp)
 1de:	69a2                	ld	s3,8(sp)
 1e0:	6a02                	ld	s4,0(sp)
 1e2:	6145                	addi	sp,sp,48
 1e4:	8082                	ret

00000000000001e6 <thread_b>:

void 
thread_b(void)
{
 1e6:	7179                	addi	sp,sp,-48
 1e8:	f406                	sd	ra,40(sp)
 1ea:	f022                	sd	s0,32(sp)
 1ec:	ec26                	sd	s1,24(sp)
 1ee:	e84a                	sd	s2,16(sp)
 1f0:	e44e                	sd	s3,8(sp)
 1f2:	e052                	sd	s4,0(sp)
 1f4:	1800                	addi	s0,sp,48
  int i;
  printf("thread_b started\n");
 1f6:	00001517          	auipc	a0,0x1
 1fa:	a6a50513          	addi	a0,a0,-1430 # c60 <malloc+0x158>
 1fe:	00001097          	auipc	ra,0x1
 202:	852080e7          	jalr	-1966(ra) # a50 <printf>
  b_started = 1;
 206:	4785                	li	a5,1
 208:	00001717          	auipc	a4,0x1
 20c:	b6f72823          	sw	a5,-1168(a4) # d78 <b_started>
  while(a_started == 0 || c_started == 0)
 210:	00001497          	auipc	s1,0x1
 214:	b6c48493          	addi	s1,s1,-1172 # d7c <a_started>
 218:	00001917          	auipc	s2,0x1
 21c:	b5c90913          	addi	s2,s2,-1188 # d74 <c_started>
 220:	a029                	j	22a <thread_b+0x44>
    thread_yield();
 222:	00000097          	auipc	ra,0x0
 226:	ed0080e7          	jalr	-304(ra) # f2 <thread_yield>
  while(a_started == 0 || c_started == 0)
 22a:	409c                	lw	a5,0(s1)
 22c:	2781                	sext.w	a5,a5
 22e:	dbf5                	beqz	a5,222 <thread_b+0x3c>
 230:	00092783          	lw	a5,0(s2)
 234:	2781                	sext.w	a5,a5
 236:	d7f5                	beqz	a5,222 <thread_b+0x3c>
  
  for (i = 0; i < 100; i++) {
 238:	4481                	li	s1,0
    printf("thread_b %d\n", i);
 23a:	00001a17          	auipc	s4,0x1
 23e:	a3ea0a13          	addi	s4,s4,-1474 # c78 <malloc+0x170>
    b_n += 1;
 242:	00001917          	auipc	s2,0x1
 246:	b2a90913          	addi	s2,s2,-1238 # d6c <b_n>
  for (i = 0; i < 100; i++) {
 24a:	06400993          	li	s3,100
    printf("thread_b %d\n", i);
 24e:	85a6                	mv	a1,s1
 250:	8552                	mv	a0,s4
 252:	00000097          	auipc	ra,0x0
 256:	7fe080e7          	jalr	2046(ra) # a50 <printf>
    b_n += 1;
 25a:	00092783          	lw	a5,0(s2)
 25e:	2785                	addiw	a5,a5,1
 260:	00f92023          	sw	a5,0(s2)
    thread_yield();
 264:	00000097          	auipc	ra,0x0
 268:	e8e080e7          	jalr	-370(ra) # f2 <thread_yield>
  for (i = 0; i < 100; i++) {
 26c:	2485                	addiw	s1,s1,1
 26e:	ff3490e3          	bne	s1,s3,24e <thread_b+0x68>
  }
  printf("thread_b: exit after %d\n", b_n);
 272:	00001597          	auipc	a1,0x1
 276:	afa5a583          	lw	a1,-1286(a1) # d6c <b_n>
 27a:	00001517          	auipc	a0,0x1
 27e:	a0e50513          	addi	a0,a0,-1522 # c88 <malloc+0x180>
 282:	00000097          	auipc	ra,0x0
 286:	7ce080e7          	jalr	1998(ra) # a50 <printf>

  current_thread->state = FREE;
 28a:	00001797          	auipc	a5,0x1
 28e:	af67b783          	ld	a5,-1290(a5) # d80 <current_thread>
 292:	6709                	lui	a4,0x2
 294:	97ba                	add	a5,a5,a4
 296:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 29a:	00000097          	auipc	ra,0x0
 29e:	d8c080e7          	jalr	-628(ra) # 26 <thread_schedule>
}
 2a2:	70a2                	ld	ra,40(sp)
 2a4:	7402                	ld	s0,32(sp)
 2a6:	64e2                	ld	s1,24(sp)
 2a8:	6942                	ld	s2,16(sp)
 2aa:	69a2                	ld	s3,8(sp)
 2ac:	6a02                	ld	s4,0(sp)
 2ae:	6145                	addi	sp,sp,48
 2b0:	8082                	ret

00000000000002b2 <thread_c>:

void 
thread_c(void)
{
 2b2:	7179                	addi	sp,sp,-48
 2b4:	f406                	sd	ra,40(sp)
 2b6:	f022                	sd	s0,32(sp)
 2b8:	ec26                	sd	s1,24(sp)
 2ba:	e84a                	sd	s2,16(sp)
 2bc:	e44e                	sd	s3,8(sp)
 2be:	e052                	sd	s4,0(sp)
 2c0:	1800                	addi	s0,sp,48
  int i;
  printf("thread_c started\n");
 2c2:	00001517          	auipc	a0,0x1
 2c6:	9e650513          	addi	a0,a0,-1562 # ca8 <malloc+0x1a0>
 2ca:	00000097          	auipc	ra,0x0
 2ce:	786080e7          	jalr	1926(ra) # a50 <printf>
  c_started = 1;
 2d2:	4785                	li	a5,1
 2d4:	00001717          	auipc	a4,0x1
 2d8:	aaf72023          	sw	a5,-1376(a4) # d74 <c_started>
  while(a_started == 0 || b_started == 0)
 2dc:	00001497          	auipc	s1,0x1
 2e0:	aa048493          	addi	s1,s1,-1376 # d7c <a_started>
 2e4:	00001917          	auipc	s2,0x1
 2e8:	a9490913          	addi	s2,s2,-1388 # d78 <b_started>
 2ec:	a029                	j	2f6 <thread_c+0x44>
    thread_yield();
 2ee:	00000097          	auipc	ra,0x0
 2f2:	e04080e7          	jalr	-508(ra) # f2 <thread_yield>
  while(a_started == 0 || b_started == 0)
 2f6:	409c                	lw	a5,0(s1)
 2f8:	2781                	sext.w	a5,a5
 2fa:	dbf5                	beqz	a5,2ee <thread_c+0x3c>
 2fc:	00092783          	lw	a5,0(s2)
 300:	2781                	sext.w	a5,a5
 302:	d7f5                	beqz	a5,2ee <thread_c+0x3c>
  
  for (i = 0; i < 100; i++) {
 304:	4481                	li	s1,0
    printf("thread_c %d\n", i);
 306:	00001a17          	auipc	s4,0x1
 30a:	9baa0a13          	addi	s4,s4,-1606 # cc0 <malloc+0x1b8>
    c_n += 1;
 30e:	00001917          	auipc	s2,0x1
 312:	a5a90913          	addi	s2,s2,-1446 # d68 <c_n>
  for (i = 0; i < 100; i++) {
 316:	06400993          	li	s3,100
    printf("thread_c %d\n", i);
 31a:	85a6                	mv	a1,s1
 31c:	8552                	mv	a0,s4
 31e:	00000097          	auipc	ra,0x0
 322:	732080e7          	jalr	1842(ra) # a50 <printf>
    c_n += 1;
 326:	00092783          	lw	a5,0(s2)
 32a:	2785                	addiw	a5,a5,1
 32c:	00f92023          	sw	a5,0(s2)
    thread_yield();
 330:	00000097          	auipc	ra,0x0
 334:	dc2080e7          	jalr	-574(ra) # f2 <thread_yield>
  for (i = 0; i < 100; i++) {
 338:	2485                	addiw	s1,s1,1
 33a:	ff3490e3          	bne	s1,s3,31a <thread_c+0x68>
  }
  printf("thread_c: exit after %d\n", c_n);
 33e:	00001597          	auipc	a1,0x1
 342:	a2a5a583          	lw	a1,-1494(a1) # d68 <c_n>
 346:	00001517          	auipc	a0,0x1
 34a:	98a50513          	addi	a0,a0,-1654 # cd0 <malloc+0x1c8>
 34e:	00000097          	auipc	ra,0x0
 352:	702080e7          	jalr	1794(ra) # a50 <printf>

  current_thread->state = FREE;
 356:	00001797          	auipc	a5,0x1
 35a:	a2a7b783          	ld	a5,-1494(a5) # d80 <current_thread>
 35e:	6709                	lui	a4,0x2
 360:	97ba                	add	a5,a5,a4
 362:	0007a023          	sw	zero,0(a5)
  thread_schedule();
 366:	00000097          	auipc	ra,0x0
 36a:	cc0080e7          	jalr	-832(ra) # 26 <thread_schedule>
}
 36e:	70a2                	ld	ra,40(sp)
 370:	7402                	ld	s0,32(sp)
 372:	64e2                	ld	s1,24(sp)
 374:	6942                	ld	s2,16(sp)
 376:	69a2                	ld	s3,8(sp)
 378:	6a02                	ld	s4,0(sp)
 37a:	6145                	addi	sp,sp,48
 37c:	8082                	ret

000000000000037e <main>:

int 
main(int argc, char *argv[]) 
{
 37e:	1141                	addi	sp,sp,-16
 380:	e406                	sd	ra,8(sp)
 382:	e022                	sd	s0,0(sp)
 384:	0800                	addi	s0,sp,16
  a_started = b_started = c_started = 0;
 386:	00001797          	auipc	a5,0x1
 38a:	9e07a723          	sw	zero,-1554(a5) # d74 <c_started>
 38e:	00001797          	auipc	a5,0x1
 392:	9e07a523          	sw	zero,-1558(a5) # d78 <b_started>
 396:	00001797          	auipc	a5,0x1
 39a:	9e07a323          	sw	zero,-1562(a5) # d7c <a_started>
  a_n = b_n = c_n = 0;
 39e:	00001797          	auipc	a5,0x1
 3a2:	9c07a523          	sw	zero,-1590(a5) # d68 <c_n>
 3a6:	00001797          	auipc	a5,0x1
 3aa:	9c07a323          	sw	zero,-1594(a5) # d6c <b_n>
 3ae:	00001797          	auipc	a5,0x1
 3b2:	9c07a123          	sw	zero,-1598(a5) # d70 <a_n>
  thread_init();
 3b6:	00000097          	auipc	ra,0x0
 3ba:	c4a080e7          	jalr	-950(ra) # 0 <thread_init>
  thread_create(thread_a);
 3be:	00000517          	auipc	a0,0x0
 3c2:	d5c50513          	addi	a0,a0,-676 # 11a <thread_a>
 3c6:	00000097          	auipc	ra,0x0
 3ca:	cf0080e7          	jalr	-784(ra) # b6 <thread_create>
  thread_create(thread_b);
 3ce:	00000517          	auipc	a0,0x0
 3d2:	e1850513          	addi	a0,a0,-488 # 1e6 <thread_b>
 3d6:	00000097          	auipc	ra,0x0
 3da:	ce0080e7          	jalr	-800(ra) # b6 <thread_create>
  thread_create(thread_c);
 3de:	00000517          	auipc	a0,0x0
 3e2:	ed450513          	addi	a0,a0,-300 # 2b2 <thread_c>
 3e6:	00000097          	auipc	ra,0x0
 3ea:	cd0080e7          	jalr	-816(ra) # b6 <thread_create>
  thread_schedule();
 3ee:	00000097          	auipc	ra,0x0
 3f2:	c38080e7          	jalr	-968(ra) # 26 <thread_schedule>
  exit(0);
 3f6:	4501                	li	a0,0
 3f8:	00000097          	auipc	ra,0x0
 3fc:	2de080e7          	jalr	734(ra) # 6d6 <exit>

0000000000000400 <thread_switch>:

	.globl thread_switch
thread_switch:
	/* YOUR CODE HERE */

	sd ra, 0(a0)
 400:	00153023          	sd	ra,0(a0)
	sd sp, 8(a0)
 404:	00253423          	sd	sp,8(a0)
	sd s0, 16(a0)
 408:	e900                	sd	s0,16(a0)
	sd s1, 24(a0)
 40a:	ed04                	sd	s1,24(a0)
	sd s2, 32(a0)
 40c:	03253023          	sd	s2,32(a0)
	sd s3, 40(a0)
 410:	03353423          	sd	s3,40(a0)
	sd s4, 48(a0)
 414:	03453823          	sd	s4,48(a0)
	sd s5, 56(a0)
 418:	03553c23          	sd	s5,56(a0)
	sd s6, 64(a0)
 41c:	05653023          	sd	s6,64(a0)
	sd s7, 72(a0)
 420:	05753423          	sd	s7,72(a0)
	sd s8, 80(a0)
 424:	05853823          	sd	s8,80(a0)
	sd s9, 88(a0)
 428:	05953c23          	sd	s9,88(a0)
	sd s10, 96(a0)
 42c:	07a53023          	sd	s10,96(a0)
	sd s11, 104(a0)
 430:	07b53423          	sd	s11,104(a0)

	ld ra, 0(a1)
 434:	0005b083          	ld	ra,0(a1)
	ld sp, 8(a1)
 438:	0085b103          	ld	sp,8(a1)
	ld s0, 16(a1)
 43c:	6980                	ld	s0,16(a1)
	ld s1, 24(a1)
 43e:	6d84                	ld	s1,24(a1)
	ld s2, 32(a1)
 440:	0205b903          	ld	s2,32(a1)
	ld s3, 40(a1)
 444:	0285b983          	ld	s3,40(a1)
	ld s4, 48(a1)
 448:	0305ba03          	ld	s4,48(a1)
	ld s5, 56(a1)
 44c:	0385ba83          	ld	s5,56(a1)
	ld s6, 64(a1)
 450:	0405bb03          	ld	s6,64(a1)
	ld s7, 72(a1)
 454:	0485bb83          	ld	s7,72(a1)
	ld s8, 80(a1)
 458:	0505bc03          	ld	s8,80(a1)
	ld s9, 88(a1)
 45c:	0585bc83          	ld	s9,88(a1)
	ld s10, 96(a1)
 460:	0605bd03          	ld	s10,96(a1)
	ld s11, 104(a1)
 464:	0685bd83          	ld	s11,104(a1)

	ret    /* return to ra */
 468:	8082                	ret

000000000000046a <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 46a:	1141                	addi	sp,sp,-16
 46c:	e422                	sd	s0,8(sp)
 46e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 470:	87aa                	mv	a5,a0
 472:	0585                	addi	a1,a1,1
 474:	0785                	addi	a5,a5,1
 476:	fff5c703          	lbu	a4,-1(a1)
 47a:	fee78fa3          	sb	a4,-1(a5)
 47e:	fb75                	bnez	a4,472 <strcpy+0x8>
    ;
  return os;
}
 480:	6422                	ld	s0,8(sp)
 482:	0141                	addi	sp,sp,16
 484:	8082                	ret

0000000000000486 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 486:	1141                	addi	sp,sp,-16
 488:	e422                	sd	s0,8(sp)
 48a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 48c:	00054783          	lbu	a5,0(a0)
 490:	cb91                	beqz	a5,4a4 <strcmp+0x1e>
 492:	0005c703          	lbu	a4,0(a1)
 496:	00f71763          	bne	a4,a5,4a4 <strcmp+0x1e>
    p++, q++;
 49a:	0505                	addi	a0,a0,1
 49c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 49e:	00054783          	lbu	a5,0(a0)
 4a2:	fbe5                	bnez	a5,492 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 4a4:	0005c503          	lbu	a0,0(a1)
}
 4a8:	40a7853b          	subw	a0,a5,a0
 4ac:	6422                	ld	s0,8(sp)
 4ae:	0141                	addi	sp,sp,16
 4b0:	8082                	ret

00000000000004b2 <strlen>:

uint
strlen(const char *s)
{
 4b2:	1141                	addi	sp,sp,-16
 4b4:	e422                	sd	s0,8(sp)
 4b6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 4b8:	00054783          	lbu	a5,0(a0)
 4bc:	cf91                	beqz	a5,4d8 <strlen+0x26>
 4be:	0505                	addi	a0,a0,1
 4c0:	87aa                	mv	a5,a0
 4c2:	4685                	li	a3,1
 4c4:	9e89                	subw	a3,a3,a0
 4c6:	00f6853b          	addw	a0,a3,a5
 4ca:	0785                	addi	a5,a5,1
 4cc:	fff7c703          	lbu	a4,-1(a5)
 4d0:	fb7d                	bnez	a4,4c6 <strlen+0x14>
    ;
  return n;
}
 4d2:	6422                	ld	s0,8(sp)
 4d4:	0141                	addi	sp,sp,16
 4d6:	8082                	ret
  for(n = 0; s[n]; n++)
 4d8:	4501                	li	a0,0
 4da:	bfe5                	j	4d2 <strlen+0x20>

00000000000004dc <memset>:

void*
memset(void *dst, int c, uint n)
{
 4dc:	1141                	addi	sp,sp,-16
 4de:	e422                	sd	s0,8(sp)
 4e0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 4e2:	ca19                	beqz	a2,4f8 <memset+0x1c>
 4e4:	87aa                	mv	a5,a0
 4e6:	1602                	slli	a2,a2,0x20
 4e8:	9201                	srli	a2,a2,0x20
 4ea:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 4ee:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 4f2:	0785                	addi	a5,a5,1
 4f4:	fee79de3          	bne	a5,a4,4ee <memset+0x12>
  }
  return dst;
}
 4f8:	6422                	ld	s0,8(sp)
 4fa:	0141                	addi	sp,sp,16
 4fc:	8082                	ret

00000000000004fe <strchr>:

char*
strchr(const char *s, char c)
{
 4fe:	1141                	addi	sp,sp,-16
 500:	e422                	sd	s0,8(sp)
 502:	0800                	addi	s0,sp,16
  for(; *s; s++)
 504:	00054783          	lbu	a5,0(a0)
 508:	cb99                	beqz	a5,51e <strchr+0x20>
    if(*s == c)
 50a:	00f58763          	beq	a1,a5,518 <strchr+0x1a>
  for(; *s; s++)
 50e:	0505                	addi	a0,a0,1
 510:	00054783          	lbu	a5,0(a0)
 514:	fbfd                	bnez	a5,50a <strchr+0xc>
      return (char*)s;
  return 0;
 516:	4501                	li	a0,0
}
 518:	6422                	ld	s0,8(sp)
 51a:	0141                	addi	sp,sp,16
 51c:	8082                	ret
  return 0;
 51e:	4501                	li	a0,0
 520:	bfe5                	j	518 <strchr+0x1a>

0000000000000522 <gets>:

char*
gets(char *buf, int max)
{
 522:	711d                	addi	sp,sp,-96
 524:	ec86                	sd	ra,88(sp)
 526:	e8a2                	sd	s0,80(sp)
 528:	e4a6                	sd	s1,72(sp)
 52a:	e0ca                	sd	s2,64(sp)
 52c:	fc4e                	sd	s3,56(sp)
 52e:	f852                	sd	s4,48(sp)
 530:	f456                	sd	s5,40(sp)
 532:	f05a                	sd	s6,32(sp)
 534:	ec5e                	sd	s7,24(sp)
 536:	1080                	addi	s0,sp,96
 538:	8baa                	mv	s7,a0
 53a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 53c:	892a                	mv	s2,a0
 53e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 540:	4aa9                	li	s5,10
 542:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 544:	89a6                	mv	s3,s1
 546:	2485                	addiw	s1,s1,1
 548:	0344d863          	bge	s1,s4,578 <gets+0x56>
    cc = read(0, &c, 1);
 54c:	4605                	li	a2,1
 54e:	faf40593          	addi	a1,s0,-81
 552:	4501                	li	a0,0
 554:	00000097          	auipc	ra,0x0
 558:	19a080e7          	jalr	410(ra) # 6ee <read>
    if(cc < 1)
 55c:	00a05e63          	blez	a0,578 <gets+0x56>
    buf[i++] = c;
 560:	faf44783          	lbu	a5,-81(s0)
 564:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 568:	01578763          	beq	a5,s5,576 <gets+0x54>
 56c:	0905                	addi	s2,s2,1
 56e:	fd679be3          	bne	a5,s6,544 <gets+0x22>
  for(i=0; i+1 < max; ){
 572:	89a6                	mv	s3,s1
 574:	a011                	j	578 <gets+0x56>
 576:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 578:	99de                	add	s3,s3,s7
 57a:	00098023          	sb	zero,0(s3)
  return buf;
}
 57e:	855e                	mv	a0,s7
 580:	60e6                	ld	ra,88(sp)
 582:	6446                	ld	s0,80(sp)
 584:	64a6                	ld	s1,72(sp)
 586:	6906                	ld	s2,64(sp)
 588:	79e2                	ld	s3,56(sp)
 58a:	7a42                	ld	s4,48(sp)
 58c:	7aa2                	ld	s5,40(sp)
 58e:	7b02                	ld	s6,32(sp)
 590:	6be2                	ld	s7,24(sp)
 592:	6125                	addi	sp,sp,96
 594:	8082                	ret

0000000000000596 <stat>:

int
stat(const char *n, struct stat *st)
{
 596:	1101                	addi	sp,sp,-32
 598:	ec06                	sd	ra,24(sp)
 59a:	e822                	sd	s0,16(sp)
 59c:	e426                	sd	s1,8(sp)
 59e:	e04a                	sd	s2,0(sp)
 5a0:	1000                	addi	s0,sp,32
 5a2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5a4:	4581                	li	a1,0
 5a6:	00000097          	auipc	ra,0x0
 5aa:	170080e7          	jalr	368(ra) # 716 <open>
  if(fd < 0)
 5ae:	02054563          	bltz	a0,5d8 <stat+0x42>
 5b2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 5b4:	85ca                	mv	a1,s2
 5b6:	00000097          	auipc	ra,0x0
 5ba:	178080e7          	jalr	376(ra) # 72e <fstat>
 5be:	892a                	mv	s2,a0
  close(fd);
 5c0:	8526                	mv	a0,s1
 5c2:	00000097          	auipc	ra,0x0
 5c6:	13c080e7          	jalr	316(ra) # 6fe <close>
  return r;
}
 5ca:	854a                	mv	a0,s2
 5cc:	60e2                	ld	ra,24(sp)
 5ce:	6442                	ld	s0,16(sp)
 5d0:	64a2                	ld	s1,8(sp)
 5d2:	6902                	ld	s2,0(sp)
 5d4:	6105                	addi	sp,sp,32
 5d6:	8082                	ret
    return -1;
 5d8:	597d                	li	s2,-1
 5da:	bfc5                	j	5ca <stat+0x34>

00000000000005dc <atoi>:

int
atoi(const char *s)
{
 5dc:	1141                	addi	sp,sp,-16
 5de:	e422                	sd	s0,8(sp)
 5e0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 5e2:	00054683          	lbu	a3,0(a0)
 5e6:	fd06879b          	addiw	a5,a3,-48
 5ea:	0ff7f793          	zext.b	a5,a5
 5ee:	4625                	li	a2,9
 5f0:	02f66863          	bltu	a2,a5,620 <atoi+0x44>
 5f4:	872a                	mv	a4,a0
  n = 0;
 5f6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 5f8:	0705                	addi	a4,a4,1 # 2001 <__global_pointer$+0xaa0>
 5fa:	0025179b          	slliw	a5,a0,0x2
 5fe:	9fa9                	addw	a5,a5,a0
 600:	0017979b          	slliw	a5,a5,0x1
 604:	9fb5                	addw	a5,a5,a3
 606:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 60a:	00074683          	lbu	a3,0(a4)
 60e:	fd06879b          	addiw	a5,a3,-48
 612:	0ff7f793          	zext.b	a5,a5
 616:	fef671e3          	bgeu	a2,a5,5f8 <atoi+0x1c>
  return n;
}
 61a:	6422                	ld	s0,8(sp)
 61c:	0141                	addi	sp,sp,16
 61e:	8082                	ret
  n = 0;
 620:	4501                	li	a0,0
 622:	bfe5                	j	61a <atoi+0x3e>

0000000000000624 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 624:	1141                	addi	sp,sp,-16
 626:	e422                	sd	s0,8(sp)
 628:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 62a:	02b57463          	bgeu	a0,a1,652 <memmove+0x2e>
    while(n-- > 0)
 62e:	00c05f63          	blez	a2,64c <memmove+0x28>
 632:	1602                	slli	a2,a2,0x20
 634:	9201                	srli	a2,a2,0x20
 636:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 63a:	872a                	mv	a4,a0
      *dst++ = *src++;
 63c:	0585                	addi	a1,a1,1
 63e:	0705                	addi	a4,a4,1
 640:	fff5c683          	lbu	a3,-1(a1)
 644:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 648:	fee79ae3          	bne	a5,a4,63c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 64c:	6422                	ld	s0,8(sp)
 64e:	0141                	addi	sp,sp,16
 650:	8082                	ret
    dst += n;
 652:	00c50733          	add	a4,a0,a2
    src += n;
 656:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 658:	fec05ae3          	blez	a2,64c <memmove+0x28>
 65c:	fff6079b          	addiw	a5,a2,-1
 660:	1782                	slli	a5,a5,0x20
 662:	9381                	srli	a5,a5,0x20
 664:	fff7c793          	not	a5,a5
 668:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 66a:	15fd                	addi	a1,a1,-1
 66c:	177d                	addi	a4,a4,-1
 66e:	0005c683          	lbu	a3,0(a1)
 672:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 676:	fee79ae3          	bne	a5,a4,66a <memmove+0x46>
 67a:	bfc9                	j	64c <memmove+0x28>

000000000000067c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 67c:	1141                	addi	sp,sp,-16
 67e:	e422                	sd	s0,8(sp)
 680:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 682:	ca05                	beqz	a2,6b2 <memcmp+0x36>
 684:	fff6069b          	addiw	a3,a2,-1
 688:	1682                	slli	a3,a3,0x20
 68a:	9281                	srli	a3,a3,0x20
 68c:	0685                	addi	a3,a3,1
 68e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 690:	00054783          	lbu	a5,0(a0)
 694:	0005c703          	lbu	a4,0(a1)
 698:	00e79863          	bne	a5,a4,6a8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 69c:	0505                	addi	a0,a0,1
    p2++;
 69e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 6a0:	fed518e3          	bne	a0,a3,690 <memcmp+0x14>
  }
  return 0;
 6a4:	4501                	li	a0,0
 6a6:	a019                	j	6ac <memcmp+0x30>
      return *p1 - *p2;
 6a8:	40e7853b          	subw	a0,a5,a4
}
 6ac:	6422                	ld	s0,8(sp)
 6ae:	0141                	addi	sp,sp,16
 6b0:	8082                	ret
  return 0;
 6b2:	4501                	li	a0,0
 6b4:	bfe5                	j	6ac <memcmp+0x30>

00000000000006b6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 6b6:	1141                	addi	sp,sp,-16
 6b8:	e406                	sd	ra,8(sp)
 6ba:	e022                	sd	s0,0(sp)
 6bc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 6be:	00000097          	auipc	ra,0x0
 6c2:	f66080e7          	jalr	-154(ra) # 624 <memmove>
}
 6c6:	60a2                	ld	ra,8(sp)
 6c8:	6402                	ld	s0,0(sp)
 6ca:	0141                	addi	sp,sp,16
 6cc:	8082                	ret

00000000000006ce <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 6ce:	4885                	li	a7,1
 ecall
 6d0:	00000073          	ecall
 ret
 6d4:	8082                	ret

00000000000006d6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 6d6:	4889                	li	a7,2
 ecall
 6d8:	00000073          	ecall
 ret
 6dc:	8082                	ret

00000000000006de <wait>:
.global wait
wait:
 li a7, SYS_wait
 6de:	488d                	li	a7,3
 ecall
 6e0:	00000073          	ecall
 ret
 6e4:	8082                	ret

00000000000006e6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 6e6:	4891                	li	a7,4
 ecall
 6e8:	00000073          	ecall
 ret
 6ec:	8082                	ret

00000000000006ee <read>:
.global read
read:
 li a7, SYS_read
 6ee:	4895                	li	a7,5
 ecall
 6f0:	00000073          	ecall
 ret
 6f4:	8082                	ret

00000000000006f6 <write>:
.global write
write:
 li a7, SYS_write
 6f6:	48c1                	li	a7,16
 ecall
 6f8:	00000073          	ecall
 ret
 6fc:	8082                	ret

00000000000006fe <close>:
.global close
close:
 li a7, SYS_close
 6fe:	48d5                	li	a7,21
 ecall
 700:	00000073          	ecall
 ret
 704:	8082                	ret

0000000000000706 <kill>:
.global kill
kill:
 li a7, SYS_kill
 706:	4899                	li	a7,6
 ecall
 708:	00000073          	ecall
 ret
 70c:	8082                	ret

000000000000070e <exec>:
.global exec
exec:
 li a7, SYS_exec
 70e:	489d                	li	a7,7
 ecall
 710:	00000073          	ecall
 ret
 714:	8082                	ret

0000000000000716 <open>:
.global open
open:
 li a7, SYS_open
 716:	48bd                	li	a7,15
 ecall
 718:	00000073          	ecall
 ret
 71c:	8082                	ret

000000000000071e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 71e:	48c5                	li	a7,17
 ecall
 720:	00000073          	ecall
 ret
 724:	8082                	ret

0000000000000726 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 726:	48c9                	li	a7,18
 ecall
 728:	00000073          	ecall
 ret
 72c:	8082                	ret

000000000000072e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 72e:	48a1                	li	a7,8
 ecall
 730:	00000073          	ecall
 ret
 734:	8082                	ret

0000000000000736 <link>:
.global link
link:
 li a7, SYS_link
 736:	48cd                	li	a7,19
 ecall
 738:	00000073          	ecall
 ret
 73c:	8082                	ret

000000000000073e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 73e:	48d1                	li	a7,20
 ecall
 740:	00000073          	ecall
 ret
 744:	8082                	ret

0000000000000746 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 746:	48a5                	li	a7,9
 ecall
 748:	00000073          	ecall
 ret
 74c:	8082                	ret

000000000000074e <dup>:
.global dup
dup:
 li a7, SYS_dup
 74e:	48a9                	li	a7,10
 ecall
 750:	00000073          	ecall
 ret
 754:	8082                	ret

0000000000000756 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 756:	48ad                	li	a7,11
 ecall
 758:	00000073          	ecall
 ret
 75c:	8082                	ret

000000000000075e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 75e:	48b1                	li	a7,12
 ecall
 760:	00000073          	ecall
 ret
 764:	8082                	ret

0000000000000766 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 766:	48b5                	li	a7,13
 ecall
 768:	00000073          	ecall
 ret
 76c:	8082                	ret

000000000000076e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 76e:	48b9                	li	a7,14
 ecall
 770:	00000073          	ecall
 ret
 774:	8082                	ret

0000000000000776 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 776:	1101                	addi	sp,sp,-32
 778:	ec06                	sd	ra,24(sp)
 77a:	e822                	sd	s0,16(sp)
 77c:	1000                	addi	s0,sp,32
 77e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 782:	4605                	li	a2,1
 784:	fef40593          	addi	a1,s0,-17
 788:	00000097          	auipc	ra,0x0
 78c:	f6e080e7          	jalr	-146(ra) # 6f6 <write>
}
 790:	60e2                	ld	ra,24(sp)
 792:	6442                	ld	s0,16(sp)
 794:	6105                	addi	sp,sp,32
 796:	8082                	ret

0000000000000798 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 798:	7139                	addi	sp,sp,-64
 79a:	fc06                	sd	ra,56(sp)
 79c:	f822                	sd	s0,48(sp)
 79e:	f426                	sd	s1,40(sp)
 7a0:	f04a                	sd	s2,32(sp)
 7a2:	ec4e                	sd	s3,24(sp)
 7a4:	0080                	addi	s0,sp,64
 7a6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 7a8:	c299                	beqz	a3,7ae <printint+0x16>
 7aa:	0805c963          	bltz	a1,83c <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 7ae:	2581                	sext.w	a1,a1
  neg = 0;
 7b0:	4881                	li	a7,0
 7b2:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 7b6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 7b8:	2601                	sext.w	a2,a2
 7ba:	00000517          	auipc	a0,0x0
 7be:	59650513          	addi	a0,a0,1430 # d50 <digits>
 7c2:	883a                	mv	a6,a4
 7c4:	2705                	addiw	a4,a4,1
 7c6:	02c5f7bb          	remuw	a5,a1,a2
 7ca:	1782                	slli	a5,a5,0x20
 7cc:	9381                	srli	a5,a5,0x20
 7ce:	97aa                	add	a5,a5,a0
 7d0:	0007c783          	lbu	a5,0(a5)
 7d4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 7d8:	0005879b          	sext.w	a5,a1
 7dc:	02c5d5bb          	divuw	a1,a1,a2
 7e0:	0685                	addi	a3,a3,1
 7e2:	fec7f0e3          	bgeu	a5,a2,7c2 <printint+0x2a>
  if(neg)
 7e6:	00088c63          	beqz	a7,7fe <printint+0x66>
    buf[i++] = '-';
 7ea:	fd070793          	addi	a5,a4,-48
 7ee:	00878733          	add	a4,a5,s0
 7f2:	02d00793          	li	a5,45
 7f6:	fef70823          	sb	a5,-16(a4)
 7fa:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 7fe:	02e05863          	blez	a4,82e <printint+0x96>
 802:	fc040793          	addi	a5,s0,-64
 806:	00e78933          	add	s2,a5,a4
 80a:	fff78993          	addi	s3,a5,-1
 80e:	99ba                	add	s3,s3,a4
 810:	377d                	addiw	a4,a4,-1
 812:	1702                	slli	a4,a4,0x20
 814:	9301                	srli	a4,a4,0x20
 816:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 81a:	fff94583          	lbu	a1,-1(s2)
 81e:	8526                	mv	a0,s1
 820:	00000097          	auipc	ra,0x0
 824:	f56080e7          	jalr	-170(ra) # 776 <putc>
  while(--i >= 0)
 828:	197d                	addi	s2,s2,-1
 82a:	ff3918e3          	bne	s2,s3,81a <printint+0x82>
}
 82e:	70e2                	ld	ra,56(sp)
 830:	7442                	ld	s0,48(sp)
 832:	74a2                	ld	s1,40(sp)
 834:	7902                	ld	s2,32(sp)
 836:	69e2                	ld	s3,24(sp)
 838:	6121                	addi	sp,sp,64
 83a:	8082                	ret
    x = -xx;
 83c:	40b005bb          	negw	a1,a1
    neg = 1;
 840:	4885                	li	a7,1
    x = -xx;
 842:	bf85                	j	7b2 <printint+0x1a>

0000000000000844 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 844:	7119                	addi	sp,sp,-128
 846:	fc86                	sd	ra,120(sp)
 848:	f8a2                	sd	s0,112(sp)
 84a:	f4a6                	sd	s1,104(sp)
 84c:	f0ca                	sd	s2,96(sp)
 84e:	ecce                	sd	s3,88(sp)
 850:	e8d2                	sd	s4,80(sp)
 852:	e4d6                	sd	s5,72(sp)
 854:	e0da                	sd	s6,64(sp)
 856:	fc5e                	sd	s7,56(sp)
 858:	f862                	sd	s8,48(sp)
 85a:	f466                	sd	s9,40(sp)
 85c:	f06a                	sd	s10,32(sp)
 85e:	ec6e                	sd	s11,24(sp)
 860:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 862:	0005c903          	lbu	s2,0(a1)
 866:	18090f63          	beqz	s2,a04 <vprintf+0x1c0>
 86a:	8aaa                	mv	s5,a0
 86c:	8b32                	mv	s6,a2
 86e:	00158493          	addi	s1,a1,1
  state = 0;
 872:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 874:	02500a13          	li	s4,37
 878:	4c55                	li	s8,21
 87a:	00000c97          	auipc	s9,0x0
 87e:	47ec8c93          	addi	s9,s9,1150 # cf8 <malloc+0x1f0>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 882:	02800d93          	li	s11,40
  putc(fd, 'x');
 886:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 888:	00000b97          	auipc	s7,0x0
 88c:	4c8b8b93          	addi	s7,s7,1224 # d50 <digits>
 890:	a839                	j	8ae <vprintf+0x6a>
        putc(fd, c);
 892:	85ca                	mv	a1,s2
 894:	8556                	mv	a0,s5
 896:	00000097          	auipc	ra,0x0
 89a:	ee0080e7          	jalr	-288(ra) # 776 <putc>
 89e:	a019                	j	8a4 <vprintf+0x60>
    } else if(state == '%'){
 8a0:	01498d63          	beq	s3,s4,8ba <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 8a4:	0485                	addi	s1,s1,1
 8a6:	fff4c903          	lbu	s2,-1(s1)
 8aa:	14090d63          	beqz	s2,a04 <vprintf+0x1c0>
    if(state == 0){
 8ae:	fe0999e3          	bnez	s3,8a0 <vprintf+0x5c>
      if(c == '%'){
 8b2:	ff4910e3          	bne	s2,s4,892 <vprintf+0x4e>
        state = '%';
 8b6:	89d2                	mv	s3,s4
 8b8:	b7f5                	j	8a4 <vprintf+0x60>
      if(c == 'd'){
 8ba:	11490c63          	beq	s2,s4,9d2 <vprintf+0x18e>
 8be:	f9d9079b          	addiw	a5,s2,-99
 8c2:	0ff7f793          	zext.b	a5,a5
 8c6:	10fc6e63          	bltu	s8,a5,9e2 <vprintf+0x19e>
 8ca:	f9d9079b          	addiw	a5,s2,-99
 8ce:	0ff7f713          	zext.b	a4,a5
 8d2:	10ec6863          	bltu	s8,a4,9e2 <vprintf+0x19e>
 8d6:	00271793          	slli	a5,a4,0x2
 8da:	97e6                	add	a5,a5,s9
 8dc:	439c                	lw	a5,0(a5)
 8de:	97e6                	add	a5,a5,s9
 8e0:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 8e2:	008b0913          	addi	s2,s6,8
 8e6:	4685                	li	a3,1
 8e8:	4629                	li	a2,10
 8ea:	000b2583          	lw	a1,0(s6)
 8ee:	8556                	mv	a0,s5
 8f0:	00000097          	auipc	ra,0x0
 8f4:	ea8080e7          	jalr	-344(ra) # 798 <printint>
 8f8:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 8fa:	4981                	li	s3,0
 8fc:	b765                	j	8a4 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8fe:	008b0913          	addi	s2,s6,8
 902:	4681                	li	a3,0
 904:	4629                	li	a2,10
 906:	000b2583          	lw	a1,0(s6)
 90a:	8556                	mv	a0,s5
 90c:	00000097          	auipc	ra,0x0
 910:	e8c080e7          	jalr	-372(ra) # 798 <printint>
 914:	8b4a                	mv	s6,s2
      state = 0;
 916:	4981                	li	s3,0
 918:	b771                	j	8a4 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 91a:	008b0913          	addi	s2,s6,8
 91e:	4681                	li	a3,0
 920:	866a                	mv	a2,s10
 922:	000b2583          	lw	a1,0(s6)
 926:	8556                	mv	a0,s5
 928:	00000097          	auipc	ra,0x0
 92c:	e70080e7          	jalr	-400(ra) # 798 <printint>
 930:	8b4a                	mv	s6,s2
      state = 0;
 932:	4981                	li	s3,0
 934:	bf85                	j	8a4 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 936:	008b0793          	addi	a5,s6,8
 93a:	f8f43423          	sd	a5,-120(s0)
 93e:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 942:	03000593          	li	a1,48
 946:	8556                	mv	a0,s5
 948:	00000097          	auipc	ra,0x0
 94c:	e2e080e7          	jalr	-466(ra) # 776 <putc>
  putc(fd, 'x');
 950:	07800593          	li	a1,120
 954:	8556                	mv	a0,s5
 956:	00000097          	auipc	ra,0x0
 95a:	e20080e7          	jalr	-480(ra) # 776 <putc>
 95e:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 960:	03c9d793          	srli	a5,s3,0x3c
 964:	97de                	add	a5,a5,s7
 966:	0007c583          	lbu	a1,0(a5)
 96a:	8556                	mv	a0,s5
 96c:	00000097          	auipc	ra,0x0
 970:	e0a080e7          	jalr	-502(ra) # 776 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 974:	0992                	slli	s3,s3,0x4
 976:	397d                	addiw	s2,s2,-1
 978:	fe0914e3          	bnez	s2,960 <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 97c:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 980:	4981                	li	s3,0
 982:	b70d                	j	8a4 <vprintf+0x60>
        s = va_arg(ap, char*);
 984:	008b0913          	addi	s2,s6,8
 988:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 98c:	02098163          	beqz	s3,9ae <vprintf+0x16a>
        while(*s != 0){
 990:	0009c583          	lbu	a1,0(s3)
 994:	c5ad                	beqz	a1,9fe <vprintf+0x1ba>
          putc(fd, *s);
 996:	8556                	mv	a0,s5
 998:	00000097          	auipc	ra,0x0
 99c:	dde080e7          	jalr	-546(ra) # 776 <putc>
          s++;
 9a0:	0985                	addi	s3,s3,1
        while(*s != 0){
 9a2:	0009c583          	lbu	a1,0(s3)
 9a6:	f9e5                	bnez	a1,996 <vprintf+0x152>
        s = va_arg(ap, char*);
 9a8:	8b4a                	mv	s6,s2
      state = 0;
 9aa:	4981                	li	s3,0
 9ac:	bde5                	j	8a4 <vprintf+0x60>
          s = "(null)";
 9ae:	00000997          	auipc	s3,0x0
 9b2:	34298993          	addi	s3,s3,834 # cf0 <malloc+0x1e8>
        while(*s != 0){
 9b6:	85ee                	mv	a1,s11
 9b8:	bff9                	j	996 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 9ba:	008b0913          	addi	s2,s6,8
 9be:	000b4583          	lbu	a1,0(s6)
 9c2:	8556                	mv	a0,s5
 9c4:	00000097          	auipc	ra,0x0
 9c8:	db2080e7          	jalr	-590(ra) # 776 <putc>
 9cc:	8b4a                	mv	s6,s2
      state = 0;
 9ce:	4981                	li	s3,0
 9d0:	bdd1                	j	8a4 <vprintf+0x60>
        putc(fd, c);
 9d2:	85d2                	mv	a1,s4
 9d4:	8556                	mv	a0,s5
 9d6:	00000097          	auipc	ra,0x0
 9da:	da0080e7          	jalr	-608(ra) # 776 <putc>
      state = 0;
 9de:	4981                	li	s3,0
 9e0:	b5d1                	j	8a4 <vprintf+0x60>
        putc(fd, '%');
 9e2:	85d2                	mv	a1,s4
 9e4:	8556                	mv	a0,s5
 9e6:	00000097          	auipc	ra,0x0
 9ea:	d90080e7          	jalr	-624(ra) # 776 <putc>
        putc(fd, c);
 9ee:	85ca                	mv	a1,s2
 9f0:	8556                	mv	a0,s5
 9f2:	00000097          	auipc	ra,0x0
 9f6:	d84080e7          	jalr	-636(ra) # 776 <putc>
      state = 0;
 9fa:	4981                	li	s3,0
 9fc:	b565                	j	8a4 <vprintf+0x60>
        s = va_arg(ap, char*);
 9fe:	8b4a                	mv	s6,s2
      state = 0;
 a00:	4981                	li	s3,0
 a02:	b54d                	j	8a4 <vprintf+0x60>
    }
  }
}
 a04:	70e6                	ld	ra,120(sp)
 a06:	7446                	ld	s0,112(sp)
 a08:	74a6                	ld	s1,104(sp)
 a0a:	7906                	ld	s2,96(sp)
 a0c:	69e6                	ld	s3,88(sp)
 a0e:	6a46                	ld	s4,80(sp)
 a10:	6aa6                	ld	s5,72(sp)
 a12:	6b06                	ld	s6,64(sp)
 a14:	7be2                	ld	s7,56(sp)
 a16:	7c42                	ld	s8,48(sp)
 a18:	7ca2                	ld	s9,40(sp)
 a1a:	7d02                	ld	s10,32(sp)
 a1c:	6de2                	ld	s11,24(sp)
 a1e:	6109                	addi	sp,sp,128
 a20:	8082                	ret

0000000000000a22 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a22:	715d                	addi	sp,sp,-80
 a24:	ec06                	sd	ra,24(sp)
 a26:	e822                	sd	s0,16(sp)
 a28:	1000                	addi	s0,sp,32
 a2a:	e010                	sd	a2,0(s0)
 a2c:	e414                	sd	a3,8(s0)
 a2e:	e818                	sd	a4,16(s0)
 a30:	ec1c                	sd	a5,24(s0)
 a32:	03043023          	sd	a6,32(s0)
 a36:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a3a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a3e:	8622                	mv	a2,s0
 a40:	00000097          	auipc	ra,0x0
 a44:	e04080e7          	jalr	-508(ra) # 844 <vprintf>
}
 a48:	60e2                	ld	ra,24(sp)
 a4a:	6442                	ld	s0,16(sp)
 a4c:	6161                	addi	sp,sp,80
 a4e:	8082                	ret

0000000000000a50 <printf>:

void
printf(const char *fmt, ...)
{
 a50:	711d                	addi	sp,sp,-96
 a52:	ec06                	sd	ra,24(sp)
 a54:	e822                	sd	s0,16(sp)
 a56:	1000                	addi	s0,sp,32
 a58:	e40c                	sd	a1,8(s0)
 a5a:	e810                	sd	a2,16(s0)
 a5c:	ec14                	sd	a3,24(s0)
 a5e:	f018                	sd	a4,32(s0)
 a60:	f41c                	sd	a5,40(s0)
 a62:	03043823          	sd	a6,48(s0)
 a66:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a6a:	00840613          	addi	a2,s0,8
 a6e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a72:	85aa                	mv	a1,a0
 a74:	4505                	li	a0,1
 a76:	00000097          	auipc	ra,0x0
 a7a:	dce080e7          	jalr	-562(ra) # 844 <vprintf>
}
 a7e:	60e2                	ld	ra,24(sp)
 a80:	6442                	ld	s0,16(sp)
 a82:	6125                	addi	sp,sp,96
 a84:	8082                	ret

0000000000000a86 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a86:	1141                	addi	sp,sp,-16
 a88:	e422                	sd	s0,8(sp)
 a8a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a8c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a90:	00000797          	auipc	a5,0x0
 a94:	2f87b783          	ld	a5,760(a5) # d88 <freep>
 a98:	a02d                	j	ac2 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a9a:	4618                	lw	a4,8(a2)
 a9c:	9f2d                	addw	a4,a4,a1
 a9e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 aa2:	6398                	ld	a4,0(a5)
 aa4:	6310                	ld	a2,0(a4)
 aa6:	a83d                	j	ae4 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 aa8:	ff852703          	lw	a4,-8(a0)
 aac:	9f31                	addw	a4,a4,a2
 aae:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 ab0:	ff053683          	ld	a3,-16(a0)
 ab4:	a091                	j	af8 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ab6:	6398                	ld	a4,0(a5)
 ab8:	00e7e463          	bltu	a5,a4,ac0 <free+0x3a>
 abc:	00e6ea63          	bltu	a3,a4,ad0 <free+0x4a>
{
 ac0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ac2:	fed7fae3          	bgeu	a5,a3,ab6 <free+0x30>
 ac6:	6398                	ld	a4,0(a5)
 ac8:	00e6e463          	bltu	a3,a4,ad0 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 acc:	fee7eae3          	bltu	a5,a4,ac0 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 ad0:	ff852583          	lw	a1,-8(a0)
 ad4:	6390                	ld	a2,0(a5)
 ad6:	02059813          	slli	a6,a1,0x20
 ada:	01c85713          	srli	a4,a6,0x1c
 ade:	9736                	add	a4,a4,a3
 ae0:	fae60de3          	beq	a2,a4,a9a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 ae4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 ae8:	4790                	lw	a2,8(a5)
 aea:	02061593          	slli	a1,a2,0x20
 aee:	01c5d713          	srli	a4,a1,0x1c
 af2:	973e                	add	a4,a4,a5
 af4:	fae68ae3          	beq	a3,a4,aa8 <free+0x22>
    p->s.ptr = bp->s.ptr;
 af8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 afa:	00000717          	auipc	a4,0x0
 afe:	28f73723          	sd	a5,654(a4) # d88 <freep>
}
 b02:	6422                	ld	s0,8(sp)
 b04:	0141                	addi	sp,sp,16
 b06:	8082                	ret

0000000000000b08 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b08:	7139                	addi	sp,sp,-64
 b0a:	fc06                	sd	ra,56(sp)
 b0c:	f822                	sd	s0,48(sp)
 b0e:	f426                	sd	s1,40(sp)
 b10:	f04a                	sd	s2,32(sp)
 b12:	ec4e                	sd	s3,24(sp)
 b14:	e852                	sd	s4,16(sp)
 b16:	e456                	sd	s5,8(sp)
 b18:	e05a                	sd	s6,0(sp)
 b1a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b1c:	02051493          	slli	s1,a0,0x20
 b20:	9081                	srli	s1,s1,0x20
 b22:	04bd                	addi	s1,s1,15
 b24:	8091                	srli	s1,s1,0x4
 b26:	0014899b          	addiw	s3,s1,1
 b2a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 b2c:	00000517          	auipc	a0,0x0
 b30:	25c53503          	ld	a0,604(a0) # d88 <freep>
 b34:	c515                	beqz	a0,b60 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b36:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b38:	4798                	lw	a4,8(a5)
 b3a:	02977f63          	bgeu	a4,s1,b78 <malloc+0x70>
 b3e:	8a4e                	mv	s4,s3
 b40:	0009871b          	sext.w	a4,s3
 b44:	6685                	lui	a3,0x1
 b46:	00d77363          	bgeu	a4,a3,b4c <malloc+0x44>
 b4a:	6a05                	lui	s4,0x1
 b4c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b50:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b54:	00000917          	auipc	s2,0x0
 b58:	23490913          	addi	s2,s2,564 # d88 <freep>
  if(p == (char*)-1)
 b5c:	5afd                	li	s5,-1
 b5e:	a895                	j	bd2 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 b60:	00008797          	auipc	a5,0x8
 b64:	41078793          	addi	a5,a5,1040 # 8f70 <base>
 b68:	00000717          	auipc	a4,0x0
 b6c:	22f73023          	sd	a5,544(a4) # d88 <freep>
 b70:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b72:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b76:	b7e1                	j	b3e <malloc+0x36>
      if(p->s.size == nunits)
 b78:	02e48c63          	beq	s1,a4,bb0 <malloc+0xa8>
        p->s.size -= nunits;
 b7c:	4137073b          	subw	a4,a4,s3
 b80:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b82:	02071693          	slli	a3,a4,0x20
 b86:	01c6d713          	srli	a4,a3,0x1c
 b8a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b8c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b90:	00000717          	auipc	a4,0x0
 b94:	1ea73c23          	sd	a0,504(a4) # d88 <freep>
      return (void*)(p + 1);
 b98:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 b9c:	70e2                	ld	ra,56(sp)
 b9e:	7442                	ld	s0,48(sp)
 ba0:	74a2                	ld	s1,40(sp)
 ba2:	7902                	ld	s2,32(sp)
 ba4:	69e2                	ld	s3,24(sp)
 ba6:	6a42                	ld	s4,16(sp)
 ba8:	6aa2                	ld	s5,8(sp)
 baa:	6b02                	ld	s6,0(sp)
 bac:	6121                	addi	sp,sp,64
 bae:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 bb0:	6398                	ld	a4,0(a5)
 bb2:	e118                	sd	a4,0(a0)
 bb4:	bff1                	j	b90 <malloc+0x88>
  hp->s.size = nu;
 bb6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 bba:	0541                	addi	a0,a0,16
 bbc:	00000097          	auipc	ra,0x0
 bc0:	eca080e7          	jalr	-310(ra) # a86 <free>
  return freep;
 bc4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 bc8:	d971                	beqz	a0,b9c <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bca:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 bcc:	4798                	lw	a4,8(a5)
 bce:	fa9775e3          	bgeu	a4,s1,b78 <malloc+0x70>
    if(p == freep)
 bd2:	00093703          	ld	a4,0(s2)
 bd6:	853e                	mv	a0,a5
 bd8:	fef719e3          	bne	a4,a5,bca <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 bdc:	8552                	mv	a0,s4
 bde:	00000097          	auipc	ra,0x0
 be2:	b80080e7          	jalr	-1152(ra) # 75e <sbrk>
  if(p == (char*)-1)
 be6:	fd5518e3          	bne	a0,s5,bb6 <malloc+0xae>
        return 0;
 bea:	4501                	li	a0,0
 bec:	bf45                	j	b9c <malloc+0x94>
