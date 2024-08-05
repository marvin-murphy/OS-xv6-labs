
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	a7013103          	ld	sp,-1424(sp) # 80008a70 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	23d050ef          	jal	ra,80005a52 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00026797          	auipc	a5,0x26
    80000034:	21078793          	addi	a5,a5,528 # 80026240 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	17c080e7          	jalr	380(ra) # 800001c4 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	fe090913          	addi	s2,s2,-32 # 80009030 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	3de080e7          	jalr	990(ra) # 80006438 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	47e080e7          	jalr	1150(ra) # 800064ec <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	e76080e7          	jalr	-394(ra) # 80005f00 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	00e504b3          	add	s1,a0,a4
    800000ac:	777d                	lui	a4,0xfffff
    800000ae:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b0:	94be                	add	s1,s1,a5
    800000b2:	0095ee63          	bltu	a1,s1,800000ce <freerange+0x3c>
    800000b6:	892e                	mv	s2,a1
    kfree(p);
    800000b8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ba:	6985                	lui	s3,0x1
    kfree(p);
    800000bc:	01448533          	add	a0,s1,s4
    800000c0:	00000097          	auipc	ra,0x0
    800000c4:	f5c080e7          	jalr	-164(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c8:	94ce                	add	s1,s1,s3
    800000ca:	fe9979e3          	bgeu	s2,s1,800000bc <freerange+0x2a>
}
    800000ce:	70a2                	ld	ra,40(sp)
    800000d0:	7402                	ld	s0,32(sp)
    800000d2:	64e2                	ld	s1,24(sp)
    800000d4:	6942                	ld	s2,16(sp)
    800000d6:	69a2                	ld	s3,8(sp)
    800000d8:	6a02                	ld	s4,0(sp)
    800000da:	6145                	addi	sp,sp,48
    800000dc:	8082                	ret

00000000800000de <kinit>:
{
    800000de:	1141                	addi	sp,sp,-16
    800000e0:	e406                	sd	ra,8(sp)
    800000e2:	e022                	sd	s0,0(sp)
    800000e4:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e6:	00008597          	auipc	a1,0x8
    800000ea:	f3258593          	addi	a1,a1,-206 # 80008018 <etext+0x18>
    800000ee:	00009517          	auipc	a0,0x9
    800000f2:	f4250513          	addi	a0,a0,-190 # 80009030 <kmem>
    800000f6:	00006097          	auipc	ra,0x6
    800000fa:	2b2080e7          	jalr	690(ra) # 800063a8 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fe:	45c5                	li	a1,17
    80000100:	05ee                	slli	a1,a1,0x1b
    80000102:	00026517          	auipc	a0,0x26
    80000106:	13e50513          	addi	a0,a0,318 # 80026240 <end>
    8000010a:	00000097          	auipc	ra,0x0
    8000010e:	f88080e7          	jalr	-120(ra) # 80000092 <freerange>
}
    80000112:	60a2                	ld	ra,8(sp)
    80000114:	6402                	ld	s0,0(sp)
    80000116:	0141                	addi	sp,sp,16
    80000118:	8082                	ret

000000008000011a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000011a:	1101                	addi	sp,sp,-32
    8000011c:	ec06                	sd	ra,24(sp)
    8000011e:	e822                	sd	s0,16(sp)
    80000120:	e426                	sd	s1,8(sp)
    80000122:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000124:	00009497          	auipc	s1,0x9
    80000128:	f0c48493          	addi	s1,s1,-244 # 80009030 <kmem>
    8000012c:	8526                	mv	a0,s1
    8000012e:	00006097          	auipc	ra,0x6
    80000132:	30a080e7          	jalr	778(ra) # 80006438 <acquire>
  r = kmem.freelist;
    80000136:	6c84                	ld	s1,24(s1)
  if(r)
    80000138:	c885                	beqz	s1,80000168 <kalloc+0x4e>
    kmem.freelist = r->next;
    8000013a:	609c                	ld	a5,0(s1)
    8000013c:	00009517          	auipc	a0,0x9
    80000140:	ef450513          	addi	a0,a0,-268 # 80009030 <kmem>
    80000144:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000146:	00006097          	auipc	ra,0x6
    8000014a:	3a6080e7          	jalr	934(ra) # 800064ec <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014e:	6605                	lui	a2,0x1
    80000150:	4595                	li	a1,5
    80000152:	8526                	mv	a0,s1
    80000154:	00000097          	auipc	ra,0x0
    80000158:	070080e7          	jalr	112(ra) # 800001c4 <memset>
  return (void*)r;
}
    8000015c:	8526                	mv	a0,s1
    8000015e:	60e2                	ld	ra,24(sp)
    80000160:	6442                	ld	s0,16(sp)
    80000162:	64a2                	ld	s1,8(sp)
    80000164:	6105                	addi	sp,sp,32
    80000166:	8082                	ret
  release(&kmem.lock);
    80000168:	00009517          	auipc	a0,0x9
    8000016c:	ec850513          	addi	a0,a0,-312 # 80009030 <kmem>
    80000170:	00006097          	auipc	ra,0x6
    80000174:	37c080e7          	jalr	892(ra) # 800064ec <release>
  if(r)
    80000178:	b7d5                	j	8000015c <kalloc+0x42>

000000008000017a <free_mem>:

uint64
free_mem(void)
{
    8000017a:	1101                	addi	sp,sp,-32
    8000017c:	ec06                	sd	ra,24(sp)
    8000017e:	e822                	sd	s0,16(sp)
    80000180:	e426                	sd	s1,8(sp)
    80000182:	1000                	addi	s0,sp,32
  struct run *r;
  uint64 num = 0;

  acquire(&kmem.lock);
    80000184:	00009497          	auipc	s1,0x9
    80000188:	eac48493          	addi	s1,s1,-340 # 80009030 <kmem>
    8000018c:	8526                	mv	a0,s1
    8000018e:	00006097          	auipc	ra,0x6
    80000192:	2aa080e7          	jalr	682(ra) # 80006438 <acquire>
  r=kmem.freelist;
    80000196:	6c9c                	ld	a5,24(s1)
  while(r){
    80000198:	c785                	beqz	a5,800001c0 <free_mem+0x46>
  uint64 num = 0;
    8000019a:	4481                	li	s1,0
    num++;
    8000019c:	0485                	addi	s1,s1,1
    r=r->next;
    8000019e:	639c                	ld	a5,0(a5)
  while(r){
    800001a0:	fff5                	bnez	a5,8000019c <free_mem+0x22>
  }

  release(&kmem.lock);
    800001a2:	00009517          	auipc	a0,0x9
    800001a6:	e8e50513          	addi	a0,a0,-370 # 80009030 <kmem>
    800001aa:	00006097          	auipc	ra,0x6
    800001ae:	342080e7          	jalr	834(ra) # 800064ec <release>
  return num*PGSIZE;
}
    800001b2:	00c49513          	slli	a0,s1,0xc
    800001b6:	60e2                	ld	ra,24(sp)
    800001b8:	6442                	ld	s0,16(sp)
    800001ba:	64a2                	ld	s1,8(sp)
    800001bc:	6105                	addi	sp,sp,32
    800001be:	8082                	ret
  uint64 num = 0;
    800001c0:	4481                	li	s1,0
    800001c2:	b7c5                	j	800001a2 <free_mem+0x28>

00000000800001c4 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800001c4:	1141                	addi	sp,sp,-16
    800001c6:	e422                	sd	s0,8(sp)
    800001c8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800001ca:	ca19                	beqz	a2,800001e0 <memset+0x1c>
    800001cc:	87aa                	mv	a5,a0
    800001ce:	1602                	slli	a2,a2,0x20
    800001d0:	9201                	srli	a2,a2,0x20
    800001d2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    800001d6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800001da:	0785                	addi	a5,a5,1
    800001dc:	fee79de3          	bne	a5,a4,800001d6 <memset+0x12>
  }
  return dst;
}
    800001e0:	6422                	ld	s0,8(sp)
    800001e2:	0141                	addi	sp,sp,16
    800001e4:	8082                	ret

00000000800001e6 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800001e6:	1141                	addi	sp,sp,-16
    800001e8:	e422                	sd	s0,8(sp)
    800001ea:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001ec:	ca05                	beqz	a2,8000021c <memcmp+0x36>
    800001ee:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001f2:	1682                	slli	a3,a3,0x20
    800001f4:	9281                	srli	a3,a3,0x20
    800001f6:	0685                	addi	a3,a3,1
    800001f8:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001fa:	00054783          	lbu	a5,0(a0)
    800001fe:	0005c703          	lbu	a4,0(a1)
    80000202:	00e79863          	bne	a5,a4,80000212 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000206:	0505                	addi	a0,a0,1
    80000208:	0585                	addi	a1,a1,1
  while(n-- > 0){
    8000020a:	fed518e3          	bne	a0,a3,800001fa <memcmp+0x14>
  }

  return 0;
    8000020e:	4501                	li	a0,0
    80000210:	a019                	j	80000216 <memcmp+0x30>
      return *s1 - *s2;
    80000212:	40e7853b          	subw	a0,a5,a4
}
    80000216:	6422                	ld	s0,8(sp)
    80000218:	0141                	addi	sp,sp,16
    8000021a:	8082                	ret
  return 0;
    8000021c:	4501                	li	a0,0
    8000021e:	bfe5                	j	80000216 <memcmp+0x30>

0000000080000220 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000220:	1141                	addi	sp,sp,-16
    80000222:	e422                	sd	s0,8(sp)
    80000224:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000226:	c205                	beqz	a2,80000246 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000228:	02a5e263          	bltu	a1,a0,8000024c <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    8000022c:	1602                	slli	a2,a2,0x20
    8000022e:	9201                	srli	a2,a2,0x20
    80000230:	00c587b3          	add	a5,a1,a2
{
    80000234:	872a                	mv	a4,a0
      *d++ = *s++;
    80000236:	0585                	addi	a1,a1,1
    80000238:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffd8dc1>
    8000023a:	fff5c683          	lbu	a3,-1(a1)
    8000023e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000242:	fef59ae3          	bne	a1,a5,80000236 <memmove+0x16>

  return dst;
}
    80000246:	6422                	ld	s0,8(sp)
    80000248:	0141                	addi	sp,sp,16
    8000024a:	8082                	ret
  if(s < d && s + n > d){
    8000024c:	02061693          	slli	a3,a2,0x20
    80000250:	9281                	srli	a3,a3,0x20
    80000252:	00d58733          	add	a4,a1,a3
    80000256:	fce57be3          	bgeu	a0,a4,8000022c <memmove+0xc>
    d += n;
    8000025a:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    8000025c:	fff6079b          	addiw	a5,a2,-1
    80000260:	1782                	slli	a5,a5,0x20
    80000262:	9381                	srli	a5,a5,0x20
    80000264:	fff7c793          	not	a5,a5
    80000268:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000026a:	177d                	addi	a4,a4,-1
    8000026c:	16fd                	addi	a3,a3,-1
    8000026e:	00074603          	lbu	a2,0(a4)
    80000272:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000276:	fee79ae3          	bne	a5,a4,8000026a <memmove+0x4a>
    8000027a:	b7f1                	j	80000246 <memmove+0x26>

000000008000027c <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    8000027c:	1141                	addi	sp,sp,-16
    8000027e:	e406                	sd	ra,8(sp)
    80000280:	e022                	sd	s0,0(sp)
    80000282:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000284:	00000097          	auipc	ra,0x0
    80000288:	f9c080e7          	jalr	-100(ra) # 80000220 <memmove>
}
    8000028c:	60a2                	ld	ra,8(sp)
    8000028e:	6402                	ld	s0,0(sp)
    80000290:	0141                	addi	sp,sp,16
    80000292:	8082                	ret

0000000080000294 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000294:	1141                	addi	sp,sp,-16
    80000296:	e422                	sd	s0,8(sp)
    80000298:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000029a:	ce11                	beqz	a2,800002b6 <strncmp+0x22>
    8000029c:	00054783          	lbu	a5,0(a0)
    800002a0:	cf89                	beqz	a5,800002ba <strncmp+0x26>
    800002a2:	0005c703          	lbu	a4,0(a1)
    800002a6:	00f71a63          	bne	a4,a5,800002ba <strncmp+0x26>
    n--, p++, q++;
    800002aa:	367d                	addiw	a2,a2,-1
    800002ac:	0505                	addi	a0,a0,1
    800002ae:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    800002b0:	f675                	bnez	a2,8000029c <strncmp+0x8>
  if(n == 0)
    return 0;
    800002b2:	4501                	li	a0,0
    800002b4:	a809                	j	800002c6 <strncmp+0x32>
    800002b6:	4501                	li	a0,0
    800002b8:	a039                	j	800002c6 <strncmp+0x32>
  if(n == 0)
    800002ba:	ca09                	beqz	a2,800002cc <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    800002bc:	00054503          	lbu	a0,0(a0)
    800002c0:	0005c783          	lbu	a5,0(a1)
    800002c4:	9d1d                	subw	a0,a0,a5
}
    800002c6:	6422                	ld	s0,8(sp)
    800002c8:	0141                	addi	sp,sp,16
    800002ca:	8082                	ret
    return 0;
    800002cc:	4501                	li	a0,0
    800002ce:	bfe5                	j	800002c6 <strncmp+0x32>

00000000800002d0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800002d0:	1141                	addi	sp,sp,-16
    800002d2:	e422                	sd	s0,8(sp)
    800002d4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800002d6:	872a                	mv	a4,a0
    800002d8:	8832                	mv	a6,a2
    800002da:	367d                	addiw	a2,a2,-1
    800002dc:	01005963          	blez	a6,800002ee <strncpy+0x1e>
    800002e0:	0705                	addi	a4,a4,1
    800002e2:	0005c783          	lbu	a5,0(a1)
    800002e6:	fef70fa3          	sb	a5,-1(a4)
    800002ea:	0585                	addi	a1,a1,1
    800002ec:	f7f5                	bnez	a5,800002d8 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002ee:	86ba                	mv	a3,a4
    800002f0:	00c05c63          	blez	a2,80000308 <strncpy+0x38>
    *s++ = 0;
    800002f4:	0685                	addi	a3,a3,1
    800002f6:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002fa:	40d707bb          	subw	a5,a4,a3
    800002fe:	37fd                	addiw	a5,a5,-1
    80000300:	010787bb          	addw	a5,a5,a6
    80000304:	fef048e3          	bgtz	a5,800002f4 <strncpy+0x24>
  return os;
}
    80000308:	6422                	ld	s0,8(sp)
    8000030a:	0141                	addi	sp,sp,16
    8000030c:	8082                	ret

000000008000030e <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    8000030e:	1141                	addi	sp,sp,-16
    80000310:	e422                	sd	s0,8(sp)
    80000312:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000314:	02c05363          	blez	a2,8000033a <safestrcpy+0x2c>
    80000318:	fff6069b          	addiw	a3,a2,-1
    8000031c:	1682                	slli	a3,a3,0x20
    8000031e:	9281                	srli	a3,a3,0x20
    80000320:	96ae                	add	a3,a3,a1
    80000322:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000324:	00d58963          	beq	a1,a3,80000336 <safestrcpy+0x28>
    80000328:	0585                	addi	a1,a1,1
    8000032a:	0785                	addi	a5,a5,1
    8000032c:	fff5c703          	lbu	a4,-1(a1)
    80000330:	fee78fa3          	sb	a4,-1(a5)
    80000334:	fb65                	bnez	a4,80000324 <safestrcpy+0x16>
    ;
  *s = 0;
    80000336:	00078023          	sb	zero,0(a5)
  return os;
}
    8000033a:	6422                	ld	s0,8(sp)
    8000033c:	0141                	addi	sp,sp,16
    8000033e:	8082                	ret

0000000080000340 <strlen>:

int
strlen(const char *s)
{
    80000340:	1141                	addi	sp,sp,-16
    80000342:	e422                	sd	s0,8(sp)
    80000344:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000346:	00054783          	lbu	a5,0(a0)
    8000034a:	cf91                	beqz	a5,80000366 <strlen+0x26>
    8000034c:	0505                	addi	a0,a0,1
    8000034e:	87aa                	mv	a5,a0
    80000350:	4685                	li	a3,1
    80000352:	9e89                	subw	a3,a3,a0
    80000354:	00f6853b          	addw	a0,a3,a5
    80000358:	0785                	addi	a5,a5,1
    8000035a:	fff7c703          	lbu	a4,-1(a5)
    8000035e:	fb7d                	bnez	a4,80000354 <strlen+0x14>
    ;
  return n;
}
    80000360:	6422                	ld	s0,8(sp)
    80000362:	0141                	addi	sp,sp,16
    80000364:	8082                	ret
  for(n = 0; s[n]; n++)
    80000366:	4501                	li	a0,0
    80000368:	bfe5                	j	80000360 <strlen+0x20>

000000008000036a <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000036a:	1141                	addi	sp,sp,-16
    8000036c:	e406                	sd	ra,8(sp)
    8000036e:	e022                	sd	s0,0(sp)
    80000370:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000372:	00001097          	auipc	ra,0x1
    80000376:	be8080e7          	jalr	-1048(ra) # 80000f5a <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    8000037a:	00009717          	auipc	a4,0x9
    8000037e:	c8670713          	addi	a4,a4,-890 # 80009000 <started>
  if(cpuid() == 0){
    80000382:	c139                	beqz	a0,800003c8 <main+0x5e>
    while(started == 0)
    80000384:	431c                	lw	a5,0(a4)
    80000386:	2781                	sext.w	a5,a5
    80000388:	dff5                	beqz	a5,80000384 <main+0x1a>
      ;
    __sync_synchronize();
    8000038a:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000038e:	00001097          	auipc	ra,0x1
    80000392:	bcc080e7          	jalr	-1076(ra) # 80000f5a <cpuid>
    80000396:	85aa                	mv	a1,a0
    80000398:	00008517          	auipc	a0,0x8
    8000039c:	ca050513          	addi	a0,a0,-864 # 80008038 <etext+0x38>
    800003a0:	00006097          	auipc	ra,0x6
    800003a4:	baa080e7          	jalr	-1110(ra) # 80005f4a <printf>
    kvminithart();    // turn on paging
    800003a8:	00000097          	auipc	ra,0x0
    800003ac:	0d8080e7          	jalr	216(ra) # 80000480 <kvminithart>
    trapinithart();   // install kernel trap vector
    800003b0:	00002097          	auipc	ra,0x2
    800003b4:	936080e7          	jalr	-1738(ra) # 80001ce6 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800003b8:	00005097          	auipc	ra,0x5
    800003bc:	078080e7          	jalr	120(ra) # 80005430 <plicinithart>
  }

  scheduler();        
    800003c0:	00001097          	auipc	ra,0x1
    800003c4:	18e080e7          	jalr	398(ra) # 8000154e <scheduler>
    consoleinit();
    800003c8:	00006097          	auipc	ra,0x6
    800003cc:	a48080e7          	jalr	-1464(ra) # 80005e10 <consoleinit>
    printfinit();
    800003d0:	00006097          	auipc	ra,0x6
    800003d4:	d5a080e7          	jalr	-678(ra) # 8000612a <printfinit>
    printf("\n");
    800003d8:	00008517          	auipc	a0,0x8
    800003dc:	c7050513          	addi	a0,a0,-912 # 80008048 <etext+0x48>
    800003e0:	00006097          	auipc	ra,0x6
    800003e4:	b6a080e7          	jalr	-1174(ra) # 80005f4a <printf>
    printf("xv6 kernel is booting\n");
    800003e8:	00008517          	auipc	a0,0x8
    800003ec:	c3850513          	addi	a0,a0,-968 # 80008020 <etext+0x20>
    800003f0:	00006097          	auipc	ra,0x6
    800003f4:	b5a080e7          	jalr	-1190(ra) # 80005f4a <printf>
    printf("\n");
    800003f8:	00008517          	auipc	a0,0x8
    800003fc:	c5050513          	addi	a0,a0,-944 # 80008048 <etext+0x48>
    80000400:	00006097          	auipc	ra,0x6
    80000404:	b4a080e7          	jalr	-1206(ra) # 80005f4a <printf>
    kinit();         // physical page allocator
    80000408:	00000097          	auipc	ra,0x0
    8000040c:	cd6080e7          	jalr	-810(ra) # 800000de <kinit>
    kvminit();       // create kernel page table
    80000410:	00000097          	auipc	ra,0x0
    80000414:	322080e7          	jalr	802(ra) # 80000732 <kvminit>
    kvminithart();   // turn on paging
    80000418:	00000097          	auipc	ra,0x0
    8000041c:	068080e7          	jalr	104(ra) # 80000480 <kvminithart>
    procinit();      // process table
    80000420:	00001097          	auipc	ra,0x1
    80000424:	a8c080e7          	jalr	-1396(ra) # 80000eac <procinit>
    trapinit();      // trap vectors
    80000428:	00002097          	auipc	ra,0x2
    8000042c:	896080e7          	jalr	-1898(ra) # 80001cbe <trapinit>
    trapinithart();  // install kernel trap vector
    80000430:	00002097          	auipc	ra,0x2
    80000434:	8b6080e7          	jalr	-1866(ra) # 80001ce6 <trapinithart>
    plicinit();      // set up interrupt controller
    80000438:	00005097          	auipc	ra,0x5
    8000043c:	fe2080e7          	jalr	-30(ra) # 8000541a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000440:	00005097          	auipc	ra,0x5
    80000444:	ff0080e7          	jalr	-16(ra) # 80005430 <plicinithart>
    binit();         // buffer cache
    80000448:	00002097          	auipc	ra,0x2
    8000044c:	1a0080e7          	jalr	416(ra) # 800025e8 <binit>
    iinit();         // inode table
    80000450:	00003097          	auipc	ra,0x3
    80000454:	82e080e7          	jalr	-2002(ra) # 80002c7e <iinit>
    fileinit();      // file table
    80000458:	00003097          	auipc	ra,0x3
    8000045c:	7e0080e7          	jalr	2016(ra) # 80003c38 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000460:	00005097          	auipc	ra,0x5
    80000464:	0f0080e7          	jalr	240(ra) # 80005550 <virtio_disk_init>
    userinit();      // first user process
    80000468:	00001097          	auipc	ra,0x1
    8000046c:	ea4080e7          	jalr	-348(ra) # 8000130c <userinit>
    __sync_synchronize();
    80000470:	0ff0000f          	fence
    started = 1;
    80000474:	4785                	li	a5,1
    80000476:	00009717          	auipc	a4,0x9
    8000047a:	b8f72523          	sw	a5,-1142(a4) # 80009000 <started>
    8000047e:	b789                	j	800003c0 <main+0x56>

0000000080000480 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000480:	1141                	addi	sp,sp,-16
    80000482:	e422                	sd	s0,8(sp)
    80000484:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000486:	00009797          	auipc	a5,0x9
    8000048a:	b827b783          	ld	a5,-1150(a5) # 80009008 <kernel_pagetable>
    8000048e:	83b1                	srli	a5,a5,0xc
    80000490:	577d                	li	a4,-1
    80000492:	177e                	slli	a4,a4,0x3f
    80000494:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    80000496:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000049a:	12000073          	sfence.vma
  sfence_vma();
}
    8000049e:	6422                	ld	s0,8(sp)
    800004a0:	0141                	addi	sp,sp,16
    800004a2:	8082                	ret

00000000800004a4 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800004a4:	7139                	addi	sp,sp,-64
    800004a6:	fc06                	sd	ra,56(sp)
    800004a8:	f822                	sd	s0,48(sp)
    800004aa:	f426                	sd	s1,40(sp)
    800004ac:	f04a                	sd	s2,32(sp)
    800004ae:	ec4e                	sd	s3,24(sp)
    800004b0:	e852                	sd	s4,16(sp)
    800004b2:	e456                	sd	s5,8(sp)
    800004b4:	e05a                	sd	s6,0(sp)
    800004b6:	0080                	addi	s0,sp,64
    800004b8:	84aa                	mv	s1,a0
    800004ba:	89ae                	mv	s3,a1
    800004bc:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800004be:	57fd                	li	a5,-1
    800004c0:	83e9                	srli	a5,a5,0x1a
    800004c2:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800004c4:	4b31                	li	s6,12
  if(va >= MAXVA)
    800004c6:	04b7f263          	bgeu	a5,a1,8000050a <walk+0x66>
    panic("walk");
    800004ca:	00008517          	auipc	a0,0x8
    800004ce:	b8650513          	addi	a0,a0,-1146 # 80008050 <etext+0x50>
    800004d2:	00006097          	auipc	ra,0x6
    800004d6:	a2e080e7          	jalr	-1490(ra) # 80005f00 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800004da:	060a8663          	beqz	s5,80000546 <walk+0xa2>
    800004de:	00000097          	auipc	ra,0x0
    800004e2:	c3c080e7          	jalr	-964(ra) # 8000011a <kalloc>
    800004e6:	84aa                	mv	s1,a0
    800004e8:	c529                	beqz	a0,80000532 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004ea:	6605                	lui	a2,0x1
    800004ec:	4581                	li	a1,0
    800004ee:	00000097          	auipc	ra,0x0
    800004f2:	cd6080e7          	jalr	-810(ra) # 800001c4 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004f6:	00c4d793          	srli	a5,s1,0xc
    800004fa:	07aa                	slli	a5,a5,0xa
    800004fc:	0017e793          	ori	a5,a5,1
    80000500:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000504:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd8db7>
    80000506:	036a0063          	beq	s4,s6,80000526 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    8000050a:	0149d933          	srl	s2,s3,s4
    8000050e:	1ff97913          	andi	s2,s2,511
    80000512:	090e                	slli	s2,s2,0x3
    80000514:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000516:	00093483          	ld	s1,0(s2)
    8000051a:	0014f793          	andi	a5,s1,1
    8000051e:	dfd5                	beqz	a5,800004da <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000520:	80a9                	srli	s1,s1,0xa
    80000522:	04b2                	slli	s1,s1,0xc
    80000524:	b7c5                	j	80000504 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80000526:	00c9d513          	srli	a0,s3,0xc
    8000052a:	1ff57513          	andi	a0,a0,511
    8000052e:	050e                	slli	a0,a0,0x3
    80000530:	9526                	add	a0,a0,s1
}
    80000532:	70e2                	ld	ra,56(sp)
    80000534:	7442                	ld	s0,48(sp)
    80000536:	74a2                	ld	s1,40(sp)
    80000538:	7902                	ld	s2,32(sp)
    8000053a:	69e2                	ld	s3,24(sp)
    8000053c:	6a42                	ld	s4,16(sp)
    8000053e:	6aa2                	ld	s5,8(sp)
    80000540:	6b02                	ld	s6,0(sp)
    80000542:	6121                	addi	sp,sp,64
    80000544:	8082                	ret
        return 0;
    80000546:	4501                	li	a0,0
    80000548:	b7ed                	j	80000532 <walk+0x8e>

000000008000054a <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000054a:	57fd                	li	a5,-1
    8000054c:	83e9                	srli	a5,a5,0x1a
    8000054e:	00b7f463          	bgeu	a5,a1,80000556 <walkaddr+0xc>
    return 0;
    80000552:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000554:	8082                	ret
{
    80000556:	1141                	addi	sp,sp,-16
    80000558:	e406                	sd	ra,8(sp)
    8000055a:	e022                	sd	s0,0(sp)
    8000055c:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000055e:	4601                	li	a2,0
    80000560:	00000097          	auipc	ra,0x0
    80000564:	f44080e7          	jalr	-188(ra) # 800004a4 <walk>
  if(pte == 0)
    80000568:	c105                	beqz	a0,80000588 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000056a:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000056c:	0117f693          	andi	a3,a5,17
    80000570:	4745                	li	a4,17
    return 0;
    80000572:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000574:	00e68663          	beq	a3,a4,80000580 <walkaddr+0x36>
}
    80000578:	60a2                	ld	ra,8(sp)
    8000057a:	6402                	ld	s0,0(sp)
    8000057c:	0141                	addi	sp,sp,16
    8000057e:	8082                	ret
  pa = PTE2PA(*pte);
    80000580:	83a9                	srli	a5,a5,0xa
    80000582:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000586:	bfcd                	j	80000578 <walkaddr+0x2e>
    return 0;
    80000588:	4501                	li	a0,0
    8000058a:	b7fd                	j	80000578 <walkaddr+0x2e>

000000008000058c <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000058c:	715d                	addi	sp,sp,-80
    8000058e:	e486                	sd	ra,72(sp)
    80000590:	e0a2                	sd	s0,64(sp)
    80000592:	fc26                	sd	s1,56(sp)
    80000594:	f84a                	sd	s2,48(sp)
    80000596:	f44e                	sd	s3,40(sp)
    80000598:	f052                	sd	s4,32(sp)
    8000059a:	ec56                	sd	s5,24(sp)
    8000059c:	e85a                	sd	s6,16(sp)
    8000059e:	e45e                	sd	s7,8(sp)
    800005a0:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    800005a2:	c639                	beqz	a2,800005f0 <mappages+0x64>
    800005a4:	8aaa                	mv	s5,a0
    800005a6:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    800005a8:	777d                	lui	a4,0xfffff
    800005aa:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    800005ae:	fff58993          	addi	s3,a1,-1
    800005b2:	99b2                	add	s3,s3,a2
    800005b4:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    800005b8:	893e                	mv	s2,a5
    800005ba:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800005be:	6b85                	lui	s7,0x1
    800005c0:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005c4:	4605                	li	a2,1
    800005c6:	85ca                	mv	a1,s2
    800005c8:	8556                	mv	a0,s5
    800005ca:	00000097          	auipc	ra,0x0
    800005ce:	eda080e7          	jalr	-294(ra) # 800004a4 <walk>
    800005d2:	cd1d                	beqz	a0,80000610 <mappages+0x84>
    if(*pte & PTE_V)
    800005d4:	611c                	ld	a5,0(a0)
    800005d6:	8b85                	andi	a5,a5,1
    800005d8:	e785                	bnez	a5,80000600 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005da:	80b1                	srli	s1,s1,0xc
    800005dc:	04aa                	slli	s1,s1,0xa
    800005de:	0164e4b3          	or	s1,s1,s6
    800005e2:	0014e493          	ori	s1,s1,1
    800005e6:	e104                	sd	s1,0(a0)
    if(a == last)
    800005e8:	05390063          	beq	s2,s3,80000628 <mappages+0x9c>
    a += PGSIZE;
    800005ec:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005ee:	bfc9                	j	800005c0 <mappages+0x34>
    panic("mappages: size");
    800005f0:	00008517          	auipc	a0,0x8
    800005f4:	a6850513          	addi	a0,a0,-1432 # 80008058 <etext+0x58>
    800005f8:	00006097          	auipc	ra,0x6
    800005fc:	908080e7          	jalr	-1784(ra) # 80005f00 <panic>
      panic("mappages: remap");
    80000600:	00008517          	auipc	a0,0x8
    80000604:	a6850513          	addi	a0,a0,-1432 # 80008068 <etext+0x68>
    80000608:	00006097          	auipc	ra,0x6
    8000060c:	8f8080e7          	jalr	-1800(ra) # 80005f00 <panic>
      return -1;
    80000610:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000612:	60a6                	ld	ra,72(sp)
    80000614:	6406                	ld	s0,64(sp)
    80000616:	74e2                	ld	s1,56(sp)
    80000618:	7942                	ld	s2,48(sp)
    8000061a:	79a2                	ld	s3,40(sp)
    8000061c:	7a02                	ld	s4,32(sp)
    8000061e:	6ae2                	ld	s5,24(sp)
    80000620:	6b42                	ld	s6,16(sp)
    80000622:	6ba2                	ld	s7,8(sp)
    80000624:	6161                	addi	sp,sp,80
    80000626:	8082                	ret
  return 0;
    80000628:	4501                	li	a0,0
    8000062a:	b7e5                	j	80000612 <mappages+0x86>

000000008000062c <kvmmap>:
{
    8000062c:	1141                	addi	sp,sp,-16
    8000062e:	e406                	sd	ra,8(sp)
    80000630:	e022                	sd	s0,0(sp)
    80000632:	0800                	addi	s0,sp,16
    80000634:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000636:	86b2                	mv	a3,a2
    80000638:	863e                	mv	a2,a5
    8000063a:	00000097          	auipc	ra,0x0
    8000063e:	f52080e7          	jalr	-174(ra) # 8000058c <mappages>
    80000642:	e509                	bnez	a0,8000064c <kvmmap+0x20>
}
    80000644:	60a2                	ld	ra,8(sp)
    80000646:	6402                	ld	s0,0(sp)
    80000648:	0141                	addi	sp,sp,16
    8000064a:	8082                	ret
    panic("kvmmap");
    8000064c:	00008517          	auipc	a0,0x8
    80000650:	a2c50513          	addi	a0,a0,-1492 # 80008078 <etext+0x78>
    80000654:	00006097          	auipc	ra,0x6
    80000658:	8ac080e7          	jalr	-1876(ra) # 80005f00 <panic>

000000008000065c <kvmmake>:
{
    8000065c:	1101                	addi	sp,sp,-32
    8000065e:	ec06                	sd	ra,24(sp)
    80000660:	e822                	sd	s0,16(sp)
    80000662:	e426                	sd	s1,8(sp)
    80000664:	e04a                	sd	s2,0(sp)
    80000666:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000668:	00000097          	auipc	ra,0x0
    8000066c:	ab2080e7          	jalr	-1358(ra) # 8000011a <kalloc>
    80000670:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000672:	6605                	lui	a2,0x1
    80000674:	4581                	li	a1,0
    80000676:	00000097          	auipc	ra,0x0
    8000067a:	b4e080e7          	jalr	-1202(ra) # 800001c4 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000067e:	4719                	li	a4,6
    80000680:	6685                	lui	a3,0x1
    80000682:	10000637          	lui	a2,0x10000
    80000686:	100005b7          	lui	a1,0x10000
    8000068a:	8526                	mv	a0,s1
    8000068c:	00000097          	auipc	ra,0x0
    80000690:	fa0080e7          	jalr	-96(ra) # 8000062c <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000694:	4719                	li	a4,6
    80000696:	6685                	lui	a3,0x1
    80000698:	10001637          	lui	a2,0x10001
    8000069c:	100015b7          	lui	a1,0x10001
    800006a0:	8526                	mv	a0,s1
    800006a2:	00000097          	auipc	ra,0x0
    800006a6:	f8a080e7          	jalr	-118(ra) # 8000062c <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    800006aa:	4719                	li	a4,6
    800006ac:	004006b7          	lui	a3,0x400
    800006b0:	0c000637          	lui	a2,0xc000
    800006b4:	0c0005b7          	lui	a1,0xc000
    800006b8:	8526                	mv	a0,s1
    800006ba:	00000097          	auipc	ra,0x0
    800006be:	f72080e7          	jalr	-142(ra) # 8000062c <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006c2:	00008917          	auipc	s2,0x8
    800006c6:	93e90913          	addi	s2,s2,-1730 # 80008000 <etext>
    800006ca:	4729                	li	a4,10
    800006cc:	80008697          	auipc	a3,0x80008
    800006d0:	93468693          	addi	a3,a3,-1740 # 8000 <_entry-0x7fff8000>
    800006d4:	4605                	li	a2,1
    800006d6:	067e                	slli	a2,a2,0x1f
    800006d8:	85b2                	mv	a1,a2
    800006da:	8526                	mv	a0,s1
    800006dc:	00000097          	auipc	ra,0x0
    800006e0:	f50080e7          	jalr	-176(ra) # 8000062c <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006e4:	4719                	li	a4,6
    800006e6:	46c5                	li	a3,17
    800006e8:	06ee                	slli	a3,a3,0x1b
    800006ea:	412686b3          	sub	a3,a3,s2
    800006ee:	864a                	mv	a2,s2
    800006f0:	85ca                	mv	a1,s2
    800006f2:	8526                	mv	a0,s1
    800006f4:	00000097          	auipc	ra,0x0
    800006f8:	f38080e7          	jalr	-200(ra) # 8000062c <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006fc:	4729                	li	a4,10
    800006fe:	6685                	lui	a3,0x1
    80000700:	00007617          	auipc	a2,0x7
    80000704:	90060613          	addi	a2,a2,-1792 # 80007000 <_trampoline>
    80000708:	040005b7          	lui	a1,0x4000
    8000070c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000070e:	05b2                	slli	a1,a1,0xc
    80000710:	8526                	mv	a0,s1
    80000712:	00000097          	auipc	ra,0x0
    80000716:	f1a080e7          	jalr	-230(ra) # 8000062c <kvmmap>
  proc_mapstacks(kpgtbl);
    8000071a:	8526                	mv	a0,s1
    8000071c:	00000097          	auipc	ra,0x0
    80000720:	6fc080e7          	jalr	1788(ra) # 80000e18 <proc_mapstacks>
}
    80000724:	8526                	mv	a0,s1
    80000726:	60e2                	ld	ra,24(sp)
    80000728:	6442                	ld	s0,16(sp)
    8000072a:	64a2                	ld	s1,8(sp)
    8000072c:	6902                	ld	s2,0(sp)
    8000072e:	6105                	addi	sp,sp,32
    80000730:	8082                	ret

0000000080000732 <kvminit>:
{
    80000732:	1141                	addi	sp,sp,-16
    80000734:	e406                	sd	ra,8(sp)
    80000736:	e022                	sd	s0,0(sp)
    80000738:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000073a:	00000097          	auipc	ra,0x0
    8000073e:	f22080e7          	jalr	-222(ra) # 8000065c <kvmmake>
    80000742:	00009797          	auipc	a5,0x9
    80000746:	8ca7b323          	sd	a0,-1850(a5) # 80009008 <kernel_pagetable>
}
    8000074a:	60a2                	ld	ra,8(sp)
    8000074c:	6402                	ld	s0,0(sp)
    8000074e:	0141                	addi	sp,sp,16
    80000750:	8082                	ret

0000000080000752 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000752:	715d                	addi	sp,sp,-80
    80000754:	e486                	sd	ra,72(sp)
    80000756:	e0a2                	sd	s0,64(sp)
    80000758:	fc26                	sd	s1,56(sp)
    8000075a:	f84a                	sd	s2,48(sp)
    8000075c:	f44e                	sd	s3,40(sp)
    8000075e:	f052                	sd	s4,32(sp)
    80000760:	ec56                	sd	s5,24(sp)
    80000762:	e85a                	sd	s6,16(sp)
    80000764:	e45e                	sd	s7,8(sp)
    80000766:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000768:	03459793          	slli	a5,a1,0x34
    8000076c:	e795                	bnez	a5,80000798 <uvmunmap+0x46>
    8000076e:	8a2a                	mv	s4,a0
    80000770:	892e                	mv	s2,a1
    80000772:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000774:	0632                	slli	a2,a2,0xc
    80000776:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000077a:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000077c:	6b05                	lui	s6,0x1
    8000077e:	0735e263          	bltu	a1,s3,800007e2 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000782:	60a6                	ld	ra,72(sp)
    80000784:	6406                	ld	s0,64(sp)
    80000786:	74e2                	ld	s1,56(sp)
    80000788:	7942                	ld	s2,48(sp)
    8000078a:	79a2                	ld	s3,40(sp)
    8000078c:	7a02                	ld	s4,32(sp)
    8000078e:	6ae2                	ld	s5,24(sp)
    80000790:	6b42                	ld	s6,16(sp)
    80000792:	6ba2                	ld	s7,8(sp)
    80000794:	6161                	addi	sp,sp,80
    80000796:	8082                	ret
    panic("uvmunmap: not aligned");
    80000798:	00008517          	auipc	a0,0x8
    8000079c:	8e850513          	addi	a0,a0,-1816 # 80008080 <etext+0x80>
    800007a0:	00005097          	auipc	ra,0x5
    800007a4:	760080e7          	jalr	1888(ra) # 80005f00 <panic>
      panic("uvmunmap: walk");
    800007a8:	00008517          	auipc	a0,0x8
    800007ac:	8f050513          	addi	a0,a0,-1808 # 80008098 <etext+0x98>
    800007b0:	00005097          	auipc	ra,0x5
    800007b4:	750080e7          	jalr	1872(ra) # 80005f00 <panic>
      panic("uvmunmap: not mapped");
    800007b8:	00008517          	auipc	a0,0x8
    800007bc:	8f050513          	addi	a0,a0,-1808 # 800080a8 <etext+0xa8>
    800007c0:	00005097          	auipc	ra,0x5
    800007c4:	740080e7          	jalr	1856(ra) # 80005f00 <panic>
      panic("uvmunmap: not a leaf");
    800007c8:	00008517          	auipc	a0,0x8
    800007cc:	8f850513          	addi	a0,a0,-1800 # 800080c0 <etext+0xc0>
    800007d0:	00005097          	auipc	ra,0x5
    800007d4:	730080e7          	jalr	1840(ra) # 80005f00 <panic>
    *pte = 0;
    800007d8:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007dc:	995a                	add	s2,s2,s6
    800007de:	fb3972e3          	bgeu	s2,s3,80000782 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007e2:	4601                	li	a2,0
    800007e4:	85ca                	mv	a1,s2
    800007e6:	8552                	mv	a0,s4
    800007e8:	00000097          	auipc	ra,0x0
    800007ec:	cbc080e7          	jalr	-836(ra) # 800004a4 <walk>
    800007f0:	84aa                	mv	s1,a0
    800007f2:	d95d                	beqz	a0,800007a8 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007f4:	6108                	ld	a0,0(a0)
    800007f6:	00157793          	andi	a5,a0,1
    800007fa:	dfdd                	beqz	a5,800007b8 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007fc:	3ff57793          	andi	a5,a0,1023
    80000800:	fd7784e3          	beq	a5,s7,800007c8 <uvmunmap+0x76>
    if(do_free){
    80000804:	fc0a8ae3          	beqz	s5,800007d8 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    80000808:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    8000080a:	0532                	slli	a0,a0,0xc
    8000080c:	00000097          	auipc	ra,0x0
    80000810:	810080e7          	jalr	-2032(ra) # 8000001c <kfree>
    80000814:	b7d1                	j	800007d8 <uvmunmap+0x86>

0000000080000816 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000816:	1101                	addi	sp,sp,-32
    80000818:	ec06                	sd	ra,24(sp)
    8000081a:	e822                	sd	s0,16(sp)
    8000081c:	e426                	sd	s1,8(sp)
    8000081e:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000820:	00000097          	auipc	ra,0x0
    80000824:	8fa080e7          	jalr	-1798(ra) # 8000011a <kalloc>
    80000828:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000082a:	c519                	beqz	a0,80000838 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000082c:	6605                	lui	a2,0x1
    8000082e:	4581                	li	a1,0
    80000830:	00000097          	auipc	ra,0x0
    80000834:	994080e7          	jalr	-1644(ra) # 800001c4 <memset>
  return pagetable;
}
    80000838:	8526                	mv	a0,s1
    8000083a:	60e2                	ld	ra,24(sp)
    8000083c:	6442                	ld	s0,16(sp)
    8000083e:	64a2                	ld	s1,8(sp)
    80000840:	6105                	addi	sp,sp,32
    80000842:	8082                	ret

0000000080000844 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80000844:	7179                	addi	sp,sp,-48
    80000846:	f406                	sd	ra,40(sp)
    80000848:	f022                	sd	s0,32(sp)
    8000084a:	ec26                	sd	s1,24(sp)
    8000084c:	e84a                	sd	s2,16(sp)
    8000084e:	e44e                	sd	s3,8(sp)
    80000850:	e052                	sd	s4,0(sp)
    80000852:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000854:	6785                	lui	a5,0x1
    80000856:	04f67863          	bgeu	a2,a5,800008a6 <uvminit+0x62>
    8000085a:	8a2a                	mv	s4,a0
    8000085c:	89ae                	mv	s3,a1
    8000085e:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80000860:	00000097          	auipc	ra,0x0
    80000864:	8ba080e7          	jalr	-1862(ra) # 8000011a <kalloc>
    80000868:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000086a:	6605                	lui	a2,0x1
    8000086c:	4581                	li	a1,0
    8000086e:	00000097          	auipc	ra,0x0
    80000872:	956080e7          	jalr	-1706(ra) # 800001c4 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000876:	4779                	li	a4,30
    80000878:	86ca                	mv	a3,s2
    8000087a:	6605                	lui	a2,0x1
    8000087c:	4581                	li	a1,0
    8000087e:	8552                	mv	a0,s4
    80000880:	00000097          	auipc	ra,0x0
    80000884:	d0c080e7          	jalr	-756(ra) # 8000058c <mappages>
  memmove(mem, src, sz);
    80000888:	8626                	mv	a2,s1
    8000088a:	85ce                	mv	a1,s3
    8000088c:	854a                	mv	a0,s2
    8000088e:	00000097          	auipc	ra,0x0
    80000892:	992080e7          	jalr	-1646(ra) # 80000220 <memmove>
}
    80000896:	70a2                	ld	ra,40(sp)
    80000898:	7402                	ld	s0,32(sp)
    8000089a:	64e2                	ld	s1,24(sp)
    8000089c:	6942                	ld	s2,16(sp)
    8000089e:	69a2                	ld	s3,8(sp)
    800008a0:	6a02                	ld	s4,0(sp)
    800008a2:	6145                	addi	sp,sp,48
    800008a4:	8082                	ret
    panic("inituvm: more than a page");
    800008a6:	00008517          	auipc	a0,0x8
    800008aa:	83250513          	addi	a0,a0,-1998 # 800080d8 <etext+0xd8>
    800008ae:	00005097          	auipc	ra,0x5
    800008b2:	652080e7          	jalr	1618(ra) # 80005f00 <panic>

00000000800008b6 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800008b6:	1101                	addi	sp,sp,-32
    800008b8:	ec06                	sd	ra,24(sp)
    800008ba:	e822                	sd	s0,16(sp)
    800008bc:	e426                	sd	s1,8(sp)
    800008be:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008c0:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008c2:	00b67d63          	bgeu	a2,a1,800008dc <uvmdealloc+0x26>
    800008c6:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008c8:	6785                	lui	a5,0x1
    800008ca:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008cc:	00f60733          	add	a4,a2,a5
    800008d0:	76fd                	lui	a3,0xfffff
    800008d2:	8f75                	and	a4,a4,a3
    800008d4:	97ae                	add	a5,a5,a1
    800008d6:	8ff5                	and	a5,a5,a3
    800008d8:	00f76863          	bltu	a4,a5,800008e8 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008dc:	8526                	mv	a0,s1
    800008de:	60e2                	ld	ra,24(sp)
    800008e0:	6442                	ld	s0,16(sp)
    800008e2:	64a2                	ld	s1,8(sp)
    800008e4:	6105                	addi	sp,sp,32
    800008e6:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008e8:	8f99                	sub	a5,a5,a4
    800008ea:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008ec:	4685                	li	a3,1
    800008ee:	0007861b          	sext.w	a2,a5
    800008f2:	85ba                	mv	a1,a4
    800008f4:	00000097          	auipc	ra,0x0
    800008f8:	e5e080e7          	jalr	-418(ra) # 80000752 <uvmunmap>
    800008fc:	b7c5                	j	800008dc <uvmdealloc+0x26>

00000000800008fe <uvmalloc>:
  if(newsz < oldsz)
    800008fe:	0ab66163          	bltu	a2,a1,800009a0 <uvmalloc+0xa2>
{
    80000902:	7139                	addi	sp,sp,-64
    80000904:	fc06                	sd	ra,56(sp)
    80000906:	f822                	sd	s0,48(sp)
    80000908:	f426                	sd	s1,40(sp)
    8000090a:	f04a                	sd	s2,32(sp)
    8000090c:	ec4e                	sd	s3,24(sp)
    8000090e:	e852                	sd	s4,16(sp)
    80000910:	e456                	sd	s5,8(sp)
    80000912:	0080                	addi	s0,sp,64
    80000914:	8aaa                	mv	s5,a0
    80000916:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000918:	6785                	lui	a5,0x1
    8000091a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000091c:	95be                	add	a1,a1,a5
    8000091e:	77fd                	lui	a5,0xfffff
    80000920:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000924:	08c9f063          	bgeu	s3,a2,800009a4 <uvmalloc+0xa6>
    80000928:	894e                	mv	s2,s3
    mem = kalloc();
    8000092a:	fffff097          	auipc	ra,0xfffff
    8000092e:	7f0080e7          	jalr	2032(ra) # 8000011a <kalloc>
    80000932:	84aa                	mv	s1,a0
    if(mem == 0){
    80000934:	c51d                	beqz	a0,80000962 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80000936:	6605                	lui	a2,0x1
    80000938:	4581                	li	a1,0
    8000093a:	00000097          	auipc	ra,0x0
    8000093e:	88a080e7          	jalr	-1910(ra) # 800001c4 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80000942:	4779                	li	a4,30
    80000944:	86a6                	mv	a3,s1
    80000946:	6605                	lui	a2,0x1
    80000948:	85ca                	mv	a1,s2
    8000094a:	8556                	mv	a0,s5
    8000094c:	00000097          	auipc	ra,0x0
    80000950:	c40080e7          	jalr	-960(ra) # 8000058c <mappages>
    80000954:	e905                	bnez	a0,80000984 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000956:	6785                	lui	a5,0x1
    80000958:	993e                	add	s2,s2,a5
    8000095a:	fd4968e3          	bltu	s2,s4,8000092a <uvmalloc+0x2c>
  return newsz;
    8000095e:	8552                	mv	a0,s4
    80000960:	a809                	j	80000972 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80000962:	864e                	mv	a2,s3
    80000964:	85ca                	mv	a1,s2
    80000966:	8556                	mv	a0,s5
    80000968:	00000097          	auipc	ra,0x0
    8000096c:	f4e080e7          	jalr	-178(ra) # 800008b6 <uvmdealloc>
      return 0;
    80000970:	4501                	li	a0,0
}
    80000972:	70e2                	ld	ra,56(sp)
    80000974:	7442                	ld	s0,48(sp)
    80000976:	74a2                	ld	s1,40(sp)
    80000978:	7902                	ld	s2,32(sp)
    8000097a:	69e2                	ld	s3,24(sp)
    8000097c:	6a42                	ld	s4,16(sp)
    8000097e:	6aa2                	ld	s5,8(sp)
    80000980:	6121                	addi	sp,sp,64
    80000982:	8082                	ret
      kfree(mem);
    80000984:	8526                	mv	a0,s1
    80000986:	fffff097          	auipc	ra,0xfffff
    8000098a:	696080e7          	jalr	1686(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000098e:	864e                	mv	a2,s3
    80000990:	85ca                	mv	a1,s2
    80000992:	8556                	mv	a0,s5
    80000994:	00000097          	auipc	ra,0x0
    80000998:	f22080e7          	jalr	-222(ra) # 800008b6 <uvmdealloc>
      return 0;
    8000099c:	4501                	li	a0,0
    8000099e:	bfd1                	j	80000972 <uvmalloc+0x74>
    return oldsz;
    800009a0:	852e                	mv	a0,a1
}
    800009a2:	8082                	ret
  return newsz;
    800009a4:	8532                	mv	a0,a2
    800009a6:	b7f1                	j	80000972 <uvmalloc+0x74>

00000000800009a8 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800009a8:	7179                	addi	sp,sp,-48
    800009aa:	f406                	sd	ra,40(sp)
    800009ac:	f022                	sd	s0,32(sp)
    800009ae:	ec26                	sd	s1,24(sp)
    800009b0:	e84a                	sd	s2,16(sp)
    800009b2:	e44e                	sd	s3,8(sp)
    800009b4:	e052                	sd	s4,0(sp)
    800009b6:	1800                	addi	s0,sp,48
    800009b8:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009ba:	84aa                	mv	s1,a0
    800009bc:	6905                	lui	s2,0x1
    800009be:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009c0:	4985                	li	s3,1
    800009c2:	a829                	j	800009dc <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009c4:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800009c6:	00c79513          	slli	a0,a5,0xc
    800009ca:	00000097          	auipc	ra,0x0
    800009ce:	fde080e7          	jalr	-34(ra) # 800009a8 <freewalk>
      pagetable[i] = 0;
    800009d2:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009d6:	04a1                	addi	s1,s1,8
    800009d8:	03248163          	beq	s1,s2,800009fa <freewalk+0x52>
    pte_t pte = pagetable[i];
    800009dc:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009de:	00f7f713          	andi	a4,a5,15
    800009e2:	ff3701e3          	beq	a4,s3,800009c4 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009e6:	8b85                	andi	a5,a5,1
    800009e8:	d7fd                	beqz	a5,800009d6 <freewalk+0x2e>
      panic("freewalk: leaf");
    800009ea:	00007517          	auipc	a0,0x7
    800009ee:	70e50513          	addi	a0,a0,1806 # 800080f8 <etext+0xf8>
    800009f2:	00005097          	auipc	ra,0x5
    800009f6:	50e080e7          	jalr	1294(ra) # 80005f00 <panic>
    }
  }
  kfree((void*)pagetable);
    800009fa:	8552                	mv	a0,s4
    800009fc:	fffff097          	auipc	ra,0xfffff
    80000a00:	620080e7          	jalr	1568(ra) # 8000001c <kfree>
}
    80000a04:	70a2                	ld	ra,40(sp)
    80000a06:	7402                	ld	s0,32(sp)
    80000a08:	64e2                	ld	s1,24(sp)
    80000a0a:	6942                	ld	s2,16(sp)
    80000a0c:	69a2                	ld	s3,8(sp)
    80000a0e:	6a02                	ld	s4,0(sp)
    80000a10:	6145                	addi	sp,sp,48
    80000a12:	8082                	ret

0000000080000a14 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a14:	1101                	addi	sp,sp,-32
    80000a16:	ec06                	sd	ra,24(sp)
    80000a18:	e822                	sd	s0,16(sp)
    80000a1a:	e426                	sd	s1,8(sp)
    80000a1c:	1000                	addi	s0,sp,32
    80000a1e:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a20:	e999                	bnez	a1,80000a36 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a22:	8526                	mv	a0,s1
    80000a24:	00000097          	auipc	ra,0x0
    80000a28:	f84080e7          	jalr	-124(ra) # 800009a8 <freewalk>
}
    80000a2c:	60e2                	ld	ra,24(sp)
    80000a2e:	6442                	ld	s0,16(sp)
    80000a30:	64a2                	ld	s1,8(sp)
    80000a32:	6105                	addi	sp,sp,32
    80000a34:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a36:	6785                	lui	a5,0x1
    80000a38:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a3a:	95be                	add	a1,a1,a5
    80000a3c:	4685                	li	a3,1
    80000a3e:	00c5d613          	srli	a2,a1,0xc
    80000a42:	4581                	li	a1,0
    80000a44:	00000097          	auipc	ra,0x0
    80000a48:	d0e080e7          	jalr	-754(ra) # 80000752 <uvmunmap>
    80000a4c:	bfd9                	j	80000a22 <uvmfree+0xe>

0000000080000a4e <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a4e:	c679                	beqz	a2,80000b1c <uvmcopy+0xce>
{
    80000a50:	715d                	addi	sp,sp,-80
    80000a52:	e486                	sd	ra,72(sp)
    80000a54:	e0a2                	sd	s0,64(sp)
    80000a56:	fc26                	sd	s1,56(sp)
    80000a58:	f84a                	sd	s2,48(sp)
    80000a5a:	f44e                	sd	s3,40(sp)
    80000a5c:	f052                	sd	s4,32(sp)
    80000a5e:	ec56                	sd	s5,24(sp)
    80000a60:	e85a                	sd	s6,16(sp)
    80000a62:	e45e                	sd	s7,8(sp)
    80000a64:	0880                	addi	s0,sp,80
    80000a66:	8b2a                	mv	s6,a0
    80000a68:	8aae                	mv	s5,a1
    80000a6a:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a6c:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a6e:	4601                	li	a2,0
    80000a70:	85ce                	mv	a1,s3
    80000a72:	855a                	mv	a0,s6
    80000a74:	00000097          	auipc	ra,0x0
    80000a78:	a30080e7          	jalr	-1488(ra) # 800004a4 <walk>
    80000a7c:	c531                	beqz	a0,80000ac8 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a7e:	6118                	ld	a4,0(a0)
    80000a80:	00177793          	andi	a5,a4,1
    80000a84:	cbb1                	beqz	a5,80000ad8 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a86:	00a75593          	srli	a1,a4,0xa
    80000a8a:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a8e:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a92:	fffff097          	auipc	ra,0xfffff
    80000a96:	688080e7          	jalr	1672(ra) # 8000011a <kalloc>
    80000a9a:	892a                	mv	s2,a0
    80000a9c:	c939                	beqz	a0,80000af2 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a9e:	6605                	lui	a2,0x1
    80000aa0:	85de                	mv	a1,s7
    80000aa2:	fffff097          	auipc	ra,0xfffff
    80000aa6:	77e080e7          	jalr	1918(ra) # 80000220 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000aaa:	8726                	mv	a4,s1
    80000aac:	86ca                	mv	a3,s2
    80000aae:	6605                	lui	a2,0x1
    80000ab0:	85ce                	mv	a1,s3
    80000ab2:	8556                	mv	a0,s5
    80000ab4:	00000097          	auipc	ra,0x0
    80000ab8:	ad8080e7          	jalr	-1320(ra) # 8000058c <mappages>
    80000abc:	e515                	bnez	a0,80000ae8 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000abe:	6785                	lui	a5,0x1
    80000ac0:	99be                	add	s3,s3,a5
    80000ac2:	fb49e6e3          	bltu	s3,s4,80000a6e <uvmcopy+0x20>
    80000ac6:	a081                	j	80000b06 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000ac8:	00007517          	auipc	a0,0x7
    80000acc:	64050513          	addi	a0,a0,1600 # 80008108 <etext+0x108>
    80000ad0:	00005097          	auipc	ra,0x5
    80000ad4:	430080e7          	jalr	1072(ra) # 80005f00 <panic>
      panic("uvmcopy: page not present");
    80000ad8:	00007517          	auipc	a0,0x7
    80000adc:	65050513          	addi	a0,a0,1616 # 80008128 <etext+0x128>
    80000ae0:	00005097          	auipc	ra,0x5
    80000ae4:	420080e7          	jalr	1056(ra) # 80005f00 <panic>
      kfree(mem);
    80000ae8:	854a                	mv	a0,s2
    80000aea:	fffff097          	auipc	ra,0xfffff
    80000aee:	532080e7          	jalr	1330(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000af2:	4685                	li	a3,1
    80000af4:	00c9d613          	srli	a2,s3,0xc
    80000af8:	4581                	li	a1,0
    80000afa:	8556                	mv	a0,s5
    80000afc:	00000097          	auipc	ra,0x0
    80000b00:	c56080e7          	jalr	-938(ra) # 80000752 <uvmunmap>
  return -1;
    80000b04:	557d                	li	a0,-1
}
    80000b06:	60a6                	ld	ra,72(sp)
    80000b08:	6406                	ld	s0,64(sp)
    80000b0a:	74e2                	ld	s1,56(sp)
    80000b0c:	7942                	ld	s2,48(sp)
    80000b0e:	79a2                	ld	s3,40(sp)
    80000b10:	7a02                	ld	s4,32(sp)
    80000b12:	6ae2                	ld	s5,24(sp)
    80000b14:	6b42                	ld	s6,16(sp)
    80000b16:	6ba2                	ld	s7,8(sp)
    80000b18:	6161                	addi	sp,sp,80
    80000b1a:	8082                	ret
  return 0;
    80000b1c:	4501                	li	a0,0
}
    80000b1e:	8082                	ret

0000000080000b20 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b20:	1141                	addi	sp,sp,-16
    80000b22:	e406                	sd	ra,8(sp)
    80000b24:	e022                	sd	s0,0(sp)
    80000b26:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b28:	4601                	li	a2,0
    80000b2a:	00000097          	auipc	ra,0x0
    80000b2e:	97a080e7          	jalr	-1670(ra) # 800004a4 <walk>
  if(pte == 0)
    80000b32:	c901                	beqz	a0,80000b42 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b34:	611c                	ld	a5,0(a0)
    80000b36:	9bbd                	andi	a5,a5,-17
    80000b38:	e11c                	sd	a5,0(a0)
}
    80000b3a:	60a2                	ld	ra,8(sp)
    80000b3c:	6402                	ld	s0,0(sp)
    80000b3e:	0141                	addi	sp,sp,16
    80000b40:	8082                	ret
    panic("uvmclear");
    80000b42:	00007517          	auipc	a0,0x7
    80000b46:	60650513          	addi	a0,a0,1542 # 80008148 <etext+0x148>
    80000b4a:	00005097          	auipc	ra,0x5
    80000b4e:	3b6080e7          	jalr	950(ra) # 80005f00 <panic>

0000000080000b52 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b52:	c6bd                	beqz	a3,80000bc0 <copyout+0x6e>
{
    80000b54:	715d                	addi	sp,sp,-80
    80000b56:	e486                	sd	ra,72(sp)
    80000b58:	e0a2                	sd	s0,64(sp)
    80000b5a:	fc26                	sd	s1,56(sp)
    80000b5c:	f84a                	sd	s2,48(sp)
    80000b5e:	f44e                	sd	s3,40(sp)
    80000b60:	f052                	sd	s4,32(sp)
    80000b62:	ec56                	sd	s5,24(sp)
    80000b64:	e85a                	sd	s6,16(sp)
    80000b66:	e45e                	sd	s7,8(sp)
    80000b68:	e062                	sd	s8,0(sp)
    80000b6a:	0880                	addi	s0,sp,80
    80000b6c:	8b2a                	mv	s6,a0
    80000b6e:	8c2e                	mv	s8,a1
    80000b70:	8a32                	mv	s4,a2
    80000b72:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b74:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b76:	6a85                	lui	s5,0x1
    80000b78:	a015                	j	80000b9c <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b7a:	9562                	add	a0,a0,s8
    80000b7c:	0004861b          	sext.w	a2,s1
    80000b80:	85d2                	mv	a1,s4
    80000b82:	41250533          	sub	a0,a0,s2
    80000b86:	fffff097          	auipc	ra,0xfffff
    80000b8a:	69a080e7          	jalr	1690(ra) # 80000220 <memmove>

    len -= n;
    80000b8e:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b92:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b94:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b98:	02098263          	beqz	s3,80000bbc <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b9c:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000ba0:	85ca                	mv	a1,s2
    80000ba2:	855a                	mv	a0,s6
    80000ba4:	00000097          	auipc	ra,0x0
    80000ba8:	9a6080e7          	jalr	-1626(ra) # 8000054a <walkaddr>
    if(pa0 == 0)
    80000bac:	cd01                	beqz	a0,80000bc4 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000bae:	418904b3          	sub	s1,s2,s8
    80000bb2:	94d6                	add	s1,s1,s5
    80000bb4:	fc99f3e3          	bgeu	s3,s1,80000b7a <copyout+0x28>
    80000bb8:	84ce                	mv	s1,s3
    80000bba:	b7c1                	j	80000b7a <copyout+0x28>
  }
  return 0;
    80000bbc:	4501                	li	a0,0
    80000bbe:	a021                	j	80000bc6 <copyout+0x74>
    80000bc0:	4501                	li	a0,0
}
    80000bc2:	8082                	ret
      return -1;
    80000bc4:	557d                	li	a0,-1
}
    80000bc6:	60a6                	ld	ra,72(sp)
    80000bc8:	6406                	ld	s0,64(sp)
    80000bca:	74e2                	ld	s1,56(sp)
    80000bcc:	7942                	ld	s2,48(sp)
    80000bce:	79a2                	ld	s3,40(sp)
    80000bd0:	7a02                	ld	s4,32(sp)
    80000bd2:	6ae2                	ld	s5,24(sp)
    80000bd4:	6b42                	ld	s6,16(sp)
    80000bd6:	6ba2                	ld	s7,8(sp)
    80000bd8:	6c02                	ld	s8,0(sp)
    80000bda:	6161                	addi	sp,sp,80
    80000bdc:	8082                	ret

0000000080000bde <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000bde:	caa5                	beqz	a3,80000c4e <copyin+0x70>
{
    80000be0:	715d                	addi	sp,sp,-80
    80000be2:	e486                	sd	ra,72(sp)
    80000be4:	e0a2                	sd	s0,64(sp)
    80000be6:	fc26                	sd	s1,56(sp)
    80000be8:	f84a                	sd	s2,48(sp)
    80000bea:	f44e                	sd	s3,40(sp)
    80000bec:	f052                	sd	s4,32(sp)
    80000bee:	ec56                	sd	s5,24(sp)
    80000bf0:	e85a                	sd	s6,16(sp)
    80000bf2:	e45e                	sd	s7,8(sp)
    80000bf4:	e062                	sd	s8,0(sp)
    80000bf6:	0880                	addi	s0,sp,80
    80000bf8:	8b2a                	mv	s6,a0
    80000bfa:	8a2e                	mv	s4,a1
    80000bfc:	8c32                	mv	s8,a2
    80000bfe:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c00:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c02:	6a85                	lui	s5,0x1
    80000c04:	a01d                	j	80000c2a <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c06:	018505b3          	add	a1,a0,s8
    80000c0a:	0004861b          	sext.w	a2,s1
    80000c0e:	412585b3          	sub	a1,a1,s2
    80000c12:	8552                	mv	a0,s4
    80000c14:	fffff097          	auipc	ra,0xfffff
    80000c18:	60c080e7          	jalr	1548(ra) # 80000220 <memmove>

    len -= n;
    80000c1c:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c20:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c22:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c26:	02098263          	beqz	s3,80000c4a <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000c2a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c2e:	85ca                	mv	a1,s2
    80000c30:	855a                	mv	a0,s6
    80000c32:	00000097          	auipc	ra,0x0
    80000c36:	918080e7          	jalr	-1768(ra) # 8000054a <walkaddr>
    if(pa0 == 0)
    80000c3a:	cd01                	beqz	a0,80000c52 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000c3c:	418904b3          	sub	s1,s2,s8
    80000c40:	94d6                	add	s1,s1,s5
    80000c42:	fc99f2e3          	bgeu	s3,s1,80000c06 <copyin+0x28>
    80000c46:	84ce                	mv	s1,s3
    80000c48:	bf7d                	j	80000c06 <copyin+0x28>
  }
  return 0;
    80000c4a:	4501                	li	a0,0
    80000c4c:	a021                	j	80000c54 <copyin+0x76>
    80000c4e:	4501                	li	a0,0
}
    80000c50:	8082                	ret
      return -1;
    80000c52:	557d                	li	a0,-1
}
    80000c54:	60a6                	ld	ra,72(sp)
    80000c56:	6406                	ld	s0,64(sp)
    80000c58:	74e2                	ld	s1,56(sp)
    80000c5a:	7942                	ld	s2,48(sp)
    80000c5c:	79a2                	ld	s3,40(sp)
    80000c5e:	7a02                	ld	s4,32(sp)
    80000c60:	6ae2                	ld	s5,24(sp)
    80000c62:	6b42                	ld	s6,16(sp)
    80000c64:	6ba2                	ld	s7,8(sp)
    80000c66:	6c02                	ld	s8,0(sp)
    80000c68:	6161                	addi	sp,sp,80
    80000c6a:	8082                	ret

0000000080000c6c <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c6c:	c2dd                	beqz	a3,80000d12 <copyinstr+0xa6>
{
    80000c6e:	715d                	addi	sp,sp,-80
    80000c70:	e486                	sd	ra,72(sp)
    80000c72:	e0a2                	sd	s0,64(sp)
    80000c74:	fc26                	sd	s1,56(sp)
    80000c76:	f84a                	sd	s2,48(sp)
    80000c78:	f44e                	sd	s3,40(sp)
    80000c7a:	f052                	sd	s4,32(sp)
    80000c7c:	ec56                	sd	s5,24(sp)
    80000c7e:	e85a                	sd	s6,16(sp)
    80000c80:	e45e                	sd	s7,8(sp)
    80000c82:	0880                	addi	s0,sp,80
    80000c84:	8a2a                	mv	s4,a0
    80000c86:	8b2e                	mv	s6,a1
    80000c88:	8bb2                	mv	s7,a2
    80000c8a:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c8c:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c8e:	6985                	lui	s3,0x1
    80000c90:	a02d                	j	80000cba <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c92:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c96:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c98:	37fd                	addiw	a5,a5,-1
    80000c9a:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c9e:	60a6                	ld	ra,72(sp)
    80000ca0:	6406                	ld	s0,64(sp)
    80000ca2:	74e2                	ld	s1,56(sp)
    80000ca4:	7942                	ld	s2,48(sp)
    80000ca6:	79a2                	ld	s3,40(sp)
    80000ca8:	7a02                	ld	s4,32(sp)
    80000caa:	6ae2                	ld	s5,24(sp)
    80000cac:	6b42                	ld	s6,16(sp)
    80000cae:	6ba2                	ld	s7,8(sp)
    80000cb0:	6161                	addi	sp,sp,80
    80000cb2:	8082                	ret
    srcva = va0 + PGSIZE;
    80000cb4:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000cb8:	c8a9                	beqz	s1,80000d0a <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000cba:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000cbe:	85ca                	mv	a1,s2
    80000cc0:	8552                	mv	a0,s4
    80000cc2:	00000097          	auipc	ra,0x0
    80000cc6:	888080e7          	jalr	-1912(ra) # 8000054a <walkaddr>
    if(pa0 == 0)
    80000cca:	c131                	beqz	a0,80000d0e <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000ccc:	417906b3          	sub	a3,s2,s7
    80000cd0:	96ce                	add	a3,a3,s3
    80000cd2:	00d4f363          	bgeu	s1,a3,80000cd8 <copyinstr+0x6c>
    80000cd6:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000cd8:	955e                	add	a0,a0,s7
    80000cda:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000cde:	daf9                	beqz	a3,80000cb4 <copyinstr+0x48>
    80000ce0:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000ce2:	41650633          	sub	a2,a0,s6
    80000ce6:	fff48593          	addi	a1,s1,-1
    80000cea:	95da                	add	a1,a1,s6
    while(n > 0){
    80000cec:	96da                	add	a3,a3,s6
      if(*p == '\0'){
    80000cee:	00f60733          	add	a4,a2,a5
    80000cf2:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd8dc0>
    80000cf6:	df51                	beqz	a4,80000c92 <copyinstr+0x26>
        *dst = *p;
    80000cf8:	00e78023          	sb	a4,0(a5)
      --max;
    80000cfc:	40f584b3          	sub	s1,a1,a5
      dst++;
    80000d00:	0785                	addi	a5,a5,1
    while(n > 0){
    80000d02:	fed796e3          	bne	a5,a3,80000cee <copyinstr+0x82>
      dst++;
    80000d06:	8b3e                	mv	s6,a5
    80000d08:	b775                	j	80000cb4 <copyinstr+0x48>
    80000d0a:	4781                	li	a5,0
    80000d0c:	b771                	j	80000c98 <copyinstr+0x2c>
      return -1;
    80000d0e:	557d                	li	a0,-1
    80000d10:	b779                	j	80000c9e <copyinstr+0x32>
  int got_null = 0;
    80000d12:	4781                	li	a5,0
  if(got_null){
    80000d14:	37fd                	addiw	a5,a5,-1
    80000d16:	0007851b          	sext.w	a0,a5
}
    80000d1a:	8082                	ret

0000000080000d1c <_vmprint>:

void
_vmprint(pagetable_t pagetable, int level)
{
    80000d1c:	7159                	addi	sp,sp,-112
    80000d1e:	f486                	sd	ra,104(sp)
    80000d20:	f0a2                	sd	s0,96(sp)
    80000d22:	eca6                	sd	s1,88(sp)
    80000d24:	e8ca                	sd	s2,80(sp)
    80000d26:	e4ce                	sd	s3,72(sp)
    80000d28:	e0d2                	sd	s4,64(sp)
    80000d2a:	fc56                	sd	s5,56(sp)
    80000d2c:	f85a                	sd	s6,48(sp)
    80000d2e:	f45e                	sd	s7,40(sp)
    80000d30:	f062                	sd	s8,32(sp)
    80000d32:	ec66                	sd	s9,24(sp)
    80000d34:	e86a                	sd	s10,16(sp)
    80000d36:	e46e                	sd	s11,8(sp)
    80000d38:	1880                	addi	s0,sp,112
    80000d3a:	8aae                	mv	s5,a1
  for(int i=0;i<512;i++){
    80000d3c:	8a2a                	mv	s4,a0
    80000d3e:	4981                	li	s3,0
    pte_t pte=pagetable[i];
    if(pte&PTE_V){
      for(int j=0;j<level;j++){
    80000d40:	4d01                	li	s10,0
        if(j){
          printf(" ");
        }
        printf("..");
    80000d42:	00007b17          	auipc	s6,0x7
    80000d46:	41eb0b13          	addi	s6,s6,1054 # 80008160 <etext+0x160>
          printf(" ");
    80000d4a:	00007b97          	auipc	s7,0x7
    80000d4e:	40eb8b93          	addi	s7,s7,1038 # 80008158 <etext+0x158>
      }

      uint64 child = PTE2PA(pte);
      printf("%d: pte %p pa %p\n",i,pte,child);
    80000d52:	00007c97          	auipc	s9,0x7
    80000d56:	416c8c93          	addi	s9,s9,1046 # 80008168 <etext+0x168>
      if((pte&(PTE_R | PTE_W |PTE_X)) == 0){
        _vmprint((pagetable_t)child, level+1);
    80000d5a:	00158d9b          	addiw	s11,a1,1
  for(int i=0;i<512;i++){
    80000d5e:	20000c13          	li	s8,512
    80000d62:	a025                	j	80000d8a <_vmprint+0x6e>
      uint64 child = PTE2PA(pte);
    80000d64:	00a95493          	srli	s1,s2,0xa
    80000d68:	04b2                	slli	s1,s1,0xc
      printf("%d: pte %p pa %p\n",i,pte,child);
    80000d6a:	86a6                	mv	a3,s1
    80000d6c:	864a                	mv	a2,s2
    80000d6e:	85ce                	mv	a1,s3
    80000d70:	8566                	mv	a0,s9
    80000d72:	00005097          	auipc	ra,0x5
    80000d76:	1d8080e7          	jalr	472(ra) # 80005f4a <printf>
      if((pte&(PTE_R | PTE_W |PTE_X)) == 0){
    80000d7a:	00e97913          	andi	s2,s2,14
    80000d7e:	02090d63          	beqz	s2,80000db8 <_vmprint+0x9c>
  for(int i=0;i<512;i++){
    80000d82:	2985                	addiw	s3,s3,1 # 1001 <_entry-0x7fffefff>
    80000d84:	0a21                	addi	s4,s4,8
    80000d86:	05898063          	beq	s3,s8,80000dc6 <_vmprint+0xaa>
    pte_t pte=pagetable[i];
    80000d8a:	000a3903          	ld	s2,0(s4)
    if(pte&PTE_V){
    80000d8e:	00197793          	andi	a5,s2,1
    80000d92:	dbe5                	beqz	a5,80000d82 <_vmprint+0x66>
      for(int j=0;j<level;j++){
    80000d94:	84ea                	mv	s1,s10
    80000d96:	fd5057e3          	blez	s5,80000d64 <_vmprint+0x48>
        printf("..");
    80000d9a:	855a                	mv	a0,s6
    80000d9c:	00005097          	auipc	ra,0x5
    80000da0:	1ae080e7          	jalr	430(ra) # 80005f4a <printf>
      for(int j=0;j<level;j++){
    80000da4:	2485                	addiw	s1,s1,1
    80000da6:	fa9a8fe3          	beq	s5,s1,80000d64 <_vmprint+0x48>
        if(j){
    80000daa:	d8e5                	beqz	s1,80000d9a <_vmprint+0x7e>
          printf(" ");
    80000dac:	855e                	mv	a0,s7
    80000dae:	00005097          	auipc	ra,0x5
    80000db2:	19c080e7          	jalr	412(ra) # 80005f4a <printf>
    80000db6:	b7d5                	j	80000d9a <_vmprint+0x7e>
        _vmprint((pagetable_t)child, level+1);
    80000db8:	85ee                	mv	a1,s11
    80000dba:	8526                	mv	a0,s1
    80000dbc:	00000097          	auipc	ra,0x0
    80000dc0:	f60080e7          	jalr	-160(ra) # 80000d1c <_vmprint>
    80000dc4:	bf7d                	j	80000d82 <_vmprint+0x66>
      }
    }
  }
}
    80000dc6:	70a6                	ld	ra,104(sp)
    80000dc8:	7406                	ld	s0,96(sp)
    80000dca:	64e6                	ld	s1,88(sp)
    80000dcc:	6946                	ld	s2,80(sp)
    80000dce:	69a6                	ld	s3,72(sp)
    80000dd0:	6a06                	ld	s4,64(sp)
    80000dd2:	7ae2                	ld	s5,56(sp)
    80000dd4:	7b42                	ld	s6,48(sp)
    80000dd6:	7ba2                	ld	s7,40(sp)
    80000dd8:	7c02                	ld	s8,32(sp)
    80000dda:	6ce2                	ld	s9,24(sp)
    80000ddc:	6d42                	ld	s10,16(sp)
    80000dde:	6da2                	ld	s11,8(sp)
    80000de0:	6165                	addi	sp,sp,112
    80000de2:	8082                	ret

0000000080000de4 <vmprint>:

void
vmprint(pagetable_t pagetable){
    80000de4:	1101                	addi	sp,sp,-32
    80000de6:	ec06                	sd	ra,24(sp)
    80000de8:	e822                	sd	s0,16(sp)
    80000dea:	e426                	sd	s1,8(sp)
    80000dec:	1000                	addi	s0,sp,32
    80000dee:	84aa                	mv	s1,a0
  printf("page table %p\n",pagetable);
    80000df0:	85aa                	mv	a1,a0
    80000df2:	00007517          	auipc	a0,0x7
    80000df6:	38e50513          	addi	a0,a0,910 # 80008180 <etext+0x180>
    80000dfa:	00005097          	auipc	ra,0x5
    80000dfe:	150080e7          	jalr	336(ra) # 80005f4a <printf>
  _vmprint(pagetable,1);
    80000e02:	4585                	li	a1,1
    80000e04:	8526                	mv	a0,s1
    80000e06:	00000097          	auipc	ra,0x0
    80000e0a:	f16080e7          	jalr	-234(ra) # 80000d1c <_vmprint>
    80000e0e:	60e2                	ld	ra,24(sp)
    80000e10:	6442                	ld	s0,16(sp)
    80000e12:	64a2                	ld	s1,8(sp)
    80000e14:	6105                	addi	sp,sp,32
    80000e16:	8082                	ret

0000000080000e18 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000e18:	7139                	addi	sp,sp,-64
    80000e1a:	fc06                	sd	ra,56(sp)
    80000e1c:	f822                	sd	s0,48(sp)
    80000e1e:	f426                	sd	s1,40(sp)
    80000e20:	f04a                	sd	s2,32(sp)
    80000e22:	ec4e                	sd	s3,24(sp)
    80000e24:	e852                	sd	s4,16(sp)
    80000e26:	e456                	sd	s5,8(sp)
    80000e28:	e05a                	sd	s6,0(sp)
    80000e2a:	0080                	addi	s0,sp,64
    80000e2c:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e2e:	00008497          	auipc	s1,0x8
    80000e32:	65248493          	addi	s1,s1,1618 # 80009480 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000e36:	8b26                	mv	s6,s1
    80000e38:	00007a97          	auipc	s5,0x7
    80000e3c:	1c8a8a93          	addi	s5,s5,456 # 80008000 <etext>
    80000e40:	01000937          	lui	s2,0x1000
    80000e44:	197d                	addi	s2,s2,-1 # ffffff <_entry-0x7f000001>
    80000e46:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e48:	0000ea17          	auipc	s4,0xe
    80000e4c:	438a0a13          	addi	s4,s4,1080 # 8000f280 <tickslock>
    char *pa = kalloc();
    80000e50:	fffff097          	auipc	ra,0xfffff
    80000e54:	2ca080e7          	jalr	714(ra) # 8000011a <kalloc>
    80000e58:	862a                	mv	a2,a0
    if(pa == 0)
    80000e5a:	c129                	beqz	a0,80000e9c <proc_mapstacks+0x84>
    uint64 va = KSTACK((int) (p - proc));
    80000e5c:	416485b3          	sub	a1,s1,s6
    80000e60:	858d                	srai	a1,a1,0x3
    80000e62:	000ab783          	ld	a5,0(s5)
    80000e66:	02f585b3          	mul	a1,a1,a5
    80000e6a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e6e:	4719                	li	a4,6
    80000e70:	6685                	lui	a3,0x1
    80000e72:	40b905b3          	sub	a1,s2,a1
    80000e76:	854e                	mv	a0,s3
    80000e78:	fffff097          	auipc	ra,0xfffff
    80000e7c:	7b4080e7          	jalr	1972(ra) # 8000062c <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e80:	17848493          	addi	s1,s1,376
    80000e84:	fd4496e3          	bne	s1,s4,80000e50 <proc_mapstacks+0x38>
  }
}
    80000e88:	70e2                	ld	ra,56(sp)
    80000e8a:	7442                	ld	s0,48(sp)
    80000e8c:	74a2                	ld	s1,40(sp)
    80000e8e:	7902                	ld	s2,32(sp)
    80000e90:	69e2                	ld	s3,24(sp)
    80000e92:	6a42                	ld	s4,16(sp)
    80000e94:	6aa2                	ld	s5,8(sp)
    80000e96:	6b02                	ld	s6,0(sp)
    80000e98:	6121                	addi	sp,sp,64
    80000e9a:	8082                	ret
      panic("kalloc");
    80000e9c:	00007517          	auipc	a0,0x7
    80000ea0:	2f450513          	addi	a0,a0,756 # 80008190 <etext+0x190>
    80000ea4:	00005097          	auipc	ra,0x5
    80000ea8:	05c080e7          	jalr	92(ra) # 80005f00 <panic>

0000000080000eac <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000eac:	7139                	addi	sp,sp,-64
    80000eae:	fc06                	sd	ra,56(sp)
    80000eb0:	f822                	sd	s0,48(sp)
    80000eb2:	f426                	sd	s1,40(sp)
    80000eb4:	f04a                	sd	s2,32(sp)
    80000eb6:	ec4e                	sd	s3,24(sp)
    80000eb8:	e852                	sd	s4,16(sp)
    80000eba:	e456                	sd	s5,8(sp)
    80000ebc:	e05a                	sd	s6,0(sp)
    80000ebe:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000ec0:	00007597          	auipc	a1,0x7
    80000ec4:	2d858593          	addi	a1,a1,728 # 80008198 <etext+0x198>
    80000ec8:	00008517          	auipc	a0,0x8
    80000ecc:	18850513          	addi	a0,a0,392 # 80009050 <pid_lock>
    80000ed0:	00005097          	auipc	ra,0x5
    80000ed4:	4d8080e7          	jalr	1240(ra) # 800063a8 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000ed8:	00007597          	auipc	a1,0x7
    80000edc:	2c858593          	addi	a1,a1,712 # 800081a0 <etext+0x1a0>
    80000ee0:	00008517          	auipc	a0,0x8
    80000ee4:	18850513          	addi	a0,a0,392 # 80009068 <wait_lock>
    80000ee8:	00005097          	auipc	ra,0x5
    80000eec:	4c0080e7          	jalr	1216(ra) # 800063a8 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ef0:	00008497          	auipc	s1,0x8
    80000ef4:	59048493          	addi	s1,s1,1424 # 80009480 <proc>
      initlock(&p->lock, "proc");
    80000ef8:	00007b17          	auipc	s6,0x7
    80000efc:	2b8b0b13          	addi	s6,s6,696 # 800081b0 <etext+0x1b0>
      p->kstack = KSTACK((int) (p - proc));
    80000f00:	8aa6                	mv	s5,s1
    80000f02:	00007a17          	auipc	s4,0x7
    80000f06:	0fea0a13          	addi	s4,s4,254 # 80008000 <etext>
    80000f0a:	01000937          	lui	s2,0x1000
    80000f0e:	197d                	addi	s2,s2,-1 # ffffff <_entry-0x7f000001>
    80000f10:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f12:	0000e997          	auipc	s3,0xe
    80000f16:	36e98993          	addi	s3,s3,878 # 8000f280 <tickslock>
      initlock(&p->lock, "proc");
    80000f1a:	85da                	mv	a1,s6
    80000f1c:	8526                	mv	a0,s1
    80000f1e:	00005097          	auipc	ra,0x5
    80000f22:	48a080e7          	jalr	1162(ra) # 800063a8 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    80000f26:	415487b3          	sub	a5,s1,s5
    80000f2a:	878d                	srai	a5,a5,0x3
    80000f2c:	000a3703          	ld	a4,0(s4)
    80000f30:	02e787b3          	mul	a5,a5,a4
    80000f34:	00d7979b          	slliw	a5,a5,0xd
    80000f38:	40f907b3          	sub	a5,s2,a5
    80000f3c:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f3e:	17848493          	addi	s1,s1,376
    80000f42:	fd349ce3          	bne	s1,s3,80000f1a <procinit+0x6e>
  }
}
    80000f46:	70e2                	ld	ra,56(sp)
    80000f48:	7442                	ld	s0,48(sp)
    80000f4a:	74a2                	ld	s1,40(sp)
    80000f4c:	7902                	ld	s2,32(sp)
    80000f4e:	69e2                	ld	s3,24(sp)
    80000f50:	6a42                	ld	s4,16(sp)
    80000f52:	6aa2                	ld	s5,8(sp)
    80000f54:	6b02                	ld	s6,0(sp)
    80000f56:	6121                	addi	sp,sp,64
    80000f58:	8082                	ret

0000000080000f5a <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000f5a:	1141                	addi	sp,sp,-16
    80000f5c:	e422                	sd	s0,8(sp)
    80000f5e:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f60:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f62:	2501                	sext.w	a0,a0
    80000f64:	6422                	ld	s0,8(sp)
    80000f66:	0141                	addi	sp,sp,16
    80000f68:	8082                	ret

0000000080000f6a <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80000f6a:	1141                	addi	sp,sp,-16
    80000f6c:	e422                	sd	s0,8(sp)
    80000f6e:	0800                	addi	s0,sp,16
    80000f70:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f72:	2781                	sext.w	a5,a5
    80000f74:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f76:	00008517          	auipc	a0,0x8
    80000f7a:	10a50513          	addi	a0,a0,266 # 80009080 <cpus>
    80000f7e:	953e                	add	a0,a0,a5
    80000f80:	6422                	ld	s0,8(sp)
    80000f82:	0141                	addi	sp,sp,16
    80000f84:	8082                	ret

0000000080000f86 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80000f86:	1101                	addi	sp,sp,-32
    80000f88:	ec06                	sd	ra,24(sp)
    80000f8a:	e822                	sd	s0,16(sp)
    80000f8c:	e426                	sd	s1,8(sp)
    80000f8e:	1000                	addi	s0,sp,32
  push_off();
    80000f90:	00005097          	auipc	ra,0x5
    80000f94:	45c080e7          	jalr	1116(ra) # 800063ec <push_off>
    80000f98:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000f9a:	2781                	sext.w	a5,a5
    80000f9c:	079e                	slli	a5,a5,0x7
    80000f9e:	00008717          	auipc	a4,0x8
    80000fa2:	0b270713          	addi	a4,a4,178 # 80009050 <pid_lock>
    80000fa6:	97ba                	add	a5,a5,a4
    80000fa8:	7b84                	ld	s1,48(a5)
  pop_off();
    80000faa:	00005097          	auipc	ra,0x5
    80000fae:	4e2080e7          	jalr	1250(ra) # 8000648c <pop_off>
  return p;
}
    80000fb2:	8526                	mv	a0,s1
    80000fb4:	60e2                	ld	ra,24(sp)
    80000fb6:	6442                	ld	s0,16(sp)
    80000fb8:	64a2                	ld	s1,8(sp)
    80000fba:	6105                	addi	sp,sp,32
    80000fbc:	8082                	ret

0000000080000fbe <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000fbe:	1141                	addi	sp,sp,-16
    80000fc0:	e406                	sd	ra,8(sp)
    80000fc2:	e022                	sd	s0,0(sp)
    80000fc4:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000fc6:	00000097          	auipc	ra,0x0
    80000fca:	fc0080e7          	jalr	-64(ra) # 80000f86 <myproc>
    80000fce:	00005097          	auipc	ra,0x5
    80000fd2:	51e080e7          	jalr	1310(ra) # 800064ec <release>

  if (first) {
    80000fd6:	00008797          	auipc	a5,0x8
    80000fda:	a4a7a783          	lw	a5,-1462(a5) # 80008a20 <first.1>
    80000fde:	eb89                	bnez	a5,80000ff0 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000fe0:	00001097          	auipc	ra,0x1
    80000fe4:	d1e080e7          	jalr	-738(ra) # 80001cfe <usertrapret>
}
    80000fe8:	60a2                	ld	ra,8(sp)
    80000fea:	6402                	ld	s0,0(sp)
    80000fec:	0141                	addi	sp,sp,16
    80000fee:	8082                	ret
    first = 0;
    80000ff0:	00008797          	auipc	a5,0x8
    80000ff4:	a207a823          	sw	zero,-1488(a5) # 80008a20 <first.1>
    fsinit(ROOTDEV);
    80000ff8:	4505                	li	a0,1
    80000ffa:	00002097          	auipc	ra,0x2
    80000ffe:	c04080e7          	jalr	-1020(ra) # 80002bfe <fsinit>
    80001002:	bff9                	j	80000fe0 <forkret+0x22>

0000000080001004 <allocpid>:
allocpid() {
    80001004:	1101                	addi	sp,sp,-32
    80001006:	ec06                	sd	ra,24(sp)
    80001008:	e822                	sd	s0,16(sp)
    8000100a:	e426                	sd	s1,8(sp)
    8000100c:	e04a                	sd	s2,0(sp)
    8000100e:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001010:	00008917          	auipc	s2,0x8
    80001014:	04090913          	addi	s2,s2,64 # 80009050 <pid_lock>
    80001018:	854a                	mv	a0,s2
    8000101a:	00005097          	auipc	ra,0x5
    8000101e:	41e080e7          	jalr	1054(ra) # 80006438 <acquire>
  pid = nextpid;
    80001022:	00008797          	auipc	a5,0x8
    80001026:	a0278793          	addi	a5,a5,-1534 # 80008a24 <nextpid>
    8000102a:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    8000102c:	0014871b          	addiw	a4,s1,1
    80001030:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001032:	854a                	mv	a0,s2
    80001034:	00005097          	auipc	ra,0x5
    80001038:	4b8080e7          	jalr	1208(ra) # 800064ec <release>
}
    8000103c:	8526                	mv	a0,s1
    8000103e:	60e2                	ld	ra,24(sp)
    80001040:	6442                	ld	s0,16(sp)
    80001042:	64a2                	ld	s1,8(sp)
    80001044:	6902                	ld	s2,0(sp)
    80001046:	6105                	addi	sp,sp,32
    80001048:	8082                	ret

000000008000104a <proc_pagetable>:
{
    8000104a:	1101                	addi	sp,sp,-32
    8000104c:	ec06                	sd	ra,24(sp)
    8000104e:	e822                	sd	s0,16(sp)
    80001050:	e426                	sd	s1,8(sp)
    80001052:	e04a                	sd	s2,0(sp)
    80001054:	1000                	addi	s0,sp,32
    80001056:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001058:	fffff097          	auipc	ra,0xfffff
    8000105c:	7be080e7          	jalr	1982(ra) # 80000816 <uvmcreate>
    80001060:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001062:	cd39                	beqz	a0,800010c0 <proc_pagetable+0x76>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001064:	4729                	li	a4,10
    80001066:	00006697          	auipc	a3,0x6
    8000106a:	f9a68693          	addi	a3,a3,-102 # 80007000 <_trampoline>
    8000106e:	6605                	lui	a2,0x1
    80001070:	040005b7          	lui	a1,0x4000
    80001074:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001076:	05b2                	slli	a1,a1,0xc
    80001078:	fffff097          	auipc	ra,0xfffff
    8000107c:	514080e7          	jalr	1300(ra) # 8000058c <mappages>
    80001080:	04054763          	bltz	a0,800010ce <proc_pagetable+0x84>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001084:	4719                	li	a4,6
    80001086:	05893683          	ld	a3,88(s2)
    8000108a:	6605                	lui	a2,0x1
    8000108c:	020005b7          	lui	a1,0x2000
    80001090:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001092:	05b6                	slli	a1,a1,0xd
    80001094:	8526                	mv	a0,s1
    80001096:	fffff097          	auipc	ra,0xfffff
    8000109a:	4f6080e7          	jalr	1270(ra) # 8000058c <mappages>
    8000109e:	04054063          	bltz	a0,800010de <proc_pagetable+0x94>
  if(mappages(pagetable, USYSCALL, PGSIZE, (uint64)(p->usyscall), PTE_R | PTE_U) < 0){
    800010a2:	4749                	li	a4,18
    800010a4:	06093683          	ld	a3,96(s2)
    800010a8:	6605                	lui	a2,0x1
    800010aa:	040005b7          	lui	a1,0x4000
    800010ae:	15f5                	addi	a1,a1,-3 # 3fffffd <_entry-0x7c000003>
    800010b0:	05b2                	slli	a1,a1,0xc
    800010b2:	8526                	mv	a0,s1
    800010b4:	fffff097          	auipc	ra,0xfffff
    800010b8:	4d8080e7          	jalr	1240(ra) # 8000058c <mappages>
    800010bc:	04054463          	bltz	a0,80001104 <proc_pagetable+0xba>
}
    800010c0:	8526                	mv	a0,s1
    800010c2:	60e2                	ld	ra,24(sp)
    800010c4:	6442                	ld	s0,16(sp)
    800010c6:	64a2                	ld	s1,8(sp)
    800010c8:	6902                	ld	s2,0(sp)
    800010ca:	6105                	addi	sp,sp,32
    800010cc:	8082                	ret
    uvmfree(pagetable, 0);
    800010ce:	4581                	li	a1,0
    800010d0:	8526                	mv	a0,s1
    800010d2:	00000097          	auipc	ra,0x0
    800010d6:	942080e7          	jalr	-1726(ra) # 80000a14 <uvmfree>
    return 0;
    800010da:	4481                	li	s1,0
    800010dc:	b7d5                	j	800010c0 <proc_pagetable+0x76>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010de:	4681                	li	a3,0
    800010e0:	4605                	li	a2,1
    800010e2:	040005b7          	lui	a1,0x4000
    800010e6:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800010e8:	05b2                	slli	a1,a1,0xc
    800010ea:	8526                	mv	a0,s1
    800010ec:	fffff097          	auipc	ra,0xfffff
    800010f0:	666080e7          	jalr	1638(ra) # 80000752 <uvmunmap>
    uvmfree(pagetable, 0);
    800010f4:	4581                	li	a1,0
    800010f6:	8526                	mv	a0,s1
    800010f8:	00000097          	auipc	ra,0x0
    800010fc:	91c080e7          	jalr	-1764(ra) # 80000a14 <uvmfree>
    return 0;
    80001100:	4481                	li	s1,0
    80001102:	bf7d                	j	800010c0 <proc_pagetable+0x76>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001104:	4681                	li	a3,0
    80001106:	4605                	li	a2,1
    80001108:	040005b7          	lui	a1,0x4000
    8000110c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000110e:	05b2                	slli	a1,a1,0xc
    80001110:	8526                	mv	a0,s1
    80001112:	fffff097          	auipc	ra,0xfffff
    80001116:	640080e7          	jalr	1600(ra) # 80000752 <uvmunmap>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000111a:	4681                	li	a3,0
    8000111c:	4605                	li	a2,1
    8000111e:	020005b7          	lui	a1,0x2000
    80001122:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001124:	05b6                	slli	a1,a1,0xd
    80001126:	8526                	mv	a0,s1
    80001128:	fffff097          	auipc	ra,0xfffff
    8000112c:	62a080e7          	jalr	1578(ra) # 80000752 <uvmunmap>
    uvmfree(pagetable, 0);
    80001130:	4581                	li	a1,0
    80001132:	8526                	mv	a0,s1
    80001134:	00000097          	auipc	ra,0x0
    80001138:	8e0080e7          	jalr	-1824(ra) # 80000a14 <uvmfree>
    return 0;
    8000113c:	4481                	li	s1,0
    8000113e:	b749                	j	800010c0 <proc_pagetable+0x76>

0000000080001140 <proc_freepagetable>:
{
    80001140:	7179                	addi	sp,sp,-48
    80001142:	f406                	sd	ra,40(sp)
    80001144:	f022                	sd	s0,32(sp)
    80001146:	ec26                	sd	s1,24(sp)
    80001148:	e84a                	sd	s2,16(sp)
    8000114a:	e44e                	sd	s3,8(sp)
    8000114c:	1800                	addi	s0,sp,48
    8000114e:	84aa                	mv	s1,a0
    80001150:	89ae                	mv	s3,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001152:	4681                	li	a3,0
    80001154:	4605                	li	a2,1
    80001156:	04000937          	lui	s2,0x4000
    8000115a:	fff90593          	addi	a1,s2,-1 # 3ffffff <_entry-0x7c000001>
    8000115e:	05b2                	slli	a1,a1,0xc
    80001160:	fffff097          	auipc	ra,0xfffff
    80001164:	5f2080e7          	jalr	1522(ra) # 80000752 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001168:	4681                	li	a3,0
    8000116a:	4605                	li	a2,1
    8000116c:	020005b7          	lui	a1,0x2000
    80001170:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001172:	05b6                	slli	a1,a1,0xd
    80001174:	8526                	mv	a0,s1
    80001176:	fffff097          	auipc	ra,0xfffff
    8000117a:	5dc080e7          	jalr	1500(ra) # 80000752 <uvmunmap>
  uvmunmap(pagetable, USYSCALL, 1, 0);
    8000117e:	4681                	li	a3,0
    80001180:	4605                	li	a2,1
    80001182:	1975                	addi	s2,s2,-3
    80001184:	00c91593          	slli	a1,s2,0xc
    80001188:	8526                	mv	a0,s1
    8000118a:	fffff097          	auipc	ra,0xfffff
    8000118e:	5c8080e7          	jalr	1480(ra) # 80000752 <uvmunmap>
  uvmfree(pagetable, sz);
    80001192:	85ce                	mv	a1,s3
    80001194:	8526                	mv	a0,s1
    80001196:	00000097          	auipc	ra,0x0
    8000119a:	87e080e7          	jalr	-1922(ra) # 80000a14 <uvmfree>
}
    8000119e:	70a2                	ld	ra,40(sp)
    800011a0:	7402                	ld	s0,32(sp)
    800011a2:	64e2                	ld	s1,24(sp)
    800011a4:	6942                	ld	s2,16(sp)
    800011a6:	69a2                	ld	s3,8(sp)
    800011a8:	6145                	addi	sp,sp,48
    800011aa:	8082                	ret

00000000800011ac <freeproc>:
{
    800011ac:	1101                	addi	sp,sp,-32
    800011ae:	ec06                	sd	ra,24(sp)
    800011b0:	e822                	sd	s0,16(sp)
    800011b2:	e426                	sd	s1,8(sp)
    800011b4:	1000                	addi	s0,sp,32
    800011b6:	84aa                	mv	s1,a0
  if(p->trapframe)
    800011b8:	6d28                	ld	a0,88(a0)
    800011ba:	c509                	beqz	a0,800011c4 <freeproc+0x18>
    kfree((void*)p->trapframe);
    800011bc:	fffff097          	auipc	ra,0xfffff
    800011c0:	e60080e7          	jalr	-416(ra) # 8000001c <kfree>
  p->trapframe = 0;
    800011c4:	0404bc23          	sd	zero,88(s1)
  if(p->usyscall){
    800011c8:	70a8                	ld	a0,96(s1)
    800011ca:	c509                	beqz	a0,800011d4 <freeproc+0x28>
    kfree((void*)p->usyscall);
    800011cc:	fffff097          	auipc	ra,0xfffff
    800011d0:	e50080e7          	jalr	-432(ra) # 8000001c <kfree>
  p->usyscall=0;
    800011d4:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    800011d8:	68a8                	ld	a0,80(s1)
    800011da:	c511                	beqz	a0,800011e6 <freeproc+0x3a>
    proc_freepagetable(p->pagetable, p->sz);
    800011dc:	64ac                	ld	a1,72(s1)
    800011de:	00000097          	auipc	ra,0x0
    800011e2:	f62080e7          	jalr	-158(ra) # 80001140 <proc_freepagetable>
  p->pagetable = 0;
    800011e6:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800011ea:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800011ee:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800011f2:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800011f6:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    800011fa:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800011fe:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001202:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001206:	0004ac23          	sw	zero,24(s1)
}
    8000120a:	60e2                	ld	ra,24(sp)
    8000120c:	6442                	ld	s0,16(sp)
    8000120e:	64a2                	ld	s1,8(sp)
    80001210:	6105                	addi	sp,sp,32
    80001212:	8082                	ret

0000000080001214 <allocproc>:
{
    80001214:	1101                	addi	sp,sp,-32
    80001216:	ec06                	sd	ra,24(sp)
    80001218:	e822                	sd	s0,16(sp)
    8000121a:	e426                	sd	s1,8(sp)
    8000121c:	e04a                	sd	s2,0(sp)
    8000121e:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001220:	00008497          	auipc	s1,0x8
    80001224:	26048493          	addi	s1,s1,608 # 80009480 <proc>
    80001228:	0000e917          	auipc	s2,0xe
    8000122c:	05890913          	addi	s2,s2,88 # 8000f280 <tickslock>
    acquire(&p->lock);
    80001230:	8526                	mv	a0,s1
    80001232:	00005097          	auipc	ra,0x5
    80001236:	206080e7          	jalr	518(ra) # 80006438 <acquire>
    if(p->state == UNUSED) {
    8000123a:	4c9c                	lw	a5,24(s1)
    8000123c:	cf81                	beqz	a5,80001254 <allocproc+0x40>
      release(&p->lock);
    8000123e:	8526                	mv	a0,s1
    80001240:	00005097          	auipc	ra,0x5
    80001244:	2ac080e7          	jalr	684(ra) # 800064ec <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001248:	17848493          	addi	s1,s1,376
    8000124c:	ff2492e3          	bne	s1,s2,80001230 <allocproc+0x1c>
  return 0;
    80001250:	4481                	li	s1,0
    80001252:	a095                	j	800012b6 <allocproc+0xa2>
  p->pid = allocpid();
    80001254:	00000097          	auipc	ra,0x0
    80001258:	db0080e7          	jalr	-592(ra) # 80001004 <allocpid>
    8000125c:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000125e:	4785                	li	a5,1
    80001260:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001262:	fffff097          	auipc	ra,0xfffff
    80001266:	eb8080e7          	jalr	-328(ra) # 8000011a <kalloc>
    8000126a:	892a                	mv	s2,a0
    8000126c:	eca8                	sd	a0,88(s1)
    8000126e:	c939                	beqz	a0,800012c4 <allocproc+0xb0>
  if((p->usyscall = (struct usyscall *)kalloc()) == 0){
    80001270:	fffff097          	auipc	ra,0xfffff
    80001274:	eaa080e7          	jalr	-342(ra) # 8000011a <kalloc>
    80001278:	892a                	mv	s2,a0
    8000127a:	f0a8                	sd	a0,96(s1)
    8000127c:	c125                	beqz	a0,800012dc <allocproc+0xc8>
  p->usyscall->pid=p->pid;
    8000127e:	589c                	lw	a5,48(s1)
    80001280:	c11c                	sw	a5,0(a0)
  p->pagetable = proc_pagetable(p);
    80001282:	8526                	mv	a0,s1
    80001284:	00000097          	auipc	ra,0x0
    80001288:	dc6080e7          	jalr	-570(ra) # 8000104a <proc_pagetable>
    8000128c:	892a                	mv	s2,a0
    8000128e:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001290:	c135                	beqz	a0,800012f4 <allocproc+0xe0>
  memset(&p->context, 0, sizeof(p->context));
    80001292:	07000613          	li	a2,112
    80001296:	4581                	li	a1,0
    80001298:	06848513          	addi	a0,s1,104
    8000129c:	fffff097          	auipc	ra,0xfffff
    800012a0:	f28080e7          	jalr	-216(ra) # 800001c4 <memset>
  p->context.ra = (uint64)forkret;
    800012a4:	00000797          	auipc	a5,0x0
    800012a8:	d1a78793          	addi	a5,a5,-742 # 80000fbe <forkret>
    800012ac:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    800012ae:	60bc                	ld	a5,64(s1)
    800012b0:	6705                	lui	a4,0x1
    800012b2:	97ba                	add	a5,a5,a4
    800012b4:	f8bc                	sd	a5,112(s1)
}
    800012b6:	8526                	mv	a0,s1
    800012b8:	60e2                	ld	ra,24(sp)
    800012ba:	6442                	ld	s0,16(sp)
    800012bc:	64a2                	ld	s1,8(sp)
    800012be:	6902                	ld	s2,0(sp)
    800012c0:	6105                	addi	sp,sp,32
    800012c2:	8082                	ret
    freeproc(p);
    800012c4:	8526                	mv	a0,s1
    800012c6:	00000097          	auipc	ra,0x0
    800012ca:	ee6080e7          	jalr	-282(ra) # 800011ac <freeproc>
    release(&p->lock);
    800012ce:	8526                	mv	a0,s1
    800012d0:	00005097          	auipc	ra,0x5
    800012d4:	21c080e7          	jalr	540(ra) # 800064ec <release>
    return 0;
    800012d8:	84ca                	mv	s1,s2
    800012da:	bff1                	j	800012b6 <allocproc+0xa2>
    freeproc(p);
    800012dc:	8526                	mv	a0,s1
    800012de:	00000097          	auipc	ra,0x0
    800012e2:	ece080e7          	jalr	-306(ra) # 800011ac <freeproc>
    release(&p->lock);
    800012e6:	8526                	mv	a0,s1
    800012e8:	00005097          	auipc	ra,0x5
    800012ec:	204080e7          	jalr	516(ra) # 800064ec <release>
    return 0;
    800012f0:	84ca                	mv	s1,s2
    800012f2:	b7d1                	j	800012b6 <allocproc+0xa2>
    freeproc(p);
    800012f4:	8526                	mv	a0,s1
    800012f6:	00000097          	auipc	ra,0x0
    800012fa:	eb6080e7          	jalr	-330(ra) # 800011ac <freeproc>
    release(&p->lock);
    800012fe:	8526                	mv	a0,s1
    80001300:	00005097          	auipc	ra,0x5
    80001304:	1ec080e7          	jalr	492(ra) # 800064ec <release>
    return 0;
    80001308:	84ca                	mv	s1,s2
    8000130a:	b775                	j	800012b6 <allocproc+0xa2>

000000008000130c <userinit>:
{
    8000130c:	1101                	addi	sp,sp,-32
    8000130e:	ec06                	sd	ra,24(sp)
    80001310:	e822                	sd	s0,16(sp)
    80001312:	e426                	sd	s1,8(sp)
    80001314:	1000                	addi	s0,sp,32
  p = allocproc();
    80001316:	00000097          	auipc	ra,0x0
    8000131a:	efe080e7          	jalr	-258(ra) # 80001214 <allocproc>
    8000131e:	84aa                	mv	s1,a0
  initproc = p;
    80001320:	00008797          	auipc	a5,0x8
    80001324:	cea7b823          	sd	a0,-784(a5) # 80009010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001328:	03400613          	li	a2,52
    8000132c:	00007597          	auipc	a1,0x7
    80001330:	70458593          	addi	a1,a1,1796 # 80008a30 <initcode>
    80001334:	6928                	ld	a0,80(a0)
    80001336:	fffff097          	auipc	ra,0xfffff
    8000133a:	50e080e7          	jalr	1294(ra) # 80000844 <uvminit>
  p->sz = PGSIZE;
    8000133e:	6785                	lui	a5,0x1
    80001340:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001342:	6cb8                	ld	a4,88(s1)
    80001344:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001348:	6cb8                	ld	a4,88(s1)
    8000134a:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000134c:	4641                	li	a2,16
    8000134e:	00007597          	auipc	a1,0x7
    80001352:	e6a58593          	addi	a1,a1,-406 # 800081b8 <etext+0x1b8>
    80001356:	16048513          	addi	a0,s1,352
    8000135a:	fffff097          	auipc	ra,0xfffff
    8000135e:	fb4080e7          	jalr	-76(ra) # 8000030e <safestrcpy>
  p->cwd = namei("/");
    80001362:	00007517          	auipc	a0,0x7
    80001366:	e6650513          	addi	a0,a0,-410 # 800081c8 <etext+0x1c8>
    8000136a:	00002097          	auipc	ra,0x2
    8000136e:	2ca080e7          	jalr	714(ra) # 80003634 <namei>
    80001372:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    80001376:	478d                	li	a5,3
    80001378:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000137a:	8526                	mv	a0,s1
    8000137c:	00005097          	auipc	ra,0x5
    80001380:	170080e7          	jalr	368(ra) # 800064ec <release>
}
    80001384:	60e2                	ld	ra,24(sp)
    80001386:	6442                	ld	s0,16(sp)
    80001388:	64a2                	ld	s1,8(sp)
    8000138a:	6105                	addi	sp,sp,32
    8000138c:	8082                	ret

000000008000138e <growproc>:
{
    8000138e:	1101                	addi	sp,sp,-32
    80001390:	ec06                	sd	ra,24(sp)
    80001392:	e822                	sd	s0,16(sp)
    80001394:	e426                	sd	s1,8(sp)
    80001396:	e04a                	sd	s2,0(sp)
    80001398:	1000                	addi	s0,sp,32
    8000139a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000139c:	00000097          	auipc	ra,0x0
    800013a0:	bea080e7          	jalr	-1046(ra) # 80000f86 <myproc>
    800013a4:	892a                	mv	s2,a0
  sz = p->sz;
    800013a6:	652c                	ld	a1,72(a0)
    800013a8:	0005879b          	sext.w	a5,a1
  if(n > 0){
    800013ac:	00904f63          	bgtz	s1,800013ca <growproc+0x3c>
  } else if(n < 0){
    800013b0:	0204cd63          	bltz	s1,800013ea <growproc+0x5c>
  p->sz = sz;
    800013b4:	1782                	slli	a5,a5,0x20
    800013b6:	9381                	srli	a5,a5,0x20
    800013b8:	04f93423          	sd	a5,72(s2)
  return 0;
    800013bc:	4501                	li	a0,0
}
    800013be:	60e2                	ld	ra,24(sp)
    800013c0:	6442                	ld	s0,16(sp)
    800013c2:	64a2                	ld	s1,8(sp)
    800013c4:	6902                	ld	s2,0(sp)
    800013c6:	6105                	addi	sp,sp,32
    800013c8:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800013ca:	00f4863b          	addw	a2,s1,a5
    800013ce:	1602                	slli	a2,a2,0x20
    800013d0:	9201                	srli	a2,a2,0x20
    800013d2:	1582                	slli	a1,a1,0x20
    800013d4:	9181                	srli	a1,a1,0x20
    800013d6:	6928                	ld	a0,80(a0)
    800013d8:	fffff097          	auipc	ra,0xfffff
    800013dc:	526080e7          	jalr	1318(ra) # 800008fe <uvmalloc>
    800013e0:	0005079b          	sext.w	a5,a0
    800013e4:	fbe1                	bnez	a5,800013b4 <growproc+0x26>
      return -1;
    800013e6:	557d                	li	a0,-1
    800013e8:	bfd9                	j	800013be <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800013ea:	00f4863b          	addw	a2,s1,a5
    800013ee:	1602                	slli	a2,a2,0x20
    800013f0:	9201                	srli	a2,a2,0x20
    800013f2:	1582                	slli	a1,a1,0x20
    800013f4:	9181                	srli	a1,a1,0x20
    800013f6:	6928                	ld	a0,80(a0)
    800013f8:	fffff097          	auipc	ra,0xfffff
    800013fc:	4be080e7          	jalr	1214(ra) # 800008b6 <uvmdealloc>
    80001400:	0005079b          	sext.w	a5,a0
    80001404:	bf45                	j	800013b4 <growproc+0x26>

0000000080001406 <fork>:
{
    80001406:	7139                	addi	sp,sp,-64
    80001408:	fc06                	sd	ra,56(sp)
    8000140a:	f822                	sd	s0,48(sp)
    8000140c:	f426                	sd	s1,40(sp)
    8000140e:	f04a                	sd	s2,32(sp)
    80001410:	ec4e                	sd	s3,24(sp)
    80001412:	e852                	sd	s4,16(sp)
    80001414:	e456                	sd	s5,8(sp)
    80001416:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001418:	00000097          	auipc	ra,0x0
    8000141c:	b6e080e7          	jalr	-1170(ra) # 80000f86 <myproc>
    80001420:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001422:	00000097          	auipc	ra,0x0
    80001426:	df2080e7          	jalr	-526(ra) # 80001214 <allocproc>
    8000142a:	12050063          	beqz	a0,8000154a <fork+0x144>
    8000142e:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001430:	048ab603          	ld	a2,72(s5)
    80001434:	692c                	ld	a1,80(a0)
    80001436:	050ab503          	ld	a0,80(s5)
    8000143a:	fffff097          	auipc	ra,0xfffff
    8000143e:	614080e7          	jalr	1556(ra) # 80000a4e <uvmcopy>
    80001442:	04054863          	bltz	a0,80001492 <fork+0x8c>
  np->sz = p->sz;
    80001446:	048ab783          	ld	a5,72(s5)
    8000144a:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    8000144e:	058ab683          	ld	a3,88(s5)
    80001452:	87b6                	mv	a5,a3
    80001454:	0589b703          	ld	a4,88(s3)
    80001458:	12068693          	addi	a3,a3,288
    8000145c:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001460:	6788                	ld	a0,8(a5)
    80001462:	6b8c                	ld	a1,16(a5)
    80001464:	6f90                	ld	a2,24(a5)
    80001466:	01073023          	sd	a6,0(a4)
    8000146a:	e708                	sd	a0,8(a4)
    8000146c:	eb0c                	sd	a1,16(a4)
    8000146e:	ef10                	sd	a2,24(a4)
    80001470:	02078793          	addi	a5,a5,32
    80001474:	02070713          	addi	a4,a4,32
    80001478:	fed792e3          	bne	a5,a3,8000145c <fork+0x56>
  np->trapframe->a0 = 0;
    8000147c:	0589b783          	ld	a5,88(s3)
    80001480:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001484:	0d8a8493          	addi	s1,s5,216
    80001488:	0d898913          	addi	s2,s3,216
    8000148c:	158a8a13          	addi	s4,s5,344
    80001490:	a00d                	j	800014b2 <fork+0xac>
    freeproc(np);
    80001492:	854e                	mv	a0,s3
    80001494:	00000097          	auipc	ra,0x0
    80001498:	d18080e7          	jalr	-744(ra) # 800011ac <freeproc>
    release(&np->lock);
    8000149c:	854e                	mv	a0,s3
    8000149e:	00005097          	auipc	ra,0x5
    800014a2:	04e080e7          	jalr	78(ra) # 800064ec <release>
    return -1;
    800014a6:	597d                	li	s2,-1
    800014a8:	a079                	j	80001536 <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    800014aa:	04a1                	addi	s1,s1,8
    800014ac:	0921                	addi	s2,s2,8
    800014ae:	01448b63          	beq	s1,s4,800014c4 <fork+0xbe>
    if(p->ofile[i])
    800014b2:	6088                	ld	a0,0(s1)
    800014b4:	d97d                	beqz	a0,800014aa <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    800014b6:	00003097          	auipc	ra,0x3
    800014ba:	814080e7          	jalr	-2028(ra) # 80003cca <filedup>
    800014be:	00a93023          	sd	a0,0(s2)
    800014c2:	b7e5                	j	800014aa <fork+0xa4>
  np->cwd = idup(p->cwd);
    800014c4:	158ab503          	ld	a0,344(s5)
    800014c8:	00002097          	auipc	ra,0x2
    800014cc:	972080e7          	jalr	-1678(ra) # 80002e3a <idup>
    800014d0:	14a9bc23          	sd	a0,344(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800014d4:	4641                	li	a2,16
    800014d6:	160a8593          	addi	a1,s5,352
    800014da:	16098513          	addi	a0,s3,352
    800014de:	fffff097          	auipc	ra,0xfffff
    800014e2:	e30080e7          	jalr	-464(ra) # 8000030e <safestrcpy>
  pid = np->pid;
    800014e6:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    800014ea:	854e                	mv	a0,s3
    800014ec:	00005097          	auipc	ra,0x5
    800014f0:	000080e7          	jalr	ra # 800064ec <release>
  acquire(&wait_lock);
    800014f4:	00008497          	auipc	s1,0x8
    800014f8:	b7448493          	addi	s1,s1,-1164 # 80009068 <wait_lock>
    800014fc:	8526                	mv	a0,s1
    800014fe:	00005097          	auipc	ra,0x5
    80001502:	f3a080e7          	jalr	-198(ra) # 80006438 <acquire>
  np->parent = p;
    80001506:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    8000150a:	8526                	mv	a0,s1
    8000150c:	00005097          	auipc	ra,0x5
    80001510:	fe0080e7          	jalr	-32(ra) # 800064ec <release>
  acquire(&np->lock);
    80001514:	854e                	mv	a0,s3
    80001516:	00005097          	auipc	ra,0x5
    8000151a:	f22080e7          	jalr	-222(ra) # 80006438 <acquire>
  np->state = RUNNABLE;
    8000151e:	478d                	li	a5,3
    80001520:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001524:	854e                	mv	a0,s3
    80001526:	00005097          	auipc	ra,0x5
    8000152a:	fc6080e7          	jalr	-58(ra) # 800064ec <release>
  np->trace_mask=p->trace_mask;
    8000152e:	170aa783          	lw	a5,368(s5)
    80001532:	16f9a823          	sw	a5,368(s3)
}
    80001536:	854a                	mv	a0,s2
    80001538:	70e2                	ld	ra,56(sp)
    8000153a:	7442                	ld	s0,48(sp)
    8000153c:	74a2                	ld	s1,40(sp)
    8000153e:	7902                	ld	s2,32(sp)
    80001540:	69e2                	ld	s3,24(sp)
    80001542:	6a42                	ld	s4,16(sp)
    80001544:	6aa2                	ld	s5,8(sp)
    80001546:	6121                	addi	sp,sp,64
    80001548:	8082                	ret
    return -1;
    8000154a:	597d                	li	s2,-1
    8000154c:	b7ed                	j	80001536 <fork+0x130>

000000008000154e <scheduler>:
{
    8000154e:	7139                	addi	sp,sp,-64
    80001550:	fc06                	sd	ra,56(sp)
    80001552:	f822                	sd	s0,48(sp)
    80001554:	f426                	sd	s1,40(sp)
    80001556:	f04a                	sd	s2,32(sp)
    80001558:	ec4e                	sd	s3,24(sp)
    8000155a:	e852                	sd	s4,16(sp)
    8000155c:	e456                	sd	s5,8(sp)
    8000155e:	e05a                	sd	s6,0(sp)
    80001560:	0080                	addi	s0,sp,64
    80001562:	8792                	mv	a5,tp
  int id = r_tp();
    80001564:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001566:	00779a93          	slli	s5,a5,0x7
    8000156a:	00008717          	auipc	a4,0x8
    8000156e:	ae670713          	addi	a4,a4,-1306 # 80009050 <pid_lock>
    80001572:	9756                	add	a4,a4,s5
    80001574:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001578:	00008717          	auipc	a4,0x8
    8000157c:	b1070713          	addi	a4,a4,-1264 # 80009088 <cpus+0x8>
    80001580:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001582:	498d                	li	s3,3
        p->state = RUNNING;
    80001584:	4b11                	li	s6,4
        c->proc = p;
    80001586:	079e                	slli	a5,a5,0x7
    80001588:	00008a17          	auipc	s4,0x8
    8000158c:	ac8a0a13          	addi	s4,s4,-1336 # 80009050 <pid_lock>
    80001590:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001592:	0000e917          	auipc	s2,0xe
    80001596:	cee90913          	addi	s2,s2,-786 # 8000f280 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000159a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000159e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800015a2:	10079073          	csrw	sstatus,a5
    800015a6:	00008497          	auipc	s1,0x8
    800015aa:	eda48493          	addi	s1,s1,-294 # 80009480 <proc>
    800015ae:	a811                	j	800015c2 <scheduler+0x74>
      release(&p->lock);
    800015b0:	8526                	mv	a0,s1
    800015b2:	00005097          	auipc	ra,0x5
    800015b6:	f3a080e7          	jalr	-198(ra) # 800064ec <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800015ba:	17848493          	addi	s1,s1,376
    800015be:	fd248ee3          	beq	s1,s2,8000159a <scheduler+0x4c>
      acquire(&p->lock);
    800015c2:	8526                	mv	a0,s1
    800015c4:	00005097          	auipc	ra,0x5
    800015c8:	e74080e7          	jalr	-396(ra) # 80006438 <acquire>
      if(p->state == RUNNABLE) {
    800015cc:	4c9c                	lw	a5,24(s1)
    800015ce:	ff3791e3          	bne	a5,s3,800015b0 <scheduler+0x62>
        p->state = RUNNING;
    800015d2:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800015d6:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800015da:	06848593          	addi	a1,s1,104
    800015de:	8556                	mv	a0,s5
    800015e0:	00000097          	auipc	ra,0x0
    800015e4:	674080e7          	jalr	1652(ra) # 80001c54 <swtch>
        c->proc = 0;
    800015e8:	020a3823          	sd	zero,48(s4)
    800015ec:	b7d1                	j	800015b0 <scheduler+0x62>

00000000800015ee <sched>:
{
    800015ee:	7179                	addi	sp,sp,-48
    800015f0:	f406                	sd	ra,40(sp)
    800015f2:	f022                	sd	s0,32(sp)
    800015f4:	ec26                	sd	s1,24(sp)
    800015f6:	e84a                	sd	s2,16(sp)
    800015f8:	e44e                	sd	s3,8(sp)
    800015fa:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800015fc:	00000097          	auipc	ra,0x0
    80001600:	98a080e7          	jalr	-1654(ra) # 80000f86 <myproc>
    80001604:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001606:	00005097          	auipc	ra,0x5
    8000160a:	db8080e7          	jalr	-584(ra) # 800063be <holding>
    8000160e:	c93d                	beqz	a0,80001684 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001610:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001612:	2781                	sext.w	a5,a5
    80001614:	079e                	slli	a5,a5,0x7
    80001616:	00008717          	auipc	a4,0x8
    8000161a:	a3a70713          	addi	a4,a4,-1478 # 80009050 <pid_lock>
    8000161e:	97ba                	add	a5,a5,a4
    80001620:	0a87a703          	lw	a4,168(a5)
    80001624:	4785                	li	a5,1
    80001626:	06f71763          	bne	a4,a5,80001694 <sched+0xa6>
  if(p->state == RUNNING)
    8000162a:	4c98                	lw	a4,24(s1)
    8000162c:	4791                	li	a5,4
    8000162e:	06f70b63          	beq	a4,a5,800016a4 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001632:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001636:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001638:	efb5                	bnez	a5,800016b4 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000163a:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000163c:	00008917          	auipc	s2,0x8
    80001640:	a1490913          	addi	s2,s2,-1516 # 80009050 <pid_lock>
    80001644:	2781                	sext.w	a5,a5
    80001646:	079e                	slli	a5,a5,0x7
    80001648:	97ca                	add	a5,a5,s2
    8000164a:	0ac7a983          	lw	s3,172(a5)
    8000164e:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001650:	2781                	sext.w	a5,a5
    80001652:	079e                	slli	a5,a5,0x7
    80001654:	00008597          	auipc	a1,0x8
    80001658:	a3458593          	addi	a1,a1,-1484 # 80009088 <cpus+0x8>
    8000165c:	95be                	add	a1,a1,a5
    8000165e:	06848513          	addi	a0,s1,104
    80001662:	00000097          	auipc	ra,0x0
    80001666:	5f2080e7          	jalr	1522(ra) # 80001c54 <swtch>
    8000166a:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000166c:	2781                	sext.w	a5,a5
    8000166e:	079e                	slli	a5,a5,0x7
    80001670:	993e                	add	s2,s2,a5
    80001672:	0b392623          	sw	s3,172(s2)
}
    80001676:	70a2                	ld	ra,40(sp)
    80001678:	7402                	ld	s0,32(sp)
    8000167a:	64e2                	ld	s1,24(sp)
    8000167c:	6942                	ld	s2,16(sp)
    8000167e:	69a2                	ld	s3,8(sp)
    80001680:	6145                	addi	sp,sp,48
    80001682:	8082                	ret
    panic("sched p->lock");
    80001684:	00007517          	auipc	a0,0x7
    80001688:	b4c50513          	addi	a0,a0,-1204 # 800081d0 <etext+0x1d0>
    8000168c:	00005097          	auipc	ra,0x5
    80001690:	874080e7          	jalr	-1932(ra) # 80005f00 <panic>
    panic("sched locks");
    80001694:	00007517          	auipc	a0,0x7
    80001698:	b4c50513          	addi	a0,a0,-1204 # 800081e0 <etext+0x1e0>
    8000169c:	00005097          	auipc	ra,0x5
    800016a0:	864080e7          	jalr	-1948(ra) # 80005f00 <panic>
    panic("sched running");
    800016a4:	00007517          	auipc	a0,0x7
    800016a8:	b4c50513          	addi	a0,a0,-1204 # 800081f0 <etext+0x1f0>
    800016ac:	00005097          	auipc	ra,0x5
    800016b0:	854080e7          	jalr	-1964(ra) # 80005f00 <panic>
    panic("sched interruptible");
    800016b4:	00007517          	auipc	a0,0x7
    800016b8:	b4c50513          	addi	a0,a0,-1204 # 80008200 <etext+0x200>
    800016bc:	00005097          	auipc	ra,0x5
    800016c0:	844080e7          	jalr	-1980(ra) # 80005f00 <panic>

00000000800016c4 <yield>:
{
    800016c4:	1101                	addi	sp,sp,-32
    800016c6:	ec06                	sd	ra,24(sp)
    800016c8:	e822                	sd	s0,16(sp)
    800016ca:	e426                	sd	s1,8(sp)
    800016cc:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800016ce:	00000097          	auipc	ra,0x0
    800016d2:	8b8080e7          	jalr	-1864(ra) # 80000f86 <myproc>
    800016d6:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800016d8:	00005097          	auipc	ra,0x5
    800016dc:	d60080e7          	jalr	-672(ra) # 80006438 <acquire>
  p->state = RUNNABLE;
    800016e0:	478d                	li	a5,3
    800016e2:	cc9c                	sw	a5,24(s1)
  sched();
    800016e4:	00000097          	auipc	ra,0x0
    800016e8:	f0a080e7          	jalr	-246(ra) # 800015ee <sched>
  release(&p->lock);
    800016ec:	8526                	mv	a0,s1
    800016ee:	00005097          	auipc	ra,0x5
    800016f2:	dfe080e7          	jalr	-514(ra) # 800064ec <release>
}
    800016f6:	60e2                	ld	ra,24(sp)
    800016f8:	6442                	ld	s0,16(sp)
    800016fa:	64a2                	ld	s1,8(sp)
    800016fc:	6105                	addi	sp,sp,32
    800016fe:	8082                	ret

0000000080001700 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001700:	7179                	addi	sp,sp,-48
    80001702:	f406                	sd	ra,40(sp)
    80001704:	f022                	sd	s0,32(sp)
    80001706:	ec26                	sd	s1,24(sp)
    80001708:	e84a                	sd	s2,16(sp)
    8000170a:	e44e                	sd	s3,8(sp)
    8000170c:	1800                	addi	s0,sp,48
    8000170e:	89aa                	mv	s3,a0
    80001710:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001712:	00000097          	auipc	ra,0x0
    80001716:	874080e7          	jalr	-1932(ra) # 80000f86 <myproc>
    8000171a:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000171c:	00005097          	auipc	ra,0x5
    80001720:	d1c080e7          	jalr	-740(ra) # 80006438 <acquire>
  release(lk);
    80001724:	854a                	mv	a0,s2
    80001726:	00005097          	auipc	ra,0x5
    8000172a:	dc6080e7          	jalr	-570(ra) # 800064ec <release>

  // Go to sleep.
  p->chan = chan;
    8000172e:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001732:	4789                	li	a5,2
    80001734:	cc9c                	sw	a5,24(s1)

  sched();
    80001736:	00000097          	auipc	ra,0x0
    8000173a:	eb8080e7          	jalr	-328(ra) # 800015ee <sched>

  // Tidy up.
  p->chan = 0;
    8000173e:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001742:	8526                	mv	a0,s1
    80001744:	00005097          	auipc	ra,0x5
    80001748:	da8080e7          	jalr	-600(ra) # 800064ec <release>
  acquire(lk);
    8000174c:	854a                	mv	a0,s2
    8000174e:	00005097          	auipc	ra,0x5
    80001752:	cea080e7          	jalr	-790(ra) # 80006438 <acquire>
}
    80001756:	70a2                	ld	ra,40(sp)
    80001758:	7402                	ld	s0,32(sp)
    8000175a:	64e2                	ld	s1,24(sp)
    8000175c:	6942                	ld	s2,16(sp)
    8000175e:	69a2                	ld	s3,8(sp)
    80001760:	6145                	addi	sp,sp,48
    80001762:	8082                	ret

0000000080001764 <wait>:
{
    80001764:	715d                	addi	sp,sp,-80
    80001766:	e486                	sd	ra,72(sp)
    80001768:	e0a2                	sd	s0,64(sp)
    8000176a:	fc26                	sd	s1,56(sp)
    8000176c:	f84a                	sd	s2,48(sp)
    8000176e:	f44e                	sd	s3,40(sp)
    80001770:	f052                	sd	s4,32(sp)
    80001772:	ec56                	sd	s5,24(sp)
    80001774:	e85a                	sd	s6,16(sp)
    80001776:	e45e                	sd	s7,8(sp)
    80001778:	e062                	sd	s8,0(sp)
    8000177a:	0880                	addi	s0,sp,80
    8000177c:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000177e:	00000097          	auipc	ra,0x0
    80001782:	808080e7          	jalr	-2040(ra) # 80000f86 <myproc>
    80001786:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001788:	00008517          	auipc	a0,0x8
    8000178c:	8e050513          	addi	a0,a0,-1824 # 80009068 <wait_lock>
    80001790:	00005097          	auipc	ra,0x5
    80001794:	ca8080e7          	jalr	-856(ra) # 80006438 <acquire>
    havekids = 0;
    80001798:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    8000179a:	4a15                	li	s4,5
        havekids = 1;
    8000179c:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    8000179e:	0000e997          	auipc	s3,0xe
    800017a2:	ae298993          	addi	s3,s3,-1310 # 8000f280 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800017a6:	00008c17          	auipc	s8,0x8
    800017aa:	8c2c0c13          	addi	s8,s8,-1854 # 80009068 <wait_lock>
    havekids = 0;
    800017ae:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800017b0:	00008497          	auipc	s1,0x8
    800017b4:	cd048493          	addi	s1,s1,-816 # 80009480 <proc>
    800017b8:	a0bd                	j	80001826 <wait+0xc2>
          pid = np->pid;
    800017ba:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800017be:	000b0e63          	beqz	s6,800017da <wait+0x76>
    800017c2:	4691                	li	a3,4
    800017c4:	02c48613          	addi	a2,s1,44
    800017c8:	85da                	mv	a1,s6
    800017ca:	05093503          	ld	a0,80(s2)
    800017ce:	fffff097          	auipc	ra,0xfffff
    800017d2:	384080e7          	jalr	900(ra) # 80000b52 <copyout>
    800017d6:	02054563          	bltz	a0,80001800 <wait+0x9c>
          freeproc(np);
    800017da:	8526                	mv	a0,s1
    800017dc:	00000097          	auipc	ra,0x0
    800017e0:	9d0080e7          	jalr	-1584(ra) # 800011ac <freeproc>
          release(&np->lock);
    800017e4:	8526                	mv	a0,s1
    800017e6:	00005097          	auipc	ra,0x5
    800017ea:	d06080e7          	jalr	-762(ra) # 800064ec <release>
          release(&wait_lock);
    800017ee:	00008517          	auipc	a0,0x8
    800017f2:	87a50513          	addi	a0,a0,-1926 # 80009068 <wait_lock>
    800017f6:	00005097          	auipc	ra,0x5
    800017fa:	cf6080e7          	jalr	-778(ra) # 800064ec <release>
          return pid;
    800017fe:	a09d                	j	80001864 <wait+0x100>
            release(&np->lock);
    80001800:	8526                	mv	a0,s1
    80001802:	00005097          	auipc	ra,0x5
    80001806:	cea080e7          	jalr	-790(ra) # 800064ec <release>
            release(&wait_lock);
    8000180a:	00008517          	auipc	a0,0x8
    8000180e:	85e50513          	addi	a0,a0,-1954 # 80009068 <wait_lock>
    80001812:	00005097          	auipc	ra,0x5
    80001816:	cda080e7          	jalr	-806(ra) # 800064ec <release>
            return -1;
    8000181a:	59fd                	li	s3,-1
    8000181c:	a0a1                	j	80001864 <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    8000181e:	17848493          	addi	s1,s1,376
    80001822:	03348463          	beq	s1,s3,8000184a <wait+0xe6>
      if(np->parent == p){
    80001826:	7c9c                	ld	a5,56(s1)
    80001828:	ff279be3          	bne	a5,s2,8000181e <wait+0xba>
        acquire(&np->lock);
    8000182c:	8526                	mv	a0,s1
    8000182e:	00005097          	auipc	ra,0x5
    80001832:	c0a080e7          	jalr	-1014(ra) # 80006438 <acquire>
        if(np->state == ZOMBIE){
    80001836:	4c9c                	lw	a5,24(s1)
    80001838:	f94781e3          	beq	a5,s4,800017ba <wait+0x56>
        release(&np->lock);
    8000183c:	8526                	mv	a0,s1
    8000183e:	00005097          	auipc	ra,0x5
    80001842:	cae080e7          	jalr	-850(ra) # 800064ec <release>
        havekids = 1;
    80001846:	8756                	mv	a4,s5
    80001848:	bfd9                	j	8000181e <wait+0xba>
    if(!havekids || p->killed){
    8000184a:	c701                	beqz	a4,80001852 <wait+0xee>
    8000184c:	02892783          	lw	a5,40(s2)
    80001850:	c79d                	beqz	a5,8000187e <wait+0x11a>
      release(&wait_lock);
    80001852:	00008517          	auipc	a0,0x8
    80001856:	81650513          	addi	a0,a0,-2026 # 80009068 <wait_lock>
    8000185a:	00005097          	auipc	ra,0x5
    8000185e:	c92080e7          	jalr	-878(ra) # 800064ec <release>
      return -1;
    80001862:	59fd                	li	s3,-1
}
    80001864:	854e                	mv	a0,s3
    80001866:	60a6                	ld	ra,72(sp)
    80001868:	6406                	ld	s0,64(sp)
    8000186a:	74e2                	ld	s1,56(sp)
    8000186c:	7942                	ld	s2,48(sp)
    8000186e:	79a2                	ld	s3,40(sp)
    80001870:	7a02                	ld	s4,32(sp)
    80001872:	6ae2                	ld	s5,24(sp)
    80001874:	6b42                	ld	s6,16(sp)
    80001876:	6ba2                	ld	s7,8(sp)
    80001878:	6c02                	ld	s8,0(sp)
    8000187a:	6161                	addi	sp,sp,80
    8000187c:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000187e:	85e2                	mv	a1,s8
    80001880:	854a                	mv	a0,s2
    80001882:	00000097          	auipc	ra,0x0
    80001886:	e7e080e7          	jalr	-386(ra) # 80001700 <sleep>
    havekids = 0;
    8000188a:	b715                	j	800017ae <wait+0x4a>

000000008000188c <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000188c:	7139                	addi	sp,sp,-64
    8000188e:	fc06                	sd	ra,56(sp)
    80001890:	f822                	sd	s0,48(sp)
    80001892:	f426                	sd	s1,40(sp)
    80001894:	f04a                	sd	s2,32(sp)
    80001896:	ec4e                	sd	s3,24(sp)
    80001898:	e852                	sd	s4,16(sp)
    8000189a:	e456                	sd	s5,8(sp)
    8000189c:	0080                	addi	s0,sp,64
    8000189e:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800018a0:	00008497          	auipc	s1,0x8
    800018a4:	be048493          	addi	s1,s1,-1056 # 80009480 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800018a8:	4989                	li	s3,2
        p->state = RUNNABLE;
    800018aa:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800018ac:	0000e917          	auipc	s2,0xe
    800018b0:	9d490913          	addi	s2,s2,-1580 # 8000f280 <tickslock>
    800018b4:	a811                	j	800018c8 <wakeup+0x3c>
      }
      release(&p->lock);
    800018b6:	8526                	mv	a0,s1
    800018b8:	00005097          	auipc	ra,0x5
    800018bc:	c34080e7          	jalr	-972(ra) # 800064ec <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800018c0:	17848493          	addi	s1,s1,376
    800018c4:	03248663          	beq	s1,s2,800018f0 <wakeup+0x64>
    if(p != myproc()){
    800018c8:	fffff097          	auipc	ra,0xfffff
    800018cc:	6be080e7          	jalr	1726(ra) # 80000f86 <myproc>
    800018d0:	fea488e3          	beq	s1,a0,800018c0 <wakeup+0x34>
      acquire(&p->lock);
    800018d4:	8526                	mv	a0,s1
    800018d6:	00005097          	auipc	ra,0x5
    800018da:	b62080e7          	jalr	-1182(ra) # 80006438 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800018de:	4c9c                	lw	a5,24(s1)
    800018e0:	fd379be3          	bne	a5,s3,800018b6 <wakeup+0x2a>
    800018e4:	709c                	ld	a5,32(s1)
    800018e6:	fd4798e3          	bne	a5,s4,800018b6 <wakeup+0x2a>
        p->state = RUNNABLE;
    800018ea:	0154ac23          	sw	s5,24(s1)
    800018ee:	b7e1                	j	800018b6 <wakeup+0x2a>
    }
  }
}
    800018f0:	70e2                	ld	ra,56(sp)
    800018f2:	7442                	ld	s0,48(sp)
    800018f4:	74a2                	ld	s1,40(sp)
    800018f6:	7902                	ld	s2,32(sp)
    800018f8:	69e2                	ld	s3,24(sp)
    800018fa:	6a42                	ld	s4,16(sp)
    800018fc:	6aa2                	ld	s5,8(sp)
    800018fe:	6121                	addi	sp,sp,64
    80001900:	8082                	ret

0000000080001902 <reparent>:
{
    80001902:	7179                	addi	sp,sp,-48
    80001904:	f406                	sd	ra,40(sp)
    80001906:	f022                	sd	s0,32(sp)
    80001908:	ec26                	sd	s1,24(sp)
    8000190a:	e84a                	sd	s2,16(sp)
    8000190c:	e44e                	sd	s3,8(sp)
    8000190e:	e052                	sd	s4,0(sp)
    80001910:	1800                	addi	s0,sp,48
    80001912:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001914:	00008497          	auipc	s1,0x8
    80001918:	b6c48493          	addi	s1,s1,-1172 # 80009480 <proc>
      pp->parent = initproc;
    8000191c:	00007a17          	auipc	s4,0x7
    80001920:	6f4a0a13          	addi	s4,s4,1780 # 80009010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001924:	0000e997          	auipc	s3,0xe
    80001928:	95c98993          	addi	s3,s3,-1700 # 8000f280 <tickslock>
    8000192c:	a029                	j	80001936 <reparent+0x34>
    8000192e:	17848493          	addi	s1,s1,376
    80001932:	01348d63          	beq	s1,s3,8000194c <reparent+0x4a>
    if(pp->parent == p){
    80001936:	7c9c                	ld	a5,56(s1)
    80001938:	ff279be3          	bne	a5,s2,8000192e <reparent+0x2c>
      pp->parent = initproc;
    8000193c:	000a3503          	ld	a0,0(s4)
    80001940:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001942:	00000097          	auipc	ra,0x0
    80001946:	f4a080e7          	jalr	-182(ra) # 8000188c <wakeup>
    8000194a:	b7d5                	j	8000192e <reparent+0x2c>
}
    8000194c:	70a2                	ld	ra,40(sp)
    8000194e:	7402                	ld	s0,32(sp)
    80001950:	64e2                	ld	s1,24(sp)
    80001952:	6942                	ld	s2,16(sp)
    80001954:	69a2                	ld	s3,8(sp)
    80001956:	6a02                	ld	s4,0(sp)
    80001958:	6145                	addi	sp,sp,48
    8000195a:	8082                	ret

000000008000195c <exit>:
{
    8000195c:	7179                	addi	sp,sp,-48
    8000195e:	f406                	sd	ra,40(sp)
    80001960:	f022                	sd	s0,32(sp)
    80001962:	ec26                	sd	s1,24(sp)
    80001964:	e84a                	sd	s2,16(sp)
    80001966:	e44e                	sd	s3,8(sp)
    80001968:	e052                	sd	s4,0(sp)
    8000196a:	1800                	addi	s0,sp,48
    8000196c:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000196e:	fffff097          	auipc	ra,0xfffff
    80001972:	618080e7          	jalr	1560(ra) # 80000f86 <myproc>
    80001976:	89aa                	mv	s3,a0
  if(p == initproc)
    80001978:	00007797          	auipc	a5,0x7
    8000197c:	6987b783          	ld	a5,1688(a5) # 80009010 <initproc>
    80001980:	0d850493          	addi	s1,a0,216
    80001984:	15850913          	addi	s2,a0,344
    80001988:	02a79363          	bne	a5,a0,800019ae <exit+0x52>
    panic("init exiting");
    8000198c:	00007517          	auipc	a0,0x7
    80001990:	88c50513          	addi	a0,a0,-1908 # 80008218 <etext+0x218>
    80001994:	00004097          	auipc	ra,0x4
    80001998:	56c080e7          	jalr	1388(ra) # 80005f00 <panic>
      fileclose(f);
    8000199c:	00002097          	auipc	ra,0x2
    800019a0:	380080e7          	jalr	896(ra) # 80003d1c <fileclose>
      p->ofile[fd] = 0;
    800019a4:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800019a8:	04a1                	addi	s1,s1,8
    800019aa:	01248563          	beq	s1,s2,800019b4 <exit+0x58>
    if(p->ofile[fd]){
    800019ae:	6088                	ld	a0,0(s1)
    800019b0:	f575                	bnez	a0,8000199c <exit+0x40>
    800019b2:	bfdd                	j	800019a8 <exit+0x4c>
  begin_op();
    800019b4:	00002097          	auipc	ra,0x2
    800019b8:	ea0080e7          	jalr	-352(ra) # 80003854 <begin_op>
  iput(p->cwd);
    800019bc:	1589b503          	ld	a0,344(s3)
    800019c0:	00001097          	auipc	ra,0x1
    800019c4:	672080e7          	jalr	1650(ra) # 80003032 <iput>
  end_op();
    800019c8:	00002097          	auipc	ra,0x2
    800019cc:	f0a080e7          	jalr	-246(ra) # 800038d2 <end_op>
  p->cwd = 0;
    800019d0:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    800019d4:	00007497          	auipc	s1,0x7
    800019d8:	69448493          	addi	s1,s1,1684 # 80009068 <wait_lock>
    800019dc:	8526                	mv	a0,s1
    800019de:	00005097          	auipc	ra,0x5
    800019e2:	a5a080e7          	jalr	-1446(ra) # 80006438 <acquire>
  reparent(p);
    800019e6:	854e                	mv	a0,s3
    800019e8:	00000097          	auipc	ra,0x0
    800019ec:	f1a080e7          	jalr	-230(ra) # 80001902 <reparent>
  wakeup(p->parent);
    800019f0:	0389b503          	ld	a0,56(s3)
    800019f4:	00000097          	auipc	ra,0x0
    800019f8:	e98080e7          	jalr	-360(ra) # 8000188c <wakeup>
  acquire(&p->lock);
    800019fc:	854e                	mv	a0,s3
    800019fe:	00005097          	auipc	ra,0x5
    80001a02:	a3a080e7          	jalr	-1478(ra) # 80006438 <acquire>
  p->xstate = status;
    80001a06:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001a0a:	4795                	li	a5,5
    80001a0c:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001a10:	8526                	mv	a0,s1
    80001a12:	00005097          	auipc	ra,0x5
    80001a16:	ada080e7          	jalr	-1318(ra) # 800064ec <release>
  sched();
    80001a1a:	00000097          	auipc	ra,0x0
    80001a1e:	bd4080e7          	jalr	-1068(ra) # 800015ee <sched>
  panic("zombie exit");
    80001a22:	00007517          	auipc	a0,0x7
    80001a26:	80650513          	addi	a0,a0,-2042 # 80008228 <etext+0x228>
    80001a2a:	00004097          	auipc	ra,0x4
    80001a2e:	4d6080e7          	jalr	1238(ra) # 80005f00 <panic>

0000000080001a32 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001a32:	7179                	addi	sp,sp,-48
    80001a34:	f406                	sd	ra,40(sp)
    80001a36:	f022                	sd	s0,32(sp)
    80001a38:	ec26                	sd	s1,24(sp)
    80001a3a:	e84a                	sd	s2,16(sp)
    80001a3c:	e44e                	sd	s3,8(sp)
    80001a3e:	1800                	addi	s0,sp,48
    80001a40:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001a42:	00008497          	auipc	s1,0x8
    80001a46:	a3e48493          	addi	s1,s1,-1474 # 80009480 <proc>
    80001a4a:	0000e997          	auipc	s3,0xe
    80001a4e:	83698993          	addi	s3,s3,-1994 # 8000f280 <tickslock>
    acquire(&p->lock);
    80001a52:	8526                	mv	a0,s1
    80001a54:	00005097          	auipc	ra,0x5
    80001a58:	9e4080e7          	jalr	-1564(ra) # 80006438 <acquire>
    if(p->pid == pid){
    80001a5c:	589c                	lw	a5,48(s1)
    80001a5e:	01278d63          	beq	a5,s2,80001a78 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001a62:	8526                	mv	a0,s1
    80001a64:	00005097          	auipc	ra,0x5
    80001a68:	a88080e7          	jalr	-1400(ra) # 800064ec <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a6c:	17848493          	addi	s1,s1,376
    80001a70:	ff3491e3          	bne	s1,s3,80001a52 <kill+0x20>
  }
  return -1;
    80001a74:	557d                	li	a0,-1
    80001a76:	a829                	j	80001a90 <kill+0x5e>
      p->killed = 1;
    80001a78:	4785                	li	a5,1
    80001a7a:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001a7c:	4c98                	lw	a4,24(s1)
    80001a7e:	4789                	li	a5,2
    80001a80:	00f70f63          	beq	a4,a5,80001a9e <kill+0x6c>
      release(&p->lock);
    80001a84:	8526                	mv	a0,s1
    80001a86:	00005097          	auipc	ra,0x5
    80001a8a:	a66080e7          	jalr	-1434(ra) # 800064ec <release>
      return 0;
    80001a8e:	4501                	li	a0,0
}
    80001a90:	70a2                	ld	ra,40(sp)
    80001a92:	7402                	ld	s0,32(sp)
    80001a94:	64e2                	ld	s1,24(sp)
    80001a96:	6942                	ld	s2,16(sp)
    80001a98:	69a2                	ld	s3,8(sp)
    80001a9a:	6145                	addi	sp,sp,48
    80001a9c:	8082                	ret
        p->state = RUNNABLE;
    80001a9e:	478d                	li	a5,3
    80001aa0:	cc9c                	sw	a5,24(s1)
    80001aa2:	b7cd                	j	80001a84 <kill+0x52>

0000000080001aa4 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001aa4:	7179                	addi	sp,sp,-48
    80001aa6:	f406                	sd	ra,40(sp)
    80001aa8:	f022                	sd	s0,32(sp)
    80001aaa:	ec26                	sd	s1,24(sp)
    80001aac:	e84a                	sd	s2,16(sp)
    80001aae:	e44e                	sd	s3,8(sp)
    80001ab0:	e052                	sd	s4,0(sp)
    80001ab2:	1800                	addi	s0,sp,48
    80001ab4:	84aa                	mv	s1,a0
    80001ab6:	892e                	mv	s2,a1
    80001ab8:	89b2                	mv	s3,a2
    80001aba:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001abc:	fffff097          	auipc	ra,0xfffff
    80001ac0:	4ca080e7          	jalr	1226(ra) # 80000f86 <myproc>
  if(user_dst){
    80001ac4:	c08d                	beqz	s1,80001ae6 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001ac6:	86d2                	mv	a3,s4
    80001ac8:	864e                	mv	a2,s3
    80001aca:	85ca                	mv	a1,s2
    80001acc:	6928                	ld	a0,80(a0)
    80001ace:	fffff097          	auipc	ra,0xfffff
    80001ad2:	084080e7          	jalr	132(ra) # 80000b52 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001ad6:	70a2                	ld	ra,40(sp)
    80001ad8:	7402                	ld	s0,32(sp)
    80001ada:	64e2                	ld	s1,24(sp)
    80001adc:	6942                	ld	s2,16(sp)
    80001ade:	69a2                	ld	s3,8(sp)
    80001ae0:	6a02                	ld	s4,0(sp)
    80001ae2:	6145                	addi	sp,sp,48
    80001ae4:	8082                	ret
    memmove((char *)dst, src, len);
    80001ae6:	000a061b          	sext.w	a2,s4
    80001aea:	85ce                	mv	a1,s3
    80001aec:	854a                	mv	a0,s2
    80001aee:	ffffe097          	auipc	ra,0xffffe
    80001af2:	732080e7          	jalr	1842(ra) # 80000220 <memmove>
    return 0;
    80001af6:	8526                	mv	a0,s1
    80001af8:	bff9                	j	80001ad6 <either_copyout+0x32>

0000000080001afa <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001afa:	7179                	addi	sp,sp,-48
    80001afc:	f406                	sd	ra,40(sp)
    80001afe:	f022                	sd	s0,32(sp)
    80001b00:	ec26                	sd	s1,24(sp)
    80001b02:	e84a                	sd	s2,16(sp)
    80001b04:	e44e                	sd	s3,8(sp)
    80001b06:	e052                	sd	s4,0(sp)
    80001b08:	1800                	addi	s0,sp,48
    80001b0a:	892a                	mv	s2,a0
    80001b0c:	84ae                	mv	s1,a1
    80001b0e:	89b2                	mv	s3,a2
    80001b10:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001b12:	fffff097          	auipc	ra,0xfffff
    80001b16:	474080e7          	jalr	1140(ra) # 80000f86 <myproc>
  if(user_src){
    80001b1a:	c08d                	beqz	s1,80001b3c <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001b1c:	86d2                	mv	a3,s4
    80001b1e:	864e                	mv	a2,s3
    80001b20:	85ca                	mv	a1,s2
    80001b22:	6928                	ld	a0,80(a0)
    80001b24:	fffff097          	auipc	ra,0xfffff
    80001b28:	0ba080e7          	jalr	186(ra) # 80000bde <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001b2c:	70a2                	ld	ra,40(sp)
    80001b2e:	7402                	ld	s0,32(sp)
    80001b30:	64e2                	ld	s1,24(sp)
    80001b32:	6942                	ld	s2,16(sp)
    80001b34:	69a2                	ld	s3,8(sp)
    80001b36:	6a02                	ld	s4,0(sp)
    80001b38:	6145                	addi	sp,sp,48
    80001b3a:	8082                	ret
    memmove(dst, (char*)src, len);
    80001b3c:	000a061b          	sext.w	a2,s4
    80001b40:	85ce                	mv	a1,s3
    80001b42:	854a                	mv	a0,s2
    80001b44:	ffffe097          	auipc	ra,0xffffe
    80001b48:	6dc080e7          	jalr	1756(ra) # 80000220 <memmove>
    return 0;
    80001b4c:	8526                	mv	a0,s1
    80001b4e:	bff9                	j	80001b2c <either_copyin+0x32>

0000000080001b50 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001b50:	715d                	addi	sp,sp,-80
    80001b52:	e486                	sd	ra,72(sp)
    80001b54:	e0a2                	sd	s0,64(sp)
    80001b56:	fc26                	sd	s1,56(sp)
    80001b58:	f84a                	sd	s2,48(sp)
    80001b5a:	f44e                	sd	s3,40(sp)
    80001b5c:	f052                	sd	s4,32(sp)
    80001b5e:	ec56                	sd	s5,24(sp)
    80001b60:	e85a                	sd	s6,16(sp)
    80001b62:	e45e                	sd	s7,8(sp)
    80001b64:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001b66:	00006517          	auipc	a0,0x6
    80001b6a:	4e250513          	addi	a0,a0,1250 # 80008048 <etext+0x48>
    80001b6e:	00004097          	auipc	ra,0x4
    80001b72:	3dc080e7          	jalr	988(ra) # 80005f4a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b76:	00008497          	auipc	s1,0x8
    80001b7a:	a6a48493          	addi	s1,s1,-1430 # 800095e0 <proc+0x160>
    80001b7e:	0000e917          	auipc	s2,0xe
    80001b82:	86290913          	addi	s2,s2,-1950 # 8000f3e0 <bcache+0x148>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b86:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001b88:	00006997          	auipc	s3,0x6
    80001b8c:	6b098993          	addi	s3,s3,1712 # 80008238 <etext+0x238>
    printf("%d %s %s", p->pid, state, p->name);
    80001b90:	00006a97          	auipc	s5,0x6
    80001b94:	6b0a8a93          	addi	s5,s5,1712 # 80008240 <etext+0x240>
    printf("\n");
    80001b98:	00006a17          	auipc	s4,0x6
    80001b9c:	4b0a0a13          	addi	s4,s4,1200 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ba0:	00006b97          	auipc	s7,0x6
    80001ba4:	6d8b8b93          	addi	s7,s7,1752 # 80008278 <states.0>
    80001ba8:	a00d                	j	80001bca <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001baa:	ed06a583          	lw	a1,-304(a3)
    80001bae:	8556                	mv	a0,s5
    80001bb0:	00004097          	auipc	ra,0x4
    80001bb4:	39a080e7          	jalr	922(ra) # 80005f4a <printf>
    printf("\n");
    80001bb8:	8552                	mv	a0,s4
    80001bba:	00004097          	auipc	ra,0x4
    80001bbe:	390080e7          	jalr	912(ra) # 80005f4a <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001bc2:	17848493          	addi	s1,s1,376
    80001bc6:	03248263          	beq	s1,s2,80001bea <procdump+0x9a>
    if(p->state == UNUSED)
    80001bca:	86a6                	mv	a3,s1
    80001bcc:	eb84a783          	lw	a5,-328(s1)
    80001bd0:	dbed                	beqz	a5,80001bc2 <procdump+0x72>
      state = "???";
    80001bd2:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001bd4:	fcfb6be3          	bltu	s6,a5,80001baa <procdump+0x5a>
    80001bd8:	02079713          	slli	a4,a5,0x20
    80001bdc:	01d75793          	srli	a5,a4,0x1d
    80001be0:	97de                	add	a5,a5,s7
    80001be2:	6390                	ld	a2,0(a5)
    80001be4:	f279                	bnez	a2,80001baa <procdump+0x5a>
      state = "???";
    80001be6:	864e                	mv	a2,s3
    80001be8:	b7c9                	j	80001baa <procdump+0x5a>
  }
}
    80001bea:	60a6                	ld	ra,72(sp)
    80001bec:	6406                	ld	s0,64(sp)
    80001bee:	74e2                	ld	s1,56(sp)
    80001bf0:	7942                	ld	s2,48(sp)
    80001bf2:	79a2                	ld	s3,40(sp)
    80001bf4:	7a02                	ld	s4,32(sp)
    80001bf6:	6ae2                	ld	s5,24(sp)
    80001bf8:	6b42                	ld	s6,16(sp)
    80001bfa:	6ba2                	ld	s7,8(sp)
    80001bfc:	6161                	addi	sp,sp,80
    80001bfe:	8082                	ret

0000000080001c00 <nproc>:

uint64
nproc(void)
{
    80001c00:	7179                	addi	sp,sp,-48
    80001c02:	f406                	sd	ra,40(sp)
    80001c04:	f022                	sd	s0,32(sp)
    80001c06:	ec26                	sd	s1,24(sp)
    80001c08:	e84a                	sd	s2,16(sp)
    80001c0a:	e44e                	sd	s3,8(sp)
    80001c0c:	1800                	addi	s0,sp,48
  struct proc *p;
  uint64 num = 0;
    80001c0e:	4901                	li	s2,0

  for(p=proc;p<&proc[NPROC];p++){
    80001c10:	00008497          	auipc	s1,0x8
    80001c14:	87048493          	addi	s1,s1,-1936 # 80009480 <proc>
    80001c18:	0000d997          	auipc	s3,0xd
    80001c1c:	66898993          	addi	s3,s3,1640 # 8000f280 <tickslock>
    acquire(&p->lock);
    80001c20:	8526                	mv	a0,s1
    80001c22:	00005097          	auipc	ra,0x5
    80001c26:	816080e7          	jalr	-2026(ra) # 80006438 <acquire>
    if(p->state != UNUSED){
    80001c2a:	4c9c                	lw	a5,24(s1)
      num++;
    80001c2c:	00f037b3          	snez	a5,a5
    80001c30:	993e                	add	s2,s2,a5
    }
    release(&p->lock);
    80001c32:	8526                	mv	a0,s1
    80001c34:	00005097          	auipc	ra,0x5
    80001c38:	8b8080e7          	jalr	-1864(ra) # 800064ec <release>
  for(p=proc;p<&proc[NPROC];p++){
    80001c3c:	17848493          	addi	s1,s1,376
    80001c40:	ff3490e3          	bne	s1,s3,80001c20 <nproc+0x20>
  }

  return num;
    80001c44:	854a                	mv	a0,s2
    80001c46:	70a2                	ld	ra,40(sp)
    80001c48:	7402                	ld	s0,32(sp)
    80001c4a:	64e2                	ld	s1,24(sp)
    80001c4c:	6942                	ld	s2,16(sp)
    80001c4e:	69a2                	ld	s3,8(sp)
    80001c50:	6145                	addi	sp,sp,48
    80001c52:	8082                	ret

0000000080001c54 <swtch>:
    80001c54:	00153023          	sd	ra,0(a0)
    80001c58:	00253423          	sd	sp,8(a0)
    80001c5c:	e900                	sd	s0,16(a0)
    80001c5e:	ed04                	sd	s1,24(a0)
    80001c60:	03253023          	sd	s2,32(a0)
    80001c64:	03353423          	sd	s3,40(a0)
    80001c68:	03453823          	sd	s4,48(a0)
    80001c6c:	03553c23          	sd	s5,56(a0)
    80001c70:	05653023          	sd	s6,64(a0)
    80001c74:	05753423          	sd	s7,72(a0)
    80001c78:	05853823          	sd	s8,80(a0)
    80001c7c:	05953c23          	sd	s9,88(a0)
    80001c80:	07a53023          	sd	s10,96(a0)
    80001c84:	07b53423          	sd	s11,104(a0)
    80001c88:	0005b083          	ld	ra,0(a1)
    80001c8c:	0085b103          	ld	sp,8(a1)
    80001c90:	6980                	ld	s0,16(a1)
    80001c92:	6d84                	ld	s1,24(a1)
    80001c94:	0205b903          	ld	s2,32(a1)
    80001c98:	0285b983          	ld	s3,40(a1)
    80001c9c:	0305ba03          	ld	s4,48(a1)
    80001ca0:	0385ba83          	ld	s5,56(a1)
    80001ca4:	0405bb03          	ld	s6,64(a1)
    80001ca8:	0485bb83          	ld	s7,72(a1)
    80001cac:	0505bc03          	ld	s8,80(a1)
    80001cb0:	0585bc83          	ld	s9,88(a1)
    80001cb4:	0605bd03          	ld	s10,96(a1)
    80001cb8:	0685bd83          	ld	s11,104(a1)
    80001cbc:	8082                	ret

0000000080001cbe <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001cbe:	1141                	addi	sp,sp,-16
    80001cc0:	e406                	sd	ra,8(sp)
    80001cc2:	e022                	sd	s0,0(sp)
    80001cc4:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001cc6:	00006597          	auipc	a1,0x6
    80001cca:	5e258593          	addi	a1,a1,1506 # 800082a8 <states.0+0x30>
    80001cce:	0000d517          	auipc	a0,0xd
    80001cd2:	5b250513          	addi	a0,a0,1458 # 8000f280 <tickslock>
    80001cd6:	00004097          	auipc	ra,0x4
    80001cda:	6d2080e7          	jalr	1746(ra) # 800063a8 <initlock>
}
    80001cde:	60a2                	ld	ra,8(sp)
    80001ce0:	6402                	ld	s0,0(sp)
    80001ce2:	0141                	addi	sp,sp,16
    80001ce4:	8082                	ret

0000000080001ce6 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001ce6:	1141                	addi	sp,sp,-16
    80001ce8:	e422                	sd	s0,8(sp)
    80001cea:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cec:	00003797          	auipc	a5,0x3
    80001cf0:	67478793          	addi	a5,a5,1652 # 80005360 <kernelvec>
    80001cf4:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001cf8:	6422                	ld	s0,8(sp)
    80001cfa:	0141                	addi	sp,sp,16
    80001cfc:	8082                	ret

0000000080001cfe <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001cfe:	1141                	addi	sp,sp,-16
    80001d00:	e406                	sd	ra,8(sp)
    80001d02:	e022                	sd	s0,0(sp)
    80001d04:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001d06:	fffff097          	auipc	ra,0xfffff
    80001d0a:	280080e7          	jalr	640(ra) # 80000f86 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d0e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001d12:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d14:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001d18:	00005697          	auipc	a3,0x5
    80001d1c:	2e868693          	addi	a3,a3,744 # 80007000 <_trampoline>
    80001d20:	00005717          	auipc	a4,0x5
    80001d24:	2e070713          	addi	a4,a4,736 # 80007000 <_trampoline>
    80001d28:	8f15                	sub	a4,a4,a3
    80001d2a:	040007b7          	lui	a5,0x4000
    80001d2e:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001d30:	07b2                	slli	a5,a5,0xc
    80001d32:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d34:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001d38:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001d3a:	18002673          	csrr	a2,satp
    80001d3e:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001d40:	6d30                	ld	a2,88(a0)
    80001d42:	6138                	ld	a4,64(a0)
    80001d44:	6585                	lui	a1,0x1
    80001d46:	972e                	add	a4,a4,a1
    80001d48:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001d4a:	6d38                	ld	a4,88(a0)
    80001d4c:	00000617          	auipc	a2,0x0
    80001d50:	13860613          	addi	a2,a2,312 # 80001e84 <usertrap>
    80001d54:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001d56:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d58:	8612                	mv	a2,tp
    80001d5a:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d5c:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001d60:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001d64:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d68:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001d6c:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001d6e:	6f18                	ld	a4,24(a4)
    80001d70:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001d74:	692c                	ld	a1,80(a0)
    80001d76:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001d78:	00005717          	auipc	a4,0x5
    80001d7c:	31870713          	addi	a4,a4,792 # 80007090 <userret>
    80001d80:	8f15                	sub	a4,a4,a3
    80001d82:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001d84:	577d                	li	a4,-1
    80001d86:	177e                	slli	a4,a4,0x3f
    80001d88:	8dd9                	or	a1,a1,a4
    80001d8a:	02000537          	lui	a0,0x2000
    80001d8e:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001d90:	0536                	slli	a0,a0,0xd
    80001d92:	9782                	jalr	a5
}
    80001d94:	60a2                	ld	ra,8(sp)
    80001d96:	6402                	ld	s0,0(sp)
    80001d98:	0141                	addi	sp,sp,16
    80001d9a:	8082                	ret

0000000080001d9c <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001d9c:	1101                	addi	sp,sp,-32
    80001d9e:	ec06                	sd	ra,24(sp)
    80001da0:	e822                	sd	s0,16(sp)
    80001da2:	e426                	sd	s1,8(sp)
    80001da4:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001da6:	0000d497          	auipc	s1,0xd
    80001daa:	4da48493          	addi	s1,s1,1242 # 8000f280 <tickslock>
    80001dae:	8526                	mv	a0,s1
    80001db0:	00004097          	auipc	ra,0x4
    80001db4:	688080e7          	jalr	1672(ra) # 80006438 <acquire>
  ticks++;
    80001db8:	00007517          	auipc	a0,0x7
    80001dbc:	26050513          	addi	a0,a0,608 # 80009018 <ticks>
    80001dc0:	411c                	lw	a5,0(a0)
    80001dc2:	2785                	addiw	a5,a5,1
    80001dc4:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001dc6:	00000097          	auipc	ra,0x0
    80001dca:	ac6080e7          	jalr	-1338(ra) # 8000188c <wakeup>
  release(&tickslock);
    80001dce:	8526                	mv	a0,s1
    80001dd0:	00004097          	auipc	ra,0x4
    80001dd4:	71c080e7          	jalr	1820(ra) # 800064ec <release>
}
    80001dd8:	60e2                	ld	ra,24(sp)
    80001dda:	6442                	ld	s0,16(sp)
    80001ddc:	64a2                	ld	s1,8(sp)
    80001dde:	6105                	addi	sp,sp,32
    80001de0:	8082                	ret

0000000080001de2 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001de2:	1101                	addi	sp,sp,-32
    80001de4:	ec06                	sd	ra,24(sp)
    80001de6:	e822                	sd	s0,16(sp)
    80001de8:	e426                	sd	s1,8(sp)
    80001dea:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dec:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001df0:	00074d63          	bltz	a4,80001e0a <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001df4:	57fd                	li	a5,-1
    80001df6:	17fe                	slli	a5,a5,0x3f
    80001df8:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001dfa:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001dfc:	06f70363          	beq	a4,a5,80001e62 <devintr+0x80>
  }
}
    80001e00:	60e2                	ld	ra,24(sp)
    80001e02:	6442                	ld	s0,16(sp)
    80001e04:	64a2                	ld	s1,8(sp)
    80001e06:	6105                	addi	sp,sp,32
    80001e08:	8082                	ret
     (scause & 0xff) == 9){
    80001e0a:	0ff77793          	zext.b	a5,a4
  if((scause & 0x8000000000000000L) &&
    80001e0e:	46a5                	li	a3,9
    80001e10:	fed792e3          	bne	a5,a3,80001df4 <devintr+0x12>
    int irq = plic_claim();
    80001e14:	00003097          	auipc	ra,0x3
    80001e18:	654080e7          	jalr	1620(ra) # 80005468 <plic_claim>
    80001e1c:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001e1e:	47a9                	li	a5,10
    80001e20:	02f50763          	beq	a0,a5,80001e4e <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001e24:	4785                	li	a5,1
    80001e26:	02f50963          	beq	a0,a5,80001e58 <devintr+0x76>
    return 1;
    80001e2a:	4505                	li	a0,1
    } else if(irq){
    80001e2c:	d8f1                	beqz	s1,80001e00 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001e2e:	85a6                	mv	a1,s1
    80001e30:	00006517          	auipc	a0,0x6
    80001e34:	48050513          	addi	a0,a0,1152 # 800082b0 <states.0+0x38>
    80001e38:	00004097          	auipc	ra,0x4
    80001e3c:	112080e7          	jalr	274(ra) # 80005f4a <printf>
      plic_complete(irq);
    80001e40:	8526                	mv	a0,s1
    80001e42:	00003097          	auipc	ra,0x3
    80001e46:	64a080e7          	jalr	1610(ra) # 8000548c <plic_complete>
    return 1;
    80001e4a:	4505                	li	a0,1
    80001e4c:	bf55                	j	80001e00 <devintr+0x1e>
      uartintr();
    80001e4e:	00004097          	auipc	ra,0x4
    80001e52:	50a080e7          	jalr	1290(ra) # 80006358 <uartintr>
    80001e56:	b7ed                	j	80001e40 <devintr+0x5e>
      virtio_disk_intr();
    80001e58:	00004097          	auipc	ra,0x4
    80001e5c:	ac0080e7          	jalr	-1344(ra) # 80005918 <virtio_disk_intr>
    80001e60:	b7c5                	j	80001e40 <devintr+0x5e>
    if(cpuid() == 0){
    80001e62:	fffff097          	auipc	ra,0xfffff
    80001e66:	0f8080e7          	jalr	248(ra) # 80000f5a <cpuid>
    80001e6a:	c901                	beqz	a0,80001e7a <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001e6c:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001e70:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001e72:	14479073          	csrw	sip,a5
    return 2;
    80001e76:	4509                	li	a0,2
    80001e78:	b761                	j	80001e00 <devintr+0x1e>
      clockintr();
    80001e7a:	00000097          	auipc	ra,0x0
    80001e7e:	f22080e7          	jalr	-222(ra) # 80001d9c <clockintr>
    80001e82:	b7ed                	j	80001e6c <devintr+0x8a>

0000000080001e84 <usertrap>:
{
    80001e84:	1101                	addi	sp,sp,-32
    80001e86:	ec06                	sd	ra,24(sp)
    80001e88:	e822                	sd	s0,16(sp)
    80001e8a:	e426                	sd	s1,8(sp)
    80001e8c:	e04a                	sd	s2,0(sp)
    80001e8e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e90:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001e94:	1007f793          	andi	a5,a5,256
    80001e98:	e3ad                	bnez	a5,80001efa <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001e9a:	00003797          	auipc	a5,0x3
    80001e9e:	4c678793          	addi	a5,a5,1222 # 80005360 <kernelvec>
    80001ea2:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001ea6:	fffff097          	auipc	ra,0xfffff
    80001eaa:	0e0080e7          	jalr	224(ra) # 80000f86 <myproc>
    80001eae:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001eb0:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001eb2:	14102773          	csrr	a4,sepc
    80001eb6:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001eb8:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001ebc:	47a1                	li	a5,8
    80001ebe:	04f71c63          	bne	a4,a5,80001f16 <usertrap+0x92>
    if(p->killed)
    80001ec2:	551c                	lw	a5,40(a0)
    80001ec4:	e3b9                	bnez	a5,80001f0a <usertrap+0x86>
    p->trapframe->epc += 4;
    80001ec6:	6cb8                	ld	a4,88(s1)
    80001ec8:	6f1c                	ld	a5,24(a4)
    80001eca:	0791                	addi	a5,a5,4
    80001ecc:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ece:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001ed2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ed6:	10079073          	csrw	sstatus,a5
    syscall();
    80001eda:	00000097          	auipc	ra,0x0
    80001ede:	2e0080e7          	jalr	736(ra) # 800021ba <syscall>
  if(p->killed)
    80001ee2:	549c                	lw	a5,40(s1)
    80001ee4:	ebc1                	bnez	a5,80001f74 <usertrap+0xf0>
  usertrapret();
    80001ee6:	00000097          	auipc	ra,0x0
    80001eea:	e18080e7          	jalr	-488(ra) # 80001cfe <usertrapret>
}
    80001eee:	60e2                	ld	ra,24(sp)
    80001ef0:	6442                	ld	s0,16(sp)
    80001ef2:	64a2                	ld	s1,8(sp)
    80001ef4:	6902                	ld	s2,0(sp)
    80001ef6:	6105                	addi	sp,sp,32
    80001ef8:	8082                	ret
    panic("usertrap: not from user mode");
    80001efa:	00006517          	auipc	a0,0x6
    80001efe:	3d650513          	addi	a0,a0,982 # 800082d0 <states.0+0x58>
    80001f02:	00004097          	auipc	ra,0x4
    80001f06:	ffe080e7          	jalr	-2(ra) # 80005f00 <panic>
      exit(-1);
    80001f0a:	557d                	li	a0,-1
    80001f0c:	00000097          	auipc	ra,0x0
    80001f10:	a50080e7          	jalr	-1456(ra) # 8000195c <exit>
    80001f14:	bf4d                	j	80001ec6 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80001f16:	00000097          	auipc	ra,0x0
    80001f1a:	ecc080e7          	jalr	-308(ra) # 80001de2 <devintr>
    80001f1e:	892a                	mv	s2,a0
    80001f20:	c501                	beqz	a0,80001f28 <usertrap+0xa4>
  if(p->killed)
    80001f22:	549c                	lw	a5,40(s1)
    80001f24:	c3a1                	beqz	a5,80001f64 <usertrap+0xe0>
    80001f26:	a815                	j	80001f5a <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f28:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001f2c:	5890                	lw	a2,48(s1)
    80001f2e:	00006517          	auipc	a0,0x6
    80001f32:	3c250513          	addi	a0,a0,962 # 800082f0 <states.0+0x78>
    80001f36:	00004097          	auipc	ra,0x4
    80001f3a:	014080e7          	jalr	20(ra) # 80005f4a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f3e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f42:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f46:	00006517          	auipc	a0,0x6
    80001f4a:	3da50513          	addi	a0,a0,986 # 80008320 <states.0+0xa8>
    80001f4e:	00004097          	auipc	ra,0x4
    80001f52:	ffc080e7          	jalr	-4(ra) # 80005f4a <printf>
    p->killed = 1;
    80001f56:	4785                	li	a5,1
    80001f58:	d49c                	sw	a5,40(s1)
    exit(-1);
    80001f5a:	557d                	li	a0,-1
    80001f5c:	00000097          	auipc	ra,0x0
    80001f60:	a00080e7          	jalr	-1536(ra) # 8000195c <exit>
  if(which_dev == 2)
    80001f64:	4789                	li	a5,2
    80001f66:	f8f910e3          	bne	s2,a5,80001ee6 <usertrap+0x62>
    yield();
    80001f6a:	fffff097          	auipc	ra,0xfffff
    80001f6e:	75a080e7          	jalr	1882(ra) # 800016c4 <yield>
    80001f72:	bf95                	j	80001ee6 <usertrap+0x62>
  int which_dev = 0;
    80001f74:	4901                	li	s2,0
    80001f76:	b7d5                	j	80001f5a <usertrap+0xd6>

0000000080001f78 <kerneltrap>:
{
    80001f78:	7179                	addi	sp,sp,-48
    80001f7a:	f406                	sd	ra,40(sp)
    80001f7c:	f022                	sd	s0,32(sp)
    80001f7e:	ec26                	sd	s1,24(sp)
    80001f80:	e84a                	sd	s2,16(sp)
    80001f82:	e44e                	sd	s3,8(sp)
    80001f84:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f86:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f8a:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f8e:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001f92:	1004f793          	andi	a5,s1,256
    80001f96:	cb85                	beqz	a5,80001fc6 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f98:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f9c:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001f9e:	ef85                	bnez	a5,80001fd6 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001fa0:	00000097          	auipc	ra,0x0
    80001fa4:	e42080e7          	jalr	-446(ra) # 80001de2 <devintr>
    80001fa8:	cd1d                	beqz	a0,80001fe6 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001faa:	4789                	li	a5,2
    80001fac:	06f50a63          	beq	a0,a5,80002020 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001fb0:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001fb4:	10049073          	csrw	sstatus,s1
}
    80001fb8:	70a2                	ld	ra,40(sp)
    80001fba:	7402                	ld	s0,32(sp)
    80001fbc:	64e2                	ld	s1,24(sp)
    80001fbe:	6942                	ld	s2,16(sp)
    80001fc0:	69a2                	ld	s3,8(sp)
    80001fc2:	6145                	addi	sp,sp,48
    80001fc4:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001fc6:	00006517          	auipc	a0,0x6
    80001fca:	37a50513          	addi	a0,a0,890 # 80008340 <states.0+0xc8>
    80001fce:	00004097          	auipc	ra,0x4
    80001fd2:	f32080e7          	jalr	-206(ra) # 80005f00 <panic>
    panic("kerneltrap: interrupts enabled");
    80001fd6:	00006517          	auipc	a0,0x6
    80001fda:	39250513          	addi	a0,a0,914 # 80008368 <states.0+0xf0>
    80001fde:	00004097          	auipc	ra,0x4
    80001fe2:	f22080e7          	jalr	-222(ra) # 80005f00 <panic>
    printf("scause %p\n", scause);
    80001fe6:	85ce                	mv	a1,s3
    80001fe8:	00006517          	auipc	a0,0x6
    80001fec:	3a050513          	addi	a0,a0,928 # 80008388 <states.0+0x110>
    80001ff0:	00004097          	auipc	ra,0x4
    80001ff4:	f5a080e7          	jalr	-166(ra) # 80005f4a <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ff8:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ffc:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002000:	00006517          	auipc	a0,0x6
    80002004:	39850513          	addi	a0,a0,920 # 80008398 <states.0+0x120>
    80002008:	00004097          	auipc	ra,0x4
    8000200c:	f42080e7          	jalr	-190(ra) # 80005f4a <printf>
    panic("kerneltrap");
    80002010:	00006517          	auipc	a0,0x6
    80002014:	3a050513          	addi	a0,a0,928 # 800083b0 <states.0+0x138>
    80002018:	00004097          	auipc	ra,0x4
    8000201c:	ee8080e7          	jalr	-280(ra) # 80005f00 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002020:	fffff097          	auipc	ra,0xfffff
    80002024:	f66080e7          	jalr	-154(ra) # 80000f86 <myproc>
    80002028:	d541                	beqz	a0,80001fb0 <kerneltrap+0x38>
    8000202a:	fffff097          	auipc	ra,0xfffff
    8000202e:	f5c080e7          	jalr	-164(ra) # 80000f86 <myproc>
    80002032:	4d18                	lw	a4,24(a0)
    80002034:	4791                	li	a5,4
    80002036:	f6f71de3          	bne	a4,a5,80001fb0 <kerneltrap+0x38>
    yield();
    8000203a:	fffff097          	auipc	ra,0xfffff
    8000203e:	68a080e7          	jalr	1674(ra) # 800016c4 <yield>
    80002042:	b7bd                	j	80001fb0 <kerneltrap+0x38>

0000000080002044 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002044:	1101                	addi	sp,sp,-32
    80002046:	ec06                	sd	ra,24(sp)
    80002048:	e822                	sd	s0,16(sp)
    8000204a:	e426                	sd	s1,8(sp)
    8000204c:	1000                	addi	s0,sp,32
    8000204e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002050:	fffff097          	auipc	ra,0xfffff
    80002054:	f36080e7          	jalr	-202(ra) # 80000f86 <myproc>
  switch (n) {
    80002058:	4795                	li	a5,5
    8000205a:	0497e163          	bltu	a5,s1,8000209c <argraw+0x58>
    8000205e:	048a                	slli	s1,s1,0x2
    80002060:	00006717          	auipc	a4,0x6
    80002064:	45070713          	addi	a4,a4,1104 # 800084b0 <states.0+0x238>
    80002068:	94ba                	add	s1,s1,a4
    8000206a:	409c                	lw	a5,0(s1)
    8000206c:	97ba                	add	a5,a5,a4
    8000206e:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002070:	6d3c                	ld	a5,88(a0)
    80002072:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002074:	60e2                	ld	ra,24(sp)
    80002076:	6442                	ld	s0,16(sp)
    80002078:	64a2                	ld	s1,8(sp)
    8000207a:	6105                	addi	sp,sp,32
    8000207c:	8082                	ret
    return p->trapframe->a1;
    8000207e:	6d3c                	ld	a5,88(a0)
    80002080:	7fa8                	ld	a0,120(a5)
    80002082:	bfcd                	j	80002074 <argraw+0x30>
    return p->trapframe->a2;
    80002084:	6d3c                	ld	a5,88(a0)
    80002086:	63c8                	ld	a0,128(a5)
    80002088:	b7f5                	j	80002074 <argraw+0x30>
    return p->trapframe->a3;
    8000208a:	6d3c                	ld	a5,88(a0)
    8000208c:	67c8                	ld	a0,136(a5)
    8000208e:	b7dd                	j	80002074 <argraw+0x30>
    return p->trapframe->a4;
    80002090:	6d3c                	ld	a5,88(a0)
    80002092:	6bc8                	ld	a0,144(a5)
    80002094:	b7c5                	j	80002074 <argraw+0x30>
    return p->trapframe->a5;
    80002096:	6d3c                	ld	a5,88(a0)
    80002098:	6fc8                	ld	a0,152(a5)
    8000209a:	bfe9                	j	80002074 <argraw+0x30>
  panic("argraw");
    8000209c:	00006517          	auipc	a0,0x6
    800020a0:	32450513          	addi	a0,a0,804 # 800083c0 <states.0+0x148>
    800020a4:	00004097          	auipc	ra,0x4
    800020a8:	e5c080e7          	jalr	-420(ra) # 80005f00 <panic>

00000000800020ac <fetchaddr>:
{
    800020ac:	1101                	addi	sp,sp,-32
    800020ae:	ec06                	sd	ra,24(sp)
    800020b0:	e822                	sd	s0,16(sp)
    800020b2:	e426                	sd	s1,8(sp)
    800020b4:	e04a                	sd	s2,0(sp)
    800020b6:	1000                	addi	s0,sp,32
    800020b8:	84aa                	mv	s1,a0
    800020ba:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800020bc:	fffff097          	auipc	ra,0xfffff
    800020c0:	eca080e7          	jalr	-310(ra) # 80000f86 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    800020c4:	653c                	ld	a5,72(a0)
    800020c6:	02f4f863          	bgeu	s1,a5,800020f6 <fetchaddr+0x4a>
    800020ca:	00848713          	addi	a4,s1,8
    800020ce:	02e7e663          	bltu	a5,a4,800020fa <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800020d2:	46a1                	li	a3,8
    800020d4:	8626                	mv	a2,s1
    800020d6:	85ca                	mv	a1,s2
    800020d8:	6928                	ld	a0,80(a0)
    800020da:	fffff097          	auipc	ra,0xfffff
    800020de:	b04080e7          	jalr	-1276(ra) # 80000bde <copyin>
    800020e2:	00a03533          	snez	a0,a0
    800020e6:	40a00533          	neg	a0,a0
}
    800020ea:	60e2                	ld	ra,24(sp)
    800020ec:	6442                	ld	s0,16(sp)
    800020ee:	64a2                	ld	s1,8(sp)
    800020f0:	6902                	ld	s2,0(sp)
    800020f2:	6105                	addi	sp,sp,32
    800020f4:	8082                	ret
    return -1;
    800020f6:	557d                	li	a0,-1
    800020f8:	bfcd                	j	800020ea <fetchaddr+0x3e>
    800020fa:	557d                	li	a0,-1
    800020fc:	b7fd                	j	800020ea <fetchaddr+0x3e>

00000000800020fe <fetchstr>:
{
    800020fe:	7179                	addi	sp,sp,-48
    80002100:	f406                	sd	ra,40(sp)
    80002102:	f022                	sd	s0,32(sp)
    80002104:	ec26                	sd	s1,24(sp)
    80002106:	e84a                	sd	s2,16(sp)
    80002108:	e44e                	sd	s3,8(sp)
    8000210a:	1800                	addi	s0,sp,48
    8000210c:	892a                	mv	s2,a0
    8000210e:	84ae                	mv	s1,a1
    80002110:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002112:	fffff097          	auipc	ra,0xfffff
    80002116:	e74080e7          	jalr	-396(ra) # 80000f86 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    8000211a:	86ce                	mv	a3,s3
    8000211c:	864a                	mv	a2,s2
    8000211e:	85a6                	mv	a1,s1
    80002120:	6928                	ld	a0,80(a0)
    80002122:	fffff097          	auipc	ra,0xfffff
    80002126:	b4a080e7          	jalr	-1206(ra) # 80000c6c <copyinstr>
  if(err < 0)
    8000212a:	00054763          	bltz	a0,80002138 <fetchstr+0x3a>
  return strlen(buf);
    8000212e:	8526                	mv	a0,s1
    80002130:	ffffe097          	auipc	ra,0xffffe
    80002134:	210080e7          	jalr	528(ra) # 80000340 <strlen>
}
    80002138:	70a2                	ld	ra,40(sp)
    8000213a:	7402                	ld	s0,32(sp)
    8000213c:	64e2                	ld	s1,24(sp)
    8000213e:	6942                	ld	s2,16(sp)
    80002140:	69a2                	ld	s3,8(sp)
    80002142:	6145                	addi	sp,sp,48
    80002144:	8082                	ret

0000000080002146 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002146:	1101                	addi	sp,sp,-32
    80002148:	ec06                	sd	ra,24(sp)
    8000214a:	e822                	sd	s0,16(sp)
    8000214c:	e426                	sd	s1,8(sp)
    8000214e:	1000                	addi	s0,sp,32
    80002150:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002152:	00000097          	auipc	ra,0x0
    80002156:	ef2080e7          	jalr	-270(ra) # 80002044 <argraw>
    8000215a:	c088                	sw	a0,0(s1)
  return 0;
}
    8000215c:	4501                	li	a0,0
    8000215e:	60e2                	ld	ra,24(sp)
    80002160:	6442                	ld	s0,16(sp)
    80002162:	64a2                	ld	s1,8(sp)
    80002164:	6105                	addi	sp,sp,32
    80002166:	8082                	ret

0000000080002168 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002168:	1101                	addi	sp,sp,-32
    8000216a:	ec06                	sd	ra,24(sp)
    8000216c:	e822                	sd	s0,16(sp)
    8000216e:	e426                	sd	s1,8(sp)
    80002170:	1000                	addi	s0,sp,32
    80002172:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002174:	00000097          	auipc	ra,0x0
    80002178:	ed0080e7          	jalr	-304(ra) # 80002044 <argraw>
    8000217c:	e088                	sd	a0,0(s1)
  return 0;
}
    8000217e:	4501                	li	a0,0
    80002180:	60e2                	ld	ra,24(sp)
    80002182:	6442                	ld	s0,16(sp)
    80002184:	64a2                	ld	s1,8(sp)
    80002186:	6105                	addi	sp,sp,32
    80002188:	8082                	ret

000000008000218a <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000218a:	1101                	addi	sp,sp,-32
    8000218c:	ec06                	sd	ra,24(sp)
    8000218e:	e822                	sd	s0,16(sp)
    80002190:	e426                	sd	s1,8(sp)
    80002192:	e04a                	sd	s2,0(sp)
    80002194:	1000                	addi	s0,sp,32
    80002196:	84ae                	mv	s1,a1
    80002198:	8932                	mv	s2,a2
  *ip = argraw(n);
    8000219a:	00000097          	auipc	ra,0x0
    8000219e:	eaa080e7          	jalr	-342(ra) # 80002044 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    800021a2:	864a                	mv	a2,s2
    800021a4:	85a6                	mv	a1,s1
    800021a6:	00000097          	auipc	ra,0x0
    800021aa:	f58080e7          	jalr	-168(ra) # 800020fe <fetchstr>
}
    800021ae:	60e2                	ld	ra,24(sp)
    800021b0:	6442                	ld	s0,16(sp)
    800021b2:	64a2                	ld	s1,8(sp)
    800021b4:	6902                	ld	s2,0(sp)
    800021b6:	6105                	addi	sp,sp,32
    800021b8:	8082                	ret

00000000800021ba <syscall>:
  [SYS_sysinfo]    "sysinfo",
};

void
syscall(void)
{
    800021ba:	7179                	addi	sp,sp,-48
    800021bc:	f406                	sd	ra,40(sp)
    800021be:	f022                	sd	s0,32(sp)
    800021c0:	ec26                	sd	s1,24(sp)
    800021c2:	e84a                	sd	s2,16(sp)
    800021c4:	e44e                	sd	s3,8(sp)
    800021c6:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    800021c8:	fffff097          	auipc	ra,0xfffff
    800021cc:	dbe080e7          	jalr	-578(ra) # 80000f86 <myproc>
    800021d0:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    800021d2:	05853903          	ld	s2,88(a0)
    800021d6:	0a893783          	ld	a5,168(s2)
    800021da:	0007899b          	sext.w	s3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800021de:	37fd                	addiw	a5,a5,-1
    800021e0:	4775                	li	a4,29
    800021e2:	04f76763          	bltu	a4,a5,80002230 <syscall+0x76>
    800021e6:	00399713          	slli	a4,s3,0x3
    800021ea:	00006797          	auipc	a5,0x6
    800021ee:	2de78793          	addi	a5,a5,734 # 800084c8 <syscalls>
    800021f2:	97ba                	add	a5,a5,a4
    800021f4:	639c                	ld	a5,0(a5)
    800021f6:	cf8d                	beqz	a5,80002230 <syscall+0x76>
    p->trapframe->a0 = syscalls[num]();
    800021f8:	9782                	jalr	a5
    800021fa:	06a93823          	sd	a0,112(s2)

    if((1<<num)&p->trace_mask){
    800021fe:	1704a783          	lw	a5,368(s1)
    80002202:	4137d7bb          	sraw	a5,a5,s3
    80002206:	8b85                	andi	a5,a5,1
    80002208:	c3b9                	beqz	a5,8000224e <syscall+0x94>
      printf("%d: syscall %s -> %d\n", p->pid, syscalls_name[num], p->trapframe->a0);
    8000220a:	6cb8                	ld	a4,88(s1)
    8000220c:	098e                	slli	s3,s3,0x3
    8000220e:	00006797          	auipc	a5,0x6
    80002212:	2ba78793          	addi	a5,a5,698 # 800084c8 <syscalls>
    80002216:	97ce                	add	a5,a5,s3
    80002218:	7b34                	ld	a3,112(a4)
    8000221a:	7ff0                	ld	a2,248(a5)
    8000221c:	588c                	lw	a1,48(s1)
    8000221e:	00006517          	auipc	a0,0x6
    80002222:	1aa50513          	addi	a0,a0,426 # 800083c8 <states.0+0x150>
    80002226:	00004097          	auipc	ra,0x4
    8000222a:	d24080e7          	jalr	-732(ra) # 80005f4a <printf>
    8000222e:	a005                	j	8000224e <syscall+0x94>
    }
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002230:	86ce                	mv	a3,s3
    80002232:	16048613          	addi	a2,s1,352
    80002236:	588c                	lw	a1,48(s1)
    80002238:	00006517          	auipc	a0,0x6
    8000223c:	1a850513          	addi	a0,a0,424 # 800083e0 <states.0+0x168>
    80002240:	00004097          	auipc	ra,0x4
    80002244:	d0a080e7          	jalr	-758(ra) # 80005f4a <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002248:	6cbc                	ld	a5,88(s1)
    8000224a:	577d                	li	a4,-1
    8000224c:	fbb8                	sd	a4,112(a5)
  }
}
    8000224e:	70a2                	ld	ra,40(sp)
    80002250:	7402                	ld	s0,32(sp)
    80002252:	64e2                	ld	s1,24(sp)
    80002254:	6942                	ld	s2,16(sp)
    80002256:	69a2                	ld	s3,8(sp)
    80002258:	6145                	addi	sp,sp,48
    8000225a:	8082                	ret

000000008000225c <sys_exit>:
#include "proc.h"
#include "sysinfo.h"

uint64
sys_exit(void)
{
    8000225c:	1101                	addi	sp,sp,-32
    8000225e:	ec06                	sd	ra,24(sp)
    80002260:	e822                	sd	s0,16(sp)
    80002262:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002264:	fec40593          	addi	a1,s0,-20
    80002268:	4501                	li	a0,0
    8000226a:	00000097          	auipc	ra,0x0
    8000226e:	edc080e7          	jalr	-292(ra) # 80002146 <argint>
    return -1;
    80002272:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002274:	00054963          	bltz	a0,80002286 <sys_exit+0x2a>
  exit(n);
    80002278:	fec42503          	lw	a0,-20(s0)
    8000227c:	fffff097          	auipc	ra,0xfffff
    80002280:	6e0080e7          	jalr	1760(ra) # 8000195c <exit>
  return 0;  // not reached
    80002284:	4781                	li	a5,0
}
    80002286:	853e                	mv	a0,a5
    80002288:	60e2                	ld	ra,24(sp)
    8000228a:	6442                	ld	s0,16(sp)
    8000228c:	6105                	addi	sp,sp,32
    8000228e:	8082                	ret

0000000080002290 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002290:	1141                	addi	sp,sp,-16
    80002292:	e406                	sd	ra,8(sp)
    80002294:	e022                	sd	s0,0(sp)
    80002296:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002298:	fffff097          	auipc	ra,0xfffff
    8000229c:	cee080e7          	jalr	-786(ra) # 80000f86 <myproc>
}
    800022a0:	5908                	lw	a0,48(a0)
    800022a2:	60a2                	ld	ra,8(sp)
    800022a4:	6402                	ld	s0,0(sp)
    800022a6:	0141                	addi	sp,sp,16
    800022a8:	8082                	ret

00000000800022aa <sys_fork>:

uint64
sys_fork(void)
{
    800022aa:	1141                	addi	sp,sp,-16
    800022ac:	e406                	sd	ra,8(sp)
    800022ae:	e022                	sd	s0,0(sp)
    800022b0:	0800                	addi	s0,sp,16
  return fork();
    800022b2:	fffff097          	auipc	ra,0xfffff
    800022b6:	154080e7          	jalr	340(ra) # 80001406 <fork>
}
    800022ba:	60a2                	ld	ra,8(sp)
    800022bc:	6402                	ld	s0,0(sp)
    800022be:	0141                	addi	sp,sp,16
    800022c0:	8082                	ret

00000000800022c2 <sys_wait>:

uint64
sys_wait(void)
{
    800022c2:	1101                	addi	sp,sp,-32
    800022c4:	ec06                	sd	ra,24(sp)
    800022c6:	e822                	sd	s0,16(sp)
    800022c8:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    800022ca:	fe840593          	addi	a1,s0,-24
    800022ce:	4501                	li	a0,0
    800022d0:	00000097          	auipc	ra,0x0
    800022d4:	e98080e7          	jalr	-360(ra) # 80002168 <argaddr>
    800022d8:	87aa                	mv	a5,a0
    return -1;
    800022da:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    800022dc:	0007c863          	bltz	a5,800022ec <sys_wait+0x2a>
  return wait(p);
    800022e0:	fe843503          	ld	a0,-24(s0)
    800022e4:	fffff097          	auipc	ra,0xfffff
    800022e8:	480080e7          	jalr	1152(ra) # 80001764 <wait>
}
    800022ec:	60e2                	ld	ra,24(sp)
    800022ee:	6442                	ld	s0,16(sp)
    800022f0:	6105                	addi	sp,sp,32
    800022f2:	8082                	ret

00000000800022f4 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800022f4:	7179                	addi	sp,sp,-48
    800022f6:	f406                	sd	ra,40(sp)
    800022f8:	f022                	sd	s0,32(sp)
    800022fa:	ec26                	sd	s1,24(sp)
    800022fc:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    800022fe:	fdc40593          	addi	a1,s0,-36
    80002302:	4501                	li	a0,0
    80002304:	00000097          	auipc	ra,0x0
    80002308:	e42080e7          	jalr	-446(ra) # 80002146 <argint>
    8000230c:	87aa                	mv	a5,a0
    return -1;
    8000230e:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002310:	0207c063          	bltz	a5,80002330 <sys_sbrk+0x3c>
  
  addr = myproc()->sz;
    80002314:	fffff097          	auipc	ra,0xfffff
    80002318:	c72080e7          	jalr	-910(ra) # 80000f86 <myproc>
    8000231c:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    8000231e:	fdc42503          	lw	a0,-36(s0)
    80002322:	fffff097          	auipc	ra,0xfffff
    80002326:	06c080e7          	jalr	108(ra) # 8000138e <growproc>
    8000232a:	00054863          	bltz	a0,8000233a <sys_sbrk+0x46>
    return -1;
  return addr;
    8000232e:	8526                	mv	a0,s1
}
    80002330:	70a2                	ld	ra,40(sp)
    80002332:	7402                	ld	s0,32(sp)
    80002334:	64e2                	ld	s1,24(sp)
    80002336:	6145                	addi	sp,sp,48
    80002338:	8082                	ret
    return -1;
    8000233a:	557d                	li	a0,-1
    8000233c:	bfd5                	j	80002330 <sys_sbrk+0x3c>

000000008000233e <sys_sleep>:

uint64
sys_sleep(void)
{
    8000233e:	7139                	addi	sp,sp,-64
    80002340:	fc06                	sd	ra,56(sp)
    80002342:	f822                	sd	s0,48(sp)
    80002344:	f426                	sd	s1,40(sp)
    80002346:	f04a                	sd	s2,32(sp)
    80002348:	ec4e                	sd	s3,24(sp)
    8000234a:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;


  if(argint(0, &n) < 0)
    8000234c:	fcc40593          	addi	a1,s0,-52
    80002350:	4501                	li	a0,0
    80002352:	00000097          	auipc	ra,0x0
    80002356:	df4080e7          	jalr	-524(ra) # 80002146 <argint>
    return -1;
    8000235a:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    8000235c:	06054563          	bltz	a0,800023c6 <sys_sleep+0x88>
  acquire(&tickslock);
    80002360:	0000d517          	auipc	a0,0xd
    80002364:	f2050513          	addi	a0,a0,-224 # 8000f280 <tickslock>
    80002368:	00004097          	auipc	ra,0x4
    8000236c:	0d0080e7          	jalr	208(ra) # 80006438 <acquire>
  ticks0 = ticks;
    80002370:	00007917          	auipc	s2,0x7
    80002374:	ca892903          	lw	s2,-856(s2) # 80009018 <ticks>
  while(ticks - ticks0 < n){
    80002378:	fcc42783          	lw	a5,-52(s0)
    8000237c:	cf85                	beqz	a5,800023b4 <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000237e:	0000d997          	auipc	s3,0xd
    80002382:	f0298993          	addi	s3,s3,-254 # 8000f280 <tickslock>
    80002386:	00007497          	auipc	s1,0x7
    8000238a:	c9248493          	addi	s1,s1,-878 # 80009018 <ticks>
    if(myproc()->killed){
    8000238e:	fffff097          	auipc	ra,0xfffff
    80002392:	bf8080e7          	jalr	-1032(ra) # 80000f86 <myproc>
    80002396:	551c                	lw	a5,40(a0)
    80002398:	ef9d                	bnez	a5,800023d6 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    8000239a:	85ce                	mv	a1,s3
    8000239c:	8526                	mv	a0,s1
    8000239e:	fffff097          	auipc	ra,0xfffff
    800023a2:	362080e7          	jalr	866(ra) # 80001700 <sleep>
  while(ticks - ticks0 < n){
    800023a6:	409c                	lw	a5,0(s1)
    800023a8:	412787bb          	subw	a5,a5,s2
    800023ac:	fcc42703          	lw	a4,-52(s0)
    800023b0:	fce7efe3          	bltu	a5,a4,8000238e <sys_sleep+0x50>
  }
  release(&tickslock);
    800023b4:	0000d517          	auipc	a0,0xd
    800023b8:	ecc50513          	addi	a0,a0,-308 # 8000f280 <tickslock>
    800023bc:	00004097          	auipc	ra,0x4
    800023c0:	130080e7          	jalr	304(ra) # 800064ec <release>
  return 0;
    800023c4:	4781                	li	a5,0
}
    800023c6:	853e                	mv	a0,a5
    800023c8:	70e2                	ld	ra,56(sp)
    800023ca:	7442                	ld	s0,48(sp)
    800023cc:	74a2                	ld	s1,40(sp)
    800023ce:	7902                	ld	s2,32(sp)
    800023d0:	69e2                	ld	s3,24(sp)
    800023d2:	6121                	addi	sp,sp,64
    800023d4:	8082                	ret
      release(&tickslock);
    800023d6:	0000d517          	auipc	a0,0xd
    800023da:	eaa50513          	addi	a0,a0,-342 # 8000f280 <tickslock>
    800023de:	00004097          	auipc	ra,0x4
    800023e2:	10e080e7          	jalr	270(ra) # 800064ec <release>
      return -1;
    800023e6:	57fd                	li	a5,-1
    800023e8:	bff9                	j	800023c6 <sys_sleep+0x88>

00000000800023ea <sys_kill>:
// }
// #endif

uint64
sys_kill(void)
{
    800023ea:	1101                	addi	sp,sp,-32
    800023ec:	ec06                	sd	ra,24(sp)
    800023ee:	e822                	sd	s0,16(sp)
    800023f0:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    800023f2:	fec40593          	addi	a1,s0,-20
    800023f6:	4501                	li	a0,0
    800023f8:	00000097          	auipc	ra,0x0
    800023fc:	d4e080e7          	jalr	-690(ra) # 80002146 <argint>
    80002400:	87aa                	mv	a5,a0
    return -1;
    80002402:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002404:	0007c863          	bltz	a5,80002414 <sys_kill+0x2a>
  return kill(pid);
    80002408:	fec42503          	lw	a0,-20(s0)
    8000240c:	fffff097          	auipc	ra,0xfffff
    80002410:	626080e7          	jalr	1574(ra) # 80001a32 <kill>
}
    80002414:	60e2                	ld	ra,24(sp)
    80002416:	6442                	ld	s0,16(sp)
    80002418:	6105                	addi	sp,sp,32
    8000241a:	8082                	ret

000000008000241c <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000241c:	1101                	addi	sp,sp,-32
    8000241e:	ec06                	sd	ra,24(sp)
    80002420:	e822                	sd	s0,16(sp)
    80002422:	e426                	sd	s1,8(sp)
    80002424:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002426:	0000d517          	auipc	a0,0xd
    8000242a:	e5a50513          	addi	a0,a0,-422 # 8000f280 <tickslock>
    8000242e:	00004097          	auipc	ra,0x4
    80002432:	00a080e7          	jalr	10(ra) # 80006438 <acquire>
  xticks = ticks;
    80002436:	00007497          	auipc	s1,0x7
    8000243a:	be24a483          	lw	s1,-1054(s1) # 80009018 <ticks>
  release(&tickslock);
    8000243e:	0000d517          	auipc	a0,0xd
    80002442:	e4250513          	addi	a0,a0,-446 # 8000f280 <tickslock>
    80002446:	00004097          	auipc	ra,0x4
    8000244a:	0a6080e7          	jalr	166(ra) # 800064ec <release>
  return xticks;
}
    8000244e:	02049513          	slli	a0,s1,0x20
    80002452:	9101                	srli	a0,a0,0x20
    80002454:	60e2                	ld	ra,24(sp)
    80002456:	6442                	ld	s0,16(sp)
    80002458:	64a2                	ld	s1,8(sp)
    8000245a:	6105                	addi	sp,sp,32
    8000245c:	8082                	ret

000000008000245e <sys_trace>:

uint64
sys_trace(void)
{
    8000245e:	1141                	addi	sp,sp,-16
    80002460:	e406                	sd	ra,8(sp)
    80002462:	e022                	sd	s0,0(sp)
    80002464:	0800                	addi	s0,sp,16
  argint(0,&(myproc()->trace_mask));
    80002466:	fffff097          	auipc	ra,0xfffff
    8000246a:	b20080e7          	jalr	-1248(ra) # 80000f86 <myproc>
    8000246e:	17050593          	addi	a1,a0,368
    80002472:	4501                	li	a0,0
    80002474:	00000097          	auipc	ra,0x0
    80002478:	cd2080e7          	jalr	-814(ra) # 80002146 <argint>
  return 0;
}
    8000247c:	4501                	li	a0,0
    8000247e:	60a2                	ld	ra,8(sp)
    80002480:	6402                	ld	s0,0(sp)
    80002482:	0141                	addi	sp,sp,16
    80002484:	8082                	ret

0000000080002486 <sys_sysinfo>:

uint64
sys_sysinfo(void)
{
    80002486:	7139                	addi	sp,sp,-64
    80002488:	fc06                	sd	ra,56(sp)
    8000248a:	f822                	sd	s0,48(sp)
    8000248c:	f426                	sd	s1,40(sp)
    8000248e:	0080                	addi	s0,sp,64
  uint64 addr;
  struct sysinfo info;
  struct proc *p = myproc();
    80002490:	fffff097          	auipc	ra,0xfffff
    80002494:	af6080e7          	jalr	-1290(ra) # 80000f86 <myproc>
    80002498:	84aa                	mv	s1,a0
  if(argaddr(0,&addr)<0){
    8000249a:	fd840593          	addi	a1,s0,-40
    8000249e:	4501                	li	a0,0
    800024a0:	00000097          	auipc	ra,0x0
    800024a4:	cc8080e7          	jalr	-824(ra) # 80002168 <argaddr>
    return -1;
    800024a8:	57fd                	li	a5,-1
  if(argaddr(0,&addr)<0){
    800024aa:	02054a63          	bltz	a0,800024de <sys_sysinfo+0x58>
  }
  info.freemem=free_mem();
    800024ae:	ffffe097          	auipc	ra,0xffffe
    800024b2:	ccc080e7          	jalr	-820(ra) # 8000017a <free_mem>
    800024b6:	fca43423          	sd	a0,-56(s0)
  info.nproc=nproc();
    800024ba:	fffff097          	auipc	ra,0xfffff
    800024be:	746080e7          	jalr	1862(ra) # 80001c00 <nproc>
    800024c2:	fca43823          	sd	a0,-48(s0)

  if(copyout(p->pagetable, addr, (char*)&info, sizeof(info))<0){
    800024c6:	46c1                	li	a3,16
    800024c8:	fc840613          	addi	a2,s0,-56
    800024cc:	fd843583          	ld	a1,-40(s0)
    800024d0:	68a8                	ld	a0,80(s1)
    800024d2:	ffffe097          	auipc	ra,0xffffe
    800024d6:	680080e7          	jalr	1664(ra) # 80000b52 <copyout>
    800024da:	43f55793          	srai	a5,a0,0x3f
    return -1;
  }
  return 0;
}
    800024de:	853e                	mv	a0,a5
    800024e0:	70e2                	ld	ra,56(sp)
    800024e2:	7442                	ld	s0,48(sp)
    800024e4:	74a2                	ld	s1,40(sp)
    800024e6:	6121                	addi	sp,sp,64
    800024e8:	8082                	ret

00000000800024ea <sys_pgaccess>:

extern pte_t * walk(pagetable_t, uint64, int);

int
sys_pgaccess(void)
{
    800024ea:	715d                	addi	sp,sp,-80
    800024ec:	e486                	sd	ra,72(sp)
    800024ee:	e0a2                	sd	s0,64(sp)
    800024f0:	fc26                	sd	s1,56(sp)
    800024f2:	f84a                	sd	s2,48(sp)
    800024f4:	f44e                	sd	s3,40(sp)
    800024f6:	0880                	addi	s0,sp,80
  uint64 BitMask = 0;
    800024f8:	fc043423          	sd	zero,-56(s0)

  uint64 StartVA;
  int NumberOfPages;
  uint64 BitMaskVA;

  if(argint(1, &NumberOfPages) < 0){
    800024fc:	fbc40593          	addi	a1,s0,-68
    80002500:	4505                	li	a0,1
    80002502:	00000097          	auipc	ra,0x0
    80002506:	c44080e7          	jalr	-956(ra) # 80002146 <argint>
    8000250a:	0c054763          	bltz	a0,800025d8 <sys_pgaccess+0xee>
    return -1;
  }

  if(NumberOfPages > MAXSCAN){
    8000250e:	fbc42703          	lw	a4,-68(s0)
    80002512:	02000793          	li	a5,32
    80002516:	0ce7c363          	blt	a5,a4,800025dc <sys_pgaccess+0xf2>
    return -1;
  }

  if(argaddr(0, &StartVA) < 0){
    8000251a:	fc040593          	addi	a1,s0,-64
    8000251e:	4501                	li	a0,0
    80002520:	00000097          	auipc	ra,0x0
    80002524:	c48080e7          	jalr	-952(ra) # 80002168 <argaddr>
    80002528:	0a054c63          	bltz	a0,800025e0 <sys_pgaccess+0xf6>
    return -1;
  }
  if(argaddr(2, &BitMaskVA) < 0){
    8000252c:	fb040593          	addi	a1,s0,-80
    80002530:	4509                	li	a0,2
    80002532:	00000097          	auipc	ra,0x0
    80002536:	c36080e7          	jalr	-970(ra) # 80002168 <argaddr>
    8000253a:	0a054563          	bltz	a0,800025e4 <sys_pgaccess+0xfa>
  }

  int i;
  pte_t* pte;

  for(i=0; i<NumberOfPages; StartVA += PGSIZE, i++){
    8000253e:	fbc42783          	lw	a5,-68(s0)
    80002542:	06f05563          	blez	a5,800025ac <sys_pgaccess+0xc2>
    80002546:	4481                	li	s1,0
    if((pte = walk(myproc()->pagetable, StartVA, 0)) == 0){
      panic("pgaccess : walk failed");
    }
    if(*pte & PTE_A){
      BitMask |= 1 << i;
    80002548:	4985                	li	s3,1
  for(i=0; i<NumberOfPages; StartVA += PGSIZE, i++){
    8000254a:	6905                	lui	s2,0x1
    8000254c:	a01d                	j	80002572 <sys_pgaccess+0x88>
      panic("pgaccess : walk failed");
    8000254e:	00006517          	auipc	a0,0x6
    80002552:	13250513          	addi	a0,a0,306 # 80008680 <syscalls_name+0xc0>
    80002556:	00004097          	auipc	ra,0x4
    8000255a:	9aa080e7          	jalr	-1622(ra) # 80005f00 <panic>
  for(i=0; i<NumberOfPages; StartVA += PGSIZE, i++){
    8000255e:	fc043783          	ld	a5,-64(s0)
    80002562:	97ca                	add	a5,a5,s2
    80002564:	fcf43023          	sd	a5,-64(s0)
    80002568:	2485                	addiw	s1,s1,1
    8000256a:	fbc42783          	lw	a5,-68(s0)
    8000256e:	02f4df63          	bge	s1,a5,800025ac <sys_pgaccess+0xc2>
    if((pte = walk(myproc()->pagetable, StartVA, 0)) == 0){
    80002572:	fffff097          	auipc	ra,0xfffff
    80002576:	a14080e7          	jalr	-1516(ra) # 80000f86 <myproc>
    8000257a:	4601                	li	a2,0
    8000257c:	fc043583          	ld	a1,-64(s0)
    80002580:	6928                	ld	a0,80(a0)
    80002582:	ffffe097          	auipc	ra,0xffffe
    80002586:	f22080e7          	jalr	-222(ra) # 800004a4 <walk>
    8000258a:	d171                	beqz	a0,8000254e <sys_pgaccess+0x64>
    if(*pte & PTE_A){
    8000258c:	611c                	ld	a5,0(a0)
    8000258e:	0407f793          	andi	a5,a5,64
    80002592:	d7f1                	beqz	a5,8000255e <sys_pgaccess+0x74>
      BitMask |= 1 << i;
    80002594:	0099973b          	sllw	a4,s3,s1
    80002598:	fc843783          	ld	a5,-56(s0)
    8000259c:	8fd9                	or	a5,a5,a4
    8000259e:	fcf43423          	sd	a5,-56(s0)
      *pte &= ~PTE_A;
    800025a2:	611c                	ld	a5,0(a0)
    800025a4:	fbf7f793          	andi	a5,a5,-65
    800025a8:	e11c                	sd	a5,0(a0)
    800025aa:	bf55                	j	8000255e <sys_pgaccess+0x74>
    }
  }

  copyout(myproc()->pagetable, BitMaskVA, (char*)&BitMask, sizeof(BitMask));
    800025ac:	fffff097          	auipc	ra,0xfffff
    800025b0:	9da080e7          	jalr	-1574(ra) # 80000f86 <myproc>
    800025b4:	46a1                	li	a3,8
    800025b6:	fc840613          	addi	a2,s0,-56
    800025ba:	fb043583          	ld	a1,-80(s0)
    800025be:	6928                	ld	a0,80(a0)
    800025c0:	ffffe097          	auipc	ra,0xffffe
    800025c4:	592080e7          	jalr	1426(ra) # 80000b52 <copyout>
  return 0;
    800025c8:	4501                	li	a0,0
}
    800025ca:	60a6                	ld	ra,72(sp)
    800025cc:	6406                	ld	s0,64(sp)
    800025ce:	74e2                	ld	s1,56(sp)
    800025d0:	7942                	ld	s2,48(sp)
    800025d2:	79a2                	ld	s3,40(sp)
    800025d4:	6161                	addi	sp,sp,80
    800025d6:	8082                	ret
    return -1;
    800025d8:	557d                	li	a0,-1
    800025da:	bfc5                	j	800025ca <sys_pgaccess+0xe0>
    return -1;
    800025dc:	557d                	li	a0,-1
    800025de:	b7f5                	j	800025ca <sys_pgaccess+0xe0>
    return -1;
    800025e0:	557d                	li	a0,-1
    800025e2:	b7e5                	j	800025ca <sys_pgaccess+0xe0>
    return -1;
    800025e4:	557d                	li	a0,-1
    800025e6:	b7d5                	j	800025ca <sys_pgaccess+0xe0>

00000000800025e8 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800025e8:	7179                	addi	sp,sp,-48
    800025ea:	f406                	sd	ra,40(sp)
    800025ec:	f022                	sd	s0,32(sp)
    800025ee:	ec26                	sd	s1,24(sp)
    800025f0:	e84a                	sd	s2,16(sp)
    800025f2:	e44e                	sd	s3,8(sp)
    800025f4:	e052                	sd	s4,0(sp)
    800025f6:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800025f8:	00006597          	auipc	a1,0x6
    800025fc:	0a058593          	addi	a1,a1,160 # 80008698 <syscalls_name+0xd8>
    80002600:	0000d517          	auipc	a0,0xd
    80002604:	c9850513          	addi	a0,a0,-872 # 8000f298 <bcache>
    80002608:	00004097          	auipc	ra,0x4
    8000260c:	da0080e7          	jalr	-608(ra) # 800063a8 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002610:	00015797          	auipc	a5,0x15
    80002614:	c8878793          	addi	a5,a5,-888 # 80017298 <bcache+0x8000>
    80002618:	00015717          	auipc	a4,0x15
    8000261c:	ee870713          	addi	a4,a4,-280 # 80017500 <bcache+0x8268>
    80002620:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002624:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002628:	0000d497          	auipc	s1,0xd
    8000262c:	c8848493          	addi	s1,s1,-888 # 8000f2b0 <bcache+0x18>
    b->next = bcache.head.next;
    80002630:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002632:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002634:	00006a17          	auipc	s4,0x6
    80002638:	06ca0a13          	addi	s4,s4,108 # 800086a0 <syscalls_name+0xe0>
    b->next = bcache.head.next;
    8000263c:	2b893783          	ld	a5,696(s2) # 12b8 <_entry-0x7fffed48>
    80002640:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002642:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002646:	85d2                	mv	a1,s4
    80002648:	01048513          	addi	a0,s1,16
    8000264c:	00001097          	auipc	ra,0x1
    80002650:	4c2080e7          	jalr	1218(ra) # 80003b0e <initsleeplock>
    bcache.head.next->prev = b;
    80002654:	2b893783          	ld	a5,696(s2)
    80002658:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000265a:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000265e:	45848493          	addi	s1,s1,1112
    80002662:	fd349de3          	bne	s1,s3,8000263c <binit+0x54>
  }
}
    80002666:	70a2                	ld	ra,40(sp)
    80002668:	7402                	ld	s0,32(sp)
    8000266a:	64e2                	ld	s1,24(sp)
    8000266c:	6942                	ld	s2,16(sp)
    8000266e:	69a2                	ld	s3,8(sp)
    80002670:	6a02                	ld	s4,0(sp)
    80002672:	6145                	addi	sp,sp,48
    80002674:	8082                	ret

0000000080002676 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002676:	7179                	addi	sp,sp,-48
    80002678:	f406                	sd	ra,40(sp)
    8000267a:	f022                	sd	s0,32(sp)
    8000267c:	ec26                	sd	s1,24(sp)
    8000267e:	e84a                	sd	s2,16(sp)
    80002680:	e44e                	sd	s3,8(sp)
    80002682:	1800                	addi	s0,sp,48
    80002684:	892a                	mv	s2,a0
    80002686:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002688:	0000d517          	auipc	a0,0xd
    8000268c:	c1050513          	addi	a0,a0,-1008 # 8000f298 <bcache>
    80002690:	00004097          	auipc	ra,0x4
    80002694:	da8080e7          	jalr	-600(ra) # 80006438 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002698:	00015497          	auipc	s1,0x15
    8000269c:	eb84b483          	ld	s1,-328(s1) # 80017550 <bcache+0x82b8>
    800026a0:	00015797          	auipc	a5,0x15
    800026a4:	e6078793          	addi	a5,a5,-416 # 80017500 <bcache+0x8268>
    800026a8:	02f48f63          	beq	s1,a5,800026e6 <bread+0x70>
    800026ac:	873e                	mv	a4,a5
    800026ae:	a021                	j	800026b6 <bread+0x40>
    800026b0:	68a4                	ld	s1,80(s1)
    800026b2:	02e48a63          	beq	s1,a4,800026e6 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800026b6:	449c                	lw	a5,8(s1)
    800026b8:	ff279ce3          	bne	a5,s2,800026b0 <bread+0x3a>
    800026bc:	44dc                	lw	a5,12(s1)
    800026be:	ff3799e3          	bne	a5,s3,800026b0 <bread+0x3a>
      b->refcnt++;
    800026c2:	40bc                	lw	a5,64(s1)
    800026c4:	2785                	addiw	a5,a5,1
    800026c6:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800026c8:	0000d517          	auipc	a0,0xd
    800026cc:	bd050513          	addi	a0,a0,-1072 # 8000f298 <bcache>
    800026d0:	00004097          	auipc	ra,0x4
    800026d4:	e1c080e7          	jalr	-484(ra) # 800064ec <release>
      acquiresleep(&b->lock);
    800026d8:	01048513          	addi	a0,s1,16
    800026dc:	00001097          	auipc	ra,0x1
    800026e0:	46c080e7          	jalr	1132(ra) # 80003b48 <acquiresleep>
      return b;
    800026e4:	a8b9                	j	80002742 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800026e6:	00015497          	auipc	s1,0x15
    800026ea:	e624b483          	ld	s1,-414(s1) # 80017548 <bcache+0x82b0>
    800026ee:	00015797          	auipc	a5,0x15
    800026f2:	e1278793          	addi	a5,a5,-494 # 80017500 <bcache+0x8268>
    800026f6:	00f48863          	beq	s1,a5,80002706 <bread+0x90>
    800026fa:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800026fc:	40bc                	lw	a5,64(s1)
    800026fe:	cf81                	beqz	a5,80002716 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002700:	64a4                	ld	s1,72(s1)
    80002702:	fee49de3          	bne	s1,a4,800026fc <bread+0x86>
  panic("bget: no buffers");
    80002706:	00006517          	auipc	a0,0x6
    8000270a:	fa250513          	addi	a0,a0,-94 # 800086a8 <syscalls_name+0xe8>
    8000270e:	00003097          	auipc	ra,0x3
    80002712:	7f2080e7          	jalr	2034(ra) # 80005f00 <panic>
      b->dev = dev;
    80002716:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000271a:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000271e:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002722:	4785                	li	a5,1
    80002724:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002726:	0000d517          	auipc	a0,0xd
    8000272a:	b7250513          	addi	a0,a0,-1166 # 8000f298 <bcache>
    8000272e:	00004097          	auipc	ra,0x4
    80002732:	dbe080e7          	jalr	-578(ra) # 800064ec <release>
      acquiresleep(&b->lock);
    80002736:	01048513          	addi	a0,s1,16
    8000273a:	00001097          	auipc	ra,0x1
    8000273e:	40e080e7          	jalr	1038(ra) # 80003b48 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002742:	409c                	lw	a5,0(s1)
    80002744:	cb89                	beqz	a5,80002756 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002746:	8526                	mv	a0,s1
    80002748:	70a2                	ld	ra,40(sp)
    8000274a:	7402                	ld	s0,32(sp)
    8000274c:	64e2                	ld	s1,24(sp)
    8000274e:	6942                	ld	s2,16(sp)
    80002750:	69a2                	ld	s3,8(sp)
    80002752:	6145                	addi	sp,sp,48
    80002754:	8082                	ret
    virtio_disk_rw(b, 0);
    80002756:	4581                	li	a1,0
    80002758:	8526                	mv	a0,s1
    8000275a:	00003097          	auipc	ra,0x3
    8000275e:	f38080e7          	jalr	-200(ra) # 80005692 <virtio_disk_rw>
    b->valid = 1;
    80002762:	4785                	li	a5,1
    80002764:	c09c                	sw	a5,0(s1)
  return b;
    80002766:	b7c5                	j	80002746 <bread+0xd0>

0000000080002768 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002768:	1101                	addi	sp,sp,-32
    8000276a:	ec06                	sd	ra,24(sp)
    8000276c:	e822                	sd	s0,16(sp)
    8000276e:	e426                	sd	s1,8(sp)
    80002770:	1000                	addi	s0,sp,32
    80002772:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002774:	0541                	addi	a0,a0,16
    80002776:	00001097          	auipc	ra,0x1
    8000277a:	46c080e7          	jalr	1132(ra) # 80003be2 <holdingsleep>
    8000277e:	cd01                	beqz	a0,80002796 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002780:	4585                	li	a1,1
    80002782:	8526                	mv	a0,s1
    80002784:	00003097          	auipc	ra,0x3
    80002788:	f0e080e7          	jalr	-242(ra) # 80005692 <virtio_disk_rw>
}
    8000278c:	60e2                	ld	ra,24(sp)
    8000278e:	6442                	ld	s0,16(sp)
    80002790:	64a2                	ld	s1,8(sp)
    80002792:	6105                	addi	sp,sp,32
    80002794:	8082                	ret
    panic("bwrite");
    80002796:	00006517          	auipc	a0,0x6
    8000279a:	f2a50513          	addi	a0,a0,-214 # 800086c0 <syscalls_name+0x100>
    8000279e:	00003097          	auipc	ra,0x3
    800027a2:	762080e7          	jalr	1890(ra) # 80005f00 <panic>

00000000800027a6 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800027a6:	1101                	addi	sp,sp,-32
    800027a8:	ec06                	sd	ra,24(sp)
    800027aa:	e822                	sd	s0,16(sp)
    800027ac:	e426                	sd	s1,8(sp)
    800027ae:	e04a                	sd	s2,0(sp)
    800027b0:	1000                	addi	s0,sp,32
    800027b2:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800027b4:	01050913          	addi	s2,a0,16
    800027b8:	854a                	mv	a0,s2
    800027ba:	00001097          	auipc	ra,0x1
    800027be:	428080e7          	jalr	1064(ra) # 80003be2 <holdingsleep>
    800027c2:	c92d                	beqz	a0,80002834 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800027c4:	854a                	mv	a0,s2
    800027c6:	00001097          	auipc	ra,0x1
    800027ca:	3d8080e7          	jalr	984(ra) # 80003b9e <releasesleep>

  acquire(&bcache.lock);
    800027ce:	0000d517          	auipc	a0,0xd
    800027d2:	aca50513          	addi	a0,a0,-1334 # 8000f298 <bcache>
    800027d6:	00004097          	auipc	ra,0x4
    800027da:	c62080e7          	jalr	-926(ra) # 80006438 <acquire>
  b->refcnt--;
    800027de:	40bc                	lw	a5,64(s1)
    800027e0:	37fd                	addiw	a5,a5,-1
    800027e2:	0007871b          	sext.w	a4,a5
    800027e6:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800027e8:	eb05                	bnez	a4,80002818 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800027ea:	68bc                	ld	a5,80(s1)
    800027ec:	64b8                	ld	a4,72(s1)
    800027ee:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800027f0:	64bc                	ld	a5,72(s1)
    800027f2:	68b8                	ld	a4,80(s1)
    800027f4:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800027f6:	00015797          	auipc	a5,0x15
    800027fa:	aa278793          	addi	a5,a5,-1374 # 80017298 <bcache+0x8000>
    800027fe:	2b87b703          	ld	a4,696(a5)
    80002802:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002804:	00015717          	auipc	a4,0x15
    80002808:	cfc70713          	addi	a4,a4,-772 # 80017500 <bcache+0x8268>
    8000280c:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000280e:	2b87b703          	ld	a4,696(a5)
    80002812:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002814:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002818:	0000d517          	auipc	a0,0xd
    8000281c:	a8050513          	addi	a0,a0,-1408 # 8000f298 <bcache>
    80002820:	00004097          	auipc	ra,0x4
    80002824:	ccc080e7          	jalr	-820(ra) # 800064ec <release>
}
    80002828:	60e2                	ld	ra,24(sp)
    8000282a:	6442                	ld	s0,16(sp)
    8000282c:	64a2                	ld	s1,8(sp)
    8000282e:	6902                	ld	s2,0(sp)
    80002830:	6105                	addi	sp,sp,32
    80002832:	8082                	ret
    panic("brelse");
    80002834:	00006517          	auipc	a0,0x6
    80002838:	e9450513          	addi	a0,a0,-364 # 800086c8 <syscalls_name+0x108>
    8000283c:	00003097          	auipc	ra,0x3
    80002840:	6c4080e7          	jalr	1732(ra) # 80005f00 <panic>

0000000080002844 <bpin>:

void
bpin(struct buf *b) {
    80002844:	1101                	addi	sp,sp,-32
    80002846:	ec06                	sd	ra,24(sp)
    80002848:	e822                	sd	s0,16(sp)
    8000284a:	e426                	sd	s1,8(sp)
    8000284c:	1000                	addi	s0,sp,32
    8000284e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002850:	0000d517          	auipc	a0,0xd
    80002854:	a4850513          	addi	a0,a0,-1464 # 8000f298 <bcache>
    80002858:	00004097          	auipc	ra,0x4
    8000285c:	be0080e7          	jalr	-1056(ra) # 80006438 <acquire>
  b->refcnt++;
    80002860:	40bc                	lw	a5,64(s1)
    80002862:	2785                	addiw	a5,a5,1
    80002864:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002866:	0000d517          	auipc	a0,0xd
    8000286a:	a3250513          	addi	a0,a0,-1486 # 8000f298 <bcache>
    8000286e:	00004097          	auipc	ra,0x4
    80002872:	c7e080e7          	jalr	-898(ra) # 800064ec <release>
}
    80002876:	60e2                	ld	ra,24(sp)
    80002878:	6442                	ld	s0,16(sp)
    8000287a:	64a2                	ld	s1,8(sp)
    8000287c:	6105                	addi	sp,sp,32
    8000287e:	8082                	ret

0000000080002880 <bunpin>:

void
bunpin(struct buf *b) {
    80002880:	1101                	addi	sp,sp,-32
    80002882:	ec06                	sd	ra,24(sp)
    80002884:	e822                	sd	s0,16(sp)
    80002886:	e426                	sd	s1,8(sp)
    80002888:	1000                	addi	s0,sp,32
    8000288a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000288c:	0000d517          	auipc	a0,0xd
    80002890:	a0c50513          	addi	a0,a0,-1524 # 8000f298 <bcache>
    80002894:	00004097          	auipc	ra,0x4
    80002898:	ba4080e7          	jalr	-1116(ra) # 80006438 <acquire>
  b->refcnt--;
    8000289c:	40bc                	lw	a5,64(s1)
    8000289e:	37fd                	addiw	a5,a5,-1
    800028a0:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800028a2:	0000d517          	auipc	a0,0xd
    800028a6:	9f650513          	addi	a0,a0,-1546 # 8000f298 <bcache>
    800028aa:	00004097          	auipc	ra,0x4
    800028ae:	c42080e7          	jalr	-958(ra) # 800064ec <release>
}
    800028b2:	60e2                	ld	ra,24(sp)
    800028b4:	6442                	ld	s0,16(sp)
    800028b6:	64a2                	ld	s1,8(sp)
    800028b8:	6105                	addi	sp,sp,32
    800028ba:	8082                	ret

00000000800028bc <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800028bc:	1101                	addi	sp,sp,-32
    800028be:	ec06                	sd	ra,24(sp)
    800028c0:	e822                	sd	s0,16(sp)
    800028c2:	e426                	sd	s1,8(sp)
    800028c4:	e04a                	sd	s2,0(sp)
    800028c6:	1000                	addi	s0,sp,32
    800028c8:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800028ca:	00d5d59b          	srliw	a1,a1,0xd
    800028ce:	00015797          	auipc	a5,0x15
    800028d2:	0a67a783          	lw	a5,166(a5) # 80017974 <sb+0x1c>
    800028d6:	9dbd                	addw	a1,a1,a5
    800028d8:	00000097          	auipc	ra,0x0
    800028dc:	d9e080e7          	jalr	-610(ra) # 80002676 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800028e0:	0074f713          	andi	a4,s1,7
    800028e4:	4785                	li	a5,1
    800028e6:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800028ea:	14ce                	slli	s1,s1,0x33
    800028ec:	90d9                	srli	s1,s1,0x36
    800028ee:	00950733          	add	a4,a0,s1
    800028f2:	05874703          	lbu	a4,88(a4)
    800028f6:	00e7f6b3          	and	a3,a5,a4
    800028fa:	c69d                	beqz	a3,80002928 <bfree+0x6c>
    800028fc:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800028fe:	94aa                	add	s1,s1,a0
    80002900:	fff7c793          	not	a5,a5
    80002904:	8f7d                	and	a4,a4,a5
    80002906:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000290a:	00001097          	auipc	ra,0x1
    8000290e:	120080e7          	jalr	288(ra) # 80003a2a <log_write>
  brelse(bp);
    80002912:	854a                	mv	a0,s2
    80002914:	00000097          	auipc	ra,0x0
    80002918:	e92080e7          	jalr	-366(ra) # 800027a6 <brelse>
}
    8000291c:	60e2                	ld	ra,24(sp)
    8000291e:	6442                	ld	s0,16(sp)
    80002920:	64a2                	ld	s1,8(sp)
    80002922:	6902                	ld	s2,0(sp)
    80002924:	6105                	addi	sp,sp,32
    80002926:	8082                	ret
    panic("freeing free block");
    80002928:	00006517          	auipc	a0,0x6
    8000292c:	da850513          	addi	a0,a0,-600 # 800086d0 <syscalls_name+0x110>
    80002930:	00003097          	auipc	ra,0x3
    80002934:	5d0080e7          	jalr	1488(ra) # 80005f00 <panic>

0000000080002938 <balloc>:
{
    80002938:	711d                	addi	sp,sp,-96
    8000293a:	ec86                	sd	ra,88(sp)
    8000293c:	e8a2                	sd	s0,80(sp)
    8000293e:	e4a6                	sd	s1,72(sp)
    80002940:	e0ca                	sd	s2,64(sp)
    80002942:	fc4e                	sd	s3,56(sp)
    80002944:	f852                	sd	s4,48(sp)
    80002946:	f456                	sd	s5,40(sp)
    80002948:	f05a                	sd	s6,32(sp)
    8000294a:	ec5e                	sd	s7,24(sp)
    8000294c:	e862                	sd	s8,16(sp)
    8000294e:	e466                	sd	s9,8(sp)
    80002950:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002952:	00015797          	auipc	a5,0x15
    80002956:	00a7a783          	lw	a5,10(a5) # 8001795c <sb+0x4>
    8000295a:	cbc1                	beqz	a5,800029ea <balloc+0xb2>
    8000295c:	8baa                	mv	s7,a0
    8000295e:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002960:	00015b17          	auipc	s6,0x15
    80002964:	ff8b0b13          	addi	s6,s6,-8 # 80017958 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002968:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000296a:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000296c:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000296e:	6c89                	lui	s9,0x2
    80002970:	a831                	j	8000298c <balloc+0x54>
    brelse(bp);
    80002972:	854a                	mv	a0,s2
    80002974:	00000097          	auipc	ra,0x0
    80002978:	e32080e7          	jalr	-462(ra) # 800027a6 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000297c:	015c87bb          	addw	a5,s9,s5
    80002980:	00078a9b          	sext.w	s5,a5
    80002984:	004b2703          	lw	a4,4(s6)
    80002988:	06eaf163          	bgeu	s5,a4,800029ea <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    8000298c:	41fad79b          	sraiw	a5,s5,0x1f
    80002990:	0137d79b          	srliw	a5,a5,0x13
    80002994:	015787bb          	addw	a5,a5,s5
    80002998:	40d7d79b          	sraiw	a5,a5,0xd
    8000299c:	01cb2583          	lw	a1,28(s6)
    800029a0:	9dbd                	addw	a1,a1,a5
    800029a2:	855e                	mv	a0,s7
    800029a4:	00000097          	auipc	ra,0x0
    800029a8:	cd2080e7          	jalr	-814(ra) # 80002676 <bread>
    800029ac:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800029ae:	004b2503          	lw	a0,4(s6)
    800029b2:	000a849b          	sext.w	s1,s5
    800029b6:	8762                	mv	a4,s8
    800029b8:	faa4fde3          	bgeu	s1,a0,80002972 <balloc+0x3a>
      m = 1 << (bi % 8);
    800029bc:	00777693          	andi	a3,a4,7
    800029c0:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800029c4:	41f7579b          	sraiw	a5,a4,0x1f
    800029c8:	01d7d79b          	srliw	a5,a5,0x1d
    800029cc:	9fb9                	addw	a5,a5,a4
    800029ce:	4037d79b          	sraiw	a5,a5,0x3
    800029d2:	00f90633          	add	a2,s2,a5
    800029d6:	05864603          	lbu	a2,88(a2)
    800029da:	00c6f5b3          	and	a1,a3,a2
    800029de:	cd91                	beqz	a1,800029fa <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800029e0:	2705                	addiw	a4,a4,1
    800029e2:	2485                	addiw	s1,s1,1
    800029e4:	fd471ae3          	bne	a4,s4,800029b8 <balloc+0x80>
    800029e8:	b769                	j	80002972 <balloc+0x3a>
  panic("balloc: out of blocks");
    800029ea:	00006517          	auipc	a0,0x6
    800029ee:	cfe50513          	addi	a0,a0,-770 # 800086e8 <syscalls_name+0x128>
    800029f2:	00003097          	auipc	ra,0x3
    800029f6:	50e080e7          	jalr	1294(ra) # 80005f00 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800029fa:	97ca                	add	a5,a5,s2
    800029fc:	8e55                	or	a2,a2,a3
    800029fe:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002a02:	854a                	mv	a0,s2
    80002a04:	00001097          	auipc	ra,0x1
    80002a08:	026080e7          	jalr	38(ra) # 80003a2a <log_write>
        brelse(bp);
    80002a0c:	854a                	mv	a0,s2
    80002a0e:	00000097          	auipc	ra,0x0
    80002a12:	d98080e7          	jalr	-616(ra) # 800027a6 <brelse>
  bp = bread(dev, bno);
    80002a16:	85a6                	mv	a1,s1
    80002a18:	855e                	mv	a0,s7
    80002a1a:	00000097          	auipc	ra,0x0
    80002a1e:	c5c080e7          	jalr	-932(ra) # 80002676 <bread>
    80002a22:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002a24:	40000613          	li	a2,1024
    80002a28:	4581                	li	a1,0
    80002a2a:	05850513          	addi	a0,a0,88
    80002a2e:	ffffd097          	auipc	ra,0xffffd
    80002a32:	796080e7          	jalr	1942(ra) # 800001c4 <memset>
  log_write(bp);
    80002a36:	854a                	mv	a0,s2
    80002a38:	00001097          	auipc	ra,0x1
    80002a3c:	ff2080e7          	jalr	-14(ra) # 80003a2a <log_write>
  brelse(bp);
    80002a40:	854a                	mv	a0,s2
    80002a42:	00000097          	auipc	ra,0x0
    80002a46:	d64080e7          	jalr	-668(ra) # 800027a6 <brelse>
}
    80002a4a:	8526                	mv	a0,s1
    80002a4c:	60e6                	ld	ra,88(sp)
    80002a4e:	6446                	ld	s0,80(sp)
    80002a50:	64a6                	ld	s1,72(sp)
    80002a52:	6906                	ld	s2,64(sp)
    80002a54:	79e2                	ld	s3,56(sp)
    80002a56:	7a42                	ld	s4,48(sp)
    80002a58:	7aa2                	ld	s5,40(sp)
    80002a5a:	7b02                	ld	s6,32(sp)
    80002a5c:	6be2                	ld	s7,24(sp)
    80002a5e:	6c42                	ld	s8,16(sp)
    80002a60:	6ca2                	ld	s9,8(sp)
    80002a62:	6125                	addi	sp,sp,96
    80002a64:	8082                	ret

0000000080002a66 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80002a66:	7179                	addi	sp,sp,-48
    80002a68:	f406                	sd	ra,40(sp)
    80002a6a:	f022                	sd	s0,32(sp)
    80002a6c:	ec26                	sd	s1,24(sp)
    80002a6e:	e84a                	sd	s2,16(sp)
    80002a70:	e44e                	sd	s3,8(sp)
    80002a72:	e052                	sd	s4,0(sp)
    80002a74:	1800                	addi	s0,sp,48
    80002a76:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002a78:	47ad                	li	a5,11
    80002a7a:	04b7fe63          	bgeu	a5,a1,80002ad6 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002a7e:	ff45849b          	addiw	s1,a1,-12
    80002a82:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002a86:	0ff00793          	li	a5,255
    80002a8a:	0ae7e463          	bltu	a5,a4,80002b32 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002a8e:	08052583          	lw	a1,128(a0)
    80002a92:	c5b5                	beqz	a1,80002afe <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80002a94:	00092503          	lw	a0,0(s2)
    80002a98:	00000097          	auipc	ra,0x0
    80002a9c:	bde080e7          	jalr	-1058(ra) # 80002676 <bread>
    80002aa0:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002aa2:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002aa6:	02049713          	slli	a4,s1,0x20
    80002aaa:	01e75593          	srli	a1,a4,0x1e
    80002aae:	00b784b3          	add	s1,a5,a1
    80002ab2:	0004a983          	lw	s3,0(s1)
    80002ab6:	04098e63          	beqz	s3,80002b12 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    80002aba:	8552                	mv	a0,s4
    80002abc:	00000097          	auipc	ra,0x0
    80002ac0:	cea080e7          	jalr	-790(ra) # 800027a6 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002ac4:	854e                	mv	a0,s3
    80002ac6:	70a2                	ld	ra,40(sp)
    80002ac8:	7402                	ld	s0,32(sp)
    80002aca:	64e2                	ld	s1,24(sp)
    80002acc:	6942                	ld	s2,16(sp)
    80002ace:	69a2                	ld	s3,8(sp)
    80002ad0:	6a02                	ld	s4,0(sp)
    80002ad2:	6145                	addi	sp,sp,48
    80002ad4:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    80002ad6:	02059793          	slli	a5,a1,0x20
    80002ada:	01e7d593          	srli	a1,a5,0x1e
    80002ade:	00b504b3          	add	s1,a0,a1
    80002ae2:	0504a983          	lw	s3,80(s1)
    80002ae6:	fc099fe3          	bnez	s3,80002ac4 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    80002aea:	4108                	lw	a0,0(a0)
    80002aec:	00000097          	auipc	ra,0x0
    80002af0:	e4c080e7          	jalr	-436(ra) # 80002938 <balloc>
    80002af4:	0005099b          	sext.w	s3,a0
    80002af8:	0534a823          	sw	s3,80(s1)
    80002afc:	b7e1                	j	80002ac4 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80002afe:	4108                	lw	a0,0(a0)
    80002b00:	00000097          	auipc	ra,0x0
    80002b04:	e38080e7          	jalr	-456(ra) # 80002938 <balloc>
    80002b08:	0005059b          	sext.w	a1,a0
    80002b0c:	08b92023          	sw	a1,128(s2)
    80002b10:	b751                	j	80002a94 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002b12:	00092503          	lw	a0,0(s2)
    80002b16:	00000097          	auipc	ra,0x0
    80002b1a:	e22080e7          	jalr	-478(ra) # 80002938 <balloc>
    80002b1e:	0005099b          	sext.w	s3,a0
    80002b22:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002b26:	8552                	mv	a0,s4
    80002b28:	00001097          	auipc	ra,0x1
    80002b2c:	f02080e7          	jalr	-254(ra) # 80003a2a <log_write>
    80002b30:	b769                	j	80002aba <bmap+0x54>
  panic("bmap: out of range");
    80002b32:	00006517          	auipc	a0,0x6
    80002b36:	bce50513          	addi	a0,a0,-1074 # 80008700 <syscalls_name+0x140>
    80002b3a:	00003097          	auipc	ra,0x3
    80002b3e:	3c6080e7          	jalr	966(ra) # 80005f00 <panic>

0000000080002b42 <iget>:
{
    80002b42:	7179                	addi	sp,sp,-48
    80002b44:	f406                	sd	ra,40(sp)
    80002b46:	f022                	sd	s0,32(sp)
    80002b48:	ec26                	sd	s1,24(sp)
    80002b4a:	e84a                	sd	s2,16(sp)
    80002b4c:	e44e                	sd	s3,8(sp)
    80002b4e:	e052                	sd	s4,0(sp)
    80002b50:	1800                	addi	s0,sp,48
    80002b52:	89aa                	mv	s3,a0
    80002b54:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002b56:	00015517          	auipc	a0,0x15
    80002b5a:	e2250513          	addi	a0,a0,-478 # 80017978 <itable>
    80002b5e:	00004097          	auipc	ra,0x4
    80002b62:	8da080e7          	jalr	-1830(ra) # 80006438 <acquire>
  empty = 0;
    80002b66:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002b68:	00015497          	auipc	s1,0x15
    80002b6c:	e2848493          	addi	s1,s1,-472 # 80017990 <itable+0x18>
    80002b70:	00017697          	auipc	a3,0x17
    80002b74:	8b068693          	addi	a3,a3,-1872 # 80019420 <log>
    80002b78:	a039                	j	80002b86 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002b7a:	02090b63          	beqz	s2,80002bb0 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002b7e:	08848493          	addi	s1,s1,136
    80002b82:	02d48a63          	beq	s1,a3,80002bb6 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002b86:	449c                	lw	a5,8(s1)
    80002b88:	fef059e3          	blez	a5,80002b7a <iget+0x38>
    80002b8c:	4098                	lw	a4,0(s1)
    80002b8e:	ff3716e3          	bne	a4,s3,80002b7a <iget+0x38>
    80002b92:	40d8                	lw	a4,4(s1)
    80002b94:	ff4713e3          	bne	a4,s4,80002b7a <iget+0x38>
      ip->ref++;
    80002b98:	2785                	addiw	a5,a5,1
    80002b9a:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002b9c:	00015517          	auipc	a0,0x15
    80002ba0:	ddc50513          	addi	a0,a0,-548 # 80017978 <itable>
    80002ba4:	00004097          	auipc	ra,0x4
    80002ba8:	948080e7          	jalr	-1720(ra) # 800064ec <release>
      return ip;
    80002bac:	8926                	mv	s2,s1
    80002bae:	a03d                	j	80002bdc <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002bb0:	f7f9                	bnez	a5,80002b7e <iget+0x3c>
    80002bb2:	8926                	mv	s2,s1
    80002bb4:	b7e9                	j	80002b7e <iget+0x3c>
  if(empty == 0)
    80002bb6:	02090c63          	beqz	s2,80002bee <iget+0xac>
  ip->dev = dev;
    80002bba:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002bbe:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002bc2:	4785                	li	a5,1
    80002bc4:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002bc8:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002bcc:	00015517          	auipc	a0,0x15
    80002bd0:	dac50513          	addi	a0,a0,-596 # 80017978 <itable>
    80002bd4:	00004097          	auipc	ra,0x4
    80002bd8:	918080e7          	jalr	-1768(ra) # 800064ec <release>
}
    80002bdc:	854a                	mv	a0,s2
    80002bde:	70a2                	ld	ra,40(sp)
    80002be0:	7402                	ld	s0,32(sp)
    80002be2:	64e2                	ld	s1,24(sp)
    80002be4:	6942                	ld	s2,16(sp)
    80002be6:	69a2                	ld	s3,8(sp)
    80002be8:	6a02                	ld	s4,0(sp)
    80002bea:	6145                	addi	sp,sp,48
    80002bec:	8082                	ret
    panic("iget: no inodes");
    80002bee:	00006517          	auipc	a0,0x6
    80002bf2:	b2a50513          	addi	a0,a0,-1238 # 80008718 <syscalls_name+0x158>
    80002bf6:	00003097          	auipc	ra,0x3
    80002bfa:	30a080e7          	jalr	778(ra) # 80005f00 <panic>

0000000080002bfe <fsinit>:
fsinit(int dev) {
    80002bfe:	7179                	addi	sp,sp,-48
    80002c00:	f406                	sd	ra,40(sp)
    80002c02:	f022                	sd	s0,32(sp)
    80002c04:	ec26                	sd	s1,24(sp)
    80002c06:	e84a                	sd	s2,16(sp)
    80002c08:	e44e                	sd	s3,8(sp)
    80002c0a:	1800                	addi	s0,sp,48
    80002c0c:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002c0e:	4585                	li	a1,1
    80002c10:	00000097          	auipc	ra,0x0
    80002c14:	a66080e7          	jalr	-1434(ra) # 80002676 <bread>
    80002c18:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002c1a:	00015997          	auipc	s3,0x15
    80002c1e:	d3e98993          	addi	s3,s3,-706 # 80017958 <sb>
    80002c22:	02000613          	li	a2,32
    80002c26:	05850593          	addi	a1,a0,88
    80002c2a:	854e                	mv	a0,s3
    80002c2c:	ffffd097          	auipc	ra,0xffffd
    80002c30:	5f4080e7          	jalr	1524(ra) # 80000220 <memmove>
  brelse(bp);
    80002c34:	8526                	mv	a0,s1
    80002c36:	00000097          	auipc	ra,0x0
    80002c3a:	b70080e7          	jalr	-1168(ra) # 800027a6 <brelse>
  if(sb.magic != FSMAGIC)
    80002c3e:	0009a703          	lw	a4,0(s3)
    80002c42:	102037b7          	lui	a5,0x10203
    80002c46:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002c4a:	02f71263          	bne	a4,a5,80002c6e <fsinit+0x70>
  initlog(dev, &sb);
    80002c4e:	00015597          	auipc	a1,0x15
    80002c52:	d0a58593          	addi	a1,a1,-758 # 80017958 <sb>
    80002c56:	854a                	mv	a0,s2
    80002c58:	00001097          	auipc	ra,0x1
    80002c5c:	b56080e7          	jalr	-1194(ra) # 800037ae <initlog>
}
    80002c60:	70a2                	ld	ra,40(sp)
    80002c62:	7402                	ld	s0,32(sp)
    80002c64:	64e2                	ld	s1,24(sp)
    80002c66:	6942                	ld	s2,16(sp)
    80002c68:	69a2                	ld	s3,8(sp)
    80002c6a:	6145                	addi	sp,sp,48
    80002c6c:	8082                	ret
    panic("invalid file system");
    80002c6e:	00006517          	auipc	a0,0x6
    80002c72:	aba50513          	addi	a0,a0,-1350 # 80008728 <syscalls_name+0x168>
    80002c76:	00003097          	auipc	ra,0x3
    80002c7a:	28a080e7          	jalr	650(ra) # 80005f00 <panic>

0000000080002c7e <iinit>:
{
    80002c7e:	7179                	addi	sp,sp,-48
    80002c80:	f406                	sd	ra,40(sp)
    80002c82:	f022                	sd	s0,32(sp)
    80002c84:	ec26                	sd	s1,24(sp)
    80002c86:	e84a                	sd	s2,16(sp)
    80002c88:	e44e                	sd	s3,8(sp)
    80002c8a:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002c8c:	00006597          	auipc	a1,0x6
    80002c90:	ab458593          	addi	a1,a1,-1356 # 80008740 <syscalls_name+0x180>
    80002c94:	00015517          	auipc	a0,0x15
    80002c98:	ce450513          	addi	a0,a0,-796 # 80017978 <itable>
    80002c9c:	00003097          	auipc	ra,0x3
    80002ca0:	70c080e7          	jalr	1804(ra) # 800063a8 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002ca4:	00015497          	auipc	s1,0x15
    80002ca8:	cfc48493          	addi	s1,s1,-772 # 800179a0 <itable+0x28>
    80002cac:	00016997          	auipc	s3,0x16
    80002cb0:	78498993          	addi	s3,s3,1924 # 80019430 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002cb4:	00006917          	auipc	s2,0x6
    80002cb8:	a9490913          	addi	s2,s2,-1388 # 80008748 <syscalls_name+0x188>
    80002cbc:	85ca                	mv	a1,s2
    80002cbe:	8526                	mv	a0,s1
    80002cc0:	00001097          	auipc	ra,0x1
    80002cc4:	e4e080e7          	jalr	-434(ra) # 80003b0e <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002cc8:	08848493          	addi	s1,s1,136
    80002ccc:	ff3498e3          	bne	s1,s3,80002cbc <iinit+0x3e>
}
    80002cd0:	70a2                	ld	ra,40(sp)
    80002cd2:	7402                	ld	s0,32(sp)
    80002cd4:	64e2                	ld	s1,24(sp)
    80002cd6:	6942                	ld	s2,16(sp)
    80002cd8:	69a2                	ld	s3,8(sp)
    80002cda:	6145                	addi	sp,sp,48
    80002cdc:	8082                	ret

0000000080002cde <ialloc>:
{
    80002cde:	715d                	addi	sp,sp,-80
    80002ce0:	e486                	sd	ra,72(sp)
    80002ce2:	e0a2                	sd	s0,64(sp)
    80002ce4:	fc26                	sd	s1,56(sp)
    80002ce6:	f84a                	sd	s2,48(sp)
    80002ce8:	f44e                	sd	s3,40(sp)
    80002cea:	f052                	sd	s4,32(sp)
    80002cec:	ec56                	sd	s5,24(sp)
    80002cee:	e85a                	sd	s6,16(sp)
    80002cf0:	e45e                	sd	s7,8(sp)
    80002cf2:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002cf4:	00015717          	auipc	a4,0x15
    80002cf8:	c7072703          	lw	a4,-912(a4) # 80017964 <sb+0xc>
    80002cfc:	4785                	li	a5,1
    80002cfe:	04e7fa63          	bgeu	a5,a4,80002d52 <ialloc+0x74>
    80002d02:	8aaa                	mv	s5,a0
    80002d04:	8bae                	mv	s7,a1
    80002d06:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002d08:	00015a17          	auipc	s4,0x15
    80002d0c:	c50a0a13          	addi	s4,s4,-944 # 80017958 <sb>
    80002d10:	00048b1b          	sext.w	s6,s1
    80002d14:	0044d593          	srli	a1,s1,0x4
    80002d18:	018a2783          	lw	a5,24(s4)
    80002d1c:	9dbd                	addw	a1,a1,a5
    80002d1e:	8556                	mv	a0,s5
    80002d20:	00000097          	auipc	ra,0x0
    80002d24:	956080e7          	jalr	-1706(ra) # 80002676 <bread>
    80002d28:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002d2a:	05850993          	addi	s3,a0,88
    80002d2e:	00f4f793          	andi	a5,s1,15
    80002d32:	079a                	slli	a5,a5,0x6
    80002d34:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002d36:	00099783          	lh	a5,0(s3)
    80002d3a:	c785                	beqz	a5,80002d62 <ialloc+0x84>
    brelse(bp);
    80002d3c:	00000097          	auipc	ra,0x0
    80002d40:	a6a080e7          	jalr	-1430(ra) # 800027a6 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002d44:	0485                	addi	s1,s1,1
    80002d46:	00ca2703          	lw	a4,12(s4)
    80002d4a:	0004879b          	sext.w	a5,s1
    80002d4e:	fce7e1e3          	bltu	a5,a4,80002d10 <ialloc+0x32>
  panic("ialloc: no inodes");
    80002d52:	00006517          	auipc	a0,0x6
    80002d56:	9fe50513          	addi	a0,a0,-1538 # 80008750 <syscalls_name+0x190>
    80002d5a:	00003097          	auipc	ra,0x3
    80002d5e:	1a6080e7          	jalr	422(ra) # 80005f00 <panic>
      memset(dip, 0, sizeof(*dip));
    80002d62:	04000613          	li	a2,64
    80002d66:	4581                	li	a1,0
    80002d68:	854e                	mv	a0,s3
    80002d6a:	ffffd097          	auipc	ra,0xffffd
    80002d6e:	45a080e7          	jalr	1114(ra) # 800001c4 <memset>
      dip->type = type;
    80002d72:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002d76:	854a                	mv	a0,s2
    80002d78:	00001097          	auipc	ra,0x1
    80002d7c:	cb2080e7          	jalr	-846(ra) # 80003a2a <log_write>
      brelse(bp);
    80002d80:	854a                	mv	a0,s2
    80002d82:	00000097          	auipc	ra,0x0
    80002d86:	a24080e7          	jalr	-1500(ra) # 800027a6 <brelse>
      return iget(dev, inum);
    80002d8a:	85da                	mv	a1,s6
    80002d8c:	8556                	mv	a0,s5
    80002d8e:	00000097          	auipc	ra,0x0
    80002d92:	db4080e7          	jalr	-588(ra) # 80002b42 <iget>
}
    80002d96:	60a6                	ld	ra,72(sp)
    80002d98:	6406                	ld	s0,64(sp)
    80002d9a:	74e2                	ld	s1,56(sp)
    80002d9c:	7942                	ld	s2,48(sp)
    80002d9e:	79a2                	ld	s3,40(sp)
    80002da0:	7a02                	ld	s4,32(sp)
    80002da2:	6ae2                	ld	s5,24(sp)
    80002da4:	6b42                	ld	s6,16(sp)
    80002da6:	6ba2                	ld	s7,8(sp)
    80002da8:	6161                	addi	sp,sp,80
    80002daa:	8082                	ret

0000000080002dac <iupdate>:
{
    80002dac:	1101                	addi	sp,sp,-32
    80002dae:	ec06                	sd	ra,24(sp)
    80002db0:	e822                	sd	s0,16(sp)
    80002db2:	e426                	sd	s1,8(sp)
    80002db4:	e04a                	sd	s2,0(sp)
    80002db6:	1000                	addi	s0,sp,32
    80002db8:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002dba:	415c                	lw	a5,4(a0)
    80002dbc:	0047d79b          	srliw	a5,a5,0x4
    80002dc0:	00015597          	auipc	a1,0x15
    80002dc4:	bb05a583          	lw	a1,-1104(a1) # 80017970 <sb+0x18>
    80002dc8:	9dbd                	addw	a1,a1,a5
    80002dca:	4108                	lw	a0,0(a0)
    80002dcc:	00000097          	auipc	ra,0x0
    80002dd0:	8aa080e7          	jalr	-1878(ra) # 80002676 <bread>
    80002dd4:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002dd6:	05850793          	addi	a5,a0,88
    80002dda:	40d8                	lw	a4,4(s1)
    80002ddc:	8b3d                	andi	a4,a4,15
    80002dde:	071a                	slli	a4,a4,0x6
    80002de0:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002de2:	04449703          	lh	a4,68(s1)
    80002de6:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002dea:	04649703          	lh	a4,70(s1)
    80002dee:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002df2:	04849703          	lh	a4,72(s1)
    80002df6:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002dfa:	04a49703          	lh	a4,74(s1)
    80002dfe:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002e02:	44f8                	lw	a4,76(s1)
    80002e04:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002e06:	03400613          	li	a2,52
    80002e0a:	05048593          	addi	a1,s1,80
    80002e0e:	00c78513          	addi	a0,a5,12
    80002e12:	ffffd097          	auipc	ra,0xffffd
    80002e16:	40e080e7          	jalr	1038(ra) # 80000220 <memmove>
  log_write(bp);
    80002e1a:	854a                	mv	a0,s2
    80002e1c:	00001097          	auipc	ra,0x1
    80002e20:	c0e080e7          	jalr	-1010(ra) # 80003a2a <log_write>
  brelse(bp);
    80002e24:	854a                	mv	a0,s2
    80002e26:	00000097          	auipc	ra,0x0
    80002e2a:	980080e7          	jalr	-1664(ra) # 800027a6 <brelse>
}
    80002e2e:	60e2                	ld	ra,24(sp)
    80002e30:	6442                	ld	s0,16(sp)
    80002e32:	64a2                	ld	s1,8(sp)
    80002e34:	6902                	ld	s2,0(sp)
    80002e36:	6105                	addi	sp,sp,32
    80002e38:	8082                	ret

0000000080002e3a <idup>:
{
    80002e3a:	1101                	addi	sp,sp,-32
    80002e3c:	ec06                	sd	ra,24(sp)
    80002e3e:	e822                	sd	s0,16(sp)
    80002e40:	e426                	sd	s1,8(sp)
    80002e42:	1000                	addi	s0,sp,32
    80002e44:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e46:	00015517          	auipc	a0,0x15
    80002e4a:	b3250513          	addi	a0,a0,-1230 # 80017978 <itable>
    80002e4e:	00003097          	auipc	ra,0x3
    80002e52:	5ea080e7          	jalr	1514(ra) # 80006438 <acquire>
  ip->ref++;
    80002e56:	449c                	lw	a5,8(s1)
    80002e58:	2785                	addiw	a5,a5,1
    80002e5a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e5c:	00015517          	auipc	a0,0x15
    80002e60:	b1c50513          	addi	a0,a0,-1252 # 80017978 <itable>
    80002e64:	00003097          	auipc	ra,0x3
    80002e68:	688080e7          	jalr	1672(ra) # 800064ec <release>
}
    80002e6c:	8526                	mv	a0,s1
    80002e6e:	60e2                	ld	ra,24(sp)
    80002e70:	6442                	ld	s0,16(sp)
    80002e72:	64a2                	ld	s1,8(sp)
    80002e74:	6105                	addi	sp,sp,32
    80002e76:	8082                	ret

0000000080002e78 <ilock>:
{
    80002e78:	1101                	addi	sp,sp,-32
    80002e7a:	ec06                	sd	ra,24(sp)
    80002e7c:	e822                	sd	s0,16(sp)
    80002e7e:	e426                	sd	s1,8(sp)
    80002e80:	e04a                	sd	s2,0(sp)
    80002e82:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002e84:	c115                	beqz	a0,80002ea8 <ilock+0x30>
    80002e86:	84aa                	mv	s1,a0
    80002e88:	451c                	lw	a5,8(a0)
    80002e8a:	00f05f63          	blez	a5,80002ea8 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002e8e:	0541                	addi	a0,a0,16
    80002e90:	00001097          	auipc	ra,0x1
    80002e94:	cb8080e7          	jalr	-840(ra) # 80003b48 <acquiresleep>
  if(ip->valid == 0){
    80002e98:	40bc                	lw	a5,64(s1)
    80002e9a:	cf99                	beqz	a5,80002eb8 <ilock+0x40>
}
    80002e9c:	60e2                	ld	ra,24(sp)
    80002e9e:	6442                	ld	s0,16(sp)
    80002ea0:	64a2                	ld	s1,8(sp)
    80002ea2:	6902                	ld	s2,0(sp)
    80002ea4:	6105                	addi	sp,sp,32
    80002ea6:	8082                	ret
    panic("ilock");
    80002ea8:	00006517          	auipc	a0,0x6
    80002eac:	8c050513          	addi	a0,a0,-1856 # 80008768 <syscalls_name+0x1a8>
    80002eb0:	00003097          	auipc	ra,0x3
    80002eb4:	050080e7          	jalr	80(ra) # 80005f00 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002eb8:	40dc                	lw	a5,4(s1)
    80002eba:	0047d79b          	srliw	a5,a5,0x4
    80002ebe:	00015597          	auipc	a1,0x15
    80002ec2:	ab25a583          	lw	a1,-1358(a1) # 80017970 <sb+0x18>
    80002ec6:	9dbd                	addw	a1,a1,a5
    80002ec8:	4088                	lw	a0,0(s1)
    80002eca:	fffff097          	auipc	ra,0xfffff
    80002ece:	7ac080e7          	jalr	1964(ra) # 80002676 <bread>
    80002ed2:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002ed4:	05850593          	addi	a1,a0,88
    80002ed8:	40dc                	lw	a5,4(s1)
    80002eda:	8bbd                	andi	a5,a5,15
    80002edc:	079a                	slli	a5,a5,0x6
    80002ede:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002ee0:	00059783          	lh	a5,0(a1)
    80002ee4:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002ee8:	00259783          	lh	a5,2(a1)
    80002eec:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002ef0:	00459783          	lh	a5,4(a1)
    80002ef4:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002ef8:	00659783          	lh	a5,6(a1)
    80002efc:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002f00:	459c                	lw	a5,8(a1)
    80002f02:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002f04:	03400613          	li	a2,52
    80002f08:	05b1                	addi	a1,a1,12
    80002f0a:	05048513          	addi	a0,s1,80
    80002f0e:	ffffd097          	auipc	ra,0xffffd
    80002f12:	312080e7          	jalr	786(ra) # 80000220 <memmove>
    brelse(bp);
    80002f16:	854a                	mv	a0,s2
    80002f18:	00000097          	auipc	ra,0x0
    80002f1c:	88e080e7          	jalr	-1906(ra) # 800027a6 <brelse>
    ip->valid = 1;
    80002f20:	4785                	li	a5,1
    80002f22:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002f24:	04449783          	lh	a5,68(s1)
    80002f28:	fbb5                	bnez	a5,80002e9c <ilock+0x24>
      panic("ilock: no type");
    80002f2a:	00006517          	auipc	a0,0x6
    80002f2e:	84650513          	addi	a0,a0,-1978 # 80008770 <syscalls_name+0x1b0>
    80002f32:	00003097          	auipc	ra,0x3
    80002f36:	fce080e7          	jalr	-50(ra) # 80005f00 <panic>

0000000080002f3a <iunlock>:
{
    80002f3a:	1101                	addi	sp,sp,-32
    80002f3c:	ec06                	sd	ra,24(sp)
    80002f3e:	e822                	sd	s0,16(sp)
    80002f40:	e426                	sd	s1,8(sp)
    80002f42:	e04a                	sd	s2,0(sp)
    80002f44:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002f46:	c905                	beqz	a0,80002f76 <iunlock+0x3c>
    80002f48:	84aa                	mv	s1,a0
    80002f4a:	01050913          	addi	s2,a0,16
    80002f4e:	854a                	mv	a0,s2
    80002f50:	00001097          	auipc	ra,0x1
    80002f54:	c92080e7          	jalr	-878(ra) # 80003be2 <holdingsleep>
    80002f58:	cd19                	beqz	a0,80002f76 <iunlock+0x3c>
    80002f5a:	449c                	lw	a5,8(s1)
    80002f5c:	00f05d63          	blez	a5,80002f76 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002f60:	854a                	mv	a0,s2
    80002f62:	00001097          	auipc	ra,0x1
    80002f66:	c3c080e7          	jalr	-964(ra) # 80003b9e <releasesleep>
}
    80002f6a:	60e2                	ld	ra,24(sp)
    80002f6c:	6442                	ld	s0,16(sp)
    80002f6e:	64a2                	ld	s1,8(sp)
    80002f70:	6902                	ld	s2,0(sp)
    80002f72:	6105                	addi	sp,sp,32
    80002f74:	8082                	ret
    panic("iunlock");
    80002f76:	00006517          	auipc	a0,0x6
    80002f7a:	80a50513          	addi	a0,a0,-2038 # 80008780 <syscalls_name+0x1c0>
    80002f7e:	00003097          	auipc	ra,0x3
    80002f82:	f82080e7          	jalr	-126(ra) # 80005f00 <panic>

0000000080002f86 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002f86:	7179                	addi	sp,sp,-48
    80002f88:	f406                	sd	ra,40(sp)
    80002f8a:	f022                	sd	s0,32(sp)
    80002f8c:	ec26                	sd	s1,24(sp)
    80002f8e:	e84a                	sd	s2,16(sp)
    80002f90:	e44e                	sd	s3,8(sp)
    80002f92:	e052                	sd	s4,0(sp)
    80002f94:	1800                	addi	s0,sp,48
    80002f96:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002f98:	05050493          	addi	s1,a0,80
    80002f9c:	08050913          	addi	s2,a0,128
    80002fa0:	a021                	j	80002fa8 <itrunc+0x22>
    80002fa2:	0491                	addi	s1,s1,4
    80002fa4:	01248d63          	beq	s1,s2,80002fbe <itrunc+0x38>
    if(ip->addrs[i]){
    80002fa8:	408c                	lw	a1,0(s1)
    80002faa:	dde5                	beqz	a1,80002fa2 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002fac:	0009a503          	lw	a0,0(s3)
    80002fb0:	00000097          	auipc	ra,0x0
    80002fb4:	90c080e7          	jalr	-1780(ra) # 800028bc <bfree>
      ip->addrs[i] = 0;
    80002fb8:	0004a023          	sw	zero,0(s1)
    80002fbc:	b7dd                	j	80002fa2 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002fbe:	0809a583          	lw	a1,128(s3)
    80002fc2:	e185                	bnez	a1,80002fe2 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002fc4:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002fc8:	854e                	mv	a0,s3
    80002fca:	00000097          	auipc	ra,0x0
    80002fce:	de2080e7          	jalr	-542(ra) # 80002dac <iupdate>
}
    80002fd2:	70a2                	ld	ra,40(sp)
    80002fd4:	7402                	ld	s0,32(sp)
    80002fd6:	64e2                	ld	s1,24(sp)
    80002fd8:	6942                	ld	s2,16(sp)
    80002fda:	69a2                	ld	s3,8(sp)
    80002fdc:	6a02                	ld	s4,0(sp)
    80002fde:	6145                	addi	sp,sp,48
    80002fe0:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002fe2:	0009a503          	lw	a0,0(s3)
    80002fe6:	fffff097          	auipc	ra,0xfffff
    80002fea:	690080e7          	jalr	1680(ra) # 80002676 <bread>
    80002fee:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002ff0:	05850493          	addi	s1,a0,88
    80002ff4:	45850913          	addi	s2,a0,1112
    80002ff8:	a021                	j	80003000 <itrunc+0x7a>
    80002ffa:	0491                	addi	s1,s1,4
    80002ffc:	01248b63          	beq	s1,s2,80003012 <itrunc+0x8c>
      if(a[j])
    80003000:	408c                	lw	a1,0(s1)
    80003002:	dde5                	beqz	a1,80002ffa <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80003004:	0009a503          	lw	a0,0(s3)
    80003008:	00000097          	auipc	ra,0x0
    8000300c:	8b4080e7          	jalr	-1868(ra) # 800028bc <bfree>
    80003010:	b7ed                	j	80002ffa <itrunc+0x74>
    brelse(bp);
    80003012:	8552                	mv	a0,s4
    80003014:	fffff097          	auipc	ra,0xfffff
    80003018:	792080e7          	jalr	1938(ra) # 800027a6 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    8000301c:	0809a583          	lw	a1,128(s3)
    80003020:	0009a503          	lw	a0,0(s3)
    80003024:	00000097          	auipc	ra,0x0
    80003028:	898080e7          	jalr	-1896(ra) # 800028bc <bfree>
    ip->addrs[NDIRECT] = 0;
    8000302c:	0809a023          	sw	zero,128(s3)
    80003030:	bf51                	j	80002fc4 <itrunc+0x3e>

0000000080003032 <iput>:
{
    80003032:	1101                	addi	sp,sp,-32
    80003034:	ec06                	sd	ra,24(sp)
    80003036:	e822                	sd	s0,16(sp)
    80003038:	e426                	sd	s1,8(sp)
    8000303a:	e04a                	sd	s2,0(sp)
    8000303c:	1000                	addi	s0,sp,32
    8000303e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003040:	00015517          	auipc	a0,0x15
    80003044:	93850513          	addi	a0,a0,-1736 # 80017978 <itable>
    80003048:	00003097          	auipc	ra,0x3
    8000304c:	3f0080e7          	jalr	1008(ra) # 80006438 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003050:	4498                	lw	a4,8(s1)
    80003052:	4785                	li	a5,1
    80003054:	02f70363          	beq	a4,a5,8000307a <iput+0x48>
  ip->ref--;
    80003058:	449c                	lw	a5,8(s1)
    8000305a:	37fd                	addiw	a5,a5,-1
    8000305c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000305e:	00015517          	auipc	a0,0x15
    80003062:	91a50513          	addi	a0,a0,-1766 # 80017978 <itable>
    80003066:	00003097          	auipc	ra,0x3
    8000306a:	486080e7          	jalr	1158(ra) # 800064ec <release>
}
    8000306e:	60e2                	ld	ra,24(sp)
    80003070:	6442                	ld	s0,16(sp)
    80003072:	64a2                	ld	s1,8(sp)
    80003074:	6902                	ld	s2,0(sp)
    80003076:	6105                	addi	sp,sp,32
    80003078:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000307a:	40bc                	lw	a5,64(s1)
    8000307c:	dff1                	beqz	a5,80003058 <iput+0x26>
    8000307e:	04a49783          	lh	a5,74(s1)
    80003082:	fbf9                	bnez	a5,80003058 <iput+0x26>
    acquiresleep(&ip->lock);
    80003084:	01048913          	addi	s2,s1,16
    80003088:	854a                	mv	a0,s2
    8000308a:	00001097          	auipc	ra,0x1
    8000308e:	abe080e7          	jalr	-1346(ra) # 80003b48 <acquiresleep>
    release(&itable.lock);
    80003092:	00015517          	auipc	a0,0x15
    80003096:	8e650513          	addi	a0,a0,-1818 # 80017978 <itable>
    8000309a:	00003097          	auipc	ra,0x3
    8000309e:	452080e7          	jalr	1106(ra) # 800064ec <release>
    itrunc(ip);
    800030a2:	8526                	mv	a0,s1
    800030a4:	00000097          	auipc	ra,0x0
    800030a8:	ee2080e7          	jalr	-286(ra) # 80002f86 <itrunc>
    ip->type = 0;
    800030ac:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800030b0:	8526                	mv	a0,s1
    800030b2:	00000097          	auipc	ra,0x0
    800030b6:	cfa080e7          	jalr	-774(ra) # 80002dac <iupdate>
    ip->valid = 0;
    800030ba:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800030be:	854a                	mv	a0,s2
    800030c0:	00001097          	auipc	ra,0x1
    800030c4:	ade080e7          	jalr	-1314(ra) # 80003b9e <releasesleep>
    acquire(&itable.lock);
    800030c8:	00015517          	auipc	a0,0x15
    800030cc:	8b050513          	addi	a0,a0,-1872 # 80017978 <itable>
    800030d0:	00003097          	auipc	ra,0x3
    800030d4:	368080e7          	jalr	872(ra) # 80006438 <acquire>
    800030d8:	b741                	j	80003058 <iput+0x26>

00000000800030da <iunlockput>:
{
    800030da:	1101                	addi	sp,sp,-32
    800030dc:	ec06                	sd	ra,24(sp)
    800030de:	e822                	sd	s0,16(sp)
    800030e0:	e426                	sd	s1,8(sp)
    800030e2:	1000                	addi	s0,sp,32
    800030e4:	84aa                	mv	s1,a0
  iunlock(ip);
    800030e6:	00000097          	auipc	ra,0x0
    800030ea:	e54080e7          	jalr	-428(ra) # 80002f3a <iunlock>
  iput(ip);
    800030ee:	8526                	mv	a0,s1
    800030f0:	00000097          	auipc	ra,0x0
    800030f4:	f42080e7          	jalr	-190(ra) # 80003032 <iput>
}
    800030f8:	60e2                	ld	ra,24(sp)
    800030fa:	6442                	ld	s0,16(sp)
    800030fc:	64a2                	ld	s1,8(sp)
    800030fe:	6105                	addi	sp,sp,32
    80003100:	8082                	ret

0000000080003102 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003102:	1141                	addi	sp,sp,-16
    80003104:	e422                	sd	s0,8(sp)
    80003106:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003108:	411c                	lw	a5,0(a0)
    8000310a:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000310c:	415c                	lw	a5,4(a0)
    8000310e:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003110:	04451783          	lh	a5,68(a0)
    80003114:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003118:	04a51783          	lh	a5,74(a0)
    8000311c:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003120:	04c56783          	lwu	a5,76(a0)
    80003124:	e99c                	sd	a5,16(a1)
}
    80003126:	6422                	ld	s0,8(sp)
    80003128:	0141                	addi	sp,sp,16
    8000312a:	8082                	ret

000000008000312c <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000312c:	457c                	lw	a5,76(a0)
    8000312e:	0ed7e963          	bltu	a5,a3,80003220 <readi+0xf4>
{
    80003132:	7159                	addi	sp,sp,-112
    80003134:	f486                	sd	ra,104(sp)
    80003136:	f0a2                	sd	s0,96(sp)
    80003138:	eca6                	sd	s1,88(sp)
    8000313a:	e8ca                	sd	s2,80(sp)
    8000313c:	e4ce                	sd	s3,72(sp)
    8000313e:	e0d2                	sd	s4,64(sp)
    80003140:	fc56                	sd	s5,56(sp)
    80003142:	f85a                	sd	s6,48(sp)
    80003144:	f45e                	sd	s7,40(sp)
    80003146:	f062                	sd	s8,32(sp)
    80003148:	ec66                	sd	s9,24(sp)
    8000314a:	e86a                	sd	s10,16(sp)
    8000314c:	e46e                	sd	s11,8(sp)
    8000314e:	1880                	addi	s0,sp,112
    80003150:	8baa                	mv	s7,a0
    80003152:	8c2e                	mv	s8,a1
    80003154:	8ab2                	mv	s5,a2
    80003156:	84b6                	mv	s1,a3
    80003158:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000315a:	9f35                	addw	a4,a4,a3
    return 0;
    8000315c:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000315e:	0ad76063          	bltu	a4,a3,800031fe <readi+0xd2>
  if(off + n > ip->size)
    80003162:	00e7f463          	bgeu	a5,a4,8000316a <readi+0x3e>
    n = ip->size - off;
    80003166:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000316a:	0a0b0963          	beqz	s6,8000321c <readi+0xf0>
    8000316e:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003170:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003174:	5cfd                	li	s9,-1
    80003176:	a82d                	j	800031b0 <readi+0x84>
    80003178:	020a1d93          	slli	s11,s4,0x20
    8000317c:	020ddd93          	srli	s11,s11,0x20
    80003180:	05890613          	addi	a2,s2,88
    80003184:	86ee                	mv	a3,s11
    80003186:	963a                	add	a2,a2,a4
    80003188:	85d6                	mv	a1,s5
    8000318a:	8562                	mv	a0,s8
    8000318c:	fffff097          	auipc	ra,0xfffff
    80003190:	918080e7          	jalr	-1768(ra) # 80001aa4 <either_copyout>
    80003194:	05950d63          	beq	a0,s9,800031ee <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003198:	854a                	mv	a0,s2
    8000319a:	fffff097          	auipc	ra,0xfffff
    8000319e:	60c080e7          	jalr	1548(ra) # 800027a6 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800031a2:	013a09bb          	addw	s3,s4,s3
    800031a6:	009a04bb          	addw	s1,s4,s1
    800031aa:	9aee                	add	s5,s5,s11
    800031ac:	0569f763          	bgeu	s3,s6,800031fa <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    800031b0:	000ba903          	lw	s2,0(s7)
    800031b4:	00a4d59b          	srliw	a1,s1,0xa
    800031b8:	855e                	mv	a0,s7
    800031ba:	00000097          	auipc	ra,0x0
    800031be:	8ac080e7          	jalr	-1876(ra) # 80002a66 <bmap>
    800031c2:	0005059b          	sext.w	a1,a0
    800031c6:	854a                	mv	a0,s2
    800031c8:	fffff097          	auipc	ra,0xfffff
    800031cc:	4ae080e7          	jalr	1198(ra) # 80002676 <bread>
    800031d0:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800031d2:	3ff4f713          	andi	a4,s1,1023
    800031d6:	40ed07bb          	subw	a5,s10,a4
    800031da:	413b06bb          	subw	a3,s6,s3
    800031de:	8a3e                	mv	s4,a5
    800031e0:	2781                	sext.w	a5,a5
    800031e2:	0006861b          	sext.w	a2,a3
    800031e6:	f8f679e3          	bgeu	a2,a5,80003178 <readi+0x4c>
    800031ea:	8a36                	mv	s4,a3
    800031ec:	b771                	j	80003178 <readi+0x4c>
      brelse(bp);
    800031ee:	854a                	mv	a0,s2
    800031f0:	fffff097          	auipc	ra,0xfffff
    800031f4:	5b6080e7          	jalr	1462(ra) # 800027a6 <brelse>
      tot = -1;
    800031f8:	59fd                	li	s3,-1
  }
  return tot;
    800031fa:	0009851b          	sext.w	a0,s3
}
    800031fe:	70a6                	ld	ra,104(sp)
    80003200:	7406                	ld	s0,96(sp)
    80003202:	64e6                	ld	s1,88(sp)
    80003204:	6946                	ld	s2,80(sp)
    80003206:	69a6                	ld	s3,72(sp)
    80003208:	6a06                	ld	s4,64(sp)
    8000320a:	7ae2                	ld	s5,56(sp)
    8000320c:	7b42                	ld	s6,48(sp)
    8000320e:	7ba2                	ld	s7,40(sp)
    80003210:	7c02                	ld	s8,32(sp)
    80003212:	6ce2                	ld	s9,24(sp)
    80003214:	6d42                	ld	s10,16(sp)
    80003216:	6da2                	ld	s11,8(sp)
    80003218:	6165                	addi	sp,sp,112
    8000321a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000321c:	89da                	mv	s3,s6
    8000321e:	bff1                	j	800031fa <readi+0xce>
    return 0;
    80003220:	4501                	li	a0,0
}
    80003222:	8082                	ret

0000000080003224 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003224:	457c                	lw	a5,76(a0)
    80003226:	10d7e863          	bltu	a5,a3,80003336 <writei+0x112>
{
    8000322a:	7159                	addi	sp,sp,-112
    8000322c:	f486                	sd	ra,104(sp)
    8000322e:	f0a2                	sd	s0,96(sp)
    80003230:	eca6                	sd	s1,88(sp)
    80003232:	e8ca                	sd	s2,80(sp)
    80003234:	e4ce                	sd	s3,72(sp)
    80003236:	e0d2                	sd	s4,64(sp)
    80003238:	fc56                	sd	s5,56(sp)
    8000323a:	f85a                	sd	s6,48(sp)
    8000323c:	f45e                	sd	s7,40(sp)
    8000323e:	f062                	sd	s8,32(sp)
    80003240:	ec66                	sd	s9,24(sp)
    80003242:	e86a                	sd	s10,16(sp)
    80003244:	e46e                	sd	s11,8(sp)
    80003246:	1880                	addi	s0,sp,112
    80003248:	8b2a                	mv	s6,a0
    8000324a:	8c2e                	mv	s8,a1
    8000324c:	8ab2                	mv	s5,a2
    8000324e:	8936                	mv	s2,a3
    80003250:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80003252:	00e687bb          	addw	a5,a3,a4
    80003256:	0ed7e263          	bltu	a5,a3,8000333a <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000325a:	00043737          	lui	a4,0x43
    8000325e:	0ef76063          	bltu	a4,a5,8000333e <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003262:	0c0b8863          	beqz	s7,80003332 <writei+0x10e>
    80003266:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003268:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000326c:	5cfd                	li	s9,-1
    8000326e:	a091                	j	800032b2 <writei+0x8e>
    80003270:	02099d93          	slli	s11,s3,0x20
    80003274:	020ddd93          	srli	s11,s11,0x20
    80003278:	05848513          	addi	a0,s1,88
    8000327c:	86ee                	mv	a3,s11
    8000327e:	8656                	mv	a2,s5
    80003280:	85e2                	mv	a1,s8
    80003282:	953a                	add	a0,a0,a4
    80003284:	fffff097          	auipc	ra,0xfffff
    80003288:	876080e7          	jalr	-1930(ra) # 80001afa <either_copyin>
    8000328c:	07950263          	beq	a0,s9,800032f0 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003290:	8526                	mv	a0,s1
    80003292:	00000097          	auipc	ra,0x0
    80003296:	798080e7          	jalr	1944(ra) # 80003a2a <log_write>
    brelse(bp);
    8000329a:	8526                	mv	a0,s1
    8000329c:	fffff097          	auipc	ra,0xfffff
    800032a0:	50a080e7          	jalr	1290(ra) # 800027a6 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800032a4:	01498a3b          	addw	s4,s3,s4
    800032a8:	0129893b          	addw	s2,s3,s2
    800032ac:	9aee                	add	s5,s5,s11
    800032ae:	057a7663          	bgeu	s4,s7,800032fa <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    800032b2:	000b2483          	lw	s1,0(s6)
    800032b6:	00a9559b          	srliw	a1,s2,0xa
    800032ba:	855a                	mv	a0,s6
    800032bc:	fffff097          	auipc	ra,0xfffff
    800032c0:	7aa080e7          	jalr	1962(ra) # 80002a66 <bmap>
    800032c4:	0005059b          	sext.w	a1,a0
    800032c8:	8526                	mv	a0,s1
    800032ca:	fffff097          	auipc	ra,0xfffff
    800032ce:	3ac080e7          	jalr	940(ra) # 80002676 <bread>
    800032d2:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800032d4:	3ff97713          	andi	a4,s2,1023
    800032d8:	40ed07bb          	subw	a5,s10,a4
    800032dc:	414b86bb          	subw	a3,s7,s4
    800032e0:	89be                	mv	s3,a5
    800032e2:	2781                	sext.w	a5,a5
    800032e4:	0006861b          	sext.w	a2,a3
    800032e8:	f8f674e3          	bgeu	a2,a5,80003270 <writei+0x4c>
    800032ec:	89b6                	mv	s3,a3
    800032ee:	b749                	j	80003270 <writei+0x4c>
      brelse(bp);
    800032f0:	8526                	mv	a0,s1
    800032f2:	fffff097          	auipc	ra,0xfffff
    800032f6:	4b4080e7          	jalr	1204(ra) # 800027a6 <brelse>
  }

  if(off > ip->size)
    800032fa:	04cb2783          	lw	a5,76(s6)
    800032fe:	0127f463          	bgeu	a5,s2,80003306 <writei+0xe2>
    ip->size = off;
    80003302:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003306:	855a                	mv	a0,s6
    80003308:	00000097          	auipc	ra,0x0
    8000330c:	aa4080e7          	jalr	-1372(ra) # 80002dac <iupdate>

  return tot;
    80003310:	000a051b          	sext.w	a0,s4
}
    80003314:	70a6                	ld	ra,104(sp)
    80003316:	7406                	ld	s0,96(sp)
    80003318:	64e6                	ld	s1,88(sp)
    8000331a:	6946                	ld	s2,80(sp)
    8000331c:	69a6                	ld	s3,72(sp)
    8000331e:	6a06                	ld	s4,64(sp)
    80003320:	7ae2                	ld	s5,56(sp)
    80003322:	7b42                	ld	s6,48(sp)
    80003324:	7ba2                	ld	s7,40(sp)
    80003326:	7c02                	ld	s8,32(sp)
    80003328:	6ce2                	ld	s9,24(sp)
    8000332a:	6d42                	ld	s10,16(sp)
    8000332c:	6da2                	ld	s11,8(sp)
    8000332e:	6165                	addi	sp,sp,112
    80003330:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003332:	8a5e                	mv	s4,s7
    80003334:	bfc9                	j	80003306 <writei+0xe2>
    return -1;
    80003336:	557d                	li	a0,-1
}
    80003338:	8082                	ret
    return -1;
    8000333a:	557d                	li	a0,-1
    8000333c:	bfe1                	j	80003314 <writei+0xf0>
    return -1;
    8000333e:	557d                	li	a0,-1
    80003340:	bfd1                	j	80003314 <writei+0xf0>

0000000080003342 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003342:	1141                	addi	sp,sp,-16
    80003344:	e406                	sd	ra,8(sp)
    80003346:	e022                	sd	s0,0(sp)
    80003348:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000334a:	4639                	li	a2,14
    8000334c:	ffffd097          	auipc	ra,0xffffd
    80003350:	f48080e7          	jalr	-184(ra) # 80000294 <strncmp>
}
    80003354:	60a2                	ld	ra,8(sp)
    80003356:	6402                	ld	s0,0(sp)
    80003358:	0141                	addi	sp,sp,16
    8000335a:	8082                	ret

000000008000335c <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000335c:	7139                	addi	sp,sp,-64
    8000335e:	fc06                	sd	ra,56(sp)
    80003360:	f822                	sd	s0,48(sp)
    80003362:	f426                	sd	s1,40(sp)
    80003364:	f04a                	sd	s2,32(sp)
    80003366:	ec4e                	sd	s3,24(sp)
    80003368:	e852                	sd	s4,16(sp)
    8000336a:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000336c:	04451703          	lh	a4,68(a0)
    80003370:	4785                	li	a5,1
    80003372:	00f71a63          	bne	a4,a5,80003386 <dirlookup+0x2a>
    80003376:	892a                	mv	s2,a0
    80003378:	89ae                	mv	s3,a1
    8000337a:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000337c:	457c                	lw	a5,76(a0)
    8000337e:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003380:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003382:	e79d                	bnez	a5,800033b0 <dirlookup+0x54>
    80003384:	a8a5                	j	800033fc <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003386:	00005517          	auipc	a0,0x5
    8000338a:	40250513          	addi	a0,a0,1026 # 80008788 <syscalls_name+0x1c8>
    8000338e:	00003097          	auipc	ra,0x3
    80003392:	b72080e7          	jalr	-1166(ra) # 80005f00 <panic>
      panic("dirlookup read");
    80003396:	00005517          	auipc	a0,0x5
    8000339a:	40a50513          	addi	a0,a0,1034 # 800087a0 <syscalls_name+0x1e0>
    8000339e:	00003097          	auipc	ra,0x3
    800033a2:	b62080e7          	jalr	-1182(ra) # 80005f00 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033a6:	24c1                	addiw	s1,s1,16
    800033a8:	04c92783          	lw	a5,76(s2)
    800033ac:	04f4f763          	bgeu	s1,a5,800033fa <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033b0:	4741                	li	a4,16
    800033b2:	86a6                	mv	a3,s1
    800033b4:	fc040613          	addi	a2,s0,-64
    800033b8:	4581                	li	a1,0
    800033ba:	854a                	mv	a0,s2
    800033bc:	00000097          	auipc	ra,0x0
    800033c0:	d70080e7          	jalr	-656(ra) # 8000312c <readi>
    800033c4:	47c1                	li	a5,16
    800033c6:	fcf518e3          	bne	a0,a5,80003396 <dirlookup+0x3a>
    if(de.inum == 0)
    800033ca:	fc045783          	lhu	a5,-64(s0)
    800033ce:	dfe1                	beqz	a5,800033a6 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800033d0:	fc240593          	addi	a1,s0,-62
    800033d4:	854e                	mv	a0,s3
    800033d6:	00000097          	auipc	ra,0x0
    800033da:	f6c080e7          	jalr	-148(ra) # 80003342 <namecmp>
    800033de:	f561                	bnez	a0,800033a6 <dirlookup+0x4a>
      if(poff)
    800033e0:	000a0463          	beqz	s4,800033e8 <dirlookup+0x8c>
        *poff = off;
    800033e4:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800033e8:	fc045583          	lhu	a1,-64(s0)
    800033ec:	00092503          	lw	a0,0(s2)
    800033f0:	fffff097          	auipc	ra,0xfffff
    800033f4:	752080e7          	jalr	1874(ra) # 80002b42 <iget>
    800033f8:	a011                	j	800033fc <dirlookup+0xa0>
  return 0;
    800033fa:	4501                	li	a0,0
}
    800033fc:	70e2                	ld	ra,56(sp)
    800033fe:	7442                	ld	s0,48(sp)
    80003400:	74a2                	ld	s1,40(sp)
    80003402:	7902                	ld	s2,32(sp)
    80003404:	69e2                	ld	s3,24(sp)
    80003406:	6a42                	ld	s4,16(sp)
    80003408:	6121                	addi	sp,sp,64
    8000340a:	8082                	ret

000000008000340c <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000340c:	711d                	addi	sp,sp,-96
    8000340e:	ec86                	sd	ra,88(sp)
    80003410:	e8a2                	sd	s0,80(sp)
    80003412:	e4a6                	sd	s1,72(sp)
    80003414:	e0ca                	sd	s2,64(sp)
    80003416:	fc4e                	sd	s3,56(sp)
    80003418:	f852                	sd	s4,48(sp)
    8000341a:	f456                	sd	s5,40(sp)
    8000341c:	f05a                	sd	s6,32(sp)
    8000341e:	ec5e                	sd	s7,24(sp)
    80003420:	e862                	sd	s8,16(sp)
    80003422:	e466                	sd	s9,8(sp)
    80003424:	e06a                	sd	s10,0(sp)
    80003426:	1080                	addi	s0,sp,96
    80003428:	84aa                	mv	s1,a0
    8000342a:	8b2e                	mv	s6,a1
    8000342c:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000342e:	00054703          	lbu	a4,0(a0)
    80003432:	02f00793          	li	a5,47
    80003436:	02f70363          	beq	a4,a5,8000345c <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000343a:	ffffe097          	auipc	ra,0xffffe
    8000343e:	b4c080e7          	jalr	-1204(ra) # 80000f86 <myproc>
    80003442:	15853503          	ld	a0,344(a0)
    80003446:	00000097          	auipc	ra,0x0
    8000344a:	9f4080e7          	jalr	-1548(ra) # 80002e3a <idup>
    8000344e:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003450:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003454:	4cb5                	li	s9,13
  len = path - s;
    80003456:	4b81                	li	s7,0

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003458:	4c05                	li	s8,1
    8000345a:	a87d                	j	80003518 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    8000345c:	4585                	li	a1,1
    8000345e:	4505                	li	a0,1
    80003460:	fffff097          	auipc	ra,0xfffff
    80003464:	6e2080e7          	jalr	1762(ra) # 80002b42 <iget>
    80003468:	8a2a                	mv	s4,a0
    8000346a:	b7dd                	j	80003450 <namex+0x44>
      iunlockput(ip);
    8000346c:	8552                	mv	a0,s4
    8000346e:	00000097          	auipc	ra,0x0
    80003472:	c6c080e7          	jalr	-916(ra) # 800030da <iunlockput>
      return 0;
    80003476:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003478:	8552                	mv	a0,s4
    8000347a:	60e6                	ld	ra,88(sp)
    8000347c:	6446                	ld	s0,80(sp)
    8000347e:	64a6                	ld	s1,72(sp)
    80003480:	6906                	ld	s2,64(sp)
    80003482:	79e2                	ld	s3,56(sp)
    80003484:	7a42                	ld	s4,48(sp)
    80003486:	7aa2                	ld	s5,40(sp)
    80003488:	7b02                	ld	s6,32(sp)
    8000348a:	6be2                	ld	s7,24(sp)
    8000348c:	6c42                	ld	s8,16(sp)
    8000348e:	6ca2                	ld	s9,8(sp)
    80003490:	6d02                	ld	s10,0(sp)
    80003492:	6125                	addi	sp,sp,96
    80003494:	8082                	ret
      iunlock(ip);
    80003496:	8552                	mv	a0,s4
    80003498:	00000097          	auipc	ra,0x0
    8000349c:	aa2080e7          	jalr	-1374(ra) # 80002f3a <iunlock>
      return ip;
    800034a0:	bfe1                	j	80003478 <namex+0x6c>
      iunlockput(ip);
    800034a2:	8552                	mv	a0,s4
    800034a4:	00000097          	auipc	ra,0x0
    800034a8:	c36080e7          	jalr	-970(ra) # 800030da <iunlockput>
      return 0;
    800034ac:	8a4e                	mv	s4,s3
    800034ae:	b7e9                	j	80003478 <namex+0x6c>
  len = path - s;
    800034b0:	40998633          	sub	a2,s3,s1
    800034b4:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    800034b8:	09acd863          	bge	s9,s10,80003548 <namex+0x13c>
    memmove(name, s, DIRSIZ);
    800034bc:	4639                	li	a2,14
    800034be:	85a6                	mv	a1,s1
    800034c0:	8556                	mv	a0,s5
    800034c2:	ffffd097          	auipc	ra,0xffffd
    800034c6:	d5e080e7          	jalr	-674(ra) # 80000220 <memmove>
    800034ca:	84ce                	mv	s1,s3
  while(*path == '/')
    800034cc:	0004c783          	lbu	a5,0(s1)
    800034d0:	01279763          	bne	a5,s2,800034de <namex+0xd2>
    path++;
    800034d4:	0485                	addi	s1,s1,1
  while(*path == '/')
    800034d6:	0004c783          	lbu	a5,0(s1)
    800034da:	ff278de3          	beq	a5,s2,800034d4 <namex+0xc8>
    ilock(ip);
    800034de:	8552                	mv	a0,s4
    800034e0:	00000097          	auipc	ra,0x0
    800034e4:	998080e7          	jalr	-1640(ra) # 80002e78 <ilock>
    if(ip->type != T_DIR){
    800034e8:	044a1783          	lh	a5,68(s4)
    800034ec:	f98790e3          	bne	a5,s8,8000346c <namex+0x60>
    if(nameiparent && *path == '\0'){
    800034f0:	000b0563          	beqz	s6,800034fa <namex+0xee>
    800034f4:	0004c783          	lbu	a5,0(s1)
    800034f8:	dfd9                	beqz	a5,80003496 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    800034fa:	865e                	mv	a2,s7
    800034fc:	85d6                	mv	a1,s5
    800034fe:	8552                	mv	a0,s4
    80003500:	00000097          	auipc	ra,0x0
    80003504:	e5c080e7          	jalr	-420(ra) # 8000335c <dirlookup>
    80003508:	89aa                	mv	s3,a0
    8000350a:	dd41                	beqz	a0,800034a2 <namex+0x96>
    iunlockput(ip);
    8000350c:	8552                	mv	a0,s4
    8000350e:	00000097          	auipc	ra,0x0
    80003512:	bcc080e7          	jalr	-1076(ra) # 800030da <iunlockput>
    ip = next;
    80003516:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003518:	0004c783          	lbu	a5,0(s1)
    8000351c:	01279763          	bne	a5,s2,8000352a <namex+0x11e>
    path++;
    80003520:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003522:	0004c783          	lbu	a5,0(s1)
    80003526:	ff278de3          	beq	a5,s2,80003520 <namex+0x114>
  if(*path == 0)
    8000352a:	cb9d                	beqz	a5,80003560 <namex+0x154>
  while(*path != '/' && *path != 0)
    8000352c:	0004c783          	lbu	a5,0(s1)
    80003530:	89a6                	mv	s3,s1
  len = path - s;
    80003532:	8d5e                	mv	s10,s7
    80003534:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003536:	01278963          	beq	a5,s2,80003548 <namex+0x13c>
    8000353a:	dbbd                	beqz	a5,800034b0 <namex+0xa4>
    path++;
    8000353c:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    8000353e:	0009c783          	lbu	a5,0(s3)
    80003542:	ff279ce3          	bne	a5,s2,8000353a <namex+0x12e>
    80003546:	b7ad                	j	800034b0 <namex+0xa4>
    memmove(name, s, len);
    80003548:	2601                	sext.w	a2,a2
    8000354a:	85a6                	mv	a1,s1
    8000354c:	8556                	mv	a0,s5
    8000354e:	ffffd097          	auipc	ra,0xffffd
    80003552:	cd2080e7          	jalr	-814(ra) # 80000220 <memmove>
    name[len] = 0;
    80003556:	9d56                	add	s10,s10,s5
    80003558:	000d0023          	sb	zero,0(s10)
    8000355c:	84ce                	mv	s1,s3
    8000355e:	b7bd                	j	800034cc <namex+0xc0>
  if(nameiparent){
    80003560:	f00b0ce3          	beqz	s6,80003478 <namex+0x6c>
    iput(ip);
    80003564:	8552                	mv	a0,s4
    80003566:	00000097          	auipc	ra,0x0
    8000356a:	acc080e7          	jalr	-1332(ra) # 80003032 <iput>
    return 0;
    8000356e:	4a01                	li	s4,0
    80003570:	b721                	j	80003478 <namex+0x6c>

0000000080003572 <dirlink>:
{
    80003572:	7139                	addi	sp,sp,-64
    80003574:	fc06                	sd	ra,56(sp)
    80003576:	f822                	sd	s0,48(sp)
    80003578:	f426                	sd	s1,40(sp)
    8000357a:	f04a                	sd	s2,32(sp)
    8000357c:	ec4e                	sd	s3,24(sp)
    8000357e:	e852                	sd	s4,16(sp)
    80003580:	0080                	addi	s0,sp,64
    80003582:	892a                	mv	s2,a0
    80003584:	8a2e                	mv	s4,a1
    80003586:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003588:	4601                	li	a2,0
    8000358a:	00000097          	auipc	ra,0x0
    8000358e:	dd2080e7          	jalr	-558(ra) # 8000335c <dirlookup>
    80003592:	e93d                	bnez	a0,80003608 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003594:	04c92483          	lw	s1,76(s2)
    80003598:	c49d                	beqz	s1,800035c6 <dirlink+0x54>
    8000359a:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000359c:	4741                	li	a4,16
    8000359e:	86a6                	mv	a3,s1
    800035a0:	fc040613          	addi	a2,s0,-64
    800035a4:	4581                	li	a1,0
    800035a6:	854a                	mv	a0,s2
    800035a8:	00000097          	auipc	ra,0x0
    800035ac:	b84080e7          	jalr	-1148(ra) # 8000312c <readi>
    800035b0:	47c1                	li	a5,16
    800035b2:	06f51163          	bne	a0,a5,80003614 <dirlink+0xa2>
    if(de.inum == 0)
    800035b6:	fc045783          	lhu	a5,-64(s0)
    800035ba:	c791                	beqz	a5,800035c6 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800035bc:	24c1                	addiw	s1,s1,16
    800035be:	04c92783          	lw	a5,76(s2)
    800035c2:	fcf4ede3          	bltu	s1,a5,8000359c <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800035c6:	4639                	li	a2,14
    800035c8:	85d2                	mv	a1,s4
    800035ca:	fc240513          	addi	a0,s0,-62
    800035ce:	ffffd097          	auipc	ra,0xffffd
    800035d2:	d02080e7          	jalr	-766(ra) # 800002d0 <strncpy>
  de.inum = inum;
    800035d6:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800035da:	4741                	li	a4,16
    800035dc:	86a6                	mv	a3,s1
    800035de:	fc040613          	addi	a2,s0,-64
    800035e2:	4581                	li	a1,0
    800035e4:	854a                	mv	a0,s2
    800035e6:	00000097          	auipc	ra,0x0
    800035ea:	c3e080e7          	jalr	-962(ra) # 80003224 <writei>
    800035ee:	872a                	mv	a4,a0
    800035f0:	47c1                	li	a5,16
  return 0;
    800035f2:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800035f4:	02f71863          	bne	a4,a5,80003624 <dirlink+0xb2>
}
    800035f8:	70e2                	ld	ra,56(sp)
    800035fa:	7442                	ld	s0,48(sp)
    800035fc:	74a2                	ld	s1,40(sp)
    800035fe:	7902                	ld	s2,32(sp)
    80003600:	69e2                	ld	s3,24(sp)
    80003602:	6a42                	ld	s4,16(sp)
    80003604:	6121                	addi	sp,sp,64
    80003606:	8082                	ret
    iput(ip);
    80003608:	00000097          	auipc	ra,0x0
    8000360c:	a2a080e7          	jalr	-1494(ra) # 80003032 <iput>
    return -1;
    80003610:	557d                	li	a0,-1
    80003612:	b7dd                	j	800035f8 <dirlink+0x86>
      panic("dirlink read");
    80003614:	00005517          	auipc	a0,0x5
    80003618:	19c50513          	addi	a0,a0,412 # 800087b0 <syscalls_name+0x1f0>
    8000361c:	00003097          	auipc	ra,0x3
    80003620:	8e4080e7          	jalr	-1820(ra) # 80005f00 <panic>
    panic("dirlink");
    80003624:	00005517          	auipc	a0,0x5
    80003628:	28c50513          	addi	a0,a0,652 # 800088b0 <syscalls_name+0x2f0>
    8000362c:	00003097          	auipc	ra,0x3
    80003630:	8d4080e7          	jalr	-1836(ra) # 80005f00 <panic>

0000000080003634 <namei>:

struct inode*
namei(char *path)
{
    80003634:	1101                	addi	sp,sp,-32
    80003636:	ec06                	sd	ra,24(sp)
    80003638:	e822                	sd	s0,16(sp)
    8000363a:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000363c:	fe040613          	addi	a2,s0,-32
    80003640:	4581                	li	a1,0
    80003642:	00000097          	auipc	ra,0x0
    80003646:	dca080e7          	jalr	-566(ra) # 8000340c <namex>
}
    8000364a:	60e2                	ld	ra,24(sp)
    8000364c:	6442                	ld	s0,16(sp)
    8000364e:	6105                	addi	sp,sp,32
    80003650:	8082                	ret

0000000080003652 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003652:	1141                	addi	sp,sp,-16
    80003654:	e406                	sd	ra,8(sp)
    80003656:	e022                	sd	s0,0(sp)
    80003658:	0800                	addi	s0,sp,16
    8000365a:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000365c:	4585                	li	a1,1
    8000365e:	00000097          	auipc	ra,0x0
    80003662:	dae080e7          	jalr	-594(ra) # 8000340c <namex>
}
    80003666:	60a2                	ld	ra,8(sp)
    80003668:	6402                	ld	s0,0(sp)
    8000366a:	0141                	addi	sp,sp,16
    8000366c:	8082                	ret

000000008000366e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000366e:	1101                	addi	sp,sp,-32
    80003670:	ec06                	sd	ra,24(sp)
    80003672:	e822                	sd	s0,16(sp)
    80003674:	e426                	sd	s1,8(sp)
    80003676:	e04a                	sd	s2,0(sp)
    80003678:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000367a:	00016917          	auipc	s2,0x16
    8000367e:	da690913          	addi	s2,s2,-602 # 80019420 <log>
    80003682:	01892583          	lw	a1,24(s2)
    80003686:	02892503          	lw	a0,40(s2)
    8000368a:	fffff097          	auipc	ra,0xfffff
    8000368e:	fec080e7          	jalr	-20(ra) # 80002676 <bread>
    80003692:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003694:	02c92683          	lw	a3,44(s2)
    80003698:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000369a:	02d05863          	blez	a3,800036ca <write_head+0x5c>
    8000369e:	00016797          	auipc	a5,0x16
    800036a2:	db278793          	addi	a5,a5,-590 # 80019450 <log+0x30>
    800036a6:	05c50713          	addi	a4,a0,92
    800036aa:	36fd                	addiw	a3,a3,-1
    800036ac:	02069613          	slli	a2,a3,0x20
    800036b0:	01e65693          	srli	a3,a2,0x1e
    800036b4:	00016617          	auipc	a2,0x16
    800036b8:	da060613          	addi	a2,a2,-608 # 80019454 <log+0x34>
    800036bc:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800036be:	4390                	lw	a2,0(a5)
    800036c0:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800036c2:	0791                	addi	a5,a5,4
    800036c4:	0711                	addi	a4,a4,4 # 43004 <_entry-0x7ffbcffc>
    800036c6:	fed79ce3          	bne	a5,a3,800036be <write_head+0x50>
  }
  bwrite(buf);
    800036ca:	8526                	mv	a0,s1
    800036cc:	fffff097          	auipc	ra,0xfffff
    800036d0:	09c080e7          	jalr	156(ra) # 80002768 <bwrite>
  brelse(buf);
    800036d4:	8526                	mv	a0,s1
    800036d6:	fffff097          	auipc	ra,0xfffff
    800036da:	0d0080e7          	jalr	208(ra) # 800027a6 <brelse>
}
    800036de:	60e2                	ld	ra,24(sp)
    800036e0:	6442                	ld	s0,16(sp)
    800036e2:	64a2                	ld	s1,8(sp)
    800036e4:	6902                	ld	s2,0(sp)
    800036e6:	6105                	addi	sp,sp,32
    800036e8:	8082                	ret

00000000800036ea <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800036ea:	00016797          	auipc	a5,0x16
    800036ee:	d627a783          	lw	a5,-670(a5) # 8001944c <log+0x2c>
    800036f2:	0af05d63          	blez	a5,800037ac <install_trans+0xc2>
{
    800036f6:	7139                	addi	sp,sp,-64
    800036f8:	fc06                	sd	ra,56(sp)
    800036fa:	f822                	sd	s0,48(sp)
    800036fc:	f426                	sd	s1,40(sp)
    800036fe:	f04a                	sd	s2,32(sp)
    80003700:	ec4e                	sd	s3,24(sp)
    80003702:	e852                	sd	s4,16(sp)
    80003704:	e456                	sd	s5,8(sp)
    80003706:	e05a                	sd	s6,0(sp)
    80003708:	0080                	addi	s0,sp,64
    8000370a:	8b2a                	mv	s6,a0
    8000370c:	00016a97          	auipc	s5,0x16
    80003710:	d44a8a93          	addi	s5,s5,-700 # 80019450 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003714:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003716:	00016997          	auipc	s3,0x16
    8000371a:	d0a98993          	addi	s3,s3,-758 # 80019420 <log>
    8000371e:	a00d                	j	80003740 <install_trans+0x56>
    brelse(lbuf);
    80003720:	854a                	mv	a0,s2
    80003722:	fffff097          	auipc	ra,0xfffff
    80003726:	084080e7          	jalr	132(ra) # 800027a6 <brelse>
    brelse(dbuf);
    8000372a:	8526                	mv	a0,s1
    8000372c:	fffff097          	auipc	ra,0xfffff
    80003730:	07a080e7          	jalr	122(ra) # 800027a6 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003734:	2a05                	addiw	s4,s4,1
    80003736:	0a91                	addi	s5,s5,4
    80003738:	02c9a783          	lw	a5,44(s3)
    8000373c:	04fa5e63          	bge	s4,a5,80003798 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003740:	0189a583          	lw	a1,24(s3)
    80003744:	014585bb          	addw	a1,a1,s4
    80003748:	2585                	addiw	a1,a1,1
    8000374a:	0289a503          	lw	a0,40(s3)
    8000374e:	fffff097          	auipc	ra,0xfffff
    80003752:	f28080e7          	jalr	-216(ra) # 80002676 <bread>
    80003756:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003758:	000aa583          	lw	a1,0(s5)
    8000375c:	0289a503          	lw	a0,40(s3)
    80003760:	fffff097          	auipc	ra,0xfffff
    80003764:	f16080e7          	jalr	-234(ra) # 80002676 <bread>
    80003768:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000376a:	40000613          	li	a2,1024
    8000376e:	05890593          	addi	a1,s2,88
    80003772:	05850513          	addi	a0,a0,88
    80003776:	ffffd097          	auipc	ra,0xffffd
    8000377a:	aaa080e7          	jalr	-1366(ra) # 80000220 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000377e:	8526                	mv	a0,s1
    80003780:	fffff097          	auipc	ra,0xfffff
    80003784:	fe8080e7          	jalr	-24(ra) # 80002768 <bwrite>
    if(recovering == 0)
    80003788:	f80b1ce3          	bnez	s6,80003720 <install_trans+0x36>
      bunpin(dbuf);
    8000378c:	8526                	mv	a0,s1
    8000378e:	fffff097          	auipc	ra,0xfffff
    80003792:	0f2080e7          	jalr	242(ra) # 80002880 <bunpin>
    80003796:	b769                	j	80003720 <install_trans+0x36>
}
    80003798:	70e2                	ld	ra,56(sp)
    8000379a:	7442                	ld	s0,48(sp)
    8000379c:	74a2                	ld	s1,40(sp)
    8000379e:	7902                	ld	s2,32(sp)
    800037a0:	69e2                	ld	s3,24(sp)
    800037a2:	6a42                	ld	s4,16(sp)
    800037a4:	6aa2                	ld	s5,8(sp)
    800037a6:	6b02                	ld	s6,0(sp)
    800037a8:	6121                	addi	sp,sp,64
    800037aa:	8082                	ret
    800037ac:	8082                	ret

00000000800037ae <initlog>:
{
    800037ae:	7179                	addi	sp,sp,-48
    800037b0:	f406                	sd	ra,40(sp)
    800037b2:	f022                	sd	s0,32(sp)
    800037b4:	ec26                	sd	s1,24(sp)
    800037b6:	e84a                	sd	s2,16(sp)
    800037b8:	e44e                	sd	s3,8(sp)
    800037ba:	1800                	addi	s0,sp,48
    800037bc:	892a                	mv	s2,a0
    800037be:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800037c0:	00016497          	auipc	s1,0x16
    800037c4:	c6048493          	addi	s1,s1,-928 # 80019420 <log>
    800037c8:	00005597          	auipc	a1,0x5
    800037cc:	ff858593          	addi	a1,a1,-8 # 800087c0 <syscalls_name+0x200>
    800037d0:	8526                	mv	a0,s1
    800037d2:	00003097          	auipc	ra,0x3
    800037d6:	bd6080e7          	jalr	-1066(ra) # 800063a8 <initlock>
  log.start = sb->logstart;
    800037da:	0149a583          	lw	a1,20(s3)
    800037de:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800037e0:	0109a783          	lw	a5,16(s3)
    800037e4:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800037e6:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800037ea:	854a                	mv	a0,s2
    800037ec:	fffff097          	auipc	ra,0xfffff
    800037f0:	e8a080e7          	jalr	-374(ra) # 80002676 <bread>
  log.lh.n = lh->n;
    800037f4:	4d34                	lw	a3,88(a0)
    800037f6:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800037f8:	02d05663          	blez	a3,80003824 <initlog+0x76>
    800037fc:	05c50793          	addi	a5,a0,92
    80003800:	00016717          	auipc	a4,0x16
    80003804:	c5070713          	addi	a4,a4,-944 # 80019450 <log+0x30>
    80003808:	36fd                	addiw	a3,a3,-1
    8000380a:	02069613          	slli	a2,a3,0x20
    8000380e:	01e65693          	srli	a3,a2,0x1e
    80003812:	06050613          	addi	a2,a0,96
    80003816:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    80003818:	4390                	lw	a2,0(a5)
    8000381a:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000381c:	0791                	addi	a5,a5,4
    8000381e:	0711                	addi	a4,a4,4
    80003820:	fed79ce3          	bne	a5,a3,80003818 <initlog+0x6a>
  brelse(buf);
    80003824:	fffff097          	auipc	ra,0xfffff
    80003828:	f82080e7          	jalr	-126(ra) # 800027a6 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000382c:	4505                	li	a0,1
    8000382e:	00000097          	auipc	ra,0x0
    80003832:	ebc080e7          	jalr	-324(ra) # 800036ea <install_trans>
  log.lh.n = 0;
    80003836:	00016797          	auipc	a5,0x16
    8000383a:	c007ab23          	sw	zero,-1002(a5) # 8001944c <log+0x2c>
  write_head(); // clear the log
    8000383e:	00000097          	auipc	ra,0x0
    80003842:	e30080e7          	jalr	-464(ra) # 8000366e <write_head>
}
    80003846:	70a2                	ld	ra,40(sp)
    80003848:	7402                	ld	s0,32(sp)
    8000384a:	64e2                	ld	s1,24(sp)
    8000384c:	6942                	ld	s2,16(sp)
    8000384e:	69a2                	ld	s3,8(sp)
    80003850:	6145                	addi	sp,sp,48
    80003852:	8082                	ret

0000000080003854 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003854:	1101                	addi	sp,sp,-32
    80003856:	ec06                	sd	ra,24(sp)
    80003858:	e822                	sd	s0,16(sp)
    8000385a:	e426                	sd	s1,8(sp)
    8000385c:	e04a                	sd	s2,0(sp)
    8000385e:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003860:	00016517          	auipc	a0,0x16
    80003864:	bc050513          	addi	a0,a0,-1088 # 80019420 <log>
    80003868:	00003097          	auipc	ra,0x3
    8000386c:	bd0080e7          	jalr	-1072(ra) # 80006438 <acquire>
  while(1){
    if(log.committing){
    80003870:	00016497          	auipc	s1,0x16
    80003874:	bb048493          	addi	s1,s1,-1104 # 80019420 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003878:	4979                	li	s2,30
    8000387a:	a039                	j	80003888 <begin_op+0x34>
      sleep(&log, &log.lock);
    8000387c:	85a6                	mv	a1,s1
    8000387e:	8526                	mv	a0,s1
    80003880:	ffffe097          	auipc	ra,0xffffe
    80003884:	e80080e7          	jalr	-384(ra) # 80001700 <sleep>
    if(log.committing){
    80003888:	50dc                	lw	a5,36(s1)
    8000388a:	fbed                	bnez	a5,8000387c <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000388c:	5098                	lw	a4,32(s1)
    8000388e:	2705                	addiw	a4,a4,1
    80003890:	0007069b          	sext.w	a3,a4
    80003894:	0027179b          	slliw	a5,a4,0x2
    80003898:	9fb9                	addw	a5,a5,a4
    8000389a:	0017979b          	slliw	a5,a5,0x1
    8000389e:	54d8                	lw	a4,44(s1)
    800038a0:	9fb9                	addw	a5,a5,a4
    800038a2:	00f95963          	bge	s2,a5,800038b4 <begin_op+0x60>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800038a6:	85a6                	mv	a1,s1
    800038a8:	8526                	mv	a0,s1
    800038aa:	ffffe097          	auipc	ra,0xffffe
    800038ae:	e56080e7          	jalr	-426(ra) # 80001700 <sleep>
    800038b2:	bfd9                	j	80003888 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800038b4:	00016517          	auipc	a0,0x16
    800038b8:	b6c50513          	addi	a0,a0,-1172 # 80019420 <log>
    800038bc:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800038be:	00003097          	auipc	ra,0x3
    800038c2:	c2e080e7          	jalr	-978(ra) # 800064ec <release>
      break;
    }
  }
}
    800038c6:	60e2                	ld	ra,24(sp)
    800038c8:	6442                	ld	s0,16(sp)
    800038ca:	64a2                	ld	s1,8(sp)
    800038cc:	6902                	ld	s2,0(sp)
    800038ce:	6105                	addi	sp,sp,32
    800038d0:	8082                	ret

00000000800038d2 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800038d2:	7139                	addi	sp,sp,-64
    800038d4:	fc06                	sd	ra,56(sp)
    800038d6:	f822                	sd	s0,48(sp)
    800038d8:	f426                	sd	s1,40(sp)
    800038da:	f04a                	sd	s2,32(sp)
    800038dc:	ec4e                	sd	s3,24(sp)
    800038de:	e852                	sd	s4,16(sp)
    800038e0:	e456                	sd	s5,8(sp)
    800038e2:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800038e4:	00016497          	auipc	s1,0x16
    800038e8:	b3c48493          	addi	s1,s1,-1220 # 80019420 <log>
    800038ec:	8526                	mv	a0,s1
    800038ee:	00003097          	auipc	ra,0x3
    800038f2:	b4a080e7          	jalr	-1206(ra) # 80006438 <acquire>
  log.outstanding -= 1;
    800038f6:	509c                	lw	a5,32(s1)
    800038f8:	37fd                	addiw	a5,a5,-1
    800038fa:	0007891b          	sext.w	s2,a5
    800038fe:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003900:	50dc                	lw	a5,36(s1)
    80003902:	e7b9                	bnez	a5,80003950 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003904:	04091e63          	bnez	s2,80003960 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80003908:	00016497          	auipc	s1,0x16
    8000390c:	b1848493          	addi	s1,s1,-1256 # 80019420 <log>
    80003910:	4785                	li	a5,1
    80003912:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003914:	8526                	mv	a0,s1
    80003916:	00003097          	auipc	ra,0x3
    8000391a:	bd6080e7          	jalr	-1066(ra) # 800064ec <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000391e:	54dc                	lw	a5,44(s1)
    80003920:	06f04763          	bgtz	a5,8000398e <end_op+0xbc>
    acquire(&log.lock);
    80003924:	00016497          	auipc	s1,0x16
    80003928:	afc48493          	addi	s1,s1,-1284 # 80019420 <log>
    8000392c:	8526                	mv	a0,s1
    8000392e:	00003097          	auipc	ra,0x3
    80003932:	b0a080e7          	jalr	-1270(ra) # 80006438 <acquire>
    log.committing = 0;
    80003936:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000393a:	8526                	mv	a0,s1
    8000393c:	ffffe097          	auipc	ra,0xffffe
    80003940:	f50080e7          	jalr	-176(ra) # 8000188c <wakeup>
    release(&log.lock);
    80003944:	8526                	mv	a0,s1
    80003946:	00003097          	auipc	ra,0x3
    8000394a:	ba6080e7          	jalr	-1114(ra) # 800064ec <release>
}
    8000394e:	a03d                	j	8000397c <end_op+0xaa>
    panic("log.committing");
    80003950:	00005517          	auipc	a0,0x5
    80003954:	e7850513          	addi	a0,a0,-392 # 800087c8 <syscalls_name+0x208>
    80003958:	00002097          	auipc	ra,0x2
    8000395c:	5a8080e7          	jalr	1448(ra) # 80005f00 <panic>
    wakeup(&log);
    80003960:	00016497          	auipc	s1,0x16
    80003964:	ac048493          	addi	s1,s1,-1344 # 80019420 <log>
    80003968:	8526                	mv	a0,s1
    8000396a:	ffffe097          	auipc	ra,0xffffe
    8000396e:	f22080e7          	jalr	-222(ra) # 8000188c <wakeup>
  release(&log.lock);
    80003972:	8526                	mv	a0,s1
    80003974:	00003097          	auipc	ra,0x3
    80003978:	b78080e7          	jalr	-1160(ra) # 800064ec <release>
}
    8000397c:	70e2                	ld	ra,56(sp)
    8000397e:	7442                	ld	s0,48(sp)
    80003980:	74a2                	ld	s1,40(sp)
    80003982:	7902                	ld	s2,32(sp)
    80003984:	69e2                	ld	s3,24(sp)
    80003986:	6a42                	ld	s4,16(sp)
    80003988:	6aa2                	ld	s5,8(sp)
    8000398a:	6121                	addi	sp,sp,64
    8000398c:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    8000398e:	00016a97          	auipc	s5,0x16
    80003992:	ac2a8a93          	addi	s5,s5,-1342 # 80019450 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003996:	00016a17          	auipc	s4,0x16
    8000399a:	a8aa0a13          	addi	s4,s4,-1398 # 80019420 <log>
    8000399e:	018a2583          	lw	a1,24(s4)
    800039a2:	012585bb          	addw	a1,a1,s2
    800039a6:	2585                	addiw	a1,a1,1
    800039a8:	028a2503          	lw	a0,40(s4)
    800039ac:	fffff097          	auipc	ra,0xfffff
    800039b0:	cca080e7          	jalr	-822(ra) # 80002676 <bread>
    800039b4:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800039b6:	000aa583          	lw	a1,0(s5)
    800039ba:	028a2503          	lw	a0,40(s4)
    800039be:	fffff097          	auipc	ra,0xfffff
    800039c2:	cb8080e7          	jalr	-840(ra) # 80002676 <bread>
    800039c6:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800039c8:	40000613          	li	a2,1024
    800039cc:	05850593          	addi	a1,a0,88
    800039d0:	05848513          	addi	a0,s1,88
    800039d4:	ffffd097          	auipc	ra,0xffffd
    800039d8:	84c080e7          	jalr	-1972(ra) # 80000220 <memmove>
    bwrite(to);  // write the log
    800039dc:	8526                	mv	a0,s1
    800039de:	fffff097          	auipc	ra,0xfffff
    800039e2:	d8a080e7          	jalr	-630(ra) # 80002768 <bwrite>
    brelse(from);
    800039e6:	854e                	mv	a0,s3
    800039e8:	fffff097          	auipc	ra,0xfffff
    800039ec:	dbe080e7          	jalr	-578(ra) # 800027a6 <brelse>
    brelse(to);
    800039f0:	8526                	mv	a0,s1
    800039f2:	fffff097          	auipc	ra,0xfffff
    800039f6:	db4080e7          	jalr	-588(ra) # 800027a6 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800039fa:	2905                	addiw	s2,s2,1
    800039fc:	0a91                	addi	s5,s5,4
    800039fe:	02ca2783          	lw	a5,44(s4)
    80003a02:	f8f94ee3          	blt	s2,a5,8000399e <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003a06:	00000097          	auipc	ra,0x0
    80003a0a:	c68080e7          	jalr	-920(ra) # 8000366e <write_head>
    install_trans(0); // Now install writes to home locations
    80003a0e:	4501                	li	a0,0
    80003a10:	00000097          	auipc	ra,0x0
    80003a14:	cda080e7          	jalr	-806(ra) # 800036ea <install_trans>
    log.lh.n = 0;
    80003a18:	00016797          	auipc	a5,0x16
    80003a1c:	a207aa23          	sw	zero,-1484(a5) # 8001944c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003a20:	00000097          	auipc	ra,0x0
    80003a24:	c4e080e7          	jalr	-946(ra) # 8000366e <write_head>
    80003a28:	bdf5                	j	80003924 <end_op+0x52>

0000000080003a2a <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003a2a:	1101                	addi	sp,sp,-32
    80003a2c:	ec06                	sd	ra,24(sp)
    80003a2e:	e822                	sd	s0,16(sp)
    80003a30:	e426                	sd	s1,8(sp)
    80003a32:	e04a                	sd	s2,0(sp)
    80003a34:	1000                	addi	s0,sp,32
    80003a36:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003a38:	00016917          	auipc	s2,0x16
    80003a3c:	9e890913          	addi	s2,s2,-1560 # 80019420 <log>
    80003a40:	854a                	mv	a0,s2
    80003a42:	00003097          	auipc	ra,0x3
    80003a46:	9f6080e7          	jalr	-1546(ra) # 80006438 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003a4a:	02c92603          	lw	a2,44(s2)
    80003a4e:	47f5                	li	a5,29
    80003a50:	06c7c563          	blt	a5,a2,80003aba <log_write+0x90>
    80003a54:	00016797          	auipc	a5,0x16
    80003a58:	9e87a783          	lw	a5,-1560(a5) # 8001943c <log+0x1c>
    80003a5c:	37fd                	addiw	a5,a5,-1
    80003a5e:	04f65e63          	bge	a2,a5,80003aba <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003a62:	00016797          	auipc	a5,0x16
    80003a66:	9de7a783          	lw	a5,-1570(a5) # 80019440 <log+0x20>
    80003a6a:	06f05063          	blez	a5,80003aca <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003a6e:	4781                	li	a5,0
    80003a70:	06c05563          	blez	a2,80003ada <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003a74:	44cc                	lw	a1,12(s1)
    80003a76:	00016717          	auipc	a4,0x16
    80003a7a:	9da70713          	addi	a4,a4,-1574 # 80019450 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003a7e:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003a80:	4314                	lw	a3,0(a4)
    80003a82:	04b68c63          	beq	a3,a1,80003ada <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003a86:	2785                	addiw	a5,a5,1
    80003a88:	0711                	addi	a4,a4,4
    80003a8a:	fef61be3          	bne	a2,a5,80003a80 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003a8e:	0621                	addi	a2,a2,8
    80003a90:	060a                	slli	a2,a2,0x2
    80003a92:	00016797          	auipc	a5,0x16
    80003a96:	98e78793          	addi	a5,a5,-1650 # 80019420 <log>
    80003a9a:	97b2                	add	a5,a5,a2
    80003a9c:	44d8                	lw	a4,12(s1)
    80003a9e:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003aa0:	8526                	mv	a0,s1
    80003aa2:	fffff097          	auipc	ra,0xfffff
    80003aa6:	da2080e7          	jalr	-606(ra) # 80002844 <bpin>
    log.lh.n++;
    80003aaa:	00016717          	auipc	a4,0x16
    80003aae:	97670713          	addi	a4,a4,-1674 # 80019420 <log>
    80003ab2:	575c                	lw	a5,44(a4)
    80003ab4:	2785                	addiw	a5,a5,1
    80003ab6:	d75c                	sw	a5,44(a4)
    80003ab8:	a82d                	j	80003af2 <log_write+0xc8>
    panic("too big a transaction");
    80003aba:	00005517          	auipc	a0,0x5
    80003abe:	d1e50513          	addi	a0,a0,-738 # 800087d8 <syscalls_name+0x218>
    80003ac2:	00002097          	auipc	ra,0x2
    80003ac6:	43e080e7          	jalr	1086(ra) # 80005f00 <panic>
    panic("log_write outside of trans");
    80003aca:	00005517          	auipc	a0,0x5
    80003ace:	d2650513          	addi	a0,a0,-730 # 800087f0 <syscalls_name+0x230>
    80003ad2:	00002097          	auipc	ra,0x2
    80003ad6:	42e080e7          	jalr	1070(ra) # 80005f00 <panic>
  log.lh.block[i] = b->blockno;
    80003ada:	00878693          	addi	a3,a5,8
    80003ade:	068a                	slli	a3,a3,0x2
    80003ae0:	00016717          	auipc	a4,0x16
    80003ae4:	94070713          	addi	a4,a4,-1728 # 80019420 <log>
    80003ae8:	9736                	add	a4,a4,a3
    80003aea:	44d4                	lw	a3,12(s1)
    80003aec:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003aee:	faf609e3          	beq	a2,a5,80003aa0 <log_write+0x76>
  }
  release(&log.lock);
    80003af2:	00016517          	auipc	a0,0x16
    80003af6:	92e50513          	addi	a0,a0,-1746 # 80019420 <log>
    80003afa:	00003097          	auipc	ra,0x3
    80003afe:	9f2080e7          	jalr	-1550(ra) # 800064ec <release>
}
    80003b02:	60e2                	ld	ra,24(sp)
    80003b04:	6442                	ld	s0,16(sp)
    80003b06:	64a2                	ld	s1,8(sp)
    80003b08:	6902                	ld	s2,0(sp)
    80003b0a:	6105                	addi	sp,sp,32
    80003b0c:	8082                	ret

0000000080003b0e <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003b0e:	1101                	addi	sp,sp,-32
    80003b10:	ec06                	sd	ra,24(sp)
    80003b12:	e822                	sd	s0,16(sp)
    80003b14:	e426                	sd	s1,8(sp)
    80003b16:	e04a                	sd	s2,0(sp)
    80003b18:	1000                	addi	s0,sp,32
    80003b1a:	84aa                	mv	s1,a0
    80003b1c:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003b1e:	00005597          	auipc	a1,0x5
    80003b22:	cf258593          	addi	a1,a1,-782 # 80008810 <syscalls_name+0x250>
    80003b26:	0521                	addi	a0,a0,8
    80003b28:	00003097          	auipc	ra,0x3
    80003b2c:	880080e7          	jalr	-1920(ra) # 800063a8 <initlock>
  lk->name = name;
    80003b30:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003b34:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003b38:	0204a423          	sw	zero,40(s1)
}
    80003b3c:	60e2                	ld	ra,24(sp)
    80003b3e:	6442                	ld	s0,16(sp)
    80003b40:	64a2                	ld	s1,8(sp)
    80003b42:	6902                	ld	s2,0(sp)
    80003b44:	6105                	addi	sp,sp,32
    80003b46:	8082                	ret

0000000080003b48 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003b48:	1101                	addi	sp,sp,-32
    80003b4a:	ec06                	sd	ra,24(sp)
    80003b4c:	e822                	sd	s0,16(sp)
    80003b4e:	e426                	sd	s1,8(sp)
    80003b50:	e04a                	sd	s2,0(sp)
    80003b52:	1000                	addi	s0,sp,32
    80003b54:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003b56:	00850913          	addi	s2,a0,8
    80003b5a:	854a                	mv	a0,s2
    80003b5c:	00003097          	auipc	ra,0x3
    80003b60:	8dc080e7          	jalr	-1828(ra) # 80006438 <acquire>
  while (lk->locked) {
    80003b64:	409c                	lw	a5,0(s1)
    80003b66:	cb89                	beqz	a5,80003b78 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003b68:	85ca                	mv	a1,s2
    80003b6a:	8526                	mv	a0,s1
    80003b6c:	ffffe097          	auipc	ra,0xffffe
    80003b70:	b94080e7          	jalr	-1132(ra) # 80001700 <sleep>
  while (lk->locked) {
    80003b74:	409c                	lw	a5,0(s1)
    80003b76:	fbed                	bnez	a5,80003b68 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003b78:	4785                	li	a5,1
    80003b7a:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003b7c:	ffffd097          	auipc	ra,0xffffd
    80003b80:	40a080e7          	jalr	1034(ra) # 80000f86 <myproc>
    80003b84:	591c                	lw	a5,48(a0)
    80003b86:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003b88:	854a                	mv	a0,s2
    80003b8a:	00003097          	auipc	ra,0x3
    80003b8e:	962080e7          	jalr	-1694(ra) # 800064ec <release>
}
    80003b92:	60e2                	ld	ra,24(sp)
    80003b94:	6442                	ld	s0,16(sp)
    80003b96:	64a2                	ld	s1,8(sp)
    80003b98:	6902                	ld	s2,0(sp)
    80003b9a:	6105                	addi	sp,sp,32
    80003b9c:	8082                	ret

0000000080003b9e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003b9e:	1101                	addi	sp,sp,-32
    80003ba0:	ec06                	sd	ra,24(sp)
    80003ba2:	e822                	sd	s0,16(sp)
    80003ba4:	e426                	sd	s1,8(sp)
    80003ba6:	e04a                	sd	s2,0(sp)
    80003ba8:	1000                	addi	s0,sp,32
    80003baa:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003bac:	00850913          	addi	s2,a0,8
    80003bb0:	854a                	mv	a0,s2
    80003bb2:	00003097          	auipc	ra,0x3
    80003bb6:	886080e7          	jalr	-1914(ra) # 80006438 <acquire>
  lk->locked = 0;
    80003bba:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003bbe:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003bc2:	8526                	mv	a0,s1
    80003bc4:	ffffe097          	auipc	ra,0xffffe
    80003bc8:	cc8080e7          	jalr	-824(ra) # 8000188c <wakeup>
  release(&lk->lk);
    80003bcc:	854a                	mv	a0,s2
    80003bce:	00003097          	auipc	ra,0x3
    80003bd2:	91e080e7          	jalr	-1762(ra) # 800064ec <release>
}
    80003bd6:	60e2                	ld	ra,24(sp)
    80003bd8:	6442                	ld	s0,16(sp)
    80003bda:	64a2                	ld	s1,8(sp)
    80003bdc:	6902                	ld	s2,0(sp)
    80003bde:	6105                	addi	sp,sp,32
    80003be0:	8082                	ret

0000000080003be2 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003be2:	7179                	addi	sp,sp,-48
    80003be4:	f406                	sd	ra,40(sp)
    80003be6:	f022                	sd	s0,32(sp)
    80003be8:	ec26                	sd	s1,24(sp)
    80003bea:	e84a                	sd	s2,16(sp)
    80003bec:	e44e                	sd	s3,8(sp)
    80003bee:	1800                	addi	s0,sp,48
    80003bf0:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003bf2:	00850913          	addi	s2,a0,8
    80003bf6:	854a                	mv	a0,s2
    80003bf8:	00003097          	auipc	ra,0x3
    80003bfc:	840080e7          	jalr	-1984(ra) # 80006438 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003c00:	409c                	lw	a5,0(s1)
    80003c02:	ef99                	bnez	a5,80003c20 <holdingsleep+0x3e>
    80003c04:	4481                	li	s1,0
  release(&lk->lk);
    80003c06:	854a                	mv	a0,s2
    80003c08:	00003097          	auipc	ra,0x3
    80003c0c:	8e4080e7          	jalr	-1820(ra) # 800064ec <release>
  return r;
}
    80003c10:	8526                	mv	a0,s1
    80003c12:	70a2                	ld	ra,40(sp)
    80003c14:	7402                	ld	s0,32(sp)
    80003c16:	64e2                	ld	s1,24(sp)
    80003c18:	6942                	ld	s2,16(sp)
    80003c1a:	69a2                	ld	s3,8(sp)
    80003c1c:	6145                	addi	sp,sp,48
    80003c1e:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003c20:	0284a983          	lw	s3,40(s1)
    80003c24:	ffffd097          	auipc	ra,0xffffd
    80003c28:	362080e7          	jalr	866(ra) # 80000f86 <myproc>
    80003c2c:	5904                	lw	s1,48(a0)
    80003c2e:	413484b3          	sub	s1,s1,s3
    80003c32:	0014b493          	seqz	s1,s1
    80003c36:	bfc1                	j	80003c06 <holdingsleep+0x24>

0000000080003c38 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003c38:	1141                	addi	sp,sp,-16
    80003c3a:	e406                	sd	ra,8(sp)
    80003c3c:	e022                	sd	s0,0(sp)
    80003c3e:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003c40:	00005597          	auipc	a1,0x5
    80003c44:	be058593          	addi	a1,a1,-1056 # 80008820 <syscalls_name+0x260>
    80003c48:	00016517          	auipc	a0,0x16
    80003c4c:	92050513          	addi	a0,a0,-1760 # 80019568 <ftable>
    80003c50:	00002097          	auipc	ra,0x2
    80003c54:	758080e7          	jalr	1880(ra) # 800063a8 <initlock>
}
    80003c58:	60a2                	ld	ra,8(sp)
    80003c5a:	6402                	ld	s0,0(sp)
    80003c5c:	0141                	addi	sp,sp,16
    80003c5e:	8082                	ret

0000000080003c60 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003c60:	1101                	addi	sp,sp,-32
    80003c62:	ec06                	sd	ra,24(sp)
    80003c64:	e822                	sd	s0,16(sp)
    80003c66:	e426                	sd	s1,8(sp)
    80003c68:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003c6a:	00016517          	auipc	a0,0x16
    80003c6e:	8fe50513          	addi	a0,a0,-1794 # 80019568 <ftable>
    80003c72:	00002097          	auipc	ra,0x2
    80003c76:	7c6080e7          	jalr	1990(ra) # 80006438 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003c7a:	00016497          	auipc	s1,0x16
    80003c7e:	90648493          	addi	s1,s1,-1786 # 80019580 <ftable+0x18>
    80003c82:	00017717          	auipc	a4,0x17
    80003c86:	89e70713          	addi	a4,a4,-1890 # 8001a520 <ftable+0xfb8>
    if(f->ref == 0){
    80003c8a:	40dc                	lw	a5,4(s1)
    80003c8c:	cf99                	beqz	a5,80003caa <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003c8e:	02848493          	addi	s1,s1,40
    80003c92:	fee49ce3          	bne	s1,a4,80003c8a <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003c96:	00016517          	auipc	a0,0x16
    80003c9a:	8d250513          	addi	a0,a0,-1838 # 80019568 <ftable>
    80003c9e:	00003097          	auipc	ra,0x3
    80003ca2:	84e080e7          	jalr	-1970(ra) # 800064ec <release>
  return 0;
    80003ca6:	4481                	li	s1,0
    80003ca8:	a819                	j	80003cbe <filealloc+0x5e>
      f->ref = 1;
    80003caa:	4785                	li	a5,1
    80003cac:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003cae:	00016517          	auipc	a0,0x16
    80003cb2:	8ba50513          	addi	a0,a0,-1862 # 80019568 <ftable>
    80003cb6:	00003097          	auipc	ra,0x3
    80003cba:	836080e7          	jalr	-1994(ra) # 800064ec <release>
}
    80003cbe:	8526                	mv	a0,s1
    80003cc0:	60e2                	ld	ra,24(sp)
    80003cc2:	6442                	ld	s0,16(sp)
    80003cc4:	64a2                	ld	s1,8(sp)
    80003cc6:	6105                	addi	sp,sp,32
    80003cc8:	8082                	ret

0000000080003cca <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003cca:	1101                	addi	sp,sp,-32
    80003ccc:	ec06                	sd	ra,24(sp)
    80003cce:	e822                	sd	s0,16(sp)
    80003cd0:	e426                	sd	s1,8(sp)
    80003cd2:	1000                	addi	s0,sp,32
    80003cd4:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003cd6:	00016517          	auipc	a0,0x16
    80003cda:	89250513          	addi	a0,a0,-1902 # 80019568 <ftable>
    80003cde:	00002097          	auipc	ra,0x2
    80003ce2:	75a080e7          	jalr	1882(ra) # 80006438 <acquire>
  if(f->ref < 1)
    80003ce6:	40dc                	lw	a5,4(s1)
    80003ce8:	02f05263          	blez	a5,80003d0c <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003cec:	2785                	addiw	a5,a5,1
    80003cee:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003cf0:	00016517          	auipc	a0,0x16
    80003cf4:	87850513          	addi	a0,a0,-1928 # 80019568 <ftable>
    80003cf8:	00002097          	auipc	ra,0x2
    80003cfc:	7f4080e7          	jalr	2036(ra) # 800064ec <release>
  return f;
}
    80003d00:	8526                	mv	a0,s1
    80003d02:	60e2                	ld	ra,24(sp)
    80003d04:	6442                	ld	s0,16(sp)
    80003d06:	64a2                	ld	s1,8(sp)
    80003d08:	6105                	addi	sp,sp,32
    80003d0a:	8082                	ret
    panic("filedup");
    80003d0c:	00005517          	auipc	a0,0x5
    80003d10:	b1c50513          	addi	a0,a0,-1252 # 80008828 <syscalls_name+0x268>
    80003d14:	00002097          	auipc	ra,0x2
    80003d18:	1ec080e7          	jalr	492(ra) # 80005f00 <panic>

0000000080003d1c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003d1c:	7139                	addi	sp,sp,-64
    80003d1e:	fc06                	sd	ra,56(sp)
    80003d20:	f822                	sd	s0,48(sp)
    80003d22:	f426                	sd	s1,40(sp)
    80003d24:	f04a                	sd	s2,32(sp)
    80003d26:	ec4e                	sd	s3,24(sp)
    80003d28:	e852                	sd	s4,16(sp)
    80003d2a:	e456                	sd	s5,8(sp)
    80003d2c:	0080                	addi	s0,sp,64
    80003d2e:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003d30:	00016517          	auipc	a0,0x16
    80003d34:	83850513          	addi	a0,a0,-1992 # 80019568 <ftable>
    80003d38:	00002097          	auipc	ra,0x2
    80003d3c:	700080e7          	jalr	1792(ra) # 80006438 <acquire>
  if(f->ref < 1)
    80003d40:	40dc                	lw	a5,4(s1)
    80003d42:	06f05163          	blez	a5,80003da4 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003d46:	37fd                	addiw	a5,a5,-1
    80003d48:	0007871b          	sext.w	a4,a5
    80003d4c:	c0dc                	sw	a5,4(s1)
    80003d4e:	06e04363          	bgtz	a4,80003db4 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003d52:	0004a903          	lw	s2,0(s1)
    80003d56:	0094ca83          	lbu	s5,9(s1)
    80003d5a:	0104ba03          	ld	s4,16(s1)
    80003d5e:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003d62:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003d66:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003d6a:	00015517          	auipc	a0,0x15
    80003d6e:	7fe50513          	addi	a0,a0,2046 # 80019568 <ftable>
    80003d72:	00002097          	auipc	ra,0x2
    80003d76:	77a080e7          	jalr	1914(ra) # 800064ec <release>

  if(ff.type == FD_PIPE){
    80003d7a:	4785                	li	a5,1
    80003d7c:	04f90d63          	beq	s2,a5,80003dd6 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003d80:	3979                	addiw	s2,s2,-2
    80003d82:	4785                	li	a5,1
    80003d84:	0527e063          	bltu	a5,s2,80003dc4 <fileclose+0xa8>
    begin_op();
    80003d88:	00000097          	auipc	ra,0x0
    80003d8c:	acc080e7          	jalr	-1332(ra) # 80003854 <begin_op>
    iput(ff.ip);
    80003d90:	854e                	mv	a0,s3
    80003d92:	fffff097          	auipc	ra,0xfffff
    80003d96:	2a0080e7          	jalr	672(ra) # 80003032 <iput>
    end_op();
    80003d9a:	00000097          	auipc	ra,0x0
    80003d9e:	b38080e7          	jalr	-1224(ra) # 800038d2 <end_op>
    80003da2:	a00d                	j	80003dc4 <fileclose+0xa8>
    panic("fileclose");
    80003da4:	00005517          	auipc	a0,0x5
    80003da8:	a8c50513          	addi	a0,a0,-1396 # 80008830 <syscalls_name+0x270>
    80003dac:	00002097          	auipc	ra,0x2
    80003db0:	154080e7          	jalr	340(ra) # 80005f00 <panic>
    release(&ftable.lock);
    80003db4:	00015517          	auipc	a0,0x15
    80003db8:	7b450513          	addi	a0,a0,1972 # 80019568 <ftable>
    80003dbc:	00002097          	auipc	ra,0x2
    80003dc0:	730080e7          	jalr	1840(ra) # 800064ec <release>
  }
}
    80003dc4:	70e2                	ld	ra,56(sp)
    80003dc6:	7442                	ld	s0,48(sp)
    80003dc8:	74a2                	ld	s1,40(sp)
    80003dca:	7902                	ld	s2,32(sp)
    80003dcc:	69e2                	ld	s3,24(sp)
    80003dce:	6a42                	ld	s4,16(sp)
    80003dd0:	6aa2                	ld	s5,8(sp)
    80003dd2:	6121                	addi	sp,sp,64
    80003dd4:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003dd6:	85d6                	mv	a1,s5
    80003dd8:	8552                	mv	a0,s4
    80003dda:	00000097          	auipc	ra,0x0
    80003dde:	34c080e7          	jalr	844(ra) # 80004126 <pipeclose>
    80003de2:	b7cd                	j	80003dc4 <fileclose+0xa8>

0000000080003de4 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003de4:	715d                	addi	sp,sp,-80
    80003de6:	e486                	sd	ra,72(sp)
    80003de8:	e0a2                	sd	s0,64(sp)
    80003dea:	fc26                	sd	s1,56(sp)
    80003dec:	f84a                	sd	s2,48(sp)
    80003dee:	f44e                	sd	s3,40(sp)
    80003df0:	0880                	addi	s0,sp,80
    80003df2:	84aa                	mv	s1,a0
    80003df4:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003df6:	ffffd097          	auipc	ra,0xffffd
    80003dfa:	190080e7          	jalr	400(ra) # 80000f86 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003dfe:	409c                	lw	a5,0(s1)
    80003e00:	37f9                	addiw	a5,a5,-2
    80003e02:	4705                	li	a4,1
    80003e04:	04f76763          	bltu	a4,a5,80003e52 <filestat+0x6e>
    80003e08:	892a                	mv	s2,a0
    ilock(f->ip);
    80003e0a:	6c88                	ld	a0,24(s1)
    80003e0c:	fffff097          	auipc	ra,0xfffff
    80003e10:	06c080e7          	jalr	108(ra) # 80002e78 <ilock>
    stati(f->ip, &st);
    80003e14:	fb840593          	addi	a1,s0,-72
    80003e18:	6c88                	ld	a0,24(s1)
    80003e1a:	fffff097          	auipc	ra,0xfffff
    80003e1e:	2e8080e7          	jalr	744(ra) # 80003102 <stati>
    iunlock(f->ip);
    80003e22:	6c88                	ld	a0,24(s1)
    80003e24:	fffff097          	auipc	ra,0xfffff
    80003e28:	116080e7          	jalr	278(ra) # 80002f3a <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003e2c:	46e1                	li	a3,24
    80003e2e:	fb840613          	addi	a2,s0,-72
    80003e32:	85ce                	mv	a1,s3
    80003e34:	05093503          	ld	a0,80(s2)
    80003e38:	ffffd097          	auipc	ra,0xffffd
    80003e3c:	d1a080e7          	jalr	-742(ra) # 80000b52 <copyout>
    80003e40:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003e44:	60a6                	ld	ra,72(sp)
    80003e46:	6406                	ld	s0,64(sp)
    80003e48:	74e2                	ld	s1,56(sp)
    80003e4a:	7942                	ld	s2,48(sp)
    80003e4c:	79a2                	ld	s3,40(sp)
    80003e4e:	6161                	addi	sp,sp,80
    80003e50:	8082                	ret
  return -1;
    80003e52:	557d                	li	a0,-1
    80003e54:	bfc5                	j	80003e44 <filestat+0x60>

0000000080003e56 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003e56:	7179                	addi	sp,sp,-48
    80003e58:	f406                	sd	ra,40(sp)
    80003e5a:	f022                	sd	s0,32(sp)
    80003e5c:	ec26                	sd	s1,24(sp)
    80003e5e:	e84a                	sd	s2,16(sp)
    80003e60:	e44e                	sd	s3,8(sp)
    80003e62:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003e64:	00854783          	lbu	a5,8(a0)
    80003e68:	c3d5                	beqz	a5,80003f0c <fileread+0xb6>
    80003e6a:	84aa                	mv	s1,a0
    80003e6c:	89ae                	mv	s3,a1
    80003e6e:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003e70:	411c                	lw	a5,0(a0)
    80003e72:	4705                	li	a4,1
    80003e74:	04e78963          	beq	a5,a4,80003ec6 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003e78:	470d                	li	a4,3
    80003e7a:	04e78d63          	beq	a5,a4,80003ed4 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003e7e:	4709                	li	a4,2
    80003e80:	06e79e63          	bne	a5,a4,80003efc <fileread+0xa6>
    ilock(f->ip);
    80003e84:	6d08                	ld	a0,24(a0)
    80003e86:	fffff097          	auipc	ra,0xfffff
    80003e8a:	ff2080e7          	jalr	-14(ra) # 80002e78 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003e8e:	874a                	mv	a4,s2
    80003e90:	5094                	lw	a3,32(s1)
    80003e92:	864e                	mv	a2,s3
    80003e94:	4585                	li	a1,1
    80003e96:	6c88                	ld	a0,24(s1)
    80003e98:	fffff097          	auipc	ra,0xfffff
    80003e9c:	294080e7          	jalr	660(ra) # 8000312c <readi>
    80003ea0:	892a                	mv	s2,a0
    80003ea2:	00a05563          	blez	a0,80003eac <fileread+0x56>
      f->off += r;
    80003ea6:	509c                	lw	a5,32(s1)
    80003ea8:	9fa9                	addw	a5,a5,a0
    80003eaa:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003eac:	6c88                	ld	a0,24(s1)
    80003eae:	fffff097          	auipc	ra,0xfffff
    80003eb2:	08c080e7          	jalr	140(ra) # 80002f3a <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003eb6:	854a                	mv	a0,s2
    80003eb8:	70a2                	ld	ra,40(sp)
    80003eba:	7402                	ld	s0,32(sp)
    80003ebc:	64e2                	ld	s1,24(sp)
    80003ebe:	6942                	ld	s2,16(sp)
    80003ec0:	69a2                	ld	s3,8(sp)
    80003ec2:	6145                	addi	sp,sp,48
    80003ec4:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003ec6:	6908                	ld	a0,16(a0)
    80003ec8:	00000097          	auipc	ra,0x0
    80003ecc:	3c0080e7          	jalr	960(ra) # 80004288 <piperead>
    80003ed0:	892a                	mv	s2,a0
    80003ed2:	b7d5                	j	80003eb6 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003ed4:	02451783          	lh	a5,36(a0)
    80003ed8:	03079693          	slli	a3,a5,0x30
    80003edc:	92c1                	srli	a3,a3,0x30
    80003ede:	4725                	li	a4,9
    80003ee0:	02d76863          	bltu	a4,a3,80003f10 <fileread+0xba>
    80003ee4:	0792                	slli	a5,a5,0x4
    80003ee6:	00015717          	auipc	a4,0x15
    80003eea:	5e270713          	addi	a4,a4,1506 # 800194c8 <devsw>
    80003eee:	97ba                	add	a5,a5,a4
    80003ef0:	639c                	ld	a5,0(a5)
    80003ef2:	c38d                	beqz	a5,80003f14 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003ef4:	4505                	li	a0,1
    80003ef6:	9782                	jalr	a5
    80003ef8:	892a                	mv	s2,a0
    80003efa:	bf75                	j	80003eb6 <fileread+0x60>
    panic("fileread");
    80003efc:	00005517          	auipc	a0,0x5
    80003f00:	94450513          	addi	a0,a0,-1724 # 80008840 <syscalls_name+0x280>
    80003f04:	00002097          	auipc	ra,0x2
    80003f08:	ffc080e7          	jalr	-4(ra) # 80005f00 <panic>
    return -1;
    80003f0c:	597d                	li	s2,-1
    80003f0e:	b765                	j	80003eb6 <fileread+0x60>
      return -1;
    80003f10:	597d                	li	s2,-1
    80003f12:	b755                	j	80003eb6 <fileread+0x60>
    80003f14:	597d                	li	s2,-1
    80003f16:	b745                	j	80003eb6 <fileread+0x60>

0000000080003f18 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003f18:	715d                	addi	sp,sp,-80
    80003f1a:	e486                	sd	ra,72(sp)
    80003f1c:	e0a2                	sd	s0,64(sp)
    80003f1e:	fc26                	sd	s1,56(sp)
    80003f20:	f84a                	sd	s2,48(sp)
    80003f22:	f44e                	sd	s3,40(sp)
    80003f24:	f052                	sd	s4,32(sp)
    80003f26:	ec56                	sd	s5,24(sp)
    80003f28:	e85a                	sd	s6,16(sp)
    80003f2a:	e45e                	sd	s7,8(sp)
    80003f2c:	e062                	sd	s8,0(sp)
    80003f2e:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003f30:	00954783          	lbu	a5,9(a0)
    80003f34:	10078663          	beqz	a5,80004040 <filewrite+0x128>
    80003f38:	892a                	mv	s2,a0
    80003f3a:	8b2e                	mv	s6,a1
    80003f3c:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003f3e:	411c                	lw	a5,0(a0)
    80003f40:	4705                	li	a4,1
    80003f42:	02e78263          	beq	a5,a4,80003f66 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003f46:	470d                	li	a4,3
    80003f48:	02e78663          	beq	a5,a4,80003f74 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003f4c:	4709                	li	a4,2
    80003f4e:	0ee79163          	bne	a5,a4,80004030 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003f52:	0ac05d63          	blez	a2,8000400c <filewrite+0xf4>
    int i = 0;
    80003f56:	4981                	li	s3,0
    80003f58:	6b85                	lui	s7,0x1
    80003f5a:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003f5e:	6c05                	lui	s8,0x1
    80003f60:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003f64:	a861                	j	80003ffc <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003f66:	6908                	ld	a0,16(a0)
    80003f68:	00000097          	auipc	ra,0x0
    80003f6c:	22e080e7          	jalr	558(ra) # 80004196 <pipewrite>
    80003f70:	8a2a                	mv	s4,a0
    80003f72:	a045                	j	80004012 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003f74:	02451783          	lh	a5,36(a0)
    80003f78:	03079693          	slli	a3,a5,0x30
    80003f7c:	92c1                	srli	a3,a3,0x30
    80003f7e:	4725                	li	a4,9
    80003f80:	0cd76263          	bltu	a4,a3,80004044 <filewrite+0x12c>
    80003f84:	0792                	slli	a5,a5,0x4
    80003f86:	00015717          	auipc	a4,0x15
    80003f8a:	54270713          	addi	a4,a4,1346 # 800194c8 <devsw>
    80003f8e:	97ba                	add	a5,a5,a4
    80003f90:	679c                	ld	a5,8(a5)
    80003f92:	cbdd                	beqz	a5,80004048 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003f94:	4505                	li	a0,1
    80003f96:	9782                	jalr	a5
    80003f98:	8a2a                	mv	s4,a0
    80003f9a:	a8a5                	j	80004012 <filewrite+0xfa>
    80003f9c:	00048a9b          	sext.w	s5,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003fa0:	00000097          	auipc	ra,0x0
    80003fa4:	8b4080e7          	jalr	-1868(ra) # 80003854 <begin_op>
      ilock(f->ip);
    80003fa8:	01893503          	ld	a0,24(s2)
    80003fac:	fffff097          	auipc	ra,0xfffff
    80003fb0:	ecc080e7          	jalr	-308(ra) # 80002e78 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003fb4:	8756                	mv	a4,s5
    80003fb6:	02092683          	lw	a3,32(s2)
    80003fba:	01698633          	add	a2,s3,s6
    80003fbe:	4585                	li	a1,1
    80003fc0:	01893503          	ld	a0,24(s2)
    80003fc4:	fffff097          	auipc	ra,0xfffff
    80003fc8:	260080e7          	jalr	608(ra) # 80003224 <writei>
    80003fcc:	84aa                	mv	s1,a0
    80003fce:	00a05763          	blez	a0,80003fdc <filewrite+0xc4>
        f->off += r;
    80003fd2:	02092783          	lw	a5,32(s2)
    80003fd6:	9fa9                	addw	a5,a5,a0
    80003fd8:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003fdc:	01893503          	ld	a0,24(s2)
    80003fe0:	fffff097          	auipc	ra,0xfffff
    80003fe4:	f5a080e7          	jalr	-166(ra) # 80002f3a <iunlock>
      end_op();
    80003fe8:	00000097          	auipc	ra,0x0
    80003fec:	8ea080e7          	jalr	-1814(ra) # 800038d2 <end_op>

      if(r != n1){
    80003ff0:	009a9f63          	bne	s5,s1,8000400e <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003ff4:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003ff8:	0149db63          	bge	s3,s4,8000400e <filewrite+0xf6>
      int n1 = n - i;
    80003ffc:	413a04bb          	subw	s1,s4,s3
    80004000:	0004879b          	sext.w	a5,s1
    80004004:	f8fbdce3          	bge	s7,a5,80003f9c <filewrite+0x84>
    80004008:	84e2                	mv	s1,s8
    8000400a:	bf49                	j	80003f9c <filewrite+0x84>
    int i = 0;
    8000400c:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    8000400e:	013a1f63          	bne	s4,s3,8000402c <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004012:	8552                	mv	a0,s4
    80004014:	60a6                	ld	ra,72(sp)
    80004016:	6406                	ld	s0,64(sp)
    80004018:	74e2                	ld	s1,56(sp)
    8000401a:	7942                	ld	s2,48(sp)
    8000401c:	79a2                	ld	s3,40(sp)
    8000401e:	7a02                	ld	s4,32(sp)
    80004020:	6ae2                	ld	s5,24(sp)
    80004022:	6b42                	ld	s6,16(sp)
    80004024:	6ba2                	ld	s7,8(sp)
    80004026:	6c02                	ld	s8,0(sp)
    80004028:	6161                	addi	sp,sp,80
    8000402a:	8082                	ret
    ret = (i == n ? n : -1);
    8000402c:	5a7d                	li	s4,-1
    8000402e:	b7d5                	j	80004012 <filewrite+0xfa>
    panic("filewrite");
    80004030:	00005517          	auipc	a0,0x5
    80004034:	82050513          	addi	a0,a0,-2016 # 80008850 <syscalls_name+0x290>
    80004038:	00002097          	auipc	ra,0x2
    8000403c:	ec8080e7          	jalr	-312(ra) # 80005f00 <panic>
    return -1;
    80004040:	5a7d                	li	s4,-1
    80004042:	bfc1                	j	80004012 <filewrite+0xfa>
      return -1;
    80004044:	5a7d                	li	s4,-1
    80004046:	b7f1                	j	80004012 <filewrite+0xfa>
    80004048:	5a7d                	li	s4,-1
    8000404a:	b7e1                	j	80004012 <filewrite+0xfa>

000000008000404c <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000404c:	7179                	addi	sp,sp,-48
    8000404e:	f406                	sd	ra,40(sp)
    80004050:	f022                	sd	s0,32(sp)
    80004052:	ec26                	sd	s1,24(sp)
    80004054:	e84a                	sd	s2,16(sp)
    80004056:	e44e                	sd	s3,8(sp)
    80004058:	e052                	sd	s4,0(sp)
    8000405a:	1800                	addi	s0,sp,48
    8000405c:	84aa                	mv	s1,a0
    8000405e:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004060:	0005b023          	sd	zero,0(a1)
    80004064:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004068:	00000097          	auipc	ra,0x0
    8000406c:	bf8080e7          	jalr	-1032(ra) # 80003c60 <filealloc>
    80004070:	e088                	sd	a0,0(s1)
    80004072:	c551                	beqz	a0,800040fe <pipealloc+0xb2>
    80004074:	00000097          	auipc	ra,0x0
    80004078:	bec080e7          	jalr	-1044(ra) # 80003c60 <filealloc>
    8000407c:	00aa3023          	sd	a0,0(s4)
    80004080:	c92d                	beqz	a0,800040f2 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004082:	ffffc097          	auipc	ra,0xffffc
    80004086:	098080e7          	jalr	152(ra) # 8000011a <kalloc>
    8000408a:	892a                	mv	s2,a0
    8000408c:	c125                	beqz	a0,800040ec <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    8000408e:	4985                	li	s3,1
    80004090:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004094:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004098:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    8000409c:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800040a0:	00004597          	auipc	a1,0x4
    800040a4:	37858593          	addi	a1,a1,888 # 80008418 <states.0+0x1a0>
    800040a8:	00002097          	auipc	ra,0x2
    800040ac:	300080e7          	jalr	768(ra) # 800063a8 <initlock>
  (*f0)->type = FD_PIPE;
    800040b0:	609c                	ld	a5,0(s1)
    800040b2:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800040b6:	609c                	ld	a5,0(s1)
    800040b8:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800040bc:	609c                	ld	a5,0(s1)
    800040be:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800040c2:	609c                	ld	a5,0(s1)
    800040c4:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800040c8:	000a3783          	ld	a5,0(s4)
    800040cc:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800040d0:	000a3783          	ld	a5,0(s4)
    800040d4:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800040d8:	000a3783          	ld	a5,0(s4)
    800040dc:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800040e0:	000a3783          	ld	a5,0(s4)
    800040e4:	0127b823          	sd	s2,16(a5)
  return 0;
    800040e8:	4501                	li	a0,0
    800040ea:	a025                	j	80004112 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800040ec:	6088                	ld	a0,0(s1)
    800040ee:	e501                	bnez	a0,800040f6 <pipealloc+0xaa>
    800040f0:	a039                	j	800040fe <pipealloc+0xb2>
    800040f2:	6088                	ld	a0,0(s1)
    800040f4:	c51d                	beqz	a0,80004122 <pipealloc+0xd6>
    fileclose(*f0);
    800040f6:	00000097          	auipc	ra,0x0
    800040fa:	c26080e7          	jalr	-986(ra) # 80003d1c <fileclose>
  if(*f1)
    800040fe:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004102:	557d                	li	a0,-1
  if(*f1)
    80004104:	c799                	beqz	a5,80004112 <pipealloc+0xc6>
    fileclose(*f1);
    80004106:	853e                	mv	a0,a5
    80004108:	00000097          	auipc	ra,0x0
    8000410c:	c14080e7          	jalr	-1004(ra) # 80003d1c <fileclose>
  return -1;
    80004110:	557d                	li	a0,-1
}
    80004112:	70a2                	ld	ra,40(sp)
    80004114:	7402                	ld	s0,32(sp)
    80004116:	64e2                	ld	s1,24(sp)
    80004118:	6942                	ld	s2,16(sp)
    8000411a:	69a2                	ld	s3,8(sp)
    8000411c:	6a02                	ld	s4,0(sp)
    8000411e:	6145                	addi	sp,sp,48
    80004120:	8082                	ret
  return -1;
    80004122:	557d                	li	a0,-1
    80004124:	b7fd                	j	80004112 <pipealloc+0xc6>

0000000080004126 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004126:	1101                	addi	sp,sp,-32
    80004128:	ec06                	sd	ra,24(sp)
    8000412a:	e822                	sd	s0,16(sp)
    8000412c:	e426                	sd	s1,8(sp)
    8000412e:	e04a                	sd	s2,0(sp)
    80004130:	1000                	addi	s0,sp,32
    80004132:	84aa                	mv	s1,a0
    80004134:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004136:	00002097          	auipc	ra,0x2
    8000413a:	302080e7          	jalr	770(ra) # 80006438 <acquire>
  if(writable){
    8000413e:	02090d63          	beqz	s2,80004178 <pipeclose+0x52>
    pi->writeopen = 0;
    80004142:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004146:	21848513          	addi	a0,s1,536
    8000414a:	ffffd097          	auipc	ra,0xffffd
    8000414e:	742080e7          	jalr	1858(ra) # 8000188c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004152:	2204b783          	ld	a5,544(s1)
    80004156:	eb95                	bnez	a5,8000418a <pipeclose+0x64>
    release(&pi->lock);
    80004158:	8526                	mv	a0,s1
    8000415a:	00002097          	auipc	ra,0x2
    8000415e:	392080e7          	jalr	914(ra) # 800064ec <release>
    kfree((char*)pi);
    80004162:	8526                	mv	a0,s1
    80004164:	ffffc097          	auipc	ra,0xffffc
    80004168:	eb8080e7          	jalr	-328(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    8000416c:	60e2                	ld	ra,24(sp)
    8000416e:	6442                	ld	s0,16(sp)
    80004170:	64a2                	ld	s1,8(sp)
    80004172:	6902                	ld	s2,0(sp)
    80004174:	6105                	addi	sp,sp,32
    80004176:	8082                	ret
    pi->readopen = 0;
    80004178:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000417c:	21c48513          	addi	a0,s1,540
    80004180:	ffffd097          	auipc	ra,0xffffd
    80004184:	70c080e7          	jalr	1804(ra) # 8000188c <wakeup>
    80004188:	b7e9                	j	80004152 <pipeclose+0x2c>
    release(&pi->lock);
    8000418a:	8526                	mv	a0,s1
    8000418c:	00002097          	auipc	ra,0x2
    80004190:	360080e7          	jalr	864(ra) # 800064ec <release>
}
    80004194:	bfe1                	j	8000416c <pipeclose+0x46>

0000000080004196 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004196:	711d                	addi	sp,sp,-96
    80004198:	ec86                	sd	ra,88(sp)
    8000419a:	e8a2                	sd	s0,80(sp)
    8000419c:	e4a6                	sd	s1,72(sp)
    8000419e:	e0ca                	sd	s2,64(sp)
    800041a0:	fc4e                	sd	s3,56(sp)
    800041a2:	f852                	sd	s4,48(sp)
    800041a4:	f456                	sd	s5,40(sp)
    800041a6:	f05a                	sd	s6,32(sp)
    800041a8:	ec5e                	sd	s7,24(sp)
    800041aa:	e862                	sd	s8,16(sp)
    800041ac:	1080                	addi	s0,sp,96
    800041ae:	84aa                	mv	s1,a0
    800041b0:	8aae                	mv	s5,a1
    800041b2:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800041b4:	ffffd097          	auipc	ra,0xffffd
    800041b8:	dd2080e7          	jalr	-558(ra) # 80000f86 <myproc>
    800041bc:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800041be:	8526                	mv	a0,s1
    800041c0:	00002097          	auipc	ra,0x2
    800041c4:	278080e7          	jalr	632(ra) # 80006438 <acquire>
  while(i < n){
    800041c8:	0b405363          	blez	s4,8000426e <pipewrite+0xd8>
  int i = 0;
    800041cc:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800041ce:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800041d0:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800041d4:	21c48b93          	addi	s7,s1,540
    800041d8:	a089                	j	8000421a <pipewrite+0x84>
      release(&pi->lock);
    800041da:	8526                	mv	a0,s1
    800041dc:	00002097          	auipc	ra,0x2
    800041e0:	310080e7          	jalr	784(ra) # 800064ec <release>
      return -1;
    800041e4:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800041e6:	854a                	mv	a0,s2
    800041e8:	60e6                	ld	ra,88(sp)
    800041ea:	6446                	ld	s0,80(sp)
    800041ec:	64a6                	ld	s1,72(sp)
    800041ee:	6906                	ld	s2,64(sp)
    800041f0:	79e2                	ld	s3,56(sp)
    800041f2:	7a42                	ld	s4,48(sp)
    800041f4:	7aa2                	ld	s5,40(sp)
    800041f6:	7b02                	ld	s6,32(sp)
    800041f8:	6be2                	ld	s7,24(sp)
    800041fa:	6c42                	ld	s8,16(sp)
    800041fc:	6125                	addi	sp,sp,96
    800041fe:	8082                	ret
      wakeup(&pi->nread);
    80004200:	8562                	mv	a0,s8
    80004202:	ffffd097          	auipc	ra,0xffffd
    80004206:	68a080e7          	jalr	1674(ra) # 8000188c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000420a:	85a6                	mv	a1,s1
    8000420c:	855e                	mv	a0,s7
    8000420e:	ffffd097          	auipc	ra,0xffffd
    80004212:	4f2080e7          	jalr	1266(ra) # 80001700 <sleep>
  while(i < n){
    80004216:	05495d63          	bge	s2,s4,80004270 <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    8000421a:	2204a783          	lw	a5,544(s1)
    8000421e:	dfd5                	beqz	a5,800041da <pipewrite+0x44>
    80004220:	0289a783          	lw	a5,40(s3)
    80004224:	fbdd                	bnez	a5,800041da <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004226:	2184a783          	lw	a5,536(s1)
    8000422a:	21c4a703          	lw	a4,540(s1)
    8000422e:	2007879b          	addiw	a5,a5,512
    80004232:	fcf707e3          	beq	a4,a5,80004200 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004236:	4685                	li	a3,1
    80004238:	01590633          	add	a2,s2,s5
    8000423c:	faf40593          	addi	a1,s0,-81
    80004240:	0509b503          	ld	a0,80(s3)
    80004244:	ffffd097          	auipc	ra,0xffffd
    80004248:	99a080e7          	jalr	-1638(ra) # 80000bde <copyin>
    8000424c:	03650263          	beq	a0,s6,80004270 <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004250:	21c4a783          	lw	a5,540(s1)
    80004254:	0017871b          	addiw	a4,a5,1
    80004258:	20e4ae23          	sw	a4,540(s1)
    8000425c:	1ff7f793          	andi	a5,a5,511
    80004260:	97a6                	add	a5,a5,s1
    80004262:	faf44703          	lbu	a4,-81(s0)
    80004266:	00e78c23          	sb	a4,24(a5)
      i++;
    8000426a:	2905                	addiw	s2,s2,1
    8000426c:	b76d                	j	80004216 <pipewrite+0x80>
  int i = 0;
    8000426e:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004270:	21848513          	addi	a0,s1,536
    80004274:	ffffd097          	auipc	ra,0xffffd
    80004278:	618080e7          	jalr	1560(ra) # 8000188c <wakeup>
  release(&pi->lock);
    8000427c:	8526                	mv	a0,s1
    8000427e:	00002097          	auipc	ra,0x2
    80004282:	26e080e7          	jalr	622(ra) # 800064ec <release>
  return i;
    80004286:	b785                	j	800041e6 <pipewrite+0x50>

0000000080004288 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004288:	715d                	addi	sp,sp,-80
    8000428a:	e486                	sd	ra,72(sp)
    8000428c:	e0a2                	sd	s0,64(sp)
    8000428e:	fc26                	sd	s1,56(sp)
    80004290:	f84a                	sd	s2,48(sp)
    80004292:	f44e                	sd	s3,40(sp)
    80004294:	f052                	sd	s4,32(sp)
    80004296:	ec56                	sd	s5,24(sp)
    80004298:	e85a                	sd	s6,16(sp)
    8000429a:	0880                	addi	s0,sp,80
    8000429c:	84aa                	mv	s1,a0
    8000429e:	892e                	mv	s2,a1
    800042a0:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800042a2:	ffffd097          	auipc	ra,0xffffd
    800042a6:	ce4080e7          	jalr	-796(ra) # 80000f86 <myproc>
    800042aa:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800042ac:	8526                	mv	a0,s1
    800042ae:	00002097          	auipc	ra,0x2
    800042b2:	18a080e7          	jalr	394(ra) # 80006438 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800042b6:	2184a703          	lw	a4,536(s1)
    800042ba:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800042be:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800042c2:	02f71463          	bne	a4,a5,800042ea <piperead+0x62>
    800042c6:	2244a783          	lw	a5,548(s1)
    800042ca:	c385                	beqz	a5,800042ea <piperead+0x62>
    if(pr->killed){
    800042cc:	028a2783          	lw	a5,40(s4)
    800042d0:	ebc9                	bnez	a5,80004362 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800042d2:	85a6                	mv	a1,s1
    800042d4:	854e                	mv	a0,s3
    800042d6:	ffffd097          	auipc	ra,0xffffd
    800042da:	42a080e7          	jalr	1066(ra) # 80001700 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800042de:	2184a703          	lw	a4,536(s1)
    800042e2:	21c4a783          	lw	a5,540(s1)
    800042e6:	fef700e3          	beq	a4,a5,800042c6 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800042ea:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800042ec:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800042ee:	05505463          	blez	s5,80004336 <piperead+0xae>
    if(pi->nread == pi->nwrite)
    800042f2:	2184a783          	lw	a5,536(s1)
    800042f6:	21c4a703          	lw	a4,540(s1)
    800042fa:	02f70e63          	beq	a4,a5,80004336 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800042fe:	0017871b          	addiw	a4,a5,1
    80004302:	20e4ac23          	sw	a4,536(s1)
    80004306:	1ff7f793          	andi	a5,a5,511
    8000430a:	97a6                	add	a5,a5,s1
    8000430c:	0187c783          	lbu	a5,24(a5)
    80004310:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004314:	4685                	li	a3,1
    80004316:	fbf40613          	addi	a2,s0,-65
    8000431a:	85ca                	mv	a1,s2
    8000431c:	050a3503          	ld	a0,80(s4)
    80004320:	ffffd097          	auipc	ra,0xffffd
    80004324:	832080e7          	jalr	-1998(ra) # 80000b52 <copyout>
    80004328:	01650763          	beq	a0,s6,80004336 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000432c:	2985                	addiw	s3,s3,1
    8000432e:	0905                	addi	s2,s2,1
    80004330:	fd3a91e3          	bne	s5,s3,800042f2 <piperead+0x6a>
    80004334:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004336:	21c48513          	addi	a0,s1,540
    8000433a:	ffffd097          	auipc	ra,0xffffd
    8000433e:	552080e7          	jalr	1362(ra) # 8000188c <wakeup>
  release(&pi->lock);
    80004342:	8526                	mv	a0,s1
    80004344:	00002097          	auipc	ra,0x2
    80004348:	1a8080e7          	jalr	424(ra) # 800064ec <release>
  return i;
}
    8000434c:	854e                	mv	a0,s3
    8000434e:	60a6                	ld	ra,72(sp)
    80004350:	6406                	ld	s0,64(sp)
    80004352:	74e2                	ld	s1,56(sp)
    80004354:	7942                	ld	s2,48(sp)
    80004356:	79a2                	ld	s3,40(sp)
    80004358:	7a02                	ld	s4,32(sp)
    8000435a:	6ae2                	ld	s5,24(sp)
    8000435c:	6b42                	ld	s6,16(sp)
    8000435e:	6161                	addi	sp,sp,80
    80004360:	8082                	ret
      release(&pi->lock);
    80004362:	8526                	mv	a0,s1
    80004364:	00002097          	auipc	ra,0x2
    80004368:	188080e7          	jalr	392(ra) # 800064ec <release>
      return -1;
    8000436c:	59fd                	li	s3,-1
    8000436e:	bff9                	j	8000434c <piperead+0xc4>

0000000080004370 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004370:	de010113          	addi	sp,sp,-544
    80004374:	20113c23          	sd	ra,536(sp)
    80004378:	20813823          	sd	s0,528(sp)
    8000437c:	20913423          	sd	s1,520(sp)
    80004380:	21213023          	sd	s2,512(sp)
    80004384:	ffce                	sd	s3,504(sp)
    80004386:	fbd2                	sd	s4,496(sp)
    80004388:	f7d6                	sd	s5,488(sp)
    8000438a:	f3da                	sd	s6,480(sp)
    8000438c:	efde                	sd	s7,472(sp)
    8000438e:	ebe2                	sd	s8,464(sp)
    80004390:	e7e6                	sd	s9,456(sp)
    80004392:	e3ea                	sd	s10,448(sp)
    80004394:	ff6e                	sd	s11,440(sp)
    80004396:	1400                	addi	s0,sp,544
    80004398:	892a                	mv	s2,a0
    8000439a:	dea43423          	sd	a0,-536(s0)
    8000439e:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800043a2:	ffffd097          	auipc	ra,0xffffd
    800043a6:	be4080e7          	jalr	-1052(ra) # 80000f86 <myproc>
    800043aa:	84aa                	mv	s1,a0

  begin_op();
    800043ac:	fffff097          	auipc	ra,0xfffff
    800043b0:	4a8080e7          	jalr	1192(ra) # 80003854 <begin_op>

  if((ip = namei(path)) == 0){
    800043b4:	854a                	mv	a0,s2
    800043b6:	fffff097          	auipc	ra,0xfffff
    800043ba:	27e080e7          	jalr	638(ra) # 80003634 <namei>
    800043be:	c93d                	beqz	a0,80004434 <exec+0xc4>
    800043c0:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800043c2:	fffff097          	auipc	ra,0xfffff
    800043c6:	ab6080e7          	jalr	-1354(ra) # 80002e78 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800043ca:	04000713          	li	a4,64
    800043ce:	4681                	li	a3,0
    800043d0:	e5040613          	addi	a2,s0,-432
    800043d4:	4581                	li	a1,0
    800043d6:	8556                	mv	a0,s5
    800043d8:	fffff097          	auipc	ra,0xfffff
    800043dc:	d54080e7          	jalr	-684(ra) # 8000312c <readi>
    800043e0:	04000793          	li	a5,64
    800043e4:	00f51a63          	bne	a0,a5,800043f8 <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    800043e8:	e5042703          	lw	a4,-432(s0)
    800043ec:	464c47b7          	lui	a5,0x464c4
    800043f0:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800043f4:	04f70663          	beq	a4,a5,80004440 <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800043f8:	8556                	mv	a0,s5
    800043fa:	fffff097          	auipc	ra,0xfffff
    800043fe:	ce0080e7          	jalr	-800(ra) # 800030da <iunlockput>
    end_op();
    80004402:	fffff097          	auipc	ra,0xfffff
    80004406:	4d0080e7          	jalr	1232(ra) # 800038d2 <end_op>
  }
  return -1;
    8000440a:	557d                	li	a0,-1
}
    8000440c:	21813083          	ld	ra,536(sp)
    80004410:	21013403          	ld	s0,528(sp)
    80004414:	20813483          	ld	s1,520(sp)
    80004418:	20013903          	ld	s2,512(sp)
    8000441c:	79fe                	ld	s3,504(sp)
    8000441e:	7a5e                	ld	s4,496(sp)
    80004420:	7abe                	ld	s5,488(sp)
    80004422:	7b1e                	ld	s6,480(sp)
    80004424:	6bfe                	ld	s7,472(sp)
    80004426:	6c5e                	ld	s8,464(sp)
    80004428:	6cbe                	ld	s9,456(sp)
    8000442a:	6d1e                	ld	s10,448(sp)
    8000442c:	7dfa                	ld	s11,440(sp)
    8000442e:	22010113          	addi	sp,sp,544
    80004432:	8082                	ret
    end_op();
    80004434:	fffff097          	auipc	ra,0xfffff
    80004438:	49e080e7          	jalr	1182(ra) # 800038d2 <end_op>
    return -1;
    8000443c:	557d                	li	a0,-1
    8000443e:	b7f9                	j	8000440c <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004440:	8526                	mv	a0,s1
    80004442:	ffffd097          	auipc	ra,0xffffd
    80004446:	c08080e7          	jalr	-1016(ra) # 8000104a <proc_pagetable>
    8000444a:	8b2a                	mv	s6,a0
    8000444c:	d555                	beqz	a0,800043f8 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000444e:	e7042783          	lw	a5,-400(s0)
    80004452:	e8845703          	lhu	a4,-376(s0)
    80004456:	c735                	beqz	a4,800044c2 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004458:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000445a:	e0043423          	sd	zero,-504(s0)
    if((ph.vaddr % PGSIZE) != 0)
    8000445e:	6a05                	lui	s4,0x1
    80004460:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80004464:	dee43023          	sd	a4,-544(s0)
loadseg(pagetable_t pagetable, uint64 va, struct inode *ip, uint offset, uint sz)
{
  uint i, n;
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    80004468:	6d85                	lui	s11,0x1
    8000446a:	7d7d                	lui	s10,0xfffff
    8000446c:	a4b9                	j	800046ba <exec+0x34a>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    8000446e:	00004517          	auipc	a0,0x4
    80004472:	3f250513          	addi	a0,a0,1010 # 80008860 <syscalls_name+0x2a0>
    80004476:	00002097          	auipc	ra,0x2
    8000447a:	a8a080e7          	jalr	-1398(ra) # 80005f00 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000447e:	874a                	mv	a4,s2
    80004480:	009c86bb          	addw	a3,s9,s1
    80004484:	4581                	li	a1,0
    80004486:	8556                	mv	a0,s5
    80004488:	fffff097          	auipc	ra,0xfffff
    8000448c:	ca4080e7          	jalr	-860(ra) # 8000312c <readi>
    80004490:	2501                	sext.w	a0,a0
    80004492:	1ca91463          	bne	s2,a0,8000465a <exec+0x2ea>
  for(i = 0; i < sz; i += PGSIZE){
    80004496:	009d84bb          	addw	s1,s11,s1
    8000449a:	013d09bb          	addw	s3,s10,s3
    8000449e:	1f74fe63          	bgeu	s1,s7,8000469a <exec+0x32a>
    pa = walkaddr(pagetable, va + i);
    800044a2:	02049593          	slli	a1,s1,0x20
    800044a6:	9181                	srli	a1,a1,0x20
    800044a8:	95e2                	add	a1,a1,s8
    800044aa:	855a                	mv	a0,s6
    800044ac:	ffffc097          	auipc	ra,0xffffc
    800044b0:	09e080e7          	jalr	158(ra) # 8000054a <walkaddr>
    800044b4:	862a                	mv	a2,a0
    if(pa == 0)
    800044b6:	dd45                	beqz	a0,8000446e <exec+0xfe>
      n = PGSIZE;
    800044b8:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    800044ba:	fd49f2e3          	bgeu	s3,s4,8000447e <exec+0x10e>
      n = sz - i;
    800044be:	894e                	mv	s2,s3
    800044c0:	bf7d                	j	8000447e <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800044c2:	4481                	li	s1,0
  iunlockput(ip);
    800044c4:	8556                	mv	a0,s5
    800044c6:	fffff097          	auipc	ra,0xfffff
    800044ca:	c14080e7          	jalr	-1004(ra) # 800030da <iunlockput>
  end_op();
    800044ce:	fffff097          	auipc	ra,0xfffff
    800044d2:	404080e7          	jalr	1028(ra) # 800038d2 <end_op>
  p = myproc();
    800044d6:	ffffd097          	auipc	ra,0xffffd
    800044da:	ab0080e7          	jalr	-1360(ra) # 80000f86 <myproc>
    800044de:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    800044e0:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800044e4:	6785                	lui	a5,0x1
    800044e6:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800044e8:	97a6                	add	a5,a5,s1
    800044ea:	777d                	lui	a4,0xfffff
    800044ec:	8ff9                	and	a5,a5,a4
    800044ee:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800044f2:	6609                	lui	a2,0x2
    800044f4:	963e                	add	a2,a2,a5
    800044f6:	85be                	mv	a1,a5
    800044f8:	855a                	mv	a0,s6
    800044fa:	ffffc097          	auipc	ra,0xffffc
    800044fe:	404080e7          	jalr	1028(ra) # 800008fe <uvmalloc>
    80004502:	8c2a                	mv	s8,a0
  ip = 0;
    80004504:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004506:	14050a63          	beqz	a0,8000465a <exec+0x2ea>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000450a:	75f9                	lui	a1,0xffffe
    8000450c:	95aa                	add	a1,a1,a0
    8000450e:	855a                	mv	a0,s6
    80004510:	ffffc097          	auipc	ra,0xffffc
    80004514:	610080e7          	jalr	1552(ra) # 80000b20 <uvmclear>
  stackbase = sp - PGSIZE;
    80004518:	7afd                	lui	s5,0xfffff
    8000451a:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    8000451c:	df043783          	ld	a5,-528(s0)
    80004520:	6388                	ld	a0,0(a5)
    80004522:	c925                	beqz	a0,80004592 <exec+0x222>
    80004524:	e9040993          	addi	s3,s0,-368
    80004528:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    8000452c:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    8000452e:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004530:	ffffc097          	auipc	ra,0xffffc
    80004534:	e10080e7          	jalr	-496(ra) # 80000340 <strlen>
    80004538:	0015079b          	addiw	a5,a0,1
    8000453c:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004540:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004544:	13596f63          	bltu	s2,s5,80004682 <exec+0x312>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004548:	df043d83          	ld	s11,-528(s0)
    8000454c:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80004550:	8552                	mv	a0,s4
    80004552:	ffffc097          	auipc	ra,0xffffc
    80004556:	dee080e7          	jalr	-530(ra) # 80000340 <strlen>
    8000455a:	0015069b          	addiw	a3,a0,1
    8000455e:	8652                	mv	a2,s4
    80004560:	85ca                	mv	a1,s2
    80004562:	855a                	mv	a0,s6
    80004564:	ffffc097          	auipc	ra,0xffffc
    80004568:	5ee080e7          	jalr	1518(ra) # 80000b52 <copyout>
    8000456c:	10054f63          	bltz	a0,8000468a <exec+0x31a>
    ustack[argc] = sp;
    80004570:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004574:	0485                	addi	s1,s1,1
    80004576:	008d8793          	addi	a5,s11,8
    8000457a:	def43823          	sd	a5,-528(s0)
    8000457e:	008db503          	ld	a0,8(s11)
    80004582:	c911                	beqz	a0,80004596 <exec+0x226>
    if(argc >= MAXARG)
    80004584:	09a1                	addi	s3,s3,8
    80004586:	fb3c95e3          	bne	s9,s3,80004530 <exec+0x1c0>
  sz = sz1;
    8000458a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000458e:	4a81                	li	s5,0
    80004590:	a0e9                	j	8000465a <exec+0x2ea>
  sp = sz;
    80004592:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004594:	4481                	li	s1,0
  ustack[argc] = 0;
    80004596:	00349793          	slli	a5,s1,0x3
    8000459a:	f9078793          	addi	a5,a5,-112
    8000459e:	97a2                	add	a5,a5,s0
    800045a0:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800045a4:	00148693          	addi	a3,s1,1
    800045a8:	068e                	slli	a3,a3,0x3
    800045aa:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800045ae:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800045b2:	01597663          	bgeu	s2,s5,800045be <exec+0x24e>
  sz = sz1;
    800045b6:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    800045ba:	4a81                	li	s5,0
    800045bc:	a879                	j	8000465a <exec+0x2ea>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800045be:	e9040613          	addi	a2,s0,-368
    800045c2:	85ca                	mv	a1,s2
    800045c4:	855a                	mv	a0,s6
    800045c6:	ffffc097          	auipc	ra,0xffffc
    800045ca:	58c080e7          	jalr	1420(ra) # 80000b52 <copyout>
    800045ce:	0c054263          	bltz	a0,80004692 <exec+0x322>
  p->trapframe->a1 = sp;
    800045d2:	058bb783          	ld	a5,88(s7)
    800045d6:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800045da:	de843783          	ld	a5,-536(s0)
    800045de:	0007c703          	lbu	a4,0(a5)
    800045e2:	cf11                	beqz	a4,800045fe <exec+0x28e>
    800045e4:	0785                	addi	a5,a5,1
    if(*s == '/')
    800045e6:	02f00693          	li	a3,47
    800045ea:	a039                	j	800045f8 <exec+0x288>
      last = s+1;
    800045ec:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    800045f0:	0785                	addi	a5,a5,1
    800045f2:	fff7c703          	lbu	a4,-1(a5)
    800045f6:	c701                	beqz	a4,800045fe <exec+0x28e>
    if(*s == '/')
    800045f8:	fed71ce3          	bne	a4,a3,800045f0 <exec+0x280>
    800045fc:	bfc5                	j	800045ec <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    800045fe:	4641                	li	a2,16
    80004600:	de843583          	ld	a1,-536(s0)
    80004604:	160b8513          	addi	a0,s7,352
    80004608:	ffffc097          	auipc	ra,0xffffc
    8000460c:	d06080e7          	jalr	-762(ra) # 8000030e <safestrcpy>
  oldpagetable = p->pagetable;
    80004610:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80004614:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80004618:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000461c:	058bb783          	ld	a5,88(s7)
    80004620:	e6843703          	ld	a4,-408(s0)
    80004624:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004626:	058bb783          	ld	a5,88(s7)
    8000462a:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000462e:	85ea                	mv	a1,s10
    80004630:	ffffd097          	auipc	ra,0xffffd
    80004634:	b10080e7          	jalr	-1264(ra) # 80001140 <proc_freepagetable>
  if(p->pid==1){
    80004638:	030ba703          	lw	a4,48(s7)
    8000463c:	4785                	li	a5,1
    8000463e:	00f70563          	beq	a4,a5,80004648 <exec+0x2d8>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004642:	0004851b          	sext.w	a0,s1
    80004646:	b3d9                	j	8000440c <exec+0x9c>
    vmprint(p->pagetable);
    80004648:	050bb503          	ld	a0,80(s7)
    8000464c:	ffffc097          	auipc	ra,0xffffc
    80004650:	798080e7          	jalr	1944(ra) # 80000de4 <vmprint>
    80004654:	b7fd                	j	80004642 <exec+0x2d2>
    80004656:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    8000465a:	df843583          	ld	a1,-520(s0)
    8000465e:	855a                	mv	a0,s6
    80004660:	ffffd097          	auipc	ra,0xffffd
    80004664:	ae0080e7          	jalr	-1312(ra) # 80001140 <proc_freepagetable>
  if(ip){
    80004668:	d80a98e3          	bnez	s5,800043f8 <exec+0x88>
  return -1;
    8000466c:	557d                	li	a0,-1
    8000466e:	bb79                	j	8000440c <exec+0x9c>
    80004670:	de943c23          	sd	s1,-520(s0)
    80004674:	b7dd                	j	8000465a <exec+0x2ea>
    80004676:	de943c23          	sd	s1,-520(s0)
    8000467a:	b7c5                	j	8000465a <exec+0x2ea>
    8000467c:	de943c23          	sd	s1,-520(s0)
    80004680:	bfe9                	j	8000465a <exec+0x2ea>
  sz = sz1;
    80004682:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004686:	4a81                	li	s5,0
    80004688:	bfc9                	j	8000465a <exec+0x2ea>
  sz = sz1;
    8000468a:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    8000468e:	4a81                	li	s5,0
    80004690:	b7e9                	j	8000465a <exec+0x2ea>
  sz = sz1;
    80004692:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004696:	4a81                	li	s5,0
    80004698:	b7c9                	j	8000465a <exec+0x2ea>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000469a:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000469e:	e0843783          	ld	a5,-504(s0)
    800046a2:	0017869b          	addiw	a3,a5,1
    800046a6:	e0d43423          	sd	a3,-504(s0)
    800046aa:	e0043783          	ld	a5,-512(s0)
    800046ae:	0387879b          	addiw	a5,a5,56
    800046b2:	e8845703          	lhu	a4,-376(s0)
    800046b6:	e0e6d7e3          	bge	a3,a4,800044c4 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800046ba:	2781                	sext.w	a5,a5
    800046bc:	e0f43023          	sd	a5,-512(s0)
    800046c0:	03800713          	li	a4,56
    800046c4:	86be                	mv	a3,a5
    800046c6:	e1840613          	addi	a2,s0,-488
    800046ca:	4581                	li	a1,0
    800046cc:	8556                	mv	a0,s5
    800046ce:	fffff097          	auipc	ra,0xfffff
    800046d2:	a5e080e7          	jalr	-1442(ra) # 8000312c <readi>
    800046d6:	03800793          	li	a5,56
    800046da:	f6f51ee3          	bne	a0,a5,80004656 <exec+0x2e6>
    if(ph.type != ELF_PROG_LOAD)
    800046de:	e1842783          	lw	a5,-488(s0)
    800046e2:	4705                	li	a4,1
    800046e4:	fae79de3          	bne	a5,a4,8000469e <exec+0x32e>
    if(ph.memsz < ph.filesz)
    800046e8:	e4043603          	ld	a2,-448(s0)
    800046ec:	e3843783          	ld	a5,-456(s0)
    800046f0:	f8f660e3          	bltu	a2,a5,80004670 <exec+0x300>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800046f4:	e2843783          	ld	a5,-472(s0)
    800046f8:	963e                	add	a2,a2,a5
    800046fa:	f6f66ee3          	bltu	a2,a5,80004676 <exec+0x306>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    800046fe:	85a6                	mv	a1,s1
    80004700:	855a                	mv	a0,s6
    80004702:	ffffc097          	auipc	ra,0xffffc
    80004706:	1fc080e7          	jalr	508(ra) # 800008fe <uvmalloc>
    8000470a:	dea43c23          	sd	a0,-520(s0)
    8000470e:	d53d                	beqz	a0,8000467c <exec+0x30c>
    if((ph.vaddr % PGSIZE) != 0)
    80004710:	e2843c03          	ld	s8,-472(s0)
    80004714:	de043783          	ld	a5,-544(s0)
    80004718:	00fc77b3          	and	a5,s8,a5
    8000471c:	ff9d                	bnez	a5,8000465a <exec+0x2ea>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000471e:	e2042c83          	lw	s9,-480(s0)
    80004722:	e3842b83          	lw	s7,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004726:	f60b8ae3          	beqz	s7,8000469a <exec+0x32a>
    8000472a:	89de                	mv	s3,s7
    8000472c:	4481                	li	s1,0
    8000472e:	bb95                	j	800044a2 <exec+0x132>

0000000080004730 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004730:	7179                	addi	sp,sp,-48
    80004732:	f406                	sd	ra,40(sp)
    80004734:	f022                	sd	s0,32(sp)
    80004736:	ec26                	sd	s1,24(sp)
    80004738:	e84a                	sd	s2,16(sp)
    8000473a:	1800                	addi	s0,sp,48
    8000473c:	892e                	mv	s2,a1
    8000473e:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004740:	fdc40593          	addi	a1,s0,-36
    80004744:	ffffe097          	auipc	ra,0xffffe
    80004748:	a02080e7          	jalr	-1534(ra) # 80002146 <argint>
    8000474c:	04054063          	bltz	a0,8000478c <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004750:	fdc42703          	lw	a4,-36(s0)
    80004754:	47bd                	li	a5,15
    80004756:	02e7ed63          	bltu	a5,a4,80004790 <argfd+0x60>
    8000475a:	ffffd097          	auipc	ra,0xffffd
    8000475e:	82c080e7          	jalr	-2004(ra) # 80000f86 <myproc>
    80004762:	fdc42703          	lw	a4,-36(s0)
    80004766:	01a70793          	addi	a5,a4,26 # fffffffffffff01a <end+0xffffffff7ffd8dda>
    8000476a:	078e                	slli	a5,a5,0x3
    8000476c:	953e                	add	a0,a0,a5
    8000476e:	651c                	ld	a5,8(a0)
    80004770:	c395                	beqz	a5,80004794 <argfd+0x64>
    return -1;
  if(pfd)
    80004772:	00090463          	beqz	s2,8000477a <argfd+0x4a>
    *pfd = fd;
    80004776:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000477a:	4501                	li	a0,0
  if(pf)
    8000477c:	c091                	beqz	s1,80004780 <argfd+0x50>
    *pf = f;
    8000477e:	e09c                	sd	a5,0(s1)
}
    80004780:	70a2                	ld	ra,40(sp)
    80004782:	7402                	ld	s0,32(sp)
    80004784:	64e2                	ld	s1,24(sp)
    80004786:	6942                	ld	s2,16(sp)
    80004788:	6145                	addi	sp,sp,48
    8000478a:	8082                	ret
    return -1;
    8000478c:	557d                	li	a0,-1
    8000478e:	bfcd                	j	80004780 <argfd+0x50>
    return -1;
    80004790:	557d                	li	a0,-1
    80004792:	b7fd                	j	80004780 <argfd+0x50>
    80004794:	557d                	li	a0,-1
    80004796:	b7ed                	j	80004780 <argfd+0x50>

0000000080004798 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004798:	1101                	addi	sp,sp,-32
    8000479a:	ec06                	sd	ra,24(sp)
    8000479c:	e822                	sd	s0,16(sp)
    8000479e:	e426                	sd	s1,8(sp)
    800047a0:	1000                	addi	s0,sp,32
    800047a2:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800047a4:	ffffc097          	auipc	ra,0xffffc
    800047a8:	7e2080e7          	jalr	2018(ra) # 80000f86 <myproc>
    800047ac:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800047ae:	0d850793          	addi	a5,a0,216
    800047b2:	4501                	li	a0,0
    800047b4:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800047b6:	6398                	ld	a4,0(a5)
    800047b8:	cb19                	beqz	a4,800047ce <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800047ba:	2505                	addiw	a0,a0,1
    800047bc:	07a1                	addi	a5,a5,8
    800047be:	fed51ce3          	bne	a0,a3,800047b6 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800047c2:	557d                	li	a0,-1
}
    800047c4:	60e2                	ld	ra,24(sp)
    800047c6:	6442                	ld	s0,16(sp)
    800047c8:	64a2                	ld	s1,8(sp)
    800047ca:	6105                	addi	sp,sp,32
    800047cc:	8082                	ret
      p->ofile[fd] = f;
    800047ce:	01a50793          	addi	a5,a0,26
    800047d2:	078e                	slli	a5,a5,0x3
    800047d4:	963e                	add	a2,a2,a5
    800047d6:	e604                	sd	s1,8(a2)
      return fd;
    800047d8:	b7f5                	j	800047c4 <fdalloc+0x2c>

00000000800047da <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800047da:	715d                	addi	sp,sp,-80
    800047dc:	e486                	sd	ra,72(sp)
    800047de:	e0a2                	sd	s0,64(sp)
    800047e0:	fc26                	sd	s1,56(sp)
    800047e2:	f84a                	sd	s2,48(sp)
    800047e4:	f44e                	sd	s3,40(sp)
    800047e6:	f052                	sd	s4,32(sp)
    800047e8:	ec56                	sd	s5,24(sp)
    800047ea:	0880                	addi	s0,sp,80
    800047ec:	89ae                	mv	s3,a1
    800047ee:	8ab2                	mv	s5,a2
    800047f0:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800047f2:	fb040593          	addi	a1,s0,-80
    800047f6:	fffff097          	auipc	ra,0xfffff
    800047fa:	e5c080e7          	jalr	-420(ra) # 80003652 <nameiparent>
    800047fe:	892a                	mv	s2,a0
    80004800:	12050e63          	beqz	a0,8000493c <create+0x162>
    return 0;

  ilock(dp);
    80004804:	ffffe097          	auipc	ra,0xffffe
    80004808:	674080e7          	jalr	1652(ra) # 80002e78 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000480c:	4601                	li	a2,0
    8000480e:	fb040593          	addi	a1,s0,-80
    80004812:	854a                	mv	a0,s2
    80004814:	fffff097          	auipc	ra,0xfffff
    80004818:	b48080e7          	jalr	-1208(ra) # 8000335c <dirlookup>
    8000481c:	84aa                	mv	s1,a0
    8000481e:	c921                	beqz	a0,8000486e <create+0x94>
    iunlockput(dp);
    80004820:	854a                	mv	a0,s2
    80004822:	fffff097          	auipc	ra,0xfffff
    80004826:	8b8080e7          	jalr	-1864(ra) # 800030da <iunlockput>
    ilock(ip);
    8000482a:	8526                	mv	a0,s1
    8000482c:	ffffe097          	auipc	ra,0xffffe
    80004830:	64c080e7          	jalr	1612(ra) # 80002e78 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004834:	2981                	sext.w	s3,s3
    80004836:	4789                	li	a5,2
    80004838:	02f99463          	bne	s3,a5,80004860 <create+0x86>
    8000483c:	0444d783          	lhu	a5,68(s1)
    80004840:	37f9                	addiw	a5,a5,-2
    80004842:	17c2                	slli	a5,a5,0x30
    80004844:	93c1                	srli	a5,a5,0x30
    80004846:	4705                	li	a4,1
    80004848:	00f76c63          	bltu	a4,a5,80004860 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    8000484c:	8526                	mv	a0,s1
    8000484e:	60a6                	ld	ra,72(sp)
    80004850:	6406                	ld	s0,64(sp)
    80004852:	74e2                	ld	s1,56(sp)
    80004854:	7942                	ld	s2,48(sp)
    80004856:	79a2                	ld	s3,40(sp)
    80004858:	7a02                	ld	s4,32(sp)
    8000485a:	6ae2                	ld	s5,24(sp)
    8000485c:	6161                	addi	sp,sp,80
    8000485e:	8082                	ret
    iunlockput(ip);
    80004860:	8526                	mv	a0,s1
    80004862:	fffff097          	auipc	ra,0xfffff
    80004866:	878080e7          	jalr	-1928(ra) # 800030da <iunlockput>
    return 0;
    8000486a:	4481                	li	s1,0
    8000486c:	b7c5                	j	8000484c <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    8000486e:	85ce                	mv	a1,s3
    80004870:	00092503          	lw	a0,0(s2)
    80004874:	ffffe097          	auipc	ra,0xffffe
    80004878:	46a080e7          	jalr	1130(ra) # 80002cde <ialloc>
    8000487c:	84aa                	mv	s1,a0
    8000487e:	c521                	beqz	a0,800048c6 <create+0xec>
  ilock(ip);
    80004880:	ffffe097          	auipc	ra,0xffffe
    80004884:	5f8080e7          	jalr	1528(ra) # 80002e78 <ilock>
  ip->major = major;
    80004888:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    8000488c:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80004890:	4a05                	li	s4,1
    80004892:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    80004896:	8526                	mv	a0,s1
    80004898:	ffffe097          	auipc	ra,0xffffe
    8000489c:	514080e7          	jalr	1300(ra) # 80002dac <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800048a0:	2981                	sext.w	s3,s3
    800048a2:	03498a63          	beq	s3,s4,800048d6 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    800048a6:	40d0                	lw	a2,4(s1)
    800048a8:	fb040593          	addi	a1,s0,-80
    800048ac:	854a                	mv	a0,s2
    800048ae:	fffff097          	auipc	ra,0xfffff
    800048b2:	cc4080e7          	jalr	-828(ra) # 80003572 <dirlink>
    800048b6:	06054b63          	bltz	a0,8000492c <create+0x152>
  iunlockput(dp);
    800048ba:	854a                	mv	a0,s2
    800048bc:	fffff097          	auipc	ra,0xfffff
    800048c0:	81e080e7          	jalr	-2018(ra) # 800030da <iunlockput>
  return ip;
    800048c4:	b761                	j	8000484c <create+0x72>
    panic("create: ialloc");
    800048c6:	00004517          	auipc	a0,0x4
    800048ca:	fba50513          	addi	a0,a0,-70 # 80008880 <syscalls_name+0x2c0>
    800048ce:	00001097          	auipc	ra,0x1
    800048d2:	632080e7          	jalr	1586(ra) # 80005f00 <panic>
    dp->nlink++;  // for ".."
    800048d6:	04a95783          	lhu	a5,74(s2)
    800048da:	2785                	addiw	a5,a5,1
    800048dc:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    800048e0:	854a                	mv	a0,s2
    800048e2:	ffffe097          	auipc	ra,0xffffe
    800048e6:	4ca080e7          	jalr	1226(ra) # 80002dac <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800048ea:	40d0                	lw	a2,4(s1)
    800048ec:	00004597          	auipc	a1,0x4
    800048f0:	fa458593          	addi	a1,a1,-92 # 80008890 <syscalls_name+0x2d0>
    800048f4:	8526                	mv	a0,s1
    800048f6:	fffff097          	auipc	ra,0xfffff
    800048fa:	c7c080e7          	jalr	-900(ra) # 80003572 <dirlink>
    800048fe:	00054f63          	bltz	a0,8000491c <create+0x142>
    80004902:	00492603          	lw	a2,4(s2)
    80004906:	00004597          	auipc	a1,0x4
    8000490a:	85a58593          	addi	a1,a1,-1958 # 80008160 <etext+0x160>
    8000490e:	8526                	mv	a0,s1
    80004910:	fffff097          	auipc	ra,0xfffff
    80004914:	c62080e7          	jalr	-926(ra) # 80003572 <dirlink>
    80004918:	f80557e3          	bgez	a0,800048a6 <create+0xcc>
      panic("create dots");
    8000491c:	00004517          	auipc	a0,0x4
    80004920:	f7c50513          	addi	a0,a0,-132 # 80008898 <syscalls_name+0x2d8>
    80004924:	00001097          	auipc	ra,0x1
    80004928:	5dc080e7          	jalr	1500(ra) # 80005f00 <panic>
    panic("create: dirlink");
    8000492c:	00004517          	auipc	a0,0x4
    80004930:	f7c50513          	addi	a0,a0,-132 # 800088a8 <syscalls_name+0x2e8>
    80004934:	00001097          	auipc	ra,0x1
    80004938:	5cc080e7          	jalr	1484(ra) # 80005f00 <panic>
    return 0;
    8000493c:	84aa                	mv	s1,a0
    8000493e:	b739                	j	8000484c <create+0x72>

0000000080004940 <sys_dup>:
{
    80004940:	7179                	addi	sp,sp,-48
    80004942:	f406                	sd	ra,40(sp)
    80004944:	f022                	sd	s0,32(sp)
    80004946:	ec26                	sd	s1,24(sp)
    80004948:	e84a                	sd	s2,16(sp)
    8000494a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000494c:	fd840613          	addi	a2,s0,-40
    80004950:	4581                	li	a1,0
    80004952:	4501                	li	a0,0
    80004954:	00000097          	auipc	ra,0x0
    80004958:	ddc080e7          	jalr	-548(ra) # 80004730 <argfd>
    return -1;
    8000495c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000495e:	02054363          	bltz	a0,80004984 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    80004962:	fd843903          	ld	s2,-40(s0)
    80004966:	854a                	mv	a0,s2
    80004968:	00000097          	auipc	ra,0x0
    8000496c:	e30080e7          	jalr	-464(ra) # 80004798 <fdalloc>
    80004970:	84aa                	mv	s1,a0
    return -1;
    80004972:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004974:	00054863          	bltz	a0,80004984 <sys_dup+0x44>
  filedup(f);
    80004978:	854a                	mv	a0,s2
    8000497a:	fffff097          	auipc	ra,0xfffff
    8000497e:	350080e7          	jalr	848(ra) # 80003cca <filedup>
  return fd;
    80004982:	87a6                	mv	a5,s1
}
    80004984:	853e                	mv	a0,a5
    80004986:	70a2                	ld	ra,40(sp)
    80004988:	7402                	ld	s0,32(sp)
    8000498a:	64e2                	ld	s1,24(sp)
    8000498c:	6942                	ld	s2,16(sp)
    8000498e:	6145                	addi	sp,sp,48
    80004990:	8082                	ret

0000000080004992 <sys_read>:
{
    80004992:	7179                	addi	sp,sp,-48
    80004994:	f406                	sd	ra,40(sp)
    80004996:	f022                	sd	s0,32(sp)
    80004998:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000499a:	fe840613          	addi	a2,s0,-24
    8000499e:	4581                	li	a1,0
    800049a0:	4501                	li	a0,0
    800049a2:	00000097          	auipc	ra,0x0
    800049a6:	d8e080e7          	jalr	-626(ra) # 80004730 <argfd>
    return -1;
    800049aa:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800049ac:	04054163          	bltz	a0,800049ee <sys_read+0x5c>
    800049b0:	fe440593          	addi	a1,s0,-28
    800049b4:	4509                	li	a0,2
    800049b6:	ffffd097          	auipc	ra,0xffffd
    800049ba:	790080e7          	jalr	1936(ra) # 80002146 <argint>
    return -1;
    800049be:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800049c0:	02054763          	bltz	a0,800049ee <sys_read+0x5c>
    800049c4:	fd840593          	addi	a1,s0,-40
    800049c8:	4505                	li	a0,1
    800049ca:	ffffd097          	auipc	ra,0xffffd
    800049ce:	79e080e7          	jalr	1950(ra) # 80002168 <argaddr>
    return -1;
    800049d2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800049d4:	00054d63          	bltz	a0,800049ee <sys_read+0x5c>
  return fileread(f, p, n);
    800049d8:	fe442603          	lw	a2,-28(s0)
    800049dc:	fd843583          	ld	a1,-40(s0)
    800049e0:	fe843503          	ld	a0,-24(s0)
    800049e4:	fffff097          	auipc	ra,0xfffff
    800049e8:	472080e7          	jalr	1138(ra) # 80003e56 <fileread>
    800049ec:	87aa                	mv	a5,a0
}
    800049ee:	853e                	mv	a0,a5
    800049f0:	70a2                	ld	ra,40(sp)
    800049f2:	7402                	ld	s0,32(sp)
    800049f4:	6145                	addi	sp,sp,48
    800049f6:	8082                	ret

00000000800049f8 <sys_write>:
{
    800049f8:	7179                	addi	sp,sp,-48
    800049fa:	f406                	sd	ra,40(sp)
    800049fc:	f022                	sd	s0,32(sp)
    800049fe:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004a00:	fe840613          	addi	a2,s0,-24
    80004a04:	4581                	li	a1,0
    80004a06:	4501                	li	a0,0
    80004a08:	00000097          	auipc	ra,0x0
    80004a0c:	d28080e7          	jalr	-728(ra) # 80004730 <argfd>
    return -1;
    80004a10:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004a12:	04054163          	bltz	a0,80004a54 <sys_write+0x5c>
    80004a16:	fe440593          	addi	a1,s0,-28
    80004a1a:	4509                	li	a0,2
    80004a1c:	ffffd097          	auipc	ra,0xffffd
    80004a20:	72a080e7          	jalr	1834(ra) # 80002146 <argint>
    return -1;
    80004a24:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004a26:	02054763          	bltz	a0,80004a54 <sys_write+0x5c>
    80004a2a:	fd840593          	addi	a1,s0,-40
    80004a2e:	4505                	li	a0,1
    80004a30:	ffffd097          	auipc	ra,0xffffd
    80004a34:	738080e7          	jalr	1848(ra) # 80002168 <argaddr>
    return -1;
    80004a38:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004a3a:	00054d63          	bltz	a0,80004a54 <sys_write+0x5c>
  return filewrite(f, p, n);
    80004a3e:	fe442603          	lw	a2,-28(s0)
    80004a42:	fd843583          	ld	a1,-40(s0)
    80004a46:	fe843503          	ld	a0,-24(s0)
    80004a4a:	fffff097          	auipc	ra,0xfffff
    80004a4e:	4ce080e7          	jalr	1230(ra) # 80003f18 <filewrite>
    80004a52:	87aa                	mv	a5,a0
}
    80004a54:	853e                	mv	a0,a5
    80004a56:	70a2                	ld	ra,40(sp)
    80004a58:	7402                	ld	s0,32(sp)
    80004a5a:	6145                	addi	sp,sp,48
    80004a5c:	8082                	ret

0000000080004a5e <sys_close>:
{
    80004a5e:	1101                	addi	sp,sp,-32
    80004a60:	ec06                	sd	ra,24(sp)
    80004a62:	e822                	sd	s0,16(sp)
    80004a64:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004a66:	fe040613          	addi	a2,s0,-32
    80004a6a:	fec40593          	addi	a1,s0,-20
    80004a6e:	4501                	li	a0,0
    80004a70:	00000097          	auipc	ra,0x0
    80004a74:	cc0080e7          	jalr	-832(ra) # 80004730 <argfd>
    return -1;
    80004a78:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004a7a:	02054463          	bltz	a0,80004aa2 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004a7e:	ffffc097          	auipc	ra,0xffffc
    80004a82:	508080e7          	jalr	1288(ra) # 80000f86 <myproc>
    80004a86:	fec42783          	lw	a5,-20(s0)
    80004a8a:	07e9                	addi	a5,a5,26
    80004a8c:	078e                	slli	a5,a5,0x3
    80004a8e:	953e                	add	a0,a0,a5
    80004a90:	00053423          	sd	zero,8(a0)
  fileclose(f);
    80004a94:	fe043503          	ld	a0,-32(s0)
    80004a98:	fffff097          	auipc	ra,0xfffff
    80004a9c:	284080e7          	jalr	644(ra) # 80003d1c <fileclose>
  return 0;
    80004aa0:	4781                	li	a5,0
}
    80004aa2:	853e                	mv	a0,a5
    80004aa4:	60e2                	ld	ra,24(sp)
    80004aa6:	6442                	ld	s0,16(sp)
    80004aa8:	6105                	addi	sp,sp,32
    80004aaa:	8082                	ret

0000000080004aac <sys_fstat>:
{
    80004aac:	1101                	addi	sp,sp,-32
    80004aae:	ec06                	sd	ra,24(sp)
    80004ab0:	e822                	sd	s0,16(sp)
    80004ab2:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004ab4:	fe840613          	addi	a2,s0,-24
    80004ab8:	4581                	li	a1,0
    80004aba:	4501                	li	a0,0
    80004abc:	00000097          	auipc	ra,0x0
    80004ac0:	c74080e7          	jalr	-908(ra) # 80004730 <argfd>
    return -1;
    80004ac4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004ac6:	02054563          	bltz	a0,80004af0 <sys_fstat+0x44>
    80004aca:	fe040593          	addi	a1,s0,-32
    80004ace:	4505                	li	a0,1
    80004ad0:	ffffd097          	auipc	ra,0xffffd
    80004ad4:	698080e7          	jalr	1688(ra) # 80002168 <argaddr>
    return -1;
    80004ad8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004ada:	00054b63          	bltz	a0,80004af0 <sys_fstat+0x44>
  return filestat(f, st);
    80004ade:	fe043583          	ld	a1,-32(s0)
    80004ae2:	fe843503          	ld	a0,-24(s0)
    80004ae6:	fffff097          	auipc	ra,0xfffff
    80004aea:	2fe080e7          	jalr	766(ra) # 80003de4 <filestat>
    80004aee:	87aa                	mv	a5,a0
}
    80004af0:	853e                	mv	a0,a5
    80004af2:	60e2                	ld	ra,24(sp)
    80004af4:	6442                	ld	s0,16(sp)
    80004af6:	6105                	addi	sp,sp,32
    80004af8:	8082                	ret

0000000080004afa <sys_link>:
{
    80004afa:	7169                	addi	sp,sp,-304
    80004afc:	f606                	sd	ra,296(sp)
    80004afe:	f222                	sd	s0,288(sp)
    80004b00:	ee26                	sd	s1,280(sp)
    80004b02:	ea4a                	sd	s2,272(sp)
    80004b04:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b06:	08000613          	li	a2,128
    80004b0a:	ed040593          	addi	a1,s0,-304
    80004b0e:	4501                	li	a0,0
    80004b10:	ffffd097          	auipc	ra,0xffffd
    80004b14:	67a080e7          	jalr	1658(ra) # 8000218a <argstr>
    return -1;
    80004b18:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b1a:	10054e63          	bltz	a0,80004c36 <sys_link+0x13c>
    80004b1e:	08000613          	li	a2,128
    80004b22:	f5040593          	addi	a1,s0,-176
    80004b26:	4505                	li	a0,1
    80004b28:	ffffd097          	auipc	ra,0xffffd
    80004b2c:	662080e7          	jalr	1634(ra) # 8000218a <argstr>
    return -1;
    80004b30:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b32:	10054263          	bltz	a0,80004c36 <sys_link+0x13c>
  begin_op();
    80004b36:	fffff097          	auipc	ra,0xfffff
    80004b3a:	d1e080e7          	jalr	-738(ra) # 80003854 <begin_op>
  if((ip = namei(old)) == 0){
    80004b3e:	ed040513          	addi	a0,s0,-304
    80004b42:	fffff097          	auipc	ra,0xfffff
    80004b46:	af2080e7          	jalr	-1294(ra) # 80003634 <namei>
    80004b4a:	84aa                	mv	s1,a0
    80004b4c:	c551                	beqz	a0,80004bd8 <sys_link+0xde>
  ilock(ip);
    80004b4e:	ffffe097          	auipc	ra,0xffffe
    80004b52:	32a080e7          	jalr	810(ra) # 80002e78 <ilock>
  if(ip->type == T_DIR){
    80004b56:	04449703          	lh	a4,68(s1)
    80004b5a:	4785                	li	a5,1
    80004b5c:	08f70463          	beq	a4,a5,80004be4 <sys_link+0xea>
  ip->nlink++;
    80004b60:	04a4d783          	lhu	a5,74(s1)
    80004b64:	2785                	addiw	a5,a5,1
    80004b66:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004b6a:	8526                	mv	a0,s1
    80004b6c:	ffffe097          	auipc	ra,0xffffe
    80004b70:	240080e7          	jalr	576(ra) # 80002dac <iupdate>
  iunlock(ip);
    80004b74:	8526                	mv	a0,s1
    80004b76:	ffffe097          	auipc	ra,0xffffe
    80004b7a:	3c4080e7          	jalr	964(ra) # 80002f3a <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004b7e:	fd040593          	addi	a1,s0,-48
    80004b82:	f5040513          	addi	a0,s0,-176
    80004b86:	fffff097          	auipc	ra,0xfffff
    80004b8a:	acc080e7          	jalr	-1332(ra) # 80003652 <nameiparent>
    80004b8e:	892a                	mv	s2,a0
    80004b90:	c935                	beqz	a0,80004c04 <sys_link+0x10a>
  ilock(dp);
    80004b92:	ffffe097          	auipc	ra,0xffffe
    80004b96:	2e6080e7          	jalr	742(ra) # 80002e78 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004b9a:	00092703          	lw	a4,0(s2)
    80004b9e:	409c                	lw	a5,0(s1)
    80004ba0:	04f71d63          	bne	a4,a5,80004bfa <sys_link+0x100>
    80004ba4:	40d0                	lw	a2,4(s1)
    80004ba6:	fd040593          	addi	a1,s0,-48
    80004baa:	854a                	mv	a0,s2
    80004bac:	fffff097          	auipc	ra,0xfffff
    80004bb0:	9c6080e7          	jalr	-1594(ra) # 80003572 <dirlink>
    80004bb4:	04054363          	bltz	a0,80004bfa <sys_link+0x100>
  iunlockput(dp);
    80004bb8:	854a                	mv	a0,s2
    80004bba:	ffffe097          	auipc	ra,0xffffe
    80004bbe:	520080e7          	jalr	1312(ra) # 800030da <iunlockput>
  iput(ip);
    80004bc2:	8526                	mv	a0,s1
    80004bc4:	ffffe097          	auipc	ra,0xffffe
    80004bc8:	46e080e7          	jalr	1134(ra) # 80003032 <iput>
  end_op();
    80004bcc:	fffff097          	auipc	ra,0xfffff
    80004bd0:	d06080e7          	jalr	-762(ra) # 800038d2 <end_op>
  return 0;
    80004bd4:	4781                	li	a5,0
    80004bd6:	a085                	j	80004c36 <sys_link+0x13c>
    end_op();
    80004bd8:	fffff097          	auipc	ra,0xfffff
    80004bdc:	cfa080e7          	jalr	-774(ra) # 800038d2 <end_op>
    return -1;
    80004be0:	57fd                	li	a5,-1
    80004be2:	a891                	j	80004c36 <sys_link+0x13c>
    iunlockput(ip);
    80004be4:	8526                	mv	a0,s1
    80004be6:	ffffe097          	auipc	ra,0xffffe
    80004bea:	4f4080e7          	jalr	1268(ra) # 800030da <iunlockput>
    end_op();
    80004bee:	fffff097          	auipc	ra,0xfffff
    80004bf2:	ce4080e7          	jalr	-796(ra) # 800038d2 <end_op>
    return -1;
    80004bf6:	57fd                	li	a5,-1
    80004bf8:	a83d                	j	80004c36 <sys_link+0x13c>
    iunlockput(dp);
    80004bfa:	854a                	mv	a0,s2
    80004bfc:	ffffe097          	auipc	ra,0xffffe
    80004c00:	4de080e7          	jalr	1246(ra) # 800030da <iunlockput>
  ilock(ip);
    80004c04:	8526                	mv	a0,s1
    80004c06:	ffffe097          	auipc	ra,0xffffe
    80004c0a:	272080e7          	jalr	626(ra) # 80002e78 <ilock>
  ip->nlink--;
    80004c0e:	04a4d783          	lhu	a5,74(s1)
    80004c12:	37fd                	addiw	a5,a5,-1
    80004c14:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004c18:	8526                	mv	a0,s1
    80004c1a:	ffffe097          	auipc	ra,0xffffe
    80004c1e:	192080e7          	jalr	402(ra) # 80002dac <iupdate>
  iunlockput(ip);
    80004c22:	8526                	mv	a0,s1
    80004c24:	ffffe097          	auipc	ra,0xffffe
    80004c28:	4b6080e7          	jalr	1206(ra) # 800030da <iunlockput>
  end_op();
    80004c2c:	fffff097          	auipc	ra,0xfffff
    80004c30:	ca6080e7          	jalr	-858(ra) # 800038d2 <end_op>
  return -1;
    80004c34:	57fd                	li	a5,-1
}
    80004c36:	853e                	mv	a0,a5
    80004c38:	70b2                	ld	ra,296(sp)
    80004c3a:	7412                	ld	s0,288(sp)
    80004c3c:	64f2                	ld	s1,280(sp)
    80004c3e:	6952                	ld	s2,272(sp)
    80004c40:	6155                	addi	sp,sp,304
    80004c42:	8082                	ret

0000000080004c44 <sys_unlink>:
{
    80004c44:	7151                	addi	sp,sp,-240
    80004c46:	f586                	sd	ra,232(sp)
    80004c48:	f1a2                	sd	s0,224(sp)
    80004c4a:	eda6                	sd	s1,216(sp)
    80004c4c:	e9ca                	sd	s2,208(sp)
    80004c4e:	e5ce                	sd	s3,200(sp)
    80004c50:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004c52:	08000613          	li	a2,128
    80004c56:	f3040593          	addi	a1,s0,-208
    80004c5a:	4501                	li	a0,0
    80004c5c:	ffffd097          	auipc	ra,0xffffd
    80004c60:	52e080e7          	jalr	1326(ra) # 8000218a <argstr>
    80004c64:	18054163          	bltz	a0,80004de6 <sys_unlink+0x1a2>
  begin_op();
    80004c68:	fffff097          	auipc	ra,0xfffff
    80004c6c:	bec080e7          	jalr	-1044(ra) # 80003854 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004c70:	fb040593          	addi	a1,s0,-80
    80004c74:	f3040513          	addi	a0,s0,-208
    80004c78:	fffff097          	auipc	ra,0xfffff
    80004c7c:	9da080e7          	jalr	-1574(ra) # 80003652 <nameiparent>
    80004c80:	84aa                	mv	s1,a0
    80004c82:	c979                	beqz	a0,80004d58 <sys_unlink+0x114>
  ilock(dp);
    80004c84:	ffffe097          	auipc	ra,0xffffe
    80004c88:	1f4080e7          	jalr	500(ra) # 80002e78 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004c8c:	00004597          	auipc	a1,0x4
    80004c90:	c0458593          	addi	a1,a1,-1020 # 80008890 <syscalls_name+0x2d0>
    80004c94:	fb040513          	addi	a0,s0,-80
    80004c98:	ffffe097          	auipc	ra,0xffffe
    80004c9c:	6aa080e7          	jalr	1706(ra) # 80003342 <namecmp>
    80004ca0:	14050a63          	beqz	a0,80004df4 <sys_unlink+0x1b0>
    80004ca4:	00003597          	auipc	a1,0x3
    80004ca8:	4bc58593          	addi	a1,a1,1212 # 80008160 <etext+0x160>
    80004cac:	fb040513          	addi	a0,s0,-80
    80004cb0:	ffffe097          	auipc	ra,0xffffe
    80004cb4:	692080e7          	jalr	1682(ra) # 80003342 <namecmp>
    80004cb8:	12050e63          	beqz	a0,80004df4 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004cbc:	f2c40613          	addi	a2,s0,-212
    80004cc0:	fb040593          	addi	a1,s0,-80
    80004cc4:	8526                	mv	a0,s1
    80004cc6:	ffffe097          	auipc	ra,0xffffe
    80004cca:	696080e7          	jalr	1686(ra) # 8000335c <dirlookup>
    80004cce:	892a                	mv	s2,a0
    80004cd0:	12050263          	beqz	a0,80004df4 <sys_unlink+0x1b0>
  ilock(ip);
    80004cd4:	ffffe097          	auipc	ra,0xffffe
    80004cd8:	1a4080e7          	jalr	420(ra) # 80002e78 <ilock>
  if(ip->nlink < 1)
    80004cdc:	04a91783          	lh	a5,74(s2)
    80004ce0:	08f05263          	blez	a5,80004d64 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004ce4:	04491703          	lh	a4,68(s2)
    80004ce8:	4785                	li	a5,1
    80004cea:	08f70563          	beq	a4,a5,80004d74 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004cee:	4641                	li	a2,16
    80004cf0:	4581                	li	a1,0
    80004cf2:	fc040513          	addi	a0,s0,-64
    80004cf6:	ffffb097          	auipc	ra,0xffffb
    80004cfa:	4ce080e7          	jalr	1230(ra) # 800001c4 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004cfe:	4741                	li	a4,16
    80004d00:	f2c42683          	lw	a3,-212(s0)
    80004d04:	fc040613          	addi	a2,s0,-64
    80004d08:	4581                	li	a1,0
    80004d0a:	8526                	mv	a0,s1
    80004d0c:	ffffe097          	auipc	ra,0xffffe
    80004d10:	518080e7          	jalr	1304(ra) # 80003224 <writei>
    80004d14:	47c1                	li	a5,16
    80004d16:	0af51563          	bne	a0,a5,80004dc0 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004d1a:	04491703          	lh	a4,68(s2)
    80004d1e:	4785                	li	a5,1
    80004d20:	0af70863          	beq	a4,a5,80004dd0 <sys_unlink+0x18c>
  iunlockput(dp);
    80004d24:	8526                	mv	a0,s1
    80004d26:	ffffe097          	auipc	ra,0xffffe
    80004d2a:	3b4080e7          	jalr	948(ra) # 800030da <iunlockput>
  ip->nlink--;
    80004d2e:	04a95783          	lhu	a5,74(s2)
    80004d32:	37fd                	addiw	a5,a5,-1
    80004d34:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004d38:	854a                	mv	a0,s2
    80004d3a:	ffffe097          	auipc	ra,0xffffe
    80004d3e:	072080e7          	jalr	114(ra) # 80002dac <iupdate>
  iunlockput(ip);
    80004d42:	854a                	mv	a0,s2
    80004d44:	ffffe097          	auipc	ra,0xffffe
    80004d48:	396080e7          	jalr	918(ra) # 800030da <iunlockput>
  end_op();
    80004d4c:	fffff097          	auipc	ra,0xfffff
    80004d50:	b86080e7          	jalr	-1146(ra) # 800038d2 <end_op>
  return 0;
    80004d54:	4501                	li	a0,0
    80004d56:	a84d                	j	80004e08 <sys_unlink+0x1c4>
    end_op();
    80004d58:	fffff097          	auipc	ra,0xfffff
    80004d5c:	b7a080e7          	jalr	-1158(ra) # 800038d2 <end_op>
    return -1;
    80004d60:	557d                	li	a0,-1
    80004d62:	a05d                	j	80004e08 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004d64:	00004517          	auipc	a0,0x4
    80004d68:	b5450513          	addi	a0,a0,-1196 # 800088b8 <syscalls_name+0x2f8>
    80004d6c:	00001097          	auipc	ra,0x1
    80004d70:	194080e7          	jalr	404(ra) # 80005f00 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004d74:	04c92703          	lw	a4,76(s2)
    80004d78:	02000793          	li	a5,32
    80004d7c:	f6e7f9e3          	bgeu	a5,a4,80004cee <sys_unlink+0xaa>
    80004d80:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004d84:	4741                	li	a4,16
    80004d86:	86ce                	mv	a3,s3
    80004d88:	f1840613          	addi	a2,s0,-232
    80004d8c:	4581                	li	a1,0
    80004d8e:	854a                	mv	a0,s2
    80004d90:	ffffe097          	auipc	ra,0xffffe
    80004d94:	39c080e7          	jalr	924(ra) # 8000312c <readi>
    80004d98:	47c1                	li	a5,16
    80004d9a:	00f51b63          	bne	a0,a5,80004db0 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004d9e:	f1845783          	lhu	a5,-232(s0)
    80004da2:	e7a1                	bnez	a5,80004dea <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004da4:	29c1                	addiw	s3,s3,16
    80004da6:	04c92783          	lw	a5,76(s2)
    80004daa:	fcf9ede3          	bltu	s3,a5,80004d84 <sys_unlink+0x140>
    80004dae:	b781                	j	80004cee <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004db0:	00004517          	auipc	a0,0x4
    80004db4:	b2050513          	addi	a0,a0,-1248 # 800088d0 <syscalls_name+0x310>
    80004db8:	00001097          	auipc	ra,0x1
    80004dbc:	148080e7          	jalr	328(ra) # 80005f00 <panic>
    panic("unlink: writei");
    80004dc0:	00004517          	auipc	a0,0x4
    80004dc4:	b2850513          	addi	a0,a0,-1240 # 800088e8 <syscalls_name+0x328>
    80004dc8:	00001097          	auipc	ra,0x1
    80004dcc:	138080e7          	jalr	312(ra) # 80005f00 <panic>
    dp->nlink--;
    80004dd0:	04a4d783          	lhu	a5,74(s1)
    80004dd4:	37fd                	addiw	a5,a5,-1
    80004dd6:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004dda:	8526                	mv	a0,s1
    80004ddc:	ffffe097          	auipc	ra,0xffffe
    80004de0:	fd0080e7          	jalr	-48(ra) # 80002dac <iupdate>
    80004de4:	b781                	j	80004d24 <sys_unlink+0xe0>
    return -1;
    80004de6:	557d                	li	a0,-1
    80004de8:	a005                	j	80004e08 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004dea:	854a                	mv	a0,s2
    80004dec:	ffffe097          	auipc	ra,0xffffe
    80004df0:	2ee080e7          	jalr	750(ra) # 800030da <iunlockput>
  iunlockput(dp);
    80004df4:	8526                	mv	a0,s1
    80004df6:	ffffe097          	auipc	ra,0xffffe
    80004dfa:	2e4080e7          	jalr	740(ra) # 800030da <iunlockput>
  end_op();
    80004dfe:	fffff097          	auipc	ra,0xfffff
    80004e02:	ad4080e7          	jalr	-1324(ra) # 800038d2 <end_op>
  return -1;
    80004e06:	557d                	li	a0,-1
}
    80004e08:	70ae                	ld	ra,232(sp)
    80004e0a:	740e                	ld	s0,224(sp)
    80004e0c:	64ee                	ld	s1,216(sp)
    80004e0e:	694e                	ld	s2,208(sp)
    80004e10:	69ae                	ld	s3,200(sp)
    80004e12:	616d                	addi	sp,sp,240
    80004e14:	8082                	ret

0000000080004e16 <sys_open>:

uint64
sys_open(void)
{
    80004e16:	7131                	addi	sp,sp,-192
    80004e18:	fd06                	sd	ra,184(sp)
    80004e1a:	f922                	sd	s0,176(sp)
    80004e1c:	f526                	sd	s1,168(sp)
    80004e1e:	f14a                	sd	s2,160(sp)
    80004e20:	ed4e                	sd	s3,152(sp)
    80004e22:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004e24:	08000613          	li	a2,128
    80004e28:	f5040593          	addi	a1,s0,-176
    80004e2c:	4501                	li	a0,0
    80004e2e:	ffffd097          	auipc	ra,0xffffd
    80004e32:	35c080e7          	jalr	860(ra) # 8000218a <argstr>
    return -1;
    80004e36:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004e38:	0c054163          	bltz	a0,80004efa <sys_open+0xe4>
    80004e3c:	f4c40593          	addi	a1,s0,-180
    80004e40:	4505                	li	a0,1
    80004e42:	ffffd097          	auipc	ra,0xffffd
    80004e46:	304080e7          	jalr	772(ra) # 80002146 <argint>
    80004e4a:	0a054863          	bltz	a0,80004efa <sys_open+0xe4>

  begin_op();
    80004e4e:	fffff097          	auipc	ra,0xfffff
    80004e52:	a06080e7          	jalr	-1530(ra) # 80003854 <begin_op>

  if(omode & O_CREATE){
    80004e56:	f4c42783          	lw	a5,-180(s0)
    80004e5a:	2007f793          	andi	a5,a5,512
    80004e5e:	cbdd                	beqz	a5,80004f14 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004e60:	4681                	li	a3,0
    80004e62:	4601                	li	a2,0
    80004e64:	4589                	li	a1,2
    80004e66:	f5040513          	addi	a0,s0,-176
    80004e6a:	00000097          	auipc	ra,0x0
    80004e6e:	970080e7          	jalr	-1680(ra) # 800047da <create>
    80004e72:	892a                	mv	s2,a0
    if(ip == 0){
    80004e74:	c959                	beqz	a0,80004f0a <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004e76:	04491703          	lh	a4,68(s2)
    80004e7a:	478d                	li	a5,3
    80004e7c:	00f71763          	bne	a4,a5,80004e8a <sys_open+0x74>
    80004e80:	04695703          	lhu	a4,70(s2)
    80004e84:	47a5                	li	a5,9
    80004e86:	0ce7ec63          	bltu	a5,a4,80004f5e <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004e8a:	fffff097          	auipc	ra,0xfffff
    80004e8e:	dd6080e7          	jalr	-554(ra) # 80003c60 <filealloc>
    80004e92:	89aa                	mv	s3,a0
    80004e94:	10050263          	beqz	a0,80004f98 <sys_open+0x182>
    80004e98:	00000097          	auipc	ra,0x0
    80004e9c:	900080e7          	jalr	-1792(ra) # 80004798 <fdalloc>
    80004ea0:	84aa                	mv	s1,a0
    80004ea2:	0e054663          	bltz	a0,80004f8e <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004ea6:	04491703          	lh	a4,68(s2)
    80004eaa:	478d                	li	a5,3
    80004eac:	0cf70463          	beq	a4,a5,80004f74 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004eb0:	4789                	li	a5,2
    80004eb2:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004eb6:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004eba:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004ebe:	f4c42783          	lw	a5,-180(s0)
    80004ec2:	0017c713          	xori	a4,a5,1
    80004ec6:	8b05                	andi	a4,a4,1
    80004ec8:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004ecc:	0037f713          	andi	a4,a5,3
    80004ed0:	00e03733          	snez	a4,a4
    80004ed4:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004ed8:	4007f793          	andi	a5,a5,1024
    80004edc:	c791                	beqz	a5,80004ee8 <sys_open+0xd2>
    80004ede:	04491703          	lh	a4,68(s2)
    80004ee2:	4789                	li	a5,2
    80004ee4:	08f70f63          	beq	a4,a5,80004f82 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004ee8:	854a                	mv	a0,s2
    80004eea:	ffffe097          	auipc	ra,0xffffe
    80004eee:	050080e7          	jalr	80(ra) # 80002f3a <iunlock>
  end_op();
    80004ef2:	fffff097          	auipc	ra,0xfffff
    80004ef6:	9e0080e7          	jalr	-1568(ra) # 800038d2 <end_op>

  return fd;
}
    80004efa:	8526                	mv	a0,s1
    80004efc:	70ea                	ld	ra,184(sp)
    80004efe:	744a                	ld	s0,176(sp)
    80004f00:	74aa                	ld	s1,168(sp)
    80004f02:	790a                	ld	s2,160(sp)
    80004f04:	69ea                	ld	s3,152(sp)
    80004f06:	6129                	addi	sp,sp,192
    80004f08:	8082                	ret
      end_op();
    80004f0a:	fffff097          	auipc	ra,0xfffff
    80004f0e:	9c8080e7          	jalr	-1592(ra) # 800038d2 <end_op>
      return -1;
    80004f12:	b7e5                	j	80004efa <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004f14:	f5040513          	addi	a0,s0,-176
    80004f18:	ffffe097          	auipc	ra,0xffffe
    80004f1c:	71c080e7          	jalr	1820(ra) # 80003634 <namei>
    80004f20:	892a                	mv	s2,a0
    80004f22:	c905                	beqz	a0,80004f52 <sys_open+0x13c>
    ilock(ip);
    80004f24:	ffffe097          	auipc	ra,0xffffe
    80004f28:	f54080e7          	jalr	-172(ra) # 80002e78 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004f2c:	04491703          	lh	a4,68(s2)
    80004f30:	4785                	li	a5,1
    80004f32:	f4f712e3          	bne	a4,a5,80004e76 <sys_open+0x60>
    80004f36:	f4c42783          	lw	a5,-180(s0)
    80004f3a:	dba1                	beqz	a5,80004e8a <sys_open+0x74>
      iunlockput(ip);
    80004f3c:	854a                	mv	a0,s2
    80004f3e:	ffffe097          	auipc	ra,0xffffe
    80004f42:	19c080e7          	jalr	412(ra) # 800030da <iunlockput>
      end_op();
    80004f46:	fffff097          	auipc	ra,0xfffff
    80004f4a:	98c080e7          	jalr	-1652(ra) # 800038d2 <end_op>
      return -1;
    80004f4e:	54fd                	li	s1,-1
    80004f50:	b76d                	j	80004efa <sys_open+0xe4>
      end_op();
    80004f52:	fffff097          	auipc	ra,0xfffff
    80004f56:	980080e7          	jalr	-1664(ra) # 800038d2 <end_op>
      return -1;
    80004f5a:	54fd                	li	s1,-1
    80004f5c:	bf79                	j	80004efa <sys_open+0xe4>
    iunlockput(ip);
    80004f5e:	854a                	mv	a0,s2
    80004f60:	ffffe097          	auipc	ra,0xffffe
    80004f64:	17a080e7          	jalr	378(ra) # 800030da <iunlockput>
    end_op();
    80004f68:	fffff097          	auipc	ra,0xfffff
    80004f6c:	96a080e7          	jalr	-1686(ra) # 800038d2 <end_op>
    return -1;
    80004f70:	54fd                	li	s1,-1
    80004f72:	b761                	j	80004efa <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004f74:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004f78:	04691783          	lh	a5,70(s2)
    80004f7c:	02f99223          	sh	a5,36(s3)
    80004f80:	bf2d                	j	80004eba <sys_open+0xa4>
    itrunc(ip);
    80004f82:	854a                	mv	a0,s2
    80004f84:	ffffe097          	auipc	ra,0xffffe
    80004f88:	002080e7          	jalr	2(ra) # 80002f86 <itrunc>
    80004f8c:	bfb1                	j	80004ee8 <sys_open+0xd2>
      fileclose(f);
    80004f8e:	854e                	mv	a0,s3
    80004f90:	fffff097          	auipc	ra,0xfffff
    80004f94:	d8c080e7          	jalr	-628(ra) # 80003d1c <fileclose>
    iunlockput(ip);
    80004f98:	854a                	mv	a0,s2
    80004f9a:	ffffe097          	auipc	ra,0xffffe
    80004f9e:	140080e7          	jalr	320(ra) # 800030da <iunlockput>
    end_op();
    80004fa2:	fffff097          	auipc	ra,0xfffff
    80004fa6:	930080e7          	jalr	-1744(ra) # 800038d2 <end_op>
    return -1;
    80004faa:	54fd                	li	s1,-1
    80004fac:	b7b9                	j	80004efa <sys_open+0xe4>

0000000080004fae <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004fae:	7175                	addi	sp,sp,-144
    80004fb0:	e506                	sd	ra,136(sp)
    80004fb2:	e122                	sd	s0,128(sp)
    80004fb4:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004fb6:	fffff097          	auipc	ra,0xfffff
    80004fba:	89e080e7          	jalr	-1890(ra) # 80003854 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004fbe:	08000613          	li	a2,128
    80004fc2:	f7040593          	addi	a1,s0,-144
    80004fc6:	4501                	li	a0,0
    80004fc8:	ffffd097          	auipc	ra,0xffffd
    80004fcc:	1c2080e7          	jalr	450(ra) # 8000218a <argstr>
    80004fd0:	02054963          	bltz	a0,80005002 <sys_mkdir+0x54>
    80004fd4:	4681                	li	a3,0
    80004fd6:	4601                	li	a2,0
    80004fd8:	4585                	li	a1,1
    80004fda:	f7040513          	addi	a0,s0,-144
    80004fde:	fffff097          	auipc	ra,0xfffff
    80004fe2:	7fc080e7          	jalr	2044(ra) # 800047da <create>
    80004fe6:	cd11                	beqz	a0,80005002 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004fe8:	ffffe097          	auipc	ra,0xffffe
    80004fec:	0f2080e7          	jalr	242(ra) # 800030da <iunlockput>
  end_op();
    80004ff0:	fffff097          	auipc	ra,0xfffff
    80004ff4:	8e2080e7          	jalr	-1822(ra) # 800038d2 <end_op>
  return 0;
    80004ff8:	4501                	li	a0,0
}
    80004ffa:	60aa                	ld	ra,136(sp)
    80004ffc:	640a                	ld	s0,128(sp)
    80004ffe:	6149                	addi	sp,sp,144
    80005000:	8082                	ret
    end_op();
    80005002:	fffff097          	auipc	ra,0xfffff
    80005006:	8d0080e7          	jalr	-1840(ra) # 800038d2 <end_op>
    return -1;
    8000500a:	557d                	li	a0,-1
    8000500c:	b7fd                	j	80004ffa <sys_mkdir+0x4c>

000000008000500e <sys_mknod>:

uint64
sys_mknod(void)
{
    8000500e:	7135                	addi	sp,sp,-160
    80005010:	ed06                	sd	ra,152(sp)
    80005012:	e922                	sd	s0,144(sp)
    80005014:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005016:	fffff097          	auipc	ra,0xfffff
    8000501a:	83e080e7          	jalr	-1986(ra) # 80003854 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000501e:	08000613          	li	a2,128
    80005022:	f7040593          	addi	a1,s0,-144
    80005026:	4501                	li	a0,0
    80005028:	ffffd097          	auipc	ra,0xffffd
    8000502c:	162080e7          	jalr	354(ra) # 8000218a <argstr>
    80005030:	04054a63          	bltz	a0,80005084 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80005034:	f6c40593          	addi	a1,s0,-148
    80005038:	4505                	li	a0,1
    8000503a:	ffffd097          	auipc	ra,0xffffd
    8000503e:	10c080e7          	jalr	268(ra) # 80002146 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005042:	04054163          	bltz	a0,80005084 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80005046:	f6840593          	addi	a1,s0,-152
    8000504a:	4509                	li	a0,2
    8000504c:	ffffd097          	auipc	ra,0xffffd
    80005050:	0fa080e7          	jalr	250(ra) # 80002146 <argint>
     argint(1, &major) < 0 ||
    80005054:	02054863          	bltz	a0,80005084 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005058:	f6841683          	lh	a3,-152(s0)
    8000505c:	f6c41603          	lh	a2,-148(s0)
    80005060:	458d                	li	a1,3
    80005062:	f7040513          	addi	a0,s0,-144
    80005066:	fffff097          	auipc	ra,0xfffff
    8000506a:	774080e7          	jalr	1908(ra) # 800047da <create>
     argint(2, &minor) < 0 ||
    8000506e:	c919                	beqz	a0,80005084 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005070:	ffffe097          	auipc	ra,0xffffe
    80005074:	06a080e7          	jalr	106(ra) # 800030da <iunlockput>
  end_op();
    80005078:	fffff097          	auipc	ra,0xfffff
    8000507c:	85a080e7          	jalr	-1958(ra) # 800038d2 <end_op>
  return 0;
    80005080:	4501                	li	a0,0
    80005082:	a031                	j	8000508e <sys_mknod+0x80>
    end_op();
    80005084:	fffff097          	auipc	ra,0xfffff
    80005088:	84e080e7          	jalr	-1970(ra) # 800038d2 <end_op>
    return -1;
    8000508c:	557d                	li	a0,-1
}
    8000508e:	60ea                	ld	ra,152(sp)
    80005090:	644a                	ld	s0,144(sp)
    80005092:	610d                	addi	sp,sp,160
    80005094:	8082                	ret

0000000080005096 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005096:	7135                	addi	sp,sp,-160
    80005098:	ed06                	sd	ra,152(sp)
    8000509a:	e922                	sd	s0,144(sp)
    8000509c:	e526                	sd	s1,136(sp)
    8000509e:	e14a                	sd	s2,128(sp)
    800050a0:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800050a2:	ffffc097          	auipc	ra,0xffffc
    800050a6:	ee4080e7          	jalr	-284(ra) # 80000f86 <myproc>
    800050aa:	892a                	mv	s2,a0
  
  begin_op();
    800050ac:	ffffe097          	auipc	ra,0xffffe
    800050b0:	7a8080e7          	jalr	1960(ra) # 80003854 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800050b4:	08000613          	li	a2,128
    800050b8:	f6040593          	addi	a1,s0,-160
    800050bc:	4501                	li	a0,0
    800050be:	ffffd097          	auipc	ra,0xffffd
    800050c2:	0cc080e7          	jalr	204(ra) # 8000218a <argstr>
    800050c6:	04054b63          	bltz	a0,8000511c <sys_chdir+0x86>
    800050ca:	f6040513          	addi	a0,s0,-160
    800050ce:	ffffe097          	auipc	ra,0xffffe
    800050d2:	566080e7          	jalr	1382(ra) # 80003634 <namei>
    800050d6:	84aa                	mv	s1,a0
    800050d8:	c131                	beqz	a0,8000511c <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    800050da:	ffffe097          	auipc	ra,0xffffe
    800050de:	d9e080e7          	jalr	-610(ra) # 80002e78 <ilock>
  if(ip->type != T_DIR){
    800050e2:	04449703          	lh	a4,68(s1)
    800050e6:	4785                	li	a5,1
    800050e8:	04f71063          	bne	a4,a5,80005128 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800050ec:	8526                	mv	a0,s1
    800050ee:	ffffe097          	auipc	ra,0xffffe
    800050f2:	e4c080e7          	jalr	-436(ra) # 80002f3a <iunlock>
  iput(p->cwd);
    800050f6:	15893503          	ld	a0,344(s2)
    800050fa:	ffffe097          	auipc	ra,0xffffe
    800050fe:	f38080e7          	jalr	-200(ra) # 80003032 <iput>
  end_op();
    80005102:	ffffe097          	auipc	ra,0xffffe
    80005106:	7d0080e7          	jalr	2000(ra) # 800038d2 <end_op>
  p->cwd = ip;
    8000510a:	14993c23          	sd	s1,344(s2)
  return 0;
    8000510e:	4501                	li	a0,0
}
    80005110:	60ea                	ld	ra,152(sp)
    80005112:	644a                	ld	s0,144(sp)
    80005114:	64aa                	ld	s1,136(sp)
    80005116:	690a                	ld	s2,128(sp)
    80005118:	610d                	addi	sp,sp,160
    8000511a:	8082                	ret
    end_op();
    8000511c:	ffffe097          	auipc	ra,0xffffe
    80005120:	7b6080e7          	jalr	1974(ra) # 800038d2 <end_op>
    return -1;
    80005124:	557d                	li	a0,-1
    80005126:	b7ed                	j	80005110 <sys_chdir+0x7a>
    iunlockput(ip);
    80005128:	8526                	mv	a0,s1
    8000512a:	ffffe097          	auipc	ra,0xffffe
    8000512e:	fb0080e7          	jalr	-80(ra) # 800030da <iunlockput>
    end_op();
    80005132:	ffffe097          	auipc	ra,0xffffe
    80005136:	7a0080e7          	jalr	1952(ra) # 800038d2 <end_op>
    return -1;
    8000513a:	557d                	li	a0,-1
    8000513c:	bfd1                	j	80005110 <sys_chdir+0x7a>

000000008000513e <sys_exec>:

uint64
sys_exec(void)
{
    8000513e:	7145                	addi	sp,sp,-464
    80005140:	e786                	sd	ra,456(sp)
    80005142:	e3a2                	sd	s0,448(sp)
    80005144:	ff26                	sd	s1,440(sp)
    80005146:	fb4a                	sd	s2,432(sp)
    80005148:	f74e                	sd	s3,424(sp)
    8000514a:	f352                	sd	s4,416(sp)
    8000514c:	ef56                	sd	s5,408(sp)
    8000514e:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005150:	08000613          	li	a2,128
    80005154:	f4040593          	addi	a1,s0,-192
    80005158:	4501                	li	a0,0
    8000515a:	ffffd097          	auipc	ra,0xffffd
    8000515e:	030080e7          	jalr	48(ra) # 8000218a <argstr>
    return -1;
    80005162:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005164:	0c054b63          	bltz	a0,8000523a <sys_exec+0xfc>
    80005168:	e3840593          	addi	a1,s0,-456
    8000516c:	4505                	li	a0,1
    8000516e:	ffffd097          	auipc	ra,0xffffd
    80005172:	ffa080e7          	jalr	-6(ra) # 80002168 <argaddr>
    80005176:	0c054263          	bltz	a0,8000523a <sys_exec+0xfc>
  }
  memset(argv, 0, sizeof(argv));
    8000517a:	10000613          	li	a2,256
    8000517e:	4581                	li	a1,0
    80005180:	e4040513          	addi	a0,s0,-448
    80005184:	ffffb097          	auipc	ra,0xffffb
    80005188:	040080e7          	jalr	64(ra) # 800001c4 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000518c:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005190:	89a6                	mv	s3,s1
    80005192:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005194:	02000a13          	li	s4,32
    80005198:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000519c:	00391513          	slli	a0,s2,0x3
    800051a0:	e3040593          	addi	a1,s0,-464
    800051a4:	e3843783          	ld	a5,-456(s0)
    800051a8:	953e                	add	a0,a0,a5
    800051aa:	ffffd097          	auipc	ra,0xffffd
    800051ae:	f02080e7          	jalr	-254(ra) # 800020ac <fetchaddr>
    800051b2:	02054a63          	bltz	a0,800051e6 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    800051b6:	e3043783          	ld	a5,-464(s0)
    800051ba:	c3b9                	beqz	a5,80005200 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800051bc:	ffffb097          	auipc	ra,0xffffb
    800051c0:	f5e080e7          	jalr	-162(ra) # 8000011a <kalloc>
    800051c4:	85aa                	mv	a1,a0
    800051c6:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800051ca:	cd11                	beqz	a0,800051e6 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800051cc:	6605                	lui	a2,0x1
    800051ce:	e3043503          	ld	a0,-464(s0)
    800051d2:	ffffd097          	auipc	ra,0xffffd
    800051d6:	f2c080e7          	jalr	-212(ra) # 800020fe <fetchstr>
    800051da:	00054663          	bltz	a0,800051e6 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    800051de:	0905                	addi	s2,s2,1
    800051e0:	09a1                	addi	s3,s3,8
    800051e2:	fb491be3          	bne	s2,s4,80005198 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800051e6:	f4040913          	addi	s2,s0,-192
    800051ea:	6088                	ld	a0,0(s1)
    800051ec:	c531                	beqz	a0,80005238 <sys_exec+0xfa>
    kfree(argv[i]);
    800051ee:	ffffb097          	auipc	ra,0xffffb
    800051f2:	e2e080e7          	jalr	-466(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800051f6:	04a1                	addi	s1,s1,8
    800051f8:	ff2499e3          	bne	s1,s2,800051ea <sys_exec+0xac>
  return -1;
    800051fc:	597d                	li	s2,-1
    800051fe:	a835                	j	8000523a <sys_exec+0xfc>
      argv[i] = 0;
    80005200:	0a8e                	slli	s5,s5,0x3
    80005202:	fc0a8793          	addi	a5,s5,-64 # ffffffffffffefc0 <end+0xffffffff7ffd8d80>
    80005206:	00878ab3          	add	s5,a5,s0
    8000520a:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    8000520e:	e4040593          	addi	a1,s0,-448
    80005212:	f4040513          	addi	a0,s0,-192
    80005216:	fffff097          	auipc	ra,0xfffff
    8000521a:	15a080e7          	jalr	346(ra) # 80004370 <exec>
    8000521e:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005220:	f4040993          	addi	s3,s0,-192
    80005224:	6088                	ld	a0,0(s1)
    80005226:	c911                	beqz	a0,8000523a <sys_exec+0xfc>
    kfree(argv[i]);
    80005228:	ffffb097          	auipc	ra,0xffffb
    8000522c:	df4080e7          	jalr	-524(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005230:	04a1                	addi	s1,s1,8
    80005232:	ff3499e3          	bne	s1,s3,80005224 <sys_exec+0xe6>
    80005236:	a011                	j	8000523a <sys_exec+0xfc>
  return -1;
    80005238:	597d                	li	s2,-1
}
    8000523a:	854a                	mv	a0,s2
    8000523c:	60be                	ld	ra,456(sp)
    8000523e:	641e                	ld	s0,448(sp)
    80005240:	74fa                	ld	s1,440(sp)
    80005242:	795a                	ld	s2,432(sp)
    80005244:	79ba                	ld	s3,424(sp)
    80005246:	7a1a                	ld	s4,416(sp)
    80005248:	6afa                	ld	s5,408(sp)
    8000524a:	6179                	addi	sp,sp,464
    8000524c:	8082                	ret

000000008000524e <sys_pipe>:

uint64
sys_pipe(void)
{
    8000524e:	7139                	addi	sp,sp,-64
    80005250:	fc06                	sd	ra,56(sp)
    80005252:	f822                	sd	s0,48(sp)
    80005254:	f426                	sd	s1,40(sp)
    80005256:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005258:	ffffc097          	auipc	ra,0xffffc
    8000525c:	d2e080e7          	jalr	-722(ra) # 80000f86 <myproc>
    80005260:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005262:	fd840593          	addi	a1,s0,-40
    80005266:	4501                	li	a0,0
    80005268:	ffffd097          	auipc	ra,0xffffd
    8000526c:	f00080e7          	jalr	-256(ra) # 80002168 <argaddr>
    return -1;
    80005270:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005272:	0e054063          	bltz	a0,80005352 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005276:	fc840593          	addi	a1,s0,-56
    8000527a:	fd040513          	addi	a0,s0,-48
    8000527e:	fffff097          	auipc	ra,0xfffff
    80005282:	dce080e7          	jalr	-562(ra) # 8000404c <pipealloc>
    return -1;
    80005286:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005288:	0c054563          	bltz	a0,80005352 <sys_pipe+0x104>
  fd0 = -1;
    8000528c:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005290:	fd043503          	ld	a0,-48(s0)
    80005294:	fffff097          	auipc	ra,0xfffff
    80005298:	504080e7          	jalr	1284(ra) # 80004798 <fdalloc>
    8000529c:	fca42223          	sw	a0,-60(s0)
    800052a0:	08054c63          	bltz	a0,80005338 <sys_pipe+0xea>
    800052a4:	fc843503          	ld	a0,-56(s0)
    800052a8:	fffff097          	auipc	ra,0xfffff
    800052ac:	4f0080e7          	jalr	1264(ra) # 80004798 <fdalloc>
    800052b0:	fca42023          	sw	a0,-64(s0)
    800052b4:	06054963          	bltz	a0,80005326 <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800052b8:	4691                	li	a3,4
    800052ba:	fc440613          	addi	a2,s0,-60
    800052be:	fd843583          	ld	a1,-40(s0)
    800052c2:	68a8                	ld	a0,80(s1)
    800052c4:	ffffc097          	auipc	ra,0xffffc
    800052c8:	88e080e7          	jalr	-1906(ra) # 80000b52 <copyout>
    800052cc:	02054063          	bltz	a0,800052ec <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800052d0:	4691                	li	a3,4
    800052d2:	fc040613          	addi	a2,s0,-64
    800052d6:	fd843583          	ld	a1,-40(s0)
    800052da:	0591                	addi	a1,a1,4
    800052dc:	68a8                	ld	a0,80(s1)
    800052de:	ffffc097          	auipc	ra,0xffffc
    800052e2:	874080e7          	jalr	-1932(ra) # 80000b52 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800052e6:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800052e8:	06055563          	bgez	a0,80005352 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    800052ec:	fc442783          	lw	a5,-60(s0)
    800052f0:	07e9                	addi	a5,a5,26
    800052f2:	078e                	slli	a5,a5,0x3
    800052f4:	97a6                	add	a5,a5,s1
    800052f6:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    800052fa:	fc042783          	lw	a5,-64(s0)
    800052fe:	07e9                	addi	a5,a5,26
    80005300:	078e                	slli	a5,a5,0x3
    80005302:	00f48533          	add	a0,s1,a5
    80005306:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    8000530a:	fd043503          	ld	a0,-48(s0)
    8000530e:	fffff097          	auipc	ra,0xfffff
    80005312:	a0e080e7          	jalr	-1522(ra) # 80003d1c <fileclose>
    fileclose(wf);
    80005316:	fc843503          	ld	a0,-56(s0)
    8000531a:	fffff097          	auipc	ra,0xfffff
    8000531e:	a02080e7          	jalr	-1534(ra) # 80003d1c <fileclose>
    return -1;
    80005322:	57fd                	li	a5,-1
    80005324:	a03d                	j	80005352 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005326:	fc442783          	lw	a5,-60(s0)
    8000532a:	0007c763          	bltz	a5,80005338 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    8000532e:	07e9                	addi	a5,a5,26
    80005330:	078e                	slli	a5,a5,0x3
    80005332:	97a6                	add	a5,a5,s1
    80005334:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    80005338:	fd043503          	ld	a0,-48(s0)
    8000533c:	fffff097          	auipc	ra,0xfffff
    80005340:	9e0080e7          	jalr	-1568(ra) # 80003d1c <fileclose>
    fileclose(wf);
    80005344:	fc843503          	ld	a0,-56(s0)
    80005348:	fffff097          	auipc	ra,0xfffff
    8000534c:	9d4080e7          	jalr	-1580(ra) # 80003d1c <fileclose>
    return -1;
    80005350:	57fd                	li	a5,-1
}
    80005352:	853e                	mv	a0,a5
    80005354:	70e2                	ld	ra,56(sp)
    80005356:	7442                	ld	s0,48(sp)
    80005358:	74a2                	ld	s1,40(sp)
    8000535a:	6121                	addi	sp,sp,64
    8000535c:	8082                	ret
	...

0000000080005360 <kernelvec>:
    80005360:	7111                	addi	sp,sp,-256
    80005362:	e006                	sd	ra,0(sp)
    80005364:	e40a                	sd	sp,8(sp)
    80005366:	e80e                	sd	gp,16(sp)
    80005368:	ec12                	sd	tp,24(sp)
    8000536a:	f016                	sd	t0,32(sp)
    8000536c:	f41a                	sd	t1,40(sp)
    8000536e:	f81e                	sd	t2,48(sp)
    80005370:	fc22                	sd	s0,56(sp)
    80005372:	e0a6                	sd	s1,64(sp)
    80005374:	e4aa                	sd	a0,72(sp)
    80005376:	e8ae                	sd	a1,80(sp)
    80005378:	ecb2                	sd	a2,88(sp)
    8000537a:	f0b6                	sd	a3,96(sp)
    8000537c:	f4ba                	sd	a4,104(sp)
    8000537e:	f8be                	sd	a5,112(sp)
    80005380:	fcc2                	sd	a6,120(sp)
    80005382:	e146                	sd	a7,128(sp)
    80005384:	e54a                	sd	s2,136(sp)
    80005386:	e94e                	sd	s3,144(sp)
    80005388:	ed52                	sd	s4,152(sp)
    8000538a:	f156                	sd	s5,160(sp)
    8000538c:	f55a                	sd	s6,168(sp)
    8000538e:	f95e                	sd	s7,176(sp)
    80005390:	fd62                	sd	s8,184(sp)
    80005392:	e1e6                	sd	s9,192(sp)
    80005394:	e5ea                	sd	s10,200(sp)
    80005396:	e9ee                	sd	s11,208(sp)
    80005398:	edf2                	sd	t3,216(sp)
    8000539a:	f1f6                	sd	t4,224(sp)
    8000539c:	f5fa                	sd	t5,232(sp)
    8000539e:	f9fe                	sd	t6,240(sp)
    800053a0:	bd9fc0ef          	jal	ra,80001f78 <kerneltrap>
    800053a4:	6082                	ld	ra,0(sp)
    800053a6:	6122                	ld	sp,8(sp)
    800053a8:	61c2                	ld	gp,16(sp)
    800053aa:	7282                	ld	t0,32(sp)
    800053ac:	7322                	ld	t1,40(sp)
    800053ae:	73c2                	ld	t2,48(sp)
    800053b0:	7462                	ld	s0,56(sp)
    800053b2:	6486                	ld	s1,64(sp)
    800053b4:	6526                	ld	a0,72(sp)
    800053b6:	65c6                	ld	a1,80(sp)
    800053b8:	6666                	ld	a2,88(sp)
    800053ba:	7686                	ld	a3,96(sp)
    800053bc:	7726                	ld	a4,104(sp)
    800053be:	77c6                	ld	a5,112(sp)
    800053c0:	7866                	ld	a6,120(sp)
    800053c2:	688a                	ld	a7,128(sp)
    800053c4:	692a                	ld	s2,136(sp)
    800053c6:	69ca                	ld	s3,144(sp)
    800053c8:	6a6a                	ld	s4,152(sp)
    800053ca:	7a8a                	ld	s5,160(sp)
    800053cc:	7b2a                	ld	s6,168(sp)
    800053ce:	7bca                	ld	s7,176(sp)
    800053d0:	7c6a                	ld	s8,184(sp)
    800053d2:	6c8e                	ld	s9,192(sp)
    800053d4:	6d2e                	ld	s10,200(sp)
    800053d6:	6dce                	ld	s11,208(sp)
    800053d8:	6e6e                	ld	t3,216(sp)
    800053da:	7e8e                	ld	t4,224(sp)
    800053dc:	7f2e                	ld	t5,232(sp)
    800053de:	7fce                	ld	t6,240(sp)
    800053e0:	6111                	addi	sp,sp,256
    800053e2:	10200073          	sret
    800053e6:	00000013          	nop
    800053ea:	00000013          	nop
    800053ee:	0001                	nop

00000000800053f0 <timervec>:
    800053f0:	34051573          	csrrw	a0,mscratch,a0
    800053f4:	e10c                	sd	a1,0(a0)
    800053f6:	e510                	sd	a2,8(a0)
    800053f8:	e914                	sd	a3,16(a0)
    800053fa:	6d0c                	ld	a1,24(a0)
    800053fc:	7110                	ld	a2,32(a0)
    800053fe:	6194                	ld	a3,0(a1)
    80005400:	96b2                	add	a3,a3,a2
    80005402:	e194                	sd	a3,0(a1)
    80005404:	4589                	li	a1,2
    80005406:	14459073          	csrw	sip,a1
    8000540a:	6914                	ld	a3,16(a0)
    8000540c:	6510                	ld	a2,8(a0)
    8000540e:	610c                	ld	a1,0(a0)
    80005410:	34051573          	csrrw	a0,mscratch,a0
    80005414:	30200073          	mret
	...

000000008000541a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000541a:	1141                	addi	sp,sp,-16
    8000541c:	e422                	sd	s0,8(sp)
    8000541e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005420:	0c0007b7          	lui	a5,0xc000
    80005424:	4705                	li	a4,1
    80005426:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005428:	c3d8                	sw	a4,4(a5)
}
    8000542a:	6422                	ld	s0,8(sp)
    8000542c:	0141                	addi	sp,sp,16
    8000542e:	8082                	ret

0000000080005430 <plicinithart>:

void
plicinithart(void)
{
    80005430:	1141                	addi	sp,sp,-16
    80005432:	e406                	sd	ra,8(sp)
    80005434:	e022                	sd	s0,0(sp)
    80005436:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005438:	ffffc097          	auipc	ra,0xffffc
    8000543c:	b22080e7          	jalr	-1246(ra) # 80000f5a <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005440:	0085171b          	slliw	a4,a0,0x8
    80005444:	0c0027b7          	lui	a5,0xc002
    80005448:	97ba                	add	a5,a5,a4
    8000544a:	40200713          	li	a4,1026
    8000544e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005452:	00d5151b          	slliw	a0,a0,0xd
    80005456:	0c2017b7          	lui	a5,0xc201
    8000545a:	97aa                	add	a5,a5,a0
    8000545c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005460:	60a2                	ld	ra,8(sp)
    80005462:	6402                	ld	s0,0(sp)
    80005464:	0141                	addi	sp,sp,16
    80005466:	8082                	ret

0000000080005468 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005468:	1141                	addi	sp,sp,-16
    8000546a:	e406                	sd	ra,8(sp)
    8000546c:	e022                	sd	s0,0(sp)
    8000546e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005470:	ffffc097          	auipc	ra,0xffffc
    80005474:	aea080e7          	jalr	-1302(ra) # 80000f5a <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005478:	00d5151b          	slliw	a0,a0,0xd
    8000547c:	0c2017b7          	lui	a5,0xc201
    80005480:	97aa                	add	a5,a5,a0
  return irq;
}
    80005482:	43c8                	lw	a0,4(a5)
    80005484:	60a2                	ld	ra,8(sp)
    80005486:	6402                	ld	s0,0(sp)
    80005488:	0141                	addi	sp,sp,16
    8000548a:	8082                	ret

000000008000548c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000548c:	1101                	addi	sp,sp,-32
    8000548e:	ec06                	sd	ra,24(sp)
    80005490:	e822                	sd	s0,16(sp)
    80005492:	e426                	sd	s1,8(sp)
    80005494:	1000                	addi	s0,sp,32
    80005496:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005498:	ffffc097          	auipc	ra,0xffffc
    8000549c:	ac2080e7          	jalr	-1342(ra) # 80000f5a <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800054a0:	00d5151b          	slliw	a0,a0,0xd
    800054a4:	0c2017b7          	lui	a5,0xc201
    800054a8:	97aa                	add	a5,a5,a0
    800054aa:	c3c4                	sw	s1,4(a5)
}
    800054ac:	60e2                	ld	ra,24(sp)
    800054ae:	6442                	ld	s0,16(sp)
    800054b0:	64a2                	ld	s1,8(sp)
    800054b2:	6105                	addi	sp,sp,32
    800054b4:	8082                	ret

00000000800054b6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800054b6:	1141                	addi	sp,sp,-16
    800054b8:	e406                	sd	ra,8(sp)
    800054ba:	e022                	sd	s0,0(sp)
    800054bc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800054be:	479d                	li	a5,7
    800054c0:	06a7c863          	blt	a5,a0,80005530 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    800054c4:	00016717          	auipc	a4,0x16
    800054c8:	b3c70713          	addi	a4,a4,-1220 # 8001b000 <disk>
    800054cc:	972a                	add	a4,a4,a0
    800054ce:	6789                	lui	a5,0x2
    800054d0:	97ba                	add	a5,a5,a4
    800054d2:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    800054d6:	e7ad                	bnez	a5,80005540 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800054d8:	00451793          	slli	a5,a0,0x4
    800054dc:	00018717          	auipc	a4,0x18
    800054e0:	b2470713          	addi	a4,a4,-1244 # 8001d000 <disk+0x2000>
    800054e4:	6314                	ld	a3,0(a4)
    800054e6:	96be                	add	a3,a3,a5
    800054e8:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800054ec:	6314                	ld	a3,0(a4)
    800054ee:	96be                	add	a3,a3,a5
    800054f0:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    800054f4:	6314                	ld	a3,0(a4)
    800054f6:	96be                	add	a3,a3,a5
    800054f8:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    800054fc:	6318                	ld	a4,0(a4)
    800054fe:	97ba                	add	a5,a5,a4
    80005500:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005504:	00016717          	auipc	a4,0x16
    80005508:	afc70713          	addi	a4,a4,-1284 # 8001b000 <disk>
    8000550c:	972a                	add	a4,a4,a0
    8000550e:	6789                	lui	a5,0x2
    80005510:	97ba                	add	a5,a5,a4
    80005512:	4705                	li	a4,1
    80005514:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80005518:	00018517          	auipc	a0,0x18
    8000551c:	b0050513          	addi	a0,a0,-1280 # 8001d018 <disk+0x2018>
    80005520:	ffffc097          	auipc	ra,0xffffc
    80005524:	36c080e7          	jalr	876(ra) # 8000188c <wakeup>
}
    80005528:	60a2                	ld	ra,8(sp)
    8000552a:	6402                	ld	s0,0(sp)
    8000552c:	0141                	addi	sp,sp,16
    8000552e:	8082                	ret
    panic("free_desc 1");
    80005530:	00003517          	auipc	a0,0x3
    80005534:	3c850513          	addi	a0,a0,968 # 800088f8 <syscalls_name+0x338>
    80005538:	00001097          	auipc	ra,0x1
    8000553c:	9c8080e7          	jalr	-1592(ra) # 80005f00 <panic>
    panic("free_desc 2");
    80005540:	00003517          	auipc	a0,0x3
    80005544:	3c850513          	addi	a0,a0,968 # 80008908 <syscalls_name+0x348>
    80005548:	00001097          	auipc	ra,0x1
    8000554c:	9b8080e7          	jalr	-1608(ra) # 80005f00 <panic>

0000000080005550 <virtio_disk_init>:
{
    80005550:	1101                	addi	sp,sp,-32
    80005552:	ec06                	sd	ra,24(sp)
    80005554:	e822                	sd	s0,16(sp)
    80005556:	e426                	sd	s1,8(sp)
    80005558:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    8000555a:	00003597          	auipc	a1,0x3
    8000555e:	3be58593          	addi	a1,a1,958 # 80008918 <syscalls_name+0x358>
    80005562:	00018517          	auipc	a0,0x18
    80005566:	bc650513          	addi	a0,a0,-1082 # 8001d128 <disk+0x2128>
    8000556a:	00001097          	auipc	ra,0x1
    8000556e:	e3e080e7          	jalr	-450(ra) # 800063a8 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005572:	100017b7          	lui	a5,0x10001
    80005576:	4398                	lw	a4,0(a5)
    80005578:	2701                	sext.w	a4,a4
    8000557a:	747277b7          	lui	a5,0x74727
    8000557e:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005582:	0ef71063          	bne	a4,a5,80005662 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005586:	100017b7          	lui	a5,0x10001
    8000558a:	43dc                	lw	a5,4(a5)
    8000558c:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000558e:	4705                	li	a4,1
    80005590:	0ce79963          	bne	a5,a4,80005662 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005594:	100017b7          	lui	a5,0x10001
    80005598:	479c                	lw	a5,8(a5)
    8000559a:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    8000559c:	4709                	li	a4,2
    8000559e:	0ce79263          	bne	a5,a4,80005662 <virtio_disk_init+0x112>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800055a2:	100017b7          	lui	a5,0x10001
    800055a6:	47d8                	lw	a4,12(a5)
    800055a8:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800055aa:	554d47b7          	lui	a5,0x554d4
    800055ae:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800055b2:	0af71863          	bne	a4,a5,80005662 <virtio_disk_init+0x112>
  *R(VIRTIO_MMIO_STATUS) = status;
    800055b6:	100017b7          	lui	a5,0x10001
    800055ba:	4705                	li	a4,1
    800055bc:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800055be:	470d                	li	a4,3
    800055c0:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800055c2:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800055c4:	c7ffe6b7          	lui	a3,0xc7ffe
    800055c8:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fd851f>
    800055cc:	8f75                	and	a4,a4,a3
    800055ce:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800055d0:	472d                	li	a4,11
    800055d2:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800055d4:	473d                	li	a4,15
    800055d6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    800055d8:	6705                	lui	a4,0x1
    800055da:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800055dc:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800055e0:	5bdc                	lw	a5,52(a5)
    800055e2:	2781                	sext.w	a5,a5
  if(max == 0)
    800055e4:	c7d9                	beqz	a5,80005672 <virtio_disk_init+0x122>
  if(max < NUM)
    800055e6:	471d                	li	a4,7
    800055e8:	08f77d63          	bgeu	a4,a5,80005682 <virtio_disk_init+0x132>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800055ec:	100014b7          	lui	s1,0x10001
    800055f0:	47a1                	li	a5,8
    800055f2:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    800055f4:	6609                	lui	a2,0x2
    800055f6:	4581                	li	a1,0
    800055f8:	00016517          	auipc	a0,0x16
    800055fc:	a0850513          	addi	a0,a0,-1528 # 8001b000 <disk>
    80005600:	ffffb097          	auipc	ra,0xffffb
    80005604:	bc4080e7          	jalr	-1084(ra) # 800001c4 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005608:	00016717          	auipc	a4,0x16
    8000560c:	9f870713          	addi	a4,a4,-1544 # 8001b000 <disk>
    80005610:	00c75793          	srli	a5,a4,0xc
    80005614:	2781                	sext.w	a5,a5
    80005616:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    80005618:	00018797          	auipc	a5,0x18
    8000561c:	9e878793          	addi	a5,a5,-1560 # 8001d000 <disk+0x2000>
    80005620:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005622:	00016717          	auipc	a4,0x16
    80005626:	a5e70713          	addi	a4,a4,-1442 # 8001b080 <disk+0x80>
    8000562a:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    8000562c:	00017717          	auipc	a4,0x17
    80005630:	9d470713          	addi	a4,a4,-1580 # 8001c000 <disk+0x1000>
    80005634:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005636:	4705                	li	a4,1
    80005638:	00e78c23          	sb	a4,24(a5)
    8000563c:	00e78ca3          	sb	a4,25(a5)
    80005640:	00e78d23          	sb	a4,26(a5)
    80005644:	00e78da3          	sb	a4,27(a5)
    80005648:	00e78e23          	sb	a4,28(a5)
    8000564c:	00e78ea3          	sb	a4,29(a5)
    80005650:	00e78f23          	sb	a4,30(a5)
    80005654:	00e78fa3          	sb	a4,31(a5)
}
    80005658:	60e2                	ld	ra,24(sp)
    8000565a:	6442                	ld	s0,16(sp)
    8000565c:	64a2                	ld	s1,8(sp)
    8000565e:	6105                	addi	sp,sp,32
    80005660:	8082                	ret
    panic("could not find virtio disk");
    80005662:	00003517          	auipc	a0,0x3
    80005666:	2c650513          	addi	a0,a0,710 # 80008928 <syscalls_name+0x368>
    8000566a:	00001097          	auipc	ra,0x1
    8000566e:	896080e7          	jalr	-1898(ra) # 80005f00 <panic>
    panic("virtio disk has no queue 0");
    80005672:	00003517          	auipc	a0,0x3
    80005676:	2d650513          	addi	a0,a0,726 # 80008948 <syscalls_name+0x388>
    8000567a:	00001097          	auipc	ra,0x1
    8000567e:	886080e7          	jalr	-1914(ra) # 80005f00 <panic>
    panic("virtio disk max queue too short");
    80005682:	00003517          	auipc	a0,0x3
    80005686:	2e650513          	addi	a0,a0,742 # 80008968 <syscalls_name+0x3a8>
    8000568a:	00001097          	auipc	ra,0x1
    8000568e:	876080e7          	jalr	-1930(ra) # 80005f00 <panic>

0000000080005692 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005692:	7119                	addi	sp,sp,-128
    80005694:	fc86                	sd	ra,120(sp)
    80005696:	f8a2                	sd	s0,112(sp)
    80005698:	f4a6                	sd	s1,104(sp)
    8000569a:	f0ca                	sd	s2,96(sp)
    8000569c:	ecce                	sd	s3,88(sp)
    8000569e:	e8d2                	sd	s4,80(sp)
    800056a0:	e4d6                	sd	s5,72(sp)
    800056a2:	e0da                	sd	s6,64(sp)
    800056a4:	fc5e                	sd	s7,56(sp)
    800056a6:	f862                	sd	s8,48(sp)
    800056a8:	f466                	sd	s9,40(sp)
    800056aa:	f06a                	sd	s10,32(sp)
    800056ac:	ec6e                	sd	s11,24(sp)
    800056ae:	0100                	addi	s0,sp,128
    800056b0:	8aaa                	mv	s5,a0
    800056b2:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800056b4:	00c52c83          	lw	s9,12(a0)
    800056b8:	001c9c9b          	slliw	s9,s9,0x1
    800056bc:	1c82                	slli	s9,s9,0x20
    800056be:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800056c2:	00018517          	auipc	a0,0x18
    800056c6:	a6650513          	addi	a0,a0,-1434 # 8001d128 <disk+0x2128>
    800056ca:	00001097          	auipc	ra,0x1
    800056ce:	d6e080e7          	jalr	-658(ra) # 80006438 <acquire>
  for(int i = 0; i < 3; i++){
    800056d2:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800056d4:	44a1                	li	s1,8
      disk.free[i] = 0;
    800056d6:	00016c17          	auipc	s8,0x16
    800056da:	92ac0c13          	addi	s8,s8,-1750 # 8001b000 <disk>
    800056de:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    800056e0:	4b0d                	li	s6,3
    800056e2:	a0ad                	j	8000574c <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    800056e4:	00fc0733          	add	a4,s8,a5
    800056e8:	975e                	add	a4,a4,s7
    800056ea:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800056ee:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800056f0:	0207c563          	bltz	a5,8000571a <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    800056f4:	2905                	addiw	s2,s2,1
    800056f6:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    800056f8:	19690c63          	beq	s2,s6,80005890 <virtio_disk_rw+0x1fe>
    idx[i] = alloc_desc();
    800056fc:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800056fe:	00018717          	auipc	a4,0x18
    80005702:	91a70713          	addi	a4,a4,-1766 # 8001d018 <disk+0x2018>
    80005706:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005708:	00074683          	lbu	a3,0(a4)
    8000570c:	fee1                	bnez	a3,800056e4 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    8000570e:	2785                	addiw	a5,a5,1
    80005710:	0705                	addi	a4,a4,1
    80005712:	fe979be3          	bne	a5,s1,80005708 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80005716:	57fd                	li	a5,-1
    80005718:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    8000571a:	01205d63          	blez	s2,80005734 <virtio_disk_rw+0xa2>
    8000571e:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80005720:	000a2503          	lw	a0,0(s4)
    80005724:	00000097          	auipc	ra,0x0
    80005728:	d92080e7          	jalr	-622(ra) # 800054b6 <free_desc>
      for(int j = 0; j < i; j++)
    8000572c:	2d85                	addiw	s11,s11,1
    8000572e:	0a11                	addi	s4,s4,4
    80005730:	ff2d98e3          	bne	s11,s2,80005720 <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005734:	00018597          	auipc	a1,0x18
    80005738:	9f458593          	addi	a1,a1,-1548 # 8001d128 <disk+0x2128>
    8000573c:	00018517          	auipc	a0,0x18
    80005740:	8dc50513          	addi	a0,a0,-1828 # 8001d018 <disk+0x2018>
    80005744:	ffffc097          	auipc	ra,0xffffc
    80005748:	fbc080e7          	jalr	-68(ra) # 80001700 <sleep>
  for(int i = 0; i < 3; i++){
    8000574c:	f8040a13          	addi	s4,s0,-128
{
    80005750:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80005752:	894e                	mv	s2,s3
    80005754:	b765                	j	800056fc <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005756:	00018697          	auipc	a3,0x18
    8000575a:	8aa6b683          	ld	a3,-1878(a3) # 8001d000 <disk+0x2000>
    8000575e:	96ba                	add	a3,a3,a4
    80005760:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005764:	00016817          	auipc	a6,0x16
    80005768:	89c80813          	addi	a6,a6,-1892 # 8001b000 <disk>
    8000576c:	00018697          	auipc	a3,0x18
    80005770:	89468693          	addi	a3,a3,-1900 # 8001d000 <disk+0x2000>
    80005774:	6290                	ld	a2,0(a3)
    80005776:	963a                	add	a2,a2,a4
    80005778:	00c65583          	lhu	a1,12(a2)
    8000577c:	0015e593          	ori	a1,a1,1
    80005780:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    80005784:	f8842603          	lw	a2,-120(s0)
    80005788:	628c                	ld	a1,0(a3)
    8000578a:	972e                	add	a4,a4,a1
    8000578c:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005790:	20050593          	addi	a1,a0,512
    80005794:	0592                	slli	a1,a1,0x4
    80005796:	95c2                	add	a1,a1,a6
    80005798:	577d                	li	a4,-1
    8000579a:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000579e:	00461713          	slli	a4,a2,0x4
    800057a2:	6290                	ld	a2,0(a3)
    800057a4:	963a                	add	a2,a2,a4
    800057a6:	03078793          	addi	a5,a5,48
    800057aa:	97c2                	add	a5,a5,a6
    800057ac:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    800057ae:	629c                	ld	a5,0(a3)
    800057b0:	97ba                	add	a5,a5,a4
    800057b2:	4605                	li	a2,1
    800057b4:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800057b6:	629c                	ld	a5,0(a3)
    800057b8:	97ba                	add	a5,a5,a4
    800057ba:	4809                	li	a6,2
    800057bc:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    800057c0:	629c                	ld	a5,0(a3)
    800057c2:	97ba                	add	a5,a5,a4
    800057c4:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800057c8:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    800057cc:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800057d0:	6698                	ld	a4,8(a3)
    800057d2:	00275783          	lhu	a5,2(a4)
    800057d6:	8b9d                	andi	a5,a5,7
    800057d8:	0786                	slli	a5,a5,0x1
    800057da:	973e                	add	a4,a4,a5
    800057dc:	00a71223          	sh	a0,4(a4)

  __sync_synchronize();
    800057e0:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800057e4:	6698                	ld	a4,8(a3)
    800057e6:	00275783          	lhu	a5,2(a4)
    800057ea:	2785                	addiw	a5,a5,1
    800057ec:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800057f0:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800057f4:	100017b7          	lui	a5,0x10001
    800057f8:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800057fc:	004aa783          	lw	a5,4(s5)
    80005800:	02c79163          	bne	a5,a2,80005822 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    80005804:	00018917          	auipc	s2,0x18
    80005808:	92490913          	addi	s2,s2,-1756 # 8001d128 <disk+0x2128>
  while(b->disk == 1) {
    8000580c:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    8000580e:	85ca                	mv	a1,s2
    80005810:	8556                	mv	a0,s5
    80005812:	ffffc097          	auipc	ra,0xffffc
    80005816:	eee080e7          	jalr	-274(ra) # 80001700 <sleep>
  while(b->disk == 1) {
    8000581a:	004aa783          	lw	a5,4(s5)
    8000581e:	fe9788e3          	beq	a5,s1,8000580e <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    80005822:	f8042903          	lw	s2,-128(s0)
    80005826:	20090713          	addi	a4,s2,512
    8000582a:	0712                	slli	a4,a4,0x4
    8000582c:	00015797          	auipc	a5,0x15
    80005830:	7d478793          	addi	a5,a5,2004 # 8001b000 <disk>
    80005834:	97ba                	add	a5,a5,a4
    80005836:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    8000583a:	00017997          	auipc	s3,0x17
    8000583e:	7c698993          	addi	s3,s3,1990 # 8001d000 <disk+0x2000>
    80005842:	00491713          	slli	a4,s2,0x4
    80005846:	0009b783          	ld	a5,0(s3)
    8000584a:	97ba                	add	a5,a5,a4
    8000584c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005850:	854a                	mv	a0,s2
    80005852:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005856:	00000097          	auipc	ra,0x0
    8000585a:	c60080e7          	jalr	-928(ra) # 800054b6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000585e:	8885                	andi	s1,s1,1
    80005860:	f0ed                	bnez	s1,80005842 <virtio_disk_rw+0x1b0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005862:	00018517          	auipc	a0,0x18
    80005866:	8c650513          	addi	a0,a0,-1850 # 8001d128 <disk+0x2128>
    8000586a:	00001097          	auipc	ra,0x1
    8000586e:	c82080e7          	jalr	-894(ra) # 800064ec <release>
}
    80005872:	70e6                	ld	ra,120(sp)
    80005874:	7446                	ld	s0,112(sp)
    80005876:	74a6                	ld	s1,104(sp)
    80005878:	7906                	ld	s2,96(sp)
    8000587a:	69e6                	ld	s3,88(sp)
    8000587c:	6a46                	ld	s4,80(sp)
    8000587e:	6aa6                	ld	s5,72(sp)
    80005880:	6b06                	ld	s6,64(sp)
    80005882:	7be2                	ld	s7,56(sp)
    80005884:	7c42                	ld	s8,48(sp)
    80005886:	7ca2                	ld	s9,40(sp)
    80005888:	7d02                	ld	s10,32(sp)
    8000588a:	6de2                	ld	s11,24(sp)
    8000588c:	6109                	addi	sp,sp,128
    8000588e:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005890:	f8042503          	lw	a0,-128(s0)
    80005894:	20050793          	addi	a5,a0,512
    80005898:	0792                	slli	a5,a5,0x4
  if(write)
    8000589a:	00015817          	auipc	a6,0x15
    8000589e:	76680813          	addi	a6,a6,1894 # 8001b000 <disk>
    800058a2:	00f80733          	add	a4,a6,a5
    800058a6:	01a036b3          	snez	a3,s10
    800058aa:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    800058ae:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    800058b2:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    800058b6:	7679                	lui	a2,0xffffe
    800058b8:	963e                	add	a2,a2,a5
    800058ba:	00017697          	auipc	a3,0x17
    800058be:	74668693          	addi	a3,a3,1862 # 8001d000 <disk+0x2000>
    800058c2:	6298                	ld	a4,0(a3)
    800058c4:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800058c6:	0a878593          	addi	a1,a5,168
    800058ca:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    800058cc:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800058ce:	6298                	ld	a4,0(a3)
    800058d0:	9732                	add	a4,a4,a2
    800058d2:	45c1                	li	a1,16
    800058d4:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800058d6:	6298                	ld	a4,0(a3)
    800058d8:	9732                	add	a4,a4,a2
    800058da:	4585                	li	a1,1
    800058dc:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    800058e0:	f8442703          	lw	a4,-124(s0)
    800058e4:	628c                	ld	a1,0(a3)
    800058e6:	962e                	add	a2,a2,a1
    800058e8:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd7dce>
  disk.desc[idx[1]].addr = (uint64) b->data;
    800058ec:	0712                	slli	a4,a4,0x4
    800058ee:	6290                	ld	a2,0(a3)
    800058f0:	963a                	add	a2,a2,a4
    800058f2:	058a8593          	addi	a1,s5,88
    800058f6:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800058f8:	6294                	ld	a3,0(a3)
    800058fa:	96ba                	add	a3,a3,a4
    800058fc:	40000613          	li	a2,1024
    80005900:	c690                	sw	a2,8(a3)
  if(write)
    80005902:	e40d1ae3          	bnez	s10,80005756 <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005906:	00017697          	auipc	a3,0x17
    8000590a:	6fa6b683          	ld	a3,1786(a3) # 8001d000 <disk+0x2000>
    8000590e:	96ba                	add	a3,a3,a4
    80005910:	4609                	li	a2,2
    80005912:	00c69623          	sh	a2,12(a3)
    80005916:	b5b9                	j	80005764 <virtio_disk_rw+0xd2>

0000000080005918 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005918:	1101                	addi	sp,sp,-32
    8000591a:	ec06                	sd	ra,24(sp)
    8000591c:	e822                	sd	s0,16(sp)
    8000591e:	e426                	sd	s1,8(sp)
    80005920:	e04a                	sd	s2,0(sp)
    80005922:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005924:	00018517          	auipc	a0,0x18
    80005928:	80450513          	addi	a0,a0,-2044 # 8001d128 <disk+0x2128>
    8000592c:	00001097          	auipc	ra,0x1
    80005930:	b0c080e7          	jalr	-1268(ra) # 80006438 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005934:	10001737          	lui	a4,0x10001
    80005938:	533c                	lw	a5,96(a4)
    8000593a:	8b8d                	andi	a5,a5,3
    8000593c:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000593e:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005942:	00017797          	auipc	a5,0x17
    80005946:	6be78793          	addi	a5,a5,1726 # 8001d000 <disk+0x2000>
    8000594a:	6b94                	ld	a3,16(a5)
    8000594c:	0207d703          	lhu	a4,32(a5)
    80005950:	0026d783          	lhu	a5,2(a3)
    80005954:	06f70163          	beq	a4,a5,800059b6 <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005958:	00015917          	auipc	s2,0x15
    8000595c:	6a890913          	addi	s2,s2,1704 # 8001b000 <disk>
    80005960:	00017497          	auipc	s1,0x17
    80005964:	6a048493          	addi	s1,s1,1696 # 8001d000 <disk+0x2000>
    __sync_synchronize();
    80005968:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000596c:	6898                	ld	a4,16(s1)
    8000596e:	0204d783          	lhu	a5,32(s1)
    80005972:	8b9d                	andi	a5,a5,7
    80005974:	078e                	slli	a5,a5,0x3
    80005976:	97ba                	add	a5,a5,a4
    80005978:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000597a:	20078713          	addi	a4,a5,512
    8000597e:	0712                	slli	a4,a4,0x4
    80005980:	974a                	add	a4,a4,s2
    80005982:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    80005986:	e731                	bnez	a4,800059d2 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005988:	20078793          	addi	a5,a5,512
    8000598c:	0792                	slli	a5,a5,0x4
    8000598e:	97ca                	add	a5,a5,s2
    80005990:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80005992:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005996:	ffffc097          	auipc	ra,0xffffc
    8000599a:	ef6080e7          	jalr	-266(ra) # 8000188c <wakeup>

    disk.used_idx += 1;
    8000599e:	0204d783          	lhu	a5,32(s1)
    800059a2:	2785                	addiw	a5,a5,1
    800059a4:	17c2                	slli	a5,a5,0x30
    800059a6:	93c1                	srli	a5,a5,0x30
    800059a8:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800059ac:	6898                	ld	a4,16(s1)
    800059ae:	00275703          	lhu	a4,2(a4)
    800059b2:	faf71be3          	bne	a4,a5,80005968 <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    800059b6:	00017517          	auipc	a0,0x17
    800059ba:	77250513          	addi	a0,a0,1906 # 8001d128 <disk+0x2128>
    800059be:	00001097          	auipc	ra,0x1
    800059c2:	b2e080e7          	jalr	-1234(ra) # 800064ec <release>
}
    800059c6:	60e2                	ld	ra,24(sp)
    800059c8:	6442                	ld	s0,16(sp)
    800059ca:	64a2                	ld	s1,8(sp)
    800059cc:	6902                	ld	s2,0(sp)
    800059ce:	6105                	addi	sp,sp,32
    800059d0:	8082                	ret
      panic("virtio_disk_intr status");
    800059d2:	00003517          	auipc	a0,0x3
    800059d6:	fb650513          	addi	a0,a0,-74 # 80008988 <syscalls_name+0x3c8>
    800059da:	00000097          	auipc	ra,0x0
    800059de:	526080e7          	jalr	1318(ra) # 80005f00 <panic>

00000000800059e2 <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800059e2:	1141                	addi	sp,sp,-16
    800059e4:	e422                	sd	s0,8(sp)
    800059e6:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800059e8:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800059ec:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800059f0:	0037979b          	slliw	a5,a5,0x3
    800059f4:	02004737          	lui	a4,0x2004
    800059f8:	97ba                	add	a5,a5,a4
    800059fa:	0200c737          	lui	a4,0x200c
    800059fe:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005a02:	000f4637          	lui	a2,0xf4
    80005a06:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005a0a:	9732                	add	a4,a4,a2
    80005a0c:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005a0e:	00259693          	slli	a3,a1,0x2
    80005a12:	96ae                	add	a3,a3,a1
    80005a14:	068e                	slli	a3,a3,0x3
    80005a16:	00018717          	auipc	a4,0x18
    80005a1a:	5ea70713          	addi	a4,a4,1514 # 8001e000 <timer_scratch>
    80005a1e:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005a20:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005a22:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005a24:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005a28:	00000797          	auipc	a5,0x0
    80005a2c:	9c878793          	addi	a5,a5,-1592 # 800053f0 <timervec>
    80005a30:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005a34:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005a38:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005a3c:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005a40:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005a44:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005a48:	30479073          	csrw	mie,a5
}
    80005a4c:	6422                	ld	s0,8(sp)
    80005a4e:	0141                	addi	sp,sp,16
    80005a50:	8082                	ret

0000000080005a52 <start>:
{
    80005a52:	1141                	addi	sp,sp,-16
    80005a54:	e406                	sd	ra,8(sp)
    80005a56:	e022                	sd	s0,0(sp)
    80005a58:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005a5a:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005a5e:	7779                	lui	a4,0xffffe
    80005a60:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd85bf>
    80005a64:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005a66:	6705                	lui	a4,0x1
    80005a68:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005a6c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005a6e:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005a72:	ffffb797          	auipc	a5,0xffffb
    80005a76:	8f878793          	addi	a5,a5,-1800 # 8000036a <main>
    80005a7a:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005a7e:	4781                	li	a5,0
    80005a80:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005a84:	67c1                	lui	a5,0x10
    80005a86:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005a88:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005a8c:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005a90:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005a94:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005a98:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005a9c:	57fd                	li	a5,-1
    80005a9e:	83a9                	srli	a5,a5,0xa
    80005aa0:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005aa4:	47bd                	li	a5,15
    80005aa6:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005aaa:	00000097          	auipc	ra,0x0
    80005aae:	f38080e7          	jalr	-200(ra) # 800059e2 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005ab2:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005ab6:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005ab8:	823e                	mv	tp,a5
  asm volatile("mret");
    80005aba:	30200073          	mret
}
    80005abe:	60a2                	ld	ra,8(sp)
    80005ac0:	6402                	ld	s0,0(sp)
    80005ac2:	0141                	addi	sp,sp,16
    80005ac4:	8082                	ret

0000000080005ac6 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005ac6:	715d                	addi	sp,sp,-80
    80005ac8:	e486                	sd	ra,72(sp)
    80005aca:	e0a2                	sd	s0,64(sp)
    80005acc:	fc26                	sd	s1,56(sp)
    80005ace:	f84a                	sd	s2,48(sp)
    80005ad0:	f44e                	sd	s3,40(sp)
    80005ad2:	f052                	sd	s4,32(sp)
    80005ad4:	ec56                	sd	s5,24(sp)
    80005ad6:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005ad8:	04c05763          	blez	a2,80005b26 <consolewrite+0x60>
    80005adc:	8a2a                	mv	s4,a0
    80005ade:	84ae                	mv	s1,a1
    80005ae0:	89b2                	mv	s3,a2
    80005ae2:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005ae4:	5afd                	li	s5,-1
    80005ae6:	4685                	li	a3,1
    80005ae8:	8626                	mv	a2,s1
    80005aea:	85d2                	mv	a1,s4
    80005aec:	fbf40513          	addi	a0,s0,-65
    80005af0:	ffffc097          	auipc	ra,0xffffc
    80005af4:	00a080e7          	jalr	10(ra) # 80001afa <either_copyin>
    80005af8:	01550d63          	beq	a0,s5,80005b12 <consolewrite+0x4c>
      break;
    uartputc(c);
    80005afc:	fbf44503          	lbu	a0,-65(s0)
    80005b00:	00000097          	auipc	ra,0x0
    80005b04:	77e080e7          	jalr	1918(ra) # 8000627e <uartputc>
  for(i = 0; i < n; i++){
    80005b08:	2905                	addiw	s2,s2,1
    80005b0a:	0485                	addi	s1,s1,1
    80005b0c:	fd299de3          	bne	s3,s2,80005ae6 <consolewrite+0x20>
    80005b10:	894e                	mv	s2,s3
  }

  return i;
}
    80005b12:	854a                	mv	a0,s2
    80005b14:	60a6                	ld	ra,72(sp)
    80005b16:	6406                	ld	s0,64(sp)
    80005b18:	74e2                	ld	s1,56(sp)
    80005b1a:	7942                	ld	s2,48(sp)
    80005b1c:	79a2                	ld	s3,40(sp)
    80005b1e:	7a02                	ld	s4,32(sp)
    80005b20:	6ae2                	ld	s5,24(sp)
    80005b22:	6161                	addi	sp,sp,80
    80005b24:	8082                	ret
  for(i = 0; i < n; i++){
    80005b26:	4901                	li	s2,0
    80005b28:	b7ed                	j	80005b12 <consolewrite+0x4c>

0000000080005b2a <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005b2a:	7159                	addi	sp,sp,-112
    80005b2c:	f486                	sd	ra,104(sp)
    80005b2e:	f0a2                	sd	s0,96(sp)
    80005b30:	eca6                	sd	s1,88(sp)
    80005b32:	e8ca                	sd	s2,80(sp)
    80005b34:	e4ce                	sd	s3,72(sp)
    80005b36:	e0d2                	sd	s4,64(sp)
    80005b38:	fc56                	sd	s5,56(sp)
    80005b3a:	f85a                	sd	s6,48(sp)
    80005b3c:	f45e                	sd	s7,40(sp)
    80005b3e:	f062                	sd	s8,32(sp)
    80005b40:	ec66                	sd	s9,24(sp)
    80005b42:	e86a                	sd	s10,16(sp)
    80005b44:	1880                	addi	s0,sp,112
    80005b46:	8aaa                	mv	s5,a0
    80005b48:	8a2e                	mv	s4,a1
    80005b4a:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005b4c:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005b50:	00020517          	auipc	a0,0x20
    80005b54:	5f050513          	addi	a0,a0,1520 # 80026140 <cons>
    80005b58:	00001097          	auipc	ra,0x1
    80005b5c:	8e0080e7          	jalr	-1824(ra) # 80006438 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005b60:	00020497          	auipc	s1,0x20
    80005b64:	5e048493          	addi	s1,s1,1504 # 80026140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005b68:	00020917          	auipc	s2,0x20
    80005b6c:	67090913          	addi	s2,s2,1648 # 800261d8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80005b70:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005b72:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005b74:	4ca9                	li	s9,10
  while(n > 0){
    80005b76:	07305863          	blez	s3,80005be6 <consoleread+0xbc>
    while(cons.r == cons.w){
    80005b7a:	0984a783          	lw	a5,152(s1)
    80005b7e:	09c4a703          	lw	a4,156(s1)
    80005b82:	02f71463          	bne	a4,a5,80005baa <consoleread+0x80>
      if(myproc()->killed){
    80005b86:	ffffb097          	auipc	ra,0xffffb
    80005b8a:	400080e7          	jalr	1024(ra) # 80000f86 <myproc>
    80005b8e:	551c                	lw	a5,40(a0)
    80005b90:	e7b5                	bnez	a5,80005bfc <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    80005b92:	85a6                	mv	a1,s1
    80005b94:	854a                	mv	a0,s2
    80005b96:	ffffc097          	auipc	ra,0xffffc
    80005b9a:	b6a080e7          	jalr	-1174(ra) # 80001700 <sleep>
    while(cons.r == cons.w){
    80005b9e:	0984a783          	lw	a5,152(s1)
    80005ba2:	09c4a703          	lw	a4,156(s1)
    80005ba6:	fef700e3          	beq	a4,a5,80005b86 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80005baa:	0017871b          	addiw	a4,a5,1
    80005bae:	08e4ac23          	sw	a4,152(s1)
    80005bb2:	07f7f713          	andi	a4,a5,127
    80005bb6:	9726                	add	a4,a4,s1
    80005bb8:	01874703          	lbu	a4,24(a4)
    80005bbc:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    80005bc0:	077d0563          	beq	s10,s7,80005c2a <consoleread+0x100>
    cbuf = c;
    80005bc4:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005bc8:	4685                	li	a3,1
    80005bca:	f9f40613          	addi	a2,s0,-97
    80005bce:	85d2                	mv	a1,s4
    80005bd0:	8556                	mv	a0,s5
    80005bd2:	ffffc097          	auipc	ra,0xffffc
    80005bd6:	ed2080e7          	jalr	-302(ra) # 80001aa4 <either_copyout>
    80005bda:	01850663          	beq	a0,s8,80005be6 <consoleread+0xbc>
    dst++;
    80005bde:	0a05                	addi	s4,s4,1
    --n;
    80005be0:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    80005be2:	f99d1ae3          	bne	s10,s9,80005b76 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005be6:	00020517          	auipc	a0,0x20
    80005bea:	55a50513          	addi	a0,a0,1370 # 80026140 <cons>
    80005bee:	00001097          	auipc	ra,0x1
    80005bf2:	8fe080e7          	jalr	-1794(ra) # 800064ec <release>

  return target - n;
    80005bf6:	413b053b          	subw	a0,s6,s3
    80005bfa:	a811                	j	80005c0e <consoleread+0xe4>
        release(&cons.lock);
    80005bfc:	00020517          	auipc	a0,0x20
    80005c00:	54450513          	addi	a0,a0,1348 # 80026140 <cons>
    80005c04:	00001097          	auipc	ra,0x1
    80005c08:	8e8080e7          	jalr	-1816(ra) # 800064ec <release>
        return -1;
    80005c0c:	557d                	li	a0,-1
}
    80005c0e:	70a6                	ld	ra,104(sp)
    80005c10:	7406                	ld	s0,96(sp)
    80005c12:	64e6                	ld	s1,88(sp)
    80005c14:	6946                	ld	s2,80(sp)
    80005c16:	69a6                	ld	s3,72(sp)
    80005c18:	6a06                	ld	s4,64(sp)
    80005c1a:	7ae2                	ld	s5,56(sp)
    80005c1c:	7b42                	ld	s6,48(sp)
    80005c1e:	7ba2                	ld	s7,40(sp)
    80005c20:	7c02                	ld	s8,32(sp)
    80005c22:	6ce2                	ld	s9,24(sp)
    80005c24:	6d42                	ld	s10,16(sp)
    80005c26:	6165                	addi	sp,sp,112
    80005c28:	8082                	ret
      if(n < target){
    80005c2a:	0009871b          	sext.w	a4,s3
    80005c2e:	fb677ce3          	bgeu	a4,s6,80005be6 <consoleread+0xbc>
        cons.r--;
    80005c32:	00020717          	auipc	a4,0x20
    80005c36:	5af72323          	sw	a5,1446(a4) # 800261d8 <cons+0x98>
    80005c3a:	b775                	j	80005be6 <consoleread+0xbc>

0000000080005c3c <consputc>:
{
    80005c3c:	1141                	addi	sp,sp,-16
    80005c3e:	e406                	sd	ra,8(sp)
    80005c40:	e022                	sd	s0,0(sp)
    80005c42:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005c44:	10000793          	li	a5,256
    80005c48:	00f50a63          	beq	a0,a5,80005c5c <consputc+0x20>
    uartputc_sync(c);
    80005c4c:	00000097          	auipc	ra,0x0
    80005c50:	560080e7          	jalr	1376(ra) # 800061ac <uartputc_sync>
}
    80005c54:	60a2                	ld	ra,8(sp)
    80005c56:	6402                	ld	s0,0(sp)
    80005c58:	0141                	addi	sp,sp,16
    80005c5a:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005c5c:	4521                	li	a0,8
    80005c5e:	00000097          	auipc	ra,0x0
    80005c62:	54e080e7          	jalr	1358(ra) # 800061ac <uartputc_sync>
    80005c66:	02000513          	li	a0,32
    80005c6a:	00000097          	auipc	ra,0x0
    80005c6e:	542080e7          	jalr	1346(ra) # 800061ac <uartputc_sync>
    80005c72:	4521                	li	a0,8
    80005c74:	00000097          	auipc	ra,0x0
    80005c78:	538080e7          	jalr	1336(ra) # 800061ac <uartputc_sync>
    80005c7c:	bfe1                	j	80005c54 <consputc+0x18>

0000000080005c7e <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005c7e:	1101                	addi	sp,sp,-32
    80005c80:	ec06                	sd	ra,24(sp)
    80005c82:	e822                	sd	s0,16(sp)
    80005c84:	e426                	sd	s1,8(sp)
    80005c86:	e04a                	sd	s2,0(sp)
    80005c88:	1000                	addi	s0,sp,32
    80005c8a:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005c8c:	00020517          	auipc	a0,0x20
    80005c90:	4b450513          	addi	a0,a0,1204 # 80026140 <cons>
    80005c94:	00000097          	auipc	ra,0x0
    80005c98:	7a4080e7          	jalr	1956(ra) # 80006438 <acquire>

  switch(c){
    80005c9c:	47d5                	li	a5,21
    80005c9e:	0af48663          	beq	s1,a5,80005d4a <consoleintr+0xcc>
    80005ca2:	0297ca63          	blt	a5,s1,80005cd6 <consoleintr+0x58>
    80005ca6:	47a1                	li	a5,8
    80005ca8:	0ef48763          	beq	s1,a5,80005d96 <consoleintr+0x118>
    80005cac:	47c1                	li	a5,16
    80005cae:	10f49a63          	bne	s1,a5,80005dc2 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005cb2:	ffffc097          	auipc	ra,0xffffc
    80005cb6:	e9e080e7          	jalr	-354(ra) # 80001b50 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005cba:	00020517          	auipc	a0,0x20
    80005cbe:	48650513          	addi	a0,a0,1158 # 80026140 <cons>
    80005cc2:	00001097          	auipc	ra,0x1
    80005cc6:	82a080e7          	jalr	-2006(ra) # 800064ec <release>
}
    80005cca:	60e2                	ld	ra,24(sp)
    80005ccc:	6442                	ld	s0,16(sp)
    80005cce:	64a2                	ld	s1,8(sp)
    80005cd0:	6902                	ld	s2,0(sp)
    80005cd2:	6105                	addi	sp,sp,32
    80005cd4:	8082                	ret
  switch(c){
    80005cd6:	07f00793          	li	a5,127
    80005cda:	0af48e63          	beq	s1,a5,80005d96 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005cde:	00020717          	auipc	a4,0x20
    80005ce2:	46270713          	addi	a4,a4,1122 # 80026140 <cons>
    80005ce6:	0a072783          	lw	a5,160(a4)
    80005cea:	09872703          	lw	a4,152(a4)
    80005cee:	9f99                	subw	a5,a5,a4
    80005cf0:	07f00713          	li	a4,127
    80005cf4:	fcf763e3          	bltu	a4,a5,80005cba <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005cf8:	47b5                	li	a5,13
    80005cfa:	0cf48763          	beq	s1,a5,80005dc8 <consoleintr+0x14a>
      consputc(c);
    80005cfe:	8526                	mv	a0,s1
    80005d00:	00000097          	auipc	ra,0x0
    80005d04:	f3c080e7          	jalr	-196(ra) # 80005c3c <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005d08:	00020797          	auipc	a5,0x20
    80005d0c:	43878793          	addi	a5,a5,1080 # 80026140 <cons>
    80005d10:	0a07a703          	lw	a4,160(a5)
    80005d14:	0017069b          	addiw	a3,a4,1
    80005d18:	0006861b          	sext.w	a2,a3
    80005d1c:	0ad7a023          	sw	a3,160(a5)
    80005d20:	07f77713          	andi	a4,a4,127
    80005d24:	97ba                	add	a5,a5,a4
    80005d26:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005d2a:	47a9                	li	a5,10
    80005d2c:	0cf48563          	beq	s1,a5,80005df6 <consoleintr+0x178>
    80005d30:	4791                	li	a5,4
    80005d32:	0cf48263          	beq	s1,a5,80005df6 <consoleintr+0x178>
    80005d36:	00020797          	auipc	a5,0x20
    80005d3a:	4a27a783          	lw	a5,1186(a5) # 800261d8 <cons+0x98>
    80005d3e:	0807879b          	addiw	a5,a5,128
    80005d42:	f6f61ce3          	bne	a2,a5,80005cba <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005d46:	863e                	mv	a2,a5
    80005d48:	a07d                	j	80005df6 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005d4a:	00020717          	auipc	a4,0x20
    80005d4e:	3f670713          	addi	a4,a4,1014 # 80026140 <cons>
    80005d52:	0a072783          	lw	a5,160(a4)
    80005d56:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005d5a:	00020497          	auipc	s1,0x20
    80005d5e:	3e648493          	addi	s1,s1,998 # 80026140 <cons>
    while(cons.e != cons.w &&
    80005d62:	4929                	li	s2,10
    80005d64:	f4f70be3          	beq	a4,a5,80005cba <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005d68:	37fd                	addiw	a5,a5,-1
    80005d6a:	07f7f713          	andi	a4,a5,127
    80005d6e:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005d70:	01874703          	lbu	a4,24(a4)
    80005d74:	f52703e3          	beq	a4,s2,80005cba <consoleintr+0x3c>
      cons.e--;
    80005d78:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005d7c:	10000513          	li	a0,256
    80005d80:	00000097          	auipc	ra,0x0
    80005d84:	ebc080e7          	jalr	-324(ra) # 80005c3c <consputc>
    while(cons.e != cons.w &&
    80005d88:	0a04a783          	lw	a5,160(s1)
    80005d8c:	09c4a703          	lw	a4,156(s1)
    80005d90:	fcf71ce3          	bne	a4,a5,80005d68 <consoleintr+0xea>
    80005d94:	b71d                	j	80005cba <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005d96:	00020717          	auipc	a4,0x20
    80005d9a:	3aa70713          	addi	a4,a4,938 # 80026140 <cons>
    80005d9e:	0a072783          	lw	a5,160(a4)
    80005da2:	09c72703          	lw	a4,156(a4)
    80005da6:	f0f70ae3          	beq	a4,a5,80005cba <consoleintr+0x3c>
      cons.e--;
    80005daa:	37fd                	addiw	a5,a5,-1
    80005dac:	00020717          	auipc	a4,0x20
    80005db0:	42f72a23          	sw	a5,1076(a4) # 800261e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005db4:	10000513          	li	a0,256
    80005db8:	00000097          	auipc	ra,0x0
    80005dbc:	e84080e7          	jalr	-380(ra) # 80005c3c <consputc>
    80005dc0:	bded                	j	80005cba <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005dc2:	ee048ce3          	beqz	s1,80005cba <consoleintr+0x3c>
    80005dc6:	bf21                	j	80005cde <consoleintr+0x60>
      consputc(c);
    80005dc8:	4529                	li	a0,10
    80005dca:	00000097          	auipc	ra,0x0
    80005dce:	e72080e7          	jalr	-398(ra) # 80005c3c <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005dd2:	00020797          	auipc	a5,0x20
    80005dd6:	36e78793          	addi	a5,a5,878 # 80026140 <cons>
    80005dda:	0a07a703          	lw	a4,160(a5)
    80005dde:	0017069b          	addiw	a3,a4,1
    80005de2:	0006861b          	sext.w	a2,a3
    80005de6:	0ad7a023          	sw	a3,160(a5)
    80005dea:	07f77713          	andi	a4,a4,127
    80005dee:	97ba                	add	a5,a5,a4
    80005df0:	4729                	li	a4,10
    80005df2:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005df6:	00020797          	auipc	a5,0x20
    80005dfa:	3ec7a323          	sw	a2,998(a5) # 800261dc <cons+0x9c>
        wakeup(&cons.r);
    80005dfe:	00020517          	auipc	a0,0x20
    80005e02:	3da50513          	addi	a0,a0,986 # 800261d8 <cons+0x98>
    80005e06:	ffffc097          	auipc	ra,0xffffc
    80005e0a:	a86080e7          	jalr	-1402(ra) # 8000188c <wakeup>
    80005e0e:	b575                	j	80005cba <consoleintr+0x3c>

0000000080005e10 <consoleinit>:

void
consoleinit(void)
{
    80005e10:	1141                	addi	sp,sp,-16
    80005e12:	e406                	sd	ra,8(sp)
    80005e14:	e022                	sd	s0,0(sp)
    80005e16:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005e18:	00003597          	auipc	a1,0x3
    80005e1c:	b8858593          	addi	a1,a1,-1144 # 800089a0 <syscalls_name+0x3e0>
    80005e20:	00020517          	auipc	a0,0x20
    80005e24:	32050513          	addi	a0,a0,800 # 80026140 <cons>
    80005e28:	00000097          	auipc	ra,0x0
    80005e2c:	580080e7          	jalr	1408(ra) # 800063a8 <initlock>

  uartinit();
    80005e30:	00000097          	auipc	ra,0x0
    80005e34:	32c080e7          	jalr	812(ra) # 8000615c <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005e38:	00013797          	auipc	a5,0x13
    80005e3c:	69078793          	addi	a5,a5,1680 # 800194c8 <devsw>
    80005e40:	00000717          	auipc	a4,0x0
    80005e44:	cea70713          	addi	a4,a4,-790 # 80005b2a <consoleread>
    80005e48:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005e4a:	00000717          	auipc	a4,0x0
    80005e4e:	c7c70713          	addi	a4,a4,-900 # 80005ac6 <consolewrite>
    80005e52:	ef98                	sd	a4,24(a5)
}
    80005e54:	60a2                	ld	ra,8(sp)
    80005e56:	6402                	ld	s0,0(sp)
    80005e58:	0141                	addi	sp,sp,16
    80005e5a:	8082                	ret

0000000080005e5c <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005e5c:	7179                	addi	sp,sp,-48
    80005e5e:	f406                	sd	ra,40(sp)
    80005e60:	f022                	sd	s0,32(sp)
    80005e62:	ec26                	sd	s1,24(sp)
    80005e64:	e84a                	sd	s2,16(sp)
    80005e66:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005e68:	c219                	beqz	a2,80005e6e <printint+0x12>
    80005e6a:	08054763          	bltz	a0,80005ef8 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005e6e:	2501                	sext.w	a0,a0
    80005e70:	4881                	li	a7,0
    80005e72:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005e76:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005e78:	2581                	sext.w	a1,a1
    80005e7a:	00003617          	auipc	a2,0x3
    80005e7e:	b5660613          	addi	a2,a2,-1194 # 800089d0 <digits>
    80005e82:	883a                	mv	a6,a4
    80005e84:	2705                	addiw	a4,a4,1
    80005e86:	02b577bb          	remuw	a5,a0,a1
    80005e8a:	1782                	slli	a5,a5,0x20
    80005e8c:	9381                	srli	a5,a5,0x20
    80005e8e:	97b2                	add	a5,a5,a2
    80005e90:	0007c783          	lbu	a5,0(a5)
    80005e94:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005e98:	0005079b          	sext.w	a5,a0
    80005e9c:	02b5553b          	divuw	a0,a0,a1
    80005ea0:	0685                	addi	a3,a3,1
    80005ea2:	feb7f0e3          	bgeu	a5,a1,80005e82 <printint+0x26>

  if(sign)
    80005ea6:	00088c63          	beqz	a7,80005ebe <printint+0x62>
    buf[i++] = '-';
    80005eaa:	fe070793          	addi	a5,a4,-32
    80005eae:	00878733          	add	a4,a5,s0
    80005eb2:	02d00793          	li	a5,45
    80005eb6:	fef70823          	sb	a5,-16(a4)
    80005eba:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005ebe:	02e05763          	blez	a4,80005eec <printint+0x90>
    80005ec2:	fd040793          	addi	a5,s0,-48
    80005ec6:	00e784b3          	add	s1,a5,a4
    80005eca:	fff78913          	addi	s2,a5,-1
    80005ece:	993a                	add	s2,s2,a4
    80005ed0:	377d                	addiw	a4,a4,-1
    80005ed2:	1702                	slli	a4,a4,0x20
    80005ed4:	9301                	srli	a4,a4,0x20
    80005ed6:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005eda:	fff4c503          	lbu	a0,-1(s1)
    80005ede:	00000097          	auipc	ra,0x0
    80005ee2:	d5e080e7          	jalr	-674(ra) # 80005c3c <consputc>
  while(--i >= 0)
    80005ee6:	14fd                	addi	s1,s1,-1
    80005ee8:	ff2499e3          	bne	s1,s2,80005eda <printint+0x7e>
}
    80005eec:	70a2                	ld	ra,40(sp)
    80005eee:	7402                	ld	s0,32(sp)
    80005ef0:	64e2                	ld	s1,24(sp)
    80005ef2:	6942                	ld	s2,16(sp)
    80005ef4:	6145                	addi	sp,sp,48
    80005ef6:	8082                	ret
    x = -xx;
    80005ef8:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005efc:	4885                	li	a7,1
    x = -xx;
    80005efe:	bf95                	j	80005e72 <printint+0x16>

0000000080005f00 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005f00:	1101                	addi	sp,sp,-32
    80005f02:	ec06                	sd	ra,24(sp)
    80005f04:	e822                	sd	s0,16(sp)
    80005f06:	e426                	sd	s1,8(sp)
    80005f08:	1000                	addi	s0,sp,32
    80005f0a:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005f0c:	00020797          	auipc	a5,0x20
    80005f10:	2e07aa23          	sw	zero,756(a5) # 80026200 <pr+0x18>
  printf("panic: ");
    80005f14:	00003517          	auipc	a0,0x3
    80005f18:	a9450513          	addi	a0,a0,-1388 # 800089a8 <syscalls_name+0x3e8>
    80005f1c:	00000097          	auipc	ra,0x0
    80005f20:	02e080e7          	jalr	46(ra) # 80005f4a <printf>
  printf(s);
    80005f24:	8526                	mv	a0,s1
    80005f26:	00000097          	auipc	ra,0x0
    80005f2a:	024080e7          	jalr	36(ra) # 80005f4a <printf>
  printf("\n");
    80005f2e:	00002517          	auipc	a0,0x2
    80005f32:	11a50513          	addi	a0,a0,282 # 80008048 <etext+0x48>
    80005f36:	00000097          	auipc	ra,0x0
    80005f3a:	014080e7          	jalr	20(ra) # 80005f4a <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005f3e:	4785                	li	a5,1
    80005f40:	00003717          	auipc	a4,0x3
    80005f44:	0cf72e23          	sw	a5,220(a4) # 8000901c <panicked>
  for(;;)
    80005f48:	a001                	j	80005f48 <panic+0x48>

0000000080005f4a <printf>:
{
    80005f4a:	7131                	addi	sp,sp,-192
    80005f4c:	fc86                	sd	ra,120(sp)
    80005f4e:	f8a2                	sd	s0,112(sp)
    80005f50:	f4a6                	sd	s1,104(sp)
    80005f52:	f0ca                	sd	s2,96(sp)
    80005f54:	ecce                	sd	s3,88(sp)
    80005f56:	e8d2                	sd	s4,80(sp)
    80005f58:	e4d6                	sd	s5,72(sp)
    80005f5a:	e0da                	sd	s6,64(sp)
    80005f5c:	fc5e                	sd	s7,56(sp)
    80005f5e:	f862                	sd	s8,48(sp)
    80005f60:	f466                	sd	s9,40(sp)
    80005f62:	f06a                	sd	s10,32(sp)
    80005f64:	ec6e                	sd	s11,24(sp)
    80005f66:	0100                	addi	s0,sp,128
    80005f68:	8a2a                	mv	s4,a0
    80005f6a:	e40c                	sd	a1,8(s0)
    80005f6c:	e810                	sd	a2,16(s0)
    80005f6e:	ec14                	sd	a3,24(s0)
    80005f70:	f018                	sd	a4,32(s0)
    80005f72:	f41c                	sd	a5,40(s0)
    80005f74:	03043823          	sd	a6,48(s0)
    80005f78:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005f7c:	00020d97          	auipc	s11,0x20
    80005f80:	284dad83          	lw	s11,644(s11) # 80026200 <pr+0x18>
  if(locking)
    80005f84:	020d9b63          	bnez	s11,80005fba <printf+0x70>
  if (fmt == 0)
    80005f88:	040a0263          	beqz	s4,80005fcc <printf+0x82>
  va_start(ap, fmt);
    80005f8c:	00840793          	addi	a5,s0,8
    80005f90:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005f94:	000a4503          	lbu	a0,0(s4)
    80005f98:	14050f63          	beqz	a0,800060f6 <printf+0x1ac>
    80005f9c:	4981                	li	s3,0
    if(c != '%'){
    80005f9e:	02500a93          	li	s5,37
    switch(c){
    80005fa2:	07000b93          	li	s7,112
  consputc('x');
    80005fa6:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005fa8:	00003b17          	auipc	s6,0x3
    80005fac:	a28b0b13          	addi	s6,s6,-1496 # 800089d0 <digits>
    switch(c){
    80005fb0:	07300c93          	li	s9,115
    80005fb4:	06400c13          	li	s8,100
    80005fb8:	a82d                	j	80005ff2 <printf+0xa8>
    acquire(&pr.lock);
    80005fba:	00020517          	auipc	a0,0x20
    80005fbe:	22e50513          	addi	a0,a0,558 # 800261e8 <pr>
    80005fc2:	00000097          	auipc	ra,0x0
    80005fc6:	476080e7          	jalr	1142(ra) # 80006438 <acquire>
    80005fca:	bf7d                	j	80005f88 <printf+0x3e>
    panic("null fmt");
    80005fcc:	00003517          	auipc	a0,0x3
    80005fd0:	9ec50513          	addi	a0,a0,-1556 # 800089b8 <syscalls_name+0x3f8>
    80005fd4:	00000097          	auipc	ra,0x0
    80005fd8:	f2c080e7          	jalr	-212(ra) # 80005f00 <panic>
      consputc(c);
    80005fdc:	00000097          	auipc	ra,0x0
    80005fe0:	c60080e7          	jalr	-928(ra) # 80005c3c <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005fe4:	2985                	addiw	s3,s3,1
    80005fe6:	013a07b3          	add	a5,s4,s3
    80005fea:	0007c503          	lbu	a0,0(a5)
    80005fee:	10050463          	beqz	a0,800060f6 <printf+0x1ac>
    if(c != '%'){
    80005ff2:	ff5515e3          	bne	a0,s5,80005fdc <printf+0x92>
    c = fmt[++i] & 0xff;
    80005ff6:	2985                	addiw	s3,s3,1
    80005ff8:	013a07b3          	add	a5,s4,s3
    80005ffc:	0007c783          	lbu	a5,0(a5)
    80006000:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80006004:	cbed                	beqz	a5,800060f6 <printf+0x1ac>
    switch(c){
    80006006:	05778a63          	beq	a5,s7,8000605a <printf+0x110>
    8000600a:	02fbf663          	bgeu	s7,a5,80006036 <printf+0xec>
    8000600e:	09978863          	beq	a5,s9,8000609e <printf+0x154>
    80006012:	07800713          	li	a4,120
    80006016:	0ce79563          	bne	a5,a4,800060e0 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    8000601a:	f8843783          	ld	a5,-120(s0)
    8000601e:	00878713          	addi	a4,a5,8
    80006022:	f8e43423          	sd	a4,-120(s0)
    80006026:	4605                	li	a2,1
    80006028:	85ea                	mv	a1,s10
    8000602a:	4388                	lw	a0,0(a5)
    8000602c:	00000097          	auipc	ra,0x0
    80006030:	e30080e7          	jalr	-464(ra) # 80005e5c <printint>
      break;
    80006034:	bf45                	j	80005fe4 <printf+0x9a>
    switch(c){
    80006036:	09578f63          	beq	a5,s5,800060d4 <printf+0x18a>
    8000603a:	0b879363          	bne	a5,s8,800060e0 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    8000603e:	f8843783          	ld	a5,-120(s0)
    80006042:	00878713          	addi	a4,a5,8
    80006046:	f8e43423          	sd	a4,-120(s0)
    8000604a:	4605                	li	a2,1
    8000604c:	45a9                	li	a1,10
    8000604e:	4388                	lw	a0,0(a5)
    80006050:	00000097          	auipc	ra,0x0
    80006054:	e0c080e7          	jalr	-500(ra) # 80005e5c <printint>
      break;
    80006058:	b771                	j	80005fe4 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    8000605a:	f8843783          	ld	a5,-120(s0)
    8000605e:	00878713          	addi	a4,a5,8
    80006062:	f8e43423          	sd	a4,-120(s0)
    80006066:	0007b903          	ld	s2,0(a5)
  consputc('0');
    8000606a:	03000513          	li	a0,48
    8000606e:	00000097          	auipc	ra,0x0
    80006072:	bce080e7          	jalr	-1074(ra) # 80005c3c <consputc>
  consputc('x');
    80006076:	07800513          	li	a0,120
    8000607a:	00000097          	auipc	ra,0x0
    8000607e:	bc2080e7          	jalr	-1086(ra) # 80005c3c <consputc>
    80006082:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006084:	03c95793          	srli	a5,s2,0x3c
    80006088:	97da                	add	a5,a5,s6
    8000608a:	0007c503          	lbu	a0,0(a5)
    8000608e:	00000097          	auipc	ra,0x0
    80006092:	bae080e7          	jalr	-1106(ra) # 80005c3c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006096:	0912                	slli	s2,s2,0x4
    80006098:	34fd                	addiw	s1,s1,-1
    8000609a:	f4ed                	bnez	s1,80006084 <printf+0x13a>
    8000609c:	b7a1                	j	80005fe4 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    8000609e:	f8843783          	ld	a5,-120(s0)
    800060a2:	00878713          	addi	a4,a5,8
    800060a6:	f8e43423          	sd	a4,-120(s0)
    800060aa:	6384                	ld	s1,0(a5)
    800060ac:	cc89                	beqz	s1,800060c6 <printf+0x17c>
      for(; *s; s++)
    800060ae:	0004c503          	lbu	a0,0(s1)
    800060b2:	d90d                	beqz	a0,80005fe4 <printf+0x9a>
        consputc(*s);
    800060b4:	00000097          	auipc	ra,0x0
    800060b8:	b88080e7          	jalr	-1144(ra) # 80005c3c <consputc>
      for(; *s; s++)
    800060bc:	0485                	addi	s1,s1,1
    800060be:	0004c503          	lbu	a0,0(s1)
    800060c2:	f96d                	bnez	a0,800060b4 <printf+0x16a>
    800060c4:	b705                	j	80005fe4 <printf+0x9a>
        s = "(null)";
    800060c6:	00003497          	auipc	s1,0x3
    800060ca:	8ea48493          	addi	s1,s1,-1814 # 800089b0 <syscalls_name+0x3f0>
      for(; *s; s++)
    800060ce:	02800513          	li	a0,40
    800060d2:	b7cd                	j	800060b4 <printf+0x16a>
      consputc('%');
    800060d4:	8556                	mv	a0,s5
    800060d6:	00000097          	auipc	ra,0x0
    800060da:	b66080e7          	jalr	-1178(ra) # 80005c3c <consputc>
      break;
    800060de:	b719                	j	80005fe4 <printf+0x9a>
      consputc('%');
    800060e0:	8556                	mv	a0,s5
    800060e2:	00000097          	auipc	ra,0x0
    800060e6:	b5a080e7          	jalr	-1190(ra) # 80005c3c <consputc>
      consputc(c);
    800060ea:	8526                	mv	a0,s1
    800060ec:	00000097          	auipc	ra,0x0
    800060f0:	b50080e7          	jalr	-1200(ra) # 80005c3c <consputc>
      break;
    800060f4:	bdc5                	j	80005fe4 <printf+0x9a>
  if(locking)
    800060f6:	020d9163          	bnez	s11,80006118 <printf+0x1ce>
}
    800060fa:	70e6                	ld	ra,120(sp)
    800060fc:	7446                	ld	s0,112(sp)
    800060fe:	74a6                	ld	s1,104(sp)
    80006100:	7906                	ld	s2,96(sp)
    80006102:	69e6                	ld	s3,88(sp)
    80006104:	6a46                	ld	s4,80(sp)
    80006106:	6aa6                	ld	s5,72(sp)
    80006108:	6b06                	ld	s6,64(sp)
    8000610a:	7be2                	ld	s7,56(sp)
    8000610c:	7c42                	ld	s8,48(sp)
    8000610e:	7ca2                	ld	s9,40(sp)
    80006110:	7d02                	ld	s10,32(sp)
    80006112:	6de2                	ld	s11,24(sp)
    80006114:	6129                	addi	sp,sp,192
    80006116:	8082                	ret
    release(&pr.lock);
    80006118:	00020517          	auipc	a0,0x20
    8000611c:	0d050513          	addi	a0,a0,208 # 800261e8 <pr>
    80006120:	00000097          	auipc	ra,0x0
    80006124:	3cc080e7          	jalr	972(ra) # 800064ec <release>
}
    80006128:	bfc9                	j	800060fa <printf+0x1b0>

000000008000612a <printfinit>:
    ;
}

void
printfinit(void)
{
    8000612a:	1101                	addi	sp,sp,-32
    8000612c:	ec06                	sd	ra,24(sp)
    8000612e:	e822                	sd	s0,16(sp)
    80006130:	e426                	sd	s1,8(sp)
    80006132:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006134:	00020497          	auipc	s1,0x20
    80006138:	0b448493          	addi	s1,s1,180 # 800261e8 <pr>
    8000613c:	00003597          	auipc	a1,0x3
    80006140:	88c58593          	addi	a1,a1,-1908 # 800089c8 <syscalls_name+0x408>
    80006144:	8526                	mv	a0,s1
    80006146:	00000097          	auipc	ra,0x0
    8000614a:	262080e7          	jalr	610(ra) # 800063a8 <initlock>
  pr.locking = 1;
    8000614e:	4785                	li	a5,1
    80006150:	cc9c                	sw	a5,24(s1)
}
    80006152:	60e2                	ld	ra,24(sp)
    80006154:	6442                	ld	s0,16(sp)
    80006156:	64a2                	ld	s1,8(sp)
    80006158:	6105                	addi	sp,sp,32
    8000615a:	8082                	ret

000000008000615c <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000615c:	1141                	addi	sp,sp,-16
    8000615e:	e406                	sd	ra,8(sp)
    80006160:	e022                	sd	s0,0(sp)
    80006162:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006164:	100007b7          	lui	a5,0x10000
    80006168:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000616c:	f8000713          	li	a4,-128
    80006170:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006174:	470d                	li	a4,3
    80006176:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000617a:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000617e:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006182:	469d                	li	a3,7
    80006184:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006188:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000618c:	00003597          	auipc	a1,0x3
    80006190:	85c58593          	addi	a1,a1,-1956 # 800089e8 <digits+0x18>
    80006194:	00020517          	auipc	a0,0x20
    80006198:	07450513          	addi	a0,a0,116 # 80026208 <uart_tx_lock>
    8000619c:	00000097          	auipc	ra,0x0
    800061a0:	20c080e7          	jalr	524(ra) # 800063a8 <initlock>
}
    800061a4:	60a2                	ld	ra,8(sp)
    800061a6:	6402                	ld	s0,0(sp)
    800061a8:	0141                	addi	sp,sp,16
    800061aa:	8082                	ret

00000000800061ac <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800061ac:	1101                	addi	sp,sp,-32
    800061ae:	ec06                	sd	ra,24(sp)
    800061b0:	e822                	sd	s0,16(sp)
    800061b2:	e426                	sd	s1,8(sp)
    800061b4:	1000                	addi	s0,sp,32
    800061b6:	84aa                	mv	s1,a0
  push_off();
    800061b8:	00000097          	auipc	ra,0x0
    800061bc:	234080e7          	jalr	564(ra) # 800063ec <push_off>

  if(panicked){
    800061c0:	00003797          	auipc	a5,0x3
    800061c4:	e5c7a783          	lw	a5,-420(a5) # 8000901c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800061c8:	10000737          	lui	a4,0x10000
  if(panicked){
    800061cc:	c391                	beqz	a5,800061d0 <uartputc_sync+0x24>
    for(;;)
    800061ce:	a001                	j	800061ce <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800061d0:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800061d4:	0207f793          	andi	a5,a5,32
    800061d8:	dfe5                	beqz	a5,800061d0 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    800061da:	0ff4f513          	zext.b	a0,s1
    800061de:	100007b7          	lui	a5,0x10000
    800061e2:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800061e6:	00000097          	auipc	ra,0x0
    800061ea:	2a6080e7          	jalr	678(ra) # 8000648c <pop_off>
}
    800061ee:	60e2                	ld	ra,24(sp)
    800061f0:	6442                	ld	s0,16(sp)
    800061f2:	64a2                	ld	s1,8(sp)
    800061f4:	6105                	addi	sp,sp,32
    800061f6:	8082                	ret

00000000800061f8 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800061f8:	00003797          	auipc	a5,0x3
    800061fc:	e287b783          	ld	a5,-472(a5) # 80009020 <uart_tx_r>
    80006200:	00003717          	auipc	a4,0x3
    80006204:	e2873703          	ld	a4,-472(a4) # 80009028 <uart_tx_w>
    80006208:	06f70a63          	beq	a4,a5,8000627c <uartstart+0x84>
{
    8000620c:	7139                	addi	sp,sp,-64
    8000620e:	fc06                	sd	ra,56(sp)
    80006210:	f822                	sd	s0,48(sp)
    80006212:	f426                	sd	s1,40(sp)
    80006214:	f04a                	sd	s2,32(sp)
    80006216:	ec4e                	sd	s3,24(sp)
    80006218:	e852                	sd	s4,16(sp)
    8000621a:	e456                	sd	s5,8(sp)
    8000621c:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000621e:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006222:	00020a17          	auipc	s4,0x20
    80006226:	fe6a0a13          	addi	s4,s4,-26 # 80026208 <uart_tx_lock>
    uart_tx_r += 1;
    8000622a:	00003497          	auipc	s1,0x3
    8000622e:	df648493          	addi	s1,s1,-522 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80006232:	00003997          	auipc	s3,0x3
    80006236:	df698993          	addi	s3,s3,-522 # 80009028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000623a:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000623e:	02077713          	andi	a4,a4,32
    80006242:	c705                	beqz	a4,8000626a <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006244:	01f7f713          	andi	a4,a5,31
    80006248:	9752                	add	a4,a4,s4
    8000624a:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    8000624e:	0785                	addi	a5,a5,1
    80006250:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006252:	8526                	mv	a0,s1
    80006254:	ffffb097          	auipc	ra,0xffffb
    80006258:	638080e7          	jalr	1592(ra) # 8000188c <wakeup>
    
    WriteReg(THR, c);
    8000625c:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006260:	609c                	ld	a5,0(s1)
    80006262:	0009b703          	ld	a4,0(s3)
    80006266:	fcf71ae3          	bne	a4,a5,8000623a <uartstart+0x42>
  }
}
    8000626a:	70e2                	ld	ra,56(sp)
    8000626c:	7442                	ld	s0,48(sp)
    8000626e:	74a2                	ld	s1,40(sp)
    80006270:	7902                	ld	s2,32(sp)
    80006272:	69e2                	ld	s3,24(sp)
    80006274:	6a42                	ld	s4,16(sp)
    80006276:	6aa2                	ld	s5,8(sp)
    80006278:	6121                	addi	sp,sp,64
    8000627a:	8082                	ret
    8000627c:	8082                	ret

000000008000627e <uartputc>:
{
    8000627e:	7179                	addi	sp,sp,-48
    80006280:	f406                	sd	ra,40(sp)
    80006282:	f022                	sd	s0,32(sp)
    80006284:	ec26                	sd	s1,24(sp)
    80006286:	e84a                	sd	s2,16(sp)
    80006288:	e44e                	sd	s3,8(sp)
    8000628a:	e052                	sd	s4,0(sp)
    8000628c:	1800                	addi	s0,sp,48
    8000628e:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80006290:	00020517          	auipc	a0,0x20
    80006294:	f7850513          	addi	a0,a0,-136 # 80026208 <uart_tx_lock>
    80006298:	00000097          	auipc	ra,0x0
    8000629c:	1a0080e7          	jalr	416(ra) # 80006438 <acquire>
  if(panicked){
    800062a0:	00003797          	auipc	a5,0x3
    800062a4:	d7c7a783          	lw	a5,-644(a5) # 8000901c <panicked>
    800062a8:	c391                	beqz	a5,800062ac <uartputc+0x2e>
    for(;;)
    800062aa:	a001                	j	800062aa <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800062ac:	00003717          	auipc	a4,0x3
    800062b0:	d7c73703          	ld	a4,-644(a4) # 80009028 <uart_tx_w>
    800062b4:	00003797          	auipc	a5,0x3
    800062b8:	d6c7b783          	ld	a5,-660(a5) # 80009020 <uart_tx_r>
    800062bc:	02078793          	addi	a5,a5,32
    800062c0:	02e79b63          	bne	a5,a4,800062f6 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    800062c4:	00020997          	auipc	s3,0x20
    800062c8:	f4498993          	addi	s3,s3,-188 # 80026208 <uart_tx_lock>
    800062cc:	00003497          	auipc	s1,0x3
    800062d0:	d5448493          	addi	s1,s1,-684 # 80009020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800062d4:	00003917          	auipc	s2,0x3
    800062d8:	d5490913          	addi	s2,s2,-684 # 80009028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    800062dc:	85ce                	mv	a1,s3
    800062de:	8526                	mv	a0,s1
    800062e0:	ffffb097          	auipc	ra,0xffffb
    800062e4:	420080e7          	jalr	1056(ra) # 80001700 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800062e8:	00093703          	ld	a4,0(s2)
    800062ec:	609c                	ld	a5,0(s1)
    800062ee:	02078793          	addi	a5,a5,32
    800062f2:	fee785e3          	beq	a5,a4,800062dc <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800062f6:	00020497          	auipc	s1,0x20
    800062fa:	f1248493          	addi	s1,s1,-238 # 80026208 <uart_tx_lock>
    800062fe:	01f77793          	andi	a5,a4,31
    80006302:	97a6                	add	a5,a5,s1
    80006304:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    80006308:	0705                	addi	a4,a4,1
    8000630a:	00003797          	auipc	a5,0x3
    8000630e:	d0e7bf23          	sd	a4,-738(a5) # 80009028 <uart_tx_w>
      uartstart();
    80006312:	00000097          	auipc	ra,0x0
    80006316:	ee6080e7          	jalr	-282(ra) # 800061f8 <uartstart>
      release(&uart_tx_lock);
    8000631a:	8526                	mv	a0,s1
    8000631c:	00000097          	auipc	ra,0x0
    80006320:	1d0080e7          	jalr	464(ra) # 800064ec <release>
}
    80006324:	70a2                	ld	ra,40(sp)
    80006326:	7402                	ld	s0,32(sp)
    80006328:	64e2                	ld	s1,24(sp)
    8000632a:	6942                	ld	s2,16(sp)
    8000632c:	69a2                	ld	s3,8(sp)
    8000632e:	6a02                	ld	s4,0(sp)
    80006330:	6145                	addi	sp,sp,48
    80006332:	8082                	ret

0000000080006334 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006334:	1141                	addi	sp,sp,-16
    80006336:	e422                	sd	s0,8(sp)
    80006338:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000633a:	100007b7          	lui	a5,0x10000
    8000633e:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006342:	8b85                	andi	a5,a5,1
    80006344:	cb81                	beqz	a5,80006354 <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    80006346:	100007b7          	lui	a5,0x10000
    8000634a:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000634e:	6422                	ld	s0,8(sp)
    80006350:	0141                	addi	sp,sp,16
    80006352:	8082                	ret
    return -1;
    80006354:	557d                	li	a0,-1
    80006356:	bfe5                	j	8000634e <uartgetc+0x1a>

0000000080006358 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006358:	1101                	addi	sp,sp,-32
    8000635a:	ec06                	sd	ra,24(sp)
    8000635c:	e822                	sd	s0,16(sp)
    8000635e:	e426                	sd	s1,8(sp)
    80006360:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006362:	54fd                	li	s1,-1
    80006364:	a029                	j	8000636e <uartintr+0x16>
      break;
    consoleintr(c);
    80006366:	00000097          	auipc	ra,0x0
    8000636a:	918080e7          	jalr	-1768(ra) # 80005c7e <consoleintr>
    int c = uartgetc();
    8000636e:	00000097          	auipc	ra,0x0
    80006372:	fc6080e7          	jalr	-58(ra) # 80006334 <uartgetc>
    if(c == -1)
    80006376:	fe9518e3          	bne	a0,s1,80006366 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000637a:	00020497          	auipc	s1,0x20
    8000637e:	e8e48493          	addi	s1,s1,-370 # 80026208 <uart_tx_lock>
    80006382:	8526                	mv	a0,s1
    80006384:	00000097          	auipc	ra,0x0
    80006388:	0b4080e7          	jalr	180(ra) # 80006438 <acquire>
  uartstart();
    8000638c:	00000097          	auipc	ra,0x0
    80006390:	e6c080e7          	jalr	-404(ra) # 800061f8 <uartstart>
  release(&uart_tx_lock);
    80006394:	8526                	mv	a0,s1
    80006396:	00000097          	auipc	ra,0x0
    8000639a:	156080e7          	jalr	342(ra) # 800064ec <release>
}
    8000639e:	60e2                	ld	ra,24(sp)
    800063a0:	6442                	ld	s0,16(sp)
    800063a2:	64a2                	ld	s1,8(sp)
    800063a4:	6105                	addi	sp,sp,32
    800063a6:	8082                	ret

00000000800063a8 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800063a8:	1141                	addi	sp,sp,-16
    800063aa:	e422                	sd	s0,8(sp)
    800063ac:	0800                	addi	s0,sp,16
  lk->name = name;
    800063ae:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800063b0:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800063b4:	00053823          	sd	zero,16(a0)
}
    800063b8:	6422                	ld	s0,8(sp)
    800063ba:	0141                	addi	sp,sp,16
    800063bc:	8082                	ret

00000000800063be <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800063be:	411c                	lw	a5,0(a0)
    800063c0:	e399                	bnez	a5,800063c6 <holding+0x8>
    800063c2:	4501                	li	a0,0
  return r;
}
    800063c4:	8082                	ret
{
    800063c6:	1101                	addi	sp,sp,-32
    800063c8:	ec06                	sd	ra,24(sp)
    800063ca:	e822                	sd	s0,16(sp)
    800063cc:	e426                	sd	s1,8(sp)
    800063ce:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800063d0:	6904                	ld	s1,16(a0)
    800063d2:	ffffb097          	auipc	ra,0xffffb
    800063d6:	b98080e7          	jalr	-1128(ra) # 80000f6a <mycpu>
    800063da:	40a48533          	sub	a0,s1,a0
    800063de:	00153513          	seqz	a0,a0
}
    800063e2:	60e2                	ld	ra,24(sp)
    800063e4:	6442                	ld	s0,16(sp)
    800063e6:	64a2                	ld	s1,8(sp)
    800063e8:	6105                	addi	sp,sp,32
    800063ea:	8082                	ret

00000000800063ec <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800063ec:	1101                	addi	sp,sp,-32
    800063ee:	ec06                	sd	ra,24(sp)
    800063f0:	e822                	sd	s0,16(sp)
    800063f2:	e426                	sd	s1,8(sp)
    800063f4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800063f6:	100024f3          	csrr	s1,sstatus
    800063fa:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800063fe:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006400:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006404:	ffffb097          	auipc	ra,0xffffb
    80006408:	b66080e7          	jalr	-1178(ra) # 80000f6a <mycpu>
    8000640c:	5d3c                	lw	a5,120(a0)
    8000640e:	cf89                	beqz	a5,80006428 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006410:	ffffb097          	auipc	ra,0xffffb
    80006414:	b5a080e7          	jalr	-1190(ra) # 80000f6a <mycpu>
    80006418:	5d3c                	lw	a5,120(a0)
    8000641a:	2785                	addiw	a5,a5,1
    8000641c:	dd3c                	sw	a5,120(a0)
}
    8000641e:	60e2                	ld	ra,24(sp)
    80006420:	6442                	ld	s0,16(sp)
    80006422:	64a2                	ld	s1,8(sp)
    80006424:	6105                	addi	sp,sp,32
    80006426:	8082                	ret
    mycpu()->intena = old;
    80006428:	ffffb097          	auipc	ra,0xffffb
    8000642c:	b42080e7          	jalr	-1214(ra) # 80000f6a <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006430:	8085                	srli	s1,s1,0x1
    80006432:	8885                	andi	s1,s1,1
    80006434:	dd64                	sw	s1,124(a0)
    80006436:	bfe9                	j	80006410 <push_off+0x24>

0000000080006438 <acquire>:
{
    80006438:	1101                	addi	sp,sp,-32
    8000643a:	ec06                	sd	ra,24(sp)
    8000643c:	e822                	sd	s0,16(sp)
    8000643e:	e426                	sd	s1,8(sp)
    80006440:	1000                	addi	s0,sp,32
    80006442:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006444:	00000097          	auipc	ra,0x0
    80006448:	fa8080e7          	jalr	-88(ra) # 800063ec <push_off>
  if(holding(lk))
    8000644c:	8526                	mv	a0,s1
    8000644e:	00000097          	auipc	ra,0x0
    80006452:	f70080e7          	jalr	-144(ra) # 800063be <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006456:	4705                	li	a4,1
  if(holding(lk))
    80006458:	e115                	bnez	a0,8000647c <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000645a:	87ba                	mv	a5,a4
    8000645c:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006460:	2781                	sext.w	a5,a5
    80006462:	ffe5                	bnez	a5,8000645a <acquire+0x22>
  __sync_synchronize();
    80006464:	0ff0000f          	fence
  lk->cpu = mycpu();
    80006468:	ffffb097          	auipc	ra,0xffffb
    8000646c:	b02080e7          	jalr	-1278(ra) # 80000f6a <mycpu>
    80006470:	e888                	sd	a0,16(s1)
}
    80006472:	60e2                	ld	ra,24(sp)
    80006474:	6442                	ld	s0,16(sp)
    80006476:	64a2                	ld	s1,8(sp)
    80006478:	6105                	addi	sp,sp,32
    8000647a:	8082                	ret
    panic("acquire");
    8000647c:	00002517          	auipc	a0,0x2
    80006480:	57450513          	addi	a0,a0,1396 # 800089f0 <digits+0x20>
    80006484:	00000097          	auipc	ra,0x0
    80006488:	a7c080e7          	jalr	-1412(ra) # 80005f00 <panic>

000000008000648c <pop_off>:

void
pop_off(void)
{
    8000648c:	1141                	addi	sp,sp,-16
    8000648e:	e406                	sd	ra,8(sp)
    80006490:	e022                	sd	s0,0(sp)
    80006492:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006494:	ffffb097          	auipc	ra,0xffffb
    80006498:	ad6080e7          	jalr	-1322(ra) # 80000f6a <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000649c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800064a0:	8b89                	andi	a5,a5,2
  if(intr_get())
    800064a2:	e78d                	bnez	a5,800064cc <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800064a4:	5d3c                	lw	a5,120(a0)
    800064a6:	02f05b63          	blez	a5,800064dc <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800064aa:	37fd                	addiw	a5,a5,-1
    800064ac:	0007871b          	sext.w	a4,a5
    800064b0:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800064b2:	eb09                	bnez	a4,800064c4 <pop_off+0x38>
    800064b4:	5d7c                	lw	a5,124(a0)
    800064b6:	c799                	beqz	a5,800064c4 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800064b8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800064bc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800064c0:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800064c4:	60a2                	ld	ra,8(sp)
    800064c6:	6402                	ld	s0,0(sp)
    800064c8:	0141                	addi	sp,sp,16
    800064ca:	8082                	ret
    panic("pop_off - interruptible");
    800064cc:	00002517          	auipc	a0,0x2
    800064d0:	52c50513          	addi	a0,a0,1324 # 800089f8 <digits+0x28>
    800064d4:	00000097          	auipc	ra,0x0
    800064d8:	a2c080e7          	jalr	-1492(ra) # 80005f00 <panic>
    panic("pop_off");
    800064dc:	00002517          	auipc	a0,0x2
    800064e0:	53450513          	addi	a0,a0,1332 # 80008a10 <digits+0x40>
    800064e4:	00000097          	auipc	ra,0x0
    800064e8:	a1c080e7          	jalr	-1508(ra) # 80005f00 <panic>

00000000800064ec <release>:
{
    800064ec:	1101                	addi	sp,sp,-32
    800064ee:	ec06                	sd	ra,24(sp)
    800064f0:	e822                	sd	s0,16(sp)
    800064f2:	e426                	sd	s1,8(sp)
    800064f4:	1000                	addi	s0,sp,32
    800064f6:	84aa                	mv	s1,a0
  if(!holding(lk))
    800064f8:	00000097          	auipc	ra,0x0
    800064fc:	ec6080e7          	jalr	-314(ra) # 800063be <holding>
    80006500:	c115                	beqz	a0,80006524 <release+0x38>
  lk->cpu = 0;
    80006502:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006506:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000650a:	0f50000f          	fence	iorw,ow
    8000650e:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006512:	00000097          	auipc	ra,0x0
    80006516:	f7a080e7          	jalr	-134(ra) # 8000648c <pop_off>
}
    8000651a:	60e2                	ld	ra,24(sp)
    8000651c:	6442                	ld	s0,16(sp)
    8000651e:	64a2                	ld	s1,8(sp)
    80006520:	6105                	addi	sp,sp,32
    80006522:	8082                	ret
    panic("release");
    80006524:	00002517          	auipc	a0,0x2
    80006528:	4f450513          	addi	a0,a0,1268 # 80008a18 <digits+0x48>
    8000652c:	00000097          	auipc	ra,0x0
    80006530:	9d4080e7          	jalr	-1580(ra) # 80005f00 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
