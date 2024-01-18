
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	96013103          	ld	sp,-1696(sp) # 80008960 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	317050ef          	jal	ra,80005b2c <start>

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
    80000030:	00022797          	auipc	a5,0x22
    80000034:	ff078793          	addi	a5,a5,-16 # 80022020 <end>
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
    8000004c:	130080e7          	jalr	304(ra) # 80000178 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	96090913          	addi	s2,s2,-1696 # 800089b0 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	4d2080e7          	jalr	1234(ra) # 8000652c <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	572080e7          	jalr	1394(ra) # 800065e0 <release>
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
    8000008e:	f58080e7          	jalr	-168(ra) # 80005fe2 <panic>

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
    800000a4:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	94aa                	add	s1,s1,a0
    800000aa:	757d                	lui	a0,0xfffff
    800000ac:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ae:	94be                	add	s1,s1,a5
    800000b0:	0095ee63          	bltu	a1,s1,800000cc <freerange+0x3a>
    800000b4:	892e                	mv	s2,a1
    kfree(p);
    800000b6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b8:	6985                	lui	s3,0x1
    kfree(p);
    800000ba:	01448533          	add	a0,s1,s4
    800000be:	00000097          	auipc	ra,0x0
    800000c2:	f5e080e7          	jalr	-162(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c6:	94ce                	add	s1,s1,s3
    800000c8:	fe9979e3          	bgeu	s2,s1,800000ba <freerange+0x28>
}
    800000cc:	70a2                	ld	ra,40(sp)
    800000ce:	7402                	ld	s0,32(sp)
    800000d0:	64e2                	ld	s1,24(sp)
    800000d2:	6942                	ld	s2,16(sp)
    800000d4:	69a2                	ld	s3,8(sp)
    800000d6:	6a02                	ld	s4,0(sp)
    800000d8:	6145                	addi	sp,sp,48
    800000da:	8082                	ret

00000000800000dc <kinit>:
{
    800000dc:	1141                	addi	sp,sp,-16
    800000de:	e406                	sd	ra,8(sp)
    800000e0:	e022                	sd	s0,0(sp)
    800000e2:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e4:	00008597          	auipc	a1,0x8
    800000e8:	f3458593          	addi	a1,a1,-204 # 80008018 <etext+0x18>
    800000ec:	00009517          	auipc	a0,0x9
    800000f0:	8c450513          	addi	a0,a0,-1852 # 800089b0 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	3a8080e7          	jalr	936(ra) # 8000649c <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00022517          	auipc	a0,0x22
    80000104:	f2050513          	addi	a0,a0,-224 # 80022020 <end>
    80000108:	00000097          	auipc	ra,0x0
    8000010c:	f8a080e7          	jalr	-118(ra) # 80000092 <freerange>
}
    80000110:	60a2                	ld	ra,8(sp)
    80000112:	6402                	ld	s0,0(sp)
    80000114:	0141                	addi	sp,sp,16
    80000116:	8082                	ret

0000000080000118 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000118:	1101                	addi	sp,sp,-32
    8000011a:	ec06                	sd	ra,24(sp)
    8000011c:	e822                	sd	s0,16(sp)
    8000011e:	e426                	sd	s1,8(sp)
    80000120:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000122:	00009497          	auipc	s1,0x9
    80000126:	88e48493          	addi	s1,s1,-1906 # 800089b0 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	400080e7          	jalr	1024(ra) # 8000652c <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00009517          	auipc	a0,0x9
    8000013e:	87650513          	addi	a0,a0,-1930 # 800089b0 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	49c080e7          	jalr	1180(ra) # 800065e0 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	026080e7          	jalr	38(ra) # 80000178 <memset>
  return (void*)r;
}
    8000015a:	8526                	mv	a0,s1
    8000015c:	60e2                	ld	ra,24(sp)
    8000015e:	6442                	ld	s0,16(sp)
    80000160:	64a2                	ld	s1,8(sp)
    80000162:	6105                	addi	sp,sp,32
    80000164:	8082                	ret
  release(&kmem.lock);
    80000166:	00009517          	auipc	a0,0x9
    8000016a:	84a50513          	addi	a0,a0,-1974 # 800089b0 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	472080e7          	jalr	1138(ra) # 800065e0 <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000178:	1141                	addi	sp,sp,-16
    8000017a:	e422                	sd	s0,8(sp)
    8000017c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000017e:	ce09                	beqz	a2,80000198 <memset+0x20>
    80000180:	87aa                	mv	a5,a0
    80000182:	fff6071b          	addiw	a4,a2,-1
    80000186:	1702                	slli	a4,a4,0x20
    80000188:	9301                	srli	a4,a4,0x20
    8000018a:	0705                	addi	a4,a4,1
    8000018c:	972a                	add	a4,a4,a0
    cdst[i] = c;
    8000018e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000192:	0785                	addi	a5,a5,1
    80000194:	fee79de3          	bne	a5,a4,8000018e <memset+0x16>
  }
  return dst;
}
    80000198:	6422                	ld	s0,8(sp)
    8000019a:	0141                	addi	sp,sp,16
    8000019c:	8082                	ret

000000008000019e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019e:	1141                	addi	sp,sp,-16
    800001a0:	e422                	sd	s0,8(sp)
    800001a2:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a4:	ca05                	beqz	a2,800001d4 <memcmp+0x36>
    800001a6:	fff6069b          	addiw	a3,a2,-1
    800001aa:	1682                	slli	a3,a3,0x20
    800001ac:	9281                	srli	a3,a3,0x20
    800001ae:	0685                	addi	a3,a3,1
    800001b0:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b2:	00054783          	lbu	a5,0(a0)
    800001b6:	0005c703          	lbu	a4,0(a1)
    800001ba:	00e79863          	bne	a5,a4,800001ca <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001be:	0505                	addi	a0,a0,1
    800001c0:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c2:	fed518e3          	bne	a0,a3,800001b2 <memcmp+0x14>
  }

  return 0;
    800001c6:	4501                	li	a0,0
    800001c8:	a019                	j	800001ce <memcmp+0x30>
      return *s1 - *s2;
    800001ca:	40e7853b          	subw	a0,a5,a4
}
    800001ce:	6422                	ld	s0,8(sp)
    800001d0:	0141                	addi	sp,sp,16
    800001d2:	8082                	ret
  return 0;
    800001d4:	4501                	li	a0,0
    800001d6:	bfe5                	j	800001ce <memcmp+0x30>

00000000800001d8 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d8:	1141                	addi	sp,sp,-16
    800001da:	e422                	sd	s0,8(sp)
    800001dc:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001de:	ca0d                	beqz	a2,80000210 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001e0:	00a5f963          	bgeu	a1,a0,800001f2 <memmove+0x1a>
    800001e4:	02061693          	slli	a3,a2,0x20
    800001e8:	9281                	srli	a3,a3,0x20
    800001ea:	00d58733          	add	a4,a1,a3
    800001ee:	02e56463          	bltu	a0,a4,80000216 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001f2:	fff6079b          	addiw	a5,a2,-1
    800001f6:	1782                	slli	a5,a5,0x20
    800001f8:	9381                	srli	a5,a5,0x20
    800001fa:	0785                	addi	a5,a5,1
    800001fc:	97ae                	add	a5,a5,a1
    800001fe:	872a                	mv	a4,a0
      *d++ = *s++;
    80000200:	0585                	addi	a1,a1,1
    80000202:	0705                	addi	a4,a4,1
    80000204:	fff5c683          	lbu	a3,-1(a1)
    80000208:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000020c:	fef59ae3          	bne	a1,a5,80000200 <memmove+0x28>

  return dst;
}
    80000210:	6422                	ld	s0,8(sp)
    80000212:	0141                	addi	sp,sp,16
    80000214:	8082                	ret
    d += n;
    80000216:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000218:	fff6079b          	addiw	a5,a2,-1
    8000021c:	1782                	slli	a5,a5,0x20
    8000021e:	9381                	srli	a5,a5,0x20
    80000220:	fff7c793          	not	a5,a5
    80000224:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000226:	177d                	addi	a4,a4,-1
    80000228:	16fd                	addi	a3,a3,-1
    8000022a:	00074603          	lbu	a2,0(a4)
    8000022e:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000232:	fef71ae3          	bne	a4,a5,80000226 <memmove+0x4e>
    80000236:	bfe9                	j	80000210 <memmove+0x38>

0000000080000238 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000238:	1141                	addi	sp,sp,-16
    8000023a:	e406                	sd	ra,8(sp)
    8000023c:	e022                	sd	s0,0(sp)
    8000023e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000240:	00000097          	auipc	ra,0x0
    80000244:	f98080e7          	jalr	-104(ra) # 800001d8 <memmove>
}
    80000248:	60a2                	ld	ra,8(sp)
    8000024a:	6402                	ld	s0,0(sp)
    8000024c:	0141                	addi	sp,sp,16
    8000024e:	8082                	ret

0000000080000250 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000250:	1141                	addi	sp,sp,-16
    80000252:	e422                	sd	s0,8(sp)
    80000254:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000256:	ce11                	beqz	a2,80000272 <strncmp+0x22>
    80000258:	00054783          	lbu	a5,0(a0)
    8000025c:	cf89                	beqz	a5,80000276 <strncmp+0x26>
    8000025e:	0005c703          	lbu	a4,0(a1)
    80000262:	00f71a63          	bne	a4,a5,80000276 <strncmp+0x26>
    n--, p++, q++;
    80000266:	367d                	addiw	a2,a2,-1
    80000268:	0505                	addi	a0,a0,1
    8000026a:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000026c:	f675                	bnez	a2,80000258 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000026e:	4501                	li	a0,0
    80000270:	a809                	j	80000282 <strncmp+0x32>
    80000272:	4501                	li	a0,0
    80000274:	a039                	j	80000282 <strncmp+0x32>
  if(n == 0)
    80000276:	ca09                	beqz	a2,80000288 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000278:	00054503          	lbu	a0,0(a0)
    8000027c:	0005c783          	lbu	a5,0(a1)
    80000280:	9d1d                	subw	a0,a0,a5
}
    80000282:	6422                	ld	s0,8(sp)
    80000284:	0141                	addi	sp,sp,16
    80000286:	8082                	ret
    return 0;
    80000288:	4501                	li	a0,0
    8000028a:	bfe5                	j	80000282 <strncmp+0x32>

000000008000028c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000028c:	1141                	addi	sp,sp,-16
    8000028e:	e422                	sd	s0,8(sp)
    80000290:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000292:	872a                	mv	a4,a0
    80000294:	8832                	mv	a6,a2
    80000296:	367d                	addiw	a2,a2,-1
    80000298:	01005963          	blez	a6,800002aa <strncpy+0x1e>
    8000029c:	0705                	addi	a4,a4,1
    8000029e:	0005c783          	lbu	a5,0(a1)
    800002a2:	fef70fa3          	sb	a5,-1(a4)
    800002a6:	0585                	addi	a1,a1,1
    800002a8:	f7f5                	bnez	a5,80000294 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002aa:	00c05d63          	blez	a2,800002c4 <strncpy+0x38>
    800002ae:	86ba                	mv	a3,a4
    *s++ = 0;
    800002b0:	0685                	addi	a3,a3,1
    800002b2:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002b6:	fff6c793          	not	a5,a3
    800002ba:	9fb9                	addw	a5,a5,a4
    800002bc:	010787bb          	addw	a5,a5,a6
    800002c0:	fef048e3          	bgtz	a5,800002b0 <strncpy+0x24>
  return os;
}
    800002c4:	6422                	ld	s0,8(sp)
    800002c6:	0141                	addi	sp,sp,16
    800002c8:	8082                	ret

00000000800002ca <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002ca:	1141                	addi	sp,sp,-16
    800002cc:	e422                	sd	s0,8(sp)
    800002ce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002d0:	02c05363          	blez	a2,800002f6 <safestrcpy+0x2c>
    800002d4:	fff6069b          	addiw	a3,a2,-1
    800002d8:	1682                	slli	a3,a3,0x20
    800002da:	9281                	srli	a3,a3,0x20
    800002dc:	96ae                	add	a3,a3,a1
    800002de:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002e0:	00d58963          	beq	a1,a3,800002f2 <safestrcpy+0x28>
    800002e4:	0585                	addi	a1,a1,1
    800002e6:	0785                	addi	a5,a5,1
    800002e8:	fff5c703          	lbu	a4,-1(a1)
    800002ec:	fee78fa3          	sb	a4,-1(a5)
    800002f0:	fb65                	bnez	a4,800002e0 <safestrcpy+0x16>
    ;
  *s = 0;
    800002f2:	00078023          	sb	zero,0(a5)
  return os;
}
    800002f6:	6422                	ld	s0,8(sp)
    800002f8:	0141                	addi	sp,sp,16
    800002fa:	8082                	ret

00000000800002fc <strlen>:

int
strlen(const char *s)
{
    800002fc:	1141                	addi	sp,sp,-16
    800002fe:	e422                	sd	s0,8(sp)
    80000300:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000302:	00054783          	lbu	a5,0(a0)
    80000306:	cf91                	beqz	a5,80000322 <strlen+0x26>
    80000308:	0505                	addi	a0,a0,1
    8000030a:	87aa                	mv	a5,a0
    8000030c:	4685                	li	a3,1
    8000030e:	9e89                	subw	a3,a3,a0
    80000310:	00f6853b          	addw	a0,a3,a5
    80000314:	0785                	addi	a5,a5,1
    80000316:	fff7c703          	lbu	a4,-1(a5)
    8000031a:	fb7d                	bnez	a4,80000310 <strlen+0x14>
    ;
  return n;
}
    8000031c:	6422                	ld	s0,8(sp)
    8000031e:	0141                	addi	sp,sp,16
    80000320:	8082                	ret
  for(n = 0; s[n]; n++)
    80000322:	4501                	li	a0,0
    80000324:	bfe5                	j	8000031c <strlen+0x20>

0000000080000326 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000326:	1141                	addi	sp,sp,-16
    80000328:	e406                	sd	ra,8(sp)
    8000032a:	e022                	sd	s0,0(sp)
    8000032c:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000032e:	00001097          	auipc	ra,0x1
    80000332:	cf8080e7          	jalr	-776(ra) # 80001026 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000336:	00008717          	auipc	a4,0x8
    8000033a:	64a70713          	addi	a4,a4,1610 # 80008980 <started>
  if(cpuid() == 0){
    8000033e:	c139                	beqz	a0,80000384 <main+0x5e>
    while(started == 0)
    80000340:	431c                	lw	a5,0(a4)
    80000342:	2781                	sext.w	a5,a5
    80000344:	dff5                	beqz	a5,80000340 <main+0x1a>
      ;
    __sync_synchronize();
    80000346:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000034a:	00001097          	auipc	ra,0x1
    8000034e:	cdc080e7          	jalr	-804(ra) # 80001026 <cpuid>
    80000352:	85aa                	mv	a1,a0
    80000354:	00008517          	auipc	a0,0x8
    80000358:	ce450513          	addi	a0,a0,-796 # 80008038 <etext+0x38>
    8000035c:	00006097          	auipc	ra,0x6
    80000360:	cd0080e7          	jalr	-816(ra) # 8000602c <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00002097          	auipc	ra,0x2
    80000370:	b2a080e7          	jalr	-1238(ra) # 80001e96 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	10c080e7          	jalr	268(ra) # 80005480 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	264080e7          	jalr	612(ra) # 800015e0 <scheduler>
    consoleinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	b70080e7          	jalr	-1168(ra) # 80005ef4 <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	e86080e7          	jalr	-378(ra) # 80006212 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	c90080e7          	jalr	-880(ra) # 8000602c <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	c80080e7          	jalr	-896(ra) # 8000602c <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	c70080e7          	jalr	-912(ra) # 8000602c <printf>
    kinit();         // physical page allocator
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	d18080e7          	jalr	-744(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	34a080e7          	jalr	842(ra) # 80000716 <kvminit>
    kvminithart();   // turn on paging
    800003d4:	00000097          	auipc	ra,0x0
    800003d8:	068080e7          	jalr	104(ra) # 8000043c <kvminithart>
    procinit();      // process table
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	b98080e7          	jalr	-1128(ra) # 80000f74 <procinit>
    trapinit();      // trap vectors
    800003e4:	00002097          	auipc	ra,0x2
    800003e8:	a8a080e7          	jalr	-1398(ra) # 80001e6e <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00002097          	auipc	ra,0x2
    800003f0:	aaa080e7          	jalr	-1366(ra) # 80001e96 <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	076080e7          	jalr	118(ra) # 8000546a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	084080e7          	jalr	132(ra) # 80005480 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	21c080e7          	jalr	540(ra) # 80002620 <binit>
    iinit();         // inode table
    8000040c:	00003097          	auipc	ra,0x3
    80000410:	8c0080e7          	jalr	-1856(ra) # 80002ccc <iinit>
    fileinit();      // file table
    80000414:	00004097          	auipc	ra,0x4
    80000418:	85e080e7          	jalr	-1954(ra) # 80003c72 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	16c080e7          	jalr	364(ra) # 80005588 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	fa2080e7          	jalr	-94(ra) # 800013c6 <userinit>
    __sync_synchronize();
    8000042c:	0ff0000f          	fence
    started = 1;
    80000430:	4785                	li	a5,1
    80000432:	00008717          	auipc	a4,0x8
    80000436:	54f72723          	sw	a5,1358(a4) # 80008980 <started>
    8000043a:	b789                	j	8000037c <main+0x56>

000000008000043c <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000043c:	1141                	addi	sp,sp,-16
    8000043e:	e422                	sd	s0,8(sp)
    80000440:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000442:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000446:	00008797          	auipc	a5,0x8
    8000044a:	5427b783          	ld	a5,1346(a5) # 80008988 <kernel_pagetable>
    8000044e:	83b1                	srli	a5,a5,0xc
    80000450:	577d                	li	a4,-1
    80000452:	177e                	slli	a4,a4,0x3f
    80000454:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000456:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    8000045a:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    8000045e:	6422                	ld	s0,8(sp)
    80000460:	0141                	addi	sp,sp,16
    80000462:	8082                	ret

0000000080000464 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000464:	7139                	addi	sp,sp,-64
    80000466:	fc06                	sd	ra,56(sp)
    80000468:	f822                	sd	s0,48(sp)
    8000046a:	f426                	sd	s1,40(sp)
    8000046c:	f04a                	sd	s2,32(sp)
    8000046e:	ec4e                	sd	s3,24(sp)
    80000470:	e852                	sd	s4,16(sp)
    80000472:	e456                	sd	s5,8(sp)
    80000474:	e05a                	sd	s6,0(sp)
    80000476:	0080                	addi	s0,sp,64
    80000478:	84aa                	mv	s1,a0
    8000047a:	89ae                	mv	s3,a1
    8000047c:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000047e:	57fd                	li	a5,-1
    80000480:	83e9                	srli	a5,a5,0x1a
    80000482:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000484:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000486:	04b7f263          	bgeu	a5,a1,800004ca <walk+0x66>
    panic("walk");
    8000048a:	00008517          	auipc	a0,0x8
    8000048e:	bc650513          	addi	a0,a0,-1082 # 80008050 <etext+0x50>
    80000492:	00006097          	auipc	ra,0x6
    80000496:	b50080e7          	jalr	-1200(ra) # 80005fe2 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000049a:	060a8663          	beqz	s5,80000506 <walk+0xa2>
    8000049e:	00000097          	auipc	ra,0x0
    800004a2:	c7a080e7          	jalr	-902(ra) # 80000118 <kalloc>
    800004a6:	84aa                	mv	s1,a0
    800004a8:	c529                	beqz	a0,800004f2 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004aa:	6605                	lui	a2,0x1
    800004ac:	4581                	li	a1,0
    800004ae:	00000097          	auipc	ra,0x0
    800004b2:	cca080e7          	jalr	-822(ra) # 80000178 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004b6:	00c4d793          	srli	a5,s1,0xc
    800004ba:	07aa                	slli	a5,a5,0xa
    800004bc:	0017e793          	ori	a5,a5,1
    800004c0:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004c4:	3a5d                	addiw	s4,s4,-9
    800004c6:	036a0063          	beq	s4,s6,800004e6 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004ca:	0149d933          	srl	s2,s3,s4
    800004ce:	1ff97913          	andi	s2,s2,511
    800004d2:	090e                	slli	s2,s2,0x3
    800004d4:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004d6:	00093483          	ld	s1,0(s2)
    800004da:	0014f793          	andi	a5,s1,1
    800004de:	dfd5                	beqz	a5,8000049a <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004e0:	80a9                	srli	s1,s1,0xa
    800004e2:	04b2                	slli	s1,s1,0xc
    800004e4:	b7c5                	j	800004c4 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004e6:	00c9d513          	srli	a0,s3,0xc
    800004ea:	1ff57513          	andi	a0,a0,511
    800004ee:	050e                	slli	a0,a0,0x3
    800004f0:	9526                	add	a0,a0,s1
}
    800004f2:	70e2                	ld	ra,56(sp)
    800004f4:	7442                	ld	s0,48(sp)
    800004f6:	74a2                	ld	s1,40(sp)
    800004f8:	7902                	ld	s2,32(sp)
    800004fa:	69e2                	ld	s3,24(sp)
    800004fc:	6a42                	ld	s4,16(sp)
    800004fe:	6aa2                	ld	s5,8(sp)
    80000500:	6b02                	ld	s6,0(sp)
    80000502:	6121                	addi	sp,sp,64
    80000504:	8082                	ret
        return 0;
    80000506:	4501                	li	a0,0
    80000508:	b7ed                	j	800004f2 <walk+0x8e>

000000008000050a <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000050a:	57fd                	li	a5,-1
    8000050c:	83e9                	srli	a5,a5,0x1a
    8000050e:	00b7f463          	bgeu	a5,a1,80000516 <walkaddr+0xc>
    return 0;
    80000512:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000514:	8082                	ret
{
    80000516:	1141                	addi	sp,sp,-16
    80000518:	e406                	sd	ra,8(sp)
    8000051a:	e022                	sd	s0,0(sp)
    8000051c:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000051e:	4601                	li	a2,0
    80000520:	00000097          	auipc	ra,0x0
    80000524:	f44080e7          	jalr	-188(ra) # 80000464 <walk>
  if(pte == 0)
    80000528:	c105                	beqz	a0,80000548 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000052a:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000052c:	0117f693          	andi	a3,a5,17
    80000530:	4745                	li	a4,17
    return 0;
    80000532:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000534:	00e68663          	beq	a3,a4,80000540 <walkaddr+0x36>
}
    80000538:	60a2                	ld	ra,8(sp)
    8000053a:	6402                	ld	s0,0(sp)
    8000053c:	0141                	addi	sp,sp,16
    8000053e:	8082                	ret
  pa = PTE2PA(*pte);
    80000540:	00a7d513          	srli	a0,a5,0xa
    80000544:	0532                	slli	a0,a0,0xc
  return pa;
    80000546:	bfcd                	j	80000538 <walkaddr+0x2e>
    return 0;
    80000548:	4501                	li	a0,0
    8000054a:	b7fd                	j	80000538 <walkaddr+0x2e>

000000008000054c <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000054c:	715d                	addi	sp,sp,-80
    8000054e:	e486                	sd	ra,72(sp)
    80000550:	e0a2                	sd	s0,64(sp)
    80000552:	fc26                	sd	s1,56(sp)
    80000554:	f84a                	sd	s2,48(sp)
    80000556:	f44e                	sd	s3,40(sp)
    80000558:	f052                	sd	s4,32(sp)
    8000055a:	ec56                	sd	s5,24(sp)
    8000055c:	e85a                	sd	s6,16(sp)
    8000055e:	e45e                	sd	s7,8(sp)
    80000560:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000562:	03459793          	slli	a5,a1,0x34
    80000566:	e385                	bnez	a5,80000586 <mappages+0x3a>
    80000568:	8aaa                	mv	s5,a0
    8000056a:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    8000056c:	03461793          	slli	a5,a2,0x34
    80000570:	e39d                	bnez	a5,80000596 <mappages+0x4a>
    panic("mappages: size not aligned");

  if(size == 0)
    80000572:	ca15                	beqz	a2,800005a6 <mappages+0x5a>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    80000574:	79fd                	lui	s3,0xfffff
    80000576:	964e                	add	a2,a2,s3
    80000578:	00b609b3          	add	s3,a2,a1
  a = va;
    8000057c:	892e                	mv	s2,a1
    8000057e:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000582:	6b85                	lui	s7,0x1
    80000584:	a091                	j	800005c8 <mappages+0x7c>
    panic("mappages: va not aligned");
    80000586:	00008517          	auipc	a0,0x8
    8000058a:	ad250513          	addi	a0,a0,-1326 # 80008058 <etext+0x58>
    8000058e:	00006097          	auipc	ra,0x6
    80000592:	a54080e7          	jalr	-1452(ra) # 80005fe2 <panic>
    panic("mappages: size not aligned");
    80000596:	00008517          	auipc	a0,0x8
    8000059a:	ae250513          	addi	a0,a0,-1310 # 80008078 <etext+0x78>
    8000059e:	00006097          	auipc	ra,0x6
    800005a2:	a44080e7          	jalr	-1468(ra) # 80005fe2 <panic>
    panic("mappages: size");
    800005a6:	00008517          	auipc	a0,0x8
    800005aa:	af250513          	addi	a0,a0,-1294 # 80008098 <etext+0x98>
    800005ae:	00006097          	auipc	ra,0x6
    800005b2:	a34080e7          	jalr	-1484(ra) # 80005fe2 <panic>
      panic("mappages: remap");
    800005b6:	00008517          	auipc	a0,0x8
    800005ba:	af250513          	addi	a0,a0,-1294 # 800080a8 <etext+0xa8>
    800005be:	00006097          	auipc	ra,0x6
    800005c2:	a24080e7          	jalr	-1500(ra) # 80005fe2 <panic>
    a += PGSIZE;
    800005c6:	995e                	add	s2,s2,s7
  for(;;){
    800005c8:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005cc:	4605                	li	a2,1
    800005ce:	85ca                	mv	a1,s2
    800005d0:	8556                	mv	a0,s5
    800005d2:	00000097          	auipc	ra,0x0
    800005d6:	e92080e7          	jalr	-366(ra) # 80000464 <walk>
    800005da:	cd19                	beqz	a0,800005f8 <mappages+0xac>
    if(*pte & PTE_V)
    800005dc:	611c                	ld	a5,0(a0)
    800005de:	8b85                	andi	a5,a5,1
    800005e0:	fbf9                	bnez	a5,800005b6 <mappages+0x6a>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005e2:	80b1                	srli	s1,s1,0xc
    800005e4:	04aa                	slli	s1,s1,0xa
    800005e6:	0164e4b3          	or	s1,s1,s6
    800005ea:	0014e493          	ori	s1,s1,1
    800005ee:	e104                	sd	s1,0(a0)
    if(a == last)
    800005f0:	fd391be3          	bne	s2,s3,800005c6 <mappages+0x7a>
    pa += PGSIZE;
  }
  return 0;
    800005f4:	4501                	li	a0,0
    800005f6:	a011                	j	800005fa <mappages+0xae>
      return -1;
    800005f8:	557d                	li	a0,-1
}
    800005fa:	60a6                	ld	ra,72(sp)
    800005fc:	6406                	ld	s0,64(sp)
    800005fe:	74e2                	ld	s1,56(sp)
    80000600:	7942                	ld	s2,48(sp)
    80000602:	79a2                	ld	s3,40(sp)
    80000604:	7a02                	ld	s4,32(sp)
    80000606:	6ae2                	ld	s5,24(sp)
    80000608:	6b42                	ld	s6,16(sp)
    8000060a:	6ba2                	ld	s7,8(sp)
    8000060c:	6161                	addi	sp,sp,80
    8000060e:	8082                	ret

0000000080000610 <kvmmap>:
{
    80000610:	1141                	addi	sp,sp,-16
    80000612:	e406                	sd	ra,8(sp)
    80000614:	e022                	sd	s0,0(sp)
    80000616:	0800                	addi	s0,sp,16
    80000618:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000061a:	86b2                	mv	a3,a2
    8000061c:	863e                	mv	a2,a5
    8000061e:	00000097          	auipc	ra,0x0
    80000622:	f2e080e7          	jalr	-210(ra) # 8000054c <mappages>
    80000626:	e509                	bnez	a0,80000630 <kvmmap+0x20>
}
    80000628:	60a2                	ld	ra,8(sp)
    8000062a:	6402                	ld	s0,0(sp)
    8000062c:	0141                	addi	sp,sp,16
    8000062e:	8082                	ret
    panic("kvmmap");
    80000630:	00008517          	auipc	a0,0x8
    80000634:	a8850513          	addi	a0,a0,-1400 # 800080b8 <etext+0xb8>
    80000638:	00006097          	auipc	ra,0x6
    8000063c:	9aa080e7          	jalr	-1622(ra) # 80005fe2 <panic>

0000000080000640 <kvmmake>:
{
    80000640:	1101                	addi	sp,sp,-32
    80000642:	ec06                	sd	ra,24(sp)
    80000644:	e822                	sd	s0,16(sp)
    80000646:	e426                	sd	s1,8(sp)
    80000648:	e04a                	sd	s2,0(sp)
    8000064a:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000064c:	00000097          	auipc	ra,0x0
    80000650:	acc080e7          	jalr	-1332(ra) # 80000118 <kalloc>
    80000654:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000656:	6605                	lui	a2,0x1
    80000658:	4581                	li	a1,0
    8000065a:	00000097          	auipc	ra,0x0
    8000065e:	b1e080e7          	jalr	-1250(ra) # 80000178 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000662:	4719                	li	a4,6
    80000664:	6685                	lui	a3,0x1
    80000666:	10000637          	lui	a2,0x10000
    8000066a:	100005b7          	lui	a1,0x10000
    8000066e:	8526                	mv	a0,s1
    80000670:	00000097          	auipc	ra,0x0
    80000674:	fa0080e7          	jalr	-96(ra) # 80000610 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000678:	4719                	li	a4,6
    8000067a:	6685                	lui	a3,0x1
    8000067c:	10001637          	lui	a2,0x10001
    80000680:	100015b7          	lui	a1,0x10001
    80000684:	8526                	mv	a0,s1
    80000686:	00000097          	auipc	ra,0x0
    8000068a:	f8a080e7          	jalr	-118(ra) # 80000610 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000068e:	4719                	li	a4,6
    80000690:	004006b7          	lui	a3,0x400
    80000694:	0c000637          	lui	a2,0xc000
    80000698:	0c0005b7          	lui	a1,0xc000
    8000069c:	8526                	mv	a0,s1
    8000069e:	00000097          	auipc	ra,0x0
    800006a2:	f72080e7          	jalr	-142(ra) # 80000610 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006a6:	00008917          	auipc	s2,0x8
    800006aa:	95a90913          	addi	s2,s2,-1702 # 80008000 <etext>
    800006ae:	4729                	li	a4,10
    800006b0:	80008697          	auipc	a3,0x80008
    800006b4:	95068693          	addi	a3,a3,-1712 # 8000 <_entry-0x7fff8000>
    800006b8:	4605                	li	a2,1
    800006ba:	067e                	slli	a2,a2,0x1f
    800006bc:	85b2                	mv	a1,a2
    800006be:	8526                	mv	a0,s1
    800006c0:	00000097          	auipc	ra,0x0
    800006c4:	f50080e7          	jalr	-176(ra) # 80000610 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006c8:	4719                	li	a4,6
    800006ca:	46c5                	li	a3,17
    800006cc:	06ee                	slli	a3,a3,0x1b
    800006ce:	412686b3          	sub	a3,a3,s2
    800006d2:	864a                	mv	a2,s2
    800006d4:	85ca                	mv	a1,s2
    800006d6:	8526                	mv	a0,s1
    800006d8:	00000097          	auipc	ra,0x0
    800006dc:	f38080e7          	jalr	-200(ra) # 80000610 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006e0:	4729                	li	a4,10
    800006e2:	6685                	lui	a3,0x1
    800006e4:	00007617          	auipc	a2,0x7
    800006e8:	91c60613          	addi	a2,a2,-1764 # 80007000 <_trampoline>
    800006ec:	040005b7          	lui	a1,0x4000
    800006f0:	15fd                	addi	a1,a1,-1
    800006f2:	05b2                	slli	a1,a1,0xc
    800006f4:	8526                	mv	a0,s1
    800006f6:	00000097          	auipc	ra,0x0
    800006fa:	f1a080e7          	jalr	-230(ra) # 80000610 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006fe:	8526                	mv	a0,s1
    80000700:	00000097          	auipc	ra,0x0
    80000704:	7e0080e7          	jalr	2016(ra) # 80000ee0 <proc_mapstacks>
}
    80000708:	8526                	mv	a0,s1
    8000070a:	60e2                	ld	ra,24(sp)
    8000070c:	6442                	ld	s0,16(sp)
    8000070e:	64a2                	ld	s1,8(sp)
    80000710:	6902                	ld	s2,0(sp)
    80000712:	6105                	addi	sp,sp,32
    80000714:	8082                	ret

0000000080000716 <kvminit>:
{
    80000716:	1141                	addi	sp,sp,-16
    80000718:	e406                	sd	ra,8(sp)
    8000071a:	e022                	sd	s0,0(sp)
    8000071c:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000071e:	00000097          	auipc	ra,0x0
    80000722:	f22080e7          	jalr	-222(ra) # 80000640 <kvmmake>
    80000726:	00008797          	auipc	a5,0x8
    8000072a:	26a7b123          	sd	a0,610(a5) # 80008988 <kernel_pagetable>
}
    8000072e:	60a2                	ld	ra,8(sp)
    80000730:	6402                	ld	s0,0(sp)
    80000732:	0141                	addi	sp,sp,16
    80000734:	8082                	ret

0000000080000736 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000736:	715d                	addi	sp,sp,-80
    80000738:	e486                	sd	ra,72(sp)
    8000073a:	e0a2                	sd	s0,64(sp)
    8000073c:	fc26                	sd	s1,56(sp)
    8000073e:	f84a                	sd	s2,48(sp)
    80000740:	f44e                	sd	s3,40(sp)
    80000742:	f052                	sd	s4,32(sp)
    80000744:	ec56                	sd	s5,24(sp)
    80000746:	e85a                	sd	s6,16(sp)
    80000748:	e45e                	sd	s7,8(sp)
    8000074a:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000074c:	03459793          	slli	a5,a1,0x34
    80000750:	e795                	bnez	a5,8000077c <uvmunmap+0x46>
    80000752:	8a2a                	mv	s4,a0
    80000754:	892e                	mv	s2,a1
    80000756:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000758:	0632                	slli	a2,a2,0xc
    8000075a:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000075e:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000760:	6b05                	lui	s6,0x1
    80000762:	0735e863          	bltu	a1,s3,800007d2 <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000766:	60a6                	ld	ra,72(sp)
    80000768:	6406                	ld	s0,64(sp)
    8000076a:	74e2                	ld	s1,56(sp)
    8000076c:	7942                	ld	s2,48(sp)
    8000076e:	79a2                	ld	s3,40(sp)
    80000770:	7a02                	ld	s4,32(sp)
    80000772:	6ae2                	ld	s5,24(sp)
    80000774:	6b42                	ld	s6,16(sp)
    80000776:	6ba2                	ld	s7,8(sp)
    80000778:	6161                	addi	sp,sp,80
    8000077a:	8082                	ret
    panic("uvmunmap: not aligned");
    8000077c:	00008517          	auipc	a0,0x8
    80000780:	94450513          	addi	a0,a0,-1724 # 800080c0 <etext+0xc0>
    80000784:	00006097          	auipc	ra,0x6
    80000788:	85e080e7          	jalr	-1954(ra) # 80005fe2 <panic>
      panic("uvmunmap: walk");
    8000078c:	00008517          	auipc	a0,0x8
    80000790:	94c50513          	addi	a0,a0,-1716 # 800080d8 <etext+0xd8>
    80000794:	00006097          	auipc	ra,0x6
    80000798:	84e080e7          	jalr	-1970(ra) # 80005fe2 <panic>
      panic("uvmunmap: not mapped");
    8000079c:	00008517          	auipc	a0,0x8
    800007a0:	94c50513          	addi	a0,a0,-1716 # 800080e8 <etext+0xe8>
    800007a4:	00006097          	auipc	ra,0x6
    800007a8:	83e080e7          	jalr	-1986(ra) # 80005fe2 <panic>
      panic("uvmunmap: not a leaf");
    800007ac:	00008517          	auipc	a0,0x8
    800007b0:	95450513          	addi	a0,a0,-1708 # 80008100 <etext+0x100>
    800007b4:	00006097          	auipc	ra,0x6
    800007b8:	82e080e7          	jalr	-2002(ra) # 80005fe2 <panic>
      uint64 pa = PTE2PA(*pte);
    800007bc:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007be:	0532                	slli	a0,a0,0xc
    800007c0:	00000097          	auipc	ra,0x0
    800007c4:	85c080e7          	jalr	-1956(ra) # 8000001c <kfree>
    *pte = 0;
    800007c8:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007cc:	995a                	add	s2,s2,s6
    800007ce:	f9397ce3          	bgeu	s2,s3,80000766 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007d2:	4601                	li	a2,0
    800007d4:	85ca                	mv	a1,s2
    800007d6:	8552                	mv	a0,s4
    800007d8:	00000097          	auipc	ra,0x0
    800007dc:	c8c080e7          	jalr	-884(ra) # 80000464 <walk>
    800007e0:	84aa                	mv	s1,a0
    800007e2:	d54d                	beqz	a0,8000078c <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007e4:	6108                	ld	a0,0(a0)
    800007e6:	00157793          	andi	a5,a0,1
    800007ea:	dbcd                	beqz	a5,8000079c <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007ec:	3ff57793          	andi	a5,a0,1023
    800007f0:	fb778ee3          	beq	a5,s7,800007ac <uvmunmap+0x76>
    if(do_free){
    800007f4:	fc0a8ae3          	beqz	s5,800007c8 <uvmunmap+0x92>
    800007f8:	b7d1                	j	800007bc <uvmunmap+0x86>

00000000800007fa <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007fa:	1101                	addi	sp,sp,-32
    800007fc:	ec06                	sd	ra,24(sp)
    800007fe:	e822                	sd	s0,16(sp)
    80000800:	e426                	sd	s1,8(sp)
    80000802:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000804:	00000097          	auipc	ra,0x0
    80000808:	914080e7          	jalr	-1772(ra) # 80000118 <kalloc>
    8000080c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000080e:	c519                	beqz	a0,8000081c <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000810:	6605                	lui	a2,0x1
    80000812:	4581                	li	a1,0
    80000814:	00000097          	auipc	ra,0x0
    80000818:	964080e7          	jalr	-1692(ra) # 80000178 <memset>
  return pagetable;
}
    8000081c:	8526                	mv	a0,s1
    8000081e:	60e2                	ld	ra,24(sp)
    80000820:	6442                	ld	s0,16(sp)
    80000822:	64a2                	ld	s1,8(sp)
    80000824:	6105                	addi	sp,sp,32
    80000826:	8082                	ret

0000000080000828 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000828:	7179                	addi	sp,sp,-48
    8000082a:	f406                	sd	ra,40(sp)
    8000082c:	f022                	sd	s0,32(sp)
    8000082e:	ec26                	sd	s1,24(sp)
    80000830:	e84a                	sd	s2,16(sp)
    80000832:	e44e                	sd	s3,8(sp)
    80000834:	e052                	sd	s4,0(sp)
    80000836:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000838:	6785                	lui	a5,0x1
    8000083a:	04f67863          	bgeu	a2,a5,8000088a <uvmfirst+0x62>
    8000083e:	8a2a                	mv	s4,a0
    80000840:	89ae                	mv	s3,a1
    80000842:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000844:	00000097          	auipc	ra,0x0
    80000848:	8d4080e7          	jalr	-1836(ra) # 80000118 <kalloc>
    8000084c:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000084e:	6605                	lui	a2,0x1
    80000850:	4581                	li	a1,0
    80000852:	00000097          	auipc	ra,0x0
    80000856:	926080e7          	jalr	-1754(ra) # 80000178 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000085a:	4779                	li	a4,30
    8000085c:	86ca                	mv	a3,s2
    8000085e:	6605                	lui	a2,0x1
    80000860:	4581                	li	a1,0
    80000862:	8552                	mv	a0,s4
    80000864:	00000097          	auipc	ra,0x0
    80000868:	ce8080e7          	jalr	-792(ra) # 8000054c <mappages>
  memmove(mem, src, sz);
    8000086c:	8626                	mv	a2,s1
    8000086e:	85ce                	mv	a1,s3
    80000870:	854a                	mv	a0,s2
    80000872:	00000097          	auipc	ra,0x0
    80000876:	966080e7          	jalr	-1690(ra) # 800001d8 <memmove>
}
    8000087a:	70a2                	ld	ra,40(sp)
    8000087c:	7402                	ld	s0,32(sp)
    8000087e:	64e2                	ld	s1,24(sp)
    80000880:	6942                	ld	s2,16(sp)
    80000882:	69a2                	ld	s3,8(sp)
    80000884:	6a02                	ld	s4,0(sp)
    80000886:	6145                	addi	sp,sp,48
    80000888:	8082                	ret
    panic("uvmfirst: more than a page");
    8000088a:	00008517          	auipc	a0,0x8
    8000088e:	88e50513          	addi	a0,a0,-1906 # 80008118 <etext+0x118>
    80000892:	00005097          	auipc	ra,0x5
    80000896:	750080e7          	jalr	1872(ra) # 80005fe2 <panic>

000000008000089a <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000089a:	1101                	addi	sp,sp,-32
    8000089c:	ec06                	sd	ra,24(sp)
    8000089e:	e822                	sd	s0,16(sp)
    800008a0:	e426                	sd	s1,8(sp)
    800008a2:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008a4:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008a6:	00b67d63          	bgeu	a2,a1,800008c0 <uvmdealloc+0x26>
    800008aa:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008ac:	6785                	lui	a5,0x1
    800008ae:	17fd                	addi	a5,a5,-1
    800008b0:	00f60733          	add	a4,a2,a5
    800008b4:	767d                	lui	a2,0xfffff
    800008b6:	8f71                	and	a4,a4,a2
    800008b8:	97ae                	add	a5,a5,a1
    800008ba:	8ff1                	and	a5,a5,a2
    800008bc:	00f76863          	bltu	a4,a5,800008cc <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008c0:	8526                	mv	a0,s1
    800008c2:	60e2                	ld	ra,24(sp)
    800008c4:	6442                	ld	s0,16(sp)
    800008c6:	64a2                	ld	s1,8(sp)
    800008c8:	6105                	addi	sp,sp,32
    800008ca:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008cc:	8f99                	sub	a5,a5,a4
    800008ce:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008d0:	4685                	li	a3,1
    800008d2:	0007861b          	sext.w	a2,a5
    800008d6:	85ba                	mv	a1,a4
    800008d8:	00000097          	auipc	ra,0x0
    800008dc:	e5e080e7          	jalr	-418(ra) # 80000736 <uvmunmap>
    800008e0:	b7c5                	j	800008c0 <uvmdealloc+0x26>

00000000800008e2 <uvmalloc>:
  if(newsz < oldsz)
    800008e2:	0ab66563          	bltu	a2,a1,8000098c <uvmalloc+0xaa>
{
    800008e6:	7139                	addi	sp,sp,-64
    800008e8:	fc06                	sd	ra,56(sp)
    800008ea:	f822                	sd	s0,48(sp)
    800008ec:	f426                	sd	s1,40(sp)
    800008ee:	f04a                	sd	s2,32(sp)
    800008f0:	ec4e                	sd	s3,24(sp)
    800008f2:	e852                	sd	s4,16(sp)
    800008f4:	e456                	sd	s5,8(sp)
    800008f6:	e05a                	sd	s6,0(sp)
    800008f8:	0080                	addi	s0,sp,64
    800008fa:	8aaa                	mv	s5,a0
    800008fc:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008fe:	6985                	lui	s3,0x1
    80000900:	19fd                	addi	s3,s3,-1
    80000902:	95ce                	add	a1,a1,s3
    80000904:	79fd                	lui	s3,0xfffff
    80000906:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000090a:	08c9f363          	bgeu	s3,a2,80000990 <uvmalloc+0xae>
    8000090e:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000910:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80000914:	00000097          	auipc	ra,0x0
    80000918:	804080e7          	jalr	-2044(ra) # 80000118 <kalloc>
    8000091c:	84aa                	mv	s1,a0
    if(mem == 0){
    8000091e:	c51d                	beqz	a0,8000094c <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    80000920:	6605                	lui	a2,0x1
    80000922:	4581                	li	a1,0
    80000924:	00000097          	auipc	ra,0x0
    80000928:	854080e7          	jalr	-1964(ra) # 80000178 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000092c:	875a                	mv	a4,s6
    8000092e:	86a6                	mv	a3,s1
    80000930:	6605                	lui	a2,0x1
    80000932:	85ca                	mv	a1,s2
    80000934:	8556                	mv	a0,s5
    80000936:	00000097          	auipc	ra,0x0
    8000093a:	c16080e7          	jalr	-1002(ra) # 8000054c <mappages>
    8000093e:	e90d                	bnez	a0,80000970 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000940:	6785                	lui	a5,0x1
    80000942:	993e                	add	s2,s2,a5
    80000944:	fd4968e3          	bltu	s2,s4,80000914 <uvmalloc+0x32>
  return newsz;
    80000948:	8552                	mv	a0,s4
    8000094a:	a809                	j	8000095c <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    8000094c:	864e                	mv	a2,s3
    8000094e:	85ca                	mv	a1,s2
    80000950:	8556                	mv	a0,s5
    80000952:	00000097          	auipc	ra,0x0
    80000956:	f48080e7          	jalr	-184(ra) # 8000089a <uvmdealloc>
      return 0;
    8000095a:	4501                	li	a0,0
}
    8000095c:	70e2                	ld	ra,56(sp)
    8000095e:	7442                	ld	s0,48(sp)
    80000960:	74a2                	ld	s1,40(sp)
    80000962:	7902                	ld	s2,32(sp)
    80000964:	69e2                	ld	s3,24(sp)
    80000966:	6a42                	ld	s4,16(sp)
    80000968:	6aa2                	ld	s5,8(sp)
    8000096a:	6b02                	ld	s6,0(sp)
    8000096c:	6121                	addi	sp,sp,64
    8000096e:	8082                	ret
      kfree(mem);
    80000970:	8526                	mv	a0,s1
    80000972:	fffff097          	auipc	ra,0xfffff
    80000976:	6aa080e7          	jalr	1706(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000097a:	864e                	mv	a2,s3
    8000097c:	85ca                	mv	a1,s2
    8000097e:	8556                	mv	a0,s5
    80000980:	00000097          	auipc	ra,0x0
    80000984:	f1a080e7          	jalr	-230(ra) # 8000089a <uvmdealloc>
      return 0;
    80000988:	4501                	li	a0,0
    8000098a:	bfc9                	j	8000095c <uvmalloc+0x7a>
    return oldsz;
    8000098c:	852e                	mv	a0,a1
}
    8000098e:	8082                	ret
  return newsz;
    80000990:	8532                	mv	a0,a2
    80000992:	b7e9                	j	8000095c <uvmalloc+0x7a>

0000000080000994 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000994:	7179                	addi	sp,sp,-48
    80000996:	f406                	sd	ra,40(sp)
    80000998:	f022                	sd	s0,32(sp)
    8000099a:	ec26                	sd	s1,24(sp)
    8000099c:	e84a                	sd	s2,16(sp)
    8000099e:	e44e                	sd	s3,8(sp)
    800009a0:	e052                	sd	s4,0(sp)
    800009a2:	1800                	addi	s0,sp,48
    800009a4:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009a6:	84aa                	mv	s1,a0
    800009a8:	6905                	lui	s2,0x1
    800009aa:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009ac:	4985                	li	s3,1
    800009ae:	a821                	j	800009c6 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009b0:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800009b2:	0532                	slli	a0,a0,0xc
    800009b4:	00000097          	auipc	ra,0x0
    800009b8:	fe0080e7          	jalr	-32(ra) # 80000994 <freewalk>
      pagetable[i] = 0;
    800009bc:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009c0:	04a1                	addi	s1,s1,8
    800009c2:	03248163          	beq	s1,s2,800009e4 <freewalk+0x50>
    pte_t pte = pagetable[i];
    800009c6:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009c8:	00f57793          	andi	a5,a0,15
    800009cc:	ff3782e3          	beq	a5,s3,800009b0 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009d0:	8905                	andi	a0,a0,1
    800009d2:	d57d                	beqz	a0,800009c0 <freewalk+0x2c>
      panic("freewalk: leaf");
    800009d4:	00007517          	auipc	a0,0x7
    800009d8:	76450513          	addi	a0,a0,1892 # 80008138 <etext+0x138>
    800009dc:	00005097          	auipc	ra,0x5
    800009e0:	606080e7          	jalr	1542(ra) # 80005fe2 <panic>
    }
  }
  kfree((void*)pagetable);
    800009e4:	8552                	mv	a0,s4
    800009e6:	fffff097          	auipc	ra,0xfffff
    800009ea:	636080e7          	jalr	1590(ra) # 8000001c <kfree>
}
    800009ee:	70a2                	ld	ra,40(sp)
    800009f0:	7402                	ld	s0,32(sp)
    800009f2:	64e2                	ld	s1,24(sp)
    800009f4:	6942                	ld	s2,16(sp)
    800009f6:	69a2                	ld	s3,8(sp)
    800009f8:	6a02                	ld	s4,0(sp)
    800009fa:	6145                	addi	sp,sp,48
    800009fc:	8082                	ret

00000000800009fe <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009fe:	1101                	addi	sp,sp,-32
    80000a00:	ec06                	sd	ra,24(sp)
    80000a02:	e822                	sd	s0,16(sp)
    80000a04:	e426                	sd	s1,8(sp)
    80000a06:	1000                	addi	s0,sp,32
    80000a08:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a0a:	e999                	bnez	a1,80000a20 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a0c:	8526                	mv	a0,s1
    80000a0e:	00000097          	auipc	ra,0x0
    80000a12:	f86080e7          	jalr	-122(ra) # 80000994 <freewalk>
}
    80000a16:	60e2                	ld	ra,24(sp)
    80000a18:	6442                	ld	s0,16(sp)
    80000a1a:	64a2                	ld	s1,8(sp)
    80000a1c:	6105                	addi	sp,sp,32
    80000a1e:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a20:	6605                	lui	a2,0x1
    80000a22:	167d                	addi	a2,a2,-1
    80000a24:	962e                	add	a2,a2,a1
    80000a26:	4685                	li	a3,1
    80000a28:	8231                	srli	a2,a2,0xc
    80000a2a:	4581                	li	a1,0
    80000a2c:	00000097          	auipc	ra,0x0
    80000a30:	d0a080e7          	jalr	-758(ra) # 80000736 <uvmunmap>
    80000a34:	bfe1                	j	80000a0c <uvmfree+0xe>

0000000080000a36 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a36:	c679                	beqz	a2,80000b04 <uvmcopy+0xce>
{
    80000a38:	715d                	addi	sp,sp,-80
    80000a3a:	e486                	sd	ra,72(sp)
    80000a3c:	e0a2                	sd	s0,64(sp)
    80000a3e:	fc26                	sd	s1,56(sp)
    80000a40:	f84a                	sd	s2,48(sp)
    80000a42:	f44e                	sd	s3,40(sp)
    80000a44:	f052                	sd	s4,32(sp)
    80000a46:	ec56                	sd	s5,24(sp)
    80000a48:	e85a                	sd	s6,16(sp)
    80000a4a:	e45e                	sd	s7,8(sp)
    80000a4c:	0880                	addi	s0,sp,80
    80000a4e:	8b2a                	mv	s6,a0
    80000a50:	8aae                	mv	s5,a1
    80000a52:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a54:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a56:	4601                	li	a2,0
    80000a58:	85ce                	mv	a1,s3
    80000a5a:	855a                	mv	a0,s6
    80000a5c:	00000097          	auipc	ra,0x0
    80000a60:	a08080e7          	jalr	-1528(ra) # 80000464 <walk>
    80000a64:	c531                	beqz	a0,80000ab0 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a66:	6118                	ld	a4,0(a0)
    80000a68:	00177793          	andi	a5,a4,1
    80000a6c:	cbb1                	beqz	a5,80000ac0 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a6e:	00a75593          	srli	a1,a4,0xa
    80000a72:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a76:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a7a:	fffff097          	auipc	ra,0xfffff
    80000a7e:	69e080e7          	jalr	1694(ra) # 80000118 <kalloc>
    80000a82:	892a                	mv	s2,a0
    80000a84:	c939                	beqz	a0,80000ada <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a86:	6605                	lui	a2,0x1
    80000a88:	85de                	mv	a1,s7
    80000a8a:	fffff097          	auipc	ra,0xfffff
    80000a8e:	74e080e7          	jalr	1870(ra) # 800001d8 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a92:	8726                	mv	a4,s1
    80000a94:	86ca                	mv	a3,s2
    80000a96:	6605                	lui	a2,0x1
    80000a98:	85ce                	mv	a1,s3
    80000a9a:	8556                	mv	a0,s5
    80000a9c:	00000097          	auipc	ra,0x0
    80000aa0:	ab0080e7          	jalr	-1360(ra) # 8000054c <mappages>
    80000aa4:	e515                	bnez	a0,80000ad0 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000aa6:	6785                	lui	a5,0x1
    80000aa8:	99be                	add	s3,s3,a5
    80000aaa:	fb49e6e3          	bltu	s3,s4,80000a56 <uvmcopy+0x20>
    80000aae:	a081                	j	80000aee <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000ab0:	00007517          	auipc	a0,0x7
    80000ab4:	69850513          	addi	a0,a0,1688 # 80008148 <etext+0x148>
    80000ab8:	00005097          	auipc	ra,0x5
    80000abc:	52a080e7          	jalr	1322(ra) # 80005fe2 <panic>
      panic("uvmcopy: page not present");
    80000ac0:	00007517          	auipc	a0,0x7
    80000ac4:	6a850513          	addi	a0,a0,1704 # 80008168 <etext+0x168>
    80000ac8:	00005097          	auipc	ra,0x5
    80000acc:	51a080e7          	jalr	1306(ra) # 80005fe2 <panic>
      kfree(mem);
    80000ad0:	854a                	mv	a0,s2
    80000ad2:	fffff097          	auipc	ra,0xfffff
    80000ad6:	54a080e7          	jalr	1354(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000ada:	4685                	li	a3,1
    80000adc:	00c9d613          	srli	a2,s3,0xc
    80000ae0:	4581                	li	a1,0
    80000ae2:	8556                	mv	a0,s5
    80000ae4:	00000097          	auipc	ra,0x0
    80000ae8:	c52080e7          	jalr	-942(ra) # 80000736 <uvmunmap>
  return -1;
    80000aec:	557d                	li	a0,-1
}
    80000aee:	60a6                	ld	ra,72(sp)
    80000af0:	6406                	ld	s0,64(sp)
    80000af2:	74e2                	ld	s1,56(sp)
    80000af4:	7942                	ld	s2,48(sp)
    80000af6:	79a2                	ld	s3,40(sp)
    80000af8:	7a02                	ld	s4,32(sp)
    80000afa:	6ae2                	ld	s5,24(sp)
    80000afc:	6b42                	ld	s6,16(sp)
    80000afe:	6ba2                	ld	s7,8(sp)
    80000b00:	6161                	addi	sp,sp,80
    80000b02:	8082                	ret
  return 0;
    80000b04:	4501                	li	a0,0
}
    80000b06:	8082                	ret

0000000080000b08 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b08:	1141                	addi	sp,sp,-16
    80000b0a:	e406                	sd	ra,8(sp)
    80000b0c:	e022                	sd	s0,0(sp)
    80000b0e:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b10:	4601                	li	a2,0
    80000b12:	00000097          	auipc	ra,0x0
    80000b16:	952080e7          	jalr	-1710(ra) # 80000464 <walk>
  if(pte == 0)
    80000b1a:	c901                	beqz	a0,80000b2a <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b1c:	611c                	ld	a5,0(a0)
    80000b1e:	9bbd                	andi	a5,a5,-17
    80000b20:	e11c                	sd	a5,0(a0)
}
    80000b22:	60a2                	ld	ra,8(sp)
    80000b24:	6402                	ld	s0,0(sp)
    80000b26:	0141                	addi	sp,sp,16
    80000b28:	8082                	ret
    panic("uvmclear");
    80000b2a:	00007517          	auipc	a0,0x7
    80000b2e:	65e50513          	addi	a0,a0,1630 # 80008188 <etext+0x188>
    80000b32:	00005097          	auipc	ra,0x5
    80000b36:	4b0080e7          	jalr	1200(ra) # 80005fe2 <panic>

0000000080000b3a <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80000b3a:	cac9                	beqz	a3,80000bcc <copyout+0x92>
{
    80000b3c:	711d                	addi	sp,sp,-96
    80000b3e:	ec86                	sd	ra,88(sp)
    80000b40:	e8a2                	sd	s0,80(sp)
    80000b42:	e4a6                	sd	s1,72(sp)
    80000b44:	e0ca                	sd	s2,64(sp)
    80000b46:	fc4e                	sd	s3,56(sp)
    80000b48:	f852                	sd	s4,48(sp)
    80000b4a:	f456                	sd	s5,40(sp)
    80000b4c:	f05a                	sd	s6,32(sp)
    80000b4e:	ec5e                	sd	s7,24(sp)
    80000b50:	e862                	sd	s8,16(sp)
    80000b52:	e466                	sd	s9,8(sp)
    80000b54:	e06a                	sd	s10,0(sp)
    80000b56:	1080                	addi	s0,sp,96
    80000b58:	8baa                	mv	s7,a0
    80000b5a:	8aae                	mv	s5,a1
    80000b5c:	8b32                	mv	s6,a2
    80000b5e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b60:	74fd                	lui	s1,0xfffff
    80000b62:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80000b64:	57fd                	li	a5,-1
    80000b66:	83e9                	srli	a5,a5,0x1a
    80000b68:	0697e463          	bltu	a5,s1,80000bd0 <copyout+0x96>
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000b6c:	4cd5                	li	s9,21
    80000b6e:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    80000b70:	8c3e                	mv	s8,a5
    80000b72:	a035                	j	80000b9e <copyout+0x64>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    80000b74:	83a9                	srli	a5,a5,0xa
    80000b76:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b78:	409a8533          	sub	a0,s5,s1
    80000b7c:	0009061b          	sext.w	a2,s2
    80000b80:	85da                	mv	a1,s6
    80000b82:	953e                	add	a0,a0,a5
    80000b84:	fffff097          	auipc	ra,0xfffff
    80000b88:	654080e7          	jalr	1620(ra) # 800001d8 <memmove>

    len -= n;
    80000b8c:	412989b3          	sub	s3,s3,s2
    src += n;
    80000b90:	9b4a                	add	s6,s6,s2
  while(len > 0){
    80000b92:	02098b63          	beqz	s3,80000bc8 <copyout+0x8e>
    if(va0 >= MAXVA)
    80000b96:	034c6f63          	bltu	s8,s4,80000bd4 <copyout+0x9a>
    va0 = PGROUNDDOWN(dstva);
    80000b9a:	84d2                	mv	s1,s4
    dstva = va0 + PGSIZE;
    80000b9c:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    80000b9e:	4601                	li	a2,0
    80000ba0:	85a6                	mv	a1,s1
    80000ba2:	855e                	mv	a0,s7
    80000ba4:	00000097          	auipc	ra,0x0
    80000ba8:	8c0080e7          	jalr	-1856(ra) # 80000464 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000bac:	c515                	beqz	a0,80000bd8 <copyout+0x9e>
    80000bae:	611c                	ld	a5,0(a0)
    80000bb0:	0157f713          	andi	a4,a5,21
    80000bb4:	05971163          	bne	a4,s9,80000bf6 <copyout+0xbc>
    n = PGSIZE - (dstva - va0);
    80000bb8:	01a48a33          	add	s4,s1,s10
    80000bbc:	415a0933          	sub	s2,s4,s5
    if(n > len)
    80000bc0:	fb29fae3          	bgeu	s3,s2,80000b74 <copyout+0x3a>
    80000bc4:	894e                	mv	s2,s3
    80000bc6:	b77d                	j	80000b74 <copyout+0x3a>
  }
  return 0;
    80000bc8:	4501                	li	a0,0
    80000bca:	a801                	j	80000bda <copyout+0xa0>
    80000bcc:	4501                	li	a0,0
}
    80000bce:	8082                	ret
      return -1;
    80000bd0:	557d                	li	a0,-1
    80000bd2:	a021                	j	80000bda <copyout+0xa0>
    80000bd4:	557d                	li	a0,-1
    80000bd6:	a011                	j	80000bda <copyout+0xa0>
      return -1;
    80000bd8:	557d                	li	a0,-1
}
    80000bda:	60e6                	ld	ra,88(sp)
    80000bdc:	6446                	ld	s0,80(sp)
    80000bde:	64a6                	ld	s1,72(sp)
    80000be0:	6906                	ld	s2,64(sp)
    80000be2:	79e2                	ld	s3,56(sp)
    80000be4:	7a42                	ld	s4,48(sp)
    80000be6:	7aa2                	ld	s5,40(sp)
    80000be8:	7b02                	ld	s6,32(sp)
    80000bea:	6be2                	ld	s7,24(sp)
    80000bec:	6c42                	ld	s8,16(sp)
    80000bee:	6ca2                	ld	s9,8(sp)
    80000bf0:	6d02                	ld	s10,0(sp)
    80000bf2:	6125                	addi	sp,sp,96
    80000bf4:	8082                	ret
      return -1;
    80000bf6:	557d                	li	a0,-1
    80000bf8:	b7cd                	j	80000bda <copyout+0xa0>

0000000080000bfa <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000bfa:	c6bd                	beqz	a3,80000c68 <copyin+0x6e>
{
    80000bfc:	715d                	addi	sp,sp,-80
    80000bfe:	e486                	sd	ra,72(sp)
    80000c00:	e0a2                	sd	s0,64(sp)
    80000c02:	fc26                	sd	s1,56(sp)
    80000c04:	f84a                	sd	s2,48(sp)
    80000c06:	f44e                	sd	s3,40(sp)
    80000c08:	f052                	sd	s4,32(sp)
    80000c0a:	ec56                	sd	s5,24(sp)
    80000c0c:	e85a                	sd	s6,16(sp)
    80000c0e:	e45e                	sd	s7,8(sp)
    80000c10:	e062                	sd	s8,0(sp)
    80000c12:	0880                	addi	s0,sp,80
    80000c14:	8b2a                	mv	s6,a0
    80000c16:	8a2e                	mv	s4,a1
    80000c18:	8c32                	mv	s8,a2
    80000c1a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000c1c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c1e:	6a85                	lui	s5,0x1
    80000c20:	a015                	j	80000c44 <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c22:	9562                	add	a0,a0,s8
    80000c24:	0004861b          	sext.w	a2,s1
    80000c28:	412505b3          	sub	a1,a0,s2
    80000c2c:	8552                	mv	a0,s4
    80000c2e:	fffff097          	auipc	ra,0xfffff
    80000c32:	5aa080e7          	jalr	1450(ra) # 800001d8 <memmove>

    len -= n;
    80000c36:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c3a:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c3c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c40:	02098263          	beqz	s3,80000c64 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000c44:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c48:	85ca                	mv	a1,s2
    80000c4a:	855a                	mv	a0,s6
    80000c4c:	00000097          	auipc	ra,0x0
    80000c50:	8be080e7          	jalr	-1858(ra) # 8000050a <walkaddr>
    if(pa0 == 0)
    80000c54:	cd01                	beqz	a0,80000c6c <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000c56:	418904b3          	sub	s1,s2,s8
    80000c5a:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c5c:	fc99f3e3          	bgeu	s3,s1,80000c22 <copyin+0x28>
    80000c60:	84ce                	mv	s1,s3
    80000c62:	b7c1                	j	80000c22 <copyin+0x28>
  }
  return 0;
    80000c64:	4501                	li	a0,0
    80000c66:	a021                	j	80000c6e <copyin+0x74>
    80000c68:	4501                	li	a0,0
}
    80000c6a:	8082                	ret
      return -1;
    80000c6c:	557d                	li	a0,-1
}
    80000c6e:	60a6                	ld	ra,72(sp)
    80000c70:	6406                	ld	s0,64(sp)
    80000c72:	74e2                	ld	s1,56(sp)
    80000c74:	7942                	ld	s2,48(sp)
    80000c76:	79a2                	ld	s3,40(sp)
    80000c78:	7a02                	ld	s4,32(sp)
    80000c7a:	6ae2                	ld	s5,24(sp)
    80000c7c:	6b42                	ld	s6,16(sp)
    80000c7e:	6ba2                	ld	s7,8(sp)
    80000c80:	6c02                	ld	s8,0(sp)
    80000c82:	6161                	addi	sp,sp,80
    80000c84:	8082                	ret

0000000080000c86 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c86:	c6c5                	beqz	a3,80000d2e <copyinstr+0xa8>
{
    80000c88:	715d                	addi	sp,sp,-80
    80000c8a:	e486                	sd	ra,72(sp)
    80000c8c:	e0a2                	sd	s0,64(sp)
    80000c8e:	fc26                	sd	s1,56(sp)
    80000c90:	f84a                	sd	s2,48(sp)
    80000c92:	f44e                	sd	s3,40(sp)
    80000c94:	f052                	sd	s4,32(sp)
    80000c96:	ec56                	sd	s5,24(sp)
    80000c98:	e85a                	sd	s6,16(sp)
    80000c9a:	e45e                	sd	s7,8(sp)
    80000c9c:	0880                	addi	s0,sp,80
    80000c9e:	8a2a                	mv	s4,a0
    80000ca0:	8b2e                	mv	s6,a1
    80000ca2:	8bb2                	mv	s7,a2
    80000ca4:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000ca6:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000ca8:	6985                	lui	s3,0x1
    80000caa:	a035                	j	80000cd6 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000cac:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000cb0:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000cb2:	0017b793          	seqz	a5,a5
    80000cb6:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000cba:	60a6                	ld	ra,72(sp)
    80000cbc:	6406                	ld	s0,64(sp)
    80000cbe:	74e2                	ld	s1,56(sp)
    80000cc0:	7942                	ld	s2,48(sp)
    80000cc2:	79a2                	ld	s3,40(sp)
    80000cc4:	7a02                	ld	s4,32(sp)
    80000cc6:	6ae2                	ld	s5,24(sp)
    80000cc8:	6b42                	ld	s6,16(sp)
    80000cca:	6ba2                	ld	s7,8(sp)
    80000ccc:	6161                	addi	sp,sp,80
    80000cce:	8082                	ret
    srcva = va0 + PGSIZE;
    80000cd0:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000cd4:	c8a9                	beqz	s1,80000d26 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000cd6:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000cda:	85ca                	mv	a1,s2
    80000cdc:	8552                	mv	a0,s4
    80000cde:	00000097          	auipc	ra,0x0
    80000ce2:	82c080e7          	jalr	-2004(ra) # 8000050a <walkaddr>
    if(pa0 == 0)
    80000ce6:	c131                	beqz	a0,80000d2a <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000ce8:	41790833          	sub	a6,s2,s7
    80000cec:	984e                	add	a6,a6,s3
    if(n > max)
    80000cee:	0104f363          	bgeu	s1,a6,80000cf4 <copyinstr+0x6e>
    80000cf2:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000cf4:	955e                	add	a0,a0,s7
    80000cf6:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000cfa:	fc080be3          	beqz	a6,80000cd0 <copyinstr+0x4a>
    80000cfe:	985a                	add	a6,a6,s6
    80000d00:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000d02:	41650633          	sub	a2,a0,s6
    80000d06:	14fd                	addi	s1,s1,-1
    80000d08:	9b26                	add	s6,s6,s1
    80000d0a:	00f60733          	add	a4,a2,a5
    80000d0e:	00074703          	lbu	a4,0(a4)
    80000d12:	df49                	beqz	a4,80000cac <copyinstr+0x26>
        *dst = *p;
    80000d14:	00e78023          	sb	a4,0(a5)
      --max;
    80000d18:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000d1c:	0785                	addi	a5,a5,1
    while(n > 0){
    80000d1e:	ff0796e3          	bne	a5,a6,80000d0a <copyinstr+0x84>
      dst++;
    80000d22:	8b42                	mv	s6,a6
    80000d24:	b775                	j	80000cd0 <copyinstr+0x4a>
    80000d26:	4781                	li	a5,0
    80000d28:	b769                	j	80000cb2 <copyinstr+0x2c>
      return -1;
    80000d2a:	557d                	li	a0,-1
    80000d2c:	b779                	j	80000cba <copyinstr+0x34>
  int got_null = 0;
    80000d2e:	4781                	li	a5,0
  if(got_null){
    80000d30:	0017b793          	seqz	a5,a5
    80000d34:	40f00533          	neg	a0,a5
}
    80000d38:	8082                	ret

0000000080000d3a <dfs>:

void 
dfs(pagetable_t pagetable, int level) {
    80000d3a:	7119                	addi	sp,sp,-128
    80000d3c:	fc86                	sd	ra,120(sp)
    80000d3e:	f8a2                	sd	s0,112(sp)
    80000d40:	f4a6                	sd	s1,104(sp)
    80000d42:	f0ca                	sd	s2,96(sp)
    80000d44:	ecce                	sd	s3,88(sp)
    80000d46:	e8d2                	sd	s4,80(sp)
    80000d48:	e4d6                	sd	s5,72(sp)
    80000d4a:	e0da                	sd	s6,64(sp)
    80000d4c:	fc5e                	sd	s7,56(sp)
    80000d4e:	f862                	sd	s8,48(sp)
    80000d50:	f466                	sd	s9,40(sp)
    80000d52:	f06a                	sd	s10,32(sp)
    80000d54:	ec6e                	sd	s11,24(sp)
    80000d56:	0100                	addi	s0,sp,128
    80000d58:	8aae                	mv	s5,a1
// Recursively find page-table pages.
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000d5a:	89aa                	mv	s3,a0
    80000d5c:	4901                	li	s2,0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){        
    80000d5e:	4c05                	li	s8,1
      printf("%d: pte %p pa %p\n", i, pte, child);      
      dfs((pagetable_t)child, level + 1);
    }   
    else if(pte & PTE_V){
      // is child
      printf("..");
    80000d60:	00007d97          	auipc	s11,0x7
    80000d64:	438d8d93          	addi	s11,s11,1080 # 80008198 <etext+0x198>
      for(int j = 0; j < level; j++) {
        printf(" ..");
      }
      uint64 child = PTE2PA(pte);
      printf("%d: pte %p pa %p\n", i, pte, child);        
    80000d68:	00007d17          	auipc	s10,0x7
    80000d6c:	440d0d13          	addi	s10,s10,1088 # 800081a8 <etext+0x1a8>
        printf(" ..");
    80000d70:	00007b17          	auipc	s6,0x7
    80000d74:	430b0b13          	addi	s6,s6,1072 # 800081a0 <etext+0x1a0>
      dfs((pagetable_t)child, level + 1);
    80000d78:	0015879b          	addiw	a5,a1,1
    80000d7c:	f8f43423          	sd	a5,-120(s0)
  for(int i = 0; i < 512; i++){
    80000d80:	20000b93          	li	s7,512
    80000d84:	a095                	j	80000de8 <dfs+0xae>
      uint64 child = PTE2PA(pte);
    80000d86:	00a4dc93          	srli	s9,s1,0xa
    80000d8a:	0cb2                	slli	s9,s9,0xc
      printf("..");
    80000d8c:	856e                	mv	a0,s11
    80000d8e:	00005097          	auipc	ra,0x5
    80000d92:	29e080e7          	jalr	670(ra) # 8000602c <printf>
      for(int j = 0; j < level; j++) {
    80000d96:	01505b63          	blez	s5,80000dac <dfs+0x72>
    80000d9a:	4a01                	li	s4,0
        printf(" ..");
    80000d9c:	855a                	mv	a0,s6
    80000d9e:	00005097          	auipc	ra,0x5
    80000da2:	28e080e7          	jalr	654(ra) # 8000602c <printf>
      for(int j = 0; j < level; j++) {
    80000da6:	2a05                	addiw	s4,s4,1
    80000da8:	ff4a9ae3          	bne	s5,s4,80000d9c <dfs+0x62>
      printf("%d: pte %p pa %p\n", i, pte, child);      
    80000dac:	86e6                	mv	a3,s9
    80000dae:	8626                	mv	a2,s1
    80000db0:	85ca                	mv	a1,s2
    80000db2:	856a                	mv	a0,s10
    80000db4:	00005097          	auipc	ra,0x5
    80000db8:	278080e7          	jalr	632(ra) # 8000602c <printf>
      dfs((pagetable_t)child, level + 1);
    80000dbc:	f8843583          	ld	a1,-120(s0)
    80000dc0:	8566                	mv	a0,s9
    80000dc2:	00000097          	auipc	ra,0x0
    80000dc6:	f78080e7          	jalr	-136(ra) # 80000d3a <dfs>
    80000dca:	a819                	j	80000de0 <dfs+0xa6>
      uint64 child = PTE2PA(pte);
    80000dcc:	00a4d693          	srli	a3,s1,0xa
      printf("%d: pte %p pa %p\n", i, pte, child);        
    80000dd0:	06b2                	slli	a3,a3,0xc
    80000dd2:	8626                	mv	a2,s1
    80000dd4:	85ca                	mv	a1,s2
    80000dd6:	856a                	mv	a0,s10
    80000dd8:	00005097          	auipc	ra,0x5
    80000ddc:	254080e7          	jalr	596(ra) # 8000602c <printf>
  for(int i = 0; i < 512; i++){
    80000de0:	2905                	addiw	s2,s2,1
    80000de2:	09a1                	addi	s3,s3,8
    80000de4:	03790c63          	beq	s2,s7,80000e1c <dfs+0xe2>
    pte_t pte = pagetable[i];
    80000de8:	0009b483          	ld	s1,0(s3) # 1000 <_entry-0x7ffff000>
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){        
    80000dec:	00f4f793          	andi	a5,s1,15
    80000df0:	f9878be3          	beq	a5,s8,80000d86 <dfs+0x4c>
    else if(pte & PTE_V){
    80000df4:	0014f793          	andi	a5,s1,1
    80000df8:	d7e5                	beqz	a5,80000de0 <dfs+0xa6>
      printf("..");
    80000dfa:	856e                	mv	a0,s11
    80000dfc:	00005097          	auipc	ra,0x5
    80000e00:	230080e7          	jalr	560(ra) # 8000602c <printf>
      for(int j = 0; j < level; j++) {
    80000e04:	fd5054e3          	blez	s5,80000dcc <dfs+0x92>
    80000e08:	4a01                	li	s4,0
        printf(" ..");
    80000e0a:	855a                	mv	a0,s6
    80000e0c:	00005097          	auipc	ra,0x5
    80000e10:	220080e7          	jalr	544(ra) # 8000602c <printf>
      for(int j = 0; j < level; j++) {
    80000e14:	2a05                	addiw	s4,s4,1
    80000e16:	ff4a9ae3          	bne	s5,s4,80000e0a <dfs+0xd0>
    80000e1a:	bf4d                	j	80000dcc <dfs+0x92>
    }     
  }   
}
    80000e1c:	70e6                	ld	ra,120(sp)
    80000e1e:	7446                	ld	s0,112(sp)
    80000e20:	74a6                	ld	s1,104(sp)
    80000e22:	7906                	ld	s2,96(sp)
    80000e24:	69e6                	ld	s3,88(sp)
    80000e26:	6a46                	ld	s4,80(sp)
    80000e28:	6aa6                	ld	s5,72(sp)
    80000e2a:	6b06                	ld	s6,64(sp)
    80000e2c:	7be2                	ld	s7,56(sp)
    80000e2e:	7c42                	ld	s8,48(sp)
    80000e30:	7ca2                	ld	s9,40(sp)
    80000e32:	7d02                	ld	s10,32(sp)
    80000e34:	6de2                	ld	s11,24(sp)
    80000e36:	6109                	addi	sp,sp,128
    80000e38:	8082                	ret

0000000080000e3a <dfs2>:

void 
dfs2(pagetable_t pagetable, int level) {
    80000e3a:	7139                	addi	sp,sp,-64
    80000e3c:	fc06                	sd	ra,56(sp)
    80000e3e:	f822                	sd	s0,48(sp)
    80000e40:	f426                	sd	s1,40(sp)
    80000e42:	f04a                	sd	s2,32(sp)
    80000e44:	ec4e                	sd	s3,24(sp)
    80000e46:	e852                	sd	s4,16(sp)
    80000e48:	e456                	sd	s5,8(sp)
    80000e4a:	0080                	addi	s0,sp,64
// Recursively find page-table pages.
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000e4c:	84aa                	mv	s1,a0
    80000e4e:	6905                	lui	s2,0x1
    80000e50:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){        
    80000e52:	4985                	li	s3,1
      dfs2((pagetable_t)child, level + 1);
    }   
    else if(pte & PTE_A){
      // is child
      uint64 child = PTE2PA(pte);       
      printf("child: %d\n", *((int *) child));
    80000e54:	00007a17          	auipc	s4,0x7
    80000e58:	36ca0a13          	addi	s4,s4,876 # 800081c0 <etext+0x1c0>
      dfs2((pagetable_t)child, level + 1);
    80000e5c:	00158a9b          	addiw	s5,a1,1
    80000e60:	a025                	j	80000e88 <dfs2+0x4e>
      uint64 child = PTE2PA(pte);   
    80000e62:	8129                	srli	a0,a0,0xa
      dfs2((pagetable_t)child, level + 1);
    80000e64:	85d6                	mv	a1,s5
    80000e66:	0532                	slli	a0,a0,0xc
    80000e68:	00000097          	auipc	ra,0x0
    80000e6c:	fd2080e7          	jalr	-46(ra) # 80000e3a <dfs2>
    80000e70:	a809                	j	80000e82 <dfs2+0x48>
      uint64 child = PTE2PA(pte);       
    80000e72:	8129                	srli	a0,a0,0xa
    80000e74:	0532                	slli	a0,a0,0xc
      printf("child: %d\n", *((int *) child));
    80000e76:	410c                	lw	a1,0(a0)
    80000e78:	8552                	mv	a0,s4
    80000e7a:	00005097          	auipc	ra,0x5
    80000e7e:	1b2080e7          	jalr	434(ra) # 8000602c <printf>
  for(int i = 0; i < 512; i++){
    80000e82:	04a1                	addi	s1,s1,8
    80000e84:	01248b63          	beq	s1,s2,80000e9a <dfs2+0x60>
    pte_t pte = pagetable[i];
    80000e88:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){        
    80000e8a:	00f57793          	andi	a5,a0,15
    80000e8e:	fd378ae3          	beq	a5,s3,80000e62 <dfs2+0x28>
    else if(pte & PTE_A){
    80000e92:	04057793          	andi	a5,a0,64
    80000e96:	d7f5                	beqz	a5,80000e82 <dfs2+0x48>
    80000e98:	bfe9                	j	80000e72 <dfs2+0x38>
    }     
  }   
}
    80000e9a:	70e2                	ld	ra,56(sp)
    80000e9c:	7442                	ld	s0,48(sp)
    80000e9e:	74a2                	ld	s1,40(sp)
    80000ea0:	7902                	ld	s2,32(sp)
    80000ea2:	69e2                	ld	s3,24(sp)
    80000ea4:	6a42                	ld	s4,16(sp)
    80000ea6:	6aa2                	ld	s5,8(sp)
    80000ea8:	6121                	addi	sp,sp,64
    80000eaa:	8082                	ret

0000000080000eac <vmprint>:

void
vmprint(pagetable_t pagetable) {
    80000eac:	1101                	addi	sp,sp,-32
    80000eae:	ec06                	sd	ra,24(sp)
    80000eb0:	e822                	sd	s0,16(sp)
    80000eb2:	e426                	sd	s1,8(sp)
    80000eb4:	1000                	addi	s0,sp,32
    80000eb6:	84aa                	mv	s1,a0
  printf("page table %p\n", pagetable);
    80000eb8:	85aa                	mv	a1,a0
    80000eba:	00007517          	auipc	a0,0x7
    80000ebe:	31650513          	addi	a0,a0,790 # 800081d0 <etext+0x1d0>
    80000ec2:	00005097          	auipc	ra,0x5
    80000ec6:	16a080e7          	jalr	362(ra) # 8000602c <printf>
  dfs(pagetable, 0);
    80000eca:	4581                	li	a1,0
    80000ecc:	8526                	mv	a0,s1
    80000ece:	00000097          	auipc	ra,0x0
    80000ed2:	e6c080e7          	jalr	-404(ra) # 80000d3a <dfs>
    80000ed6:	60e2                	ld	ra,24(sp)
    80000ed8:	6442                	ld	s0,16(sp)
    80000eda:	64a2                	ld	s1,8(sp)
    80000edc:	6105                	addi	sp,sp,32
    80000ede:	8082                	ret

0000000080000ee0 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000ee0:	7139                	addi	sp,sp,-64
    80000ee2:	fc06                	sd	ra,56(sp)
    80000ee4:	f822                	sd	s0,48(sp)
    80000ee6:	f426                	sd	s1,40(sp)
    80000ee8:	f04a                	sd	s2,32(sp)
    80000eea:	ec4e                	sd	s3,24(sp)
    80000eec:	e852                	sd	s4,16(sp)
    80000eee:	e456                	sd	s5,8(sp)
    80000ef0:	e05a                	sd	s6,0(sp)
    80000ef2:	0080                	addi	s0,sp,64
    80000ef4:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ef6:	00008497          	auipc	s1,0x8
    80000efa:	f0a48493          	addi	s1,s1,-246 # 80008e00 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000efe:	8b26                	mv	s6,s1
    80000f00:	00007a97          	auipc	s5,0x7
    80000f04:	100a8a93          	addi	s5,s5,256 # 80008000 <etext>
    80000f08:	01000937          	lui	s2,0x1000
    80000f0c:	197d                	addi	s2,s2,-1
    80000f0e:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f10:	0000ea17          	auipc	s4,0xe
    80000f14:	af0a0a13          	addi	s4,s4,-1296 # 8000ea00 <tickslock>
    char *pa = kalloc();
    80000f18:	fffff097          	auipc	ra,0xfffff
    80000f1c:	200080e7          	jalr	512(ra) # 80000118 <kalloc>
    80000f20:	862a                	mv	a2,a0
    if(pa == 0)
    80000f22:	c129                	beqz	a0,80000f64 <proc_mapstacks+0x84>
    uint64 va = KSTACK((int) (p - proc));
    80000f24:	416485b3          	sub	a1,s1,s6
    80000f28:	8591                	srai	a1,a1,0x4
    80000f2a:	000ab783          	ld	a5,0(s5)
    80000f2e:	02f585b3          	mul	a1,a1,a5
    80000f32:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000f36:	4719                	li	a4,6
    80000f38:	6685                	lui	a3,0x1
    80000f3a:	40b905b3          	sub	a1,s2,a1
    80000f3e:	854e                	mv	a0,s3
    80000f40:	fffff097          	auipc	ra,0xfffff
    80000f44:	6d0080e7          	jalr	1744(ra) # 80000610 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f48:	17048493          	addi	s1,s1,368
    80000f4c:	fd4496e3          	bne	s1,s4,80000f18 <proc_mapstacks+0x38>
  }
}
    80000f50:	70e2                	ld	ra,56(sp)
    80000f52:	7442                	ld	s0,48(sp)
    80000f54:	74a2                	ld	s1,40(sp)
    80000f56:	7902                	ld	s2,32(sp)
    80000f58:	69e2                	ld	s3,24(sp)
    80000f5a:	6a42                	ld	s4,16(sp)
    80000f5c:	6aa2                	ld	s5,8(sp)
    80000f5e:	6b02                	ld	s6,0(sp)
    80000f60:	6121                	addi	sp,sp,64
    80000f62:	8082                	ret
      panic("kalloc");
    80000f64:	00007517          	auipc	a0,0x7
    80000f68:	27c50513          	addi	a0,a0,636 # 800081e0 <etext+0x1e0>
    80000f6c:	00005097          	auipc	ra,0x5
    80000f70:	076080e7          	jalr	118(ra) # 80005fe2 <panic>

0000000080000f74 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000f74:	7139                	addi	sp,sp,-64
    80000f76:	fc06                	sd	ra,56(sp)
    80000f78:	f822                	sd	s0,48(sp)
    80000f7a:	f426                	sd	s1,40(sp)
    80000f7c:	f04a                	sd	s2,32(sp)
    80000f7e:	ec4e                	sd	s3,24(sp)
    80000f80:	e852                	sd	s4,16(sp)
    80000f82:	e456                	sd	s5,8(sp)
    80000f84:	e05a                	sd	s6,0(sp)
    80000f86:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000f88:	00007597          	auipc	a1,0x7
    80000f8c:	26058593          	addi	a1,a1,608 # 800081e8 <etext+0x1e8>
    80000f90:	00008517          	auipc	a0,0x8
    80000f94:	a4050513          	addi	a0,a0,-1472 # 800089d0 <pid_lock>
    80000f98:	00005097          	auipc	ra,0x5
    80000f9c:	504080e7          	jalr	1284(ra) # 8000649c <initlock>
  initlock(&wait_lock, "wait_lock");
    80000fa0:	00007597          	auipc	a1,0x7
    80000fa4:	25058593          	addi	a1,a1,592 # 800081f0 <etext+0x1f0>
    80000fa8:	00008517          	auipc	a0,0x8
    80000fac:	a4050513          	addi	a0,a0,-1472 # 800089e8 <wait_lock>
    80000fb0:	00005097          	auipc	ra,0x5
    80000fb4:	4ec080e7          	jalr	1260(ra) # 8000649c <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fb8:	00008497          	auipc	s1,0x8
    80000fbc:	e4848493          	addi	s1,s1,-440 # 80008e00 <proc>
      initlock(&p->lock, "proc");
    80000fc0:	00007b17          	auipc	s6,0x7
    80000fc4:	240b0b13          	addi	s6,s6,576 # 80008200 <etext+0x200>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000fc8:	8aa6                	mv	s5,s1
    80000fca:	00007a17          	auipc	s4,0x7
    80000fce:	036a0a13          	addi	s4,s4,54 # 80008000 <etext>
    80000fd2:	01000937          	lui	s2,0x1000
    80000fd6:	197d                	addi	s2,s2,-1
    80000fd8:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fda:	0000e997          	auipc	s3,0xe
    80000fde:	a2698993          	addi	s3,s3,-1498 # 8000ea00 <tickslock>
      initlock(&p->lock, "proc");
    80000fe2:	85da                	mv	a1,s6
    80000fe4:	8526                	mv	a0,s1
    80000fe6:	00005097          	auipc	ra,0x5
    80000fea:	4b6080e7          	jalr	1206(ra) # 8000649c <initlock>
      p->state = UNUSED;
    80000fee:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000ff2:	415487b3          	sub	a5,s1,s5
    80000ff6:	8791                	srai	a5,a5,0x4
    80000ff8:	000a3703          	ld	a4,0(s4)
    80000ffc:	02e787b3          	mul	a5,a5,a4
    80001000:	00d7979b          	slliw	a5,a5,0xd
    80001004:	40f907b3          	sub	a5,s2,a5
    80001008:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    8000100a:	17048493          	addi	s1,s1,368
    8000100e:	fd349ae3          	bne	s1,s3,80000fe2 <procinit+0x6e>
  }
}
    80001012:	70e2                	ld	ra,56(sp)
    80001014:	7442                	ld	s0,48(sp)
    80001016:	74a2                	ld	s1,40(sp)
    80001018:	7902                	ld	s2,32(sp)
    8000101a:	69e2                	ld	s3,24(sp)
    8000101c:	6a42                	ld	s4,16(sp)
    8000101e:	6aa2                	ld	s5,8(sp)
    80001020:	6b02                	ld	s6,0(sp)
    80001022:	6121                	addi	sp,sp,64
    80001024:	8082                	ret

0000000080001026 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001026:	1141                	addi	sp,sp,-16
    80001028:	e422                	sd	s0,8(sp)
    8000102a:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    8000102c:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    8000102e:	2501                	sext.w	a0,a0
    80001030:	6422                	ld	s0,8(sp)
    80001032:	0141                	addi	sp,sp,16
    80001034:	8082                	ret

0000000080001036 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80001036:	1141                	addi	sp,sp,-16
    80001038:	e422                	sd	s0,8(sp)
    8000103a:	0800                	addi	s0,sp,16
    8000103c:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    8000103e:	2781                	sext.w	a5,a5
    80001040:	079e                	slli	a5,a5,0x7
  return c;
}
    80001042:	00008517          	auipc	a0,0x8
    80001046:	9be50513          	addi	a0,a0,-1602 # 80008a00 <cpus>
    8000104a:	953e                	add	a0,a0,a5
    8000104c:	6422                	ld	s0,8(sp)
    8000104e:	0141                	addi	sp,sp,16
    80001050:	8082                	ret

0000000080001052 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80001052:	1101                	addi	sp,sp,-32
    80001054:	ec06                	sd	ra,24(sp)
    80001056:	e822                	sd	s0,16(sp)
    80001058:	e426                	sd	s1,8(sp)
    8000105a:	1000                	addi	s0,sp,32
  push_off();
    8000105c:	00005097          	auipc	ra,0x5
    80001060:	484080e7          	jalr	1156(ra) # 800064e0 <push_off>
    80001064:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001066:	2781                	sext.w	a5,a5
    80001068:	079e                	slli	a5,a5,0x7
    8000106a:	00008717          	auipc	a4,0x8
    8000106e:	96670713          	addi	a4,a4,-1690 # 800089d0 <pid_lock>
    80001072:	97ba                	add	a5,a5,a4
    80001074:	7b84                	ld	s1,48(a5)
  pop_off();
    80001076:	00005097          	auipc	ra,0x5
    8000107a:	50a080e7          	jalr	1290(ra) # 80006580 <pop_off>
  return p;
}
    8000107e:	8526                	mv	a0,s1
    80001080:	60e2                	ld	ra,24(sp)
    80001082:	6442                	ld	s0,16(sp)
    80001084:	64a2                	ld	s1,8(sp)
    80001086:	6105                	addi	sp,sp,32
    80001088:	8082                	ret

000000008000108a <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    8000108a:	1141                	addi	sp,sp,-16
    8000108c:	e406                	sd	ra,8(sp)
    8000108e:	e022                	sd	s0,0(sp)
    80001090:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001092:	00000097          	auipc	ra,0x0
    80001096:	fc0080e7          	jalr	-64(ra) # 80001052 <myproc>
    8000109a:	00005097          	auipc	ra,0x5
    8000109e:	546080e7          	jalr	1350(ra) # 800065e0 <release>

  if (first) {
    800010a2:	00008797          	auipc	a5,0x8
    800010a6:	86e7a783          	lw	a5,-1938(a5) # 80008910 <first.1692>
    800010aa:	eb89                	bnez	a5,800010bc <forkret+0x32>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    800010ac:	00001097          	auipc	ra,0x1
    800010b0:	e02080e7          	jalr	-510(ra) # 80001eae <usertrapret>
}
    800010b4:	60a2                	ld	ra,8(sp)
    800010b6:	6402                	ld	s0,0(sp)
    800010b8:	0141                	addi	sp,sp,16
    800010ba:	8082                	ret
    fsinit(ROOTDEV);
    800010bc:	4505                	li	a0,1
    800010be:	00002097          	auipc	ra,0x2
    800010c2:	b8e080e7          	jalr	-1138(ra) # 80002c4c <fsinit>
    first = 0;
    800010c6:	00008797          	auipc	a5,0x8
    800010ca:	8407a523          	sw	zero,-1974(a5) # 80008910 <first.1692>
    __sync_synchronize();
    800010ce:	0ff0000f          	fence
    800010d2:	bfe9                	j	800010ac <forkret+0x22>

00000000800010d4 <allocpid>:
{
    800010d4:	1101                	addi	sp,sp,-32
    800010d6:	ec06                	sd	ra,24(sp)
    800010d8:	e822                	sd	s0,16(sp)
    800010da:	e426                	sd	s1,8(sp)
    800010dc:	e04a                	sd	s2,0(sp)
    800010de:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800010e0:	00008917          	auipc	s2,0x8
    800010e4:	8f090913          	addi	s2,s2,-1808 # 800089d0 <pid_lock>
    800010e8:	854a                	mv	a0,s2
    800010ea:	00005097          	auipc	ra,0x5
    800010ee:	442080e7          	jalr	1090(ra) # 8000652c <acquire>
  pid = nextpid;
    800010f2:	00008797          	auipc	a5,0x8
    800010f6:	82278793          	addi	a5,a5,-2014 # 80008914 <nextpid>
    800010fa:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800010fc:	0014871b          	addiw	a4,s1,1
    80001100:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001102:	854a                	mv	a0,s2
    80001104:	00005097          	auipc	ra,0x5
    80001108:	4dc080e7          	jalr	1244(ra) # 800065e0 <release>
}
    8000110c:	8526                	mv	a0,s1
    8000110e:	60e2                	ld	ra,24(sp)
    80001110:	6442                	ld	s0,16(sp)
    80001112:	64a2                	ld	s1,8(sp)
    80001114:	6902                	ld	s2,0(sp)
    80001116:	6105                	addi	sp,sp,32
    80001118:	8082                	ret

000000008000111a <proc_pagetable>:
{
    8000111a:	1101                	addi	sp,sp,-32
    8000111c:	ec06                	sd	ra,24(sp)
    8000111e:	e822                	sd	s0,16(sp)
    80001120:	e426                	sd	s1,8(sp)
    80001122:	e04a                	sd	s2,0(sp)
    80001124:	1000                	addi	s0,sp,32
    80001126:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001128:	fffff097          	auipc	ra,0xfffff
    8000112c:	6d2080e7          	jalr	1746(ra) # 800007fa <uvmcreate>
    80001130:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001132:	cd39                	beqz	a0,80001190 <proc_pagetable+0x76>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001134:	4729                	li	a4,10
    80001136:	00006697          	auipc	a3,0x6
    8000113a:	eca68693          	addi	a3,a3,-310 # 80007000 <_trampoline>
    8000113e:	6605                	lui	a2,0x1
    80001140:	040005b7          	lui	a1,0x4000
    80001144:	15fd                	addi	a1,a1,-1
    80001146:	05b2                	slli	a1,a1,0xc
    80001148:	fffff097          	auipc	ra,0xfffff
    8000114c:	404080e7          	jalr	1028(ra) # 8000054c <mappages>
    80001150:	04054763          	bltz	a0,8000119e <proc_pagetable+0x84>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001154:	4719                	li	a4,6
    80001156:	05893683          	ld	a3,88(s2)
    8000115a:	6605                	lui	a2,0x1
    8000115c:	020005b7          	lui	a1,0x2000
    80001160:	15fd                	addi	a1,a1,-1
    80001162:	05b6                	slli	a1,a1,0xd
    80001164:	8526                	mv	a0,s1
    80001166:	fffff097          	auipc	ra,0xfffff
    8000116a:	3e6080e7          	jalr	998(ra) # 8000054c <mappages>
    8000116e:	04054063          	bltz	a0,800011ae <proc_pagetable+0x94>
  if(mappages(pagetable, USYSCALL, PGSIZE,
    80001172:	4749                	li	a4,18
    80001174:	16893683          	ld	a3,360(s2)
    80001178:	6605                	lui	a2,0x1
    8000117a:	040005b7          	lui	a1,0x4000
    8000117e:	15f5                	addi	a1,a1,-3
    80001180:	05b2                	slli	a1,a1,0xc
    80001182:	8526                	mv	a0,s1
    80001184:	fffff097          	auipc	ra,0xfffff
    80001188:	3c8080e7          	jalr	968(ra) # 8000054c <mappages>
    8000118c:	04054463          	bltz	a0,800011d4 <proc_pagetable+0xba>
}
    80001190:	8526                	mv	a0,s1
    80001192:	60e2                	ld	ra,24(sp)
    80001194:	6442                	ld	s0,16(sp)
    80001196:	64a2                	ld	s1,8(sp)
    80001198:	6902                	ld	s2,0(sp)
    8000119a:	6105                	addi	sp,sp,32
    8000119c:	8082                	ret
    uvmfree(pagetable, 0);
    8000119e:	4581                	li	a1,0
    800011a0:	8526                	mv	a0,s1
    800011a2:	00000097          	auipc	ra,0x0
    800011a6:	85c080e7          	jalr	-1956(ra) # 800009fe <uvmfree>
    return 0;
    800011aa:	4481                	li	s1,0
    800011ac:	b7d5                	j	80001190 <proc_pagetable+0x76>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800011ae:	4681                	li	a3,0
    800011b0:	4605                	li	a2,1
    800011b2:	040005b7          	lui	a1,0x4000
    800011b6:	15fd                	addi	a1,a1,-1
    800011b8:	05b2                	slli	a1,a1,0xc
    800011ba:	8526                	mv	a0,s1
    800011bc:	fffff097          	auipc	ra,0xfffff
    800011c0:	57a080e7          	jalr	1402(ra) # 80000736 <uvmunmap>
    uvmfree(pagetable, 0);
    800011c4:	4581                	li	a1,0
    800011c6:	8526                	mv	a0,s1
    800011c8:	00000097          	auipc	ra,0x0
    800011cc:	836080e7          	jalr	-1994(ra) # 800009fe <uvmfree>
    return 0;
    800011d0:	4481                	li	s1,0
    800011d2:	bf7d                	j	80001190 <proc_pagetable+0x76>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800011d4:	4681                	li	a3,0
    800011d6:	4605                	li	a2,1
    800011d8:	020005b7          	lui	a1,0x2000
    800011dc:	15fd                	addi	a1,a1,-1
    800011de:	05b6                	slli	a1,a1,0xd
    800011e0:	8526                	mv	a0,s1
    800011e2:	fffff097          	auipc	ra,0xfffff
    800011e6:	554080e7          	jalr	1364(ra) # 80000736 <uvmunmap>
    uvmfree(pagetable, 0);
    800011ea:	4581                	li	a1,0
    800011ec:	8526                	mv	a0,s1
    800011ee:	00000097          	auipc	ra,0x0
    800011f2:	810080e7          	jalr	-2032(ra) # 800009fe <uvmfree>
    return 0;
    800011f6:	4481                	li	s1,0
    800011f8:	bf61                	j	80001190 <proc_pagetable+0x76>

00000000800011fa <proc_freepagetable>:
{
    800011fa:	7179                	addi	sp,sp,-48
    800011fc:	f406                	sd	ra,40(sp)
    800011fe:	f022                	sd	s0,32(sp)
    80001200:	ec26                	sd	s1,24(sp)
    80001202:	e84a                	sd	s2,16(sp)
    80001204:	e44e                	sd	s3,8(sp)
    80001206:	1800                	addi	s0,sp,48
    80001208:	84aa                	mv	s1,a0
    8000120a:	89ae                	mv	s3,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000120c:	4681                	li	a3,0
    8000120e:	4605                	li	a2,1
    80001210:	04000937          	lui	s2,0x4000
    80001214:	fff90593          	addi	a1,s2,-1 # 3ffffff <_entry-0x7c000001>
    80001218:	05b2                	slli	a1,a1,0xc
    8000121a:	fffff097          	auipc	ra,0xfffff
    8000121e:	51c080e7          	jalr	1308(ra) # 80000736 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001222:	4681                	li	a3,0
    80001224:	4605                	li	a2,1
    80001226:	020005b7          	lui	a1,0x2000
    8000122a:	15fd                	addi	a1,a1,-1
    8000122c:	05b6                	slli	a1,a1,0xd
    8000122e:	8526                	mv	a0,s1
    80001230:	fffff097          	auipc	ra,0xfffff
    80001234:	506080e7          	jalr	1286(ra) # 80000736 <uvmunmap>
  uvmunmap(pagetable, USYSCALL, 1, 0);
    80001238:	4681                	li	a3,0
    8000123a:	4605                	li	a2,1
    8000123c:	1975                	addi	s2,s2,-3
    8000123e:	00c91593          	slli	a1,s2,0xc
    80001242:	8526                	mv	a0,s1
    80001244:	fffff097          	auipc	ra,0xfffff
    80001248:	4f2080e7          	jalr	1266(ra) # 80000736 <uvmunmap>
  uvmfree(pagetable, sz);
    8000124c:	85ce                	mv	a1,s3
    8000124e:	8526                	mv	a0,s1
    80001250:	fffff097          	auipc	ra,0xfffff
    80001254:	7ae080e7          	jalr	1966(ra) # 800009fe <uvmfree>
}
    80001258:	70a2                	ld	ra,40(sp)
    8000125a:	7402                	ld	s0,32(sp)
    8000125c:	64e2                	ld	s1,24(sp)
    8000125e:	6942                	ld	s2,16(sp)
    80001260:	69a2                	ld	s3,8(sp)
    80001262:	6145                	addi	sp,sp,48
    80001264:	8082                	ret

0000000080001266 <freeproc>:
{
    80001266:	1101                	addi	sp,sp,-32
    80001268:	ec06                	sd	ra,24(sp)
    8000126a:	e822                	sd	s0,16(sp)
    8000126c:	e426                	sd	s1,8(sp)
    8000126e:	1000                	addi	s0,sp,32
    80001270:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001272:	6d28                	ld	a0,88(a0)
    80001274:	c509                	beqz	a0,8000127e <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001276:	fffff097          	auipc	ra,0xfffff
    8000127a:	da6080e7          	jalr	-602(ra) # 8000001c <kfree>
  p->trapframe = 0;
    8000127e:	0404bc23          	sd	zero,88(s1)
  if(p->usysro)
    80001282:	1684b503          	ld	a0,360(s1)
    80001286:	c509                	beqz	a0,80001290 <freeproc+0x2a>
    kfree((void*)p->usysro);  
    80001288:	fffff097          	auipc	ra,0xfffff
    8000128c:	d94080e7          	jalr	-620(ra) # 8000001c <kfree>
  if(p->pagetable)
    80001290:	68a8                	ld	a0,80(s1)
    80001292:	c511                	beqz	a0,8000129e <freeproc+0x38>
    proc_freepagetable(p->pagetable, p->sz);
    80001294:	64ac                	ld	a1,72(s1)
    80001296:	00000097          	auipc	ra,0x0
    8000129a:	f64080e7          	jalr	-156(ra) # 800011fa <proc_freepagetable>
  p->pagetable = 0;
    8000129e:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800012a2:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800012a6:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800012aa:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800012ae:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800012b2:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800012b6:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800012ba:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800012be:	0004ac23          	sw	zero,24(s1)
}
    800012c2:	60e2                	ld	ra,24(sp)
    800012c4:	6442                	ld	s0,16(sp)
    800012c6:	64a2                	ld	s1,8(sp)
    800012c8:	6105                	addi	sp,sp,32
    800012ca:	8082                	ret

00000000800012cc <allocproc>:
{
    800012cc:	1101                	addi	sp,sp,-32
    800012ce:	ec06                	sd	ra,24(sp)
    800012d0:	e822                	sd	s0,16(sp)
    800012d2:	e426                	sd	s1,8(sp)
    800012d4:	e04a                	sd	s2,0(sp)
    800012d6:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800012d8:	00008497          	auipc	s1,0x8
    800012dc:	b2848493          	addi	s1,s1,-1240 # 80008e00 <proc>
    800012e0:	0000d917          	auipc	s2,0xd
    800012e4:	72090913          	addi	s2,s2,1824 # 8000ea00 <tickslock>
    acquire(&p->lock);
    800012e8:	8526                	mv	a0,s1
    800012ea:	00005097          	auipc	ra,0x5
    800012ee:	242080e7          	jalr	578(ra) # 8000652c <acquire>
    if(p->state == UNUSED) {
    800012f2:	4c9c                	lw	a5,24(s1)
    800012f4:	cf81                	beqz	a5,8000130c <allocproc+0x40>
      release(&p->lock);
    800012f6:	8526                	mv	a0,s1
    800012f8:	00005097          	auipc	ra,0x5
    800012fc:	2e8080e7          	jalr	744(ra) # 800065e0 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001300:	17048493          	addi	s1,s1,368
    80001304:	ff2492e3          	bne	s1,s2,800012e8 <allocproc+0x1c>
  return 0;
    80001308:	4481                	li	s1,0
    8000130a:	a09d                	j	80001370 <allocproc+0xa4>
  p->pid = allocpid();
    8000130c:	00000097          	auipc	ra,0x0
    80001310:	dc8080e7          	jalr	-568(ra) # 800010d4 <allocpid>
    80001314:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001316:	4785                	li	a5,1
    80001318:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    8000131a:	fffff097          	auipc	ra,0xfffff
    8000131e:	dfe080e7          	jalr	-514(ra) # 80000118 <kalloc>
    80001322:	892a                	mv	s2,a0
    80001324:	eca8                	sd	a0,88(s1)
    80001326:	cd21                	beqz	a0,8000137e <allocproc+0xb2>
  if((p->usysro = (struct usyscall *)kalloc()) == 0) {
    80001328:	fffff097          	auipc	ra,0xfffff
    8000132c:	df0080e7          	jalr	-528(ra) # 80000118 <kalloc>
    80001330:	892a                	mv	s2,a0
    80001332:	16a4b423          	sd	a0,360(s1)
    80001336:	c125                	beqz	a0,80001396 <allocproc+0xca>
  p->usysro->pid = p->pid;
    80001338:	589c                	lw	a5,48(s1)
    8000133a:	c11c                	sw	a5,0(a0)
  p->pagetable = proc_pagetable(p);
    8000133c:	8526                	mv	a0,s1
    8000133e:	00000097          	auipc	ra,0x0
    80001342:	ddc080e7          	jalr	-548(ra) # 8000111a <proc_pagetable>
    80001346:	892a                	mv	s2,a0
    80001348:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    8000134a:	c135                	beqz	a0,800013ae <allocproc+0xe2>
  memset(&p->context, 0, sizeof(p->context));
    8000134c:	07000613          	li	a2,112
    80001350:	4581                	li	a1,0
    80001352:	06048513          	addi	a0,s1,96
    80001356:	fffff097          	auipc	ra,0xfffff
    8000135a:	e22080e7          	jalr	-478(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    8000135e:	00000797          	auipc	a5,0x0
    80001362:	d2c78793          	addi	a5,a5,-724 # 8000108a <forkret>
    80001366:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001368:	60bc                	ld	a5,64(s1)
    8000136a:	6705                	lui	a4,0x1
    8000136c:	97ba                	add	a5,a5,a4
    8000136e:	f4bc                	sd	a5,104(s1)
}
    80001370:	8526                	mv	a0,s1
    80001372:	60e2                	ld	ra,24(sp)
    80001374:	6442                	ld	s0,16(sp)
    80001376:	64a2                	ld	s1,8(sp)
    80001378:	6902                	ld	s2,0(sp)
    8000137a:	6105                	addi	sp,sp,32
    8000137c:	8082                	ret
    freeproc(p);
    8000137e:	8526                	mv	a0,s1
    80001380:	00000097          	auipc	ra,0x0
    80001384:	ee6080e7          	jalr	-282(ra) # 80001266 <freeproc>
    release(&p->lock);
    80001388:	8526                	mv	a0,s1
    8000138a:	00005097          	auipc	ra,0x5
    8000138e:	256080e7          	jalr	598(ra) # 800065e0 <release>
    return 0;
    80001392:	84ca                	mv	s1,s2
    80001394:	bff1                	j	80001370 <allocproc+0xa4>
    freeproc(p);
    80001396:	8526                	mv	a0,s1
    80001398:	00000097          	auipc	ra,0x0
    8000139c:	ece080e7          	jalr	-306(ra) # 80001266 <freeproc>
    release(&p->lock); 
    800013a0:	8526                	mv	a0,s1
    800013a2:	00005097          	auipc	ra,0x5
    800013a6:	23e080e7          	jalr	574(ra) # 800065e0 <release>
    return 0;
    800013aa:	84ca                	mv	s1,s2
    800013ac:	b7d1                	j	80001370 <allocproc+0xa4>
    freeproc(p);
    800013ae:	8526                	mv	a0,s1
    800013b0:	00000097          	auipc	ra,0x0
    800013b4:	eb6080e7          	jalr	-330(ra) # 80001266 <freeproc>
    release(&p->lock);
    800013b8:	8526                	mv	a0,s1
    800013ba:	00005097          	auipc	ra,0x5
    800013be:	226080e7          	jalr	550(ra) # 800065e0 <release>
    return 0;
    800013c2:	84ca                	mv	s1,s2
    800013c4:	b775                	j	80001370 <allocproc+0xa4>

00000000800013c6 <userinit>:
{
    800013c6:	1101                	addi	sp,sp,-32
    800013c8:	ec06                	sd	ra,24(sp)
    800013ca:	e822                	sd	s0,16(sp)
    800013cc:	e426                	sd	s1,8(sp)
    800013ce:	1000                	addi	s0,sp,32
  p = allocproc();
    800013d0:	00000097          	auipc	ra,0x0
    800013d4:	efc080e7          	jalr	-260(ra) # 800012cc <allocproc>
    800013d8:	84aa                	mv	s1,a0
  initproc = p;
    800013da:	00007797          	auipc	a5,0x7
    800013de:	5aa7bb23          	sd	a0,1462(a5) # 80008990 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    800013e2:	03400613          	li	a2,52
    800013e6:	00007597          	auipc	a1,0x7
    800013ea:	53a58593          	addi	a1,a1,1338 # 80008920 <initcode>
    800013ee:	6928                	ld	a0,80(a0)
    800013f0:	fffff097          	auipc	ra,0xfffff
    800013f4:	438080e7          	jalr	1080(ra) # 80000828 <uvmfirst>
  p->sz = PGSIZE;
    800013f8:	6785                	lui	a5,0x1
    800013fa:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800013fc:	6cb8                	ld	a4,88(s1)
    800013fe:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001402:	6cb8                	ld	a4,88(s1)
    80001404:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001406:	4641                	li	a2,16
    80001408:	00007597          	auipc	a1,0x7
    8000140c:	e0058593          	addi	a1,a1,-512 # 80008208 <etext+0x208>
    80001410:	15848513          	addi	a0,s1,344
    80001414:	fffff097          	auipc	ra,0xfffff
    80001418:	eb6080e7          	jalr	-330(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    8000141c:	00007517          	auipc	a0,0x7
    80001420:	dfc50513          	addi	a0,a0,-516 # 80008218 <etext+0x218>
    80001424:	00002097          	auipc	ra,0x2
    80001428:	24a080e7          	jalr	586(ra) # 8000366e <namei>
    8000142c:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001430:	478d                	li	a5,3
    80001432:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001434:	8526                	mv	a0,s1
    80001436:	00005097          	auipc	ra,0x5
    8000143a:	1aa080e7          	jalr	426(ra) # 800065e0 <release>
}
    8000143e:	60e2                	ld	ra,24(sp)
    80001440:	6442                	ld	s0,16(sp)
    80001442:	64a2                	ld	s1,8(sp)
    80001444:	6105                	addi	sp,sp,32
    80001446:	8082                	ret

0000000080001448 <growproc>:
{
    80001448:	1101                	addi	sp,sp,-32
    8000144a:	ec06                	sd	ra,24(sp)
    8000144c:	e822                	sd	s0,16(sp)
    8000144e:	e426                	sd	s1,8(sp)
    80001450:	e04a                	sd	s2,0(sp)
    80001452:	1000                	addi	s0,sp,32
    80001454:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001456:	00000097          	auipc	ra,0x0
    8000145a:	bfc080e7          	jalr	-1028(ra) # 80001052 <myproc>
    8000145e:	84aa                	mv	s1,a0
  sz = p->sz;
    80001460:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001462:	01204c63          	bgtz	s2,8000147a <growproc+0x32>
  } else if(n < 0){
    80001466:	02094663          	bltz	s2,80001492 <growproc+0x4a>
  p->sz = sz;
    8000146a:	e4ac                	sd	a1,72(s1)
  return 0;
    8000146c:	4501                	li	a0,0
}
    8000146e:	60e2                	ld	ra,24(sp)
    80001470:	6442                	ld	s0,16(sp)
    80001472:	64a2                	ld	s1,8(sp)
    80001474:	6902                	ld	s2,0(sp)
    80001476:	6105                	addi	sp,sp,32
    80001478:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    8000147a:	4691                	li	a3,4
    8000147c:	00b90633          	add	a2,s2,a1
    80001480:	6928                	ld	a0,80(a0)
    80001482:	fffff097          	auipc	ra,0xfffff
    80001486:	460080e7          	jalr	1120(ra) # 800008e2 <uvmalloc>
    8000148a:	85aa                	mv	a1,a0
    8000148c:	fd79                	bnez	a0,8000146a <growproc+0x22>
      return -1;
    8000148e:	557d                	li	a0,-1
    80001490:	bff9                	j	8000146e <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001492:	00b90633          	add	a2,s2,a1
    80001496:	6928                	ld	a0,80(a0)
    80001498:	fffff097          	auipc	ra,0xfffff
    8000149c:	402080e7          	jalr	1026(ra) # 8000089a <uvmdealloc>
    800014a0:	85aa                	mv	a1,a0
    800014a2:	b7e1                	j	8000146a <growproc+0x22>

00000000800014a4 <fork>:
{
    800014a4:	7179                	addi	sp,sp,-48
    800014a6:	f406                	sd	ra,40(sp)
    800014a8:	f022                	sd	s0,32(sp)
    800014aa:	ec26                	sd	s1,24(sp)
    800014ac:	e84a                	sd	s2,16(sp)
    800014ae:	e44e                	sd	s3,8(sp)
    800014b0:	e052                	sd	s4,0(sp)
    800014b2:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800014b4:	00000097          	auipc	ra,0x0
    800014b8:	b9e080e7          	jalr	-1122(ra) # 80001052 <myproc>
    800014bc:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    800014be:	00000097          	auipc	ra,0x0
    800014c2:	e0e080e7          	jalr	-498(ra) # 800012cc <allocproc>
    800014c6:	10050b63          	beqz	a0,800015dc <fork+0x138>
    800014ca:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800014cc:	04893603          	ld	a2,72(s2)
    800014d0:	692c                	ld	a1,80(a0)
    800014d2:	05093503          	ld	a0,80(s2)
    800014d6:	fffff097          	auipc	ra,0xfffff
    800014da:	560080e7          	jalr	1376(ra) # 80000a36 <uvmcopy>
    800014de:	04054663          	bltz	a0,8000152a <fork+0x86>
  np->sz = p->sz;
    800014e2:	04893783          	ld	a5,72(s2)
    800014e6:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800014ea:	05893683          	ld	a3,88(s2)
    800014ee:	87b6                	mv	a5,a3
    800014f0:	0589b703          	ld	a4,88(s3)
    800014f4:	12068693          	addi	a3,a3,288
    800014f8:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800014fc:	6788                	ld	a0,8(a5)
    800014fe:	6b8c                	ld	a1,16(a5)
    80001500:	6f90                	ld	a2,24(a5)
    80001502:	01073023          	sd	a6,0(a4)
    80001506:	e708                	sd	a0,8(a4)
    80001508:	eb0c                	sd	a1,16(a4)
    8000150a:	ef10                	sd	a2,24(a4)
    8000150c:	02078793          	addi	a5,a5,32
    80001510:	02070713          	addi	a4,a4,32
    80001514:	fed792e3          	bne	a5,a3,800014f8 <fork+0x54>
  np->trapframe->a0 = 0;
    80001518:	0589b783          	ld	a5,88(s3)
    8000151c:	0607b823          	sd	zero,112(a5)
    80001520:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    80001524:	15000a13          	li	s4,336
    80001528:	a03d                	j	80001556 <fork+0xb2>
    freeproc(np);
    8000152a:	854e                	mv	a0,s3
    8000152c:	00000097          	auipc	ra,0x0
    80001530:	d3a080e7          	jalr	-710(ra) # 80001266 <freeproc>
    release(&np->lock);
    80001534:	854e                	mv	a0,s3
    80001536:	00005097          	auipc	ra,0x5
    8000153a:	0aa080e7          	jalr	170(ra) # 800065e0 <release>
    return -1;
    8000153e:	5a7d                	li	s4,-1
    80001540:	a069                	j	800015ca <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    80001542:	00002097          	auipc	ra,0x2
    80001546:	7c2080e7          	jalr	1986(ra) # 80003d04 <filedup>
    8000154a:	009987b3          	add	a5,s3,s1
    8000154e:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    80001550:	04a1                	addi	s1,s1,8
    80001552:	01448763          	beq	s1,s4,80001560 <fork+0xbc>
    if(p->ofile[i])
    80001556:	009907b3          	add	a5,s2,s1
    8000155a:	6388                	ld	a0,0(a5)
    8000155c:	f17d                	bnez	a0,80001542 <fork+0x9e>
    8000155e:	bfcd                	j	80001550 <fork+0xac>
  np->cwd = idup(p->cwd);
    80001560:	15093503          	ld	a0,336(s2)
    80001564:	00002097          	auipc	ra,0x2
    80001568:	926080e7          	jalr	-1754(ra) # 80002e8a <idup>
    8000156c:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001570:	4641                	li	a2,16
    80001572:	15890593          	addi	a1,s2,344
    80001576:	15898513          	addi	a0,s3,344
    8000157a:	fffff097          	auipc	ra,0xfffff
    8000157e:	d50080e7          	jalr	-688(ra) # 800002ca <safestrcpy>
  pid = np->pid;
    80001582:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    80001586:	854e                	mv	a0,s3
    80001588:	00005097          	auipc	ra,0x5
    8000158c:	058080e7          	jalr	88(ra) # 800065e0 <release>
  acquire(&wait_lock);
    80001590:	00007497          	auipc	s1,0x7
    80001594:	45848493          	addi	s1,s1,1112 # 800089e8 <wait_lock>
    80001598:	8526                	mv	a0,s1
    8000159a:	00005097          	auipc	ra,0x5
    8000159e:	f92080e7          	jalr	-110(ra) # 8000652c <acquire>
  np->parent = p;
    800015a2:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    800015a6:	8526                	mv	a0,s1
    800015a8:	00005097          	auipc	ra,0x5
    800015ac:	038080e7          	jalr	56(ra) # 800065e0 <release>
  acquire(&np->lock);
    800015b0:	854e                	mv	a0,s3
    800015b2:	00005097          	auipc	ra,0x5
    800015b6:	f7a080e7          	jalr	-134(ra) # 8000652c <acquire>
  np->state = RUNNABLE;
    800015ba:	478d                	li	a5,3
    800015bc:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    800015c0:	854e                	mv	a0,s3
    800015c2:	00005097          	auipc	ra,0x5
    800015c6:	01e080e7          	jalr	30(ra) # 800065e0 <release>
}
    800015ca:	8552                	mv	a0,s4
    800015cc:	70a2                	ld	ra,40(sp)
    800015ce:	7402                	ld	s0,32(sp)
    800015d0:	64e2                	ld	s1,24(sp)
    800015d2:	6942                	ld	s2,16(sp)
    800015d4:	69a2                	ld	s3,8(sp)
    800015d6:	6a02                	ld	s4,0(sp)
    800015d8:	6145                	addi	sp,sp,48
    800015da:	8082                	ret
    return -1;
    800015dc:	5a7d                	li	s4,-1
    800015de:	b7f5                	j	800015ca <fork+0x126>

00000000800015e0 <scheduler>:
{
    800015e0:	7139                	addi	sp,sp,-64
    800015e2:	fc06                	sd	ra,56(sp)
    800015e4:	f822                	sd	s0,48(sp)
    800015e6:	f426                	sd	s1,40(sp)
    800015e8:	f04a                	sd	s2,32(sp)
    800015ea:	ec4e                	sd	s3,24(sp)
    800015ec:	e852                	sd	s4,16(sp)
    800015ee:	e456                	sd	s5,8(sp)
    800015f0:	e05a                	sd	s6,0(sp)
    800015f2:	0080                	addi	s0,sp,64
    800015f4:	8792                	mv	a5,tp
  int id = r_tp();
    800015f6:	2781                	sext.w	a5,a5
  c->proc = 0;
    800015f8:	00779a93          	slli	s5,a5,0x7
    800015fc:	00007717          	auipc	a4,0x7
    80001600:	3d470713          	addi	a4,a4,980 # 800089d0 <pid_lock>
    80001604:	9756                	add	a4,a4,s5
    80001606:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000160a:	00007717          	auipc	a4,0x7
    8000160e:	3fe70713          	addi	a4,a4,1022 # 80008a08 <cpus+0x8>
    80001612:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001614:	498d                	li	s3,3
        p->state = RUNNING;
    80001616:	4b11                	li	s6,4
        c->proc = p;
    80001618:	079e                	slli	a5,a5,0x7
    8000161a:	00007a17          	auipc	s4,0x7
    8000161e:	3b6a0a13          	addi	s4,s4,950 # 800089d0 <pid_lock>
    80001622:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001624:	0000d917          	auipc	s2,0xd
    80001628:	3dc90913          	addi	s2,s2,988 # 8000ea00 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000162c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001630:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001634:	10079073          	csrw	sstatus,a5
    80001638:	00007497          	auipc	s1,0x7
    8000163c:	7c848493          	addi	s1,s1,1992 # 80008e00 <proc>
    80001640:	a03d                	j	8000166e <scheduler+0x8e>
        p->state = RUNNING;
    80001642:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001646:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000164a:	06048593          	addi	a1,s1,96
    8000164e:	8556                	mv	a0,s5
    80001650:	00000097          	auipc	ra,0x0
    80001654:	7b4080e7          	jalr	1972(ra) # 80001e04 <swtch>
        c->proc = 0;
    80001658:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    8000165c:	8526                	mv	a0,s1
    8000165e:	00005097          	auipc	ra,0x5
    80001662:	f82080e7          	jalr	-126(ra) # 800065e0 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001666:	17048493          	addi	s1,s1,368
    8000166a:	fd2481e3          	beq	s1,s2,8000162c <scheduler+0x4c>
      acquire(&p->lock);
    8000166e:	8526                	mv	a0,s1
    80001670:	00005097          	auipc	ra,0x5
    80001674:	ebc080e7          	jalr	-324(ra) # 8000652c <acquire>
      if(p->state == RUNNABLE) {
    80001678:	4c9c                	lw	a5,24(s1)
    8000167a:	ff3791e3          	bne	a5,s3,8000165c <scheduler+0x7c>
    8000167e:	b7d1                	j	80001642 <scheduler+0x62>

0000000080001680 <sched>:
{
    80001680:	7179                	addi	sp,sp,-48
    80001682:	f406                	sd	ra,40(sp)
    80001684:	f022                	sd	s0,32(sp)
    80001686:	ec26                	sd	s1,24(sp)
    80001688:	e84a                	sd	s2,16(sp)
    8000168a:	e44e                	sd	s3,8(sp)
    8000168c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000168e:	00000097          	auipc	ra,0x0
    80001692:	9c4080e7          	jalr	-1596(ra) # 80001052 <myproc>
    80001696:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001698:	00005097          	auipc	ra,0x5
    8000169c:	e1a080e7          	jalr	-486(ra) # 800064b2 <holding>
    800016a0:	c93d                	beqz	a0,80001716 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800016a2:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800016a4:	2781                	sext.w	a5,a5
    800016a6:	079e                	slli	a5,a5,0x7
    800016a8:	00007717          	auipc	a4,0x7
    800016ac:	32870713          	addi	a4,a4,808 # 800089d0 <pid_lock>
    800016b0:	97ba                	add	a5,a5,a4
    800016b2:	0a87a703          	lw	a4,168(a5)
    800016b6:	4785                	li	a5,1
    800016b8:	06f71763          	bne	a4,a5,80001726 <sched+0xa6>
  if(p->state == RUNNING)
    800016bc:	4c98                	lw	a4,24(s1)
    800016be:	4791                	li	a5,4
    800016c0:	06f70b63          	beq	a4,a5,80001736 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800016c4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800016c8:	8b89                	andi	a5,a5,2
  if(intr_get())
    800016ca:	efb5                	bnez	a5,80001746 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800016cc:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800016ce:	00007917          	auipc	s2,0x7
    800016d2:	30290913          	addi	s2,s2,770 # 800089d0 <pid_lock>
    800016d6:	2781                	sext.w	a5,a5
    800016d8:	079e                	slli	a5,a5,0x7
    800016da:	97ca                	add	a5,a5,s2
    800016dc:	0ac7a983          	lw	s3,172(a5)
    800016e0:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800016e2:	2781                	sext.w	a5,a5
    800016e4:	079e                	slli	a5,a5,0x7
    800016e6:	00007597          	auipc	a1,0x7
    800016ea:	32258593          	addi	a1,a1,802 # 80008a08 <cpus+0x8>
    800016ee:	95be                	add	a1,a1,a5
    800016f0:	06048513          	addi	a0,s1,96
    800016f4:	00000097          	auipc	ra,0x0
    800016f8:	710080e7          	jalr	1808(ra) # 80001e04 <swtch>
    800016fc:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800016fe:	2781                	sext.w	a5,a5
    80001700:	079e                	slli	a5,a5,0x7
    80001702:	97ca                	add	a5,a5,s2
    80001704:	0b37a623          	sw	s3,172(a5)
}
    80001708:	70a2                	ld	ra,40(sp)
    8000170a:	7402                	ld	s0,32(sp)
    8000170c:	64e2                	ld	s1,24(sp)
    8000170e:	6942                	ld	s2,16(sp)
    80001710:	69a2                	ld	s3,8(sp)
    80001712:	6145                	addi	sp,sp,48
    80001714:	8082                	ret
    panic("sched p->lock");
    80001716:	00007517          	auipc	a0,0x7
    8000171a:	b0a50513          	addi	a0,a0,-1270 # 80008220 <etext+0x220>
    8000171e:	00005097          	auipc	ra,0x5
    80001722:	8c4080e7          	jalr	-1852(ra) # 80005fe2 <panic>
    panic("sched locks");
    80001726:	00007517          	auipc	a0,0x7
    8000172a:	b0a50513          	addi	a0,a0,-1270 # 80008230 <etext+0x230>
    8000172e:	00005097          	auipc	ra,0x5
    80001732:	8b4080e7          	jalr	-1868(ra) # 80005fe2 <panic>
    panic("sched running");
    80001736:	00007517          	auipc	a0,0x7
    8000173a:	b0a50513          	addi	a0,a0,-1270 # 80008240 <etext+0x240>
    8000173e:	00005097          	auipc	ra,0x5
    80001742:	8a4080e7          	jalr	-1884(ra) # 80005fe2 <panic>
    panic("sched interruptible");
    80001746:	00007517          	auipc	a0,0x7
    8000174a:	b0a50513          	addi	a0,a0,-1270 # 80008250 <etext+0x250>
    8000174e:	00005097          	auipc	ra,0x5
    80001752:	894080e7          	jalr	-1900(ra) # 80005fe2 <panic>

0000000080001756 <yield>:
{
    80001756:	1101                	addi	sp,sp,-32
    80001758:	ec06                	sd	ra,24(sp)
    8000175a:	e822                	sd	s0,16(sp)
    8000175c:	e426                	sd	s1,8(sp)
    8000175e:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001760:	00000097          	auipc	ra,0x0
    80001764:	8f2080e7          	jalr	-1806(ra) # 80001052 <myproc>
    80001768:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000176a:	00005097          	auipc	ra,0x5
    8000176e:	dc2080e7          	jalr	-574(ra) # 8000652c <acquire>
  p->state = RUNNABLE;
    80001772:	478d                	li	a5,3
    80001774:	cc9c                	sw	a5,24(s1)
  sched();
    80001776:	00000097          	auipc	ra,0x0
    8000177a:	f0a080e7          	jalr	-246(ra) # 80001680 <sched>
  release(&p->lock);
    8000177e:	8526                	mv	a0,s1
    80001780:	00005097          	auipc	ra,0x5
    80001784:	e60080e7          	jalr	-416(ra) # 800065e0 <release>
}
    80001788:	60e2                	ld	ra,24(sp)
    8000178a:	6442                	ld	s0,16(sp)
    8000178c:	64a2                	ld	s1,8(sp)
    8000178e:	6105                	addi	sp,sp,32
    80001790:	8082                	ret

0000000080001792 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001792:	7179                	addi	sp,sp,-48
    80001794:	f406                	sd	ra,40(sp)
    80001796:	f022                	sd	s0,32(sp)
    80001798:	ec26                	sd	s1,24(sp)
    8000179a:	e84a                	sd	s2,16(sp)
    8000179c:	e44e                	sd	s3,8(sp)
    8000179e:	1800                	addi	s0,sp,48
    800017a0:	89aa                	mv	s3,a0
    800017a2:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800017a4:	00000097          	auipc	ra,0x0
    800017a8:	8ae080e7          	jalr	-1874(ra) # 80001052 <myproc>
    800017ac:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800017ae:	00005097          	auipc	ra,0x5
    800017b2:	d7e080e7          	jalr	-642(ra) # 8000652c <acquire>
  release(lk);
    800017b6:	854a                	mv	a0,s2
    800017b8:	00005097          	auipc	ra,0x5
    800017bc:	e28080e7          	jalr	-472(ra) # 800065e0 <release>

  // Go to sleep.
  p->chan = chan;
    800017c0:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800017c4:	4789                	li	a5,2
    800017c6:	cc9c                	sw	a5,24(s1)

  sched();
    800017c8:	00000097          	auipc	ra,0x0
    800017cc:	eb8080e7          	jalr	-328(ra) # 80001680 <sched>

  // Tidy up.
  p->chan = 0;
    800017d0:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800017d4:	8526                	mv	a0,s1
    800017d6:	00005097          	auipc	ra,0x5
    800017da:	e0a080e7          	jalr	-502(ra) # 800065e0 <release>
  acquire(lk);
    800017de:	854a                	mv	a0,s2
    800017e0:	00005097          	auipc	ra,0x5
    800017e4:	d4c080e7          	jalr	-692(ra) # 8000652c <acquire>
}
    800017e8:	70a2                	ld	ra,40(sp)
    800017ea:	7402                	ld	s0,32(sp)
    800017ec:	64e2                	ld	s1,24(sp)
    800017ee:	6942                	ld	s2,16(sp)
    800017f0:	69a2                	ld	s3,8(sp)
    800017f2:	6145                	addi	sp,sp,48
    800017f4:	8082                	ret

00000000800017f6 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800017f6:	7139                	addi	sp,sp,-64
    800017f8:	fc06                	sd	ra,56(sp)
    800017fa:	f822                	sd	s0,48(sp)
    800017fc:	f426                	sd	s1,40(sp)
    800017fe:	f04a                	sd	s2,32(sp)
    80001800:	ec4e                	sd	s3,24(sp)
    80001802:	e852                	sd	s4,16(sp)
    80001804:	e456                	sd	s5,8(sp)
    80001806:	0080                	addi	s0,sp,64
    80001808:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000180a:	00007497          	auipc	s1,0x7
    8000180e:	5f648493          	addi	s1,s1,1526 # 80008e00 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001812:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001814:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001816:	0000d917          	auipc	s2,0xd
    8000181a:	1ea90913          	addi	s2,s2,490 # 8000ea00 <tickslock>
    8000181e:	a821                	j	80001836 <wakeup+0x40>
        p->state = RUNNABLE;
    80001820:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    80001824:	8526                	mv	a0,s1
    80001826:	00005097          	auipc	ra,0x5
    8000182a:	dba080e7          	jalr	-582(ra) # 800065e0 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000182e:	17048493          	addi	s1,s1,368
    80001832:	03248463          	beq	s1,s2,8000185a <wakeup+0x64>
    if(p != myproc()){
    80001836:	00000097          	auipc	ra,0x0
    8000183a:	81c080e7          	jalr	-2020(ra) # 80001052 <myproc>
    8000183e:	fea488e3          	beq	s1,a0,8000182e <wakeup+0x38>
      acquire(&p->lock);
    80001842:	8526                	mv	a0,s1
    80001844:	00005097          	auipc	ra,0x5
    80001848:	ce8080e7          	jalr	-792(ra) # 8000652c <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000184c:	4c9c                	lw	a5,24(s1)
    8000184e:	fd379be3          	bne	a5,s3,80001824 <wakeup+0x2e>
    80001852:	709c                	ld	a5,32(s1)
    80001854:	fd4798e3          	bne	a5,s4,80001824 <wakeup+0x2e>
    80001858:	b7e1                	j	80001820 <wakeup+0x2a>
    }
  }
}
    8000185a:	70e2                	ld	ra,56(sp)
    8000185c:	7442                	ld	s0,48(sp)
    8000185e:	74a2                	ld	s1,40(sp)
    80001860:	7902                	ld	s2,32(sp)
    80001862:	69e2                	ld	s3,24(sp)
    80001864:	6a42                	ld	s4,16(sp)
    80001866:	6aa2                	ld	s5,8(sp)
    80001868:	6121                	addi	sp,sp,64
    8000186a:	8082                	ret

000000008000186c <reparent>:
{
    8000186c:	7179                	addi	sp,sp,-48
    8000186e:	f406                	sd	ra,40(sp)
    80001870:	f022                	sd	s0,32(sp)
    80001872:	ec26                	sd	s1,24(sp)
    80001874:	e84a                	sd	s2,16(sp)
    80001876:	e44e                	sd	s3,8(sp)
    80001878:	e052                	sd	s4,0(sp)
    8000187a:	1800                	addi	s0,sp,48
    8000187c:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000187e:	00007497          	auipc	s1,0x7
    80001882:	58248493          	addi	s1,s1,1410 # 80008e00 <proc>
      pp->parent = initproc;
    80001886:	00007a17          	auipc	s4,0x7
    8000188a:	10aa0a13          	addi	s4,s4,266 # 80008990 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000188e:	0000d997          	auipc	s3,0xd
    80001892:	17298993          	addi	s3,s3,370 # 8000ea00 <tickslock>
    80001896:	a029                	j	800018a0 <reparent+0x34>
    80001898:	17048493          	addi	s1,s1,368
    8000189c:	01348d63          	beq	s1,s3,800018b6 <reparent+0x4a>
    if(pp->parent == p){
    800018a0:	7c9c                	ld	a5,56(s1)
    800018a2:	ff279be3          	bne	a5,s2,80001898 <reparent+0x2c>
      pp->parent = initproc;
    800018a6:	000a3503          	ld	a0,0(s4)
    800018aa:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800018ac:	00000097          	auipc	ra,0x0
    800018b0:	f4a080e7          	jalr	-182(ra) # 800017f6 <wakeup>
    800018b4:	b7d5                	j	80001898 <reparent+0x2c>
}
    800018b6:	70a2                	ld	ra,40(sp)
    800018b8:	7402                	ld	s0,32(sp)
    800018ba:	64e2                	ld	s1,24(sp)
    800018bc:	6942                	ld	s2,16(sp)
    800018be:	69a2                	ld	s3,8(sp)
    800018c0:	6a02                	ld	s4,0(sp)
    800018c2:	6145                	addi	sp,sp,48
    800018c4:	8082                	ret

00000000800018c6 <exit>:
{
    800018c6:	7179                	addi	sp,sp,-48
    800018c8:	f406                	sd	ra,40(sp)
    800018ca:	f022                	sd	s0,32(sp)
    800018cc:	ec26                	sd	s1,24(sp)
    800018ce:	e84a                	sd	s2,16(sp)
    800018d0:	e44e                	sd	s3,8(sp)
    800018d2:	e052                	sd	s4,0(sp)
    800018d4:	1800                	addi	s0,sp,48
    800018d6:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800018d8:	fffff097          	auipc	ra,0xfffff
    800018dc:	77a080e7          	jalr	1914(ra) # 80001052 <myproc>
    800018e0:	89aa                	mv	s3,a0
  if(p == initproc)
    800018e2:	00007797          	auipc	a5,0x7
    800018e6:	0ae7b783          	ld	a5,174(a5) # 80008990 <initproc>
    800018ea:	0d050493          	addi	s1,a0,208
    800018ee:	15050913          	addi	s2,a0,336
    800018f2:	02a79363          	bne	a5,a0,80001918 <exit+0x52>
    panic("init exiting");
    800018f6:	00007517          	auipc	a0,0x7
    800018fa:	97250513          	addi	a0,a0,-1678 # 80008268 <etext+0x268>
    800018fe:	00004097          	auipc	ra,0x4
    80001902:	6e4080e7          	jalr	1764(ra) # 80005fe2 <panic>
      fileclose(f);
    80001906:	00002097          	auipc	ra,0x2
    8000190a:	450080e7          	jalr	1104(ra) # 80003d56 <fileclose>
      p->ofile[fd] = 0;
    8000190e:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001912:	04a1                	addi	s1,s1,8
    80001914:	01248563          	beq	s1,s2,8000191e <exit+0x58>
    if(p->ofile[fd]){
    80001918:	6088                	ld	a0,0(s1)
    8000191a:	f575                	bnez	a0,80001906 <exit+0x40>
    8000191c:	bfdd                	j	80001912 <exit+0x4c>
  begin_op();
    8000191e:	00002097          	auipc	ra,0x2
    80001922:	f6c080e7          	jalr	-148(ra) # 8000388a <begin_op>
  iput(p->cwd);
    80001926:	1509b503          	ld	a0,336(s3)
    8000192a:	00001097          	auipc	ra,0x1
    8000192e:	758080e7          	jalr	1880(ra) # 80003082 <iput>
  end_op();
    80001932:	00002097          	auipc	ra,0x2
    80001936:	fd8080e7          	jalr	-40(ra) # 8000390a <end_op>
  p->cwd = 0;
    8000193a:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000193e:	00007497          	auipc	s1,0x7
    80001942:	0aa48493          	addi	s1,s1,170 # 800089e8 <wait_lock>
    80001946:	8526                	mv	a0,s1
    80001948:	00005097          	auipc	ra,0x5
    8000194c:	be4080e7          	jalr	-1052(ra) # 8000652c <acquire>
  reparent(p);
    80001950:	854e                	mv	a0,s3
    80001952:	00000097          	auipc	ra,0x0
    80001956:	f1a080e7          	jalr	-230(ra) # 8000186c <reparent>
  wakeup(p->parent);
    8000195a:	0389b503          	ld	a0,56(s3)
    8000195e:	00000097          	auipc	ra,0x0
    80001962:	e98080e7          	jalr	-360(ra) # 800017f6 <wakeup>
  acquire(&p->lock);
    80001966:	854e                	mv	a0,s3
    80001968:	00005097          	auipc	ra,0x5
    8000196c:	bc4080e7          	jalr	-1084(ra) # 8000652c <acquire>
  p->xstate = status;
    80001970:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001974:	4795                	li	a5,5
    80001976:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000197a:	8526                	mv	a0,s1
    8000197c:	00005097          	auipc	ra,0x5
    80001980:	c64080e7          	jalr	-924(ra) # 800065e0 <release>
  sched();
    80001984:	00000097          	auipc	ra,0x0
    80001988:	cfc080e7          	jalr	-772(ra) # 80001680 <sched>
  panic("zombie exit");
    8000198c:	00007517          	auipc	a0,0x7
    80001990:	8ec50513          	addi	a0,a0,-1812 # 80008278 <etext+0x278>
    80001994:	00004097          	auipc	ra,0x4
    80001998:	64e080e7          	jalr	1614(ra) # 80005fe2 <panic>

000000008000199c <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000199c:	7179                	addi	sp,sp,-48
    8000199e:	f406                	sd	ra,40(sp)
    800019a0:	f022                	sd	s0,32(sp)
    800019a2:	ec26                	sd	s1,24(sp)
    800019a4:	e84a                	sd	s2,16(sp)
    800019a6:	e44e                	sd	s3,8(sp)
    800019a8:	1800                	addi	s0,sp,48
    800019aa:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800019ac:	00007497          	auipc	s1,0x7
    800019b0:	45448493          	addi	s1,s1,1108 # 80008e00 <proc>
    800019b4:	0000d997          	auipc	s3,0xd
    800019b8:	04c98993          	addi	s3,s3,76 # 8000ea00 <tickslock>
    acquire(&p->lock);
    800019bc:	8526                	mv	a0,s1
    800019be:	00005097          	auipc	ra,0x5
    800019c2:	b6e080e7          	jalr	-1170(ra) # 8000652c <acquire>
    if(p->pid == pid){
    800019c6:	589c                	lw	a5,48(s1)
    800019c8:	01278d63          	beq	a5,s2,800019e2 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800019cc:	8526                	mv	a0,s1
    800019ce:	00005097          	auipc	ra,0x5
    800019d2:	c12080e7          	jalr	-1006(ra) # 800065e0 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800019d6:	17048493          	addi	s1,s1,368
    800019da:	ff3491e3          	bne	s1,s3,800019bc <kill+0x20>
  }
  return -1;
    800019de:	557d                	li	a0,-1
    800019e0:	a829                	j	800019fa <kill+0x5e>
      p->killed = 1;
    800019e2:	4785                	li	a5,1
    800019e4:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800019e6:	4c98                	lw	a4,24(s1)
    800019e8:	4789                	li	a5,2
    800019ea:	00f70f63          	beq	a4,a5,80001a08 <kill+0x6c>
      release(&p->lock);
    800019ee:	8526                	mv	a0,s1
    800019f0:	00005097          	auipc	ra,0x5
    800019f4:	bf0080e7          	jalr	-1040(ra) # 800065e0 <release>
      return 0;
    800019f8:	4501                	li	a0,0
}
    800019fa:	70a2                	ld	ra,40(sp)
    800019fc:	7402                	ld	s0,32(sp)
    800019fe:	64e2                	ld	s1,24(sp)
    80001a00:	6942                	ld	s2,16(sp)
    80001a02:	69a2                	ld	s3,8(sp)
    80001a04:	6145                	addi	sp,sp,48
    80001a06:	8082                	ret
        p->state = RUNNABLE;
    80001a08:	478d                	li	a5,3
    80001a0a:	cc9c                	sw	a5,24(s1)
    80001a0c:	b7cd                	j	800019ee <kill+0x52>

0000000080001a0e <setkilled>:

void
setkilled(struct proc *p)
{
    80001a0e:	1101                	addi	sp,sp,-32
    80001a10:	ec06                	sd	ra,24(sp)
    80001a12:	e822                	sd	s0,16(sp)
    80001a14:	e426                	sd	s1,8(sp)
    80001a16:	1000                	addi	s0,sp,32
    80001a18:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001a1a:	00005097          	auipc	ra,0x5
    80001a1e:	b12080e7          	jalr	-1262(ra) # 8000652c <acquire>
  p->killed = 1;
    80001a22:	4785                	li	a5,1
    80001a24:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001a26:	8526                	mv	a0,s1
    80001a28:	00005097          	auipc	ra,0x5
    80001a2c:	bb8080e7          	jalr	-1096(ra) # 800065e0 <release>
}
    80001a30:	60e2                	ld	ra,24(sp)
    80001a32:	6442                	ld	s0,16(sp)
    80001a34:	64a2                	ld	s1,8(sp)
    80001a36:	6105                	addi	sp,sp,32
    80001a38:	8082                	ret

0000000080001a3a <killed>:

int
killed(struct proc *p)
{
    80001a3a:	1101                	addi	sp,sp,-32
    80001a3c:	ec06                	sd	ra,24(sp)
    80001a3e:	e822                	sd	s0,16(sp)
    80001a40:	e426                	sd	s1,8(sp)
    80001a42:	e04a                	sd	s2,0(sp)
    80001a44:	1000                	addi	s0,sp,32
    80001a46:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001a48:	00005097          	auipc	ra,0x5
    80001a4c:	ae4080e7          	jalr	-1308(ra) # 8000652c <acquire>
  k = p->killed;
    80001a50:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001a54:	8526                	mv	a0,s1
    80001a56:	00005097          	auipc	ra,0x5
    80001a5a:	b8a080e7          	jalr	-1142(ra) # 800065e0 <release>
  return k;
}
    80001a5e:	854a                	mv	a0,s2
    80001a60:	60e2                	ld	ra,24(sp)
    80001a62:	6442                	ld	s0,16(sp)
    80001a64:	64a2                	ld	s1,8(sp)
    80001a66:	6902                	ld	s2,0(sp)
    80001a68:	6105                	addi	sp,sp,32
    80001a6a:	8082                	ret

0000000080001a6c <wait>:
{
    80001a6c:	715d                	addi	sp,sp,-80
    80001a6e:	e486                	sd	ra,72(sp)
    80001a70:	e0a2                	sd	s0,64(sp)
    80001a72:	fc26                	sd	s1,56(sp)
    80001a74:	f84a                	sd	s2,48(sp)
    80001a76:	f44e                	sd	s3,40(sp)
    80001a78:	f052                	sd	s4,32(sp)
    80001a7a:	ec56                	sd	s5,24(sp)
    80001a7c:	e85a                	sd	s6,16(sp)
    80001a7e:	e45e                	sd	s7,8(sp)
    80001a80:	e062                	sd	s8,0(sp)
    80001a82:	0880                	addi	s0,sp,80
    80001a84:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001a86:	fffff097          	auipc	ra,0xfffff
    80001a8a:	5cc080e7          	jalr	1484(ra) # 80001052 <myproc>
    80001a8e:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001a90:	00007517          	auipc	a0,0x7
    80001a94:	f5850513          	addi	a0,a0,-168 # 800089e8 <wait_lock>
    80001a98:	00005097          	auipc	ra,0x5
    80001a9c:	a94080e7          	jalr	-1388(ra) # 8000652c <acquire>
    havekids = 0;
    80001aa0:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001aa2:	4a15                	li	s4,5
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001aa4:	0000d997          	auipc	s3,0xd
    80001aa8:	f5c98993          	addi	s3,s3,-164 # 8000ea00 <tickslock>
        havekids = 1;
    80001aac:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001aae:	00007c17          	auipc	s8,0x7
    80001ab2:	f3ac0c13          	addi	s8,s8,-198 # 800089e8 <wait_lock>
    havekids = 0;
    80001ab6:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001ab8:	00007497          	auipc	s1,0x7
    80001abc:	34848493          	addi	s1,s1,840 # 80008e00 <proc>
    80001ac0:	a0bd                	j	80001b2e <wait+0xc2>
          pid = pp->pid;
    80001ac2:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001ac6:	000b0e63          	beqz	s6,80001ae2 <wait+0x76>
    80001aca:	4691                	li	a3,4
    80001acc:	02c48613          	addi	a2,s1,44
    80001ad0:	85da                	mv	a1,s6
    80001ad2:	05093503          	ld	a0,80(s2)
    80001ad6:	fffff097          	auipc	ra,0xfffff
    80001ada:	064080e7          	jalr	100(ra) # 80000b3a <copyout>
    80001ade:	02054563          	bltz	a0,80001b08 <wait+0x9c>
          freeproc(pp);
    80001ae2:	8526                	mv	a0,s1
    80001ae4:	fffff097          	auipc	ra,0xfffff
    80001ae8:	782080e7          	jalr	1922(ra) # 80001266 <freeproc>
          release(&pp->lock);
    80001aec:	8526                	mv	a0,s1
    80001aee:	00005097          	auipc	ra,0x5
    80001af2:	af2080e7          	jalr	-1294(ra) # 800065e0 <release>
          release(&wait_lock);
    80001af6:	00007517          	auipc	a0,0x7
    80001afa:	ef250513          	addi	a0,a0,-270 # 800089e8 <wait_lock>
    80001afe:	00005097          	auipc	ra,0x5
    80001b02:	ae2080e7          	jalr	-1310(ra) # 800065e0 <release>
          return pid;
    80001b06:	a0b5                	j	80001b72 <wait+0x106>
            release(&pp->lock);
    80001b08:	8526                	mv	a0,s1
    80001b0a:	00005097          	auipc	ra,0x5
    80001b0e:	ad6080e7          	jalr	-1322(ra) # 800065e0 <release>
            release(&wait_lock);
    80001b12:	00007517          	auipc	a0,0x7
    80001b16:	ed650513          	addi	a0,a0,-298 # 800089e8 <wait_lock>
    80001b1a:	00005097          	auipc	ra,0x5
    80001b1e:	ac6080e7          	jalr	-1338(ra) # 800065e0 <release>
            return -1;
    80001b22:	59fd                	li	s3,-1
    80001b24:	a0b9                	j	80001b72 <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001b26:	17048493          	addi	s1,s1,368
    80001b2a:	03348463          	beq	s1,s3,80001b52 <wait+0xe6>
      if(pp->parent == p){
    80001b2e:	7c9c                	ld	a5,56(s1)
    80001b30:	ff279be3          	bne	a5,s2,80001b26 <wait+0xba>
        acquire(&pp->lock);
    80001b34:	8526                	mv	a0,s1
    80001b36:	00005097          	auipc	ra,0x5
    80001b3a:	9f6080e7          	jalr	-1546(ra) # 8000652c <acquire>
        if(pp->state == ZOMBIE){
    80001b3e:	4c9c                	lw	a5,24(s1)
    80001b40:	f94781e3          	beq	a5,s4,80001ac2 <wait+0x56>
        release(&pp->lock);
    80001b44:	8526                	mv	a0,s1
    80001b46:	00005097          	auipc	ra,0x5
    80001b4a:	a9a080e7          	jalr	-1382(ra) # 800065e0 <release>
        havekids = 1;
    80001b4e:	8756                	mv	a4,s5
    80001b50:	bfd9                	j	80001b26 <wait+0xba>
    if(!havekids || killed(p)){
    80001b52:	c719                	beqz	a4,80001b60 <wait+0xf4>
    80001b54:	854a                	mv	a0,s2
    80001b56:	00000097          	auipc	ra,0x0
    80001b5a:	ee4080e7          	jalr	-284(ra) # 80001a3a <killed>
    80001b5e:	c51d                	beqz	a0,80001b8c <wait+0x120>
      release(&wait_lock);
    80001b60:	00007517          	auipc	a0,0x7
    80001b64:	e8850513          	addi	a0,a0,-376 # 800089e8 <wait_lock>
    80001b68:	00005097          	auipc	ra,0x5
    80001b6c:	a78080e7          	jalr	-1416(ra) # 800065e0 <release>
      return -1;
    80001b70:	59fd                	li	s3,-1
}
    80001b72:	854e                	mv	a0,s3
    80001b74:	60a6                	ld	ra,72(sp)
    80001b76:	6406                	ld	s0,64(sp)
    80001b78:	74e2                	ld	s1,56(sp)
    80001b7a:	7942                	ld	s2,48(sp)
    80001b7c:	79a2                	ld	s3,40(sp)
    80001b7e:	7a02                	ld	s4,32(sp)
    80001b80:	6ae2                	ld	s5,24(sp)
    80001b82:	6b42                	ld	s6,16(sp)
    80001b84:	6ba2                	ld	s7,8(sp)
    80001b86:	6c02                	ld	s8,0(sp)
    80001b88:	6161                	addi	sp,sp,80
    80001b8a:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001b8c:	85e2                	mv	a1,s8
    80001b8e:	854a                	mv	a0,s2
    80001b90:	00000097          	auipc	ra,0x0
    80001b94:	c02080e7          	jalr	-1022(ra) # 80001792 <sleep>
    havekids = 0;
    80001b98:	bf39                	j	80001ab6 <wait+0x4a>

0000000080001b9a <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001b9a:	7179                	addi	sp,sp,-48
    80001b9c:	f406                	sd	ra,40(sp)
    80001b9e:	f022                	sd	s0,32(sp)
    80001ba0:	ec26                	sd	s1,24(sp)
    80001ba2:	e84a                	sd	s2,16(sp)
    80001ba4:	e44e                	sd	s3,8(sp)
    80001ba6:	e052                	sd	s4,0(sp)
    80001ba8:	1800                	addi	s0,sp,48
    80001baa:	84aa                	mv	s1,a0
    80001bac:	892e                	mv	s2,a1
    80001bae:	89b2                	mv	s3,a2
    80001bb0:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001bb2:	fffff097          	auipc	ra,0xfffff
    80001bb6:	4a0080e7          	jalr	1184(ra) # 80001052 <myproc>
  if(user_dst){
    80001bba:	c08d                	beqz	s1,80001bdc <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001bbc:	86d2                	mv	a3,s4
    80001bbe:	864e                	mv	a2,s3
    80001bc0:	85ca                	mv	a1,s2
    80001bc2:	6928                	ld	a0,80(a0)
    80001bc4:	fffff097          	auipc	ra,0xfffff
    80001bc8:	f76080e7          	jalr	-138(ra) # 80000b3a <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001bcc:	70a2                	ld	ra,40(sp)
    80001bce:	7402                	ld	s0,32(sp)
    80001bd0:	64e2                	ld	s1,24(sp)
    80001bd2:	6942                	ld	s2,16(sp)
    80001bd4:	69a2                	ld	s3,8(sp)
    80001bd6:	6a02                	ld	s4,0(sp)
    80001bd8:	6145                	addi	sp,sp,48
    80001bda:	8082                	ret
    memmove((char *)dst, src, len);
    80001bdc:	000a061b          	sext.w	a2,s4
    80001be0:	85ce                	mv	a1,s3
    80001be2:	854a                	mv	a0,s2
    80001be4:	ffffe097          	auipc	ra,0xffffe
    80001be8:	5f4080e7          	jalr	1524(ra) # 800001d8 <memmove>
    return 0;
    80001bec:	8526                	mv	a0,s1
    80001bee:	bff9                	j	80001bcc <either_copyout+0x32>

0000000080001bf0 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001bf0:	7179                	addi	sp,sp,-48
    80001bf2:	f406                	sd	ra,40(sp)
    80001bf4:	f022                	sd	s0,32(sp)
    80001bf6:	ec26                	sd	s1,24(sp)
    80001bf8:	e84a                	sd	s2,16(sp)
    80001bfa:	e44e                	sd	s3,8(sp)
    80001bfc:	e052                	sd	s4,0(sp)
    80001bfe:	1800                	addi	s0,sp,48
    80001c00:	892a                	mv	s2,a0
    80001c02:	84ae                	mv	s1,a1
    80001c04:	89b2                	mv	s3,a2
    80001c06:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001c08:	fffff097          	auipc	ra,0xfffff
    80001c0c:	44a080e7          	jalr	1098(ra) # 80001052 <myproc>
  if(user_src){
    80001c10:	c08d                	beqz	s1,80001c32 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001c12:	86d2                	mv	a3,s4
    80001c14:	864e                	mv	a2,s3
    80001c16:	85ca                	mv	a1,s2
    80001c18:	6928                	ld	a0,80(a0)
    80001c1a:	fffff097          	auipc	ra,0xfffff
    80001c1e:	fe0080e7          	jalr	-32(ra) # 80000bfa <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001c22:	70a2                	ld	ra,40(sp)
    80001c24:	7402                	ld	s0,32(sp)
    80001c26:	64e2                	ld	s1,24(sp)
    80001c28:	6942                	ld	s2,16(sp)
    80001c2a:	69a2                	ld	s3,8(sp)
    80001c2c:	6a02                	ld	s4,0(sp)
    80001c2e:	6145                	addi	sp,sp,48
    80001c30:	8082                	ret
    memmove(dst, (char*)src, len);
    80001c32:	000a061b          	sext.w	a2,s4
    80001c36:	85ce                	mv	a1,s3
    80001c38:	854a                	mv	a0,s2
    80001c3a:	ffffe097          	auipc	ra,0xffffe
    80001c3e:	59e080e7          	jalr	1438(ra) # 800001d8 <memmove>
    return 0;
    80001c42:	8526                	mv	a0,s1
    80001c44:	bff9                	j	80001c22 <either_copyin+0x32>

0000000080001c46 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001c46:	715d                	addi	sp,sp,-80
    80001c48:	e486                	sd	ra,72(sp)
    80001c4a:	e0a2                	sd	s0,64(sp)
    80001c4c:	fc26                	sd	s1,56(sp)
    80001c4e:	f84a                	sd	s2,48(sp)
    80001c50:	f44e                	sd	s3,40(sp)
    80001c52:	f052                	sd	s4,32(sp)
    80001c54:	ec56                	sd	s5,24(sp)
    80001c56:	e85a                	sd	s6,16(sp)
    80001c58:	e45e                	sd	s7,8(sp)
    80001c5a:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001c5c:	00006517          	auipc	a0,0x6
    80001c60:	3ec50513          	addi	a0,a0,1004 # 80008048 <etext+0x48>
    80001c64:	00004097          	auipc	ra,0x4
    80001c68:	3c8080e7          	jalr	968(ra) # 8000602c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001c6c:	00007497          	auipc	s1,0x7
    80001c70:	2ec48493          	addi	s1,s1,748 # 80008f58 <proc+0x158>
    80001c74:	0000d917          	auipc	s2,0xd
    80001c78:	ee490913          	addi	s2,s2,-284 # 8000eb58 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c7c:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001c7e:	00006997          	auipc	s3,0x6
    80001c82:	60a98993          	addi	s3,s3,1546 # 80008288 <etext+0x288>
    printf("%d %s %s", p->pid, state, p->name);
    80001c86:	00006a97          	auipc	s5,0x6
    80001c8a:	60aa8a93          	addi	s5,s5,1546 # 80008290 <etext+0x290>
    printf("\n");
    80001c8e:	00006a17          	auipc	s4,0x6
    80001c92:	3baa0a13          	addi	s4,s4,954 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c96:	00006b97          	auipc	s7,0x6
    80001c9a:	63ab8b93          	addi	s7,s7,1594 # 800082d0 <states.1736>
    80001c9e:	a00d                	j	80001cc0 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001ca0:	ed86a583          	lw	a1,-296(a3)
    80001ca4:	8556                	mv	a0,s5
    80001ca6:	00004097          	auipc	ra,0x4
    80001caa:	386080e7          	jalr	902(ra) # 8000602c <printf>
    printf("\n");
    80001cae:	8552                	mv	a0,s4
    80001cb0:	00004097          	auipc	ra,0x4
    80001cb4:	37c080e7          	jalr	892(ra) # 8000602c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001cb8:	17048493          	addi	s1,s1,368
    80001cbc:	03248163          	beq	s1,s2,80001cde <procdump+0x98>
    if(p->state == UNUSED)
    80001cc0:	86a6                	mv	a3,s1
    80001cc2:	ec04a783          	lw	a5,-320(s1)
    80001cc6:	dbed                	beqz	a5,80001cb8 <procdump+0x72>
      state = "???";
    80001cc8:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001cca:	fcfb6be3          	bltu	s6,a5,80001ca0 <procdump+0x5a>
    80001cce:	1782                	slli	a5,a5,0x20
    80001cd0:	9381                	srli	a5,a5,0x20
    80001cd2:	078e                	slli	a5,a5,0x3
    80001cd4:	97de                	add	a5,a5,s7
    80001cd6:	6390                	ld	a2,0(a5)
    80001cd8:	f661                	bnez	a2,80001ca0 <procdump+0x5a>
      state = "???";
    80001cda:	864e                	mv	a2,s3
    80001cdc:	b7d1                	j	80001ca0 <procdump+0x5a>
  }
}
    80001cde:	60a6                	ld	ra,72(sp)
    80001ce0:	6406                	ld	s0,64(sp)
    80001ce2:	74e2                	ld	s1,56(sp)
    80001ce4:	7942                	ld	s2,48(sp)
    80001ce6:	79a2                	ld	s3,40(sp)
    80001ce8:	7a02                	ld	s4,32(sp)
    80001cea:	6ae2                	ld	s5,24(sp)
    80001cec:	6b42                	ld	s6,16(sp)
    80001cee:	6ba2                	ld	s7,8(sp)
    80001cf0:	6161                	addi	sp,sp,80
    80001cf2:	8082                	ret

0000000080001cf4 <walk2>:

void
walk2(pagetable_t pagetable, uint64 va) {
  if(va >= MAXVA)
    80001cf4:	57fd                	li	a5,-1
    80001cf6:	83e9                	srli	a5,a5,0x1a
    80001cf8:	02b7ea63          	bltu	a5,a1,80001d2c <walk2+0x38>
    panic("walk");

  for(int level = 2; level > 0; level--) {
    pte_t *pte = &pagetable[PX(level, va)];
    80001cfc:	01e5d793          	srli	a5,a1,0x1e
    80001d00:	078e                	slli	a5,a5,0x3
    80001d02:	97aa                	add	a5,a5,a0
    if(*pte & PTE_A) {
    80001d04:	6398                	ld	a4,0(a5)
    80001d06:	04077693          	andi	a3,a4,64
    80001d0a:	c681                	beqz	a3,80001d12 <walk2+0x1e>
      *pte = *pte & ~PTE_A;
    80001d0c:	fbf77713          	andi	a4,a4,-65
    80001d10:	e398                	sd	a4,0(a5)
    pte_t *pte = &pagetable[PX(level, va)];
    80001d12:	81d5                	srli	a1,a1,0x15
    80001d14:	1ff5f593          	andi	a1,a1,511
    80001d18:	058e                	slli	a1,a1,0x3
    80001d1a:	95aa                	add	a1,a1,a0
    if(*pte & PTE_A) {
    80001d1c:	619c                	ld	a5,0(a1)
    80001d1e:	0407f713          	andi	a4,a5,64
    80001d22:	c701                	beqz	a4,80001d2a <walk2+0x36>
      *pte = *pte & ~PTE_A;
    80001d24:	fbf7f793          	andi	a5,a5,-65
    80001d28:	e19c                	sd	a5,0(a1)
  for(int level = 2; level > 0; level--) {
    80001d2a:	8082                	ret
walk2(pagetable_t pagetable, uint64 va) {
    80001d2c:	1141                	addi	sp,sp,-16
    80001d2e:	e406                	sd	ra,8(sp)
    80001d30:	e022                	sd	s0,0(sp)
    80001d32:	0800                	addi	s0,sp,16
    panic("walk");
    80001d34:	00006517          	auipc	a0,0x6
    80001d38:	31c50513          	addi	a0,a0,796 # 80008050 <etext+0x50>
    80001d3c:	00004097          	auipc	ra,0x4
    80001d40:	2a6080e7          	jalr	678(ra) # 80005fe2 <panic>

0000000080001d44 <pgaccss>:
    }
  }
}

int pgaccss(uint64 buf, int npgs, uint64 btmsk) {
    80001d44:	711d                	addi	sp,sp,-96
    80001d46:	ec86                	sd	ra,88(sp)
    80001d48:	e8a2                	sd	s0,80(sp)
    80001d4a:	e4a6                	sd	s1,72(sp)
    80001d4c:	e0ca                	sd	s2,64(sp)
    80001d4e:	fc4e                	sd	s3,56(sp)
    80001d50:	f852                	sd	s4,48(sp)
    80001d52:	f456                	sd	s5,40(sp)
    80001d54:	f05a                	sd	s6,32(sp)
    80001d56:	ec5e                	sd	s7,24(sp)
    80001d58:	e862                	sd	s8,16(sp)
    80001d5a:	1080                	addi	s0,sp,96
    80001d5c:	8baa                	mv	s7,a0
    80001d5e:	8c32                	mv	s8,a2

  struct proc * p = myproc();
    80001d60:	fffff097          	auipc	ra,0xfffff
    80001d64:	2f2080e7          	jalr	754(ra) # 80001052 <myproc>
    80001d68:	89aa                	mv	s3,a0

  uint64 bitmask = 0;
    80001d6a:	fa043423          	sd	zero,-88(s0)
  uint64 track = buf;
    80001d6e:	895e                	mv	s2,s7

  for(int i = 0; i < 32; i++) {
    80001d70:	4481                	li	s1,0
    pte_t * pte = walk(p->pagetable, track, 0);
    track = track + PGSIZE;
    80001d72:	6a85                	lui	s5,0x1
    if((PTE_A & *pte)) {
      bitmask = bitmask | (1 << i);
    80001d74:	4b05                	li	s6,1
  for(int i = 0; i < 32; i++) {
    80001d76:	02000a13          	li	s4,32
    80001d7a:	a021                	j	80001d82 <pgaccss+0x3e>
    80001d7c:	2485                	addiw	s1,s1,1
    80001d7e:	03448b63          	beq	s1,s4,80001db4 <pgaccss+0x70>
    pte_t * pte = walk(p->pagetable, track, 0);
    80001d82:	4601                	li	a2,0
    80001d84:	85ca                	mv	a1,s2
    80001d86:	0509b503          	ld	a0,80(s3)
    80001d8a:	ffffe097          	auipc	ra,0xffffe
    80001d8e:	6da080e7          	jalr	1754(ra) # 80000464 <walk>
    track = track + PGSIZE;
    80001d92:	9956                	add	s2,s2,s5
    if((PTE_A & *pte)) {
    80001d94:	611c                	ld	a5,0(a0)
    80001d96:	0407f793          	andi	a5,a5,64
    80001d9a:	d3ed                	beqz	a5,80001d7c <pgaccss+0x38>
      bitmask = bitmask | (1 << i);
    80001d9c:	009b17bb          	sllw	a5,s6,s1
    80001da0:	fa843703          	ld	a4,-88(s0)
    80001da4:	8fd9                	or	a5,a5,a4
    80001da6:	faf43423          	sd	a5,-88(s0)
      *pte = *pte & ~ PTE_A;
    80001daa:	611c                	ld	a5,0(a0)
    80001dac:	fbf7f793          	andi	a5,a5,-65
    80001db0:	e11c                	sd	a5,0(a0)
    80001db2:	b7e9                	j	80001d7c <pgaccss+0x38>
    }
  }

  if(copyout(p->pagetable, btmsk, (char *) &bitmask, sizeof(uint64)) < 0) {
    80001db4:	46a1                	li	a3,8
    80001db6:	fa840613          	addi	a2,s0,-88
    80001dba:	85e2                	mv	a1,s8
    80001dbc:	0509b503          	ld	a0,80(s3)
    80001dc0:	fffff097          	auipc	ra,0xfffff
    80001dc4:	d7a080e7          	jalr	-646(ra) # 80000b3a <copyout>
    proc_freepagetable(p->pagetable, sizeof(pagetable_t));
    kfree((void *)buf);
    return -1;
  }  

  return 0;
    80001dc8:	4781                	li	a5,0
  if(copyout(p->pagetable, btmsk, (char *) &bitmask, sizeof(uint64)) < 0) {
    80001dca:	00054f63          	bltz	a0,80001de8 <pgaccss+0xa4>
}
    80001dce:	853e                	mv	a0,a5
    80001dd0:	60e6                	ld	ra,88(sp)
    80001dd2:	6446                	ld	s0,80(sp)
    80001dd4:	64a6                	ld	s1,72(sp)
    80001dd6:	6906                	ld	s2,64(sp)
    80001dd8:	79e2                	ld	s3,56(sp)
    80001dda:	7a42                	ld	s4,48(sp)
    80001ddc:	7aa2                	ld	s5,40(sp)
    80001dde:	7b02                	ld	s6,32(sp)
    80001de0:	6be2                	ld	s7,24(sp)
    80001de2:	6c42                	ld	s8,16(sp)
    80001de4:	6125                	addi	sp,sp,96
    80001de6:	8082                	ret
    proc_freepagetable(p->pagetable, sizeof(pagetable_t));
    80001de8:	45a1                	li	a1,8
    80001dea:	0509b503          	ld	a0,80(s3)
    80001dee:	fffff097          	auipc	ra,0xfffff
    80001df2:	40c080e7          	jalr	1036(ra) # 800011fa <proc_freepagetable>
    kfree((void *)buf);
    80001df6:	855e                	mv	a0,s7
    80001df8:	ffffe097          	auipc	ra,0xffffe
    80001dfc:	224080e7          	jalr	548(ra) # 8000001c <kfree>
    return -1;
    80001e00:	57fd                	li	a5,-1
    80001e02:	b7f1                	j	80001dce <pgaccss+0x8a>

0000000080001e04 <swtch>:
    80001e04:	00153023          	sd	ra,0(a0)
    80001e08:	00253423          	sd	sp,8(a0)
    80001e0c:	e900                	sd	s0,16(a0)
    80001e0e:	ed04                	sd	s1,24(a0)
    80001e10:	03253023          	sd	s2,32(a0)
    80001e14:	03353423          	sd	s3,40(a0)
    80001e18:	03453823          	sd	s4,48(a0)
    80001e1c:	03553c23          	sd	s5,56(a0)
    80001e20:	05653023          	sd	s6,64(a0)
    80001e24:	05753423          	sd	s7,72(a0)
    80001e28:	05853823          	sd	s8,80(a0)
    80001e2c:	05953c23          	sd	s9,88(a0)
    80001e30:	07a53023          	sd	s10,96(a0)
    80001e34:	07b53423          	sd	s11,104(a0)
    80001e38:	0005b083          	ld	ra,0(a1)
    80001e3c:	0085b103          	ld	sp,8(a1)
    80001e40:	6980                	ld	s0,16(a1)
    80001e42:	6d84                	ld	s1,24(a1)
    80001e44:	0205b903          	ld	s2,32(a1)
    80001e48:	0285b983          	ld	s3,40(a1)
    80001e4c:	0305ba03          	ld	s4,48(a1)
    80001e50:	0385ba83          	ld	s5,56(a1)
    80001e54:	0405bb03          	ld	s6,64(a1)
    80001e58:	0485bb83          	ld	s7,72(a1)
    80001e5c:	0505bc03          	ld	s8,80(a1)
    80001e60:	0585bc83          	ld	s9,88(a1)
    80001e64:	0605bd03          	ld	s10,96(a1)
    80001e68:	0685bd83          	ld	s11,104(a1)
    80001e6c:	8082                	ret

0000000080001e6e <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001e6e:	1141                	addi	sp,sp,-16
    80001e70:	e406                	sd	ra,8(sp)
    80001e72:	e022                	sd	s0,0(sp)
    80001e74:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001e76:	00006597          	auipc	a1,0x6
    80001e7a:	48a58593          	addi	a1,a1,1162 # 80008300 <states.1736+0x30>
    80001e7e:	0000d517          	auipc	a0,0xd
    80001e82:	b8250513          	addi	a0,a0,-1150 # 8000ea00 <tickslock>
    80001e86:	00004097          	auipc	ra,0x4
    80001e8a:	616080e7          	jalr	1558(ra) # 8000649c <initlock>
}
    80001e8e:	60a2                	ld	ra,8(sp)
    80001e90:	6402                	ld	s0,0(sp)
    80001e92:	0141                	addi	sp,sp,16
    80001e94:	8082                	ret

0000000080001e96 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001e96:	1141                	addi	sp,sp,-16
    80001e98:	e422                	sd	s0,8(sp)
    80001e9a:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001e9c:	00003797          	auipc	a5,0x3
    80001ea0:	51478793          	addi	a5,a5,1300 # 800053b0 <kernelvec>
    80001ea4:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001ea8:	6422                	ld	s0,8(sp)
    80001eaa:	0141                	addi	sp,sp,16
    80001eac:	8082                	ret

0000000080001eae <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001eae:	1141                	addi	sp,sp,-16
    80001eb0:	e406                	sd	ra,8(sp)
    80001eb2:	e022                	sd	s0,0(sp)
    80001eb4:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001eb6:	fffff097          	auipc	ra,0xfffff
    80001eba:	19c080e7          	jalr	412(ra) # 80001052 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ebe:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001ec2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ec4:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001ec8:	00005617          	auipc	a2,0x5
    80001ecc:	13860613          	addi	a2,a2,312 # 80007000 <_trampoline>
    80001ed0:	00005697          	auipc	a3,0x5
    80001ed4:	13068693          	addi	a3,a3,304 # 80007000 <_trampoline>
    80001ed8:	8e91                	sub	a3,a3,a2
    80001eda:	040007b7          	lui	a5,0x4000
    80001ede:	17fd                	addi	a5,a5,-1
    80001ee0:	07b2                	slli	a5,a5,0xc
    80001ee2:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ee4:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001ee8:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001eea:	180026f3          	csrr	a3,satp
    80001eee:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001ef0:	6d38                	ld	a4,88(a0)
    80001ef2:	6134                	ld	a3,64(a0)
    80001ef4:	6585                	lui	a1,0x1
    80001ef6:	96ae                	add	a3,a3,a1
    80001ef8:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001efa:	6d38                	ld	a4,88(a0)
    80001efc:	00000697          	auipc	a3,0x0
    80001f00:	13068693          	addi	a3,a3,304 # 8000202c <usertrap>
    80001f04:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001f06:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001f08:	8692                	mv	a3,tp
    80001f0a:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f0c:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001f10:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001f14:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f18:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001f1c:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001f1e:	6f18                	ld	a4,24(a4)
    80001f20:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001f24:	6928                	ld	a0,80(a0)
    80001f26:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001f28:	00005717          	auipc	a4,0x5
    80001f2c:	17470713          	addi	a4,a4,372 # 8000709c <userret>
    80001f30:	8f11                	sub	a4,a4,a2
    80001f32:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001f34:	577d                	li	a4,-1
    80001f36:	177e                	slli	a4,a4,0x3f
    80001f38:	8d59                	or	a0,a0,a4
    80001f3a:	9782                	jalr	a5
}
    80001f3c:	60a2                	ld	ra,8(sp)
    80001f3e:	6402                	ld	s0,0(sp)
    80001f40:	0141                	addi	sp,sp,16
    80001f42:	8082                	ret

0000000080001f44 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001f44:	1101                	addi	sp,sp,-32
    80001f46:	ec06                	sd	ra,24(sp)
    80001f48:	e822                	sd	s0,16(sp)
    80001f4a:	e426                	sd	s1,8(sp)
    80001f4c:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001f4e:	0000d497          	auipc	s1,0xd
    80001f52:	ab248493          	addi	s1,s1,-1358 # 8000ea00 <tickslock>
    80001f56:	8526                	mv	a0,s1
    80001f58:	00004097          	auipc	ra,0x4
    80001f5c:	5d4080e7          	jalr	1492(ra) # 8000652c <acquire>
  ticks++;
    80001f60:	00007517          	auipc	a0,0x7
    80001f64:	a3850513          	addi	a0,a0,-1480 # 80008998 <ticks>
    80001f68:	411c                	lw	a5,0(a0)
    80001f6a:	2785                	addiw	a5,a5,1
    80001f6c:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001f6e:	00000097          	auipc	ra,0x0
    80001f72:	888080e7          	jalr	-1912(ra) # 800017f6 <wakeup>
  release(&tickslock);
    80001f76:	8526                	mv	a0,s1
    80001f78:	00004097          	auipc	ra,0x4
    80001f7c:	668080e7          	jalr	1640(ra) # 800065e0 <release>
}
    80001f80:	60e2                	ld	ra,24(sp)
    80001f82:	6442                	ld	s0,16(sp)
    80001f84:	64a2                	ld	s1,8(sp)
    80001f86:	6105                	addi	sp,sp,32
    80001f88:	8082                	ret

0000000080001f8a <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001f8a:	1101                	addi	sp,sp,-32
    80001f8c:	ec06                	sd	ra,24(sp)
    80001f8e:	e822                	sd	s0,16(sp)
    80001f90:	e426                	sd	s1,8(sp)
    80001f92:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f94:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001f98:	00074d63          	bltz	a4,80001fb2 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001f9c:	57fd                	li	a5,-1
    80001f9e:	17fe                	slli	a5,a5,0x3f
    80001fa0:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001fa2:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001fa4:	06f70363          	beq	a4,a5,8000200a <devintr+0x80>
  }
}
    80001fa8:	60e2                	ld	ra,24(sp)
    80001faa:	6442                	ld	s0,16(sp)
    80001fac:	64a2                	ld	s1,8(sp)
    80001fae:	6105                	addi	sp,sp,32
    80001fb0:	8082                	ret
     (scause & 0xff) == 9){
    80001fb2:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001fb6:	46a5                	li	a3,9
    80001fb8:	fed792e3          	bne	a5,a3,80001f9c <devintr+0x12>
    int irq = plic_claim();
    80001fbc:	00003097          	auipc	ra,0x3
    80001fc0:	4fc080e7          	jalr	1276(ra) # 800054b8 <plic_claim>
    80001fc4:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001fc6:	47a9                	li	a5,10
    80001fc8:	02f50763          	beq	a0,a5,80001ff6 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001fcc:	4785                	li	a5,1
    80001fce:	02f50963          	beq	a0,a5,80002000 <devintr+0x76>
    return 1;
    80001fd2:	4505                	li	a0,1
    } else if(irq){
    80001fd4:	d8f1                	beqz	s1,80001fa8 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001fd6:	85a6                	mv	a1,s1
    80001fd8:	00006517          	auipc	a0,0x6
    80001fdc:	33050513          	addi	a0,a0,816 # 80008308 <states.1736+0x38>
    80001fe0:	00004097          	auipc	ra,0x4
    80001fe4:	04c080e7          	jalr	76(ra) # 8000602c <printf>
      plic_complete(irq);
    80001fe8:	8526                	mv	a0,s1
    80001fea:	00003097          	auipc	ra,0x3
    80001fee:	4f2080e7          	jalr	1266(ra) # 800054dc <plic_complete>
    return 1;
    80001ff2:	4505                	li	a0,1
    80001ff4:	bf55                	j	80001fa8 <devintr+0x1e>
      uartintr();
    80001ff6:	00004097          	auipc	ra,0x4
    80001ffa:	456080e7          	jalr	1110(ra) # 8000644c <uartintr>
    80001ffe:	b7ed                	j	80001fe8 <devintr+0x5e>
      virtio_disk_intr();
    80002000:	00004097          	auipc	ra,0x4
    80002004:	a06080e7          	jalr	-1530(ra) # 80005a06 <virtio_disk_intr>
    80002008:	b7c5                	j	80001fe8 <devintr+0x5e>
    if(cpuid() == 0){
    8000200a:	fffff097          	auipc	ra,0xfffff
    8000200e:	01c080e7          	jalr	28(ra) # 80001026 <cpuid>
    80002012:	c901                	beqz	a0,80002022 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002014:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002018:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    8000201a:	14479073          	csrw	sip,a5
    return 2;
    8000201e:	4509                	li	a0,2
    80002020:	b761                	j	80001fa8 <devintr+0x1e>
      clockintr();
    80002022:	00000097          	auipc	ra,0x0
    80002026:	f22080e7          	jalr	-222(ra) # 80001f44 <clockintr>
    8000202a:	b7ed                	j	80002014 <devintr+0x8a>

000000008000202c <usertrap>:
{
    8000202c:	1101                	addi	sp,sp,-32
    8000202e:	ec06                	sd	ra,24(sp)
    80002030:	e822                	sd	s0,16(sp)
    80002032:	e426                	sd	s1,8(sp)
    80002034:	e04a                	sd	s2,0(sp)
    80002036:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002038:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    8000203c:	1007f793          	andi	a5,a5,256
    80002040:	e3b1                	bnez	a5,80002084 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002042:	00003797          	auipc	a5,0x3
    80002046:	36e78793          	addi	a5,a5,878 # 800053b0 <kernelvec>
    8000204a:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    8000204e:	fffff097          	auipc	ra,0xfffff
    80002052:	004080e7          	jalr	4(ra) # 80001052 <myproc>
    80002056:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002058:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000205a:	14102773          	csrr	a4,sepc
    8000205e:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002060:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002064:	47a1                	li	a5,8
    80002066:	02f70763          	beq	a4,a5,80002094 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    8000206a:	00000097          	auipc	ra,0x0
    8000206e:	f20080e7          	jalr	-224(ra) # 80001f8a <devintr>
    80002072:	892a                	mv	s2,a0
    80002074:	c151                	beqz	a0,800020f8 <usertrap+0xcc>
  if(killed(p))
    80002076:	8526                	mv	a0,s1
    80002078:	00000097          	auipc	ra,0x0
    8000207c:	9c2080e7          	jalr	-1598(ra) # 80001a3a <killed>
    80002080:	c929                	beqz	a0,800020d2 <usertrap+0xa6>
    80002082:	a099                	j	800020c8 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80002084:	00006517          	auipc	a0,0x6
    80002088:	2a450513          	addi	a0,a0,676 # 80008328 <states.1736+0x58>
    8000208c:	00004097          	auipc	ra,0x4
    80002090:	f56080e7          	jalr	-170(ra) # 80005fe2 <panic>
    if(killed(p))
    80002094:	00000097          	auipc	ra,0x0
    80002098:	9a6080e7          	jalr	-1626(ra) # 80001a3a <killed>
    8000209c:	e921                	bnez	a0,800020ec <usertrap+0xc0>
    p->trapframe->epc += 4;
    8000209e:	6cb8                	ld	a4,88(s1)
    800020a0:	6f1c                	ld	a5,24(a4)
    800020a2:	0791                	addi	a5,a5,4
    800020a4:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800020a6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800020aa:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800020ae:	10079073          	csrw	sstatus,a5
    syscall();
    800020b2:	00000097          	auipc	ra,0x0
    800020b6:	2d4080e7          	jalr	724(ra) # 80002386 <syscall>
  if(killed(p))
    800020ba:	8526                	mv	a0,s1
    800020bc:	00000097          	auipc	ra,0x0
    800020c0:	97e080e7          	jalr	-1666(ra) # 80001a3a <killed>
    800020c4:	c911                	beqz	a0,800020d8 <usertrap+0xac>
    800020c6:	4901                	li	s2,0
    exit(-1);
    800020c8:	557d                	li	a0,-1
    800020ca:	fffff097          	auipc	ra,0xfffff
    800020ce:	7fc080e7          	jalr	2044(ra) # 800018c6 <exit>
  if(which_dev == 2)
    800020d2:	4789                	li	a5,2
    800020d4:	04f90f63          	beq	s2,a5,80002132 <usertrap+0x106>
  usertrapret();
    800020d8:	00000097          	auipc	ra,0x0
    800020dc:	dd6080e7          	jalr	-554(ra) # 80001eae <usertrapret>
}
    800020e0:	60e2                	ld	ra,24(sp)
    800020e2:	6442                	ld	s0,16(sp)
    800020e4:	64a2                	ld	s1,8(sp)
    800020e6:	6902                	ld	s2,0(sp)
    800020e8:	6105                	addi	sp,sp,32
    800020ea:	8082                	ret
      exit(-1);
    800020ec:	557d                	li	a0,-1
    800020ee:	fffff097          	auipc	ra,0xfffff
    800020f2:	7d8080e7          	jalr	2008(ra) # 800018c6 <exit>
    800020f6:	b765                	j	8000209e <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    800020f8:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    800020fc:	5890                	lw	a2,48(s1)
    800020fe:	00006517          	auipc	a0,0x6
    80002102:	24a50513          	addi	a0,a0,586 # 80008348 <states.1736+0x78>
    80002106:	00004097          	auipc	ra,0x4
    8000210a:	f26080e7          	jalr	-218(ra) # 8000602c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000210e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002112:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002116:	00006517          	auipc	a0,0x6
    8000211a:	26250513          	addi	a0,a0,610 # 80008378 <states.1736+0xa8>
    8000211e:	00004097          	auipc	ra,0x4
    80002122:	f0e080e7          	jalr	-242(ra) # 8000602c <printf>
    setkilled(p);
    80002126:	8526                	mv	a0,s1
    80002128:	00000097          	auipc	ra,0x0
    8000212c:	8e6080e7          	jalr	-1818(ra) # 80001a0e <setkilled>
    80002130:	b769                	j	800020ba <usertrap+0x8e>
    yield();
    80002132:	fffff097          	auipc	ra,0xfffff
    80002136:	624080e7          	jalr	1572(ra) # 80001756 <yield>
    8000213a:	bf79                	j	800020d8 <usertrap+0xac>

000000008000213c <kerneltrap>:
{
    8000213c:	7179                	addi	sp,sp,-48
    8000213e:	f406                	sd	ra,40(sp)
    80002140:	f022                	sd	s0,32(sp)
    80002142:	ec26                	sd	s1,24(sp)
    80002144:	e84a                	sd	s2,16(sp)
    80002146:	e44e                	sd	s3,8(sp)
    80002148:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000214a:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000214e:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002152:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002156:	1004f793          	andi	a5,s1,256
    8000215a:	cb85                	beqz	a5,8000218a <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000215c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002160:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002162:	ef85                	bnez	a5,8000219a <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002164:	00000097          	auipc	ra,0x0
    80002168:	e26080e7          	jalr	-474(ra) # 80001f8a <devintr>
    8000216c:	cd1d                	beqz	a0,800021aa <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    8000216e:	4789                	li	a5,2
    80002170:	06f50a63          	beq	a0,a5,800021e4 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002174:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002178:	10049073          	csrw	sstatus,s1
}
    8000217c:	70a2                	ld	ra,40(sp)
    8000217e:	7402                	ld	s0,32(sp)
    80002180:	64e2                	ld	s1,24(sp)
    80002182:	6942                	ld	s2,16(sp)
    80002184:	69a2                	ld	s3,8(sp)
    80002186:	6145                	addi	sp,sp,48
    80002188:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    8000218a:	00006517          	auipc	a0,0x6
    8000218e:	20e50513          	addi	a0,a0,526 # 80008398 <states.1736+0xc8>
    80002192:	00004097          	auipc	ra,0x4
    80002196:	e50080e7          	jalr	-432(ra) # 80005fe2 <panic>
    panic("kerneltrap: interrupts enabled");
    8000219a:	00006517          	auipc	a0,0x6
    8000219e:	22650513          	addi	a0,a0,550 # 800083c0 <states.1736+0xf0>
    800021a2:	00004097          	auipc	ra,0x4
    800021a6:	e40080e7          	jalr	-448(ra) # 80005fe2 <panic>
    printf("scause %p\n", scause);
    800021aa:	85ce                	mv	a1,s3
    800021ac:	00006517          	auipc	a0,0x6
    800021b0:	23450513          	addi	a0,a0,564 # 800083e0 <states.1736+0x110>
    800021b4:	00004097          	auipc	ra,0x4
    800021b8:	e78080e7          	jalr	-392(ra) # 8000602c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800021bc:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800021c0:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    800021c4:	00006517          	auipc	a0,0x6
    800021c8:	22c50513          	addi	a0,a0,556 # 800083f0 <states.1736+0x120>
    800021cc:	00004097          	auipc	ra,0x4
    800021d0:	e60080e7          	jalr	-416(ra) # 8000602c <printf>
    panic("kerneltrap");
    800021d4:	00006517          	auipc	a0,0x6
    800021d8:	23450513          	addi	a0,a0,564 # 80008408 <states.1736+0x138>
    800021dc:	00004097          	auipc	ra,0x4
    800021e0:	e06080e7          	jalr	-506(ra) # 80005fe2 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800021e4:	fffff097          	auipc	ra,0xfffff
    800021e8:	e6e080e7          	jalr	-402(ra) # 80001052 <myproc>
    800021ec:	d541                	beqz	a0,80002174 <kerneltrap+0x38>
    800021ee:	fffff097          	auipc	ra,0xfffff
    800021f2:	e64080e7          	jalr	-412(ra) # 80001052 <myproc>
    800021f6:	4d18                	lw	a4,24(a0)
    800021f8:	4791                	li	a5,4
    800021fa:	f6f71de3          	bne	a4,a5,80002174 <kerneltrap+0x38>
    yield();
    800021fe:	fffff097          	auipc	ra,0xfffff
    80002202:	558080e7          	jalr	1368(ra) # 80001756 <yield>
    80002206:	b7bd                	j	80002174 <kerneltrap+0x38>

0000000080002208 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002208:	1101                	addi	sp,sp,-32
    8000220a:	ec06                	sd	ra,24(sp)
    8000220c:	e822                	sd	s0,16(sp)
    8000220e:	e426                	sd	s1,8(sp)
    80002210:	1000                	addi	s0,sp,32
    80002212:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002214:	fffff097          	auipc	ra,0xfffff
    80002218:	e3e080e7          	jalr	-450(ra) # 80001052 <myproc>
  switch (n) {
    8000221c:	4795                	li	a5,5
    8000221e:	0497e163          	bltu	a5,s1,80002260 <argraw+0x58>
    80002222:	048a                	slli	s1,s1,0x2
    80002224:	00006717          	auipc	a4,0x6
    80002228:	21c70713          	addi	a4,a4,540 # 80008440 <states.1736+0x170>
    8000222c:	94ba                	add	s1,s1,a4
    8000222e:	409c                	lw	a5,0(s1)
    80002230:	97ba                	add	a5,a5,a4
    80002232:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002234:	6d3c                	ld	a5,88(a0)
    80002236:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002238:	60e2                	ld	ra,24(sp)
    8000223a:	6442                	ld	s0,16(sp)
    8000223c:	64a2                	ld	s1,8(sp)
    8000223e:	6105                	addi	sp,sp,32
    80002240:	8082                	ret
    return p->trapframe->a1;
    80002242:	6d3c                	ld	a5,88(a0)
    80002244:	7fa8                	ld	a0,120(a5)
    80002246:	bfcd                	j	80002238 <argraw+0x30>
    return p->trapframe->a2;
    80002248:	6d3c                	ld	a5,88(a0)
    8000224a:	63c8                	ld	a0,128(a5)
    8000224c:	b7f5                	j	80002238 <argraw+0x30>
    return p->trapframe->a3;
    8000224e:	6d3c                	ld	a5,88(a0)
    80002250:	67c8                	ld	a0,136(a5)
    80002252:	b7dd                	j	80002238 <argraw+0x30>
    return p->trapframe->a4;
    80002254:	6d3c                	ld	a5,88(a0)
    80002256:	6bc8                	ld	a0,144(a5)
    80002258:	b7c5                	j	80002238 <argraw+0x30>
    return p->trapframe->a5;
    8000225a:	6d3c                	ld	a5,88(a0)
    8000225c:	6fc8                	ld	a0,152(a5)
    8000225e:	bfe9                	j	80002238 <argraw+0x30>
  panic("argraw");
    80002260:	00006517          	auipc	a0,0x6
    80002264:	1b850513          	addi	a0,a0,440 # 80008418 <states.1736+0x148>
    80002268:	00004097          	auipc	ra,0x4
    8000226c:	d7a080e7          	jalr	-646(ra) # 80005fe2 <panic>

0000000080002270 <fetchaddr>:
{
    80002270:	1101                	addi	sp,sp,-32
    80002272:	ec06                	sd	ra,24(sp)
    80002274:	e822                	sd	s0,16(sp)
    80002276:	e426                	sd	s1,8(sp)
    80002278:	e04a                	sd	s2,0(sp)
    8000227a:	1000                	addi	s0,sp,32
    8000227c:	84aa                	mv	s1,a0
    8000227e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002280:	fffff097          	auipc	ra,0xfffff
    80002284:	dd2080e7          	jalr	-558(ra) # 80001052 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002288:	653c                	ld	a5,72(a0)
    8000228a:	02f4f863          	bgeu	s1,a5,800022ba <fetchaddr+0x4a>
    8000228e:	00848713          	addi	a4,s1,8
    80002292:	02e7e663          	bltu	a5,a4,800022be <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002296:	46a1                	li	a3,8
    80002298:	8626                	mv	a2,s1
    8000229a:	85ca                	mv	a1,s2
    8000229c:	6928                	ld	a0,80(a0)
    8000229e:	fffff097          	auipc	ra,0xfffff
    800022a2:	95c080e7          	jalr	-1700(ra) # 80000bfa <copyin>
    800022a6:	00a03533          	snez	a0,a0
    800022aa:	40a00533          	neg	a0,a0
}
    800022ae:	60e2                	ld	ra,24(sp)
    800022b0:	6442                	ld	s0,16(sp)
    800022b2:	64a2                	ld	s1,8(sp)
    800022b4:	6902                	ld	s2,0(sp)
    800022b6:	6105                	addi	sp,sp,32
    800022b8:	8082                	ret
    return -1;
    800022ba:	557d                	li	a0,-1
    800022bc:	bfcd                	j	800022ae <fetchaddr+0x3e>
    800022be:	557d                	li	a0,-1
    800022c0:	b7fd                	j	800022ae <fetchaddr+0x3e>

00000000800022c2 <fetchstr>:
{
    800022c2:	7179                	addi	sp,sp,-48
    800022c4:	f406                	sd	ra,40(sp)
    800022c6:	f022                	sd	s0,32(sp)
    800022c8:	ec26                	sd	s1,24(sp)
    800022ca:	e84a                	sd	s2,16(sp)
    800022cc:	e44e                	sd	s3,8(sp)
    800022ce:	1800                	addi	s0,sp,48
    800022d0:	892a                	mv	s2,a0
    800022d2:	84ae                	mv	s1,a1
    800022d4:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800022d6:	fffff097          	auipc	ra,0xfffff
    800022da:	d7c080e7          	jalr	-644(ra) # 80001052 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    800022de:	86ce                	mv	a3,s3
    800022e0:	864a                	mv	a2,s2
    800022e2:	85a6                	mv	a1,s1
    800022e4:	6928                	ld	a0,80(a0)
    800022e6:	fffff097          	auipc	ra,0xfffff
    800022ea:	9a0080e7          	jalr	-1632(ra) # 80000c86 <copyinstr>
    800022ee:	00054e63          	bltz	a0,8000230a <fetchstr+0x48>
  return strlen(buf);
    800022f2:	8526                	mv	a0,s1
    800022f4:	ffffe097          	auipc	ra,0xffffe
    800022f8:	008080e7          	jalr	8(ra) # 800002fc <strlen>
}
    800022fc:	70a2                	ld	ra,40(sp)
    800022fe:	7402                	ld	s0,32(sp)
    80002300:	64e2                	ld	s1,24(sp)
    80002302:	6942                	ld	s2,16(sp)
    80002304:	69a2                	ld	s3,8(sp)
    80002306:	6145                	addi	sp,sp,48
    80002308:	8082                	ret
    return -1;
    8000230a:	557d                	li	a0,-1
    8000230c:	bfc5                	j	800022fc <fetchstr+0x3a>

000000008000230e <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    8000230e:	1101                	addi	sp,sp,-32
    80002310:	ec06                	sd	ra,24(sp)
    80002312:	e822                	sd	s0,16(sp)
    80002314:	e426                	sd	s1,8(sp)
    80002316:	1000                	addi	s0,sp,32
    80002318:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000231a:	00000097          	auipc	ra,0x0
    8000231e:	eee080e7          	jalr	-274(ra) # 80002208 <argraw>
    80002322:	c088                	sw	a0,0(s1)
}
    80002324:	60e2                	ld	ra,24(sp)
    80002326:	6442                	ld	s0,16(sp)
    80002328:	64a2                	ld	s1,8(sp)
    8000232a:	6105                	addi	sp,sp,32
    8000232c:	8082                	ret

000000008000232e <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    8000232e:	1101                	addi	sp,sp,-32
    80002330:	ec06                	sd	ra,24(sp)
    80002332:	e822                	sd	s0,16(sp)
    80002334:	e426                	sd	s1,8(sp)
    80002336:	1000                	addi	s0,sp,32
    80002338:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000233a:	00000097          	auipc	ra,0x0
    8000233e:	ece080e7          	jalr	-306(ra) # 80002208 <argraw>
    80002342:	e088                	sd	a0,0(s1)
}
    80002344:	60e2                	ld	ra,24(sp)
    80002346:	6442                	ld	s0,16(sp)
    80002348:	64a2                	ld	s1,8(sp)
    8000234a:	6105                	addi	sp,sp,32
    8000234c:	8082                	ret

000000008000234e <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000234e:	7179                	addi	sp,sp,-48
    80002350:	f406                	sd	ra,40(sp)
    80002352:	f022                	sd	s0,32(sp)
    80002354:	ec26                	sd	s1,24(sp)
    80002356:	e84a                	sd	s2,16(sp)
    80002358:	1800                	addi	s0,sp,48
    8000235a:	84ae                	mv	s1,a1
    8000235c:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    8000235e:	fd840593          	addi	a1,s0,-40
    80002362:	00000097          	auipc	ra,0x0
    80002366:	fcc080e7          	jalr	-52(ra) # 8000232e <argaddr>
  return fetchstr(addr, buf, max);
    8000236a:	864a                	mv	a2,s2
    8000236c:	85a6                	mv	a1,s1
    8000236e:	fd843503          	ld	a0,-40(s0)
    80002372:	00000097          	auipc	ra,0x0
    80002376:	f50080e7          	jalr	-176(ra) # 800022c2 <fetchstr>
}
    8000237a:	70a2                	ld	ra,40(sp)
    8000237c:	7402                	ld	s0,32(sp)
    8000237e:	64e2                	ld	s1,24(sp)
    80002380:	6942                	ld	s2,16(sp)
    80002382:	6145                	addi	sp,sp,48
    80002384:	8082                	ret

0000000080002386 <syscall>:



void
syscall(void)
{
    80002386:	1101                	addi	sp,sp,-32
    80002388:	ec06                	sd	ra,24(sp)
    8000238a:	e822                	sd	s0,16(sp)
    8000238c:	e426                	sd	s1,8(sp)
    8000238e:	e04a                	sd	s2,0(sp)
    80002390:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002392:	fffff097          	auipc	ra,0xfffff
    80002396:	cc0080e7          	jalr	-832(ra) # 80001052 <myproc>
    8000239a:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000239c:	05853903          	ld	s2,88(a0)
    800023a0:	0a893783          	ld	a5,168(s2)
    800023a4:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    800023a8:	37fd                	addiw	a5,a5,-1
    800023aa:	4775                	li	a4,29
    800023ac:	00f76f63          	bltu	a4,a5,800023ca <syscall+0x44>
    800023b0:	00369713          	slli	a4,a3,0x3
    800023b4:	00006797          	auipc	a5,0x6
    800023b8:	0a478793          	addi	a5,a5,164 # 80008458 <syscalls>
    800023bc:	97ba                	add	a5,a5,a4
    800023be:	639c                	ld	a5,0(a5)
    800023c0:	c789                	beqz	a5,800023ca <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800023c2:	9782                	jalr	a5
    800023c4:	06a93823          	sd	a0,112(s2)
    800023c8:	a839                	j	800023e6 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800023ca:	15848613          	addi	a2,s1,344
    800023ce:	588c                	lw	a1,48(s1)
    800023d0:	00006517          	auipc	a0,0x6
    800023d4:	05050513          	addi	a0,a0,80 # 80008420 <states.1736+0x150>
    800023d8:	00004097          	auipc	ra,0x4
    800023dc:	c54080e7          	jalr	-940(ra) # 8000602c <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800023e0:	6cbc                	ld	a5,88(s1)
    800023e2:	577d                	li	a4,-1
    800023e4:	fbb8                	sd	a4,112(a5)
  }
}
    800023e6:	60e2                	ld	ra,24(sp)
    800023e8:	6442                	ld	s0,16(sp)
    800023ea:	64a2                	ld	s1,8(sp)
    800023ec:	6902                	ld	s2,0(sp)
    800023ee:	6105                	addi	sp,sp,32
    800023f0:	8082                	ret

00000000800023f2 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800023f2:	1101                	addi	sp,sp,-32
    800023f4:	ec06                	sd	ra,24(sp)
    800023f6:	e822                	sd	s0,16(sp)
    800023f8:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800023fa:	fec40593          	addi	a1,s0,-20
    800023fe:	4501                	li	a0,0
    80002400:	00000097          	auipc	ra,0x0
    80002404:	f0e080e7          	jalr	-242(ra) # 8000230e <argint>
  exit(n);
    80002408:	fec42503          	lw	a0,-20(s0)
    8000240c:	fffff097          	auipc	ra,0xfffff
    80002410:	4ba080e7          	jalr	1210(ra) # 800018c6 <exit>
  return 0;  // not reached
}
    80002414:	4501                	li	a0,0
    80002416:	60e2                	ld	ra,24(sp)
    80002418:	6442                	ld	s0,16(sp)
    8000241a:	6105                	addi	sp,sp,32
    8000241c:	8082                	ret

000000008000241e <sys_getpid>:

uint64
sys_getpid(void)
{
    8000241e:	1141                	addi	sp,sp,-16
    80002420:	e406                	sd	ra,8(sp)
    80002422:	e022                	sd	s0,0(sp)
    80002424:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002426:	fffff097          	auipc	ra,0xfffff
    8000242a:	c2c080e7          	jalr	-980(ra) # 80001052 <myproc>
}
    8000242e:	5908                	lw	a0,48(a0)
    80002430:	60a2                	ld	ra,8(sp)
    80002432:	6402                	ld	s0,0(sp)
    80002434:	0141                	addi	sp,sp,16
    80002436:	8082                	ret

0000000080002438 <sys_fork>:

uint64
sys_fork(void)
{
    80002438:	1141                	addi	sp,sp,-16
    8000243a:	e406                	sd	ra,8(sp)
    8000243c:	e022                	sd	s0,0(sp)
    8000243e:	0800                	addi	s0,sp,16
  return fork();
    80002440:	fffff097          	auipc	ra,0xfffff
    80002444:	064080e7          	jalr	100(ra) # 800014a4 <fork>
}
    80002448:	60a2                	ld	ra,8(sp)
    8000244a:	6402                	ld	s0,0(sp)
    8000244c:	0141                	addi	sp,sp,16
    8000244e:	8082                	ret

0000000080002450 <sys_wait>:

uint64
sys_wait(void)
{
    80002450:	1101                	addi	sp,sp,-32
    80002452:	ec06                	sd	ra,24(sp)
    80002454:	e822                	sd	s0,16(sp)
    80002456:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002458:	fe840593          	addi	a1,s0,-24
    8000245c:	4501                	li	a0,0
    8000245e:	00000097          	auipc	ra,0x0
    80002462:	ed0080e7          	jalr	-304(ra) # 8000232e <argaddr>
  return wait(p);
    80002466:	fe843503          	ld	a0,-24(s0)
    8000246a:	fffff097          	auipc	ra,0xfffff
    8000246e:	602080e7          	jalr	1538(ra) # 80001a6c <wait>
}
    80002472:	60e2                	ld	ra,24(sp)
    80002474:	6442                	ld	s0,16(sp)
    80002476:	6105                	addi	sp,sp,32
    80002478:	8082                	ret

000000008000247a <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000247a:	7179                	addi	sp,sp,-48
    8000247c:	f406                	sd	ra,40(sp)
    8000247e:	f022                	sd	s0,32(sp)
    80002480:	ec26                	sd	s1,24(sp)
    80002482:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002484:	fdc40593          	addi	a1,s0,-36
    80002488:	4501                	li	a0,0
    8000248a:	00000097          	auipc	ra,0x0
    8000248e:	e84080e7          	jalr	-380(ra) # 8000230e <argint>
  addr = myproc()->sz;
    80002492:	fffff097          	auipc	ra,0xfffff
    80002496:	bc0080e7          	jalr	-1088(ra) # 80001052 <myproc>
    8000249a:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    8000249c:	fdc42503          	lw	a0,-36(s0)
    800024a0:	fffff097          	auipc	ra,0xfffff
    800024a4:	fa8080e7          	jalr	-88(ra) # 80001448 <growproc>
    800024a8:	00054863          	bltz	a0,800024b8 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    800024ac:	8526                	mv	a0,s1
    800024ae:	70a2                	ld	ra,40(sp)
    800024b0:	7402                	ld	s0,32(sp)
    800024b2:	64e2                	ld	s1,24(sp)
    800024b4:	6145                	addi	sp,sp,48
    800024b6:	8082                	ret
    return -1;
    800024b8:	54fd                	li	s1,-1
    800024ba:	bfcd                	j	800024ac <sys_sbrk+0x32>

00000000800024bc <sys_sleep>:

uint64
sys_sleep(void)
{
    800024bc:	7139                	addi	sp,sp,-64
    800024be:	fc06                	sd	ra,56(sp)
    800024c0:	f822                	sd	s0,48(sp)
    800024c2:	f426                	sd	s1,40(sp)
    800024c4:	f04a                	sd	s2,32(sp)
    800024c6:	ec4e                	sd	s3,24(sp)
    800024c8:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;


  argint(0, &n);
    800024ca:	fcc40593          	addi	a1,s0,-52
    800024ce:	4501                	li	a0,0
    800024d0:	00000097          	auipc	ra,0x0
    800024d4:	e3e080e7          	jalr	-450(ra) # 8000230e <argint>
  acquire(&tickslock);
    800024d8:	0000c517          	auipc	a0,0xc
    800024dc:	52850513          	addi	a0,a0,1320 # 8000ea00 <tickslock>
    800024e0:	00004097          	auipc	ra,0x4
    800024e4:	04c080e7          	jalr	76(ra) # 8000652c <acquire>
  ticks0 = ticks;
    800024e8:	00006917          	auipc	s2,0x6
    800024ec:	4b092903          	lw	s2,1200(s2) # 80008998 <ticks>
  while(ticks - ticks0 < n){
    800024f0:	fcc42783          	lw	a5,-52(s0)
    800024f4:	cf9d                	beqz	a5,80002532 <sys_sleep+0x76>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800024f6:	0000c997          	auipc	s3,0xc
    800024fa:	50a98993          	addi	s3,s3,1290 # 8000ea00 <tickslock>
    800024fe:	00006497          	auipc	s1,0x6
    80002502:	49a48493          	addi	s1,s1,1178 # 80008998 <ticks>
    if(killed(myproc())){
    80002506:	fffff097          	auipc	ra,0xfffff
    8000250a:	b4c080e7          	jalr	-1204(ra) # 80001052 <myproc>
    8000250e:	fffff097          	auipc	ra,0xfffff
    80002512:	52c080e7          	jalr	1324(ra) # 80001a3a <killed>
    80002516:	ed15                	bnez	a0,80002552 <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    80002518:	85ce                	mv	a1,s3
    8000251a:	8526                	mv	a0,s1
    8000251c:	fffff097          	auipc	ra,0xfffff
    80002520:	276080e7          	jalr	630(ra) # 80001792 <sleep>
  while(ticks - ticks0 < n){
    80002524:	409c                	lw	a5,0(s1)
    80002526:	412787bb          	subw	a5,a5,s2
    8000252a:	fcc42703          	lw	a4,-52(s0)
    8000252e:	fce7ece3          	bltu	a5,a4,80002506 <sys_sleep+0x4a>
  }
  release(&tickslock);
    80002532:	0000c517          	auipc	a0,0xc
    80002536:	4ce50513          	addi	a0,a0,1230 # 8000ea00 <tickslock>
    8000253a:	00004097          	auipc	ra,0x4
    8000253e:	0a6080e7          	jalr	166(ra) # 800065e0 <release>
  return 0;
    80002542:	4501                	li	a0,0
}
    80002544:	70e2                	ld	ra,56(sp)
    80002546:	7442                	ld	s0,48(sp)
    80002548:	74a2                	ld	s1,40(sp)
    8000254a:	7902                	ld	s2,32(sp)
    8000254c:	69e2                	ld	s3,24(sp)
    8000254e:	6121                	addi	sp,sp,64
    80002550:	8082                	ret
      release(&tickslock);
    80002552:	0000c517          	auipc	a0,0xc
    80002556:	4ae50513          	addi	a0,a0,1198 # 8000ea00 <tickslock>
    8000255a:	00004097          	auipc	ra,0x4
    8000255e:	086080e7          	jalr	134(ra) # 800065e0 <release>
      return -1;
    80002562:	557d                	li	a0,-1
    80002564:	b7c5                	j	80002544 <sys_sleep+0x88>

0000000080002566 <sys_pgaccess>:


#ifdef LAB_PGTBL
int
sys_pgaccess(void)
{
    80002566:	7179                	addi	sp,sp,-48
    80002568:	f406                	sd	ra,40(sp)
    8000256a:	f022                	sd	s0,32(sp)
    8000256c:	1800                	addi	s0,sp,48
  // lab pgtbl: your code here.
  uint64 p;
  argaddr(0, &p);  
    8000256e:	fe840593          	addi	a1,s0,-24
    80002572:	4501                	li	a0,0
    80002574:	00000097          	auipc	ra,0x0
    80002578:	dba080e7          	jalr	-582(ra) # 8000232e <argaddr>
  int n;
  argint(1, &n);  
    8000257c:	fe440593          	addi	a1,s0,-28
    80002580:	4505                	li	a0,1
    80002582:	00000097          	auipc	ra,0x0
    80002586:	d8c080e7          	jalr	-628(ra) # 8000230e <argint>
  uint64 ui;
  argaddr(2, &ui);
    8000258a:	fd840593          	addi	a1,s0,-40
    8000258e:	4509                	li	a0,2
    80002590:	00000097          	auipc	ra,0x0
    80002594:	d9e080e7          	jalr	-610(ra) # 8000232e <argaddr>

  return pgaccss(p, n, ui);
    80002598:	fd843603          	ld	a2,-40(s0)
    8000259c:	fe442583          	lw	a1,-28(s0)
    800025a0:	fe843503          	ld	a0,-24(s0)
    800025a4:	fffff097          	auipc	ra,0xfffff
    800025a8:	7a0080e7          	jalr	1952(ra) # 80001d44 <pgaccss>
}
    800025ac:	70a2                	ld	ra,40(sp)
    800025ae:	7402                	ld	s0,32(sp)
    800025b0:	6145                	addi	sp,sp,48
    800025b2:	8082                	ret

00000000800025b4 <sys_kill>:
#endif

uint64
sys_kill(void)
{
    800025b4:	1101                	addi	sp,sp,-32
    800025b6:	ec06                	sd	ra,24(sp)
    800025b8:	e822                	sd	s0,16(sp)
    800025ba:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800025bc:	fec40593          	addi	a1,s0,-20
    800025c0:	4501                	li	a0,0
    800025c2:	00000097          	auipc	ra,0x0
    800025c6:	d4c080e7          	jalr	-692(ra) # 8000230e <argint>
  return kill(pid);
    800025ca:	fec42503          	lw	a0,-20(s0)
    800025ce:	fffff097          	auipc	ra,0xfffff
    800025d2:	3ce080e7          	jalr	974(ra) # 8000199c <kill>
}
    800025d6:	60e2                	ld	ra,24(sp)
    800025d8:	6442                	ld	s0,16(sp)
    800025da:	6105                	addi	sp,sp,32
    800025dc:	8082                	ret

00000000800025de <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800025de:	1101                	addi	sp,sp,-32
    800025e0:	ec06                	sd	ra,24(sp)
    800025e2:	e822                	sd	s0,16(sp)
    800025e4:	e426                	sd	s1,8(sp)
    800025e6:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800025e8:	0000c517          	auipc	a0,0xc
    800025ec:	41850513          	addi	a0,a0,1048 # 8000ea00 <tickslock>
    800025f0:	00004097          	auipc	ra,0x4
    800025f4:	f3c080e7          	jalr	-196(ra) # 8000652c <acquire>
  xticks = ticks;
    800025f8:	00006497          	auipc	s1,0x6
    800025fc:	3a04a483          	lw	s1,928(s1) # 80008998 <ticks>
  release(&tickslock);
    80002600:	0000c517          	auipc	a0,0xc
    80002604:	40050513          	addi	a0,a0,1024 # 8000ea00 <tickslock>
    80002608:	00004097          	auipc	ra,0x4
    8000260c:	fd8080e7          	jalr	-40(ra) # 800065e0 <release>
  return xticks;
}
    80002610:	02049513          	slli	a0,s1,0x20
    80002614:	9101                	srli	a0,a0,0x20
    80002616:	60e2                	ld	ra,24(sp)
    80002618:	6442                	ld	s0,16(sp)
    8000261a:	64a2                	ld	s1,8(sp)
    8000261c:	6105                	addi	sp,sp,32
    8000261e:	8082                	ret

0000000080002620 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002620:	7179                	addi	sp,sp,-48
    80002622:	f406                	sd	ra,40(sp)
    80002624:	f022                	sd	s0,32(sp)
    80002626:	ec26                	sd	s1,24(sp)
    80002628:	e84a                	sd	s2,16(sp)
    8000262a:	e44e                	sd	s3,8(sp)
    8000262c:	e052                	sd	s4,0(sp)
    8000262e:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002630:	00006597          	auipc	a1,0x6
    80002634:	f2058593          	addi	a1,a1,-224 # 80008550 <syscalls+0xf8>
    80002638:	0000c517          	auipc	a0,0xc
    8000263c:	3e050513          	addi	a0,a0,992 # 8000ea18 <bcache>
    80002640:	00004097          	auipc	ra,0x4
    80002644:	e5c080e7          	jalr	-420(ra) # 8000649c <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002648:	00014797          	auipc	a5,0x14
    8000264c:	3d078793          	addi	a5,a5,976 # 80016a18 <bcache+0x8000>
    80002650:	00014717          	auipc	a4,0x14
    80002654:	63070713          	addi	a4,a4,1584 # 80016c80 <bcache+0x8268>
    80002658:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000265c:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002660:	0000c497          	auipc	s1,0xc
    80002664:	3d048493          	addi	s1,s1,976 # 8000ea30 <bcache+0x18>
    b->next = bcache.head.next;
    80002668:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000266a:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000266c:	00006a17          	auipc	s4,0x6
    80002670:	eeca0a13          	addi	s4,s4,-276 # 80008558 <syscalls+0x100>
    b->next = bcache.head.next;
    80002674:	2b893783          	ld	a5,696(s2)
    80002678:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000267a:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000267e:	85d2                	mv	a1,s4
    80002680:	01048513          	addi	a0,s1,16
    80002684:	00001097          	auipc	ra,0x1
    80002688:	4c4080e7          	jalr	1220(ra) # 80003b48 <initsleeplock>
    bcache.head.next->prev = b;
    8000268c:	2b893783          	ld	a5,696(s2)
    80002690:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002692:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002696:	45848493          	addi	s1,s1,1112
    8000269a:	fd349de3          	bne	s1,s3,80002674 <binit+0x54>
  }
}
    8000269e:	70a2                	ld	ra,40(sp)
    800026a0:	7402                	ld	s0,32(sp)
    800026a2:	64e2                	ld	s1,24(sp)
    800026a4:	6942                	ld	s2,16(sp)
    800026a6:	69a2                	ld	s3,8(sp)
    800026a8:	6a02                	ld	s4,0(sp)
    800026aa:	6145                	addi	sp,sp,48
    800026ac:	8082                	ret

00000000800026ae <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800026ae:	7179                	addi	sp,sp,-48
    800026b0:	f406                	sd	ra,40(sp)
    800026b2:	f022                	sd	s0,32(sp)
    800026b4:	ec26                	sd	s1,24(sp)
    800026b6:	e84a                	sd	s2,16(sp)
    800026b8:	e44e                	sd	s3,8(sp)
    800026ba:	1800                	addi	s0,sp,48
    800026bc:	89aa                	mv	s3,a0
    800026be:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    800026c0:	0000c517          	auipc	a0,0xc
    800026c4:	35850513          	addi	a0,a0,856 # 8000ea18 <bcache>
    800026c8:	00004097          	auipc	ra,0x4
    800026cc:	e64080e7          	jalr	-412(ra) # 8000652c <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800026d0:	00014497          	auipc	s1,0x14
    800026d4:	6004b483          	ld	s1,1536(s1) # 80016cd0 <bcache+0x82b8>
    800026d8:	00014797          	auipc	a5,0x14
    800026dc:	5a878793          	addi	a5,a5,1448 # 80016c80 <bcache+0x8268>
    800026e0:	02f48f63          	beq	s1,a5,8000271e <bread+0x70>
    800026e4:	873e                	mv	a4,a5
    800026e6:	a021                	j	800026ee <bread+0x40>
    800026e8:	68a4                	ld	s1,80(s1)
    800026ea:	02e48a63          	beq	s1,a4,8000271e <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800026ee:	449c                	lw	a5,8(s1)
    800026f0:	ff379ce3          	bne	a5,s3,800026e8 <bread+0x3a>
    800026f4:	44dc                	lw	a5,12(s1)
    800026f6:	ff2799e3          	bne	a5,s2,800026e8 <bread+0x3a>
      b->refcnt++;
    800026fa:	40bc                	lw	a5,64(s1)
    800026fc:	2785                	addiw	a5,a5,1
    800026fe:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002700:	0000c517          	auipc	a0,0xc
    80002704:	31850513          	addi	a0,a0,792 # 8000ea18 <bcache>
    80002708:	00004097          	auipc	ra,0x4
    8000270c:	ed8080e7          	jalr	-296(ra) # 800065e0 <release>
      acquiresleep(&b->lock);
    80002710:	01048513          	addi	a0,s1,16
    80002714:	00001097          	auipc	ra,0x1
    80002718:	46e080e7          	jalr	1134(ra) # 80003b82 <acquiresleep>
      return b;
    8000271c:	a8b9                	j	8000277a <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000271e:	00014497          	auipc	s1,0x14
    80002722:	5aa4b483          	ld	s1,1450(s1) # 80016cc8 <bcache+0x82b0>
    80002726:	00014797          	auipc	a5,0x14
    8000272a:	55a78793          	addi	a5,a5,1370 # 80016c80 <bcache+0x8268>
    8000272e:	00f48863          	beq	s1,a5,8000273e <bread+0x90>
    80002732:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002734:	40bc                	lw	a5,64(s1)
    80002736:	cf81                	beqz	a5,8000274e <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002738:	64a4                	ld	s1,72(s1)
    8000273a:	fee49de3          	bne	s1,a4,80002734 <bread+0x86>
  panic("bget: no buffers");
    8000273e:	00006517          	auipc	a0,0x6
    80002742:	e2250513          	addi	a0,a0,-478 # 80008560 <syscalls+0x108>
    80002746:	00004097          	auipc	ra,0x4
    8000274a:	89c080e7          	jalr	-1892(ra) # 80005fe2 <panic>
      b->dev = dev;
    8000274e:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002752:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80002756:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000275a:	4785                	li	a5,1
    8000275c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000275e:	0000c517          	auipc	a0,0xc
    80002762:	2ba50513          	addi	a0,a0,698 # 8000ea18 <bcache>
    80002766:	00004097          	auipc	ra,0x4
    8000276a:	e7a080e7          	jalr	-390(ra) # 800065e0 <release>
      acquiresleep(&b->lock);
    8000276e:	01048513          	addi	a0,s1,16
    80002772:	00001097          	auipc	ra,0x1
    80002776:	410080e7          	jalr	1040(ra) # 80003b82 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000277a:	409c                	lw	a5,0(s1)
    8000277c:	cb89                	beqz	a5,8000278e <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000277e:	8526                	mv	a0,s1
    80002780:	70a2                	ld	ra,40(sp)
    80002782:	7402                	ld	s0,32(sp)
    80002784:	64e2                	ld	s1,24(sp)
    80002786:	6942                	ld	s2,16(sp)
    80002788:	69a2                	ld	s3,8(sp)
    8000278a:	6145                	addi	sp,sp,48
    8000278c:	8082                	ret
    virtio_disk_rw(b, 0);
    8000278e:	4581                	li	a1,0
    80002790:	8526                	mv	a0,s1
    80002792:	00003097          	auipc	ra,0x3
    80002796:	fe6080e7          	jalr	-26(ra) # 80005778 <virtio_disk_rw>
    b->valid = 1;
    8000279a:	4785                	li	a5,1
    8000279c:	c09c                	sw	a5,0(s1)
  return b;
    8000279e:	b7c5                	j	8000277e <bread+0xd0>

00000000800027a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800027a0:	1101                	addi	sp,sp,-32
    800027a2:	ec06                	sd	ra,24(sp)
    800027a4:	e822                	sd	s0,16(sp)
    800027a6:	e426                	sd	s1,8(sp)
    800027a8:	1000                	addi	s0,sp,32
    800027aa:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800027ac:	0541                	addi	a0,a0,16
    800027ae:	00001097          	auipc	ra,0x1
    800027b2:	46e080e7          	jalr	1134(ra) # 80003c1c <holdingsleep>
    800027b6:	cd01                	beqz	a0,800027ce <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800027b8:	4585                	li	a1,1
    800027ba:	8526                	mv	a0,s1
    800027bc:	00003097          	auipc	ra,0x3
    800027c0:	fbc080e7          	jalr	-68(ra) # 80005778 <virtio_disk_rw>
}
    800027c4:	60e2                	ld	ra,24(sp)
    800027c6:	6442                	ld	s0,16(sp)
    800027c8:	64a2                	ld	s1,8(sp)
    800027ca:	6105                	addi	sp,sp,32
    800027cc:	8082                	ret
    panic("bwrite");
    800027ce:	00006517          	auipc	a0,0x6
    800027d2:	daa50513          	addi	a0,a0,-598 # 80008578 <syscalls+0x120>
    800027d6:	00004097          	auipc	ra,0x4
    800027da:	80c080e7          	jalr	-2036(ra) # 80005fe2 <panic>

00000000800027de <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800027de:	1101                	addi	sp,sp,-32
    800027e0:	ec06                	sd	ra,24(sp)
    800027e2:	e822                	sd	s0,16(sp)
    800027e4:	e426                	sd	s1,8(sp)
    800027e6:	e04a                	sd	s2,0(sp)
    800027e8:	1000                	addi	s0,sp,32
    800027ea:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800027ec:	01050913          	addi	s2,a0,16
    800027f0:	854a                	mv	a0,s2
    800027f2:	00001097          	auipc	ra,0x1
    800027f6:	42a080e7          	jalr	1066(ra) # 80003c1c <holdingsleep>
    800027fa:	c92d                	beqz	a0,8000286c <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800027fc:	854a                	mv	a0,s2
    800027fe:	00001097          	auipc	ra,0x1
    80002802:	3da080e7          	jalr	986(ra) # 80003bd8 <releasesleep>

  acquire(&bcache.lock);
    80002806:	0000c517          	auipc	a0,0xc
    8000280a:	21250513          	addi	a0,a0,530 # 8000ea18 <bcache>
    8000280e:	00004097          	auipc	ra,0x4
    80002812:	d1e080e7          	jalr	-738(ra) # 8000652c <acquire>
  b->refcnt--;
    80002816:	40bc                	lw	a5,64(s1)
    80002818:	37fd                	addiw	a5,a5,-1
    8000281a:	0007871b          	sext.w	a4,a5
    8000281e:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002820:	eb05                	bnez	a4,80002850 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002822:	68bc                	ld	a5,80(s1)
    80002824:	64b8                	ld	a4,72(s1)
    80002826:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002828:	64bc                	ld	a5,72(s1)
    8000282a:	68b8                	ld	a4,80(s1)
    8000282c:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000282e:	00014797          	auipc	a5,0x14
    80002832:	1ea78793          	addi	a5,a5,490 # 80016a18 <bcache+0x8000>
    80002836:	2b87b703          	ld	a4,696(a5)
    8000283a:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000283c:	00014717          	auipc	a4,0x14
    80002840:	44470713          	addi	a4,a4,1092 # 80016c80 <bcache+0x8268>
    80002844:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002846:	2b87b703          	ld	a4,696(a5)
    8000284a:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000284c:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002850:	0000c517          	auipc	a0,0xc
    80002854:	1c850513          	addi	a0,a0,456 # 8000ea18 <bcache>
    80002858:	00004097          	auipc	ra,0x4
    8000285c:	d88080e7          	jalr	-632(ra) # 800065e0 <release>
}
    80002860:	60e2                	ld	ra,24(sp)
    80002862:	6442                	ld	s0,16(sp)
    80002864:	64a2                	ld	s1,8(sp)
    80002866:	6902                	ld	s2,0(sp)
    80002868:	6105                	addi	sp,sp,32
    8000286a:	8082                	ret
    panic("brelse");
    8000286c:	00006517          	auipc	a0,0x6
    80002870:	d1450513          	addi	a0,a0,-748 # 80008580 <syscalls+0x128>
    80002874:	00003097          	auipc	ra,0x3
    80002878:	76e080e7          	jalr	1902(ra) # 80005fe2 <panic>

000000008000287c <bpin>:

void
bpin(struct buf *b) {
    8000287c:	1101                	addi	sp,sp,-32
    8000287e:	ec06                	sd	ra,24(sp)
    80002880:	e822                	sd	s0,16(sp)
    80002882:	e426                	sd	s1,8(sp)
    80002884:	1000                	addi	s0,sp,32
    80002886:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002888:	0000c517          	auipc	a0,0xc
    8000288c:	19050513          	addi	a0,a0,400 # 8000ea18 <bcache>
    80002890:	00004097          	auipc	ra,0x4
    80002894:	c9c080e7          	jalr	-868(ra) # 8000652c <acquire>
  b->refcnt++;
    80002898:	40bc                	lw	a5,64(s1)
    8000289a:	2785                	addiw	a5,a5,1
    8000289c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000289e:	0000c517          	auipc	a0,0xc
    800028a2:	17a50513          	addi	a0,a0,378 # 8000ea18 <bcache>
    800028a6:	00004097          	auipc	ra,0x4
    800028aa:	d3a080e7          	jalr	-710(ra) # 800065e0 <release>
}
    800028ae:	60e2                	ld	ra,24(sp)
    800028b0:	6442                	ld	s0,16(sp)
    800028b2:	64a2                	ld	s1,8(sp)
    800028b4:	6105                	addi	sp,sp,32
    800028b6:	8082                	ret

00000000800028b8 <bunpin>:

void
bunpin(struct buf *b) {
    800028b8:	1101                	addi	sp,sp,-32
    800028ba:	ec06                	sd	ra,24(sp)
    800028bc:	e822                	sd	s0,16(sp)
    800028be:	e426                	sd	s1,8(sp)
    800028c0:	1000                	addi	s0,sp,32
    800028c2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800028c4:	0000c517          	auipc	a0,0xc
    800028c8:	15450513          	addi	a0,a0,340 # 8000ea18 <bcache>
    800028cc:	00004097          	auipc	ra,0x4
    800028d0:	c60080e7          	jalr	-928(ra) # 8000652c <acquire>
  b->refcnt--;
    800028d4:	40bc                	lw	a5,64(s1)
    800028d6:	37fd                	addiw	a5,a5,-1
    800028d8:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800028da:	0000c517          	auipc	a0,0xc
    800028de:	13e50513          	addi	a0,a0,318 # 8000ea18 <bcache>
    800028e2:	00004097          	auipc	ra,0x4
    800028e6:	cfe080e7          	jalr	-770(ra) # 800065e0 <release>
}
    800028ea:	60e2                	ld	ra,24(sp)
    800028ec:	6442                	ld	s0,16(sp)
    800028ee:	64a2                	ld	s1,8(sp)
    800028f0:	6105                	addi	sp,sp,32
    800028f2:	8082                	ret

00000000800028f4 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800028f4:	1101                	addi	sp,sp,-32
    800028f6:	ec06                	sd	ra,24(sp)
    800028f8:	e822                	sd	s0,16(sp)
    800028fa:	e426                	sd	s1,8(sp)
    800028fc:	e04a                	sd	s2,0(sp)
    800028fe:	1000                	addi	s0,sp,32
    80002900:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002902:	00d5d59b          	srliw	a1,a1,0xd
    80002906:	00014797          	auipc	a5,0x14
    8000290a:	7ee7a783          	lw	a5,2030(a5) # 800170f4 <sb+0x1c>
    8000290e:	9dbd                	addw	a1,a1,a5
    80002910:	00000097          	auipc	ra,0x0
    80002914:	d9e080e7          	jalr	-610(ra) # 800026ae <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002918:	0074f713          	andi	a4,s1,7
    8000291c:	4785                	li	a5,1
    8000291e:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002922:	14ce                	slli	s1,s1,0x33
    80002924:	90d9                	srli	s1,s1,0x36
    80002926:	00950733          	add	a4,a0,s1
    8000292a:	05874703          	lbu	a4,88(a4)
    8000292e:	00e7f6b3          	and	a3,a5,a4
    80002932:	c69d                	beqz	a3,80002960 <bfree+0x6c>
    80002934:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002936:	94aa                	add	s1,s1,a0
    80002938:	fff7c793          	not	a5,a5
    8000293c:	8ff9                	and	a5,a5,a4
    8000293e:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002942:	00001097          	auipc	ra,0x1
    80002946:	120080e7          	jalr	288(ra) # 80003a62 <log_write>
  brelse(bp);
    8000294a:	854a                	mv	a0,s2
    8000294c:	00000097          	auipc	ra,0x0
    80002950:	e92080e7          	jalr	-366(ra) # 800027de <brelse>
}
    80002954:	60e2                	ld	ra,24(sp)
    80002956:	6442                	ld	s0,16(sp)
    80002958:	64a2                	ld	s1,8(sp)
    8000295a:	6902                	ld	s2,0(sp)
    8000295c:	6105                	addi	sp,sp,32
    8000295e:	8082                	ret
    panic("freeing free block");
    80002960:	00006517          	auipc	a0,0x6
    80002964:	c2850513          	addi	a0,a0,-984 # 80008588 <syscalls+0x130>
    80002968:	00003097          	auipc	ra,0x3
    8000296c:	67a080e7          	jalr	1658(ra) # 80005fe2 <panic>

0000000080002970 <balloc>:
{
    80002970:	711d                	addi	sp,sp,-96
    80002972:	ec86                	sd	ra,88(sp)
    80002974:	e8a2                	sd	s0,80(sp)
    80002976:	e4a6                	sd	s1,72(sp)
    80002978:	e0ca                	sd	s2,64(sp)
    8000297a:	fc4e                	sd	s3,56(sp)
    8000297c:	f852                	sd	s4,48(sp)
    8000297e:	f456                	sd	s5,40(sp)
    80002980:	f05a                	sd	s6,32(sp)
    80002982:	ec5e                	sd	s7,24(sp)
    80002984:	e862                	sd	s8,16(sp)
    80002986:	e466                	sd	s9,8(sp)
    80002988:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000298a:	00014797          	auipc	a5,0x14
    8000298e:	7527a783          	lw	a5,1874(a5) # 800170dc <sb+0x4>
    80002992:	10078163          	beqz	a5,80002a94 <balloc+0x124>
    80002996:	8baa                	mv	s7,a0
    80002998:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000299a:	00014b17          	auipc	s6,0x14
    8000299e:	73eb0b13          	addi	s6,s6,1854 # 800170d8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800029a2:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800029a4:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800029a6:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800029a8:	6c89                	lui	s9,0x2
    800029aa:	a061                	j	80002a32 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    800029ac:	974a                	add	a4,a4,s2
    800029ae:	8fd5                	or	a5,a5,a3
    800029b0:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800029b4:	854a                	mv	a0,s2
    800029b6:	00001097          	auipc	ra,0x1
    800029ba:	0ac080e7          	jalr	172(ra) # 80003a62 <log_write>
        brelse(bp);
    800029be:	854a                	mv	a0,s2
    800029c0:	00000097          	auipc	ra,0x0
    800029c4:	e1e080e7          	jalr	-482(ra) # 800027de <brelse>
  bp = bread(dev, bno);
    800029c8:	85a6                	mv	a1,s1
    800029ca:	855e                	mv	a0,s7
    800029cc:	00000097          	auipc	ra,0x0
    800029d0:	ce2080e7          	jalr	-798(ra) # 800026ae <bread>
    800029d4:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800029d6:	40000613          	li	a2,1024
    800029da:	4581                	li	a1,0
    800029dc:	05850513          	addi	a0,a0,88
    800029e0:	ffffd097          	auipc	ra,0xffffd
    800029e4:	798080e7          	jalr	1944(ra) # 80000178 <memset>
  log_write(bp);
    800029e8:	854a                	mv	a0,s2
    800029ea:	00001097          	auipc	ra,0x1
    800029ee:	078080e7          	jalr	120(ra) # 80003a62 <log_write>
  brelse(bp);
    800029f2:	854a                	mv	a0,s2
    800029f4:	00000097          	auipc	ra,0x0
    800029f8:	dea080e7          	jalr	-534(ra) # 800027de <brelse>
}
    800029fc:	8526                	mv	a0,s1
    800029fe:	60e6                	ld	ra,88(sp)
    80002a00:	6446                	ld	s0,80(sp)
    80002a02:	64a6                	ld	s1,72(sp)
    80002a04:	6906                	ld	s2,64(sp)
    80002a06:	79e2                	ld	s3,56(sp)
    80002a08:	7a42                	ld	s4,48(sp)
    80002a0a:	7aa2                	ld	s5,40(sp)
    80002a0c:	7b02                	ld	s6,32(sp)
    80002a0e:	6be2                	ld	s7,24(sp)
    80002a10:	6c42                	ld	s8,16(sp)
    80002a12:	6ca2                	ld	s9,8(sp)
    80002a14:	6125                	addi	sp,sp,96
    80002a16:	8082                	ret
    brelse(bp);
    80002a18:	854a                	mv	a0,s2
    80002a1a:	00000097          	auipc	ra,0x0
    80002a1e:	dc4080e7          	jalr	-572(ra) # 800027de <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002a22:	015c87bb          	addw	a5,s9,s5
    80002a26:	00078a9b          	sext.w	s5,a5
    80002a2a:	004b2703          	lw	a4,4(s6)
    80002a2e:	06eaf363          	bgeu	s5,a4,80002a94 <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    80002a32:	41fad79b          	sraiw	a5,s5,0x1f
    80002a36:	0137d79b          	srliw	a5,a5,0x13
    80002a3a:	015787bb          	addw	a5,a5,s5
    80002a3e:	40d7d79b          	sraiw	a5,a5,0xd
    80002a42:	01cb2583          	lw	a1,28(s6)
    80002a46:	9dbd                	addw	a1,a1,a5
    80002a48:	855e                	mv	a0,s7
    80002a4a:	00000097          	auipc	ra,0x0
    80002a4e:	c64080e7          	jalr	-924(ra) # 800026ae <bread>
    80002a52:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002a54:	004b2503          	lw	a0,4(s6)
    80002a58:	000a849b          	sext.w	s1,s5
    80002a5c:	8662                	mv	a2,s8
    80002a5e:	faa4fde3          	bgeu	s1,a0,80002a18 <balloc+0xa8>
      m = 1 << (bi % 8);
    80002a62:	41f6579b          	sraiw	a5,a2,0x1f
    80002a66:	01d7d69b          	srliw	a3,a5,0x1d
    80002a6a:	00c6873b          	addw	a4,a3,a2
    80002a6e:	00777793          	andi	a5,a4,7
    80002a72:	9f95                	subw	a5,a5,a3
    80002a74:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002a78:	4037571b          	sraiw	a4,a4,0x3
    80002a7c:	00e906b3          	add	a3,s2,a4
    80002a80:	0586c683          	lbu	a3,88(a3)
    80002a84:	00d7f5b3          	and	a1,a5,a3
    80002a88:	d195                	beqz	a1,800029ac <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002a8a:	2605                	addiw	a2,a2,1
    80002a8c:	2485                	addiw	s1,s1,1
    80002a8e:	fd4618e3          	bne	a2,s4,80002a5e <balloc+0xee>
    80002a92:	b759                	j	80002a18 <balloc+0xa8>
  printf("balloc: out of blocks\n");
    80002a94:	00006517          	auipc	a0,0x6
    80002a98:	b0c50513          	addi	a0,a0,-1268 # 800085a0 <syscalls+0x148>
    80002a9c:	00003097          	auipc	ra,0x3
    80002aa0:	590080e7          	jalr	1424(ra) # 8000602c <printf>
  return 0;
    80002aa4:	4481                	li	s1,0
    80002aa6:	bf99                	j	800029fc <balloc+0x8c>

0000000080002aa8 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002aa8:	7179                	addi	sp,sp,-48
    80002aaa:	f406                	sd	ra,40(sp)
    80002aac:	f022                	sd	s0,32(sp)
    80002aae:	ec26                	sd	s1,24(sp)
    80002ab0:	e84a                	sd	s2,16(sp)
    80002ab2:	e44e                	sd	s3,8(sp)
    80002ab4:	e052                	sd	s4,0(sp)
    80002ab6:	1800                	addi	s0,sp,48
    80002ab8:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002aba:	47ad                	li	a5,11
    80002abc:	02b7e763          	bltu	a5,a1,80002aea <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    80002ac0:	02059493          	slli	s1,a1,0x20
    80002ac4:	9081                	srli	s1,s1,0x20
    80002ac6:	048a                	slli	s1,s1,0x2
    80002ac8:	94aa                	add	s1,s1,a0
    80002aca:	0504a903          	lw	s2,80(s1)
    80002ace:	06091e63          	bnez	s2,80002b4a <bmap+0xa2>
      addr = balloc(ip->dev);
    80002ad2:	4108                	lw	a0,0(a0)
    80002ad4:	00000097          	auipc	ra,0x0
    80002ad8:	e9c080e7          	jalr	-356(ra) # 80002970 <balloc>
    80002adc:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002ae0:	06090563          	beqz	s2,80002b4a <bmap+0xa2>
        return 0;
      ip->addrs[bn] = addr;
    80002ae4:	0524a823          	sw	s2,80(s1)
    80002ae8:	a08d                	j	80002b4a <bmap+0xa2>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002aea:	ff45849b          	addiw	s1,a1,-12
    80002aee:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002af2:	0ff00793          	li	a5,255
    80002af6:	08e7e563          	bltu	a5,a4,80002b80 <bmap+0xd8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002afa:	08052903          	lw	s2,128(a0)
    80002afe:	00091d63          	bnez	s2,80002b18 <bmap+0x70>
      addr = balloc(ip->dev);
    80002b02:	4108                	lw	a0,0(a0)
    80002b04:	00000097          	auipc	ra,0x0
    80002b08:	e6c080e7          	jalr	-404(ra) # 80002970 <balloc>
    80002b0c:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002b10:	02090d63          	beqz	s2,80002b4a <bmap+0xa2>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002b14:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80002b18:	85ca                	mv	a1,s2
    80002b1a:	0009a503          	lw	a0,0(s3)
    80002b1e:	00000097          	auipc	ra,0x0
    80002b22:	b90080e7          	jalr	-1136(ra) # 800026ae <bread>
    80002b26:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002b28:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002b2c:	02049593          	slli	a1,s1,0x20
    80002b30:	9181                	srli	a1,a1,0x20
    80002b32:	058a                	slli	a1,a1,0x2
    80002b34:	00b784b3          	add	s1,a5,a1
    80002b38:	0004a903          	lw	s2,0(s1)
    80002b3c:	02090063          	beqz	s2,80002b5c <bmap+0xb4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002b40:	8552                	mv	a0,s4
    80002b42:	00000097          	auipc	ra,0x0
    80002b46:	c9c080e7          	jalr	-868(ra) # 800027de <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002b4a:	854a                	mv	a0,s2
    80002b4c:	70a2                	ld	ra,40(sp)
    80002b4e:	7402                	ld	s0,32(sp)
    80002b50:	64e2                	ld	s1,24(sp)
    80002b52:	6942                	ld	s2,16(sp)
    80002b54:	69a2                	ld	s3,8(sp)
    80002b56:	6a02                	ld	s4,0(sp)
    80002b58:	6145                	addi	sp,sp,48
    80002b5a:	8082                	ret
      addr = balloc(ip->dev);
    80002b5c:	0009a503          	lw	a0,0(s3)
    80002b60:	00000097          	auipc	ra,0x0
    80002b64:	e10080e7          	jalr	-496(ra) # 80002970 <balloc>
    80002b68:	0005091b          	sext.w	s2,a0
      if(addr){
    80002b6c:	fc090ae3          	beqz	s2,80002b40 <bmap+0x98>
        a[bn] = addr;
    80002b70:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002b74:	8552                	mv	a0,s4
    80002b76:	00001097          	auipc	ra,0x1
    80002b7a:	eec080e7          	jalr	-276(ra) # 80003a62 <log_write>
    80002b7e:	b7c9                	j	80002b40 <bmap+0x98>
  panic("bmap: out of range");
    80002b80:	00006517          	auipc	a0,0x6
    80002b84:	a3850513          	addi	a0,a0,-1480 # 800085b8 <syscalls+0x160>
    80002b88:	00003097          	auipc	ra,0x3
    80002b8c:	45a080e7          	jalr	1114(ra) # 80005fe2 <panic>

0000000080002b90 <iget>:
{
    80002b90:	7179                	addi	sp,sp,-48
    80002b92:	f406                	sd	ra,40(sp)
    80002b94:	f022                	sd	s0,32(sp)
    80002b96:	ec26                	sd	s1,24(sp)
    80002b98:	e84a                	sd	s2,16(sp)
    80002b9a:	e44e                	sd	s3,8(sp)
    80002b9c:	e052                	sd	s4,0(sp)
    80002b9e:	1800                	addi	s0,sp,48
    80002ba0:	89aa                	mv	s3,a0
    80002ba2:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002ba4:	00014517          	auipc	a0,0x14
    80002ba8:	55450513          	addi	a0,a0,1364 # 800170f8 <itable>
    80002bac:	00004097          	auipc	ra,0x4
    80002bb0:	980080e7          	jalr	-1664(ra) # 8000652c <acquire>
  empty = 0;
    80002bb4:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002bb6:	00014497          	auipc	s1,0x14
    80002bba:	55a48493          	addi	s1,s1,1370 # 80017110 <itable+0x18>
    80002bbe:	00016697          	auipc	a3,0x16
    80002bc2:	fe268693          	addi	a3,a3,-30 # 80018ba0 <log>
    80002bc6:	a039                	j	80002bd4 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002bc8:	02090b63          	beqz	s2,80002bfe <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002bcc:	08848493          	addi	s1,s1,136
    80002bd0:	02d48a63          	beq	s1,a3,80002c04 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002bd4:	449c                	lw	a5,8(s1)
    80002bd6:	fef059e3          	blez	a5,80002bc8 <iget+0x38>
    80002bda:	4098                	lw	a4,0(s1)
    80002bdc:	ff3716e3          	bne	a4,s3,80002bc8 <iget+0x38>
    80002be0:	40d8                	lw	a4,4(s1)
    80002be2:	ff4713e3          	bne	a4,s4,80002bc8 <iget+0x38>
      ip->ref++;
    80002be6:	2785                	addiw	a5,a5,1
    80002be8:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002bea:	00014517          	auipc	a0,0x14
    80002bee:	50e50513          	addi	a0,a0,1294 # 800170f8 <itable>
    80002bf2:	00004097          	auipc	ra,0x4
    80002bf6:	9ee080e7          	jalr	-1554(ra) # 800065e0 <release>
      return ip;
    80002bfa:	8926                	mv	s2,s1
    80002bfc:	a03d                	j	80002c2a <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002bfe:	f7f9                	bnez	a5,80002bcc <iget+0x3c>
    80002c00:	8926                	mv	s2,s1
    80002c02:	b7e9                	j	80002bcc <iget+0x3c>
  if(empty == 0)
    80002c04:	02090c63          	beqz	s2,80002c3c <iget+0xac>
  ip->dev = dev;
    80002c08:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002c0c:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002c10:	4785                	li	a5,1
    80002c12:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002c16:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002c1a:	00014517          	auipc	a0,0x14
    80002c1e:	4de50513          	addi	a0,a0,1246 # 800170f8 <itable>
    80002c22:	00004097          	auipc	ra,0x4
    80002c26:	9be080e7          	jalr	-1602(ra) # 800065e0 <release>
}
    80002c2a:	854a                	mv	a0,s2
    80002c2c:	70a2                	ld	ra,40(sp)
    80002c2e:	7402                	ld	s0,32(sp)
    80002c30:	64e2                	ld	s1,24(sp)
    80002c32:	6942                	ld	s2,16(sp)
    80002c34:	69a2                	ld	s3,8(sp)
    80002c36:	6a02                	ld	s4,0(sp)
    80002c38:	6145                	addi	sp,sp,48
    80002c3a:	8082                	ret
    panic("iget: no inodes");
    80002c3c:	00006517          	auipc	a0,0x6
    80002c40:	99450513          	addi	a0,a0,-1644 # 800085d0 <syscalls+0x178>
    80002c44:	00003097          	auipc	ra,0x3
    80002c48:	39e080e7          	jalr	926(ra) # 80005fe2 <panic>

0000000080002c4c <fsinit>:
fsinit(int dev) {
    80002c4c:	7179                	addi	sp,sp,-48
    80002c4e:	f406                	sd	ra,40(sp)
    80002c50:	f022                	sd	s0,32(sp)
    80002c52:	ec26                	sd	s1,24(sp)
    80002c54:	e84a                	sd	s2,16(sp)
    80002c56:	e44e                	sd	s3,8(sp)
    80002c58:	1800                	addi	s0,sp,48
    80002c5a:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002c5c:	4585                	li	a1,1
    80002c5e:	00000097          	auipc	ra,0x0
    80002c62:	a50080e7          	jalr	-1456(ra) # 800026ae <bread>
    80002c66:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002c68:	00014997          	auipc	s3,0x14
    80002c6c:	47098993          	addi	s3,s3,1136 # 800170d8 <sb>
    80002c70:	02000613          	li	a2,32
    80002c74:	05850593          	addi	a1,a0,88
    80002c78:	854e                	mv	a0,s3
    80002c7a:	ffffd097          	auipc	ra,0xffffd
    80002c7e:	55e080e7          	jalr	1374(ra) # 800001d8 <memmove>
  brelse(bp);
    80002c82:	8526                	mv	a0,s1
    80002c84:	00000097          	auipc	ra,0x0
    80002c88:	b5a080e7          	jalr	-1190(ra) # 800027de <brelse>
  if(sb.magic != FSMAGIC)
    80002c8c:	0009a703          	lw	a4,0(s3)
    80002c90:	102037b7          	lui	a5,0x10203
    80002c94:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002c98:	02f71263          	bne	a4,a5,80002cbc <fsinit+0x70>
  initlog(dev, &sb);
    80002c9c:	00014597          	auipc	a1,0x14
    80002ca0:	43c58593          	addi	a1,a1,1084 # 800170d8 <sb>
    80002ca4:	854a                	mv	a0,s2
    80002ca6:	00001097          	auipc	ra,0x1
    80002caa:	b40080e7          	jalr	-1216(ra) # 800037e6 <initlog>
}
    80002cae:	70a2                	ld	ra,40(sp)
    80002cb0:	7402                	ld	s0,32(sp)
    80002cb2:	64e2                	ld	s1,24(sp)
    80002cb4:	6942                	ld	s2,16(sp)
    80002cb6:	69a2                	ld	s3,8(sp)
    80002cb8:	6145                	addi	sp,sp,48
    80002cba:	8082                	ret
    panic("invalid file system");
    80002cbc:	00006517          	auipc	a0,0x6
    80002cc0:	92450513          	addi	a0,a0,-1756 # 800085e0 <syscalls+0x188>
    80002cc4:	00003097          	auipc	ra,0x3
    80002cc8:	31e080e7          	jalr	798(ra) # 80005fe2 <panic>

0000000080002ccc <iinit>:
{
    80002ccc:	7179                	addi	sp,sp,-48
    80002cce:	f406                	sd	ra,40(sp)
    80002cd0:	f022                	sd	s0,32(sp)
    80002cd2:	ec26                	sd	s1,24(sp)
    80002cd4:	e84a                	sd	s2,16(sp)
    80002cd6:	e44e                	sd	s3,8(sp)
    80002cd8:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002cda:	00006597          	auipc	a1,0x6
    80002cde:	91e58593          	addi	a1,a1,-1762 # 800085f8 <syscalls+0x1a0>
    80002ce2:	00014517          	auipc	a0,0x14
    80002ce6:	41650513          	addi	a0,a0,1046 # 800170f8 <itable>
    80002cea:	00003097          	auipc	ra,0x3
    80002cee:	7b2080e7          	jalr	1970(ra) # 8000649c <initlock>
  for(i = 0; i < NINODE; i++) {
    80002cf2:	00014497          	auipc	s1,0x14
    80002cf6:	42e48493          	addi	s1,s1,1070 # 80017120 <itable+0x28>
    80002cfa:	00016997          	auipc	s3,0x16
    80002cfe:	eb698993          	addi	s3,s3,-330 # 80018bb0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002d02:	00006917          	auipc	s2,0x6
    80002d06:	8fe90913          	addi	s2,s2,-1794 # 80008600 <syscalls+0x1a8>
    80002d0a:	85ca                	mv	a1,s2
    80002d0c:	8526                	mv	a0,s1
    80002d0e:	00001097          	auipc	ra,0x1
    80002d12:	e3a080e7          	jalr	-454(ra) # 80003b48 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002d16:	08848493          	addi	s1,s1,136
    80002d1a:	ff3498e3          	bne	s1,s3,80002d0a <iinit+0x3e>
}
    80002d1e:	70a2                	ld	ra,40(sp)
    80002d20:	7402                	ld	s0,32(sp)
    80002d22:	64e2                	ld	s1,24(sp)
    80002d24:	6942                	ld	s2,16(sp)
    80002d26:	69a2                	ld	s3,8(sp)
    80002d28:	6145                	addi	sp,sp,48
    80002d2a:	8082                	ret

0000000080002d2c <ialloc>:
{
    80002d2c:	715d                	addi	sp,sp,-80
    80002d2e:	e486                	sd	ra,72(sp)
    80002d30:	e0a2                	sd	s0,64(sp)
    80002d32:	fc26                	sd	s1,56(sp)
    80002d34:	f84a                	sd	s2,48(sp)
    80002d36:	f44e                	sd	s3,40(sp)
    80002d38:	f052                	sd	s4,32(sp)
    80002d3a:	ec56                	sd	s5,24(sp)
    80002d3c:	e85a                	sd	s6,16(sp)
    80002d3e:	e45e                	sd	s7,8(sp)
    80002d40:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002d42:	00014717          	auipc	a4,0x14
    80002d46:	3a272703          	lw	a4,930(a4) # 800170e4 <sb+0xc>
    80002d4a:	4785                	li	a5,1
    80002d4c:	04e7fa63          	bgeu	a5,a4,80002da0 <ialloc+0x74>
    80002d50:	8aaa                	mv	s5,a0
    80002d52:	8bae                	mv	s7,a1
    80002d54:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002d56:	00014a17          	auipc	s4,0x14
    80002d5a:	382a0a13          	addi	s4,s4,898 # 800170d8 <sb>
    80002d5e:	00048b1b          	sext.w	s6,s1
    80002d62:	0044d593          	srli	a1,s1,0x4
    80002d66:	018a2783          	lw	a5,24(s4)
    80002d6a:	9dbd                	addw	a1,a1,a5
    80002d6c:	8556                	mv	a0,s5
    80002d6e:	00000097          	auipc	ra,0x0
    80002d72:	940080e7          	jalr	-1728(ra) # 800026ae <bread>
    80002d76:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002d78:	05850993          	addi	s3,a0,88
    80002d7c:	00f4f793          	andi	a5,s1,15
    80002d80:	079a                	slli	a5,a5,0x6
    80002d82:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002d84:	00099783          	lh	a5,0(s3)
    80002d88:	c3a1                	beqz	a5,80002dc8 <ialloc+0x9c>
    brelse(bp);
    80002d8a:	00000097          	auipc	ra,0x0
    80002d8e:	a54080e7          	jalr	-1452(ra) # 800027de <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002d92:	0485                	addi	s1,s1,1
    80002d94:	00ca2703          	lw	a4,12(s4)
    80002d98:	0004879b          	sext.w	a5,s1
    80002d9c:	fce7e1e3          	bltu	a5,a4,80002d5e <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002da0:	00006517          	auipc	a0,0x6
    80002da4:	86850513          	addi	a0,a0,-1944 # 80008608 <syscalls+0x1b0>
    80002da8:	00003097          	auipc	ra,0x3
    80002dac:	284080e7          	jalr	644(ra) # 8000602c <printf>
  return 0;
    80002db0:	4501                	li	a0,0
}
    80002db2:	60a6                	ld	ra,72(sp)
    80002db4:	6406                	ld	s0,64(sp)
    80002db6:	74e2                	ld	s1,56(sp)
    80002db8:	7942                	ld	s2,48(sp)
    80002dba:	79a2                	ld	s3,40(sp)
    80002dbc:	7a02                	ld	s4,32(sp)
    80002dbe:	6ae2                	ld	s5,24(sp)
    80002dc0:	6b42                	ld	s6,16(sp)
    80002dc2:	6ba2                	ld	s7,8(sp)
    80002dc4:	6161                	addi	sp,sp,80
    80002dc6:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002dc8:	04000613          	li	a2,64
    80002dcc:	4581                	li	a1,0
    80002dce:	854e                	mv	a0,s3
    80002dd0:	ffffd097          	auipc	ra,0xffffd
    80002dd4:	3a8080e7          	jalr	936(ra) # 80000178 <memset>
      dip->type = type;
    80002dd8:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002ddc:	854a                	mv	a0,s2
    80002dde:	00001097          	auipc	ra,0x1
    80002de2:	c84080e7          	jalr	-892(ra) # 80003a62 <log_write>
      brelse(bp);
    80002de6:	854a                	mv	a0,s2
    80002de8:	00000097          	auipc	ra,0x0
    80002dec:	9f6080e7          	jalr	-1546(ra) # 800027de <brelse>
      return iget(dev, inum);
    80002df0:	85da                	mv	a1,s6
    80002df2:	8556                	mv	a0,s5
    80002df4:	00000097          	auipc	ra,0x0
    80002df8:	d9c080e7          	jalr	-612(ra) # 80002b90 <iget>
    80002dfc:	bf5d                	j	80002db2 <ialloc+0x86>

0000000080002dfe <iupdate>:
{
    80002dfe:	1101                	addi	sp,sp,-32
    80002e00:	ec06                	sd	ra,24(sp)
    80002e02:	e822                	sd	s0,16(sp)
    80002e04:	e426                	sd	s1,8(sp)
    80002e06:	e04a                	sd	s2,0(sp)
    80002e08:	1000                	addi	s0,sp,32
    80002e0a:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002e0c:	415c                	lw	a5,4(a0)
    80002e0e:	0047d79b          	srliw	a5,a5,0x4
    80002e12:	00014597          	auipc	a1,0x14
    80002e16:	2de5a583          	lw	a1,734(a1) # 800170f0 <sb+0x18>
    80002e1a:	9dbd                	addw	a1,a1,a5
    80002e1c:	4108                	lw	a0,0(a0)
    80002e1e:	00000097          	auipc	ra,0x0
    80002e22:	890080e7          	jalr	-1904(ra) # 800026ae <bread>
    80002e26:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002e28:	05850793          	addi	a5,a0,88
    80002e2c:	40c8                	lw	a0,4(s1)
    80002e2e:	893d                	andi	a0,a0,15
    80002e30:	051a                	slli	a0,a0,0x6
    80002e32:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002e34:	04449703          	lh	a4,68(s1)
    80002e38:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002e3c:	04649703          	lh	a4,70(s1)
    80002e40:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002e44:	04849703          	lh	a4,72(s1)
    80002e48:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002e4c:	04a49703          	lh	a4,74(s1)
    80002e50:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002e54:	44f8                	lw	a4,76(s1)
    80002e56:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002e58:	03400613          	li	a2,52
    80002e5c:	05048593          	addi	a1,s1,80
    80002e60:	0531                	addi	a0,a0,12
    80002e62:	ffffd097          	auipc	ra,0xffffd
    80002e66:	376080e7          	jalr	886(ra) # 800001d8 <memmove>
  log_write(bp);
    80002e6a:	854a                	mv	a0,s2
    80002e6c:	00001097          	auipc	ra,0x1
    80002e70:	bf6080e7          	jalr	-1034(ra) # 80003a62 <log_write>
  brelse(bp);
    80002e74:	854a                	mv	a0,s2
    80002e76:	00000097          	auipc	ra,0x0
    80002e7a:	968080e7          	jalr	-1688(ra) # 800027de <brelse>
}
    80002e7e:	60e2                	ld	ra,24(sp)
    80002e80:	6442                	ld	s0,16(sp)
    80002e82:	64a2                	ld	s1,8(sp)
    80002e84:	6902                	ld	s2,0(sp)
    80002e86:	6105                	addi	sp,sp,32
    80002e88:	8082                	ret

0000000080002e8a <idup>:
{
    80002e8a:	1101                	addi	sp,sp,-32
    80002e8c:	ec06                	sd	ra,24(sp)
    80002e8e:	e822                	sd	s0,16(sp)
    80002e90:	e426                	sd	s1,8(sp)
    80002e92:	1000                	addi	s0,sp,32
    80002e94:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e96:	00014517          	auipc	a0,0x14
    80002e9a:	26250513          	addi	a0,a0,610 # 800170f8 <itable>
    80002e9e:	00003097          	auipc	ra,0x3
    80002ea2:	68e080e7          	jalr	1678(ra) # 8000652c <acquire>
  ip->ref++;
    80002ea6:	449c                	lw	a5,8(s1)
    80002ea8:	2785                	addiw	a5,a5,1
    80002eaa:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002eac:	00014517          	auipc	a0,0x14
    80002eb0:	24c50513          	addi	a0,a0,588 # 800170f8 <itable>
    80002eb4:	00003097          	auipc	ra,0x3
    80002eb8:	72c080e7          	jalr	1836(ra) # 800065e0 <release>
}
    80002ebc:	8526                	mv	a0,s1
    80002ebe:	60e2                	ld	ra,24(sp)
    80002ec0:	6442                	ld	s0,16(sp)
    80002ec2:	64a2                	ld	s1,8(sp)
    80002ec4:	6105                	addi	sp,sp,32
    80002ec6:	8082                	ret

0000000080002ec8 <ilock>:
{
    80002ec8:	1101                	addi	sp,sp,-32
    80002eca:	ec06                	sd	ra,24(sp)
    80002ecc:	e822                	sd	s0,16(sp)
    80002ece:	e426                	sd	s1,8(sp)
    80002ed0:	e04a                	sd	s2,0(sp)
    80002ed2:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002ed4:	c115                	beqz	a0,80002ef8 <ilock+0x30>
    80002ed6:	84aa                	mv	s1,a0
    80002ed8:	451c                	lw	a5,8(a0)
    80002eda:	00f05f63          	blez	a5,80002ef8 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002ede:	0541                	addi	a0,a0,16
    80002ee0:	00001097          	auipc	ra,0x1
    80002ee4:	ca2080e7          	jalr	-862(ra) # 80003b82 <acquiresleep>
  if(ip->valid == 0){
    80002ee8:	40bc                	lw	a5,64(s1)
    80002eea:	cf99                	beqz	a5,80002f08 <ilock+0x40>
}
    80002eec:	60e2                	ld	ra,24(sp)
    80002eee:	6442                	ld	s0,16(sp)
    80002ef0:	64a2                	ld	s1,8(sp)
    80002ef2:	6902                	ld	s2,0(sp)
    80002ef4:	6105                	addi	sp,sp,32
    80002ef6:	8082                	ret
    panic("ilock");
    80002ef8:	00005517          	auipc	a0,0x5
    80002efc:	72850513          	addi	a0,a0,1832 # 80008620 <syscalls+0x1c8>
    80002f00:	00003097          	auipc	ra,0x3
    80002f04:	0e2080e7          	jalr	226(ra) # 80005fe2 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002f08:	40dc                	lw	a5,4(s1)
    80002f0a:	0047d79b          	srliw	a5,a5,0x4
    80002f0e:	00014597          	auipc	a1,0x14
    80002f12:	1e25a583          	lw	a1,482(a1) # 800170f0 <sb+0x18>
    80002f16:	9dbd                	addw	a1,a1,a5
    80002f18:	4088                	lw	a0,0(s1)
    80002f1a:	fffff097          	auipc	ra,0xfffff
    80002f1e:	794080e7          	jalr	1940(ra) # 800026ae <bread>
    80002f22:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002f24:	05850593          	addi	a1,a0,88
    80002f28:	40dc                	lw	a5,4(s1)
    80002f2a:	8bbd                	andi	a5,a5,15
    80002f2c:	079a                	slli	a5,a5,0x6
    80002f2e:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002f30:	00059783          	lh	a5,0(a1)
    80002f34:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002f38:	00259783          	lh	a5,2(a1)
    80002f3c:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002f40:	00459783          	lh	a5,4(a1)
    80002f44:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002f48:	00659783          	lh	a5,6(a1)
    80002f4c:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002f50:	459c                	lw	a5,8(a1)
    80002f52:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002f54:	03400613          	li	a2,52
    80002f58:	05b1                	addi	a1,a1,12
    80002f5a:	05048513          	addi	a0,s1,80
    80002f5e:	ffffd097          	auipc	ra,0xffffd
    80002f62:	27a080e7          	jalr	634(ra) # 800001d8 <memmove>
    brelse(bp);
    80002f66:	854a                	mv	a0,s2
    80002f68:	00000097          	auipc	ra,0x0
    80002f6c:	876080e7          	jalr	-1930(ra) # 800027de <brelse>
    ip->valid = 1;
    80002f70:	4785                	li	a5,1
    80002f72:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002f74:	04449783          	lh	a5,68(s1)
    80002f78:	fbb5                	bnez	a5,80002eec <ilock+0x24>
      panic("ilock: no type");
    80002f7a:	00005517          	auipc	a0,0x5
    80002f7e:	6ae50513          	addi	a0,a0,1710 # 80008628 <syscalls+0x1d0>
    80002f82:	00003097          	auipc	ra,0x3
    80002f86:	060080e7          	jalr	96(ra) # 80005fe2 <panic>

0000000080002f8a <iunlock>:
{
    80002f8a:	1101                	addi	sp,sp,-32
    80002f8c:	ec06                	sd	ra,24(sp)
    80002f8e:	e822                	sd	s0,16(sp)
    80002f90:	e426                	sd	s1,8(sp)
    80002f92:	e04a                	sd	s2,0(sp)
    80002f94:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002f96:	c905                	beqz	a0,80002fc6 <iunlock+0x3c>
    80002f98:	84aa                	mv	s1,a0
    80002f9a:	01050913          	addi	s2,a0,16
    80002f9e:	854a                	mv	a0,s2
    80002fa0:	00001097          	auipc	ra,0x1
    80002fa4:	c7c080e7          	jalr	-900(ra) # 80003c1c <holdingsleep>
    80002fa8:	cd19                	beqz	a0,80002fc6 <iunlock+0x3c>
    80002faa:	449c                	lw	a5,8(s1)
    80002fac:	00f05d63          	blez	a5,80002fc6 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002fb0:	854a                	mv	a0,s2
    80002fb2:	00001097          	auipc	ra,0x1
    80002fb6:	c26080e7          	jalr	-986(ra) # 80003bd8 <releasesleep>
}
    80002fba:	60e2                	ld	ra,24(sp)
    80002fbc:	6442                	ld	s0,16(sp)
    80002fbe:	64a2                	ld	s1,8(sp)
    80002fc0:	6902                	ld	s2,0(sp)
    80002fc2:	6105                	addi	sp,sp,32
    80002fc4:	8082                	ret
    panic("iunlock");
    80002fc6:	00005517          	auipc	a0,0x5
    80002fca:	67250513          	addi	a0,a0,1650 # 80008638 <syscalls+0x1e0>
    80002fce:	00003097          	auipc	ra,0x3
    80002fd2:	014080e7          	jalr	20(ra) # 80005fe2 <panic>

0000000080002fd6 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002fd6:	7179                	addi	sp,sp,-48
    80002fd8:	f406                	sd	ra,40(sp)
    80002fda:	f022                	sd	s0,32(sp)
    80002fdc:	ec26                	sd	s1,24(sp)
    80002fde:	e84a                	sd	s2,16(sp)
    80002fe0:	e44e                	sd	s3,8(sp)
    80002fe2:	e052                	sd	s4,0(sp)
    80002fe4:	1800                	addi	s0,sp,48
    80002fe6:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002fe8:	05050493          	addi	s1,a0,80
    80002fec:	08050913          	addi	s2,a0,128
    80002ff0:	a021                	j	80002ff8 <itrunc+0x22>
    80002ff2:	0491                	addi	s1,s1,4
    80002ff4:	01248d63          	beq	s1,s2,8000300e <itrunc+0x38>
    if(ip->addrs[i]){
    80002ff8:	408c                	lw	a1,0(s1)
    80002ffa:	dde5                	beqz	a1,80002ff2 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002ffc:	0009a503          	lw	a0,0(s3)
    80003000:	00000097          	auipc	ra,0x0
    80003004:	8f4080e7          	jalr	-1804(ra) # 800028f4 <bfree>
      ip->addrs[i] = 0;
    80003008:	0004a023          	sw	zero,0(s1)
    8000300c:	b7dd                	j	80002ff2 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    8000300e:	0809a583          	lw	a1,128(s3)
    80003012:	e185                	bnez	a1,80003032 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003014:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003018:	854e                	mv	a0,s3
    8000301a:	00000097          	auipc	ra,0x0
    8000301e:	de4080e7          	jalr	-540(ra) # 80002dfe <iupdate>
}
    80003022:	70a2                	ld	ra,40(sp)
    80003024:	7402                	ld	s0,32(sp)
    80003026:	64e2                	ld	s1,24(sp)
    80003028:	6942                	ld	s2,16(sp)
    8000302a:	69a2                	ld	s3,8(sp)
    8000302c:	6a02                	ld	s4,0(sp)
    8000302e:	6145                	addi	sp,sp,48
    80003030:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003032:	0009a503          	lw	a0,0(s3)
    80003036:	fffff097          	auipc	ra,0xfffff
    8000303a:	678080e7          	jalr	1656(ra) # 800026ae <bread>
    8000303e:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003040:	05850493          	addi	s1,a0,88
    80003044:	45850913          	addi	s2,a0,1112
    80003048:	a811                	j	8000305c <itrunc+0x86>
        bfree(ip->dev, a[j]);
    8000304a:	0009a503          	lw	a0,0(s3)
    8000304e:	00000097          	auipc	ra,0x0
    80003052:	8a6080e7          	jalr	-1882(ra) # 800028f4 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80003056:	0491                	addi	s1,s1,4
    80003058:	01248563          	beq	s1,s2,80003062 <itrunc+0x8c>
      if(a[j])
    8000305c:	408c                	lw	a1,0(s1)
    8000305e:	dde5                	beqz	a1,80003056 <itrunc+0x80>
    80003060:	b7ed                	j	8000304a <itrunc+0x74>
    brelse(bp);
    80003062:	8552                	mv	a0,s4
    80003064:	fffff097          	auipc	ra,0xfffff
    80003068:	77a080e7          	jalr	1914(ra) # 800027de <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    8000306c:	0809a583          	lw	a1,128(s3)
    80003070:	0009a503          	lw	a0,0(s3)
    80003074:	00000097          	auipc	ra,0x0
    80003078:	880080e7          	jalr	-1920(ra) # 800028f4 <bfree>
    ip->addrs[NDIRECT] = 0;
    8000307c:	0809a023          	sw	zero,128(s3)
    80003080:	bf51                	j	80003014 <itrunc+0x3e>

0000000080003082 <iput>:
{
    80003082:	1101                	addi	sp,sp,-32
    80003084:	ec06                	sd	ra,24(sp)
    80003086:	e822                	sd	s0,16(sp)
    80003088:	e426                	sd	s1,8(sp)
    8000308a:	e04a                	sd	s2,0(sp)
    8000308c:	1000                	addi	s0,sp,32
    8000308e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003090:	00014517          	auipc	a0,0x14
    80003094:	06850513          	addi	a0,a0,104 # 800170f8 <itable>
    80003098:	00003097          	auipc	ra,0x3
    8000309c:	494080e7          	jalr	1172(ra) # 8000652c <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800030a0:	4498                	lw	a4,8(s1)
    800030a2:	4785                	li	a5,1
    800030a4:	02f70363          	beq	a4,a5,800030ca <iput+0x48>
  ip->ref--;
    800030a8:	449c                	lw	a5,8(s1)
    800030aa:	37fd                	addiw	a5,a5,-1
    800030ac:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800030ae:	00014517          	auipc	a0,0x14
    800030b2:	04a50513          	addi	a0,a0,74 # 800170f8 <itable>
    800030b6:	00003097          	auipc	ra,0x3
    800030ba:	52a080e7          	jalr	1322(ra) # 800065e0 <release>
}
    800030be:	60e2                	ld	ra,24(sp)
    800030c0:	6442                	ld	s0,16(sp)
    800030c2:	64a2                	ld	s1,8(sp)
    800030c4:	6902                	ld	s2,0(sp)
    800030c6:	6105                	addi	sp,sp,32
    800030c8:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800030ca:	40bc                	lw	a5,64(s1)
    800030cc:	dff1                	beqz	a5,800030a8 <iput+0x26>
    800030ce:	04a49783          	lh	a5,74(s1)
    800030d2:	fbf9                	bnez	a5,800030a8 <iput+0x26>
    acquiresleep(&ip->lock);
    800030d4:	01048913          	addi	s2,s1,16
    800030d8:	854a                	mv	a0,s2
    800030da:	00001097          	auipc	ra,0x1
    800030de:	aa8080e7          	jalr	-1368(ra) # 80003b82 <acquiresleep>
    release(&itable.lock);
    800030e2:	00014517          	auipc	a0,0x14
    800030e6:	01650513          	addi	a0,a0,22 # 800170f8 <itable>
    800030ea:	00003097          	auipc	ra,0x3
    800030ee:	4f6080e7          	jalr	1270(ra) # 800065e0 <release>
    itrunc(ip);
    800030f2:	8526                	mv	a0,s1
    800030f4:	00000097          	auipc	ra,0x0
    800030f8:	ee2080e7          	jalr	-286(ra) # 80002fd6 <itrunc>
    ip->type = 0;
    800030fc:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003100:	8526                	mv	a0,s1
    80003102:	00000097          	auipc	ra,0x0
    80003106:	cfc080e7          	jalr	-772(ra) # 80002dfe <iupdate>
    ip->valid = 0;
    8000310a:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    8000310e:	854a                	mv	a0,s2
    80003110:	00001097          	auipc	ra,0x1
    80003114:	ac8080e7          	jalr	-1336(ra) # 80003bd8 <releasesleep>
    acquire(&itable.lock);
    80003118:	00014517          	auipc	a0,0x14
    8000311c:	fe050513          	addi	a0,a0,-32 # 800170f8 <itable>
    80003120:	00003097          	auipc	ra,0x3
    80003124:	40c080e7          	jalr	1036(ra) # 8000652c <acquire>
    80003128:	b741                	j	800030a8 <iput+0x26>

000000008000312a <iunlockput>:
{
    8000312a:	1101                	addi	sp,sp,-32
    8000312c:	ec06                	sd	ra,24(sp)
    8000312e:	e822                	sd	s0,16(sp)
    80003130:	e426                	sd	s1,8(sp)
    80003132:	1000                	addi	s0,sp,32
    80003134:	84aa                	mv	s1,a0
  iunlock(ip);
    80003136:	00000097          	auipc	ra,0x0
    8000313a:	e54080e7          	jalr	-428(ra) # 80002f8a <iunlock>
  iput(ip);
    8000313e:	8526                	mv	a0,s1
    80003140:	00000097          	auipc	ra,0x0
    80003144:	f42080e7          	jalr	-190(ra) # 80003082 <iput>
}
    80003148:	60e2                	ld	ra,24(sp)
    8000314a:	6442                	ld	s0,16(sp)
    8000314c:	64a2                	ld	s1,8(sp)
    8000314e:	6105                	addi	sp,sp,32
    80003150:	8082                	ret

0000000080003152 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003152:	1141                	addi	sp,sp,-16
    80003154:	e422                	sd	s0,8(sp)
    80003156:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003158:	411c                	lw	a5,0(a0)
    8000315a:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000315c:	415c                	lw	a5,4(a0)
    8000315e:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003160:	04451783          	lh	a5,68(a0)
    80003164:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003168:	04a51783          	lh	a5,74(a0)
    8000316c:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003170:	04c56783          	lwu	a5,76(a0)
    80003174:	e99c                	sd	a5,16(a1)
}
    80003176:	6422                	ld	s0,8(sp)
    80003178:	0141                	addi	sp,sp,16
    8000317a:	8082                	ret

000000008000317c <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000317c:	457c                	lw	a5,76(a0)
    8000317e:	0ed7e963          	bltu	a5,a3,80003270 <readi+0xf4>
{
    80003182:	7159                	addi	sp,sp,-112
    80003184:	f486                	sd	ra,104(sp)
    80003186:	f0a2                	sd	s0,96(sp)
    80003188:	eca6                	sd	s1,88(sp)
    8000318a:	e8ca                	sd	s2,80(sp)
    8000318c:	e4ce                	sd	s3,72(sp)
    8000318e:	e0d2                	sd	s4,64(sp)
    80003190:	fc56                	sd	s5,56(sp)
    80003192:	f85a                	sd	s6,48(sp)
    80003194:	f45e                	sd	s7,40(sp)
    80003196:	f062                	sd	s8,32(sp)
    80003198:	ec66                	sd	s9,24(sp)
    8000319a:	e86a                	sd	s10,16(sp)
    8000319c:	e46e                	sd	s11,8(sp)
    8000319e:	1880                	addi	s0,sp,112
    800031a0:	8b2a                	mv	s6,a0
    800031a2:	8bae                	mv	s7,a1
    800031a4:	8a32                	mv	s4,a2
    800031a6:	84b6                	mv	s1,a3
    800031a8:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800031aa:	9f35                	addw	a4,a4,a3
    return 0;
    800031ac:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800031ae:	0ad76063          	bltu	a4,a3,8000324e <readi+0xd2>
  if(off + n > ip->size)
    800031b2:	00e7f463          	bgeu	a5,a4,800031ba <readi+0x3e>
    n = ip->size - off;
    800031b6:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800031ba:	0a0a8963          	beqz	s5,8000326c <readi+0xf0>
    800031be:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800031c0:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800031c4:	5c7d                	li	s8,-1
    800031c6:	a82d                	j	80003200 <readi+0x84>
    800031c8:	020d1d93          	slli	s11,s10,0x20
    800031cc:	020ddd93          	srli	s11,s11,0x20
    800031d0:	05890613          	addi	a2,s2,88
    800031d4:	86ee                	mv	a3,s11
    800031d6:	963a                	add	a2,a2,a4
    800031d8:	85d2                	mv	a1,s4
    800031da:	855e                	mv	a0,s7
    800031dc:	fffff097          	auipc	ra,0xfffff
    800031e0:	9be080e7          	jalr	-1602(ra) # 80001b9a <either_copyout>
    800031e4:	05850d63          	beq	a0,s8,8000323e <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800031e8:	854a                	mv	a0,s2
    800031ea:	fffff097          	auipc	ra,0xfffff
    800031ee:	5f4080e7          	jalr	1524(ra) # 800027de <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800031f2:	013d09bb          	addw	s3,s10,s3
    800031f6:	009d04bb          	addw	s1,s10,s1
    800031fa:	9a6e                	add	s4,s4,s11
    800031fc:	0559f763          	bgeu	s3,s5,8000324a <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80003200:	00a4d59b          	srliw	a1,s1,0xa
    80003204:	855a                	mv	a0,s6
    80003206:	00000097          	auipc	ra,0x0
    8000320a:	8a2080e7          	jalr	-1886(ra) # 80002aa8 <bmap>
    8000320e:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003212:	cd85                	beqz	a1,8000324a <readi+0xce>
    bp = bread(ip->dev, addr);
    80003214:	000b2503          	lw	a0,0(s6)
    80003218:	fffff097          	auipc	ra,0xfffff
    8000321c:	496080e7          	jalr	1174(ra) # 800026ae <bread>
    80003220:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003222:	3ff4f713          	andi	a4,s1,1023
    80003226:	40ec87bb          	subw	a5,s9,a4
    8000322a:	413a86bb          	subw	a3,s5,s3
    8000322e:	8d3e                	mv	s10,a5
    80003230:	2781                	sext.w	a5,a5
    80003232:	0006861b          	sext.w	a2,a3
    80003236:	f8f679e3          	bgeu	a2,a5,800031c8 <readi+0x4c>
    8000323a:	8d36                	mv	s10,a3
    8000323c:	b771                	j	800031c8 <readi+0x4c>
      brelse(bp);
    8000323e:	854a                	mv	a0,s2
    80003240:	fffff097          	auipc	ra,0xfffff
    80003244:	59e080e7          	jalr	1438(ra) # 800027de <brelse>
      tot = -1;
    80003248:	59fd                	li	s3,-1
  }
  return tot;
    8000324a:	0009851b          	sext.w	a0,s3
}
    8000324e:	70a6                	ld	ra,104(sp)
    80003250:	7406                	ld	s0,96(sp)
    80003252:	64e6                	ld	s1,88(sp)
    80003254:	6946                	ld	s2,80(sp)
    80003256:	69a6                	ld	s3,72(sp)
    80003258:	6a06                	ld	s4,64(sp)
    8000325a:	7ae2                	ld	s5,56(sp)
    8000325c:	7b42                	ld	s6,48(sp)
    8000325e:	7ba2                	ld	s7,40(sp)
    80003260:	7c02                	ld	s8,32(sp)
    80003262:	6ce2                	ld	s9,24(sp)
    80003264:	6d42                	ld	s10,16(sp)
    80003266:	6da2                	ld	s11,8(sp)
    80003268:	6165                	addi	sp,sp,112
    8000326a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000326c:	89d6                	mv	s3,s5
    8000326e:	bff1                	j	8000324a <readi+0xce>
    return 0;
    80003270:	4501                	li	a0,0
}
    80003272:	8082                	ret

0000000080003274 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003274:	457c                	lw	a5,76(a0)
    80003276:	10d7e863          	bltu	a5,a3,80003386 <writei+0x112>
{
    8000327a:	7159                	addi	sp,sp,-112
    8000327c:	f486                	sd	ra,104(sp)
    8000327e:	f0a2                	sd	s0,96(sp)
    80003280:	eca6                	sd	s1,88(sp)
    80003282:	e8ca                	sd	s2,80(sp)
    80003284:	e4ce                	sd	s3,72(sp)
    80003286:	e0d2                	sd	s4,64(sp)
    80003288:	fc56                	sd	s5,56(sp)
    8000328a:	f85a                	sd	s6,48(sp)
    8000328c:	f45e                	sd	s7,40(sp)
    8000328e:	f062                	sd	s8,32(sp)
    80003290:	ec66                	sd	s9,24(sp)
    80003292:	e86a                	sd	s10,16(sp)
    80003294:	e46e                	sd	s11,8(sp)
    80003296:	1880                	addi	s0,sp,112
    80003298:	8aaa                	mv	s5,a0
    8000329a:	8bae                	mv	s7,a1
    8000329c:	8a32                	mv	s4,a2
    8000329e:	8936                	mv	s2,a3
    800032a0:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800032a2:	00e687bb          	addw	a5,a3,a4
    800032a6:	0ed7e263          	bltu	a5,a3,8000338a <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800032aa:	00043737          	lui	a4,0x43
    800032ae:	0ef76063          	bltu	a4,a5,8000338e <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800032b2:	0c0b0863          	beqz	s6,80003382 <writei+0x10e>
    800032b6:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800032b8:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800032bc:	5c7d                	li	s8,-1
    800032be:	a091                	j	80003302 <writei+0x8e>
    800032c0:	020d1d93          	slli	s11,s10,0x20
    800032c4:	020ddd93          	srli	s11,s11,0x20
    800032c8:	05848513          	addi	a0,s1,88
    800032cc:	86ee                	mv	a3,s11
    800032ce:	8652                	mv	a2,s4
    800032d0:	85de                	mv	a1,s7
    800032d2:	953a                	add	a0,a0,a4
    800032d4:	fffff097          	auipc	ra,0xfffff
    800032d8:	91c080e7          	jalr	-1764(ra) # 80001bf0 <either_copyin>
    800032dc:	07850263          	beq	a0,s8,80003340 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    800032e0:	8526                	mv	a0,s1
    800032e2:	00000097          	auipc	ra,0x0
    800032e6:	780080e7          	jalr	1920(ra) # 80003a62 <log_write>
    brelse(bp);
    800032ea:	8526                	mv	a0,s1
    800032ec:	fffff097          	auipc	ra,0xfffff
    800032f0:	4f2080e7          	jalr	1266(ra) # 800027de <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800032f4:	013d09bb          	addw	s3,s10,s3
    800032f8:	012d093b          	addw	s2,s10,s2
    800032fc:	9a6e                	add	s4,s4,s11
    800032fe:	0569f663          	bgeu	s3,s6,8000334a <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80003302:	00a9559b          	srliw	a1,s2,0xa
    80003306:	8556                	mv	a0,s5
    80003308:	fffff097          	auipc	ra,0xfffff
    8000330c:	7a0080e7          	jalr	1952(ra) # 80002aa8 <bmap>
    80003310:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003314:	c99d                	beqz	a1,8000334a <writei+0xd6>
    bp = bread(ip->dev, addr);
    80003316:	000aa503          	lw	a0,0(s5) # 1000 <_entry-0x7ffff000>
    8000331a:	fffff097          	auipc	ra,0xfffff
    8000331e:	394080e7          	jalr	916(ra) # 800026ae <bread>
    80003322:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003324:	3ff97713          	andi	a4,s2,1023
    80003328:	40ec87bb          	subw	a5,s9,a4
    8000332c:	413b06bb          	subw	a3,s6,s3
    80003330:	8d3e                	mv	s10,a5
    80003332:	2781                	sext.w	a5,a5
    80003334:	0006861b          	sext.w	a2,a3
    80003338:	f8f674e3          	bgeu	a2,a5,800032c0 <writei+0x4c>
    8000333c:	8d36                	mv	s10,a3
    8000333e:	b749                	j	800032c0 <writei+0x4c>
      brelse(bp);
    80003340:	8526                	mv	a0,s1
    80003342:	fffff097          	auipc	ra,0xfffff
    80003346:	49c080e7          	jalr	1180(ra) # 800027de <brelse>
  }

  if(off > ip->size)
    8000334a:	04caa783          	lw	a5,76(s5)
    8000334e:	0127f463          	bgeu	a5,s2,80003356 <writei+0xe2>
    ip->size = off;
    80003352:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003356:	8556                	mv	a0,s5
    80003358:	00000097          	auipc	ra,0x0
    8000335c:	aa6080e7          	jalr	-1370(ra) # 80002dfe <iupdate>

  return tot;
    80003360:	0009851b          	sext.w	a0,s3
}
    80003364:	70a6                	ld	ra,104(sp)
    80003366:	7406                	ld	s0,96(sp)
    80003368:	64e6                	ld	s1,88(sp)
    8000336a:	6946                	ld	s2,80(sp)
    8000336c:	69a6                	ld	s3,72(sp)
    8000336e:	6a06                	ld	s4,64(sp)
    80003370:	7ae2                	ld	s5,56(sp)
    80003372:	7b42                	ld	s6,48(sp)
    80003374:	7ba2                	ld	s7,40(sp)
    80003376:	7c02                	ld	s8,32(sp)
    80003378:	6ce2                	ld	s9,24(sp)
    8000337a:	6d42                	ld	s10,16(sp)
    8000337c:	6da2                	ld	s11,8(sp)
    8000337e:	6165                	addi	sp,sp,112
    80003380:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003382:	89da                	mv	s3,s6
    80003384:	bfc9                	j	80003356 <writei+0xe2>
    return -1;
    80003386:	557d                	li	a0,-1
}
    80003388:	8082                	ret
    return -1;
    8000338a:	557d                	li	a0,-1
    8000338c:	bfe1                	j	80003364 <writei+0xf0>
    return -1;
    8000338e:	557d                	li	a0,-1
    80003390:	bfd1                	j	80003364 <writei+0xf0>

0000000080003392 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003392:	1141                	addi	sp,sp,-16
    80003394:	e406                	sd	ra,8(sp)
    80003396:	e022                	sd	s0,0(sp)
    80003398:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000339a:	4639                	li	a2,14
    8000339c:	ffffd097          	auipc	ra,0xffffd
    800033a0:	eb4080e7          	jalr	-332(ra) # 80000250 <strncmp>
}
    800033a4:	60a2                	ld	ra,8(sp)
    800033a6:	6402                	ld	s0,0(sp)
    800033a8:	0141                	addi	sp,sp,16
    800033aa:	8082                	ret

00000000800033ac <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800033ac:	7139                	addi	sp,sp,-64
    800033ae:	fc06                	sd	ra,56(sp)
    800033b0:	f822                	sd	s0,48(sp)
    800033b2:	f426                	sd	s1,40(sp)
    800033b4:	f04a                	sd	s2,32(sp)
    800033b6:	ec4e                	sd	s3,24(sp)
    800033b8:	e852                	sd	s4,16(sp)
    800033ba:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800033bc:	04451703          	lh	a4,68(a0)
    800033c0:	4785                	li	a5,1
    800033c2:	00f71a63          	bne	a4,a5,800033d6 <dirlookup+0x2a>
    800033c6:	892a                	mv	s2,a0
    800033c8:	89ae                	mv	s3,a1
    800033ca:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800033cc:	457c                	lw	a5,76(a0)
    800033ce:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800033d0:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033d2:	e79d                	bnez	a5,80003400 <dirlookup+0x54>
    800033d4:	a8a5                	j	8000344c <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800033d6:	00005517          	auipc	a0,0x5
    800033da:	26a50513          	addi	a0,a0,618 # 80008640 <syscalls+0x1e8>
    800033de:	00003097          	auipc	ra,0x3
    800033e2:	c04080e7          	jalr	-1020(ra) # 80005fe2 <panic>
      panic("dirlookup read");
    800033e6:	00005517          	auipc	a0,0x5
    800033ea:	27250513          	addi	a0,a0,626 # 80008658 <syscalls+0x200>
    800033ee:	00003097          	auipc	ra,0x3
    800033f2:	bf4080e7          	jalr	-1036(ra) # 80005fe2 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033f6:	24c1                	addiw	s1,s1,16
    800033f8:	04c92783          	lw	a5,76(s2)
    800033fc:	04f4f763          	bgeu	s1,a5,8000344a <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003400:	4741                	li	a4,16
    80003402:	86a6                	mv	a3,s1
    80003404:	fc040613          	addi	a2,s0,-64
    80003408:	4581                	li	a1,0
    8000340a:	854a                	mv	a0,s2
    8000340c:	00000097          	auipc	ra,0x0
    80003410:	d70080e7          	jalr	-656(ra) # 8000317c <readi>
    80003414:	47c1                	li	a5,16
    80003416:	fcf518e3          	bne	a0,a5,800033e6 <dirlookup+0x3a>
    if(de.inum == 0)
    8000341a:	fc045783          	lhu	a5,-64(s0)
    8000341e:	dfe1                	beqz	a5,800033f6 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003420:	fc240593          	addi	a1,s0,-62
    80003424:	854e                	mv	a0,s3
    80003426:	00000097          	auipc	ra,0x0
    8000342a:	f6c080e7          	jalr	-148(ra) # 80003392 <namecmp>
    8000342e:	f561                	bnez	a0,800033f6 <dirlookup+0x4a>
      if(poff)
    80003430:	000a0463          	beqz	s4,80003438 <dirlookup+0x8c>
        *poff = off;
    80003434:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003438:	fc045583          	lhu	a1,-64(s0)
    8000343c:	00092503          	lw	a0,0(s2)
    80003440:	fffff097          	auipc	ra,0xfffff
    80003444:	750080e7          	jalr	1872(ra) # 80002b90 <iget>
    80003448:	a011                	j	8000344c <dirlookup+0xa0>
  return 0;
    8000344a:	4501                	li	a0,0
}
    8000344c:	70e2                	ld	ra,56(sp)
    8000344e:	7442                	ld	s0,48(sp)
    80003450:	74a2                	ld	s1,40(sp)
    80003452:	7902                	ld	s2,32(sp)
    80003454:	69e2                	ld	s3,24(sp)
    80003456:	6a42                	ld	s4,16(sp)
    80003458:	6121                	addi	sp,sp,64
    8000345a:	8082                	ret

000000008000345c <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000345c:	711d                	addi	sp,sp,-96
    8000345e:	ec86                	sd	ra,88(sp)
    80003460:	e8a2                	sd	s0,80(sp)
    80003462:	e4a6                	sd	s1,72(sp)
    80003464:	e0ca                	sd	s2,64(sp)
    80003466:	fc4e                	sd	s3,56(sp)
    80003468:	f852                	sd	s4,48(sp)
    8000346a:	f456                	sd	s5,40(sp)
    8000346c:	f05a                	sd	s6,32(sp)
    8000346e:	ec5e                	sd	s7,24(sp)
    80003470:	e862                	sd	s8,16(sp)
    80003472:	e466                	sd	s9,8(sp)
    80003474:	1080                	addi	s0,sp,96
    80003476:	84aa                	mv	s1,a0
    80003478:	8b2e                	mv	s6,a1
    8000347a:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000347c:	00054703          	lbu	a4,0(a0)
    80003480:	02f00793          	li	a5,47
    80003484:	02f70363          	beq	a4,a5,800034aa <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003488:	ffffe097          	auipc	ra,0xffffe
    8000348c:	bca080e7          	jalr	-1078(ra) # 80001052 <myproc>
    80003490:	15053503          	ld	a0,336(a0)
    80003494:	00000097          	auipc	ra,0x0
    80003498:	9f6080e7          	jalr	-1546(ra) # 80002e8a <idup>
    8000349c:	89aa                	mv	s3,a0
  while(*path == '/')
    8000349e:	02f00913          	li	s2,47
  len = path - s;
    800034a2:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    800034a4:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800034a6:	4c05                	li	s8,1
    800034a8:	a865                	j	80003560 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800034aa:	4585                	li	a1,1
    800034ac:	4505                	li	a0,1
    800034ae:	fffff097          	auipc	ra,0xfffff
    800034b2:	6e2080e7          	jalr	1762(ra) # 80002b90 <iget>
    800034b6:	89aa                	mv	s3,a0
    800034b8:	b7dd                	j	8000349e <namex+0x42>
      iunlockput(ip);
    800034ba:	854e                	mv	a0,s3
    800034bc:	00000097          	auipc	ra,0x0
    800034c0:	c6e080e7          	jalr	-914(ra) # 8000312a <iunlockput>
      return 0;
    800034c4:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800034c6:	854e                	mv	a0,s3
    800034c8:	60e6                	ld	ra,88(sp)
    800034ca:	6446                	ld	s0,80(sp)
    800034cc:	64a6                	ld	s1,72(sp)
    800034ce:	6906                	ld	s2,64(sp)
    800034d0:	79e2                	ld	s3,56(sp)
    800034d2:	7a42                	ld	s4,48(sp)
    800034d4:	7aa2                	ld	s5,40(sp)
    800034d6:	7b02                	ld	s6,32(sp)
    800034d8:	6be2                	ld	s7,24(sp)
    800034da:	6c42                	ld	s8,16(sp)
    800034dc:	6ca2                	ld	s9,8(sp)
    800034de:	6125                	addi	sp,sp,96
    800034e0:	8082                	ret
      iunlock(ip);
    800034e2:	854e                	mv	a0,s3
    800034e4:	00000097          	auipc	ra,0x0
    800034e8:	aa6080e7          	jalr	-1370(ra) # 80002f8a <iunlock>
      return ip;
    800034ec:	bfe9                	j	800034c6 <namex+0x6a>
      iunlockput(ip);
    800034ee:	854e                	mv	a0,s3
    800034f0:	00000097          	auipc	ra,0x0
    800034f4:	c3a080e7          	jalr	-966(ra) # 8000312a <iunlockput>
      return 0;
    800034f8:	89d2                	mv	s3,s4
    800034fa:	b7f1                	j	800034c6 <namex+0x6a>
  len = path - s;
    800034fc:	40b48633          	sub	a2,s1,a1
    80003500:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80003504:	094cd463          	bge	s9,s4,8000358c <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003508:	4639                	li	a2,14
    8000350a:	8556                	mv	a0,s5
    8000350c:	ffffd097          	auipc	ra,0xffffd
    80003510:	ccc080e7          	jalr	-820(ra) # 800001d8 <memmove>
  while(*path == '/')
    80003514:	0004c783          	lbu	a5,0(s1)
    80003518:	01279763          	bne	a5,s2,80003526 <namex+0xca>
    path++;
    8000351c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000351e:	0004c783          	lbu	a5,0(s1)
    80003522:	ff278de3          	beq	a5,s2,8000351c <namex+0xc0>
    ilock(ip);
    80003526:	854e                	mv	a0,s3
    80003528:	00000097          	auipc	ra,0x0
    8000352c:	9a0080e7          	jalr	-1632(ra) # 80002ec8 <ilock>
    if(ip->type != T_DIR){
    80003530:	04499783          	lh	a5,68(s3)
    80003534:	f98793e3          	bne	a5,s8,800034ba <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003538:	000b0563          	beqz	s6,80003542 <namex+0xe6>
    8000353c:	0004c783          	lbu	a5,0(s1)
    80003540:	d3cd                	beqz	a5,800034e2 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003542:	865e                	mv	a2,s7
    80003544:	85d6                	mv	a1,s5
    80003546:	854e                	mv	a0,s3
    80003548:	00000097          	auipc	ra,0x0
    8000354c:	e64080e7          	jalr	-412(ra) # 800033ac <dirlookup>
    80003550:	8a2a                	mv	s4,a0
    80003552:	dd51                	beqz	a0,800034ee <namex+0x92>
    iunlockput(ip);
    80003554:	854e                	mv	a0,s3
    80003556:	00000097          	auipc	ra,0x0
    8000355a:	bd4080e7          	jalr	-1068(ra) # 8000312a <iunlockput>
    ip = next;
    8000355e:	89d2                	mv	s3,s4
  while(*path == '/')
    80003560:	0004c783          	lbu	a5,0(s1)
    80003564:	05279763          	bne	a5,s2,800035b2 <namex+0x156>
    path++;
    80003568:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000356a:	0004c783          	lbu	a5,0(s1)
    8000356e:	ff278de3          	beq	a5,s2,80003568 <namex+0x10c>
  if(*path == 0)
    80003572:	c79d                	beqz	a5,800035a0 <namex+0x144>
    path++;
    80003574:	85a6                	mv	a1,s1
  len = path - s;
    80003576:	8a5e                	mv	s4,s7
    80003578:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    8000357a:	01278963          	beq	a5,s2,8000358c <namex+0x130>
    8000357e:	dfbd                	beqz	a5,800034fc <namex+0xa0>
    path++;
    80003580:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003582:	0004c783          	lbu	a5,0(s1)
    80003586:	ff279ce3          	bne	a5,s2,8000357e <namex+0x122>
    8000358a:	bf8d                	j	800034fc <namex+0xa0>
    memmove(name, s, len);
    8000358c:	2601                	sext.w	a2,a2
    8000358e:	8556                	mv	a0,s5
    80003590:	ffffd097          	auipc	ra,0xffffd
    80003594:	c48080e7          	jalr	-952(ra) # 800001d8 <memmove>
    name[len] = 0;
    80003598:	9a56                	add	s4,s4,s5
    8000359a:	000a0023          	sb	zero,0(s4)
    8000359e:	bf9d                	j	80003514 <namex+0xb8>
  if(nameiparent){
    800035a0:	f20b03e3          	beqz	s6,800034c6 <namex+0x6a>
    iput(ip);
    800035a4:	854e                	mv	a0,s3
    800035a6:	00000097          	auipc	ra,0x0
    800035aa:	adc080e7          	jalr	-1316(ra) # 80003082 <iput>
    return 0;
    800035ae:	4981                	li	s3,0
    800035b0:	bf19                	j	800034c6 <namex+0x6a>
  if(*path == 0)
    800035b2:	d7fd                	beqz	a5,800035a0 <namex+0x144>
  while(*path != '/' && *path != 0)
    800035b4:	0004c783          	lbu	a5,0(s1)
    800035b8:	85a6                	mv	a1,s1
    800035ba:	b7d1                	j	8000357e <namex+0x122>

00000000800035bc <dirlink>:
{
    800035bc:	7139                	addi	sp,sp,-64
    800035be:	fc06                	sd	ra,56(sp)
    800035c0:	f822                	sd	s0,48(sp)
    800035c2:	f426                	sd	s1,40(sp)
    800035c4:	f04a                	sd	s2,32(sp)
    800035c6:	ec4e                	sd	s3,24(sp)
    800035c8:	e852                	sd	s4,16(sp)
    800035ca:	0080                	addi	s0,sp,64
    800035cc:	892a                	mv	s2,a0
    800035ce:	8a2e                	mv	s4,a1
    800035d0:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800035d2:	4601                	li	a2,0
    800035d4:	00000097          	auipc	ra,0x0
    800035d8:	dd8080e7          	jalr	-552(ra) # 800033ac <dirlookup>
    800035dc:	e93d                	bnez	a0,80003652 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800035de:	04c92483          	lw	s1,76(s2)
    800035e2:	c49d                	beqz	s1,80003610 <dirlink+0x54>
    800035e4:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800035e6:	4741                	li	a4,16
    800035e8:	86a6                	mv	a3,s1
    800035ea:	fc040613          	addi	a2,s0,-64
    800035ee:	4581                	li	a1,0
    800035f0:	854a                	mv	a0,s2
    800035f2:	00000097          	auipc	ra,0x0
    800035f6:	b8a080e7          	jalr	-1142(ra) # 8000317c <readi>
    800035fa:	47c1                	li	a5,16
    800035fc:	06f51163          	bne	a0,a5,8000365e <dirlink+0xa2>
    if(de.inum == 0)
    80003600:	fc045783          	lhu	a5,-64(s0)
    80003604:	c791                	beqz	a5,80003610 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003606:	24c1                	addiw	s1,s1,16
    80003608:	04c92783          	lw	a5,76(s2)
    8000360c:	fcf4ede3          	bltu	s1,a5,800035e6 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003610:	4639                	li	a2,14
    80003612:	85d2                	mv	a1,s4
    80003614:	fc240513          	addi	a0,s0,-62
    80003618:	ffffd097          	auipc	ra,0xffffd
    8000361c:	c74080e7          	jalr	-908(ra) # 8000028c <strncpy>
  de.inum = inum;
    80003620:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003624:	4741                	li	a4,16
    80003626:	86a6                	mv	a3,s1
    80003628:	fc040613          	addi	a2,s0,-64
    8000362c:	4581                	li	a1,0
    8000362e:	854a                	mv	a0,s2
    80003630:	00000097          	auipc	ra,0x0
    80003634:	c44080e7          	jalr	-956(ra) # 80003274 <writei>
    80003638:	1541                	addi	a0,a0,-16
    8000363a:	00a03533          	snez	a0,a0
    8000363e:	40a00533          	neg	a0,a0
}
    80003642:	70e2                	ld	ra,56(sp)
    80003644:	7442                	ld	s0,48(sp)
    80003646:	74a2                	ld	s1,40(sp)
    80003648:	7902                	ld	s2,32(sp)
    8000364a:	69e2                	ld	s3,24(sp)
    8000364c:	6a42                	ld	s4,16(sp)
    8000364e:	6121                	addi	sp,sp,64
    80003650:	8082                	ret
    iput(ip);
    80003652:	00000097          	auipc	ra,0x0
    80003656:	a30080e7          	jalr	-1488(ra) # 80003082 <iput>
    return -1;
    8000365a:	557d                	li	a0,-1
    8000365c:	b7dd                	j	80003642 <dirlink+0x86>
      panic("dirlink read");
    8000365e:	00005517          	auipc	a0,0x5
    80003662:	00a50513          	addi	a0,a0,10 # 80008668 <syscalls+0x210>
    80003666:	00003097          	auipc	ra,0x3
    8000366a:	97c080e7          	jalr	-1668(ra) # 80005fe2 <panic>

000000008000366e <namei>:

struct inode*
namei(char *path)
{
    8000366e:	1101                	addi	sp,sp,-32
    80003670:	ec06                	sd	ra,24(sp)
    80003672:	e822                	sd	s0,16(sp)
    80003674:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003676:	fe040613          	addi	a2,s0,-32
    8000367a:	4581                	li	a1,0
    8000367c:	00000097          	auipc	ra,0x0
    80003680:	de0080e7          	jalr	-544(ra) # 8000345c <namex>
}
    80003684:	60e2                	ld	ra,24(sp)
    80003686:	6442                	ld	s0,16(sp)
    80003688:	6105                	addi	sp,sp,32
    8000368a:	8082                	ret

000000008000368c <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000368c:	1141                	addi	sp,sp,-16
    8000368e:	e406                	sd	ra,8(sp)
    80003690:	e022                	sd	s0,0(sp)
    80003692:	0800                	addi	s0,sp,16
    80003694:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003696:	4585                	li	a1,1
    80003698:	00000097          	auipc	ra,0x0
    8000369c:	dc4080e7          	jalr	-572(ra) # 8000345c <namex>
}
    800036a0:	60a2                	ld	ra,8(sp)
    800036a2:	6402                	ld	s0,0(sp)
    800036a4:	0141                	addi	sp,sp,16
    800036a6:	8082                	ret

00000000800036a8 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800036a8:	1101                	addi	sp,sp,-32
    800036aa:	ec06                	sd	ra,24(sp)
    800036ac:	e822                	sd	s0,16(sp)
    800036ae:	e426                	sd	s1,8(sp)
    800036b0:	e04a                	sd	s2,0(sp)
    800036b2:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800036b4:	00015917          	auipc	s2,0x15
    800036b8:	4ec90913          	addi	s2,s2,1260 # 80018ba0 <log>
    800036bc:	01892583          	lw	a1,24(s2)
    800036c0:	02892503          	lw	a0,40(s2)
    800036c4:	fffff097          	auipc	ra,0xfffff
    800036c8:	fea080e7          	jalr	-22(ra) # 800026ae <bread>
    800036cc:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800036ce:	02c92683          	lw	a3,44(s2)
    800036d2:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800036d4:	02d05763          	blez	a3,80003702 <write_head+0x5a>
    800036d8:	00015797          	auipc	a5,0x15
    800036dc:	4f878793          	addi	a5,a5,1272 # 80018bd0 <log+0x30>
    800036e0:	05c50713          	addi	a4,a0,92
    800036e4:	36fd                	addiw	a3,a3,-1
    800036e6:	1682                	slli	a3,a3,0x20
    800036e8:	9281                	srli	a3,a3,0x20
    800036ea:	068a                	slli	a3,a3,0x2
    800036ec:	00015617          	auipc	a2,0x15
    800036f0:	4e860613          	addi	a2,a2,1256 # 80018bd4 <log+0x34>
    800036f4:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800036f6:	4390                	lw	a2,0(a5)
    800036f8:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800036fa:	0791                	addi	a5,a5,4
    800036fc:	0711                	addi	a4,a4,4
    800036fe:	fed79ce3          	bne	a5,a3,800036f6 <write_head+0x4e>
  }
  bwrite(buf);
    80003702:	8526                	mv	a0,s1
    80003704:	fffff097          	auipc	ra,0xfffff
    80003708:	09c080e7          	jalr	156(ra) # 800027a0 <bwrite>
  brelse(buf);
    8000370c:	8526                	mv	a0,s1
    8000370e:	fffff097          	auipc	ra,0xfffff
    80003712:	0d0080e7          	jalr	208(ra) # 800027de <brelse>
}
    80003716:	60e2                	ld	ra,24(sp)
    80003718:	6442                	ld	s0,16(sp)
    8000371a:	64a2                	ld	s1,8(sp)
    8000371c:	6902                	ld	s2,0(sp)
    8000371e:	6105                	addi	sp,sp,32
    80003720:	8082                	ret

0000000080003722 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003722:	00015797          	auipc	a5,0x15
    80003726:	4aa7a783          	lw	a5,1194(a5) # 80018bcc <log+0x2c>
    8000372a:	0af05d63          	blez	a5,800037e4 <install_trans+0xc2>
{
    8000372e:	7139                	addi	sp,sp,-64
    80003730:	fc06                	sd	ra,56(sp)
    80003732:	f822                	sd	s0,48(sp)
    80003734:	f426                	sd	s1,40(sp)
    80003736:	f04a                	sd	s2,32(sp)
    80003738:	ec4e                	sd	s3,24(sp)
    8000373a:	e852                	sd	s4,16(sp)
    8000373c:	e456                	sd	s5,8(sp)
    8000373e:	e05a                	sd	s6,0(sp)
    80003740:	0080                	addi	s0,sp,64
    80003742:	8b2a                	mv	s6,a0
    80003744:	00015a97          	auipc	s5,0x15
    80003748:	48ca8a93          	addi	s5,s5,1164 # 80018bd0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000374c:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000374e:	00015997          	auipc	s3,0x15
    80003752:	45298993          	addi	s3,s3,1106 # 80018ba0 <log>
    80003756:	a035                	j	80003782 <install_trans+0x60>
      bunpin(dbuf);
    80003758:	8526                	mv	a0,s1
    8000375a:	fffff097          	auipc	ra,0xfffff
    8000375e:	15e080e7          	jalr	350(ra) # 800028b8 <bunpin>
    brelse(lbuf);
    80003762:	854a                	mv	a0,s2
    80003764:	fffff097          	auipc	ra,0xfffff
    80003768:	07a080e7          	jalr	122(ra) # 800027de <brelse>
    brelse(dbuf);
    8000376c:	8526                	mv	a0,s1
    8000376e:	fffff097          	auipc	ra,0xfffff
    80003772:	070080e7          	jalr	112(ra) # 800027de <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003776:	2a05                	addiw	s4,s4,1
    80003778:	0a91                	addi	s5,s5,4
    8000377a:	02c9a783          	lw	a5,44(s3)
    8000377e:	04fa5963          	bge	s4,a5,800037d0 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003782:	0189a583          	lw	a1,24(s3)
    80003786:	014585bb          	addw	a1,a1,s4
    8000378a:	2585                	addiw	a1,a1,1
    8000378c:	0289a503          	lw	a0,40(s3)
    80003790:	fffff097          	auipc	ra,0xfffff
    80003794:	f1e080e7          	jalr	-226(ra) # 800026ae <bread>
    80003798:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000379a:	000aa583          	lw	a1,0(s5)
    8000379e:	0289a503          	lw	a0,40(s3)
    800037a2:	fffff097          	auipc	ra,0xfffff
    800037a6:	f0c080e7          	jalr	-244(ra) # 800026ae <bread>
    800037aa:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800037ac:	40000613          	li	a2,1024
    800037b0:	05890593          	addi	a1,s2,88
    800037b4:	05850513          	addi	a0,a0,88
    800037b8:	ffffd097          	auipc	ra,0xffffd
    800037bc:	a20080e7          	jalr	-1504(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    800037c0:	8526                	mv	a0,s1
    800037c2:	fffff097          	auipc	ra,0xfffff
    800037c6:	fde080e7          	jalr	-34(ra) # 800027a0 <bwrite>
    if(recovering == 0)
    800037ca:	f80b1ce3          	bnez	s6,80003762 <install_trans+0x40>
    800037ce:	b769                	j	80003758 <install_trans+0x36>
}
    800037d0:	70e2                	ld	ra,56(sp)
    800037d2:	7442                	ld	s0,48(sp)
    800037d4:	74a2                	ld	s1,40(sp)
    800037d6:	7902                	ld	s2,32(sp)
    800037d8:	69e2                	ld	s3,24(sp)
    800037da:	6a42                	ld	s4,16(sp)
    800037dc:	6aa2                	ld	s5,8(sp)
    800037de:	6b02                	ld	s6,0(sp)
    800037e0:	6121                	addi	sp,sp,64
    800037e2:	8082                	ret
    800037e4:	8082                	ret

00000000800037e6 <initlog>:
{
    800037e6:	7179                	addi	sp,sp,-48
    800037e8:	f406                	sd	ra,40(sp)
    800037ea:	f022                	sd	s0,32(sp)
    800037ec:	ec26                	sd	s1,24(sp)
    800037ee:	e84a                	sd	s2,16(sp)
    800037f0:	e44e                	sd	s3,8(sp)
    800037f2:	1800                	addi	s0,sp,48
    800037f4:	892a                	mv	s2,a0
    800037f6:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800037f8:	00015497          	auipc	s1,0x15
    800037fc:	3a848493          	addi	s1,s1,936 # 80018ba0 <log>
    80003800:	00005597          	auipc	a1,0x5
    80003804:	e7858593          	addi	a1,a1,-392 # 80008678 <syscalls+0x220>
    80003808:	8526                	mv	a0,s1
    8000380a:	00003097          	auipc	ra,0x3
    8000380e:	c92080e7          	jalr	-878(ra) # 8000649c <initlock>
  log.start = sb->logstart;
    80003812:	0149a583          	lw	a1,20(s3)
    80003816:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003818:	0109a783          	lw	a5,16(s3)
    8000381c:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000381e:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003822:	854a                	mv	a0,s2
    80003824:	fffff097          	auipc	ra,0xfffff
    80003828:	e8a080e7          	jalr	-374(ra) # 800026ae <bread>
  log.lh.n = lh->n;
    8000382c:	4d3c                	lw	a5,88(a0)
    8000382e:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003830:	02f05563          	blez	a5,8000385a <initlog+0x74>
    80003834:	05c50713          	addi	a4,a0,92
    80003838:	00015697          	auipc	a3,0x15
    8000383c:	39868693          	addi	a3,a3,920 # 80018bd0 <log+0x30>
    80003840:	37fd                	addiw	a5,a5,-1
    80003842:	1782                	slli	a5,a5,0x20
    80003844:	9381                	srli	a5,a5,0x20
    80003846:	078a                	slli	a5,a5,0x2
    80003848:	06050613          	addi	a2,a0,96
    8000384c:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    8000384e:	4310                	lw	a2,0(a4)
    80003850:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003852:	0711                	addi	a4,a4,4
    80003854:	0691                	addi	a3,a3,4
    80003856:	fef71ce3          	bne	a4,a5,8000384e <initlog+0x68>
  brelse(buf);
    8000385a:	fffff097          	auipc	ra,0xfffff
    8000385e:	f84080e7          	jalr	-124(ra) # 800027de <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003862:	4505                	li	a0,1
    80003864:	00000097          	auipc	ra,0x0
    80003868:	ebe080e7          	jalr	-322(ra) # 80003722 <install_trans>
  log.lh.n = 0;
    8000386c:	00015797          	auipc	a5,0x15
    80003870:	3607a023          	sw	zero,864(a5) # 80018bcc <log+0x2c>
  write_head(); // clear the log
    80003874:	00000097          	auipc	ra,0x0
    80003878:	e34080e7          	jalr	-460(ra) # 800036a8 <write_head>
}
    8000387c:	70a2                	ld	ra,40(sp)
    8000387e:	7402                	ld	s0,32(sp)
    80003880:	64e2                	ld	s1,24(sp)
    80003882:	6942                	ld	s2,16(sp)
    80003884:	69a2                	ld	s3,8(sp)
    80003886:	6145                	addi	sp,sp,48
    80003888:	8082                	ret

000000008000388a <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000388a:	1101                	addi	sp,sp,-32
    8000388c:	ec06                	sd	ra,24(sp)
    8000388e:	e822                	sd	s0,16(sp)
    80003890:	e426                	sd	s1,8(sp)
    80003892:	e04a                	sd	s2,0(sp)
    80003894:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003896:	00015517          	auipc	a0,0x15
    8000389a:	30a50513          	addi	a0,a0,778 # 80018ba0 <log>
    8000389e:	00003097          	auipc	ra,0x3
    800038a2:	c8e080e7          	jalr	-882(ra) # 8000652c <acquire>
  while(1){
    if(log.committing){
    800038a6:	00015497          	auipc	s1,0x15
    800038aa:	2fa48493          	addi	s1,s1,762 # 80018ba0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800038ae:	4979                	li	s2,30
    800038b0:	a039                	j	800038be <begin_op+0x34>
      sleep(&log, &log.lock);
    800038b2:	85a6                	mv	a1,s1
    800038b4:	8526                	mv	a0,s1
    800038b6:	ffffe097          	auipc	ra,0xffffe
    800038ba:	edc080e7          	jalr	-292(ra) # 80001792 <sleep>
    if(log.committing){
    800038be:	50dc                	lw	a5,36(s1)
    800038c0:	fbed                	bnez	a5,800038b2 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800038c2:	509c                	lw	a5,32(s1)
    800038c4:	0017871b          	addiw	a4,a5,1
    800038c8:	0007069b          	sext.w	a3,a4
    800038cc:	0027179b          	slliw	a5,a4,0x2
    800038d0:	9fb9                	addw	a5,a5,a4
    800038d2:	0017979b          	slliw	a5,a5,0x1
    800038d6:	54d8                	lw	a4,44(s1)
    800038d8:	9fb9                	addw	a5,a5,a4
    800038da:	00f95963          	bge	s2,a5,800038ec <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800038de:	85a6                	mv	a1,s1
    800038e0:	8526                	mv	a0,s1
    800038e2:	ffffe097          	auipc	ra,0xffffe
    800038e6:	eb0080e7          	jalr	-336(ra) # 80001792 <sleep>
    800038ea:	bfd1                	j	800038be <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800038ec:	00015517          	auipc	a0,0x15
    800038f0:	2b450513          	addi	a0,a0,692 # 80018ba0 <log>
    800038f4:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800038f6:	00003097          	auipc	ra,0x3
    800038fa:	cea080e7          	jalr	-790(ra) # 800065e0 <release>
      break;
    }
  }
}
    800038fe:	60e2                	ld	ra,24(sp)
    80003900:	6442                	ld	s0,16(sp)
    80003902:	64a2                	ld	s1,8(sp)
    80003904:	6902                	ld	s2,0(sp)
    80003906:	6105                	addi	sp,sp,32
    80003908:	8082                	ret

000000008000390a <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000390a:	7139                	addi	sp,sp,-64
    8000390c:	fc06                	sd	ra,56(sp)
    8000390e:	f822                	sd	s0,48(sp)
    80003910:	f426                	sd	s1,40(sp)
    80003912:	f04a                	sd	s2,32(sp)
    80003914:	ec4e                	sd	s3,24(sp)
    80003916:	e852                	sd	s4,16(sp)
    80003918:	e456                	sd	s5,8(sp)
    8000391a:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000391c:	00015497          	auipc	s1,0x15
    80003920:	28448493          	addi	s1,s1,644 # 80018ba0 <log>
    80003924:	8526                	mv	a0,s1
    80003926:	00003097          	auipc	ra,0x3
    8000392a:	c06080e7          	jalr	-1018(ra) # 8000652c <acquire>
  log.outstanding -= 1;
    8000392e:	509c                	lw	a5,32(s1)
    80003930:	37fd                	addiw	a5,a5,-1
    80003932:	0007891b          	sext.w	s2,a5
    80003936:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003938:	50dc                	lw	a5,36(s1)
    8000393a:	efb9                	bnez	a5,80003998 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000393c:	06091663          	bnez	s2,800039a8 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80003940:	00015497          	auipc	s1,0x15
    80003944:	26048493          	addi	s1,s1,608 # 80018ba0 <log>
    80003948:	4785                	li	a5,1
    8000394a:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000394c:	8526                	mv	a0,s1
    8000394e:	00003097          	auipc	ra,0x3
    80003952:	c92080e7          	jalr	-878(ra) # 800065e0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003956:	54dc                	lw	a5,44(s1)
    80003958:	06f04763          	bgtz	a5,800039c6 <end_op+0xbc>
    acquire(&log.lock);
    8000395c:	00015497          	auipc	s1,0x15
    80003960:	24448493          	addi	s1,s1,580 # 80018ba0 <log>
    80003964:	8526                	mv	a0,s1
    80003966:	00003097          	auipc	ra,0x3
    8000396a:	bc6080e7          	jalr	-1082(ra) # 8000652c <acquire>
    log.committing = 0;
    8000396e:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003972:	8526                	mv	a0,s1
    80003974:	ffffe097          	auipc	ra,0xffffe
    80003978:	e82080e7          	jalr	-382(ra) # 800017f6 <wakeup>
    release(&log.lock);
    8000397c:	8526                	mv	a0,s1
    8000397e:	00003097          	auipc	ra,0x3
    80003982:	c62080e7          	jalr	-926(ra) # 800065e0 <release>
}
    80003986:	70e2                	ld	ra,56(sp)
    80003988:	7442                	ld	s0,48(sp)
    8000398a:	74a2                	ld	s1,40(sp)
    8000398c:	7902                	ld	s2,32(sp)
    8000398e:	69e2                	ld	s3,24(sp)
    80003990:	6a42                	ld	s4,16(sp)
    80003992:	6aa2                	ld	s5,8(sp)
    80003994:	6121                	addi	sp,sp,64
    80003996:	8082                	ret
    panic("log.committing");
    80003998:	00005517          	auipc	a0,0x5
    8000399c:	ce850513          	addi	a0,a0,-792 # 80008680 <syscalls+0x228>
    800039a0:	00002097          	auipc	ra,0x2
    800039a4:	642080e7          	jalr	1602(ra) # 80005fe2 <panic>
    wakeup(&log);
    800039a8:	00015497          	auipc	s1,0x15
    800039ac:	1f848493          	addi	s1,s1,504 # 80018ba0 <log>
    800039b0:	8526                	mv	a0,s1
    800039b2:	ffffe097          	auipc	ra,0xffffe
    800039b6:	e44080e7          	jalr	-444(ra) # 800017f6 <wakeup>
  release(&log.lock);
    800039ba:	8526                	mv	a0,s1
    800039bc:	00003097          	auipc	ra,0x3
    800039c0:	c24080e7          	jalr	-988(ra) # 800065e0 <release>
  if(do_commit){
    800039c4:	b7c9                	j	80003986 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800039c6:	00015a97          	auipc	s5,0x15
    800039ca:	20aa8a93          	addi	s5,s5,522 # 80018bd0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800039ce:	00015a17          	auipc	s4,0x15
    800039d2:	1d2a0a13          	addi	s4,s4,466 # 80018ba0 <log>
    800039d6:	018a2583          	lw	a1,24(s4)
    800039da:	012585bb          	addw	a1,a1,s2
    800039de:	2585                	addiw	a1,a1,1
    800039e0:	028a2503          	lw	a0,40(s4)
    800039e4:	fffff097          	auipc	ra,0xfffff
    800039e8:	cca080e7          	jalr	-822(ra) # 800026ae <bread>
    800039ec:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800039ee:	000aa583          	lw	a1,0(s5)
    800039f2:	028a2503          	lw	a0,40(s4)
    800039f6:	fffff097          	auipc	ra,0xfffff
    800039fa:	cb8080e7          	jalr	-840(ra) # 800026ae <bread>
    800039fe:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003a00:	40000613          	li	a2,1024
    80003a04:	05850593          	addi	a1,a0,88
    80003a08:	05848513          	addi	a0,s1,88
    80003a0c:	ffffc097          	auipc	ra,0xffffc
    80003a10:	7cc080e7          	jalr	1996(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    80003a14:	8526                	mv	a0,s1
    80003a16:	fffff097          	auipc	ra,0xfffff
    80003a1a:	d8a080e7          	jalr	-630(ra) # 800027a0 <bwrite>
    brelse(from);
    80003a1e:	854e                	mv	a0,s3
    80003a20:	fffff097          	auipc	ra,0xfffff
    80003a24:	dbe080e7          	jalr	-578(ra) # 800027de <brelse>
    brelse(to);
    80003a28:	8526                	mv	a0,s1
    80003a2a:	fffff097          	auipc	ra,0xfffff
    80003a2e:	db4080e7          	jalr	-588(ra) # 800027de <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003a32:	2905                	addiw	s2,s2,1
    80003a34:	0a91                	addi	s5,s5,4
    80003a36:	02ca2783          	lw	a5,44(s4)
    80003a3a:	f8f94ee3          	blt	s2,a5,800039d6 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003a3e:	00000097          	auipc	ra,0x0
    80003a42:	c6a080e7          	jalr	-918(ra) # 800036a8 <write_head>
    install_trans(0); // Now install writes to home locations
    80003a46:	4501                	li	a0,0
    80003a48:	00000097          	auipc	ra,0x0
    80003a4c:	cda080e7          	jalr	-806(ra) # 80003722 <install_trans>
    log.lh.n = 0;
    80003a50:	00015797          	auipc	a5,0x15
    80003a54:	1607ae23          	sw	zero,380(a5) # 80018bcc <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003a58:	00000097          	auipc	ra,0x0
    80003a5c:	c50080e7          	jalr	-944(ra) # 800036a8 <write_head>
    80003a60:	bdf5                	j	8000395c <end_op+0x52>

0000000080003a62 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003a62:	1101                	addi	sp,sp,-32
    80003a64:	ec06                	sd	ra,24(sp)
    80003a66:	e822                	sd	s0,16(sp)
    80003a68:	e426                	sd	s1,8(sp)
    80003a6a:	e04a                	sd	s2,0(sp)
    80003a6c:	1000                	addi	s0,sp,32
    80003a6e:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003a70:	00015917          	auipc	s2,0x15
    80003a74:	13090913          	addi	s2,s2,304 # 80018ba0 <log>
    80003a78:	854a                	mv	a0,s2
    80003a7a:	00003097          	auipc	ra,0x3
    80003a7e:	ab2080e7          	jalr	-1358(ra) # 8000652c <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003a82:	02c92603          	lw	a2,44(s2)
    80003a86:	47f5                	li	a5,29
    80003a88:	06c7c563          	blt	a5,a2,80003af2 <log_write+0x90>
    80003a8c:	00015797          	auipc	a5,0x15
    80003a90:	1307a783          	lw	a5,304(a5) # 80018bbc <log+0x1c>
    80003a94:	37fd                	addiw	a5,a5,-1
    80003a96:	04f65e63          	bge	a2,a5,80003af2 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003a9a:	00015797          	auipc	a5,0x15
    80003a9e:	1267a783          	lw	a5,294(a5) # 80018bc0 <log+0x20>
    80003aa2:	06f05063          	blez	a5,80003b02 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003aa6:	4781                	li	a5,0
    80003aa8:	06c05563          	blez	a2,80003b12 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003aac:	44cc                	lw	a1,12(s1)
    80003aae:	00015717          	auipc	a4,0x15
    80003ab2:	12270713          	addi	a4,a4,290 # 80018bd0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003ab6:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003ab8:	4314                	lw	a3,0(a4)
    80003aba:	04b68c63          	beq	a3,a1,80003b12 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003abe:	2785                	addiw	a5,a5,1
    80003ac0:	0711                	addi	a4,a4,4
    80003ac2:	fef61be3          	bne	a2,a5,80003ab8 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003ac6:	0621                	addi	a2,a2,8
    80003ac8:	060a                	slli	a2,a2,0x2
    80003aca:	00015797          	auipc	a5,0x15
    80003ace:	0d678793          	addi	a5,a5,214 # 80018ba0 <log>
    80003ad2:	963e                	add	a2,a2,a5
    80003ad4:	44dc                	lw	a5,12(s1)
    80003ad6:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003ad8:	8526                	mv	a0,s1
    80003ada:	fffff097          	auipc	ra,0xfffff
    80003ade:	da2080e7          	jalr	-606(ra) # 8000287c <bpin>
    log.lh.n++;
    80003ae2:	00015717          	auipc	a4,0x15
    80003ae6:	0be70713          	addi	a4,a4,190 # 80018ba0 <log>
    80003aea:	575c                	lw	a5,44(a4)
    80003aec:	2785                	addiw	a5,a5,1
    80003aee:	d75c                	sw	a5,44(a4)
    80003af0:	a835                	j	80003b2c <log_write+0xca>
    panic("too big a transaction");
    80003af2:	00005517          	auipc	a0,0x5
    80003af6:	b9e50513          	addi	a0,a0,-1122 # 80008690 <syscalls+0x238>
    80003afa:	00002097          	auipc	ra,0x2
    80003afe:	4e8080e7          	jalr	1256(ra) # 80005fe2 <panic>
    panic("log_write outside of trans");
    80003b02:	00005517          	auipc	a0,0x5
    80003b06:	ba650513          	addi	a0,a0,-1114 # 800086a8 <syscalls+0x250>
    80003b0a:	00002097          	auipc	ra,0x2
    80003b0e:	4d8080e7          	jalr	1240(ra) # 80005fe2 <panic>
  log.lh.block[i] = b->blockno;
    80003b12:	00878713          	addi	a4,a5,8
    80003b16:	00271693          	slli	a3,a4,0x2
    80003b1a:	00015717          	auipc	a4,0x15
    80003b1e:	08670713          	addi	a4,a4,134 # 80018ba0 <log>
    80003b22:	9736                	add	a4,a4,a3
    80003b24:	44d4                	lw	a3,12(s1)
    80003b26:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003b28:	faf608e3          	beq	a2,a5,80003ad8 <log_write+0x76>
  }
  release(&log.lock);
    80003b2c:	00015517          	auipc	a0,0x15
    80003b30:	07450513          	addi	a0,a0,116 # 80018ba0 <log>
    80003b34:	00003097          	auipc	ra,0x3
    80003b38:	aac080e7          	jalr	-1364(ra) # 800065e0 <release>
}
    80003b3c:	60e2                	ld	ra,24(sp)
    80003b3e:	6442                	ld	s0,16(sp)
    80003b40:	64a2                	ld	s1,8(sp)
    80003b42:	6902                	ld	s2,0(sp)
    80003b44:	6105                	addi	sp,sp,32
    80003b46:	8082                	ret

0000000080003b48 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003b48:	1101                	addi	sp,sp,-32
    80003b4a:	ec06                	sd	ra,24(sp)
    80003b4c:	e822                	sd	s0,16(sp)
    80003b4e:	e426                	sd	s1,8(sp)
    80003b50:	e04a                	sd	s2,0(sp)
    80003b52:	1000                	addi	s0,sp,32
    80003b54:	84aa                	mv	s1,a0
    80003b56:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003b58:	00005597          	auipc	a1,0x5
    80003b5c:	b7058593          	addi	a1,a1,-1168 # 800086c8 <syscalls+0x270>
    80003b60:	0521                	addi	a0,a0,8
    80003b62:	00003097          	auipc	ra,0x3
    80003b66:	93a080e7          	jalr	-1734(ra) # 8000649c <initlock>
  lk->name = name;
    80003b6a:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003b6e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003b72:	0204a423          	sw	zero,40(s1)
}
    80003b76:	60e2                	ld	ra,24(sp)
    80003b78:	6442                	ld	s0,16(sp)
    80003b7a:	64a2                	ld	s1,8(sp)
    80003b7c:	6902                	ld	s2,0(sp)
    80003b7e:	6105                	addi	sp,sp,32
    80003b80:	8082                	ret

0000000080003b82 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003b82:	1101                	addi	sp,sp,-32
    80003b84:	ec06                	sd	ra,24(sp)
    80003b86:	e822                	sd	s0,16(sp)
    80003b88:	e426                	sd	s1,8(sp)
    80003b8a:	e04a                	sd	s2,0(sp)
    80003b8c:	1000                	addi	s0,sp,32
    80003b8e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003b90:	00850913          	addi	s2,a0,8
    80003b94:	854a                	mv	a0,s2
    80003b96:	00003097          	auipc	ra,0x3
    80003b9a:	996080e7          	jalr	-1642(ra) # 8000652c <acquire>
  while (lk->locked) {
    80003b9e:	409c                	lw	a5,0(s1)
    80003ba0:	cb89                	beqz	a5,80003bb2 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003ba2:	85ca                	mv	a1,s2
    80003ba4:	8526                	mv	a0,s1
    80003ba6:	ffffe097          	auipc	ra,0xffffe
    80003baa:	bec080e7          	jalr	-1044(ra) # 80001792 <sleep>
  while (lk->locked) {
    80003bae:	409c                	lw	a5,0(s1)
    80003bb0:	fbed                	bnez	a5,80003ba2 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003bb2:	4785                	li	a5,1
    80003bb4:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003bb6:	ffffd097          	auipc	ra,0xffffd
    80003bba:	49c080e7          	jalr	1180(ra) # 80001052 <myproc>
    80003bbe:	591c                	lw	a5,48(a0)
    80003bc0:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003bc2:	854a                	mv	a0,s2
    80003bc4:	00003097          	auipc	ra,0x3
    80003bc8:	a1c080e7          	jalr	-1508(ra) # 800065e0 <release>
}
    80003bcc:	60e2                	ld	ra,24(sp)
    80003bce:	6442                	ld	s0,16(sp)
    80003bd0:	64a2                	ld	s1,8(sp)
    80003bd2:	6902                	ld	s2,0(sp)
    80003bd4:	6105                	addi	sp,sp,32
    80003bd6:	8082                	ret

0000000080003bd8 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003bd8:	1101                	addi	sp,sp,-32
    80003bda:	ec06                	sd	ra,24(sp)
    80003bdc:	e822                	sd	s0,16(sp)
    80003bde:	e426                	sd	s1,8(sp)
    80003be0:	e04a                	sd	s2,0(sp)
    80003be2:	1000                	addi	s0,sp,32
    80003be4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003be6:	00850913          	addi	s2,a0,8
    80003bea:	854a                	mv	a0,s2
    80003bec:	00003097          	auipc	ra,0x3
    80003bf0:	940080e7          	jalr	-1728(ra) # 8000652c <acquire>
  lk->locked = 0;
    80003bf4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003bf8:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003bfc:	8526                	mv	a0,s1
    80003bfe:	ffffe097          	auipc	ra,0xffffe
    80003c02:	bf8080e7          	jalr	-1032(ra) # 800017f6 <wakeup>
  release(&lk->lk);
    80003c06:	854a                	mv	a0,s2
    80003c08:	00003097          	auipc	ra,0x3
    80003c0c:	9d8080e7          	jalr	-1576(ra) # 800065e0 <release>
}
    80003c10:	60e2                	ld	ra,24(sp)
    80003c12:	6442                	ld	s0,16(sp)
    80003c14:	64a2                	ld	s1,8(sp)
    80003c16:	6902                	ld	s2,0(sp)
    80003c18:	6105                	addi	sp,sp,32
    80003c1a:	8082                	ret

0000000080003c1c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003c1c:	7179                	addi	sp,sp,-48
    80003c1e:	f406                	sd	ra,40(sp)
    80003c20:	f022                	sd	s0,32(sp)
    80003c22:	ec26                	sd	s1,24(sp)
    80003c24:	e84a                	sd	s2,16(sp)
    80003c26:	e44e                	sd	s3,8(sp)
    80003c28:	1800                	addi	s0,sp,48
    80003c2a:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003c2c:	00850913          	addi	s2,a0,8
    80003c30:	854a                	mv	a0,s2
    80003c32:	00003097          	auipc	ra,0x3
    80003c36:	8fa080e7          	jalr	-1798(ra) # 8000652c <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003c3a:	409c                	lw	a5,0(s1)
    80003c3c:	ef99                	bnez	a5,80003c5a <holdingsleep+0x3e>
    80003c3e:	4481                	li	s1,0
  release(&lk->lk);
    80003c40:	854a                	mv	a0,s2
    80003c42:	00003097          	auipc	ra,0x3
    80003c46:	99e080e7          	jalr	-1634(ra) # 800065e0 <release>
  return r;
}
    80003c4a:	8526                	mv	a0,s1
    80003c4c:	70a2                	ld	ra,40(sp)
    80003c4e:	7402                	ld	s0,32(sp)
    80003c50:	64e2                	ld	s1,24(sp)
    80003c52:	6942                	ld	s2,16(sp)
    80003c54:	69a2                	ld	s3,8(sp)
    80003c56:	6145                	addi	sp,sp,48
    80003c58:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003c5a:	0284a983          	lw	s3,40(s1)
    80003c5e:	ffffd097          	auipc	ra,0xffffd
    80003c62:	3f4080e7          	jalr	1012(ra) # 80001052 <myproc>
    80003c66:	5904                	lw	s1,48(a0)
    80003c68:	413484b3          	sub	s1,s1,s3
    80003c6c:	0014b493          	seqz	s1,s1
    80003c70:	bfc1                	j	80003c40 <holdingsleep+0x24>

0000000080003c72 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003c72:	1141                	addi	sp,sp,-16
    80003c74:	e406                	sd	ra,8(sp)
    80003c76:	e022                	sd	s0,0(sp)
    80003c78:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003c7a:	00005597          	auipc	a1,0x5
    80003c7e:	a5e58593          	addi	a1,a1,-1442 # 800086d8 <syscalls+0x280>
    80003c82:	00015517          	auipc	a0,0x15
    80003c86:	06650513          	addi	a0,a0,102 # 80018ce8 <ftable>
    80003c8a:	00003097          	auipc	ra,0x3
    80003c8e:	812080e7          	jalr	-2030(ra) # 8000649c <initlock>
}
    80003c92:	60a2                	ld	ra,8(sp)
    80003c94:	6402                	ld	s0,0(sp)
    80003c96:	0141                	addi	sp,sp,16
    80003c98:	8082                	ret

0000000080003c9a <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003c9a:	1101                	addi	sp,sp,-32
    80003c9c:	ec06                	sd	ra,24(sp)
    80003c9e:	e822                	sd	s0,16(sp)
    80003ca0:	e426                	sd	s1,8(sp)
    80003ca2:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003ca4:	00015517          	auipc	a0,0x15
    80003ca8:	04450513          	addi	a0,a0,68 # 80018ce8 <ftable>
    80003cac:	00003097          	auipc	ra,0x3
    80003cb0:	880080e7          	jalr	-1920(ra) # 8000652c <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003cb4:	00015497          	auipc	s1,0x15
    80003cb8:	04c48493          	addi	s1,s1,76 # 80018d00 <ftable+0x18>
    80003cbc:	00016717          	auipc	a4,0x16
    80003cc0:	fe470713          	addi	a4,a4,-28 # 80019ca0 <disk>
    if(f->ref == 0){
    80003cc4:	40dc                	lw	a5,4(s1)
    80003cc6:	cf99                	beqz	a5,80003ce4 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003cc8:	02848493          	addi	s1,s1,40
    80003ccc:	fee49ce3          	bne	s1,a4,80003cc4 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003cd0:	00015517          	auipc	a0,0x15
    80003cd4:	01850513          	addi	a0,a0,24 # 80018ce8 <ftable>
    80003cd8:	00003097          	auipc	ra,0x3
    80003cdc:	908080e7          	jalr	-1784(ra) # 800065e0 <release>
  return 0;
    80003ce0:	4481                	li	s1,0
    80003ce2:	a819                	j	80003cf8 <filealloc+0x5e>
      f->ref = 1;
    80003ce4:	4785                	li	a5,1
    80003ce6:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003ce8:	00015517          	auipc	a0,0x15
    80003cec:	00050513          	mv	a0,a0
    80003cf0:	00003097          	auipc	ra,0x3
    80003cf4:	8f0080e7          	jalr	-1808(ra) # 800065e0 <release>
}
    80003cf8:	8526                	mv	a0,s1
    80003cfa:	60e2                	ld	ra,24(sp)
    80003cfc:	6442                	ld	s0,16(sp)
    80003cfe:	64a2                	ld	s1,8(sp)
    80003d00:	6105                	addi	sp,sp,32
    80003d02:	8082                	ret

0000000080003d04 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003d04:	1101                	addi	sp,sp,-32
    80003d06:	ec06                	sd	ra,24(sp)
    80003d08:	e822                	sd	s0,16(sp)
    80003d0a:	e426                	sd	s1,8(sp)
    80003d0c:	1000                	addi	s0,sp,32
    80003d0e:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003d10:	00015517          	auipc	a0,0x15
    80003d14:	fd850513          	addi	a0,a0,-40 # 80018ce8 <ftable>
    80003d18:	00003097          	auipc	ra,0x3
    80003d1c:	814080e7          	jalr	-2028(ra) # 8000652c <acquire>
  if(f->ref < 1)
    80003d20:	40dc                	lw	a5,4(s1)
    80003d22:	02f05263          	blez	a5,80003d46 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003d26:	2785                	addiw	a5,a5,1
    80003d28:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003d2a:	00015517          	auipc	a0,0x15
    80003d2e:	fbe50513          	addi	a0,a0,-66 # 80018ce8 <ftable>
    80003d32:	00003097          	auipc	ra,0x3
    80003d36:	8ae080e7          	jalr	-1874(ra) # 800065e0 <release>
  return f;
}
    80003d3a:	8526                	mv	a0,s1
    80003d3c:	60e2                	ld	ra,24(sp)
    80003d3e:	6442                	ld	s0,16(sp)
    80003d40:	64a2                	ld	s1,8(sp)
    80003d42:	6105                	addi	sp,sp,32
    80003d44:	8082                	ret
    panic("filedup");
    80003d46:	00005517          	auipc	a0,0x5
    80003d4a:	99a50513          	addi	a0,a0,-1638 # 800086e0 <syscalls+0x288>
    80003d4e:	00002097          	auipc	ra,0x2
    80003d52:	294080e7          	jalr	660(ra) # 80005fe2 <panic>

0000000080003d56 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003d56:	7139                	addi	sp,sp,-64
    80003d58:	fc06                	sd	ra,56(sp)
    80003d5a:	f822                	sd	s0,48(sp)
    80003d5c:	f426                	sd	s1,40(sp)
    80003d5e:	f04a                	sd	s2,32(sp)
    80003d60:	ec4e                	sd	s3,24(sp)
    80003d62:	e852                	sd	s4,16(sp)
    80003d64:	e456                	sd	s5,8(sp)
    80003d66:	0080                	addi	s0,sp,64
    80003d68:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003d6a:	00015517          	auipc	a0,0x15
    80003d6e:	f7e50513          	addi	a0,a0,-130 # 80018ce8 <ftable>
    80003d72:	00002097          	auipc	ra,0x2
    80003d76:	7ba080e7          	jalr	1978(ra) # 8000652c <acquire>
  if(f->ref < 1)
    80003d7a:	40dc                	lw	a5,4(s1)
    80003d7c:	06f05163          	blez	a5,80003dde <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003d80:	37fd                	addiw	a5,a5,-1
    80003d82:	0007871b          	sext.w	a4,a5
    80003d86:	c0dc                	sw	a5,4(s1)
    80003d88:	06e04363          	bgtz	a4,80003dee <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003d8c:	0004a903          	lw	s2,0(s1)
    80003d90:	0094ca83          	lbu	s5,9(s1)
    80003d94:	0104ba03          	ld	s4,16(s1)
    80003d98:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003d9c:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003da0:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003da4:	00015517          	auipc	a0,0x15
    80003da8:	f4450513          	addi	a0,a0,-188 # 80018ce8 <ftable>
    80003dac:	00003097          	auipc	ra,0x3
    80003db0:	834080e7          	jalr	-1996(ra) # 800065e0 <release>

  if(ff.type == FD_PIPE){
    80003db4:	4785                	li	a5,1
    80003db6:	04f90d63          	beq	s2,a5,80003e10 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003dba:	3979                	addiw	s2,s2,-2
    80003dbc:	4785                	li	a5,1
    80003dbe:	0527e063          	bltu	a5,s2,80003dfe <fileclose+0xa8>
    begin_op();
    80003dc2:	00000097          	auipc	ra,0x0
    80003dc6:	ac8080e7          	jalr	-1336(ra) # 8000388a <begin_op>
    iput(ff.ip);
    80003dca:	854e                	mv	a0,s3
    80003dcc:	fffff097          	auipc	ra,0xfffff
    80003dd0:	2b6080e7          	jalr	694(ra) # 80003082 <iput>
    end_op();
    80003dd4:	00000097          	auipc	ra,0x0
    80003dd8:	b36080e7          	jalr	-1226(ra) # 8000390a <end_op>
    80003ddc:	a00d                	j	80003dfe <fileclose+0xa8>
    panic("fileclose");
    80003dde:	00005517          	auipc	a0,0x5
    80003de2:	90a50513          	addi	a0,a0,-1782 # 800086e8 <syscalls+0x290>
    80003de6:	00002097          	auipc	ra,0x2
    80003dea:	1fc080e7          	jalr	508(ra) # 80005fe2 <panic>
    release(&ftable.lock);
    80003dee:	00015517          	auipc	a0,0x15
    80003df2:	efa50513          	addi	a0,a0,-262 # 80018ce8 <ftable>
    80003df6:	00002097          	auipc	ra,0x2
    80003dfa:	7ea080e7          	jalr	2026(ra) # 800065e0 <release>
  }
}
    80003dfe:	70e2                	ld	ra,56(sp)
    80003e00:	7442                	ld	s0,48(sp)
    80003e02:	74a2                	ld	s1,40(sp)
    80003e04:	7902                	ld	s2,32(sp)
    80003e06:	69e2                	ld	s3,24(sp)
    80003e08:	6a42                	ld	s4,16(sp)
    80003e0a:	6aa2                	ld	s5,8(sp)
    80003e0c:	6121                	addi	sp,sp,64
    80003e0e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003e10:	85d6                	mv	a1,s5
    80003e12:	8552                	mv	a0,s4
    80003e14:	00000097          	auipc	ra,0x0
    80003e18:	34c080e7          	jalr	844(ra) # 80004160 <pipeclose>
    80003e1c:	b7cd                	j	80003dfe <fileclose+0xa8>

0000000080003e1e <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003e1e:	715d                	addi	sp,sp,-80
    80003e20:	e486                	sd	ra,72(sp)
    80003e22:	e0a2                	sd	s0,64(sp)
    80003e24:	fc26                	sd	s1,56(sp)
    80003e26:	f84a                	sd	s2,48(sp)
    80003e28:	f44e                	sd	s3,40(sp)
    80003e2a:	0880                	addi	s0,sp,80
    80003e2c:	84aa                	mv	s1,a0
    80003e2e:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003e30:	ffffd097          	auipc	ra,0xffffd
    80003e34:	222080e7          	jalr	546(ra) # 80001052 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003e38:	409c                	lw	a5,0(s1)
    80003e3a:	37f9                	addiw	a5,a5,-2
    80003e3c:	4705                	li	a4,1
    80003e3e:	04f76763          	bltu	a4,a5,80003e8c <filestat+0x6e>
    80003e42:	892a                	mv	s2,a0
    ilock(f->ip);
    80003e44:	6c88                	ld	a0,24(s1)
    80003e46:	fffff097          	auipc	ra,0xfffff
    80003e4a:	082080e7          	jalr	130(ra) # 80002ec8 <ilock>
    stati(f->ip, &st);
    80003e4e:	fb840593          	addi	a1,s0,-72
    80003e52:	6c88                	ld	a0,24(s1)
    80003e54:	fffff097          	auipc	ra,0xfffff
    80003e58:	2fe080e7          	jalr	766(ra) # 80003152 <stati>
    iunlock(f->ip);
    80003e5c:	6c88                	ld	a0,24(s1)
    80003e5e:	fffff097          	auipc	ra,0xfffff
    80003e62:	12c080e7          	jalr	300(ra) # 80002f8a <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003e66:	46e1                	li	a3,24
    80003e68:	fb840613          	addi	a2,s0,-72
    80003e6c:	85ce                	mv	a1,s3
    80003e6e:	05093503          	ld	a0,80(s2)
    80003e72:	ffffd097          	auipc	ra,0xffffd
    80003e76:	cc8080e7          	jalr	-824(ra) # 80000b3a <copyout>
    80003e7a:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003e7e:	60a6                	ld	ra,72(sp)
    80003e80:	6406                	ld	s0,64(sp)
    80003e82:	74e2                	ld	s1,56(sp)
    80003e84:	7942                	ld	s2,48(sp)
    80003e86:	79a2                	ld	s3,40(sp)
    80003e88:	6161                	addi	sp,sp,80
    80003e8a:	8082                	ret
  return -1;
    80003e8c:	557d                	li	a0,-1
    80003e8e:	bfc5                	j	80003e7e <filestat+0x60>

0000000080003e90 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003e90:	7179                	addi	sp,sp,-48
    80003e92:	f406                	sd	ra,40(sp)
    80003e94:	f022                	sd	s0,32(sp)
    80003e96:	ec26                	sd	s1,24(sp)
    80003e98:	e84a                	sd	s2,16(sp)
    80003e9a:	e44e                	sd	s3,8(sp)
    80003e9c:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003e9e:	00854783          	lbu	a5,8(a0)
    80003ea2:	c3d5                	beqz	a5,80003f46 <fileread+0xb6>
    80003ea4:	84aa                	mv	s1,a0
    80003ea6:	89ae                	mv	s3,a1
    80003ea8:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003eaa:	411c                	lw	a5,0(a0)
    80003eac:	4705                	li	a4,1
    80003eae:	04e78963          	beq	a5,a4,80003f00 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003eb2:	470d                	li	a4,3
    80003eb4:	04e78d63          	beq	a5,a4,80003f0e <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003eb8:	4709                	li	a4,2
    80003eba:	06e79e63          	bne	a5,a4,80003f36 <fileread+0xa6>
    ilock(f->ip);
    80003ebe:	6d08                	ld	a0,24(a0)
    80003ec0:	fffff097          	auipc	ra,0xfffff
    80003ec4:	008080e7          	jalr	8(ra) # 80002ec8 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003ec8:	874a                	mv	a4,s2
    80003eca:	5094                	lw	a3,32(s1)
    80003ecc:	864e                	mv	a2,s3
    80003ece:	4585                	li	a1,1
    80003ed0:	6c88                	ld	a0,24(s1)
    80003ed2:	fffff097          	auipc	ra,0xfffff
    80003ed6:	2aa080e7          	jalr	682(ra) # 8000317c <readi>
    80003eda:	892a                	mv	s2,a0
    80003edc:	00a05563          	blez	a0,80003ee6 <fileread+0x56>
      f->off += r;
    80003ee0:	509c                	lw	a5,32(s1)
    80003ee2:	9fa9                	addw	a5,a5,a0
    80003ee4:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003ee6:	6c88                	ld	a0,24(s1)
    80003ee8:	fffff097          	auipc	ra,0xfffff
    80003eec:	0a2080e7          	jalr	162(ra) # 80002f8a <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003ef0:	854a                	mv	a0,s2
    80003ef2:	70a2                	ld	ra,40(sp)
    80003ef4:	7402                	ld	s0,32(sp)
    80003ef6:	64e2                	ld	s1,24(sp)
    80003ef8:	6942                	ld	s2,16(sp)
    80003efa:	69a2                	ld	s3,8(sp)
    80003efc:	6145                	addi	sp,sp,48
    80003efe:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003f00:	6908                	ld	a0,16(a0)
    80003f02:	00000097          	auipc	ra,0x0
    80003f06:	3ce080e7          	jalr	974(ra) # 800042d0 <piperead>
    80003f0a:	892a                	mv	s2,a0
    80003f0c:	b7d5                	j	80003ef0 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003f0e:	02451783          	lh	a5,36(a0)
    80003f12:	03079693          	slli	a3,a5,0x30
    80003f16:	92c1                	srli	a3,a3,0x30
    80003f18:	4725                	li	a4,9
    80003f1a:	02d76863          	bltu	a4,a3,80003f4a <fileread+0xba>
    80003f1e:	0792                	slli	a5,a5,0x4
    80003f20:	00015717          	auipc	a4,0x15
    80003f24:	d2870713          	addi	a4,a4,-728 # 80018c48 <devsw>
    80003f28:	97ba                	add	a5,a5,a4
    80003f2a:	639c                	ld	a5,0(a5)
    80003f2c:	c38d                	beqz	a5,80003f4e <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003f2e:	4505                	li	a0,1
    80003f30:	9782                	jalr	a5
    80003f32:	892a                	mv	s2,a0
    80003f34:	bf75                	j	80003ef0 <fileread+0x60>
    panic("fileread");
    80003f36:	00004517          	auipc	a0,0x4
    80003f3a:	7c250513          	addi	a0,a0,1986 # 800086f8 <syscalls+0x2a0>
    80003f3e:	00002097          	auipc	ra,0x2
    80003f42:	0a4080e7          	jalr	164(ra) # 80005fe2 <panic>
    return -1;
    80003f46:	597d                	li	s2,-1
    80003f48:	b765                	j	80003ef0 <fileread+0x60>
      return -1;
    80003f4a:	597d                	li	s2,-1
    80003f4c:	b755                	j	80003ef0 <fileread+0x60>
    80003f4e:	597d                	li	s2,-1
    80003f50:	b745                	j	80003ef0 <fileread+0x60>

0000000080003f52 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003f52:	715d                	addi	sp,sp,-80
    80003f54:	e486                	sd	ra,72(sp)
    80003f56:	e0a2                	sd	s0,64(sp)
    80003f58:	fc26                	sd	s1,56(sp)
    80003f5a:	f84a                	sd	s2,48(sp)
    80003f5c:	f44e                	sd	s3,40(sp)
    80003f5e:	f052                	sd	s4,32(sp)
    80003f60:	ec56                	sd	s5,24(sp)
    80003f62:	e85a                	sd	s6,16(sp)
    80003f64:	e45e                	sd	s7,8(sp)
    80003f66:	e062                	sd	s8,0(sp)
    80003f68:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003f6a:	00954783          	lbu	a5,9(a0)
    80003f6e:	10078663          	beqz	a5,8000407a <filewrite+0x128>
    80003f72:	892a                	mv	s2,a0
    80003f74:	8aae                	mv	s5,a1
    80003f76:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003f78:	411c                	lw	a5,0(a0)
    80003f7a:	4705                	li	a4,1
    80003f7c:	02e78263          	beq	a5,a4,80003fa0 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003f80:	470d                	li	a4,3
    80003f82:	02e78663          	beq	a5,a4,80003fae <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003f86:	4709                	li	a4,2
    80003f88:	0ee79163          	bne	a5,a4,8000406a <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003f8c:	0ac05d63          	blez	a2,80004046 <filewrite+0xf4>
    int i = 0;
    80003f90:	4981                	li	s3,0
    80003f92:	6b05                	lui	s6,0x1
    80003f94:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003f98:	6b85                	lui	s7,0x1
    80003f9a:	c00b8b9b          	addiw	s7,s7,-1024
    80003f9e:	a861                	j	80004036 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003fa0:	6908                	ld	a0,16(a0)
    80003fa2:	00000097          	auipc	ra,0x0
    80003fa6:	22e080e7          	jalr	558(ra) # 800041d0 <pipewrite>
    80003faa:	8a2a                	mv	s4,a0
    80003fac:	a045                	j	8000404c <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003fae:	02451783          	lh	a5,36(a0)
    80003fb2:	03079693          	slli	a3,a5,0x30
    80003fb6:	92c1                	srli	a3,a3,0x30
    80003fb8:	4725                	li	a4,9
    80003fba:	0cd76263          	bltu	a4,a3,8000407e <filewrite+0x12c>
    80003fbe:	0792                	slli	a5,a5,0x4
    80003fc0:	00015717          	auipc	a4,0x15
    80003fc4:	c8870713          	addi	a4,a4,-888 # 80018c48 <devsw>
    80003fc8:	97ba                	add	a5,a5,a4
    80003fca:	679c                	ld	a5,8(a5)
    80003fcc:	cbdd                	beqz	a5,80004082 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003fce:	4505                	li	a0,1
    80003fd0:	9782                	jalr	a5
    80003fd2:	8a2a                	mv	s4,a0
    80003fd4:	a8a5                	j	8000404c <filewrite+0xfa>
    80003fd6:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003fda:	00000097          	auipc	ra,0x0
    80003fde:	8b0080e7          	jalr	-1872(ra) # 8000388a <begin_op>
      ilock(f->ip);
    80003fe2:	01893503          	ld	a0,24(s2)
    80003fe6:	fffff097          	auipc	ra,0xfffff
    80003fea:	ee2080e7          	jalr	-286(ra) # 80002ec8 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003fee:	8762                	mv	a4,s8
    80003ff0:	02092683          	lw	a3,32(s2)
    80003ff4:	01598633          	add	a2,s3,s5
    80003ff8:	4585                	li	a1,1
    80003ffa:	01893503          	ld	a0,24(s2)
    80003ffe:	fffff097          	auipc	ra,0xfffff
    80004002:	276080e7          	jalr	630(ra) # 80003274 <writei>
    80004006:	84aa                	mv	s1,a0
    80004008:	00a05763          	blez	a0,80004016 <filewrite+0xc4>
        f->off += r;
    8000400c:	02092783          	lw	a5,32(s2)
    80004010:	9fa9                	addw	a5,a5,a0
    80004012:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004016:	01893503          	ld	a0,24(s2)
    8000401a:	fffff097          	auipc	ra,0xfffff
    8000401e:	f70080e7          	jalr	-144(ra) # 80002f8a <iunlock>
      end_op();
    80004022:	00000097          	auipc	ra,0x0
    80004026:	8e8080e7          	jalr	-1816(ra) # 8000390a <end_op>

      if(r != n1){
    8000402a:	009c1f63          	bne	s8,s1,80004048 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    8000402e:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004032:	0149db63          	bge	s3,s4,80004048 <filewrite+0xf6>
      int n1 = n - i;
    80004036:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    8000403a:	84be                	mv	s1,a5
    8000403c:	2781                	sext.w	a5,a5
    8000403e:	f8fb5ce3          	bge	s6,a5,80003fd6 <filewrite+0x84>
    80004042:	84de                	mv	s1,s7
    80004044:	bf49                	j	80003fd6 <filewrite+0x84>
    int i = 0;
    80004046:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80004048:	013a1f63          	bne	s4,s3,80004066 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000404c:	8552                	mv	a0,s4
    8000404e:	60a6                	ld	ra,72(sp)
    80004050:	6406                	ld	s0,64(sp)
    80004052:	74e2                	ld	s1,56(sp)
    80004054:	7942                	ld	s2,48(sp)
    80004056:	79a2                	ld	s3,40(sp)
    80004058:	7a02                	ld	s4,32(sp)
    8000405a:	6ae2                	ld	s5,24(sp)
    8000405c:	6b42                	ld	s6,16(sp)
    8000405e:	6ba2                	ld	s7,8(sp)
    80004060:	6c02                	ld	s8,0(sp)
    80004062:	6161                	addi	sp,sp,80
    80004064:	8082                	ret
    ret = (i == n ? n : -1);
    80004066:	5a7d                	li	s4,-1
    80004068:	b7d5                	j	8000404c <filewrite+0xfa>
    panic("filewrite");
    8000406a:	00004517          	auipc	a0,0x4
    8000406e:	69e50513          	addi	a0,a0,1694 # 80008708 <syscalls+0x2b0>
    80004072:	00002097          	auipc	ra,0x2
    80004076:	f70080e7          	jalr	-144(ra) # 80005fe2 <panic>
    return -1;
    8000407a:	5a7d                	li	s4,-1
    8000407c:	bfc1                	j	8000404c <filewrite+0xfa>
      return -1;
    8000407e:	5a7d                	li	s4,-1
    80004080:	b7f1                	j	8000404c <filewrite+0xfa>
    80004082:	5a7d                	li	s4,-1
    80004084:	b7e1                	j	8000404c <filewrite+0xfa>

0000000080004086 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004086:	7179                	addi	sp,sp,-48
    80004088:	f406                	sd	ra,40(sp)
    8000408a:	f022                	sd	s0,32(sp)
    8000408c:	ec26                	sd	s1,24(sp)
    8000408e:	e84a                	sd	s2,16(sp)
    80004090:	e44e                	sd	s3,8(sp)
    80004092:	e052                	sd	s4,0(sp)
    80004094:	1800                	addi	s0,sp,48
    80004096:	84aa                	mv	s1,a0
    80004098:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000409a:	0005b023          	sd	zero,0(a1)
    8000409e:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800040a2:	00000097          	auipc	ra,0x0
    800040a6:	bf8080e7          	jalr	-1032(ra) # 80003c9a <filealloc>
    800040aa:	e088                	sd	a0,0(s1)
    800040ac:	c551                	beqz	a0,80004138 <pipealloc+0xb2>
    800040ae:	00000097          	auipc	ra,0x0
    800040b2:	bec080e7          	jalr	-1044(ra) # 80003c9a <filealloc>
    800040b6:	00aa3023          	sd	a0,0(s4)
    800040ba:	c92d                	beqz	a0,8000412c <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800040bc:	ffffc097          	auipc	ra,0xffffc
    800040c0:	05c080e7          	jalr	92(ra) # 80000118 <kalloc>
    800040c4:	892a                	mv	s2,a0
    800040c6:	c125                	beqz	a0,80004126 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    800040c8:	4985                	li	s3,1
    800040ca:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800040ce:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800040d2:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800040d6:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800040da:	00004597          	auipc	a1,0x4
    800040de:	63e58593          	addi	a1,a1,1598 # 80008718 <syscalls+0x2c0>
    800040e2:	00002097          	auipc	ra,0x2
    800040e6:	3ba080e7          	jalr	954(ra) # 8000649c <initlock>
  (*f0)->type = FD_PIPE;
    800040ea:	609c                	ld	a5,0(s1)
    800040ec:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800040f0:	609c                	ld	a5,0(s1)
    800040f2:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800040f6:	609c                	ld	a5,0(s1)
    800040f8:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800040fc:	609c                	ld	a5,0(s1)
    800040fe:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004102:	000a3783          	ld	a5,0(s4)
    80004106:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000410a:	000a3783          	ld	a5,0(s4)
    8000410e:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004112:	000a3783          	ld	a5,0(s4)
    80004116:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000411a:	000a3783          	ld	a5,0(s4)
    8000411e:	0127b823          	sd	s2,16(a5)
  return 0;
    80004122:	4501                	li	a0,0
    80004124:	a025                	j	8000414c <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004126:	6088                	ld	a0,0(s1)
    80004128:	e501                	bnez	a0,80004130 <pipealloc+0xaa>
    8000412a:	a039                	j	80004138 <pipealloc+0xb2>
    8000412c:	6088                	ld	a0,0(s1)
    8000412e:	c51d                	beqz	a0,8000415c <pipealloc+0xd6>
    fileclose(*f0);
    80004130:	00000097          	auipc	ra,0x0
    80004134:	c26080e7          	jalr	-986(ra) # 80003d56 <fileclose>
  if(*f1)
    80004138:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000413c:	557d                	li	a0,-1
  if(*f1)
    8000413e:	c799                	beqz	a5,8000414c <pipealloc+0xc6>
    fileclose(*f1);
    80004140:	853e                	mv	a0,a5
    80004142:	00000097          	auipc	ra,0x0
    80004146:	c14080e7          	jalr	-1004(ra) # 80003d56 <fileclose>
  return -1;
    8000414a:	557d                	li	a0,-1
}
    8000414c:	70a2                	ld	ra,40(sp)
    8000414e:	7402                	ld	s0,32(sp)
    80004150:	64e2                	ld	s1,24(sp)
    80004152:	6942                	ld	s2,16(sp)
    80004154:	69a2                	ld	s3,8(sp)
    80004156:	6a02                	ld	s4,0(sp)
    80004158:	6145                	addi	sp,sp,48
    8000415a:	8082                	ret
  return -1;
    8000415c:	557d                	li	a0,-1
    8000415e:	b7fd                	j	8000414c <pipealloc+0xc6>

0000000080004160 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004160:	1101                	addi	sp,sp,-32
    80004162:	ec06                	sd	ra,24(sp)
    80004164:	e822                	sd	s0,16(sp)
    80004166:	e426                	sd	s1,8(sp)
    80004168:	e04a                	sd	s2,0(sp)
    8000416a:	1000                	addi	s0,sp,32
    8000416c:	84aa                	mv	s1,a0
    8000416e:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004170:	00002097          	auipc	ra,0x2
    80004174:	3bc080e7          	jalr	956(ra) # 8000652c <acquire>
  if(writable){
    80004178:	02090d63          	beqz	s2,800041b2 <pipeclose+0x52>
    pi->writeopen = 0;
    8000417c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004180:	21848513          	addi	a0,s1,536
    80004184:	ffffd097          	auipc	ra,0xffffd
    80004188:	672080e7          	jalr	1650(ra) # 800017f6 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000418c:	2204b783          	ld	a5,544(s1)
    80004190:	eb95                	bnez	a5,800041c4 <pipeclose+0x64>
    release(&pi->lock);
    80004192:	8526                	mv	a0,s1
    80004194:	00002097          	auipc	ra,0x2
    80004198:	44c080e7          	jalr	1100(ra) # 800065e0 <release>
    kfree((char*)pi);
    8000419c:	8526                	mv	a0,s1
    8000419e:	ffffc097          	auipc	ra,0xffffc
    800041a2:	e7e080e7          	jalr	-386(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    800041a6:	60e2                	ld	ra,24(sp)
    800041a8:	6442                	ld	s0,16(sp)
    800041aa:	64a2                	ld	s1,8(sp)
    800041ac:	6902                	ld	s2,0(sp)
    800041ae:	6105                	addi	sp,sp,32
    800041b0:	8082                	ret
    pi->readopen = 0;
    800041b2:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800041b6:	21c48513          	addi	a0,s1,540
    800041ba:	ffffd097          	auipc	ra,0xffffd
    800041be:	63c080e7          	jalr	1596(ra) # 800017f6 <wakeup>
    800041c2:	b7e9                	j	8000418c <pipeclose+0x2c>
    release(&pi->lock);
    800041c4:	8526                	mv	a0,s1
    800041c6:	00002097          	auipc	ra,0x2
    800041ca:	41a080e7          	jalr	1050(ra) # 800065e0 <release>
}
    800041ce:	bfe1                	j	800041a6 <pipeclose+0x46>

00000000800041d0 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800041d0:	7159                	addi	sp,sp,-112
    800041d2:	f486                	sd	ra,104(sp)
    800041d4:	f0a2                	sd	s0,96(sp)
    800041d6:	eca6                	sd	s1,88(sp)
    800041d8:	e8ca                	sd	s2,80(sp)
    800041da:	e4ce                	sd	s3,72(sp)
    800041dc:	e0d2                	sd	s4,64(sp)
    800041de:	fc56                	sd	s5,56(sp)
    800041e0:	f85a                	sd	s6,48(sp)
    800041e2:	f45e                	sd	s7,40(sp)
    800041e4:	f062                	sd	s8,32(sp)
    800041e6:	ec66                	sd	s9,24(sp)
    800041e8:	1880                	addi	s0,sp,112
    800041ea:	84aa                	mv	s1,a0
    800041ec:	8aae                	mv	s5,a1
    800041ee:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800041f0:	ffffd097          	auipc	ra,0xffffd
    800041f4:	e62080e7          	jalr	-414(ra) # 80001052 <myproc>
    800041f8:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800041fa:	8526                	mv	a0,s1
    800041fc:	00002097          	auipc	ra,0x2
    80004200:	330080e7          	jalr	816(ra) # 8000652c <acquire>
  while(i < n){
    80004204:	0d405463          	blez	s4,800042cc <pipewrite+0xfc>
    80004208:	8ba6                	mv	s7,s1
  int i = 0;
    8000420a:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000420c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000420e:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004212:	21c48c13          	addi	s8,s1,540
    80004216:	a08d                	j	80004278 <pipewrite+0xa8>
      release(&pi->lock);
    80004218:	8526                	mv	a0,s1
    8000421a:	00002097          	auipc	ra,0x2
    8000421e:	3c6080e7          	jalr	966(ra) # 800065e0 <release>
      return -1;
    80004222:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004224:	854a                	mv	a0,s2
    80004226:	70a6                	ld	ra,104(sp)
    80004228:	7406                	ld	s0,96(sp)
    8000422a:	64e6                	ld	s1,88(sp)
    8000422c:	6946                	ld	s2,80(sp)
    8000422e:	69a6                	ld	s3,72(sp)
    80004230:	6a06                	ld	s4,64(sp)
    80004232:	7ae2                	ld	s5,56(sp)
    80004234:	7b42                	ld	s6,48(sp)
    80004236:	7ba2                	ld	s7,40(sp)
    80004238:	7c02                	ld	s8,32(sp)
    8000423a:	6ce2                	ld	s9,24(sp)
    8000423c:	6165                	addi	sp,sp,112
    8000423e:	8082                	ret
      wakeup(&pi->nread);
    80004240:	8566                	mv	a0,s9
    80004242:	ffffd097          	auipc	ra,0xffffd
    80004246:	5b4080e7          	jalr	1460(ra) # 800017f6 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000424a:	85de                	mv	a1,s7
    8000424c:	8562                	mv	a0,s8
    8000424e:	ffffd097          	auipc	ra,0xffffd
    80004252:	544080e7          	jalr	1348(ra) # 80001792 <sleep>
    80004256:	a839                	j	80004274 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004258:	21c4a783          	lw	a5,540(s1)
    8000425c:	0017871b          	addiw	a4,a5,1
    80004260:	20e4ae23          	sw	a4,540(s1)
    80004264:	1ff7f793          	andi	a5,a5,511
    80004268:	97a6                	add	a5,a5,s1
    8000426a:	f9f44703          	lbu	a4,-97(s0)
    8000426e:	00e78c23          	sb	a4,24(a5)
      i++;
    80004272:	2905                	addiw	s2,s2,1
  while(i < n){
    80004274:	05495063          	bge	s2,s4,800042b4 <pipewrite+0xe4>
    if(pi->readopen == 0 || killed(pr)){
    80004278:	2204a783          	lw	a5,544(s1)
    8000427c:	dfd1                	beqz	a5,80004218 <pipewrite+0x48>
    8000427e:	854e                	mv	a0,s3
    80004280:	ffffd097          	auipc	ra,0xffffd
    80004284:	7ba080e7          	jalr	1978(ra) # 80001a3a <killed>
    80004288:	f941                	bnez	a0,80004218 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000428a:	2184a783          	lw	a5,536(s1)
    8000428e:	21c4a703          	lw	a4,540(s1)
    80004292:	2007879b          	addiw	a5,a5,512
    80004296:	faf705e3          	beq	a4,a5,80004240 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000429a:	4685                	li	a3,1
    8000429c:	01590633          	add	a2,s2,s5
    800042a0:	f9f40593          	addi	a1,s0,-97
    800042a4:	0509b503          	ld	a0,80(s3)
    800042a8:	ffffd097          	auipc	ra,0xffffd
    800042ac:	952080e7          	jalr	-1710(ra) # 80000bfa <copyin>
    800042b0:	fb6514e3          	bne	a0,s6,80004258 <pipewrite+0x88>
  wakeup(&pi->nread);
    800042b4:	21848513          	addi	a0,s1,536
    800042b8:	ffffd097          	auipc	ra,0xffffd
    800042bc:	53e080e7          	jalr	1342(ra) # 800017f6 <wakeup>
  release(&pi->lock);
    800042c0:	8526                	mv	a0,s1
    800042c2:	00002097          	auipc	ra,0x2
    800042c6:	31e080e7          	jalr	798(ra) # 800065e0 <release>
  return i;
    800042ca:	bfa9                	j	80004224 <pipewrite+0x54>
  int i = 0;
    800042cc:	4901                	li	s2,0
    800042ce:	b7dd                	j	800042b4 <pipewrite+0xe4>

00000000800042d0 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800042d0:	715d                	addi	sp,sp,-80
    800042d2:	e486                	sd	ra,72(sp)
    800042d4:	e0a2                	sd	s0,64(sp)
    800042d6:	fc26                	sd	s1,56(sp)
    800042d8:	f84a                	sd	s2,48(sp)
    800042da:	f44e                	sd	s3,40(sp)
    800042dc:	f052                	sd	s4,32(sp)
    800042de:	ec56                	sd	s5,24(sp)
    800042e0:	e85a                	sd	s6,16(sp)
    800042e2:	0880                	addi	s0,sp,80
    800042e4:	84aa                	mv	s1,a0
    800042e6:	892e                	mv	s2,a1
    800042e8:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800042ea:	ffffd097          	auipc	ra,0xffffd
    800042ee:	d68080e7          	jalr	-664(ra) # 80001052 <myproc>
    800042f2:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800042f4:	8b26                	mv	s6,s1
    800042f6:	8526                	mv	a0,s1
    800042f8:	00002097          	auipc	ra,0x2
    800042fc:	234080e7          	jalr	564(ra) # 8000652c <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004300:	2184a703          	lw	a4,536(s1)
    80004304:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004308:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000430c:	02f71763          	bne	a4,a5,8000433a <piperead+0x6a>
    80004310:	2244a783          	lw	a5,548(s1)
    80004314:	c39d                	beqz	a5,8000433a <piperead+0x6a>
    if(killed(pr)){
    80004316:	8552                	mv	a0,s4
    80004318:	ffffd097          	auipc	ra,0xffffd
    8000431c:	722080e7          	jalr	1826(ra) # 80001a3a <killed>
    80004320:	e941                	bnez	a0,800043b0 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004322:	85da                	mv	a1,s6
    80004324:	854e                	mv	a0,s3
    80004326:	ffffd097          	auipc	ra,0xffffd
    8000432a:	46c080e7          	jalr	1132(ra) # 80001792 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000432e:	2184a703          	lw	a4,536(s1)
    80004332:	21c4a783          	lw	a5,540(s1)
    80004336:	fcf70de3          	beq	a4,a5,80004310 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000433a:	09505263          	blez	s5,800043be <piperead+0xee>
    8000433e:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004340:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80004342:	2184a783          	lw	a5,536(s1)
    80004346:	21c4a703          	lw	a4,540(s1)
    8000434a:	02f70d63          	beq	a4,a5,80004384 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000434e:	0017871b          	addiw	a4,a5,1
    80004352:	20e4ac23          	sw	a4,536(s1)
    80004356:	1ff7f793          	andi	a5,a5,511
    8000435a:	97a6                	add	a5,a5,s1
    8000435c:	0187c783          	lbu	a5,24(a5)
    80004360:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004364:	4685                	li	a3,1
    80004366:	fbf40613          	addi	a2,s0,-65
    8000436a:	85ca                	mv	a1,s2
    8000436c:	050a3503          	ld	a0,80(s4)
    80004370:	ffffc097          	auipc	ra,0xffffc
    80004374:	7ca080e7          	jalr	1994(ra) # 80000b3a <copyout>
    80004378:	01650663          	beq	a0,s6,80004384 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000437c:	2985                	addiw	s3,s3,1
    8000437e:	0905                	addi	s2,s2,1
    80004380:	fd3a91e3          	bne	s5,s3,80004342 <piperead+0x72>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004384:	21c48513          	addi	a0,s1,540
    80004388:	ffffd097          	auipc	ra,0xffffd
    8000438c:	46e080e7          	jalr	1134(ra) # 800017f6 <wakeup>
  release(&pi->lock);
    80004390:	8526                	mv	a0,s1
    80004392:	00002097          	auipc	ra,0x2
    80004396:	24e080e7          	jalr	590(ra) # 800065e0 <release>
  return i;
}
    8000439a:	854e                	mv	a0,s3
    8000439c:	60a6                	ld	ra,72(sp)
    8000439e:	6406                	ld	s0,64(sp)
    800043a0:	74e2                	ld	s1,56(sp)
    800043a2:	7942                	ld	s2,48(sp)
    800043a4:	79a2                	ld	s3,40(sp)
    800043a6:	7a02                	ld	s4,32(sp)
    800043a8:	6ae2                	ld	s5,24(sp)
    800043aa:	6b42                	ld	s6,16(sp)
    800043ac:	6161                	addi	sp,sp,80
    800043ae:	8082                	ret
      release(&pi->lock);
    800043b0:	8526                	mv	a0,s1
    800043b2:	00002097          	auipc	ra,0x2
    800043b6:	22e080e7          	jalr	558(ra) # 800065e0 <release>
      return -1;
    800043ba:	59fd                	li	s3,-1
    800043bc:	bff9                	j	8000439a <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800043be:	4981                	li	s3,0
    800043c0:	b7d1                	j	80004384 <piperead+0xb4>

00000000800043c2 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800043c2:	1141                	addi	sp,sp,-16
    800043c4:	e422                	sd	s0,8(sp)
    800043c6:	0800                	addi	s0,sp,16
    800043c8:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800043ca:	8905                	andi	a0,a0,1
    800043cc:	c111                	beqz	a0,800043d0 <flags2perm+0xe>
      perm = PTE_X;
    800043ce:	4521                	li	a0,8
    if(flags & 0x2)
    800043d0:	8b89                	andi	a5,a5,2
    800043d2:	c399                	beqz	a5,800043d8 <flags2perm+0x16>
      perm |= PTE_W;
    800043d4:	00456513          	ori	a0,a0,4
    return perm;
}
    800043d8:	6422                	ld	s0,8(sp)
    800043da:	0141                	addi	sp,sp,16
    800043dc:	8082                	ret

00000000800043de <exec>:

int
exec(char *path, char **argv)
{
    800043de:	df010113          	addi	sp,sp,-528
    800043e2:	20113423          	sd	ra,520(sp)
    800043e6:	20813023          	sd	s0,512(sp)
    800043ea:	ffa6                	sd	s1,504(sp)
    800043ec:	fbca                	sd	s2,496(sp)
    800043ee:	f7ce                	sd	s3,488(sp)
    800043f0:	f3d2                	sd	s4,480(sp)
    800043f2:	efd6                	sd	s5,472(sp)
    800043f4:	ebda                	sd	s6,464(sp)
    800043f6:	e7de                	sd	s7,456(sp)
    800043f8:	e3e2                	sd	s8,448(sp)
    800043fa:	ff66                	sd	s9,440(sp)
    800043fc:	fb6a                	sd	s10,432(sp)
    800043fe:	f76e                	sd	s11,424(sp)
    80004400:	0c00                	addi	s0,sp,528
    80004402:	84aa                	mv	s1,a0
    80004404:	dea43c23          	sd	a0,-520(s0)
    80004408:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000440c:	ffffd097          	auipc	ra,0xffffd
    80004410:	c46080e7          	jalr	-954(ra) # 80001052 <myproc>
    80004414:	892a                	mv	s2,a0

  begin_op();
    80004416:	fffff097          	auipc	ra,0xfffff
    8000441a:	474080e7          	jalr	1140(ra) # 8000388a <begin_op>

  if((ip = namei(path)) == 0){
    8000441e:	8526                	mv	a0,s1
    80004420:	fffff097          	auipc	ra,0xfffff
    80004424:	24e080e7          	jalr	590(ra) # 8000366e <namei>
    80004428:	c92d                	beqz	a0,8000449a <exec+0xbc>
    8000442a:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000442c:	fffff097          	auipc	ra,0xfffff
    80004430:	a9c080e7          	jalr	-1380(ra) # 80002ec8 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004434:	04000713          	li	a4,64
    80004438:	4681                	li	a3,0
    8000443a:	e5040613          	addi	a2,s0,-432
    8000443e:	4581                	li	a1,0
    80004440:	8526                	mv	a0,s1
    80004442:	fffff097          	auipc	ra,0xfffff
    80004446:	d3a080e7          	jalr	-710(ra) # 8000317c <readi>
    8000444a:	04000793          	li	a5,64
    8000444e:	00f51a63          	bne	a0,a5,80004462 <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004452:	e5042703          	lw	a4,-432(s0)
    80004456:	464c47b7          	lui	a5,0x464c4
    8000445a:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000445e:	04f70463          	beq	a4,a5,800044a6 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004462:	8526                	mv	a0,s1
    80004464:	fffff097          	auipc	ra,0xfffff
    80004468:	cc6080e7          	jalr	-826(ra) # 8000312a <iunlockput>
    end_op();
    8000446c:	fffff097          	auipc	ra,0xfffff
    80004470:	49e080e7          	jalr	1182(ra) # 8000390a <end_op>
  }
  return -1;
    80004474:	557d                	li	a0,-1
}
    80004476:	20813083          	ld	ra,520(sp)
    8000447a:	20013403          	ld	s0,512(sp)
    8000447e:	74fe                	ld	s1,504(sp)
    80004480:	795e                	ld	s2,496(sp)
    80004482:	79be                	ld	s3,488(sp)
    80004484:	7a1e                	ld	s4,480(sp)
    80004486:	6afe                	ld	s5,472(sp)
    80004488:	6b5e                	ld	s6,464(sp)
    8000448a:	6bbe                	ld	s7,456(sp)
    8000448c:	6c1e                	ld	s8,448(sp)
    8000448e:	7cfa                	ld	s9,440(sp)
    80004490:	7d5a                	ld	s10,432(sp)
    80004492:	7dba                	ld	s11,424(sp)
    80004494:	21010113          	addi	sp,sp,528
    80004498:	8082                	ret
    end_op();
    8000449a:	fffff097          	auipc	ra,0xfffff
    8000449e:	470080e7          	jalr	1136(ra) # 8000390a <end_op>
    return -1;
    800044a2:	557d                	li	a0,-1
    800044a4:	bfc9                	j	80004476 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    800044a6:	854a                	mv	a0,s2
    800044a8:	ffffd097          	auipc	ra,0xffffd
    800044ac:	c72080e7          	jalr	-910(ra) # 8000111a <proc_pagetable>
    800044b0:	8baa                	mv	s7,a0
    800044b2:	d945                	beqz	a0,80004462 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800044b4:	e7042983          	lw	s3,-400(s0)
    800044b8:	e8845783          	lhu	a5,-376(s0)
    800044bc:	c7ad                	beqz	a5,80004526 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800044be:	4a01                	li	s4,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800044c0:	4b01                	li	s6,0
    if(ph.vaddr % PGSIZE != 0)
    800044c2:	6c85                	lui	s9,0x1
    800044c4:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800044c8:	def43823          	sd	a5,-528(s0)
    800044cc:	a4a9                	j	80004716 <exec+0x338>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800044ce:	00004517          	auipc	a0,0x4
    800044d2:	25250513          	addi	a0,a0,594 # 80008720 <syscalls+0x2c8>
    800044d6:	00002097          	auipc	ra,0x2
    800044da:	b0c080e7          	jalr	-1268(ra) # 80005fe2 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800044de:	8756                	mv	a4,s5
    800044e0:	012d86bb          	addw	a3,s11,s2
    800044e4:	4581                	li	a1,0
    800044e6:	8526                	mv	a0,s1
    800044e8:	fffff097          	auipc	ra,0xfffff
    800044ec:	c94080e7          	jalr	-876(ra) # 8000317c <readi>
    800044f0:	2501                	sext.w	a0,a0
    800044f2:	1caa9663          	bne	s5,a0,800046be <exec+0x2e0>
  for(i = 0; i < sz; i += PGSIZE){
    800044f6:	6785                	lui	a5,0x1
    800044f8:	0127893b          	addw	s2,a5,s2
    800044fc:	77fd                	lui	a5,0xfffff
    800044fe:	01478a3b          	addw	s4,a5,s4
    80004502:	21897163          	bgeu	s2,s8,80004704 <exec+0x326>
    pa = walkaddr(pagetable, va + i);
    80004506:	02091593          	slli	a1,s2,0x20
    8000450a:	9181                	srli	a1,a1,0x20
    8000450c:	95ea                	add	a1,a1,s10
    8000450e:	855e                	mv	a0,s7
    80004510:	ffffc097          	auipc	ra,0xffffc
    80004514:	ffa080e7          	jalr	-6(ra) # 8000050a <walkaddr>
    80004518:	862a                	mv	a2,a0
    if(pa == 0)
    8000451a:	d955                	beqz	a0,800044ce <exec+0xf0>
      n = PGSIZE;
    8000451c:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    8000451e:	fd9a70e3          	bgeu	s4,s9,800044de <exec+0x100>
      n = sz - i;
    80004522:	8ad2                	mv	s5,s4
    80004524:	bf6d                	j	800044de <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004526:	4a01                	li	s4,0
  iunlockput(ip);
    80004528:	8526                	mv	a0,s1
    8000452a:	fffff097          	auipc	ra,0xfffff
    8000452e:	c00080e7          	jalr	-1024(ra) # 8000312a <iunlockput>
  end_op();
    80004532:	fffff097          	auipc	ra,0xfffff
    80004536:	3d8080e7          	jalr	984(ra) # 8000390a <end_op>
  p = myproc();
    8000453a:	ffffd097          	auipc	ra,0xffffd
    8000453e:	b18080e7          	jalr	-1256(ra) # 80001052 <myproc>
    80004542:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004544:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004548:	6785                	lui	a5,0x1
    8000454a:	17fd                	addi	a5,a5,-1
    8000454c:	9a3e                	add	s4,s4,a5
    8000454e:	757d                	lui	a0,0xfffff
    80004550:	00aa77b3          	and	a5,s4,a0
    80004554:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004558:	4691                	li	a3,4
    8000455a:	6609                	lui	a2,0x2
    8000455c:	963e                	add	a2,a2,a5
    8000455e:	85be                	mv	a1,a5
    80004560:	855e                	mv	a0,s7
    80004562:	ffffc097          	auipc	ra,0xffffc
    80004566:	380080e7          	jalr	896(ra) # 800008e2 <uvmalloc>
    8000456a:	8b2a                	mv	s6,a0
  ip = 0;
    8000456c:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000456e:	14050863          	beqz	a0,800046be <exec+0x2e0>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004572:	75f9                	lui	a1,0xffffe
    80004574:	95aa                	add	a1,a1,a0
    80004576:	855e                	mv	a0,s7
    80004578:	ffffc097          	auipc	ra,0xffffc
    8000457c:	590080e7          	jalr	1424(ra) # 80000b08 <uvmclear>
  stackbase = sp - PGSIZE;
    80004580:	7c7d                	lui	s8,0xfffff
    80004582:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004584:	e0043783          	ld	a5,-512(s0)
    80004588:	6388                	ld	a0,0(a5)
    8000458a:	c535                	beqz	a0,800045f6 <exec+0x218>
    8000458c:	e9040993          	addi	s3,s0,-368
    80004590:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004594:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004596:	ffffc097          	auipc	ra,0xffffc
    8000459a:	d66080e7          	jalr	-666(ra) # 800002fc <strlen>
    8000459e:	2505                	addiw	a0,a0,1
    800045a0:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800045a4:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800045a8:	15896263          	bltu	s2,s8,800046ec <exec+0x30e>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800045ac:	e0043d83          	ld	s11,-512(s0)
    800045b0:	000dba03          	ld	s4,0(s11)
    800045b4:	8552                	mv	a0,s4
    800045b6:	ffffc097          	auipc	ra,0xffffc
    800045ba:	d46080e7          	jalr	-698(ra) # 800002fc <strlen>
    800045be:	0015069b          	addiw	a3,a0,1
    800045c2:	8652                	mv	a2,s4
    800045c4:	85ca                	mv	a1,s2
    800045c6:	855e                	mv	a0,s7
    800045c8:	ffffc097          	auipc	ra,0xffffc
    800045cc:	572080e7          	jalr	1394(ra) # 80000b3a <copyout>
    800045d0:	12054263          	bltz	a0,800046f4 <exec+0x316>
    ustack[argc] = sp;
    800045d4:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800045d8:	0485                	addi	s1,s1,1
    800045da:	008d8793          	addi	a5,s11,8
    800045de:	e0f43023          	sd	a5,-512(s0)
    800045e2:	008db503          	ld	a0,8(s11)
    800045e6:	c911                	beqz	a0,800045fa <exec+0x21c>
    if(argc >= MAXARG)
    800045e8:	09a1                	addi	s3,s3,8
    800045ea:	fb3c96e3          	bne	s9,s3,80004596 <exec+0x1b8>
  sz = sz1;
    800045ee:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800045f2:	4481                	li	s1,0
    800045f4:	a0e9                	j	800046be <exec+0x2e0>
  sp = sz;
    800045f6:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    800045f8:	4481                	li	s1,0
  ustack[argc] = 0;
    800045fa:	00349793          	slli	a5,s1,0x3
    800045fe:	f9040713          	addi	a4,s0,-112
    80004602:	97ba                	add	a5,a5,a4
    80004604:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    80004608:	00148693          	addi	a3,s1,1
    8000460c:	068e                	slli	a3,a3,0x3
    8000460e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004612:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004616:	01897663          	bgeu	s2,s8,80004622 <exec+0x244>
  sz = sz1;
    8000461a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000461e:	4481                	li	s1,0
    80004620:	a879                	j	800046be <exec+0x2e0>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004622:	e9040613          	addi	a2,s0,-368
    80004626:	85ca                	mv	a1,s2
    80004628:	855e                	mv	a0,s7
    8000462a:	ffffc097          	auipc	ra,0xffffc
    8000462e:	510080e7          	jalr	1296(ra) # 80000b3a <copyout>
    80004632:	0c054563          	bltz	a0,800046fc <exec+0x31e>
  p->trapframe->a1 = sp;
    80004636:	058ab783          	ld	a5,88(s5)
    8000463a:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000463e:	df843783          	ld	a5,-520(s0)
    80004642:	0007c703          	lbu	a4,0(a5)
    80004646:	cf11                	beqz	a4,80004662 <exec+0x284>
    80004648:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000464a:	02f00693          	li	a3,47
    8000464e:	a039                	j	8000465c <exec+0x27e>
      last = s+1;
    80004650:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004654:	0785                	addi	a5,a5,1
    80004656:	fff7c703          	lbu	a4,-1(a5)
    8000465a:	c701                	beqz	a4,80004662 <exec+0x284>
    if(*s == '/')
    8000465c:	fed71ce3          	bne	a4,a3,80004654 <exec+0x276>
    80004660:	bfc5                	j	80004650 <exec+0x272>
  safestrcpy(p->name, last, sizeof(p->name));
    80004662:	4641                	li	a2,16
    80004664:	df843583          	ld	a1,-520(s0)
    80004668:	158a8513          	addi	a0,s5,344
    8000466c:	ffffc097          	auipc	ra,0xffffc
    80004670:	c5e080e7          	jalr	-930(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    80004674:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004678:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    8000467c:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004680:	058ab783          	ld	a5,88(s5)
    80004684:	e6843703          	ld	a4,-408(s0)
    80004688:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000468a:	058ab783          	ld	a5,88(s5)
    8000468e:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004692:	85ea                	mv	a1,s10
    80004694:	ffffd097          	auipc	ra,0xffffd
    80004698:	b66080e7          	jalr	-1178(ra) # 800011fa <proc_freepagetable>
  if(p->pid == 1) 
    8000469c:	030aa703          	lw	a4,48(s5)
    800046a0:	4785                	li	a5,1
    800046a2:	00f70563          	beq	a4,a5,800046ac <exec+0x2ce>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800046a6:	0004851b          	sext.w	a0,s1
    800046aa:	b3f1                	j	80004476 <exec+0x98>
    vmprint(p->pagetable);
    800046ac:	050ab503          	ld	a0,80(s5)
    800046b0:	ffffc097          	auipc	ra,0xffffc
    800046b4:	7fc080e7          	jalr	2044(ra) # 80000eac <vmprint>
    800046b8:	b7fd                	j	800046a6 <exec+0x2c8>
    800046ba:	e1443423          	sd	s4,-504(s0)
    proc_freepagetable(pagetable, sz);
    800046be:	e0843583          	ld	a1,-504(s0)
    800046c2:	855e                	mv	a0,s7
    800046c4:	ffffd097          	auipc	ra,0xffffd
    800046c8:	b36080e7          	jalr	-1226(ra) # 800011fa <proc_freepagetable>
  if(ip){
    800046cc:	d8049be3          	bnez	s1,80004462 <exec+0x84>
  return -1;
    800046d0:	557d                	li	a0,-1
    800046d2:	b355                	j	80004476 <exec+0x98>
    800046d4:	e1443423          	sd	s4,-504(s0)
    800046d8:	b7dd                	j	800046be <exec+0x2e0>
    800046da:	e1443423          	sd	s4,-504(s0)
    800046de:	b7c5                	j	800046be <exec+0x2e0>
    800046e0:	e1443423          	sd	s4,-504(s0)
    800046e4:	bfe9                	j	800046be <exec+0x2e0>
    800046e6:	e1443423          	sd	s4,-504(s0)
    800046ea:	bfd1                	j	800046be <exec+0x2e0>
  sz = sz1;
    800046ec:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800046f0:	4481                	li	s1,0
    800046f2:	b7f1                	j	800046be <exec+0x2e0>
  sz = sz1;
    800046f4:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800046f8:	4481                	li	s1,0
    800046fa:	b7d1                	j	800046be <exec+0x2e0>
  sz = sz1;
    800046fc:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004700:	4481                	li	s1,0
    80004702:	bf75                	j	800046be <exec+0x2e0>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004704:	e0843a03          	ld	s4,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004708:	2b05                	addiw	s6,s6,1
    8000470a:	0389899b          	addiw	s3,s3,56
    8000470e:	e8845783          	lhu	a5,-376(s0)
    80004712:	e0fb5be3          	bge	s6,a5,80004528 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004716:	2981                	sext.w	s3,s3
    80004718:	03800713          	li	a4,56
    8000471c:	86ce                	mv	a3,s3
    8000471e:	e1840613          	addi	a2,s0,-488
    80004722:	4581                	li	a1,0
    80004724:	8526                	mv	a0,s1
    80004726:	fffff097          	auipc	ra,0xfffff
    8000472a:	a56080e7          	jalr	-1450(ra) # 8000317c <readi>
    8000472e:	03800793          	li	a5,56
    80004732:	f8f514e3          	bne	a0,a5,800046ba <exec+0x2dc>
    if(ph.type != ELF_PROG_LOAD)
    80004736:	e1842783          	lw	a5,-488(s0)
    8000473a:	4705                	li	a4,1
    8000473c:	fce796e3          	bne	a5,a4,80004708 <exec+0x32a>
    if(ph.memsz < ph.filesz)
    80004740:	e4043903          	ld	s2,-448(s0)
    80004744:	e3843783          	ld	a5,-456(s0)
    80004748:	f8f966e3          	bltu	s2,a5,800046d4 <exec+0x2f6>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000474c:	e2843783          	ld	a5,-472(s0)
    80004750:	993e                	add	s2,s2,a5
    80004752:	f8f964e3          	bltu	s2,a5,800046da <exec+0x2fc>
    if(ph.vaddr % PGSIZE != 0)
    80004756:	df043703          	ld	a4,-528(s0)
    8000475a:	8ff9                	and	a5,a5,a4
    8000475c:	f3d1                	bnez	a5,800046e0 <exec+0x302>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000475e:	e1c42503          	lw	a0,-484(s0)
    80004762:	00000097          	auipc	ra,0x0
    80004766:	c60080e7          	jalr	-928(ra) # 800043c2 <flags2perm>
    8000476a:	86aa                	mv	a3,a0
    8000476c:	864a                	mv	a2,s2
    8000476e:	85d2                	mv	a1,s4
    80004770:	855e                	mv	a0,s7
    80004772:	ffffc097          	auipc	ra,0xffffc
    80004776:	170080e7          	jalr	368(ra) # 800008e2 <uvmalloc>
    8000477a:	e0a43423          	sd	a0,-504(s0)
    8000477e:	d525                	beqz	a0,800046e6 <exec+0x308>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004780:	e2843d03          	ld	s10,-472(s0)
    80004784:	e2042d83          	lw	s11,-480(s0)
    80004788:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000478c:	f60c0ce3          	beqz	s8,80004704 <exec+0x326>
    80004790:	8a62                	mv	s4,s8
    80004792:	4901                	li	s2,0
    80004794:	bb8d                	j	80004506 <exec+0x128>

0000000080004796 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004796:	7179                	addi	sp,sp,-48
    80004798:	f406                	sd	ra,40(sp)
    8000479a:	f022                	sd	s0,32(sp)
    8000479c:	ec26                	sd	s1,24(sp)
    8000479e:	e84a                	sd	s2,16(sp)
    800047a0:	1800                	addi	s0,sp,48
    800047a2:	892e                	mv	s2,a1
    800047a4:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800047a6:	fdc40593          	addi	a1,s0,-36
    800047aa:	ffffe097          	auipc	ra,0xffffe
    800047ae:	b64080e7          	jalr	-1180(ra) # 8000230e <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800047b2:	fdc42703          	lw	a4,-36(s0)
    800047b6:	47bd                	li	a5,15
    800047b8:	02e7eb63          	bltu	a5,a4,800047ee <argfd+0x58>
    800047bc:	ffffd097          	auipc	ra,0xffffd
    800047c0:	896080e7          	jalr	-1898(ra) # 80001052 <myproc>
    800047c4:	fdc42703          	lw	a4,-36(s0)
    800047c8:	01a70793          	addi	a5,a4,26
    800047cc:	078e                	slli	a5,a5,0x3
    800047ce:	953e                	add	a0,a0,a5
    800047d0:	611c                	ld	a5,0(a0)
    800047d2:	c385                	beqz	a5,800047f2 <argfd+0x5c>
    return -1;
  if(pfd)
    800047d4:	00090463          	beqz	s2,800047dc <argfd+0x46>
    *pfd = fd;
    800047d8:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800047dc:	4501                	li	a0,0
  if(pf)
    800047de:	c091                	beqz	s1,800047e2 <argfd+0x4c>
    *pf = f;
    800047e0:	e09c                	sd	a5,0(s1)
}
    800047e2:	70a2                	ld	ra,40(sp)
    800047e4:	7402                	ld	s0,32(sp)
    800047e6:	64e2                	ld	s1,24(sp)
    800047e8:	6942                	ld	s2,16(sp)
    800047ea:	6145                	addi	sp,sp,48
    800047ec:	8082                	ret
    return -1;
    800047ee:	557d                	li	a0,-1
    800047f0:	bfcd                	j	800047e2 <argfd+0x4c>
    800047f2:	557d                	li	a0,-1
    800047f4:	b7fd                	j	800047e2 <argfd+0x4c>

00000000800047f6 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800047f6:	1101                	addi	sp,sp,-32
    800047f8:	ec06                	sd	ra,24(sp)
    800047fa:	e822                	sd	s0,16(sp)
    800047fc:	e426                	sd	s1,8(sp)
    800047fe:	1000                	addi	s0,sp,32
    80004800:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004802:	ffffd097          	auipc	ra,0xffffd
    80004806:	850080e7          	jalr	-1968(ra) # 80001052 <myproc>
    8000480a:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000480c:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffdd0b0>
    80004810:	4501                	li	a0,0
    80004812:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004814:	6398                	ld	a4,0(a5)
    80004816:	cb19                	beqz	a4,8000482c <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004818:	2505                	addiw	a0,a0,1
    8000481a:	07a1                	addi	a5,a5,8
    8000481c:	fed51ce3          	bne	a0,a3,80004814 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004820:	557d                	li	a0,-1
}
    80004822:	60e2                	ld	ra,24(sp)
    80004824:	6442                	ld	s0,16(sp)
    80004826:	64a2                	ld	s1,8(sp)
    80004828:	6105                	addi	sp,sp,32
    8000482a:	8082                	ret
      p->ofile[fd] = f;
    8000482c:	01a50793          	addi	a5,a0,26
    80004830:	078e                	slli	a5,a5,0x3
    80004832:	963e                	add	a2,a2,a5
    80004834:	e204                	sd	s1,0(a2)
      return fd;
    80004836:	b7f5                	j	80004822 <fdalloc+0x2c>

0000000080004838 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004838:	715d                	addi	sp,sp,-80
    8000483a:	e486                	sd	ra,72(sp)
    8000483c:	e0a2                	sd	s0,64(sp)
    8000483e:	fc26                	sd	s1,56(sp)
    80004840:	f84a                	sd	s2,48(sp)
    80004842:	f44e                	sd	s3,40(sp)
    80004844:	f052                	sd	s4,32(sp)
    80004846:	ec56                	sd	s5,24(sp)
    80004848:	e85a                	sd	s6,16(sp)
    8000484a:	0880                	addi	s0,sp,80
    8000484c:	8b2e                	mv	s6,a1
    8000484e:	89b2                	mv	s3,a2
    80004850:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004852:	fb040593          	addi	a1,s0,-80
    80004856:	fffff097          	auipc	ra,0xfffff
    8000485a:	e36080e7          	jalr	-458(ra) # 8000368c <nameiparent>
    8000485e:	84aa                	mv	s1,a0
    80004860:	16050063          	beqz	a0,800049c0 <create+0x188>
    return 0;

  ilock(dp);
    80004864:	ffffe097          	auipc	ra,0xffffe
    80004868:	664080e7          	jalr	1636(ra) # 80002ec8 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000486c:	4601                	li	a2,0
    8000486e:	fb040593          	addi	a1,s0,-80
    80004872:	8526                	mv	a0,s1
    80004874:	fffff097          	auipc	ra,0xfffff
    80004878:	b38080e7          	jalr	-1224(ra) # 800033ac <dirlookup>
    8000487c:	8aaa                	mv	s5,a0
    8000487e:	c931                	beqz	a0,800048d2 <create+0x9a>
    iunlockput(dp);
    80004880:	8526                	mv	a0,s1
    80004882:	fffff097          	auipc	ra,0xfffff
    80004886:	8a8080e7          	jalr	-1880(ra) # 8000312a <iunlockput>
    ilock(ip);
    8000488a:	8556                	mv	a0,s5
    8000488c:	ffffe097          	auipc	ra,0xffffe
    80004890:	63c080e7          	jalr	1596(ra) # 80002ec8 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004894:	000b059b          	sext.w	a1,s6
    80004898:	4789                	li	a5,2
    8000489a:	02f59563          	bne	a1,a5,800048c4 <create+0x8c>
    8000489e:	044ad783          	lhu	a5,68(s5)
    800048a2:	37f9                	addiw	a5,a5,-2
    800048a4:	17c2                	slli	a5,a5,0x30
    800048a6:	93c1                	srli	a5,a5,0x30
    800048a8:	4705                	li	a4,1
    800048aa:	00f76d63          	bltu	a4,a5,800048c4 <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800048ae:	8556                	mv	a0,s5
    800048b0:	60a6                	ld	ra,72(sp)
    800048b2:	6406                	ld	s0,64(sp)
    800048b4:	74e2                	ld	s1,56(sp)
    800048b6:	7942                	ld	s2,48(sp)
    800048b8:	79a2                	ld	s3,40(sp)
    800048ba:	7a02                	ld	s4,32(sp)
    800048bc:	6ae2                	ld	s5,24(sp)
    800048be:	6b42                	ld	s6,16(sp)
    800048c0:	6161                	addi	sp,sp,80
    800048c2:	8082                	ret
    iunlockput(ip);
    800048c4:	8556                	mv	a0,s5
    800048c6:	fffff097          	auipc	ra,0xfffff
    800048ca:	864080e7          	jalr	-1948(ra) # 8000312a <iunlockput>
    return 0;
    800048ce:	4a81                	li	s5,0
    800048d0:	bff9                	j	800048ae <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    800048d2:	85da                	mv	a1,s6
    800048d4:	4088                	lw	a0,0(s1)
    800048d6:	ffffe097          	auipc	ra,0xffffe
    800048da:	456080e7          	jalr	1110(ra) # 80002d2c <ialloc>
    800048de:	8a2a                	mv	s4,a0
    800048e0:	c921                	beqz	a0,80004930 <create+0xf8>
  ilock(ip);
    800048e2:	ffffe097          	auipc	ra,0xffffe
    800048e6:	5e6080e7          	jalr	1510(ra) # 80002ec8 <ilock>
  ip->major = major;
    800048ea:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800048ee:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800048f2:	4785                	li	a5,1
    800048f4:	04fa1523          	sh	a5,74(s4)
  iupdate(ip);
    800048f8:	8552                	mv	a0,s4
    800048fa:	ffffe097          	auipc	ra,0xffffe
    800048fe:	504080e7          	jalr	1284(ra) # 80002dfe <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004902:	000b059b          	sext.w	a1,s6
    80004906:	4785                	li	a5,1
    80004908:	02f58b63          	beq	a1,a5,8000493e <create+0x106>
  if(dirlink(dp, name, ip->inum) < 0)
    8000490c:	004a2603          	lw	a2,4(s4)
    80004910:	fb040593          	addi	a1,s0,-80
    80004914:	8526                	mv	a0,s1
    80004916:	fffff097          	auipc	ra,0xfffff
    8000491a:	ca6080e7          	jalr	-858(ra) # 800035bc <dirlink>
    8000491e:	06054f63          	bltz	a0,8000499c <create+0x164>
  iunlockput(dp);
    80004922:	8526                	mv	a0,s1
    80004924:	fffff097          	auipc	ra,0xfffff
    80004928:	806080e7          	jalr	-2042(ra) # 8000312a <iunlockput>
  return ip;
    8000492c:	8ad2                	mv	s5,s4
    8000492e:	b741                	j	800048ae <create+0x76>
    iunlockput(dp);
    80004930:	8526                	mv	a0,s1
    80004932:	ffffe097          	auipc	ra,0xffffe
    80004936:	7f8080e7          	jalr	2040(ra) # 8000312a <iunlockput>
    return 0;
    8000493a:	8ad2                	mv	s5,s4
    8000493c:	bf8d                	j	800048ae <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000493e:	004a2603          	lw	a2,4(s4)
    80004942:	00004597          	auipc	a1,0x4
    80004946:	dfe58593          	addi	a1,a1,-514 # 80008740 <syscalls+0x2e8>
    8000494a:	8552                	mv	a0,s4
    8000494c:	fffff097          	auipc	ra,0xfffff
    80004950:	c70080e7          	jalr	-912(ra) # 800035bc <dirlink>
    80004954:	04054463          	bltz	a0,8000499c <create+0x164>
    80004958:	40d0                	lw	a2,4(s1)
    8000495a:	00004597          	auipc	a1,0x4
    8000495e:	83e58593          	addi	a1,a1,-1986 # 80008198 <etext+0x198>
    80004962:	8552                	mv	a0,s4
    80004964:	fffff097          	auipc	ra,0xfffff
    80004968:	c58080e7          	jalr	-936(ra) # 800035bc <dirlink>
    8000496c:	02054863          	bltz	a0,8000499c <create+0x164>
  if(dirlink(dp, name, ip->inum) < 0)
    80004970:	004a2603          	lw	a2,4(s4)
    80004974:	fb040593          	addi	a1,s0,-80
    80004978:	8526                	mv	a0,s1
    8000497a:	fffff097          	auipc	ra,0xfffff
    8000497e:	c42080e7          	jalr	-958(ra) # 800035bc <dirlink>
    80004982:	00054d63          	bltz	a0,8000499c <create+0x164>
    dp->nlink++;  // for ".."
    80004986:	04a4d783          	lhu	a5,74(s1)
    8000498a:	2785                	addiw	a5,a5,1
    8000498c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004990:	8526                	mv	a0,s1
    80004992:	ffffe097          	auipc	ra,0xffffe
    80004996:	46c080e7          	jalr	1132(ra) # 80002dfe <iupdate>
    8000499a:	b761                	j	80004922 <create+0xea>
  ip->nlink = 0;
    8000499c:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800049a0:	8552                	mv	a0,s4
    800049a2:	ffffe097          	auipc	ra,0xffffe
    800049a6:	45c080e7          	jalr	1116(ra) # 80002dfe <iupdate>
  iunlockput(ip);
    800049aa:	8552                	mv	a0,s4
    800049ac:	ffffe097          	auipc	ra,0xffffe
    800049b0:	77e080e7          	jalr	1918(ra) # 8000312a <iunlockput>
  iunlockput(dp);
    800049b4:	8526                	mv	a0,s1
    800049b6:	ffffe097          	auipc	ra,0xffffe
    800049ba:	774080e7          	jalr	1908(ra) # 8000312a <iunlockput>
  return 0;
    800049be:	bdc5                	j	800048ae <create+0x76>
    return 0;
    800049c0:	8aaa                	mv	s5,a0
    800049c2:	b5f5                	j	800048ae <create+0x76>

00000000800049c4 <sys_dup>:
{
    800049c4:	7179                	addi	sp,sp,-48
    800049c6:	f406                	sd	ra,40(sp)
    800049c8:	f022                	sd	s0,32(sp)
    800049ca:	ec26                	sd	s1,24(sp)
    800049cc:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800049ce:	fd840613          	addi	a2,s0,-40
    800049d2:	4581                	li	a1,0
    800049d4:	4501                	li	a0,0
    800049d6:	00000097          	auipc	ra,0x0
    800049da:	dc0080e7          	jalr	-576(ra) # 80004796 <argfd>
    return -1;
    800049de:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800049e0:	02054363          	bltz	a0,80004a06 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800049e4:	fd843503          	ld	a0,-40(s0)
    800049e8:	00000097          	auipc	ra,0x0
    800049ec:	e0e080e7          	jalr	-498(ra) # 800047f6 <fdalloc>
    800049f0:	84aa                	mv	s1,a0
    return -1;
    800049f2:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800049f4:	00054963          	bltz	a0,80004a06 <sys_dup+0x42>
  filedup(f);
    800049f8:	fd843503          	ld	a0,-40(s0)
    800049fc:	fffff097          	auipc	ra,0xfffff
    80004a00:	308080e7          	jalr	776(ra) # 80003d04 <filedup>
  return fd;
    80004a04:	87a6                	mv	a5,s1
}
    80004a06:	853e                	mv	a0,a5
    80004a08:	70a2                	ld	ra,40(sp)
    80004a0a:	7402                	ld	s0,32(sp)
    80004a0c:	64e2                	ld	s1,24(sp)
    80004a0e:	6145                	addi	sp,sp,48
    80004a10:	8082                	ret

0000000080004a12 <sys_read>:
{
    80004a12:	7179                	addi	sp,sp,-48
    80004a14:	f406                	sd	ra,40(sp)
    80004a16:	f022                	sd	s0,32(sp)
    80004a18:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004a1a:	fd840593          	addi	a1,s0,-40
    80004a1e:	4505                	li	a0,1
    80004a20:	ffffe097          	auipc	ra,0xffffe
    80004a24:	90e080e7          	jalr	-1778(ra) # 8000232e <argaddr>
  argint(2, &n);
    80004a28:	fe440593          	addi	a1,s0,-28
    80004a2c:	4509                	li	a0,2
    80004a2e:	ffffe097          	auipc	ra,0xffffe
    80004a32:	8e0080e7          	jalr	-1824(ra) # 8000230e <argint>
  if(argfd(0, 0, &f) < 0)
    80004a36:	fe840613          	addi	a2,s0,-24
    80004a3a:	4581                	li	a1,0
    80004a3c:	4501                	li	a0,0
    80004a3e:	00000097          	auipc	ra,0x0
    80004a42:	d58080e7          	jalr	-680(ra) # 80004796 <argfd>
    80004a46:	87aa                	mv	a5,a0
    return -1;
    80004a48:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004a4a:	0007cc63          	bltz	a5,80004a62 <sys_read+0x50>
  return fileread(f, p, n);
    80004a4e:	fe442603          	lw	a2,-28(s0)
    80004a52:	fd843583          	ld	a1,-40(s0)
    80004a56:	fe843503          	ld	a0,-24(s0)
    80004a5a:	fffff097          	auipc	ra,0xfffff
    80004a5e:	436080e7          	jalr	1078(ra) # 80003e90 <fileread>
}
    80004a62:	70a2                	ld	ra,40(sp)
    80004a64:	7402                	ld	s0,32(sp)
    80004a66:	6145                	addi	sp,sp,48
    80004a68:	8082                	ret

0000000080004a6a <sys_write>:
{
    80004a6a:	7179                	addi	sp,sp,-48
    80004a6c:	f406                	sd	ra,40(sp)
    80004a6e:	f022                	sd	s0,32(sp)
    80004a70:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004a72:	fd840593          	addi	a1,s0,-40
    80004a76:	4505                	li	a0,1
    80004a78:	ffffe097          	auipc	ra,0xffffe
    80004a7c:	8b6080e7          	jalr	-1866(ra) # 8000232e <argaddr>
  argint(2, &n);
    80004a80:	fe440593          	addi	a1,s0,-28
    80004a84:	4509                	li	a0,2
    80004a86:	ffffe097          	auipc	ra,0xffffe
    80004a8a:	888080e7          	jalr	-1912(ra) # 8000230e <argint>
  if(argfd(0, 0, &f) < 0)
    80004a8e:	fe840613          	addi	a2,s0,-24
    80004a92:	4581                	li	a1,0
    80004a94:	4501                	li	a0,0
    80004a96:	00000097          	auipc	ra,0x0
    80004a9a:	d00080e7          	jalr	-768(ra) # 80004796 <argfd>
    80004a9e:	87aa                	mv	a5,a0
    return -1;
    80004aa0:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004aa2:	0007cc63          	bltz	a5,80004aba <sys_write+0x50>
  return filewrite(f, p, n);
    80004aa6:	fe442603          	lw	a2,-28(s0)
    80004aaa:	fd843583          	ld	a1,-40(s0)
    80004aae:	fe843503          	ld	a0,-24(s0)
    80004ab2:	fffff097          	auipc	ra,0xfffff
    80004ab6:	4a0080e7          	jalr	1184(ra) # 80003f52 <filewrite>
}
    80004aba:	70a2                	ld	ra,40(sp)
    80004abc:	7402                	ld	s0,32(sp)
    80004abe:	6145                	addi	sp,sp,48
    80004ac0:	8082                	ret

0000000080004ac2 <sys_close>:
{
    80004ac2:	1101                	addi	sp,sp,-32
    80004ac4:	ec06                	sd	ra,24(sp)
    80004ac6:	e822                	sd	s0,16(sp)
    80004ac8:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004aca:	fe040613          	addi	a2,s0,-32
    80004ace:	fec40593          	addi	a1,s0,-20
    80004ad2:	4501                	li	a0,0
    80004ad4:	00000097          	auipc	ra,0x0
    80004ad8:	cc2080e7          	jalr	-830(ra) # 80004796 <argfd>
    return -1;
    80004adc:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004ade:	02054463          	bltz	a0,80004b06 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004ae2:	ffffc097          	auipc	ra,0xffffc
    80004ae6:	570080e7          	jalr	1392(ra) # 80001052 <myproc>
    80004aea:	fec42783          	lw	a5,-20(s0)
    80004aee:	07e9                	addi	a5,a5,26
    80004af0:	078e                	slli	a5,a5,0x3
    80004af2:	97aa                	add	a5,a5,a0
    80004af4:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80004af8:	fe043503          	ld	a0,-32(s0)
    80004afc:	fffff097          	auipc	ra,0xfffff
    80004b00:	25a080e7          	jalr	602(ra) # 80003d56 <fileclose>
  return 0;
    80004b04:	4781                	li	a5,0
}
    80004b06:	853e                	mv	a0,a5
    80004b08:	60e2                	ld	ra,24(sp)
    80004b0a:	6442                	ld	s0,16(sp)
    80004b0c:	6105                	addi	sp,sp,32
    80004b0e:	8082                	ret

0000000080004b10 <sys_fstat>:
{
    80004b10:	1101                	addi	sp,sp,-32
    80004b12:	ec06                	sd	ra,24(sp)
    80004b14:	e822                	sd	s0,16(sp)
    80004b16:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004b18:	fe040593          	addi	a1,s0,-32
    80004b1c:	4505                	li	a0,1
    80004b1e:	ffffe097          	auipc	ra,0xffffe
    80004b22:	810080e7          	jalr	-2032(ra) # 8000232e <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004b26:	fe840613          	addi	a2,s0,-24
    80004b2a:	4581                	li	a1,0
    80004b2c:	4501                	li	a0,0
    80004b2e:	00000097          	auipc	ra,0x0
    80004b32:	c68080e7          	jalr	-920(ra) # 80004796 <argfd>
    80004b36:	87aa                	mv	a5,a0
    return -1;
    80004b38:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004b3a:	0007ca63          	bltz	a5,80004b4e <sys_fstat+0x3e>
  return filestat(f, st);
    80004b3e:	fe043583          	ld	a1,-32(s0)
    80004b42:	fe843503          	ld	a0,-24(s0)
    80004b46:	fffff097          	auipc	ra,0xfffff
    80004b4a:	2d8080e7          	jalr	728(ra) # 80003e1e <filestat>
}
    80004b4e:	60e2                	ld	ra,24(sp)
    80004b50:	6442                	ld	s0,16(sp)
    80004b52:	6105                	addi	sp,sp,32
    80004b54:	8082                	ret

0000000080004b56 <sys_link>:
{
    80004b56:	7169                	addi	sp,sp,-304
    80004b58:	f606                	sd	ra,296(sp)
    80004b5a:	f222                	sd	s0,288(sp)
    80004b5c:	ee26                	sd	s1,280(sp)
    80004b5e:	ea4a                	sd	s2,272(sp)
    80004b60:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b62:	08000613          	li	a2,128
    80004b66:	ed040593          	addi	a1,s0,-304
    80004b6a:	4501                	li	a0,0
    80004b6c:	ffffd097          	auipc	ra,0xffffd
    80004b70:	7e2080e7          	jalr	2018(ra) # 8000234e <argstr>
    return -1;
    80004b74:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b76:	10054e63          	bltz	a0,80004c92 <sys_link+0x13c>
    80004b7a:	08000613          	li	a2,128
    80004b7e:	f5040593          	addi	a1,s0,-176
    80004b82:	4505                	li	a0,1
    80004b84:	ffffd097          	auipc	ra,0xffffd
    80004b88:	7ca080e7          	jalr	1994(ra) # 8000234e <argstr>
    return -1;
    80004b8c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004b8e:	10054263          	bltz	a0,80004c92 <sys_link+0x13c>
  begin_op();
    80004b92:	fffff097          	auipc	ra,0xfffff
    80004b96:	cf8080e7          	jalr	-776(ra) # 8000388a <begin_op>
  if((ip = namei(old)) == 0){
    80004b9a:	ed040513          	addi	a0,s0,-304
    80004b9e:	fffff097          	auipc	ra,0xfffff
    80004ba2:	ad0080e7          	jalr	-1328(ra) # 8000366e <namei>
    80004ba6:	84aa                	mv	s1,a0
    80004ba8:	c551                	beqz	a0,80004c34 <sys_link+0xde>
  ilock(ip);
    80004baa:	ffffe097          	auipc	ra,0xffffe
    80004bae:	31e080e7          	jalr	798(ra) # 80002ec8 <ilock>
  if(ip->type == T_DIR){
    80004bb2:	04449703          	lh	a4,68(s1)
    80004bb6:	4785                	li	a5,1
    80004bb8:	08f70463          	beq	a4,a5,80004c40 <sys_link+0xea>
  ip->nlink++;
    80004bbc:	04a4d783          	lhu	a5,74(s1)
    80004bc0:	2785                	addiw	a5,a5,1
    80004bc2:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004bc6:	8526                	mv	a0,s1
    80004bc8:	ffffe097          	auipc	ra,0xffffe
    80004bcc:	236080e7          	jalr	566(ra) # 80002dfe <iupdate>
  iunlock(ip);
    80004bd0:	8526                	mv	a0,s1
    80004bd2:	ffffe097          	auipc	ra,0xffffe
    80004bd6:	3b8080e7          	jalr	952(ra) # 80002f8a <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004bda:	fd040593          	addi	a1,s0,-48
    80004bde:	f5040513          	addi	a0,s0,-176
    80004be2:	fffff097          	auipc	ra,0xfffff
    80004be6:	aaa080e7          	jalr	-1366(ra) # 8000368c <nameiparent>
    80004bea:	892a                	mv	s2,a0
    80004bec:	c935                	beqz	a0,80004c60 <sys_link+0x10a>
  ilock(dp);
    80004bee:	ffffe097          	auipc	ra,0xffffe
    80004bf2:	2da080e7          	jalr	730(ra) # 80002ec8 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004bf6:	00092703          	lw	a4,0(s2)
    80004bfa:	409c                	lw	a5,0(s1)
    80004bfc:	04f71d63          	bne	a4,a5,80004c56 <sys_link+0x100>
    80004c00:	40d0                	lw	a2,4(s1)
    80004c02:	fd040593          	addi	a1,s0,-48
    80004c06:	854a                	mv	a0,s2
    80004c08:	fffff097          	auipc	ra,0xfffff
    80004c0c:	9b4080e7          	jalr	-1612(ra) # 800035bc <dirlink>
    80004c10:	04054363          	bltz	a0,80004c56 <sys_link+0x100>
  iunlockput(dp);
    80004c14:	854a                	mv	a0,s2
    80004c16:	ffffe097          	auipc	ra,0xffffe
    80004c1a:	514080e7          	jalr	1300(ra) # 8000312a <iunlockput>
  iput(ip);
    80004c1e:	8526                	mv	a0,s1
    80004c20:	ffffe097          	auipc	ra,0xffffe
    80004c24:	462080e7          	jalr	1122(ra) # 80003082 <iput>
  end_op();
    80004c28:	fffff097          	auipc	ra,0xfffff
    80004c2c:	ce2080e7          	jalr	-798(ra) # 8000390a <end_op>
  return 0;
    80004c30:	4781                	li	a5,0
    80004c32:	a085                	j	80004c92 <sys_link+0x13c>
    end_op();
    80004c34:	fffff097          	auipc	ra,0xfffff
    80004c38:	cd6080e7          	jalr	-810(ra) # 8000390a <end_op>
    return -1;
    80004c3c:	57fd                	li	a5,-1
    80004c3e:	a891                	j	80004c92 <sys_link+0x13c>
    iunlockput(ip);
    80004c40:	8526                	mv	a0,s1
    80004c42:	ffffe097          	auipc	ra,0xffffe
    80004c46:	4e8080e7          	jalr	1256(ra) # 8000312a <iunlockput>
    end_op();
    80004c4a:	fffff097          	auipc	ra,0xfffff
    80004c4e:	cc0080e7          	jalr	-832(ra) # 8000390a <end_op>
    return -1;
    80004c52:	57fd                	li	a5,-1
    80004c54:	a83d                	j	80004c92 <sys_link+0x13c>
    iunlockput(dp);
    80004c56:	854a                	mv	a0,s2
    80004c58:	ffffe097          	auipc	ra,0xffffe
    80004c5c:	4d2080e7          	jalr	1234(ra) # 8000312a <iunlockput>
  ilock(ip);
    80004c60:	8526                	mv	a0,s1
    80004c62:	ffffe097          	auipc	ra,0xffffe
    80004c66:	266080e7          	jalr	614(ra) # 80002ec8 <ilock>
  ip->nlink--;
    80004c6a:	04a4d783          	lhu	a5,74(s1)
    80004c6e:	37fd                	addiw	a5,a5,-1
    80004c70:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004c74:	8526                	mv	a0,s1
    80004c76:	ffffe097          	auipc	ra,0xffffe
    80004c7a:	188080e7          	jalr	392(ra) # 80002dfe <iupdate>
  iunlockput(ip);
    80004c7e:	8526                	mv	a0,s1
    80004c80:	ffffe097          	auipc	ra,0xffffe
    80004c84:	4aa080e7          	jalr	1194(ra) # 8000312a <iunlockput>
  end_op();
    80004c88:	fffff097          	auipc	ra,0xfffff
    80004c8c:	c82080e7          	jalr	-894(ra) # 8000390a <end_op>
  return -1;
    80004c90:	57fd                	li	a5,-1
}
    80004c92:	853e                	mv	a0,a5
    80004c94:	70b2                	ld	ra,296(sp)
    80004c96:	7412                	ld	s0,288(sp)
    80004c98:	64f2                	ld	s1,280(sp)
    80004c9a:	6952                	ld	s2,272(sp)
    80004c9c:	6155                	addi	sp,sp,304
    80004c9e:	8082                	ret

0000000080004ca0 <sys_unlink>:
{
    80004ca0:	7151                	addi	sp,sp,-240
    80004ca2:	f586                	sd	ra,232(sp)
    80004ca4:	f1a2                	sd	s0,224(sp)
    80004ca6:	eda6                	sd	s1,216(sp)
    80004ca8:	e9ca                	sd	s2,208(sp)
    80004caa:	e5ce                	sd	s3,200(sp)
    80004cac:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004cae:	08000613          	li	a2,128
    80004cb2:	f3040593          	addi	a1,s0,-208
    80004cb6:	4501                	li	a0,0
    80004cb8:	ffffd097          	auipc	ra,0xffffd
    80004cbc:	696080e7          	jalr	1686(ra) # 8000234e <argstr>
    80004cc0:	18054163          	bltz	a0,80004e42 <sys_unlink+0x1a2>
  begin_op();
    80004cc4:	fffff097          	auipc	ra,0xfffff
    80004cc8:	bc6080e7          	jalr	-1082(ra) # 8000388a <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004ccc:	fb040593          	addi	a1,s0,-80
    80004cd0:	f3040513          	addi	a0,s0,-208
    80004cd4:	fffff097          	auipc	ra,0xfffff
    80004cd8:	9b8080e7          	jalr	-1608(ra) # 8000368c <nameiparent>
    80004cdc:	84aa                	mv	s1,a0
    80004cde:	c979                	beqz	a0,80004db4 <sys_unlink+0x114>
  ilock(dp);
    80004ce0:	ffffe097          	auipc	ra,0xffffe
    80004ce4:	1e8080e7          	jalr	488(ra) # 80002ec8 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004ce8:	00004597          	auipc	a1,0x4
    80004cec:	a5858593          	addi	a1,a1,-1448 # 80008740 <syscalls+0x2e8>
    80004cf0:	fb040513          	addi	a0,s0,-80
    80004cf4:	ffffe097          	auipc	ra,0xffffe
    80004cf8:	69e080e7          	jalr	1694(ra) # 80003392 <namecmp>
    80004cfc:	14050a63          	beqz	a0,80004e50 <sys_unlink+0x1b0>
    80004d00:	00003597          	auipc	a1,0x3
    80004d04:	49858593          	addi	a1,a1,1176 # 80008198 <etext+0x198>
    80004d08:	fb040513          	addi	a0,s0,-80
    80004d0c:	ffffe097          	auipc	ra,0xffffe
    80004d10:	686080e7          	jalr	1670(ra) # 80003392 <namecmp>
    80004d14:	12050e63          	beqz	a0,80004e50 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004d18:	f2c40613          	addi	a2,s0,-212
    80004d1c:	fb040593          	addi	a1,s0,-80
    80004d20:	8526                	mv	a0,s1
    80004d22:	ffffe097          	auipc	ra,0xffffe
    80004d26:	68a080e7          	jalr	1674(ra) # 800033ac <dirlookup>
    80004d2a:	892a                	mv	s2,a0
    80004d2c:	12050263          	beqz	a0,80004e50 <sys_unlink+0x1b0>
  ilock(ip);
    80004d30:	ffffe097          	auipc	ra,0xffffe
    80004d34:	198080e7          	jalr	408(ra) # 80002ec8 <ilock>
  if(ip->nlink < 1)
    80004d38:	04a91783          	lh	a5,74(s2)
    80004d3c:	08f05263          	blez	a5,80004dc0 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004d40:	04491703          	lh	a4,68(s2)
    80004d44:	4785                	li	a5,1
    80004d46:	08f70563          	beq	a4,a5,80004dd0 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004d4a:	4641                	li	a2,16
    80004d4c:	4581                	li	a1,0
    80004d4e:	fc040513          	addi	a0,s0,-64
    80004d52:	ffffb097          	auipc	ra,0xffffb
    80004d56:	426080e7          	jalr	1062(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004d5a:	4741                	li	a4,16
    80004d5c:	f2c42683          	lw	a3,-212(s0)
    80004d60:	fc040613          	addi	a2,s0,-64
    80004d64:	4581                	li	a1,0
    80004d66:	8526                	mv	a0,s1
    80004d68:	ffffe097          	auipc	ra,0xffffe
    80004d6c:	50c080e7          	jalr	1292(ra) # 80003274 <writei>
    80004d70:	47c1                	li	a5,16
    80004d72:	0af51563          	bne	a0,a5,80004e1c <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004d76:	04491703          	lh	a4,68(s2)
    80004d7a:	4785                	li	a5,1
    80004d7c:	0af70863          	beq	a4,a5,80004e2c <sys_unlink+0x18c>
  iunlockput(dp);
    80004d80:	8526                	mv	a0,s1
    80004d82:	ffffe097          	auipc	ra,0xffffe
    80004d86:	3a8080e7          	jalr	936(ra) # 8000312a <iunlockput>
  ip->nlink--;
    80004d8a:	04a95783          	lhu	a5,74(s2)
    80004d8e:	37fd                	addiw	a5,a5,-1
    80004d90:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004d94:	854a                	mv	a0,s2
    80004d96:	ffffe097          	auipc	ra,0xffffe
    80004d9a:	068080e7          	jalr	104(ra) # 80002dfe <iupdate>
  iunlockput(ip);
    80004d9e:	854a                	mv	a0,s2
    80004da0:	ffffe097          	auipc	ra,0xffffe
    80004da4:	38a080e7          	jalr	906(ra) # 8000312a <iunlockput>
  end_op();
    80004da8:	fffff097          	auipc	ra,0xfffff
    80004dac:	b62080e7          	jalr	-1182(ra) # 8000390a <end_op>
  return 0;
    80004db0:	4501                	li	a0,0
    80004db2:	a84d                	j	80004e64 <sys_unlink+0x1c4>
    end_op();
    80004db4:	fffff097          	auipc	ra,0xfffff
    80004db8:	b56080e7          	jalr	-1194(ra) # 8000390a <end_op>
    return -1;
    80004dbc:	557d                	li	a0,-1
    80004dbe:	a05d                	j	80004e64 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004dc0:	00004517          	auipc	a0,0x4
    80004dc4:	98850513          	addi	a0,a0,-1656 # 80008748 <syscalls+0x2f0>
    80004dc8:	00001097          	auipc	ra,0x1
    80004dcc:	21a080e7          	jalr	538(ra) # 80005fe2 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004dd0:	04c92703          	lw	a4,76(s2)
    80004dd4:	02000793          	li	a5,32
    80004dd8:	f6e7f9e3          	bgeu	a5,a4,80004d4a <sys_unlink+0xaa>
    80004ddc:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004de0:	4741                	li	a4,16
    80004de2:	86ce                	mv	a3,s3
    80004de4:	f1840613          	addi	a2,s0,-232
    80004de8:	4581                	li	a1,0
    80004dea:	854a                	mv	a0,s2
    80004dec:	ffffe097          	auipc	ra,0xffffe
    80004df0:	390080e7          	jalr	912(ra) # 8000317c <readi>
    80004df4:	47c1                	li	a5,16
    80004df6:	00f51b63          	bne	a0,a5,80004e0c <sys_unlink+0x16c>
    if(de.inum != 0)
    80004dfa:	f1845783          	lhu	a5,-232(s0)
    80004dfe:	e7a1                	bnez	a5,80004e46 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004e00:	29c1                	addiw	s3,s3,16
    80004e02:	04c92783          	lw	a5,76(s2)
    80004e06:	fcf9ede3          	bltu	s3,a5,80004de0 <sys_unlink+0x140>
    80004e0a:	b781                	j	80004d4a <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004e0c:	00004517          	auipc	a0,0x4
    80004e10:	95450513          	addi	a0,a0,-1708 # 80008760 <syscalls+0x308>
    80004e14:	00001097          	auipc	ra,0x1
    80004e18:	1ce080e7          	jalr	462(ra) # 80005fe2 <panic>
    panic("unlink: writei");
    80004e1c:	00004517          	auipc	a0,0x4
    80004e20:	95c50513          	addi	a0,a0,-1700 # 80008778 <syscalls+0x320>
    80004e24:	00001097          	auipc	ra,0x1
    80004e28:	1be080e7          	jalr	446(ra) # 80005fe2 <panic>
    dp->nlink--;
    80004e2c:	04a4d783          	lhu	a5,74(s1)
    80004e30:	37fd                	addiw	a5,a5,-1
    80004e32:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004e36:	8526                	mv	a0,s1
    80004e38:	ffffe097          	auipc	ra,0xffffe
    80004e3c:	fc6080e7          	jalr	-58(ra) # 80002dfe <iupdate>
    80004e40:	b781                	j	80004d80 <sys_unlink+0xe0>
    return -1;
    80004e42:	557d                	li	a0,-1
    80004e44:	a005                	j	80004e64 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004e46:	854a                	mv	a0,s2
    80004e48:	ffffe097          	auipc	ra,0xffffe
    80004e4c:	2e2080e7          	jalr	738(ra) # 8000312a <iunlockput>
  iunlockput(dp);
    80004e50:	8526                	mv	a0,s1
    80004e52:	ffffe097          	auipc	ra,0xffffe
    80004e56:	2d8080e7          	jalr	728(ra) # 8000312a <iunlockput>
  end_op();
    80004e5a:	fffff097          	auipc	ra,0xfffff
    80004e5e:	ab0080e7          	jalr	-1360(ra) # 8000390a <end_op>
  return -1;
    80004e62:	557d                	li	a0,-1
}
    80004e64:	70ae                	ld	ra,232(sp)
    80004e66:	740e                	ld	s0,224(sp)
    80004e68:	64ee                	ld	s1,216(sp)
    80004e6a:	694e                	ld	s2,208(sp)
    80004e6c:	69ae                	ld	s3,200(sp)
    80004e6e:	616d                	addi	sp,sp,240
    80004e70:	8082                	ret

0000000080004e72 <sys_open>:

uint64
sys_open(void)
{
    80004e72:	7131                	addi	sp,sp,-192
    80004e74:	fd06                	sd	ra,184(sp)
    80004e76:	f922                	sd	s0,176(sp)
    80004e78:	f526                	sd	s1,168(sp)
    80004e7a:	f14a                	sd	s2,160(sp)
    80004e7c:	ed4e                	sd	s3,152(sp)
    80004e7e:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004e80:	f4c40593          	addi	a1,s0,-180
    80004e84:	4505                	li	a0,1
    80004e86:	ffffd097          	auipc	ra,0xffffd
    80004e8a:	488080e7          	jalr	1160(ra) # 8000230e <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004e8e:	08000613          	li	a2,128
    80004e92:	f5040593          	addi	a1,s0,-176
    80004e96:	4501                	li	a0,0
    80004e98:	ffffd097          	auipc	ra,0xffffd
    80004e9c:	4b6080e7          	jalr	1206(ra) # 8000234e <argstr>
    80004ea0:	87aa                	mv	a5,a0
    return -1;
    80004ea2:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004ea4:	0a07c963          	bltz	a5,80004f56 <sys_open+0xe4>

  begin_op();
    80004ea8:	fffff097          	auipc	ra,0xfffff
    80004eac:	9e2080e7          	jalr	-1566(ra) # 8000388a <begin_op>

  if(omode & O_CREATE){
    80004eb0:	f4c42783          	lw	a5,-180(s0)
    80004eb4:	2007f793          	andi	a5,a5,512
    80004eb8:	cfc5                	beqz	a5,80004f70 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004eba:	4681                	li	a3,0
    80004ebc:	4601                	li	a2,0
    80004ebe:	4589                	li	a1,2
    80004ec0:	f5040513          	addi	a0,s0,-176
    80004ec4:	00000097          	auipc	ra,0x0
    80004ec8:	974080e7          	jalr	-1676(ra) # 80004838 <create>
    80004ecc:	84aa                	mv	s1,a0
    if(ip == 0){
    80004ece:	c959                	beqz	a0,80004f64 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004ed0:	04449703          	lh	a4,68(s1)
    80004ed4:	478d                	li	a5,3
    80004ed6:	00f71763          	bne	a4,a5,80004ee4 <sys_open+0x72>
    80004eda:	0464d703          	lhu	a4,70(s1)
    80004ede:	47a5                	li	a5,9
    80004ee0:	0ce7ed63          	bltu	a5,a4,80004fba <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004ee4:	fffff097          	auipc	ra,0xfffff
    80004ee8:	db6080e7          	jalr	-586(ra) # 80003c9a <filealloc>
    80004eec:	89aa                	mv	s3,a0
    80004eee:	10050363          	beqz	a0,80004ff4 <sys_open+0x182>
    80004ef2:	00000097          	auipc	ra,0x0
    80004ef6:	904080e7          	jalr	-1788(ra) # 800047f6 <fdalloc>
    80004efa:	892a                	mv	s2,a0
    80004efc:	0e054763          	bltz	a0,80004fea <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004f00:	04449703          	lh	a4,68(s1)
    80004f04:	478d                	li	a5,3
    80004f06:	0cf70563          	beq	a4,a5,80004fd0 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004f0a:	4789                	li	a5,2
    80004f0c:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004f10:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004f14:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004f18:	f4c42783          	lw	a5,-180(s0)
    80004f1c:	0017c713          	xori	a4,a5,1
    80004f20:	8b05                	andi	a4,a4,1
    80004f22:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004f26:	0037f713          	andi	a4,a5,3
    80004f2a:	00e03733          	snez	a4,a4
    80004f2e:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004f32:	4007f793          	andi	a5,a5,1024
    80004f36:	c791                	beqz	a5,80004f42 <sys_open+0xd0>
    80004f38:	04449703          	lh	a4,68(s1)
    80004f3c:	4789                	li	a5,2
    80004f3e:	0af70063          	beq	a4,a5,80004fde <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004f42:	8526                	mv	a0,s1
    80004f44:	ffffe097          	auipc	ra,0xffffe
    80004f48:	046080e7          	jalr	70(ra) # 80002f8a <iunlock>
  end_op();
    80004f4c:	fffff097          	auipc	ra,0xfffff
    80004f50:	9be080e7          	jalr	-1602(ra) # 8000390a <end_op>

  return fd;
    80004f54:	854a                	mv	a0,s2
}
    80004f56:	70ea                	ld	ra,184(sp)
    80004f58:	744a                	ld	s0,176(sp)
    80004f5a:	74aa                	ld	s1,168(sp)
    80004f5c:	790a                	ld	s2,160(sp)
    80004f5e:	69ea                	ld	s3,152(sp)
    80004f60:	6129                	addi	sp,sp,192
    80004f62:	8082                	ret
      end_op();
    80004f64:	fffff097          	auipc	ra,0xfffff
    80004f68:	9a6080e7          	jalr	-1626(ra) # 8000390a <end_op>
      return -1;
    80004f6c:	557d                	li	a0,-1
    80004f6e:	b7e5                	j	80004f56 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004f70:	f5040513          	addi	a0,s0,-176
    80004f74:	ffffe097          	auipc	ra,0xffffe
    80004f78:	6fa080e7          	jalr	1786(ra) # 8000366e <namei>
    80004f7c:	84aa                	mv	s1,a0
    80004f7e:	c905                	beqz	a0,80004fae <sys_open+0x13c>
    ilock(ip);
    80004f80:	ffffe097          	auipc	ra,0xffffe
    80004f84:	f48080e7          	jalr	-184(ra) # 80002ec8 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004f88:	04449703          	lh	a4,68(s1)
    80004f8c:	4785                	li	a5,1
    80004f8e:	f4f711e3          	bne	a4,a5,80004ed0 <sys_open+0x5e>
    80004f92:	f4c42783          	lw	a5,-180(s0)
    80004f96:	d7b9                	beqz	a5,80004ee4 <sys_open+0x72>
      iunlockput(ip);
    80004f98:	8526                	mv	a0,s1
    80004f9a:	ffffe097          	auipc	ra,0xffffe
    80004f9e:	190080e7          	jalr	400(ra) # 8000312a <iunlockput>
      end_op();
    80004fa2:	fffff097          	auipc	ra,0xfffff
    80004fa6:	968080e7          	jalr	-1688(ra) # 8000390a <end_op>
      return -1;
    80004faa:	557d                	li	a0,-1
    80004fac:	b76d                	j	80004f56 <sys_open+0xe4>
      end_op();
    80004fae:	fffff097          	auipc	ra,0xfffff
    80004fb2:	95c080e7          	jalr	-1700(ra) # 8000390a <end_op>
      return -1;
    80004fb6:	557d                	li	a0,-1
    80004fb8:	bf79                	j	80004f56 <sys_open+0xe4>
    iunlockput(ip);
    80004fba:	8526                	mv	a0,s1
    80004fbc:	ffffe097          	auipc	ra,0xffffe
    80004fc0:	16e080e7          	jalr	366(ra) # 8000312a <iunlockput>
    end_op();
    80004fc4:	fffff097          	auipc	ra,0xfffff
    80004fc8:	946080e7          	jalr	-1722(ra) # 8000390a <end_op>
    return -1;
    80004fcc:	557d                	li	a0,-1
    80004fce:	b761                	j	80004f56 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004fd0:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004fd4:	04649783          	lh	a5,70(s1)
    80004fd8:	02f99223          	sh	a5,36(s3)
    80004fdc:	bf25                	j	80004f14 <sys_open+0xa2>
    itrunc(ip);
    80004fde:	8526                	mv	a0,s1
    80004fe0:	ffffe097          	auipc	ra,0xffffe
    80004fe4:	ff6080e7          	jalr	-10(ra) # 80002fd6 <itrunc>
    80004fe8:	bfa9                	j	80004f42 <sys_open+0xd0>
      fileclose(f);
    80004fea:	854e                	mv	a0,s3
    80004fec:	fffff097          	auipc	ra,0xfffff
    80004ff0:	d6a080e7          	jalr	-662(ra) # 80003d56 <fileclose>
    iunlockput(ip);
    80004ff4:	8526                	mv	a0,s1
    80004ff6:	ffffe097          	auipc	ra,0xffffe
    80004ffa:	134080e7          	jalr	308(ra) # 8000312a <iunlockput>
    end_op();
    80004ffe:	fffff097          	auipc	ra,0xfffff
    80005002:	90c080e7          	jalr	-1780(ra) # 8000390a <end_op>
    return -1;
    80005006:	557d                	li	a0,-1
    80005008:	b7b9                	j	80004f56 <sys_open+0xe4>

000000008000500a <sys_mkdir>:

uint64
sys_mkdir(void)
{
    8000500a:	7175                	addi	sp,sp,-144
    8000500c:	e506                	sd	ra,136(sp)
    8000500e:	e122                	sd	s0,128(sp)
    80005010:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005012:	fffff097          	auipc	ra,0xfffff
    80005016:	878080e7          	jalr	-1928(ra) # 8000388a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    8000501a:	08000613          	li	a2,128
    8000501e:	f7040593          	addi	a1,s0,-144
    80005022:	4501                	li	a0,0
    80005024:	ffffd097          	auipc	ra,0xffffd
    80005028:	32a080e7          	jalr	810(ra) # 8000234e <argstr>
    8000502c:	02054963          	bltz	a0,8000505e <sys_mkdir+0x54>
    80005030:	4681                	li	a3,0
    80005032:	4601                	li	a2,0
    80005034:	4585                	li	a1,1
    80005036:	f7040513          	addi	a0,s0,-144
    8000503a:	fffff097          	auipc	ra,0xfffff
    8000503e:	7fe080e7          	jalr	2046(ra) # 80004838 <create>
    80005042:	cd11                	beqz	a0,8000505e <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005044:	ffffe097          	auipc	ra,0xffffe
    80005048:	0e6080e7          	jalr	230(ra) # 8000312a <iunlockput>
  end_op();
    8000504c:	fffff097          	auipc	ra,0xfffff
    80005050:	8be080e7          	jalr	-1858(ra) # 8000390a <end_op>
  return 0;
    80005054:	4501                	li	a0,0
}
    80005056:	60aa                	ld	ra,136(sp)
    80005058:	640a                	ld	s0,128(sp)
    8000505a:	6149                	addi	sp,sp,144
    8000505c:	8082                	ret
    end_op();
    8000505e:	fffff097          	auipc	ra,0xfffff
    80005062:	8ac080e7          	jalr	-1876(ra) # 8000390a <end_op>
    return -1;
    80005066:	557d                	li	a0,-1
    80005068:	b7fd                	j	80005056 <sys_mkdir+0x4c>

000000008000506a <sys_mknod>:

uint64
sys_mknod(void)
{
    8000506a:	7135                	addi	sp,sp,-160
    8000506c:	ed06                	sd	ra,152(sp)
    8000506e:	e922                	sd	s0,144(sp)
    80005070:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005072:	fffff097          	auipc	ra,0xfffff
    80005076:	818080e7          	jalr	-2024(ra) # 8000388a <begin_op>
  argint(1, &major);
    8000507a:	f6c40593          	addi	a1,s0,-148
    8000507e:	4505                	li	a0,1
    80005080:	ffffd097          	auipc	ra,0xffffd
    80005084:	28e080e7          	jalr	654(ra) # 8000230e <argint>
  argint(2, &minor);
    80005088:	f6840593          	addi	a1,s0,-152
    8000508c:	4509                	li	a0,2
    8000508e:	ffffd097          	auipc	ra,0xffffd
    80005092:	280080e7          	jalr	640(ra) # 8000230e <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005096:	08000613          	li	a2,128
    8000509a:	f7040593          	addi	a1,s0,-144
    8000509e:	4501                	li	a0,0
    800050a0:	ffffd097          	auipc	ra,0xffffd
    800050a4:	2ae080e7          	jalr	686(ra) # 8000234e <argstr>
    800050a8:	02054b63          	bltz	a0,800050de <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800050ac:	f6841683          	lh	a3,-152(s0)
    800050b0:	f6c41603          	lh	a2,-148(s0)
    800050b4:	458d                	li	a1,3
    800050b6:	f7040513          	addi	a0,s0,-144
    800050ba:	fffff097          	auipc	ra,0xfffff
    800050be:	77e080e7          	jalr	1918(ra) # 80004838 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800050c2:	cd11                	beqz	a0,800050de <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800050c4:	ffffe097          	auipc	ra,0xffffe
    800050c8:	066080e7          	jalr	102(ra) # 8000312a <iunlockput>
  end_op();
    800050cc:	fffff097          	auipc	ra,0xfffff
    800050d0:	83e080e7          	jalr	-1986(ra) # 8000390a <end_op>
  return 0;
    800050d4:	4501                	li	a0,0
}
    800050d6:	60ea                	ld	ra,152(sp)
    800050d8:	644a                	ld	s0,144(sp)
    800050da:	610d                	addi	sp,sp,160
    800050dc:	8082                	ret
    end_op();
    800050de:	fffff097          	auipc	ra,0xfffff
    800050e2:	82c080e7          	jalr	-2004(ra) # 8000390a <end_op>
    return -1;
    800050e6:	557d                	li	a0,-1
    800050e8:	b7fd                	j	800050d6 <sys_mknod+0x6c>

00000000800050ea <sys_chdir>:

uint64
sys_chdir(void)
{
    800050ea:	7135                	addi	sp,sp,-160
    800050ec:	ed06                	sd	ra,152(sp)
    800050ee:	e922                	sd	s0,144(sp)
    800050f0:	e526                	sd	s1,136(sp)
    800050f2:	e14a                	sd	s2,128(sp)
    800050f4:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800050f6:	ffffc097          	auipc	ra,0xffffc
    800050fa:	f5c080e7          	jalr	-164(ra) # 80001052 <myproc>
    800050fe:	892a                	mv	s2,a0
  
  begin_op();
    80005100:	ffffe097          	auipc	ra,0xffffe
    80005104:	78a080e7          	jalr	1930(ra) # 8000388a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005108:	08000613          	li	a2,128
    8000510c:	f6040593          	addi	a1,s0,-160
    80005110:	4501                	li	a0,0
    80005112:	ffffd097          	auipc	ra,0xffffd
    80005116:	23c080e7          	jalr	572(ra) # 8000234e <argstr>
    8000511a:	04054b63          	bltz	a0,80005170 <sys_chdir+0x86>
    8000511e:	f6040513          	addi	a0,s0,-160
    80005122:	ffffe097          	auipc	ra,0xffffe
    80005126:	54c080e7          	jalr	1356(ra) # 8000366e <namei>
    8000512a:	84aa                	mv	s1,a0
    8000512c:	c131                	beqz	a0,80005170 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    8000512e:	ffffe097          	auipc	ra,0xffffe
    80005132:	d9a080e7          	jalr	-614(ra) # 80002ec8 <ilock>
  if(ip->type != T_DIR){
    80005136:	04449703          	lh	a4,68(s1)
    8000513a:	4785                	li	a5,1
    8000513c:	04f71063          	bne	a4,a5,8000517c <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005140:	8526                	mv	a0,s1
    80005142:	ffffe097          	auipc	ra,0xffffe
    80005146:	e48080e7          	jalr	-440(ra) # 80002f8a <iunlock>
  iput(p->cwd);
    8000514a:	15093503          	ld	a0,336(s2)
    8000514e:	ffffe097          	auipc	ra,0xffffe
    80005152:	f34080e7          	jalr	-204(ra) # 80003082 <iput>
  end_op();
    80005156:	ffffe097          	auipc	ra,0xffffe
    8000515a:	7b4080e7          	jalr	1972(ra) # 8000390a <end_op>
  p->cwd = ip;
    8000515e:	14993823          	sd	s1,336(s2)
  return 0;
    80005162:	4501                	li	a0,0
}
    80005164:	60ea                	ld	ra,152(sp)
    80005166:	644a                	ld	s0,144(sp)
    80005168:	64aa                	ld	s1,136(sp)
    8000516a:	690a                	ld	s2,128(sp)
    8000516c:	610d                	addi	sp,sp,160
    8000516e:	8082                	ret
    end_op();
    80005170:	ffffe097          	auipc	ra,0xffffe
    80005174:	79a080e7          	jalr	1946(ra) # 8000390a <end_op>
    return -1;
    80005178:	557d                	li	a0,-1
    8000517a:	b7ed                	j	80005164 <sys_chdir+0x7a>
    iunlockput(ip);
    8000517c:	8526                	mv	a0,s1
    8000517e:	ffffe097          	auipc	ra,0xffffe
    80005182:	fac080e7          	jalr	-84(ra) # 8000312a <iunlockput>
    end_op();
    80005186:	ffffe097          	auipc	ra,0xffffe
    8000518a:	784080e7          	jalr	1924(ra) # 8000390a <end_op>
    return -1;
    8000518e:	557d                	li	a0,-1
    80005190:	bfd1                	j	80005164 <sys_chdir+0x7a>

0000000080005192 <sys_exec>:

uint64
sys_exec(void)
{
    80005192:	7145                	addi	sp,sp,-464
    80005194:	e786                	sd	ra,456(sp)
    80005196:	e3a2                	sd	s0,448(sp)
    80005198:	ff26                	sd	s1,440(sp)
    8000519a:	fb4a                	sd	s2,432(sp)
    8000519c:	f74e                	sd	s3,424(sp)
    8000519e:	f352                	sd	s4,416(sp)
    800051a0:	ef56                	sd	s5,408(sp)
    800051a2:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800051a4:	e3840593          	addi	a1,s0,-456
    800051a8:	4505                	li	a0,1
    800051aa:	ffffd097          	auipc	ra,0xffffd
    800051ae:	184080e7          	jalr	388(ra) # 8000232e <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800051b2:	08000613          	li	a2,128
    800051b6:	f4040593          	addi	a1,s0,-192
    800051ba:	4501                	li	a0,0
    800051bc:	ffffd097          	auipc	ra,0xffffd
    800051c0:	192080e7          	jalr	402(ra) # 8000234e <argstr>
    800051c4:	87aa                	mv	a5,a0
    return -1;
    800051c6:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800051c8:	0c07c263          	bltz	a5,8000528c <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    800051cc:	10000613          	li	a2,256
    800051d0:	4581                	li	a1,0
    800051d2:	e4040513          	addi	a0,s0,-448
    800051d6:	ffffb097          	auipc	ra,0xffffb
    800051da:	fa2080e7          	jalr	-94(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800051de:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    800051e2:	89a6                	mv	s3,s1
    800051e4:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800051e6:	02000a13          	li	s4,32
    800051ea:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800051ee:	00391513          	slli	a0,s2,0x3
    800051f2:	e3040593          	addi	a1,s0,-464
    800051f6:	e3843783          	ld	a5,-456(s0)
    800051fa:	953e                	add	a0,a0,a5
    800051fc:	ffffd097          	auipc	ra,0xffffd
    80005200:	074080e7          	jalr	116(ra) # 80002270 <fetchaddr>
    80005204:	02054a63          	bltz	a0,80005238 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80005208:	e3043783          	ld	a5,-464(s0)
    8000520c:	c3b9                	beqz	a5,80005252 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000520e:	ffffb097          	auipc	ra,0xffffb
    80005212:	f0a080e7          	jalr	-246(ra) # 80000118 <kalloc>
    80005216:	85aa                	mv	a1,a0
    80005218:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000521c:	cd11                	beqz	a0,80005238 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000521e:	6605                	lui	a2,0x1
    80005220:	e3043503          	ld	a0,-464(s0)
    80005224:	ffffd097          	auipc	ra,0xffffd
    80005228:	09e080e7          	jalr	158(ra) # 800022c2 <fetchstr>
    8000522c:	00054663          	bltz	a0,80005238 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80005230:	0905                	addi	s2,s2,1
    80005232:	09a1                	addi	s3,s3,8
    80005234:	fb491be3          	bne	s2,s4,800051ea <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005238:	10048913          	addi	s2,s1,256
    8000523c:	6088                	ld	a0,0(s1)
    8000523e:	c531                	beqz	a0,8000528a <sys_exec+0xf8>
    kfree(argv[i]);
    80005240:	ffffb097          	auipc	ra,0xffffb
    80005244:	ddc080e7          	jalr	-548(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005248:	04a1                	addi	s1,s1,8
    8000524a:	ff2499e3          	bne	s1,s2,8000523c <sys_exec+0xaa>
  return -1;
    8000524e:	557d                	li	a0,-1
    80005250:	a835                	j	8000528c <sys_exec+0xfa>
      argv[i] = 0;
    80005252:	0a8e                	slli	s5,s5,0x3
    80005254:	fc040793          	addi	a5,s0,-64
    80005258:	9abe                	add	s5,s5,a5
    8000525a:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    8000525e:	e4040593          	addi	a1,s0,-448
    80005262:	f4040513          	addi	a0,s0,-192
    80005266:	fffff097          	auipc	ra,0xfffff
    8000526a:	178080e7          	jalr	376(ra) # 800043de <exec>
    8000526e:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005270:	10048993          	addi	s3,s1,256
    80005274:	6088                	ld	a0,0(s1)
    80005276:	c901                	beqz	a0,80005286 <sys_exec+0xf4>
    kfree(argv[i]);
    80005278:	ffffb097          	auipc	ra,0xffffb
    8000527c:	da4080e7          	jalr	-604(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005280:	04a1                	addi	s1,s1,8
    80005282:	ff3499e3          	bne	s1,s3,80005274 <sys_exec+0xe2>
  return ret;
    80005286:	854a                	mv	a0,s2
    80005288:	a011                	j	8000528c <sys_exec+0xfa>
  return -1;
    8000528a:	557d                	li	a0,-1
}
    8000528c:	60be                	ld	ra,456(sp)
    8000528e:	641e                	ld	s0,448(sp)
    80005290:	74fa                	ld	s1,440(sp)
    80005292:	795a                	ld	s2,432(sp)
    80005294:	79ba                	ld	s3,424(sp)
    80005296:	7a1a                	ld	s4,416(sp)
    80005298:	6afa                	ld	s5,408(sp)
    8000529a:	6179                	addi	sp,sp,464
    8000529c:	8082                	ret

000000008000529e <sys_pipe>:

uint64
sys_pipe(void)
{
    8000529e:	7139                	addi	sp,sp,-64
    800052a0:	fc06                	sd	ra,56(sp)
    800052a2:	f822                	sd	s0,48(sp)
    800052a4:	f426                	sd	s1,40(sp)
    800052a6:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800052a8:	ffffc097          	auipc	ra,0xffffc
    800052ac:	daa080e7          	jalr	-598(ra) # 80001052 <myproc>
    800052b0:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800052b2:	fd840593          	addi	a1,s0,-40
    800052b6:	4501                	li	a0,0
    800052b8:	ffffd097          	auipc	ra,0xffffd
    800052bc:	076080e7          	jalr	118(ra) # 8000232e <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800052c0:	fc840593          	addi	a1,s0,-56
    800052c4:	fd040513          	addi	a0,s0,-48
    800052c8:	fffff097          	auipc	ra,0xfffff
    800052cc:	dbe080e7          	jalr	-578(ra) # 80004086 <pipealloc>
    return -1;
    800052d0:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800052d2:	0c054463          	bltz	a0,8000539a <sys_pipe+0xfc>
  fd0 = -1;
    800052d6:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800052da:	fd043503          	ld	a0,-48(s0)
    800052de:	fffff097          	auipc	ra,0xfffff
    800052e2:	518080e7          	jalr	1304(ra) # 800047f6 <fdalloc>
    800052e6:	fca42223          	sw	a0,-60(s0)
    800052ea:	08054b63          	bltz	a0,80005380 <sys_pipe+0xe2>
    800052ee:	fc843503          	ld	a0,-56(s0)
    800052f2:	fffff097          	auipc	ra,0xfffff
    800052f6:	504080e7          	jalr	1284(ra) # 800047f6 <fdalloc>
    800052fa:	fca42023          	sw	a0,-64(s0)
    800052fe:	06054863          	bltz	a0,8000536e <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005302:	4691                	li	a3,4
    80005304:	fc440613          	addi	a2,s0,-60
    80005308:	fd843583          	ld	a1,-40(s0)
    8000530c:	68a8                	ld	a0,80(s1)
    8000530e:	ffffc097          	auipc	ra,0xffffc
    80005312:	82c080e7          	jalr	-2004(ra) # 80000b3a <copyout>
    80005316:	02054063          	bltz	a0,80005336 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000531a:	4691                	li	a3,4
    8000531c:	fc040613          	addi	a2,s0,-64
    80005320:	fd843583          	ld	a1,-40(s0)
    80005324:	0591                	addi	a1,a1,4
    80005326:	68a8                	ld	a0,80(s1)
    80005328:	ffffc097          	auipc	ra,0xffffc
    8000532c:	812080e7          	jalr	-2030(ra) # 80000b3a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005330:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005332:	06055463          	bgez	a0,8000539a <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005336:	fc442783          	lw	a5,-60(s0)
    8000533a:	07e9                	addi	a5,a5,26
    8000533c:	078e                	slli	a5,a5,0x3
    8000533e:	97a6                	add	a5,a5,s1
    80005340:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005344:	fc042503          	lw	a0,-64(s0)
    80005348:	0569                	addi	a0,a0,26
    8000534a:	050e                	slli	a0,a0,0x3
    8000534c:	94aa                	add	s1,s1,a0
    8000534e:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005352:	fd043503          	ld	a0,-48(s0)
    80005356:	fffff097          	auipc	ra,0xfffff
    8000535a:	a00080e7          	jalr	-1536(ra) # 80003d56 <fileclose>
    fileclose(wf);
    8000535e:	fc843503          	ld	a0,-56(s0)
    80005362:	fffff097          	auipc	ra,0xfffff
    80005366:	9f4080e7          	jalr	-1548(ra) # 80003d56 <fileclose>
    return -1;
    8000536a:	57fd                	li	a5,-1
    8000536c:	a03d                	j	8000539a <sys_pipe+0xfc>
    if(fd0 >= 0)
    8000536e:	fc442783          	lw	a5,-60(s0)
    80005372:	0007c763          	bltz	a5,80005380 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005376:	07e9                	addi	a5,a5,26
    80005378:	078e                	slli	a5,a5,0x3
    8000537a:	94be                	add	s1,s1,a5
    8000537c:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005380:	fd043503          	ld	a0,-48(s0)
    80005384:	fffff097          	auipc	ra,0xfffff
    80005388:	9d2080e7          	jalr	-1582(ra) # 80003d56 <fileclose>
    fileclose(wf);
    8000538c:	fc843503          	ld	a0,-56(s0)
    80005390:	fffff097          	auipc	ra,0xfffff
    80005394:	9c6080e7          	jalr	-1594(ra) # 80003d56 <fileclose>
    return -1;
    80005398:	57fd                	li	a5,-1
}
    8000539a:	853e                	mv	a0,a5
    8000539c:	70e2                	ld	ra,56(sp)
    8000539e:	7442                	ld	s0,48(sp)
    800053a0:	74a2                	ld	s1,40(sp)
    800053a2:	6121                	addi	sp,sp,64
    800053a4:	8082                	ret
	...

00000000800053b0 <kernelvec>:
    800053b0:	7111                	addi	sp,sp,-256
    800053b2:	e006                	sd	ra,0(sp)
    800053b4:	e40a                	sd	sp,8(sp)
    800053b6:	e80e                	sd	gp,16(sp)
    800053b8:	ec12                	sd	tp,24(sp)
    800053ba:	f016                	sd	t0,32(sp)
    800053bc:	f41a                	sd	t1,40(sp)
    800053be:	f81e                	sd	t2,48(sp)
    800053c0:	fc22                	sd	s0,56(sp)
    800053c2:	e0a6                	sd	s1,64(sp)
    800053c4:	e4aa                	sd	a0,72(sp)
    800053c6:	e8ae                	sd	a1,80(sp)
    800053c8:	ecb2                	sd	a2,88(sp)
    800053ca:	f0b6                	sd	a3,96(sp)
    800053cc:	f4ba                	sd	a4,104(sp)
    800053ce:	f8be                	sd	a5,112(sp)
    800053d0:	fcc2                	sd	a6,120(sp)
    800053d2:	e146                	sd	a7,128(sp)
    800053d4:	e54a                	sd	s2,136(sp)
    800053d6:	e94e                	sd	s3,144(sp)
    800053d8:	ed52                	sd	s4,152(sp)
    800053da:	f156                	sd	s5,160(sp)
    800053dc:	f55a                	sd	s6,168(sp)
    800053de:	f95e                	sd	s7,176(sp)
    800053e0:	fd62                	sd	s8,184(sp)
    800053e2:	e1e6                	sd	s9,192(sp)
    800053e4:	e5ea                	sd	s10,200(sp)
    800053e6:	e9ee                	sd	s11,208(sp)
    800053e8:	edf2                	sd	t3,216(sp)
    800053ea:	f1f6                	sd	t4,224(sp)
    800053ec:	f5fa                	sd	t5,232(sp)
    800053ee:	f9fe                	sd	t6,240(sp)
    800053f0:	d4dfc0ef          	jal	ra,8000213c <kerneltrap>
    800053f4:	6082                	ld	ra,0(sp)
    800053f6:	6122                	ld	sp,8(sp)
    800053f8:	61c2                	ld	gp,16(sp)
    800053fa:	7282                	ld	t0,32(sp)
    800053fc:	7322                	ld	t1,40(sp)
    800053fe:	73c2                	ld	t2,48(sp)
    80005400:	7462                	ld	s0,56(sp)
    80005402:	6486                	ld	s1,64(sp)
    80005404:	6526                	ld	a0,72(sp)
    80005406:	65c6                	ld	a1,80(sp)
    80005408:	6666                	ld	a2,88(sp)
    8000540a:	7686                	ld	a3,96(sp)
    8000540c:	7726                	ld	a4,104(sp)
    8000540e:	77c6                	ld	a5,112(sp)
    80005410:	7866                	ld	a6,120(sp)
    80005412:	688a                	ld	a7,128(sp)
    80005414:	692a                	ld	s2,136(sp)
    80005416:	69ca                	ld	s3,144(sp)
    80005418:	6a6a                	ld	s4,152(sp)
    8000541a:	7a8a                	ld	s5,160(sp)
    8000541c:	7b2a                	ld	s6,168(sp)
    8000541e:	7bca                	ld	s7,176(sp)
    80005420:	7c6a                	ld	s8,184(sp)
    80005422:	6c8e                	ld	s9,192(sp)
    80005424:	6d2e                	ld	s10,200(sp)
    80005426:	6dce                	ld	s11,208(sp)
    80005428:	6e6e                	ld	t3,216(sp)
    8000542a:	7e8e                	ld	t4,224(sp)
    8000542c:	7f2e                	ld	t5,232(sp)
    8000542e:	7fce                	ld	t6,240(sp)
    80005430:	6111                	addi	sp,sp,256
    80005432:	10200073          	sret
    80005436:	00000013          	nop
    8000543a:	00000013          	nop
    8000543e:	0001                	nop

0000000080005440 <timervec>:
    80005440:	34051573          	csrrw	a0,mscratch,a0
    80005444:	e10c                	sd	a1,0(a0)
    80005446:	e510                	sd	a2,8(a0)
    80005448:	e914                	sd	a3,16(a0)
    8000544a:	6d0c                	ld	a1,24(a0)
    8000544c:	7110                	ld	a2,32(a0)
    8000544e:	6194                	ld	a3,0(a1)
    80005450:	96b2                	add	a3,a3,a2
    80005452:	e194                	sd	a3,0(a1)
    80005454:	4589                	li	a1,2
    80005456:	14459073          	csrw	sip,a1
    8000545a:	6914                	ld	a3,16(a0)
    8000545c:	6510                	ld	a2,8(a0)
    8000545e:	610c                	ld	a1,0(a0)
    80005460:	34051573          	csrrw	a0,mscratch,a0
    80005464:	30200073          	mret
	...

000000008000546a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000546a:	1141                	addi	sp,sp,-16
    8000546c:	e422                	sd	s0,8(sp)
    8000546e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005470:	0c0007b7          	lui	a5,0xc000
    80005474:	4705                	li	a4,1
    80005476:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005478:	c3d8                	sw	a4,4(a5)
}
    8000547a:	6422                	ld	s0,8(sp)
    8000547c:	0141                	addi	sp,sp,16
    8000547e:	8082                	ret

0000000080005480 <plicinithart>:

void
plicinithart(void)
{
    80005480:	1141                	addi	sp,sp,-16
    80005482:	e406                	sd	ra,8(sp)
    80005484:	e022                	sd	s0,0(sp)
    80005486:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005488:	ffffc097          	auipc	ra,0xffffc
    8000548c:	b9e080e7          	jalr	-1122(ra) # 80001026 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005490:	0085171b          	slliw	a4,a0,0x8
    80005494:	0c0027b7          	lui	a5,0xc002
    80005498:	97ba                	add	a5,a5,a4
    8000549a:	40200713          	li	a4,1026
    8000549e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800054a2:	00d5151b          	slliw	a0,a0,0xd
    800054a6:	0c2017b7          	lui	a5,0xc201
    800054aa:	953e                	add	a0,a0,a5
    800054ac:	00052023          	sw	zero,0(a0)
}
    800054b0:	60a2                	ld	ra,8(sp)
    800054b2:	6402                	ld	s0,0(sp)
    800054b4:	0141                	addi	sp,sp,16
    800054b6:	8082                	ret

00000000800054b8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800054b8:	1141                	addi	sp,sp,-16
    800054ba:	e406                	sd	ra,8(sp)
    800054bc:	e022                	sd	s0,0(sp)
    800054be:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800054c0:	ffffc097          	auipc	ra,0xffffc
    800054c4:	b66080e7          	jalr	-1178(ra) # 80001026 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800054c8:	00d5179b          	slliw	a5,a0,0xd
    800054cc:	0c201537          	lui	a0,0xc201
    800054d0:	953e                	add	a0,a0,a5
  return irq;
}
    800054d2:	4148                	lw	a0,4(a0)
    800054d4:	60a2                	ld	ra,8(sp)
    800054d6:	6402                	ld	s0,0(sp)
    800054d8:	0141                	addi	sp,sp,16
    800054da:	8082                	ret

00000000800054dc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800054dc:	1101                	addi	sp,sp,-32
    800054de:	ec06                	sd	ra,24(sp)
    800054e0:	e822                	sd	s0,16(sp)
    800054e2:	e426                	sd	s1,8(sp)
    800054e4:	1000                	addi	s0,sp,32
    800054e6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800054e8:	ffffc097          	auipc	ra,0xffffc
    800054ec:	b3e080e7          	jalr	-1218(ra) # 80001026 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800054f0:	00d5151b          	slliw	a0,a0,0xd
    800054f4:	0c2017b7          	lui	a5,0xc201
    800054f8:	97aa                	add	a5,a5,a0
    800054fa:	c3c4                	sw	s1,4(a5)
}
    800054fc:	60e2                	ld	ra,24(sp)
    800054fe:	6442                	ld	s0,16(sp)
    80005500:	64a2                	ld	s1,8(sp)
    80005502:	6105                	addi	sp,sp,32
    80005504:	8082                	ret

0000000080005506 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005506:	1141                	addi	sp,sp,-16
    80005508:	e406                	sd	ra,8(sp)
    8000550a:	e022                	sd	s0,0(sp)
    8000550c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000550e:	479d                	li	a5,7
    80005510:	04a7cc63          	blt	a5,a0,80005568 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005514:	00014797          	auipc	a5,0x14
    80005518:	78c78793          	addi	a5,a5,1932 # 80019ca0 <disk>
    8000551c:	97aa                	add	a5,a5,a0
    8000551e:	0187c783          	lbu	a5,24(a5)
    80005522:	ebb9                	bnez	a5,80005578 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005524:	00451613          	slli	a2,a0,0x4
    80005528:	00014797          	auipc	a5,0x14
    8000552c:	77878793          	addi	a5,a5,1912 # 80019ca0 <disk>
    80005530:	6394                	ld	a3,0(a5)
    80005532:	96b2                	add	a3,a3,a2
    80005534:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005538:	6398                	ld	a4,0(a5)
    8000553a:	9732                	add	a4,a4,a2
    8000553c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005540:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005544:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005548:	953e                	add	a0,a0,a5
    8000554a:	4785                	li	a5,1
    8000554c:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    80005550:	00014517          	auipc	a0,0x14
    80005554:	76850513          	addi	a0,a0,1896 # 80019cb8 <disk+0x18>
    80005558:	ffffc097          	auipc	ra,0xffffc
    8000555c:	29e080e7          	jalr	670(ra) # 800017f6 <wakeup>
}
    80005560:	60a2                	ld	ra,8(sp)
    80005562:	6402                	ld	s0,0(sp)
    80005564:	0141                	addi	sp,sp,16
    80005566:	8082                	ret
    panic("free_desc 1");
    80005568:	00003517          	auipc	a0,0x3
    8000556c:	22050513          	addi	a0,a0,544 # 80008788 <syscalls+0x330>
    80005570:	00001097          	auipc	ra,0x1
    80005574:	a72080e7          	jalr	-1422(ra) # 80005fe2 <panic>
    panic("free_desc 2");
    80005578:	00003517          	auipc	a0,0x3
    8000557c:	22050513          	addi	a0,a0,544 # 80008798 <syscalls+0x340>
    80005580:	00001097          	auipc	ra,0x1
    80005584:	a62080e7          	jalr	-1438(ra) # 80005fe2 <panic>

0000000080005588 <virtio_disk_init>:
{
    80005588:	1101                	addi	sp,sp,-32
    8000558a:	ec06                	sd	ra,24(sp)
    8000558c:	e822                	sd	s0,16(sp)
    8000558e:	e426                	sd	s1,8(sp)
    80005590:	e04a                	sd	s2,0(sp)
    80005592:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005594:	00003597          	auipc	a1,0x3
    80005598:	21458593          	addi	a1,a1,532 # 800087a8 <syscalls+0x350>
    8000559c:	00015517          	auipc	a0,0x15
    800055a0:	82c50513          	addi	a0,a0,-2004 # 80019dc8 <disk+0x128>
    800055a4:	00001097          	auipc	ra,0x1
    800055a8:	ef8080e7          	jalr	-264(ra) # 8000649c <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800055ac:	100017b7          	lui	a5,0x10001
    800055b0:	4398                	lw	a4,0(a5)
    800055b2:	2701                	sext.w	a4,a4
    800055b4:	747277b7          	lui	a5,0x74727
    800055b8:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800055bc:	14f71e63          	bne	a4,a5,80005718 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800055c0:	100017b7          	lui	a5,0x10001
    800055c4:	43dc                	lw	a5,4(a5)
    800055c6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800055c8:	4709                	li	a4,2
    800055ca:	14e79763          	bne	a5,a4,80005718 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800055ce:	100017b7          	lui	a5,0x10001
    800055d2:	479c                	lw	a5,8(a5)
    800055d4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800055d6:	14e79163          	bne	a5,a4,80005718 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800055da:	100017b7          	lui	a5,0x10001
    800055de:	47d8                	lw	a4,12(a5)
    800055e0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800055e2:	554d47b7          	lui	a5,0x554d4
    800055e6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800055ea:	12f71763          	bne	a4,a5,80005718 <virtio_disk_init+0x190>
  *R(VIRTIO_MMIO_STATUS) = status;
    800055ee:	100017b7          	lui	a5,0x10001
    800055f2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800055f6:	4705                	li	a4,1
    800055f8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800055fa:	470d                	li	a4,3
    800055fc:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800055fe:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005600:	c7ffe737          	lui	a4,0xc7ffe
    80005604:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc73f>
    80005608:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000560a:	2701                	sext.w	a4,a4
    8000560c:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000560e:	472d                	li	a4,11
    80005610:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005612:	0707a903          	lw	s2,112(a5)
    80005616:	2901                	sext.w	s2,s2
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005618:	00897793          	andi	a5,s2,8
    8000561c:	10078663          	beqz	a5,80005728 <virtio_disk_init+0x1a0>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005620:	100017b7          	lui	a5,0x10001
    80005624:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005628:	43fc                	lw	a5,68(a5)
    8000562a:	2781                	sext.w	a5,a5
    8000562c:	10079663          	bnez	a5,80005738 <virtio_disk_init+0x1b0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005630:	100017b7          	lui	a5,0x10001
    80005634:	5bdc                	lw	a5,52(a5)
    80005636:	2781                	sext.w	a5,a5
  if(max == 0)
    80005638:	10078863          	beqz	a5,80005748 <virtio_disk_init+0x1c0>
  if(max < NUM)
    8000563c:	471d                	li	a4,7
    8000563e:	10f77d63          	bgeu	a4,a5,80005758 <virtio_disk_init+0x1d0>
  disk.desc = kalloc();
    80005642:	ffffb097          	auipc	ra,0xffffb
    80005646:	ad6080e7          	jalr	-1322(ra) # 80000118 <kalloc>
    8000564a:	00014497          	auipc	s1,0x14
    8000564e:	65648493          	addi	s1,s1,1622 # 80019ca0 <disk>
    80005652:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005654:	ffffb097          	auipc	ra,0xffffb
    80005658:	ac4080e7          	jalr	-1340(ra) # 80000118 <kalloc>
    8000565c:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000565e:	ffffb097          	auipc	ra,0xffffb
    80005662:	aba080e7          	jalr	-1350(ra) # 80000118 <kalloc>
    80005666:	87aa                	mv	a5,a0
    80005668:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    8000566a:	6088                	ld	a0,0(s1)
    8000566c:	cd75                	beqz	a0,80005768 <virtio_disk_init+0x1e0>
    8000566e:	00014717          	auipc	a4,0x14
    80005672:	63a73703          	ld	a4,1594(a4) # 80019ca8 <disk+0x8>
    80005676:	cb6d                	beqz	a4,80005768 <virtio_disk_init+0x1e0>
    80005678:	cbe5                	beqz	a5,80005768 <virtio_disk_init+0x1e0>
  memset(disk.desc, 0, PGSIZE);
    8000567a:	6605                	lui	a2,0x1
    8000567c:	4581                	li	a1,0
    8000567e:	ffffb097          	auipc	ra,0xffffb
    80005682:	afa080e7          	jalr	-1286(ra) # 80000178 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005686:	00014497          	auipc	s1,0x14
    8000568a:	61a48493          	addi	s1,s1,1562 # 80019ca0 <disk>
    8000568e:	6605                	lui	a2,0x1
    80005690:	4581                	li	a1,0
    80005692:	6488                	ld	a0,8(s1)
    80005694:	ffffb097          	auipc	ra,0xffffb
    80005698:	ae4080e7          	jalr	-1308(ra) # 80000178 <memset>
  memset(disk.used, 0, PGSIZE);
    8000569c:	6605                	lui	a2,0x1
    8000569e:	4581                	li	a1,0
    800056a0:	6888                	ld	a0,16(s1)
    800056a2:	ffffb097          	auipc	ra,0xffffb
    800056a6:	ad6080e7          	jalr	-1322(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800056aa:	100017b7          	lui	a5,0x10001
    800056ae:	4721                	li	a4,8
    800056b0:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800056b2:	4098                	lw	a4,0(s1)
    800056b4:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800056b8:	40d8                	lw	a4,4(s1)
    800056ba:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800056be:	6498                	ld	a4,8(s1)
    800056c0:	0007069b          	sext.w	a3,a4
    800056c4:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800056c8:	9701                	srai	a4,a4,0x20
    800056ca:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800056ce:	6898                	ld	a4,16(s1)
    800056d0:	0007069b          	sext.w	a3,a4
    800056d4:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800056d8:	9701                	srai	a4,a4,0x20
    800056da:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800056de:	4685                	li	a3,1
    800056e0:	c3f4                	sw	a3,68(a5)
    disk.free[i] = 1;
    800056e2:	4705                	li	a4,1
    800056e4:	00d48c23          	sb	a3,24(s1)
    800056e8:	00e48ca3          	sb	a4,25(s1)
    800056ec:	00e48d23          	sb	a4,26(s1)
    800056f0:	00e48da3          	sb	a4,27(s1)
    800056f4:	00e48e23          	sb	a4,28(s1)
    800056f8:	00e48ea3          	sb	a4,29(s1)
    800056fc:	00e48f23          	sb	a4,30(s1)
    80005700:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005704:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005708:	0727a823          	sw	s2,112(a5)
}
    8000570c:	60e2                	ld	ra,24(sp)
    8000570e:	6442                	ld	s0,16(sp)
    80005710:	64a2                	ld	s1,8(sp)
    80005712:	6902                	ld	s2,0(sp)
    80005714:	6105                	addi	sp,sp,32
    80005716:	8082                	ret
    panic("could not find virtio disk");
    80005718:	00003517          	auipc	a0,0x3
    8000571c:	0a050513          	addi	a0,a0,160 # 800087b8 <syscalls+0x360>
    80005720:	00001097          	auipc	ra,0x1
    80005724:	8c2080e7          	jalr	-1854(ra) # 80005fe2 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005728:	00003517          	auipc	a0,0x3
    8000572c:	0b050513          	addi	a0,a0,176 # 800087d8 <syscalls+0x380>
    80005730:	00001097          	auipc	ra,0x1
    80005734:	8b2080e7          	jalr	-1870(ra) # 80005fe2 <panic>
    panic("virtio disk should not be ready");
    80005738:	00003517          	auipc	a0,0x3
    8000573c:	0c050513          	addi	a0,a0,192 # 800087f8 <syscalls+0x3a0>
    80005740:	00001097          	auipc	ra,0x1
    80005744:	8a2080e7          	jalr	-1886(ra) # 80005fe2 <panic>
    panic("virtio disk has no queue 0");
    80005748:	00003517          	auipc	a0,0x3
    8000574c:	0d050513          	addi	a0,a0,208 # 80008818 <syscalls+0x3c0>
    80005750:	00001097          	auipc	ra,0x1
    80005754:	892080e7          	jalr	-1902(ra) # 80005fe2 <panic>
    panic("virtio disk max queue too short");
    80005758:	00003517          	auipc	a0,0x3
    8000575c:	0e050513          	addi	a0,a0,224 # 80008838 <syscalls+0x3e0>
    80005760:	00001097          	auipc	ra,0x1
    80005764:	882080e7          	jalr	-1918(ra) # 80005fe2 <panic>
    panic("virtio disk kalloc");
    80005768:	00003517          	auipc	a0,0x3
    8000576c:	0f050513          	addi	a0,a0,240 # 80008858 <syscalls+0x400>
    80005770:	00001097          	auipc	ra,0x1
    80005774:	872080e7          	jalr	-1934(ra) # 80005fe2 <panic>

0000000080005778 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005778:	7159                	addi	sp,sp,-112
    8000577a:	f486                	sd	ra,104(sp)
    8000577c:	f0a2                	sd	s0,96(sp)
    8000577e:	eca6                	sd	s1,88(sp)
    80005780:	e8ca                	sd	s2,80(sp)
    80005782:	e4ce                	sd	s3,72(sp)
    80005784:	e0d2                	sd	s4,64(sp)
    80005786:	fc56                	sd	s5,56(sp)
    80005788:	f85a                	sd	s6,48(sp)
    8000578a:	f45e                	sd	s7,40(sp)
    8000578c:	f062                	sd	s8,32(sp)
    8000578e:	ec66                	sd	s9,24(sp)
    80005790:	e86a                	sd	s10,16(sp)
    80005792:	1880                	addi	s0,sp,112
    80005794:	892a                	mv	s2,a0
    80005796:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005798:	00c52c83          	lw	s9,12(a0)
    8000579c:	001c9c9b          	slliw	s9,s9,0x1
    800057a0:	1c82                	slli	s9,s9,0x20
    800057a2:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800057a6:	00014517          	auipc	a0,0x14
    800057aa:	62250513          	addi	a0,a0,1570 # 80019dc8 <disk+0x128>
    800057ae:	00001097          	auipc	ra,0x1
    800057b2:	d7e080e7          	jalr	-642(ra) # 8000652c <acquire>
  for(int i = 0; i < 3; i++){
    800057b6:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800057b8:	4ba1                	li	s7,8
      disk.free[i] = 0;
    800057ba:	00014b17          	auipc	s6,0x14
    800057be:	4e6b0b13          	addi	s6,s6,1254 # 80019ca0 <disk>
  for(int i = 0; i < 3; i++){
    800057c2:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    800057c4:	8a4e                	mv	s4,s3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800057c6:	00014c17          	auipc	s8,0x14
    800057ca:	602c0c13          	addi	s8,s8,1538 # 80019dc8 <disk+0x128>
    800057ce:	a8b5                	j	8000584a <virtio_disk_rw+0xd2>
      disk.free[i] = 0;
    800057d0:	00fb06b3          	add	a3,s6,a5
    800057d4:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    800057d8:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    800057da:	0207c563          	bltz	a5,80005804 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    800057de:	2485                	addiw	s1,s1,1
    800057e0:	0711                	addi	a4,a4,4
    800057e2:	1f548a63          	beq	s1,s5,800059d6 <virtio_disk_rw+0x25e>
    idx[i] = alloc_desc();
    800057e6:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    800057e8:	00014697          	auipc	a3,0x14
    800057ec:	4b868693          	addi	a3,a3,1208 # 80019ca0 <disk>
    800057f0:	87d2                	mv	a5,s4
    if(disk.free[i]){
    800057f2:	0186c583          	lbu	a1,24(a3)
    800057f6:	fde9                	bnez	a1,800057d0 <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    800057f8:	2785                	addiw	a5,a5,1
    800057fa:	0685                	addi	a3,a3,1
    800057fc:	ff779be3          	bne	a5,s7,800057f2 <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    80005800:	57fd                	li	a5,-1
    80005802:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    80005804:	02905a63          	blez	s1,80005838 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    80005808:	f9042503          	lw	a0,-112(s0)
    8000580c:	00000097          	auipc	ra,0x0
    80005810:	cfa080e7          	jalr	-774(ra) # 80005506 <free_desc>
      for(int j = 0; j < i; j++)
    80005814:	4785                	li	a5,1
    80005816:	0297d163          	bge	a5,s1,80005838 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    8000581a:	f9442503          	lw	a0,-108(s0)
    8000581e:	00000097          	auipc	ra,0x0
    80005822:	ce8080e7          	jalr	-792(ra) # 80005506 <free_desc>
      for(int j = 0; j < i; j++)
    80005826:	4789                	li	a5,2
    80005828:	0097d863          	bge	a5,s1,80005838 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    8000582c:	f9842503          	lw	a0,-104(s0)
    80005830:	00000097          	auipc	ra,0x0
    80005834:	cd6080e7          	jalr	-810(ra) # 80005506 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005838:	85e2                	mv	a1,s8
    8000583a:	00014517          	auipc	a0,0x14
    8000583e:	47e50513          	addi	a0,a0,1150 # 80019cb8 <disk+0x18>
    80005842:	ffffc097          	auipc	ra,0xffffc
    80005846:	f50080e7          	jalr	-176(ra) # 80001792 <sleep>
  for(int i = 0; i < 3; i++){
    8000584a:	f9040713          	addi	a4,s0,-112
    8000584e:	84ce                	mv	s1,s3
    80005850:	bf59                	j	800057e6 <virtio_disk_rw+0x6e>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005852:	00a60793          	addi	a5,a2,10 # 100a <_entry-0x7fffeff6>
    80005856:	00479693          	slli	a3,a5,0x4
    8000585a:	00014797          	auipc	a5,0x14
    8000585e:	44678793          	addi	a5,a5,1094 # 80019ca0 <disk>
    80005862:	97b6                	add	a5,a5,a3
    80005864:	4685                	li	a3,1
    80005866:	c794                	sw	a3,8(a5)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005868:	00014597          	auipc	a1,0x14
    8000586c:	43858593          	addi	a1,a1,1080 # 80019ca0 <disk>
    80005870:	00a60793          	addi	a5,a2,10
    80005874:	0792                	slli	a5,a5,0x4
    80005876:	97ae                	add	a5,a5,a1
    80005878:	0007a623          	sw	zero,12(a5)
  buf0->sector = sector;
    8000587c:	0197b823          	sd	s9,16(a5)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005880:	f6070693          	addi	a3,a4,-160
    80005884:	619c                	ld	a5,0(a1)
    80005886:	97b6                	add	a5,a5,a3
    80005888:	e388                	sd	a0,0(a5)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000588a:	6188                	ld	a0,0(a1)
    8000588c:	96aa                	add	a3,a3,a0
    8000588e:	47c1                	li	a5,16
    80005890:	c69c                	sw	a5,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005892:	4785                	li	a5,1
    80005894:	00f69623          	sh	a5,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80005898:	f9442783          	lw	a5,-108(s0)
    8000589c:	00f69723          	sh	a5,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800058a0:	0792                	slli	a5,a5,0x4
    800058a2:	953e                	add	a0,a0,a5
    800058a4:	05890693          	addi	a3,s2,88
    800058a8:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    800058aa:	6188                	ld	a0,0(a1)
    800058ac:	97aa                	add	a5,a5,a0
    800058ae:	40000693          	li	a3,1024
    800058b2:	c794                	sw	a3,8(a5)
  if(write)
    800058b4:	100d0d63          	beqz	s10,800059ce <virtio_disk_rw+0x256>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800058b8:	00079623          	sh	zero,12(a5)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800058bc:	00c7d683          	lhu	a3,12(a5)
    800058c0:	0016e693          	ori	a3,a3,1
    800058c4:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[1]].next = idx[2];
    800058c8:	f9842583          	lw	a1,-104(s0)
    800058cc:	00b79723          	sh	a1,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800058d0:	00014697          	auipc	a3,0x14
    800058d4:	3d068693          	addi	a3,a3,976 # 80019ca0 <disk>
    800058d8:	00260793          	addi	a5,a2,2
    800058dc:	0792                	slli	a5,a5,0x4
    800058de:	97b6                	add	a5,a5,a3
    800058e0:	587d                	li	a6,-1
    800058e2:	01078823          	sb	a6,16(a5)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800058e6:	0592                	slli	a1,a1,0x4
    800058e8:	952e                	add	a0,a0,a1
    800058ea:	f9070713          	addi	a4,a4,-112
    800058ee:	9736                	add	a4,a4,a3
    800058f0:	e118                	sd	a4,0(a0)
  disk.desc[idx[2]].len = 1;
    800058f2:	6298                	ld	a4,0(a3)
    800058f4:	972e                	add	a4,a4,a1
    800058f6:	4585                	li	a1,1
    800058f8:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800058fa:	4509                	li	a0,2
    800058fc:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[2]].next = 0;
    80005900:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005904:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    80005908:	0127b423          	sd	s2,8(a5)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000590c:	6698                	ld	a4,8(a3)
    8000590e:	00275783          	lhu	a5,2(a4)
    80005912:	8b9d                	andi	a5,a5,7
    80005914:	0786                	slli	a5,a5,0x1
    80005916:	97ba                	add	a5,a5,a4
    80005918:	00c79223          	sh	a2,4(a5)

  __sync_synchronize();
    8000591c:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005920:	6698                	ld	a4,8(a3)
    80005922:	00275783          	lhu	a5,2(a4)
    80005926:	2785                	addiw	a5,a5,1
    80005928:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000592c:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005930:	100017b7          	lui	a5,0x10001
    80005934:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005938:	00492703          	lw	a4,4(s2)
    8000593c:	4785                	li	a5,1
    8000593e:	02f71163          	bne	a4,a5,80005960 <virtio_disk_rw+0x1e8>
    sleep(b, &disk.vdisk_lock);
    80005942:	00014997          	auipc	s3,0x14
    80005946:	48698993          	addi	s3,s3,1158 # 80019dc8 <disk+0x128>
  while(b->disk == 1) {
    8000594a:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    8000594c:	85ce                	mv	a1,s3
    8000594e:	854a                	mv	a0,s2
    80005950:	ffffc097          	auipc	ra,0xffffc
    80005954:	e42080e7          	jalr	-446(ra) # 80001792 <sleep>
  while(b->disk == 1) {
    80005958:	00492783          	lw	a5,4(s2)
    8000595c:	fe9788e3          	beq	a5,s1,8000594c <virtio_disk_rw+0x1d4>
  }

  disk.info[idx[0]].b = 0;
    80005960:	f9042903          	lw	s2,-112(s0)
    80005964:	00290793          	addi	a5,s2,2
    80005968:	00479713          	slli	a4,a5,0x4
    8000596c:	00014797          	auipc	a5,0x14
    80005970:	33478793          	addi	a5,a5,820 # 80019ca0 <disk>
    80005974:	97ba                	add	a5,a5,a4
    80005976:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000597a:	00014997          	auipc	s3,0x14
    8000597e:	32698993          	addi	s3,s3,806 # 80019ca0 <disk>
    80005982:	00491713          	slli	a4,s2,0x4
    80005986:	0009b783          	ld	a5,0(s3)
    8000598a:	97ba                	add	a5,a5,a4
    8000598c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005990:	854a                	mv	a0,s2
    80005992:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005996:	00000097          	auipc	ra,0x0
    8000599a:	b70080e7          	jalr	-1168(ra) # 80005506 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000599e:	8885                	andi	s1,s1,1
    800059a0:	f0ed                	bnez	s1,80005982 <virtio_disk_rw+0x20a>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800059a2:	00014517          	auipc	a0,0x14
    800059a6:	42650513          	addi	a0,a0,1062 # 80019dc8 <disk+0x128>
    800059aa:	00001097          	auipc	ra,0x1
    800059ae:	c36080e7          	jalr	-970(ra) # 800065e0 <release>
}
    800059b2:	70a6                	ld	ra,104(sp)
    800059b4:	7406                	ld	s0,96(sp)
    800059b6:	64e6                	ld	s1,88(sp)
    800059b8:	6946                	ld	s2,80(sp)
    800059ba:	69a6                	ld	s3,72(sp)
    800059bc:	6a06                	ld	s4,64(sp)
    800059be:	7ae2                	ld	s5,56(sp)
    800059c0:	7b42                	ld	s6,48(sp)
    800059c2:	7ba2                	ld	s7,40(sp)
    800059c4:	7c02                	ld	s8,32(sp)
    800059c6:	6ce2                	ld	s9,24(sp)
    800059c8:	6d42                	ld	s10,16(sp)
    800059ca:	6165                	addi	sp,sp,112
    800059cc:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800059ce:	4689                	li	a3,2
    800059d0:	00d79623          	sh	a3,12(a5)
    800059d4:	b5e5                	j	800058bc <virtio_disk_rw+0x144>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800059d6:	f9042603          	lw	a2,-112(s0)
    800059da:	00a60713          	addi	a4,a2,10
    800059de:	0712                	slli	a4,a4,0x4
    800059e0:	00014517          	auipc	a0,0x14
    800059e4:	2c850513          	addi	a0,a0,712 # 80019ca8 <disk+0x8>
    800059e8:	953a                	add	a0,a0,a4
  if(write)
    800059ea:	e60d14e3          	bnez	s10,80005852 <virtio_disk_rw+0xda>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    800059ee:	00a60793          	addi	a5,a2,10
    800059f2:	00479693          	slli	a3,a5,0x4
    800059f6:	00014797          	auipc	a5,0x14
    800059fa:	2aa78793          	addi	a5,a5,682 # 80019ca0 <disk>
    800059fe:	97b6                	add	a5,a5,a3
    80005a00:	0007a423          	sw	zero,8(a5)
    80005a04:	b595                	j	80005868 <virtio_disk_rw+0xf0>

0000000080005a06 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005a06:	1101                	addi	sp,sp,-32
    80005a08:	ec06                	sd	ra,24(sp)
    80005a0a:	e822                	sd	s0,16(sp)
    80005a0c:	e426                	sd	s1,8(sp)
    80005a0e:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005a10:	00014497          	auipc	s1,0x14
    80005a14:	29048493          	addi	s1,s1,656 # 80019ca0 <disk>
    80005a18:	00014517          	auipc	a0,0x14
    80005a1c:	3b050513          	addi	a0,a0,944 # 80019dc8 <disk+0x128>
    80005a20:	00001097          	auipc	ra,0x1
    80005a24:	b0c080e7          	jalr	-1268(ra) # 8000652c <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005a28:	10001737          	lui	a4,0x10001
    80005a2c:	533c                	lw	a5,96(a4)
    80005a2e:	8b8d                	andi	a5,a5,3
    80005a30:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005a32:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005a36:	689c                	ld	a5,16(s1)
    80005a38:	0204d703          	lhu	a4,32(s1)
    80005a3c:	0027d783          	lhu	a5,2(a5)
    80005a40:	04f70863          	beq	a4,a5,80005a90 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005a44:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005a48:	6898                	ld	a4,16(s1)
    80005a4a:	0204d783          	lhu	a5,32(s1)
    80005a4e:	8b9d                	andi	a5,a5,7
    80005a50:	078e                	slli	a5,a5,0x3
    80005a52:	97ba                	add	a5,a5,a4
    80005a54:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005a56:	00278713          	addi	a4,a5,2
    80005a5a:	0712                	slli	a4,a4,0x4
    80005a5c:	9726                	add	a4,a4,s1
    80005a5e:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005a62:	e721                	bnez	a4,80005aaa <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005a64:	0789                	addi	a5,a5,2
    80005a66:	0792                	slli	a5,a5,0x4
    80005a68:	97a6                	add	a5,a5,s1
    80005a6a:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005a6c:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005a70:	ffffc097          	auipc	ra,0xffffc
    80005a74:	d86080e7          	jalr	-634(ra) # 800017f6 <wakeup>

    disk.used_idx += 1;
    80005a78:	0204d783          	lhu	a5,32(s1)
    80005a7c:	2785                	addiw	a5,a5,1
    80005a7e:	17c2                	slli	a5,a5,0x30
    80005a80:	93c1                	srli	a5,a5,0x30
    80005a82:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005a86:	6898                	ld	a4,16(s1)
    80005a88:	00275703          	lhu	a4,2(a4)
    80005a8c:	faf71ce3          	bne	a4,a5,80005a44 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005a90:	00014517          	auipc	a0,0x14
    80005a94:	33850513          	addi	a0,a0,824 # 80019dc8 <disk+0x128>
    80005a98:	00001097          	auipc	ra,0x1
    80005a9c:	b48080e7          	jalr	-1208(ra) # 800065e0 <release>
}
    80005aa0:	60e2                	ld	ra,24(sp)
    80005aa2:	6442                	ld	s0,16(sp)
    80005aa4:	64a2                	ld	s1,8(sp)
    80005aa6:	6105                	addi	sp,sp,32
    80005aa8:	8082                	ret
      panic("virtio_disk_intr status");
    80005aaa:	00003517          	auipc	a0,0x3
    80005aae:	dc650513          	addi	a0,a0,-570 # 80008870 <syscalls+0x418>
    80005ab2:	00000097          	auipc	ra,0x0
    80005ab6:	530080e7          	jalr	1328(ra) # 80005fe2 <panic>

0000000080005aba <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005aba:	1141                	addi	sp,sp,-16
    80005abc:	e422                	sd	s0,8(sp)
    80005abe:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005ac0:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005ac4:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005ac8:	0037979b          	slliw	a5,a5,0x3
    80005acc:	02004737          	lui	a4,0x2004
    80005ad0:	97ba                	add	a5,a5,a4
    80005ad2:	0200c737          	lui	a4,0x200c
    80005ad6:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005ada:	000f4637          	lui	a2,0xf4
    80005ade:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005ae2:	95b2                	add	a1,a1,a2
    80005ae4:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005ae6:	00269713          	slli	a4,a3,0x2
    80005aea:	9736                	add	a4,a4,a3
    80005aec:	00371693          	slli	a3,a4,0x3
    80005af0:	00014717          	auipc	a4,0x14
    80005af4:	2f070713          	addi	a4,a4,752 # 80019de0 <timer_scratch>
    80005af8:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005afa:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005afc:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005afe:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005b02:	00000797          	auipc	a5,0x0
    80005b06:	93e78793          	addi	a5,a5,-1730 # 80005440 <timervec>
    80005b0a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005b0e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005b12:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005b16:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005b1a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005b1e:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005b22:	30479073          	csrw	mie,a5
}
    80005b26:	6422                	ld	s0,8(sp)
    80005b28:	0141                	addi	sp,sp,16
    80005b2a:	8082                	ret

0000000080005b2c <start>:
{
    80005b2c:	1141                	addi	sp,sp,-16
    80005b2e:	e406                	sd	ra,8(sp)
    80005b30:	e022                	sd	s0,0(sp)
    80005b32:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005b34:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005b38:	7779                	lui	a4,0xffffe
    80005b3a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc7df>
    80005b3e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005b40:	6705                	lui	a4,0x1
    80005b42:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005b46:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005b48:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005b4c:	ffffa797          	auipc	a5,0xffffa
    80005b50:	7da78793          	addi	a5,a5,2010 # 80000326 <main>
    80005b54:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005b58:	4781                	li	a5,0
    80005b5a:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005b5e:	67c1                	lui	a5,0x10
    80005b60:	17fd                	addi	a5,a5,-1
    80005b62:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005b66:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005b6a:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005b6e:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005b72:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005b76:	57fd                	li	a5,-1
    80005b78:	83a9                	srli	a5,a5,0xa
    80005b7a:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005b7e:	47bd                	li	a5,15
    80005b80:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005b84:	00000097          	auipc	ra,0x0
    80005b88:	f36080e7          	jalr	-202(ra) # 80005aba <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005b8c:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005b90:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005b92:	823e                	mv	tp,a5
  asm volatile("mret");
    80005b94:	30200073          	mret
}
    80005b98:	60a2                	ld	ra,8(sp)
    80005b9a:	6402                	ld	s0,0(sp)
    80005b9c:	0141                	addi	sp,sp,16
    80005b9e:	8082                	ret

0000000080005ba0 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005ba0:	715d                	addi	sp,sp,-80
    80005ba2:	e486                	sd	ra,72(sp)
    80005ba4:	e0a2                	sd	s0,64(sp)
    80005ba6:	fc26                	sd	s1,56(sp)
    80005ba8:	f84a                	sd	s2,48(sp)
    80005baa:	f44e                	sd	s3,40(sp)
    80005bac:	f052                	sd	s4,32(sp)
    80005bae:	ec56                	sd	s5,24(sp)
    80005bb0:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005bb2:	04c05663          	blez	a2,80005bfe <consolewrite+0x5e>
    80005bb6:	8a2a                	mv	s4,a0
    80005bb8:	84ae                	mv	s1,a1
    80005bba:	89b2                	mv	s3,a2
    80005bbc:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005bbe:	5afd                	li	s5,-1
    80005bc0:	4685                	li	a3,1
    80005bc2:	8626                	mv	a2,s1
    80005bc4:	85d2                	mv	a1,s4
    80005bc6:	fbf40513          	addi	a0,s0,-65
    80005bca:	ffffc097          	auipc	ra,0xffffc
    80005bce:	026080e7          	jalr	38(ra) # 80001bf0 <either_copyin>
    80005bd2:	01550c63          	beq	a0,s5,80005bea <consolewrite+0x4a>
      break;
    uartputc(c);
    80005bd6:	fbf44503          	lbu	a0,-65(s0)
    80005bda:	00000097          	auipc	ra,0x0
    80005bde:	794080e7          	jalr	1940(ra) # 8000636e <uartputc>
  for(i = 0; i < n; i++){
    80005be2:	2905                	addiw	s2,s2,1
    80005be4:	0485                	addi	s1,s1,1
    80005be6:	fd299de3          	bne	s3,s2,80005bc0 <consolewrite+0x20>
  }

  return i;
}
    80005bea:	854a                	mv	a0,s2
    80005bec:	60a6                	ld	ra,72(sp)
    80005bee:	6406                	ld	s0,64(sp)
    80005bf0:	74e2                	ld	s1,56(sp)
    80005bf2:	7942                	ld	s2,48(sp)
    80005bf4:	79a2                	ld	s3,40(sp)
    80005bf6:	7a02                	ld	s4,32(sp)
    80005bf8:	6ae2                	ld	s5,24(sp)
    80005bfa:	6161                	addi	sp,sp,80
    80005bfc:	8082                	ret
  for(i = 0; i < n; i++){
    80005bfe:	4901                	li	s2,0
    80005c00:	b7ed                	j	80005bea <consolewrite+0x4a>

0000000080005c02 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005c02:	7119                	addi	sp,sp,-128
    80005c04:	fc86                	sd	ra,120(sp)
    80005c06:	f8a2                	sd	s0,112(sp)
    80005c08:	f4a6                	sd	s1,104(sp)
    80005c0a:	f0ca                	sd	s2,96(sp)
    80005c0c:	ecce                	sd	s3,88(sp)
    80005c0e:	e8d2                	sd	s4,80(sp)
    80005c10:	e4d6                	sd	s5,72(sp)
    80005c12:	e0da                	sd	s6,64(sp)
    80005c14:	fc5e                	sd	s7,56(sp)
    80005c16:	f862                	sd	s8,48(sp)
    80005c18:	f466                	sd	s9,40(sp)
    80005c1a:	f06a                	sd	s10,32(sp)
    80005c1c:	ec6e                	sd	s11,24(sp)
    80005c1e:	0100                	addi	s0,sp,128
    80005c20:	8b2a                	mv	s6,a0
    80005c22:	8aae                	mv	s5,a1
    80005c24:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005c26:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005c2a:	0001c517          	auipc	a0,0x1c
    80005c2e:	2f650513          	addi	a0,a0,758 # 80021f20 <cons>
    80005c32:	00001097          	auipc	ra,0x1
    80005c36:	8fa080e7          	jalr	-1798(ra) # 8000652c <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005c3a:	0001c497          	auipc	s1,0x1c
    80005c3e:	2e648493          	addi	s1,s1,742 # 80021f20 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005c42:	89a6                	mv	s3,s1
    80005c44:	0001c917          	auipc	s2,0x1c
    80005c48:	37490913          	addi	s2,s2,884 # 80021fb8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    80005c4c:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005c4e:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005c50:	4da9                	li	s11,10
  while(n > 0){
    80005c52:	07405b63          	blez	s4,80005cc8 <consoleread+0xc6>
    while(cons.r == cons.w){
    80005c56:	0984a783          	lw	a5,152(s1)
    80005c5a:	09c4a703          	lw	a4,156(s1)
    80005c5e:	02f71763          	bne	a4,a5,80005c8c <consoleread+0x8a>
      if(killed(myproc())){
    80005c62:	ffffb097          	auipc	ra,0xffffb
    80005c66:	3f0080e7          	jalr	1008(ra) # 80001052 <myproc>
    80005c6a:	ffffc097          	auipc	ra,0xffffc
    80005c6e:	dd0080e7          	jalr	-560(ra) # 80001a3a <killed>
    80005c72:	e535                	bnez	a0,80005cde <consoleread+0xdc>
      sleep(&cons.r, &cons.lock);
    80005c74:	85ce                	mv	a1,s3
    80005c76:	854a                	mv	a0,s2
    80005c78:	ffffc097          	auipc	ra,0xffffc
    80005c7c:	b1a080e7          	jalr	-1254(ra) # 80001792 <sleep>
    while(cons.r == cons.w){
    80005c80:	0984a783          	lw	a5,152(s1)
    80005c84:	09c4a703          	lw	a4,156(s1)
    80005c88:	fcf70de3          	beq	a4,a5,80005c62 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005c8c:	0017871b          	addiw	a4,a5,1
    80005c90:	08e4ac23          	sw	a4,152(s1)
    80005c94:	07f7f713          	andi	a4,a5,127
    80005c98:	9726                	add	a4,a4,s1
    80005c9a:	01874703          	lbu	a4,24(a4)
    80005c9e:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005ca2:	079c0663          	beq	s8,s9,80005d0e <consoleread+0x10c>
    cbuf = c;
    80005ca6:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005caa:	4685                	li	a3,1
    80005cac:	f8f40613          	addi	a2,s0,-113
    80005cb0:	85d6                	mv	a1,s5
    80005cb2:	855a                	mv	a0,s6
    80005cb4:	ffffc097          	auipc	ra,0xffffc
    80005cb8:	ee6080e7          	jalr	-282(ra) # 80001b9a <either_copyout>
    80005cbc:	01a50663          	beq	a0,s10,80005cc8 <consoleread+0xc6>
    dst++;
    80005cc0:	0a85                	addi	s5,s5,1
    --n;
    80005cc2:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005cc4:	f9bc17e3          	bne	s8,s11,80005c52 <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005cc8:	0001c517          	auipc	a0,0x1c
    80005ccc:	25850513          	addi	a0,a0,600 # 80021f20 <cons>
    80005cd0:	00001097          	auipc	ra,0x1
    80005cd4:	910080e7          	jalr	-1776(ra) # 800065e0 <release>

  return target - n;
    80005cd8:	414b853b          	subw	a0,s7,s4
    80005cdc:	a811                	j	80005cf0 <consoleread+0xee>
        release(&cons.lock);
    80005cde:	0001c517          	auipc	a0,0x1c
    80005ce2:	24250513          	addi	a0,a0,578 # 80021f20 <cons>
    80005ce6:	00001097          	auipc	ra,0x1
    80005cea:	8fa080e7          	jalr	-1798(ra) # 800065e0 <release>
        return -1;
    80005cee:	557d                	li	a0,-1
}
    80005cf0:	70e6                	ld	ra,120(sp)
    80005cf2:	7446                	ld	s0,112(sp)
    80005cf4:	74a6                	ld	s1,104(sp)
    80005cf6:	7906                	ld	s2,96(sp)
    80005cf8:	69e6                	ld	s3,88(sp)
    80005cfa:	6a46                	ld	s4,80(sp)
    80005cfc:	6aa6                	ld	s5,72(sp)
    80005cfe:	6b06                	ld	s6,64(sp)
    80005d00:	7be2                	ld	s7,56(sp)
    80005d02:	7c42                	ld	s8,48(sp)
    80005d04:	7ca2                	ld	s9,40(sp)
    80005d06:	7d02                	ld	s10,32(sp)
    80005d08:	6de2                	ld	s11,24(sp)
    80005d0a:	6109                	addi	sp,sp,128
    80005d0c:	8082                	ret
      if(n < target){
    80005d0e:	000a071b          	sext.w	a4,s4
    80005d12:	fb777be3          	bgeu	a4,s7,80005cc8 <consoleread+0xc6>
        cons.r--;
    80005d16:	0001c717          	auipc	a4,0x1c
    80005d1a:	2af72123          	sw	a5,674(a4) # 80021fb8 <cons+0x98>
    80005d1e:	b76d                	j	80005cc8 <consoleread+0xc6>

0000000080005d20 <consputc>:
{
    80005d20:	1141                	addi	sp,sp,-16
    80005d22:	e406                	sd	ra,8(sp)
    80005d24:	e022                	sd	s0,0(sp)
    80005d26:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005d28:	10000793          	li	a5,256
    80005d2c:	00f50a63          	beq	a0,a5,80005d40 <consputc+0x20>
    uartputc_sync(c);
    80005d30:	00000097          	auipc	ra,0x0
    80005d34:	564080e7          	jalr	1380(ra) # 80006294 <uartputc_sync>
}
    80005d38:	60a2                	ld	ra,8(sp)
    80005d3a:	6402                	ld	s0,0(sp)
    80005d3c:	0141                	addi	sp,sp,16
    80005d3e:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005d40:	4521                	li	a0,8
    80005d42:	00000097          	auipc	ra,0x0
    80005d46:	552080e7          	jalr	1362(ra) # 80006294 <uartputc_sync>
    80005d4a:	02000513          	li	a0,32
    80005d4e:	00000097          	auipc	ra,0x0
    80005d52:	546080e7          	jalr	1350(ra) # 80006294 <uartputc_sync>
    80005d56:	4521                	li	a0,8
    80005d58:	00000097          	auipc	ra,0x0
    80005d5c:	53c080e7          	jalr	1340(ra) # 80006294 <uartputc_sync>
    80005d60:	bfe1                	j	80005d38 <consputc+0x18>

0000000080005d62 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005d62:	1101                	addi	sp,sp,-32
    80005d64:	ec06                	sd	ra,24(sp)
    80005d66:	e822                	sd	s0,16(sp)
    80005d68:	e426                	sd	s1,8(sp)
    80005d6a:	e04a                	sd	s2,0(sp)
    80005d6c:	1000                	addi	s0,sp,32
    80005d6e:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005d70:	0001c517          	auipc	a0,0x1c
    80005d74:	1b050513          	addi	a0,a0,432 # 80021f20 <cons>
    80005d78:	00000097          	auipc	ra,0x0
    80005d7c:	7b4080e7          	jalr	1972(ra) # 8000652c <acquire>

  switch(c){
    80005d80:	47d5                	li	a5,21
    80005d82:	0af48663          	beq	s1,a5,80005e2e <consoleintr+0xcc>
    80005d86:	0297ca63          	blt	a5,s1,80005dba <consoleintr+0x58>
    80005d8a:	47a1                	li	a5,8
    80005d8c:	0ef48763          	beq	s1,a5,80005e7a <consoleintr+0x118>
    80005d90:	47c1                	li	a5,16
    80005d92:	10f49a63          	bne	s1,a5,80005ea6 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005d96:	ffffc097          	auipc	ra,0xffffc
    80005d9a:	eb0080e7          	jalr	-336(ra) # 80001c46 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005d9e:	0001c517          	auipc	a0,0x1c
    80005da2:	18250513          	addi	a0,a0,386 # 80021f20 <cons>
    80005da6:	00001097          	auipc	ra,0x1
    80005daa:	83a080e7          	jalr	-1990(ra) # 800065e0 <release>
}
    80005dae:	60e2                	ld	ra,24(sp)
    80005db0:	6442                	ld	s0,16(sp)
    80005db2:	64a2                	ld	s1,8(sp)
    80005db4:	6902                	ld	s2,0(sp)
    80005db6:	6105                	addi	sp,sp,32
    80005db8:	8082                	ret
  switch(c){
    80005dba:	07f00793          	li	a5,127
    80005dbe:	0af48e63          	beq	s1,a5,80005e7a <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005dc2:	0001c717          	auipc	a4,0x1c
    80005dc6:	15e70713          	addi	a4,a4,350 # 80021f20 <cons>
    80005dca:	0a072783          	lw	a5,160(a4)
    80005dce:	09872703          	lw	a4,152(a4)
    80005dd2:	9f99                	subw	a5,a5,a4
    80005dd4:	07f00713          	li	a4,127
    80005dd8:	fcf763e3          	bltu	a4,a5,80005d9e <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005ddc:	47b5                	li	a5,13
    80005dde:	0cf48763          	beq	s1,a5,80005eac <consoleintr+0x14a>
      consputc(c);
    80005de2:	8526                	mv	a0,s1
    80005de4:	00000097          	auipc	ra,0x0
    80005de8:	f3c080e7          	jalr	-196(ra) # 80005d20 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005dec:	0001c797          	auipc	a5,0x1c
    80005df0:	13478793          	addi	a5,a5,308 # 80021f20 <cons>
    80005df4:	0a07a683          	lw	a3,160(a5)
    80005df8:	0016871b          	addiw	a4,a3,1
    80005dfc:	0007061b          	sext.w	a2,a4
    80005e00:	0ae7a023          	sw	a4,160(a5)
    80005e04:	07f6f693          	andi	a3,a3,127
    80005e08:	97b6                	add	a5,a5,a3
    80005e0a:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005e0e:	47a9                	li	a5,10
    80005e10:	0cf48563          	beq	s1,a5,80005eda <consoleintr+0x178>
    80005e14:	4791                	li	a5,4
    80005e16:	0cf48263          	beq	s1,a5,80005eda <consoleintr+0x178>
    80005e1a:	0001c797          	auipc	a5,0x1c
    80005e1e:	19e7a783          	lw	a5,414(a5) # 80021fb8 <cons+0x98>
    80005e22:	9f1d                	subw	a4,a4,a5
    80005e24:	08000793          	li	a5,128
    80005e28:	f6f71be3          	bne	a4,a5,80005d9e <consoleintr+0x3c>
    80005e2c:	a07d                	j	80005eda <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005e2e:	0001c717          	auipc	a4,0x1c
    80005e32:	0f270713          	addi	a4,a4,242 # 80021f20 <cons>
    80005e36:	0a072783          	lw	a5,160(a4)
    80005e3a:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005e3e:	0001c497          	auipc	s1,0x1c
    80005e42:	0e248493          	addi	s1,s1,226 # 80021f20 <cons>
    while(cons.e != cons.w &&
    80005e46:	4929                	li	s2,10
    80005e48:	f4f70be3          	beq	a4,a5,80005d9e <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005e4c:	37fd                	addiw	a5,a5,-1
    80005e4e:	07f7f713          	andi	a4,a5,127
    80005e52:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005e54:	01874703          	lbu	a4,24(a4)
    80005e58:	f52703e3          	beq	a4,s2,80005d9e <consoleintr+0x3c>
      cons.e--;
    80005e5c:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005e60:	10000513          	li	a0,256
    80005e64:	00000097          	auipc	ra,0x0
    80005e68:	ebc080e7          	jalr	-324(ra) # 80005d20 <consputc>
    while(cons.e != cons.w &&
    80005e6c:	0a04a783          	lw	a5,160(s1)
    80005e70:	09c4a703          	lw	a4,156(s1)
    80005e74:	fcf71ce3          	bne	a4,a5,80005e4c <consoleintr+0xea>
    80005e78:	b71d                	j	80005d9e <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005e7a:	0001c717          	auipc	a4,0x1c
    80005e7e:	0a670713          	addi	a4,a4,166 # 80021f20 <cons>
    80005e82:	0a072783          	lw	a5,160(a4)
    80005e86:	09c72703          	lw	a4,156(a4)
    80005e8a:	f0f70ae3          	beq	a4,a5,80005d9e <consoleintr+0x3c>
      cons.e--;
    80005e8e:	37fd                	addiw	a5,a5,-1
    80005e90:	0001c717          	auipc	a4,0x1c
    80005e94:	12f72823          	sw	a5,304(a4) # 80021fc0 <cons+0xa0>
      consputc(BACKSPACE);
    80005e98:	10000513          	li	a0,256
    80005e9c:	00000097          	auipc	ra,0x0
    80005ea0:	e84080e7          	jalr	-380(ra) # 80005d20 <consputc>
    80005ea4:	bded                	j	80005d9e <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005ea6:	ee048ce3          	beqz	s1,80005d9e <consoleintr+0x3c>
    80005eaa:	bf21                	j	80005dc2 <consoleintr+0x60>
      consputc(c);
    80005eac:	4529                	li	a0,10
    80005eae:	00000097          	auipc	ra,0x0
    80005eb2:	e72080e7          	jalr	-398(ra) # 80005d20 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005eb6:	0001c797          	auipc	a5,0x1c
    80005eba:	06a78793          	addi	a5,a5,106 # 80021f20 <cons>
    80005ebe:	0a07a703          	lw	a4,160(a5)
    80005ec2:	0017069b          	addiw	a3,a4,1
    80005ec6:	0006861b          	sext.w	a2,a3
    80005eca:	0ad7a023          	sw	a3,160(a5)
    80005ece:	07f77713          	andi	a4,a4,127
    80005ed2:	97ba                	add	a5,a5,a4
    80005ed4:	4729                	li	a4,10
    80005ed6:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005eda:	0001c797          	auipc	a5,0x1c
    80005ede:	0ec7a123          	sw	a2,226(a5) # 80021fbc <cons+0x9c>
        wakeup(&cons.r);
    80005ee2:	0001c517          	auipc	a0,0x1c
    80005ee6:	0d650513          	addi	a0,a0,214 # 80021fb8 <cons+0x98>
    80005eea:	ffffc097          	auipc	ra,0xffffc
    80005eee:	90c080e7          	jalr	-1780(ra) # 800017f6 <wakeup>
    80005ef2:	b575                	j	80005d9e <consoleintr+0x3c>

0000000080005ef4 <consoleinit>:

void
consoleinit(void)
{
    80005ef4:	1141                	addi	sp,sp,-16
    80005ef6:	e406                	sd	ra,8(sp)
    80005ef8:	e022                	sd	s0,0(sp)
    80005efa:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005efc:	00003597          	auipc	a1,0x3
    80005f00:	98c58593          	addi	a1,a1,-1652 # 80008888 <syscalls+0x430>
    80005f04:	0001c517          	auipc	a0,0x1c
    80005f08:	01c50513          	addi	a0,a0,28 # 80021f20 <cons>
    80005f0c:	00000097          	auipc	ra,0x0
    80005f10:	590080e7          	jalr	1424(ra) # 8000649c <initlock>

  uartinit();
    80005f14:	00000097          	auipc	ra,0x0
    80005f18:	330080e7          	jalr	816(ra) # 80006244 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005f1c:	00013797          	auipc	a5,0x13
    80005f20:	d2c78793          	addi	a5,a5,-724 # 80018c48 <devsw>
    80005f24:	00000717          	auipc	a4,0x0
    80005f28:	cde70713          	addi	a4,a4,-802 # 80005c02 <consoleread>
    80005f2c:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005f2e:	00000717          	auipc	a4,0x0
    80005f32:	c7270713          	addi	a4,a4,-910 # 80005ba0 <consolewrite>
    80005f36:	ef98                	sd	a4,24(a5)
}
    80005f38:	60a2                	ld	ra,8(sp)
    80005f3a:	6402                	ld	s0,0(sp)
    80005f3c:	0141                	addi	sp,sp,16
    80005f3e:	8082                	ret

0000000080005f40 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005f40:	7179                	addi	sp,sp,-48
    80005f42:	f406                	sd	ra,40(sp)
    80005f44:	f022                	sd	s0,32(sp)
    80005f46:	ec26                	sd	s1,24(sp)
    80005f48:	e84a                	sd	s2,16(sp)
    80005f4a:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005f4c:	c219                	beqz	a2,80005f52 <printint+0x12>
    80005f4e:	08054663          	bltz	a0,80005fda <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005f52:	2501                	sext.w	a0,a0
    80005f54:	4881                	li	a7,0
    80005f56:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005f5a:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005f5c:	2581                	sext.w	a1,a1
    80005f5e:	00003617          	auipc	a2,0x3
    80005f62:	95a60613          	addi	a2,a2,-1702 # 800088b8 <digits>
    80005f66:	883a                	mv	a6,a4
    80005f68:	2705                	addiw	a4,a4,1
    80005f6a:	02b577bb          	remuw	a5,a0,a1
    80005f6e:	1782                	slli	a5,a5,0x20
    80005f70:	9381                	srli	a5,a5,0x20
    80005f72:	97b2                	add	a5,a5,a2
    80005f74:	0007c783          	lbu	a5,0(a5)
    80005f78:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005f7c:	0005079b          	sext.w	a5,a0
    80005f80:	02b5553b          	divuw	a0,a0,a1
    80005f84:	0685                	addi	a3,a3,1
    80005f86:	feb7f0e3          	bgeu	a5,a1,80005f66 <printint+0x26>

  if(sign)
    80005f8a:	00088b63          	beqz	a7,80005fa0 <printint+0x60>
    buf[i++] = '-';
    80005f8e:	fe040793          	addi	a5,s0,-32
    80005f92:	973e                	add	a4,a4,a5
    80005f94:	02d00793          	li	a5,45
    80005f98:	fef70823          	sb	a5,-16(a4)
    80005f9c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005fa0:	02e05763          	blez	a4,80005fce <printint+0x8e>
    80005fa4:	fd040793          	addi	a5,s0,-48
    80005fa8:	00e784b3          	add	s1,a5,a4
    80005fac:	fff78913          	addi	s2,a5,-1
    80005fb0:	993a                	add	s2,s2,a4
    80005fb2:	377d                	addiw	a4,a4,-1
    80005fb4:	1702                	slli	a4,a4,0x20
    80005fb6:	9301                	srli	a4,a4,0x20
    80005fb8:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005fbc:	fff4c503          	lbu	a0,-1(s1)
    80005fc0:	00000097          	auipc	ra,0x0
    80005fc4:	d60080e7          	jalr	-672(ra) # 80005d20 <consputc>
  while(--i >= 0)
    80005fc8:	14fd                	addi	s1,s1,-1
    80005fca:	ff2499e3          	bne	s1,s2,80005fbc <printint+0x7c>
}
    80005fce:	70a2                	ld	ra,40(sp)
    80005fd0:	7402                	ld	s0,32(sp)
    80005fd2:	64e2                	ld	s1,24(sp)
    80005fd4:	6942                	ld	s2,16(sp)
    80005fd6:	6145                	addi	sp,sp,48
    80005fd8:	8082                	ret
    x = -xx;
    80005fda:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005fde:	4885                	li	a7,1
    x = -xx;
    80005fe0:	bf9d                	j	80005f56 <printint+0x16>

0000000080005fe2 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005fe2:	1101                	addi	sp,sp,-32
    80005fe4:	ec06                	sd	ra,24(sp)
    80005fe6:	e822                	sd	s0,16(sp)
    80005fe8:	e426                	sd	s1,8(sp)
    80005fea:	1000                	addi	s0,sp,32
    80005fec:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005fee:	0001c797          	auipc	a5,0x1c
    80005ff2:	fe07a923          	sw	zero,-14(a5) # 80021fe0 <pr+0x18>
  printf("panic: ");
    80005ff6:	00003517          	auipc	a0,0x3
    80005ffa:	89a50513          	addi	a0,a0,-1894 # 80008890 <syscalls+0x438>
    80005ffe:	00000097          	auipc	ra,0x0
    80006002:	02e080e7          	jalr	46(ra) # 8000602c <printf>
  printf(s);
    80006006:	8526                	mv	a0,s1
    80006008:	00000097          	auipc	ra,0x0
    8000600c:	024080e7          	jalr	36(ra) # 8000602c <printf>
  printf("\n");
    80006010:	00002517          	auipc	a0,0x2
    80006014:	03850513          	addi	a0,a0,56 # 80008048 <etext+0x48>
    80006018:	00000097          	auipc	ra,0x0
    8000601c:	014080e7          	jalr	20(ra) # 8000602c <printf>
  panicked = 1; // freeze uart output from other CPUs
    80006020:	4785                	li	a5,1
    80006022:	00003717          	auipc	a4,0x3
    80006026:	96f72d23          	sw	a5,-1670(a4) # 8000899c <panicked>
  for(;;)
    8000602a:	a001                	j	8000602a <panic+0x48>

000000008000602c <printf>:
{
    8000602c:	7131                	addi	sp,sp,-192
    8000602e:	fc86                	sd	ra,120(sp)
    80006030:	f8a2                	sd	s0,112(sp)
    80006032:	f4a6                	sd	s1,104(sp)
    80006034:	f0ca                	sd	s2,96(sp)
    80006036:	ecce                	sd	s3,88(sp)
    80006038:	e8d2                	sd	s4,80(sp)
    8000603a:	e4d6                	sd	s5,72(sp)
    8000603c:	e0da                	sd	s6,64(sp)
    8000603e:	fc5e                	sd	s7,56(sp)
    80006040:	f862                	sd	s8,48(sp)
    80006042:	f466                	sd	s9,40(sp)
    80006044:	f06a                	sd	s10,32(sp)
    80006046:	ec6e                	sd	s11,24(sp)
    80006048:	0100                	addi	s0,sp,128
    8000604a:	8a2a                	mv	s4,a0
    8000604c:	e40c                	sd	a1,8(s0)
    8000604e:	e810                	sd	a2,16(s0)
    80006050:	ec14                	sd	a3,24(s0)
    80006052:	f018                	sd	a4,32(s0)
    80006054:	f41c                	sd	a5,40(s0)
    80006056:	03043823          	sd	a6,48(s0)
    8000605a:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    8000605e:	0001cd97          	auipc	s11,0x1c
    80006062:	f82dad83          	lw	s11,-126(s11) # 80021fe0 <pr+0x18>
  if(locking)
    80006066:	020d9b63          	bnez	s11,8000609c <printf+0x70>
  if (fmt == 0)
    8000606a:	040a0263          	beqz	s4,800060ae <printf+0x82>
  va_start(ap, fmt);
    8000606e:	00840793          	addi	a5,s0,8
    80006072:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006076:	000a4503          	lbu	a0,0(s4)
    8000607a:	16050263          	beqz	a0,800061de <printf+0x1b2>
    8000607e:	4481                	li	s1,0
    if(c != '%'){
    80006080:	02500a93          	li	s5,37
    switch(c){
    80006084:	07000b13          	li	s6,112
  consputc('x');
    80006088:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000608a:	00003b97          	auipc	s7,0x3
    8000608e:	82eb8b93          	addi	s7,s7,-2002 # 800088b8 <digits>
    switch(c){
    80006092:	07300c93          	li	s9,115
    80006096:	06400c13          	li	s8,100
    8000609a:	a82d                	j	800060d4 <printf+0xa8>
    acquire(&pr.lock);
    8000609c:	0001c517          	auipc	a0,0x1c
    800060a0:	f2c50513          	addi	a0,a0,-212 # 80021fc8 <pr>
    800060a4:	00000097          	auipc	ra,0x0
    800060a8:	488080e7          	jalr	1160(ra) # 8000652c <acquire>
    800060ac:	bf7d                	j	8000606a <printf+0x3e>
    panic("null fmt");
    800060ae:	00002517          	auipc	a0,0x2
    800060b2:	7f250513          	addi	a0,a0,2034 # 800088a0 <syscalls+0x448>
    800060b6:	00000097          	auipc	ra,0x0
    800060ba:	f2c080e7          	jalr	-212(ra) # 80005fe2 <panic>
      consputc(c);
    800060be:	00000097          	auipc	ra,0x0
    800060c2:	c62080e7          	jalr	-926(ra) # 80005d20 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800060c6:	2485                	addiw	s1,s1,1
    800060c8:	009a07b3          	add	a5,s4,s1
    800060cc:	0007c503          	lbu	a0,0(a5)
    800060d0:	10050763          	beqz	a0,800061de <printf+0x1b2>
    if(c != '%'){
    800060d4:	ff5515e3          	bne	a0,s5,800060be <printf+0x92>
    c = fmt[++i] & 0xff;
    800060d8:	2485                	addiw	s1,s1,1
    800060da:	009a07b3          	add	a5,s4,s1
    800060de:	0007c783          	lbu	a5,0(a5)
    800060e2:	0007891b          	sext.w	s2,a5
    if(c == 0)
    800060e6:	cfe5                	beqz	a5,800061de <printf+0x1b2>
    switch(c){
    800060e8:	05678a63          	beq	a5,s6,8000613c <printf+0x110>
    800060ec:	02fb7663          	bgeu	s6,a5,80006118 <printf+0xec>
    800060f0:	09978963          	beq	a5,s9,80006182 <printf+0x156>
    800060f4:	07800713          	li	a4,120
    800060f8:	0ce79863          	bne	a5,a4,800061c8 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    800060fc:	f8843783          	ld	a5,-120(s0)
    80006100:	00878713          	addi	a4,a5,8
    80006104:	f8e43423          	sd	a4,-120(s0)
    80006108:	4605                	li	a2,1
    8000610a:	85ea                	mv	a1,s10
    8000610c:	4388                	lw	a0,0(a5)
    8000610e:	00000097          	auipc	ra,0x0
    80006112:	e32080e7          	jalr	-462(ra) # 80005f40 <printint>
      break;
    80006116:	bf45                	j	800060c6 <printf+0x9a>
    switch(c){
    80006118:	0b578263          	beq	a5,s5,800061bc <printf+0x190>
    8000611c:	0b879663          	bne	a5,s8,800061c8 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80006120:	f8843783          	ld	a5,-120(s0)
    80006124:	00878713          	addi	a4,a5,8
    80006128:	f8e43423          	sd	a4,-120(s0)
    8000612c:	4605                	li	a2,1
    8000612e:	45a9                	li	a1,10
    80006130:	4388                	lw	a0,0(a5)
    80006132:	00000097          	auipc	ra,0x0
    80006136:	e0e080e7          	jalr	-498(ra) # 80005f40 <printint>
      break;
    8000613a:	b771                	j	800060c6 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    8000613c:	f8843783          	ld	a5,-120(s0)
    80006140:	00878713          	addi	a4,a5,8
    80006144:	f8e43423          	sd	a4,-120(s0)
    80006148:	0007b983          	ld	s3,0(a5)
  consputc('0');
    8000614c:	03000513          	li	a0,48
    80006150:	00000097          	auipc	ra,0x0
    80006154:	bd0080e7          	jalr	-1072(ra) # 80005d20 <consputc>
  consputc('x');
    80006158:	07800513          	li	a0,120
    8000615c:	00000097          	auipc	ra,0x0
    80006160:	bc4080e7          	jalr	-1084(ra) # 80005d20 <consputc>
    80006164:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006166:	03c9d793          	srli	a5,s3,0x3c
    8000616a:	97de                	add	a5,a5,s7
    8000616c:	0007c503          	lbu	a0,0(a5)
    80006170:	00000097          	auipc	ra,0x0
    80006174:	bb0080e7          	jalr	-1104(ra) # 80005d20 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006178:	0992                	slli	s3,s3,0x4
    8000617a:	397d                	addiw	s2,s2,-1
    8000617c:	fe0915e3          	bnez	s2,80006166 <printf+0x13a>
    80006180:	b799                	j	800060c6 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80006182:	f8843783          	ld	a5,-120(s0)
    80006186:	00878713          	addi	a4,a5,8
    8000618a:	f8e43423          	sd	a4,-120(s0)
    8000618e:	0007b903          	ld	s2,0(a5)
    80006192:	00090e63          	beqz	s2,800061ae <printf+0x182>
      for(; *s; s++)
    80006196:	00094503          	lbu	a0,0(s2)
    8000619a:	d515                	beqz	a0,800060c6 <printf+0x9a>
        consputc(*s);
    8000619c:	00000097          	auipc	ra,0x0
    800061a0:	b84080e7          	jalr	-1148(ra) # 80005d20 <consputc>
      for(; *s; s++)
    800061a4:	0905                	addi	s2,s2,1
    800061a6:	00094503          	lbu	a0,0(s2)
    800061aa:	f96d                	bnez	a0,8000619c <printf+0x170>
    800061ac:	bf29                	j	800060c6 <printf+0x9a>
        s = "(null)";
    800061ae:	00002917          	auipc	s2,0x2
    800061b2:	6ea90913          	addi	s2,s2,1770 # 80008898 <syscalls+0x440>
      for(; *s; s++)
    800061b6:	02800513          	li	a0,40
    800061ba:	b7cd                	j	8000619c <printf+0x170>
      consputc('%');
    800061bc:	8556                	mv	a0,s5
    800061be:	00000097          	auipc	ra,0x0
    800061c2:	b62080e7          	jalr	-1182(ra) # 80005d20 <consputc>
      break;
    800061c6:	b701                	j	800060c6 <printf+0x9a>
      consputc('%');
    800061c8:	8556                	mv	a0,s5
    800061ca:	00000097          	auipc	ra,0x0
    800061ce:	b56080e7          	jalr	-1194(ra) # 80005d20 <consputc>
      consputc(c);
    800061d2:	854a                	mv	a0,s2
    800061d4:	00000097          	auipc	ra,0x0
    800061d8:	b4c080e7          	jalr	-1204(ra) # 80005d20 <consputc>
      break;
    800061dc:	b5ed                	j	800060c6 <printf+0x9a>
  if(locking)
    800061de:	020d9163          	bnez	s11,80006200 <printf+0x1d4>
}
    800061e2:	70e6                	ld	ra,120(sp)
    800061e4:	7446                	ld	s0,112(sp)
    800061e6:	74a6                	ld	s1,104(sp)
    800061e8:	7906                	ld	s2,96(sp)
    800061ea:	69e6                	ld	s3,88(sp)
    800061ec:	6a46                	ld	s4,80(sp)
    800061ee:	6aa6                	ld	s5,72(sp)
    800061f0:	6b06                	ld	s6,64(sp)
    800061f2:	7be2                	ld	s7,56(sp)
    800061f4:	7c42                	ld	s8,48(sp)
    800061f6:	7ca2                	ld	s9,40(sp)
    800061f8:	7d02                	ld	s10,32(sp)
    800061fa:	6de2                	ld	s11,24(sp)
    800061fc:	6129                	addi	sp,sp,192
    800061fe:	8082                	ret
    release(&pr.lock);
    80006200:	0001c517          	auipc	a0,0x1c
    80006204:	dc850513          	addi	a0,a0,-568 # 80021fc8 <pr>
    80006208:	00000097          	auipc	ra,0x0
    8000620c:	3d8080e7          	jalr	984(ra) # 800065e0 <release>
}
    80006210:	bfc9                	j	800061e2 <printf+0x1b6>

0000000080006212 <printfinit>:
    ;
}

void
printfinit(void)
{
    80006212:	1101                	addi	sp,sp,-32
    80006214:	ec06                	sd	ra,24(sp)
    80006216:	e822                	sd	s0,16(sp)
    80006218:	e426                	sd	s1,8(sp)
    8000621a:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000621c:	0001c497          	auipc	s1,0x1c
    80006220:	dac48493          	addi	s1,s1,-596 # 80021fc8 <pr>
    80006224:	00002597          	auipc	a1,0x2
    80006228:	68c58593          	addi	a1,a1,1676 # 800088b0 <syscalls+0x458>
    8000622c:	8526                	mv	a0,s1
    8000622e:	00000097          	auipc	ra,0x0
    80006232:	26e080e7          	jalr	622(ra) # 8000649c <initlock>
  pr.locking = 1;
    80006236:	4785                	li	a5,1
    80006238:	cc9c                	sw	a5,24(s1)
}
    8000623a:	60e2                	ld	ra,24(sp)
    8000623c:	6442                	ld	s0,16(sp)
    8000623e:	64a2                	ld	s1,8(sp)
    80006240:	6105                	addi	sp,sp,32
    80006242:	8082                	ret

0000000080006244 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006244:	1141                	addi	sp,sp,-16
    80006246:	e406                	sd	ra,8(sp)
    80006248:	e022                	sd	s0,0(sp)
    8000624a:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000624c:	100007b7          	lui	a5,0x10000
    80006250:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006254:	f8000713          	li	a4,-128
    80006258:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000625c:	470d                	li	a4,3
    8000625e:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006262:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006266:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000626a:	469d                	li	a3,7
    8000626c:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006270:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006274:	00002597          	auipc	a1,0x2
    80006278:	65c58593          	addi	a1,a1,1628 # 800088d0 <digits+0x18>
    8000627c:	0001c517          	auipc	a0,0x1c
    80006280:	d6c50513          	addi	a0,a0,-660 # 80021fe8 <uart_tx_lock>
    80006284:	00000097          	auipc	ra,0x0
    80006288:	218080e7          	jalr	536(ra) # 8000649c <initlock>
}
    8000628c:	60a2                	ld	ra,8(sp)
    8000628e:	6402                	ld	s0,0(sp)
    80006290:	0141                	addi	sp,sp,16
    80006292:	8082                	ret

0000000080006294 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006294:	1101                	addi	sp,sp,-32
    80006296:	ec06                	sd	ra,24(sp)
    80006298:	e822                	sd	s0,16(sp)
    8000629a:	e426                	sd	s1,8(sp)
    8000629c:	1000                	addi	s0,sp,32
    8000629e:	84aa                	mv	s1,a0
  push_off();
    800062a0:	00000097          	auipc	ra,0x0
    800062a4:	240080e7          	jalr	576(ra) # 800064e0 <push_off>

  if(panicked){
    800062a8:	00002797          	auipc	a5,0x2
    800062ac:	6f47a783          	lw	a5,1780(a5) # 8000899c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800062b0:	10000737          	lui	a4,0x10000
  if(panicked){
    800062b4:	c391                	beqz	a5,800062b8 <uartputc_sync+0x24>
    for(;;)
    800062b6:	a001                	j	800062b6 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800062b8:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800062bc:	0ff7f793          	andi	a5,a5,255
    800062c0:	0207f793          	andi	a5,a5,32
    800062c4:	dbf5                	beqz	a5,800062b8 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    800062c6:	0ff4f793          	andi	a5,s1,255
    800062ca:	10000737          	lui	a4,0x10000
    800062ce:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    800062d2:	00000097          	auipc	ra,0x0
    800062d6:	2ae080e7          	jalr	686(ra) # 80006580 <pop_off>
}
    800062da:	60e2                	ld	ra,24(sp)
    800062dc:	6442                	ld	s0,16(sp)
    800062de:	64a2                	ld	s1,8(sp)
    800062e0:	6105                	addi	sp,sp,32
    800062e2:	8082                	ret

00000000800062e4 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800062e4:	00002717          	auipc	a4,0x2
    800062e8:	6bc73703          	ld	a4,1724(a4) # 800089a0 <uart_tx_r>
    800062ec:	00002797          	auipc	a5,0x2
    800062f0:	6bc7b783          	ld	a5,1724(a5) # 800089a8 <uart_tx_w>
    800062f4:	06e78c63          	beq	a5,a4,8000636c <uartstart+0x88>
{
    800062f8:	7139                	addi	sp,sp,-64
    800062fa:	fc06                	sd	ra,56(sp)
    800062fc:	f822                	sd	s0,48(sp)
    800062fe:	f426                	sd	s1,40(sp)
    80006300:	f04a                	sd	s2,32(sp)
    80006302:	ec4e                	sd	s3,24(sp)
    80006304:	e852                	sd	s4,16(sp)
    80006306:	e456                	sd	s5,8(sp)
    80006308:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000630a:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000630e:	0001ca17          	auipc	s4,0x1c
    80006312:	cdaa0a13          	addi	s4,s4,-806 # 80021fe8 <uart_tx_lock>
    uart_tx_r += 1;
    80006316:	00002497          	auipc	s1,0x2
    8000631a:	68a48493          	addi	s1,s1,1674 # 800089a0 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    8000631e:	00002997          	auipc	s3,0x2
    80006322:	68a98993          	addi	s3,s3,1674 # 800089a8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006326:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000632a:	0ff7f793          	andi	a5,a5,255
    8000632e:	0207f793          	andi	a5,a5,32
    80006332:	c785                	beqz	a5,8000635a <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006334:	01f77793          	andi	a5,a4,31
    80006338:	97d2                	add	a5,a5,s4
    8000633a:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    8000633e:	0705                	addi	a4,a4,1
    80006340:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006342:	8526                	mv	a0,s1
    80006344:	ffffb097          	auipc	ra,0xffffb
    80006348:	4b2080e7          	jalr	1202(ra) # 800017f6 <wakeup>
    
    WriteReg(THR, c);
    8000634c:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006350:	6098                	ld	a4,0(s1)
    80006352:	0009b783          	ld	a5,0(s3)
    80006356:	fce798e3          	bne	a5,a4,80006326 <uartstart+0x42>
  }
}
    8000635a:	70e2                	ld	ra,56(sp)
    8000635c:	7442                	ld	s0,48(sp)
    8000635e:	74a2                	ld	s1,40(sp)
    80006360:	7902                	ld	s2,32(sp)
    80006362:	69e2                	ld	s3,24(sp)
    80006364:	6a42                	ld	s4,16(sp)
    80006366:	6aa2                	ld	s5,8(sp)
    80006368:	6121                	addi	sp,sp,64
    8000636a:	8082                	ret
    8000636c:	8082                	ret

000000008000636e <uartputc>:
{
    8000636e:	7179                	addi	sp,sp,-48
    80006370:	f406                	sd	ra,40(sp)
    80006372:	f022                	sd	s0,32(sp)
    80006374:	ec26                	sd	s1,24(sp)
    80006376:	e84a                	sd	s2,16(sp)
    80006378:	e44e                	sd	s3,8(sp)
    8000637a:	e052                	sd	s4,0(sp)
    8000637c:	1800                	addi	s0,sp,48
    8000637e:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006380:	0001c517          	auipc	a0,0x1c
    80006384:	c6850513          	addi	a0,a0,-920 # 80021fe8 <uart_tx_lock>
    80006388:	00000097          	auipc	ra,0x0
    8000638c:	1a4080e7          	jalr	420(ra) # 8000652c <acquire>
  if(panicked){
    80006390:	00002797          	auipc	a5,0x2
    80006394:	60c7a783          	lw	a5,1548(a5) # 8000899c <panicked>
    80006398:	e7c9                	bnez	a5,80006422 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000639a:	00002797          	auipc	a5,0x2
    8000639e:	60e7b783          	ld	a5,1550(a5) # 800089a8 <uart_tx_w>
    800063a2:	00002717          	auipc	a4,0x2
    800063a6:	5fe73703          	ld	a4,1534(a4) # 800089a0 <uart_tx_r>
    800063aa:	02070713          	addi	a4,a4,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800063ae:	0001ca17          	auipc	s4,0x1c
    800063b2:	c3aa0a13          	addi	s4,s4,-966 # 80021fe8 <uart_tx_lock>
    800063b6:	00002497          	auipc	s1,0x2
    800063ba:	5ea48493          	addi	s1,s1,1514 # 800089a0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800063be:	00002917          	auipc	s2,0x2
    800063c2:	5ea90913          	addi	s2,s2,1514 # 800089a8 <uart_tx_w>
    800063c6:	00f71f63          	bne	a4,a5,800063e4 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    800063ca:	85d2                	mv	a1,s4
    800063cc:	8526                	mv	a0,s1
    800063ce:	ffffb097          	auipc	ra,0xffffb
    800063d2:	3c4080e7          	jalr	964(ra) # 80001792 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800063d6:	00093783          	ld	a5,0(s2)
    800063da:	6098                	ld	a4,0(s1)
    800063dc:	02070713          	addi	a4,a4,32
    800063e0:	fef705e3          	beq	a4,a5,800063ca <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800063e4:	0001c497          	auipc	s1,0x1c
    800063e8:	c0448493          	addi	s1,s1,-1020 # 80021fe8 <uart_tx_lock>
    800063ec:	01f7f713          	andi	a4,a5,31
    800063f0:	9726                	add	a4,a4,s1
    800063f2:	01370c23          	sb	s3,24(a4)
  uart_tx_w += 1;
    800063f6:	0785                	addi	a5,a5,1
    800063f8:	00002717          	auipc	a4,0x2
    800063fc:	5af73823          	sd	a5,1456(a4) # 800089a8 <uart_tx_w>
  uartstart();
    80006400:	00000097          	auipc	ra,0x0
    80006404:	ee4080e7          	jalr	-284(ra) # 800062e4 <uartstart>
  release(&uart_tx_lock);
    80006408:	8526                	mv	a0,s1
    8000640a:	00000097          	auipc	ra,0x0
    8000640e:	1d6080e7          	jalr	470(ra) # 800065e0 <release>
}
    80006412:	70a2                	ld	ra,40(sp)
    80006414:	7402                	ld	s0,32(sp)
    80006416:	64e2                	ld	s1,24(sp)
    80006418:	6942                	ld	s2,16(sp)
    8000641a:	69a2                	ld	s3,8(sp)
    8000641c:	6a02                	ld	s4,0(sp)
    8000641e:	6145                	addi	sp,sp,48
    80006420:	8082                	ret
    for(;;)
    80006422:	a001                	j	80006422 <uartputc+0xb4>

0000000080006424 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006424:	1141                	addi	sp,sp,-16
    80006426:	e422                	sd	s0,8(sp)
    80006428:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000642a:	100007b7          	lui	a5,0x10000
    8000642e:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006432:	8b85                	andi	a5,a5,1
    80006434:	cb91                	beqz	a5,80006448 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80006436:	100007b7          	lui	a5,0x10000
    8000643a:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    8000643e:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80006442:	6422                	ld	s0,8(sp)
    80006444:	0141                	addi	sp,sp,16
    80006446:	8082                	ret
    return -1;
    80006448:	557d                	li	a0,-1
    8000644a:	bfe5                	j	80006442 <uartgetc+0x1e>

000000008000644c <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    8000644c:	1101                	addi	sp,sp,-32
    8000644e:	ec06                	sd	ra,24(sp)
    80006450:	e822                	sd	s0,16(sp)
    80006452:	e426                	sd	s1,8(sp)
    80006454:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006456:	54fd                	li	s1,-1
    int c = uartgetc();
    80006458:	00000097          	auipc	ra,0x0
    8000645c:	fcc080e7          	jalr	-52(ra) # 80006424 <uartgetc>
    if(c == -1)
    80006460:	00950763          	beq	a0,s1,8000646e <uartintr+0x22>
      break;
    consoleintr(c);
    80006464:	00000097          	auipc	ra,0x0
    80006468:	8fe080e7          	jalr	-1794(ra) # 80005d62 <consoleintr>
  while(1){
    8000646c:	b7f5                	j	80006458 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000646e:	0001c497          	auipc	s1,0x1c
    80006472:	b7a48493          	addi	s1,s1,-1158 # 80021fe8 <uart_tx_lock>
    80006476:	8526                	mv	a0,s1
    80006478:	00000097          	auipc	ra,0x0
    8000647c:	0b4080e7          	jalr	180(ra) # 8000652c <acquire>
  uartstart();
    80006480:	00000097          	auipc	ra,0x0
    80006484:	e64080e7          	jalr	-412(ra) # 800062e4 <uartstart>
  release(&uart_tx_lock);
    80006488:	8526                	mv	a0,s1
    8000648a:	00000097          	auipc	ra,0x0
    8000648e:	156080e7          	jalr	342(ra) # 800065e0 <release>
}
    80006492:	60e2                	ld	ra,24(sp)
    80006494:	6442                	ld	s0,16(sp)
    80006496:	64a2                	ld	s1,8(sp)
    80006498:	6105                	addi	sp,sp,32
    8000649a:	8082                	ret

000000008000649c <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000649c:	1141                	addi	sp,sp,-16
    8000649e:	e422                	sd	s0,8(sp)
    800064a0:	0800                	addi	s0,sp,16
  lk->name = name;
    800064a2:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800064a4:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800064a8:	00053823          	sd	zero,16(a0)
}
    800064ac:	6422                	ld	s0,8(sp)
    800064ae:	0141                	addi	sp,sp,16
    800064b0:	8082                	ret

00000000800064b2 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800064b2:	411c                	lw	a5,0(a0)
    800064b4:	e399                	bnez	a5,800064ba <holding+0x8>
    800064b6:	4501                	li	a0,0
  return r;
}
    800064b8:	8082                	ret
{
    800064ba:	1101                	addi	sp,sp,-32
    800064bc:	ec06                	sd	ra,24(sp)
    800064be:	e822                	sd	s0,16(sp)
    800064c0:	e426                	sd	s1,8(sp)
    800064c2:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800064c4:	6904                	ld	s1,16(a0)
    800064c6:	ffffb097          	auipc	ra,0xffffb
    800064ca:	b70080e7          	jalr	-1168(ra) # 80001036 <mycpu>
    800064ce:	40a48533          	sub	a0,s1,a0
    800064d2:	00153513          	seqz	a0,a0
}
    800064d6:	60e2                	ld	ra,24(sp)
    800064d8:	6442                	ld	s0,16(sp)
    800064da:	64a2                	ld	s1,8(sp)
    800064dc:	6105                	addi	sp,sp,32
    800064de:	8082                	ret

00000000800064e0 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800064e0:	1101                	addi	sp,sp,-32
    800064e2:	ec06                	sd	ra,24(sp)
    800064e4:	e822                	sd	s0,16(sp)
    800064e6:	e426                	sd	s1,8(sp)
    800064e8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800064ea:	100024f3          	csrr	s1,sstatus
    800064ee:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800064f2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800064f4:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800064f8:	ffffb097          	auipc	ra,0xffffb
    800064fc:	b3e080e7          	jalr	-1218(ra) # 80001036 <mycpu>
    80006500:	5d3c                	lw	a5,120(a0)
    80006502:	cf89                	beqz	a5,8000651c <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006504:	ffffb097          	auipc	ra,0xffffb
    80006508:	b32080e7          	jalr	-1230(ra) # 80001036 <mycpu>
    8000650c:	5d3c                	lw	a5,120(a0)
    8000650e:	2785                	addiw	a5,a5,1
    80006510:	dd3c                	sw	a5,120(a0)
}
    80006512:	60e2                	ld	ra,24(sp)
    80006514:	6442                	ld	s0,16(sp)
    80006516:	64a2                	ld	s1,8(sp)
    80006518:	6105                	addi	sp,sp,32
    8000651a:	8082                	ret
    mycpu()->intena = old;
    8000651c:	ffffb097          	auipc	ra,0xffffb
    80006520:	b1a080e7          	jalr	-1254(ra) # 80001036 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006524:	8085                	srli	s1,s1,0x1
    80006526:	8885                	andi	s1,s1,1
    80006528:	dd64                	sw	s1,124(a0)
    8000652a:	bfe9                	j	80006504 <push_off+0x24>

000000008000652c <acquire>:
{
    8000652c:	1101                	addi	sp,sp,-32
    8000652e:	ec06                	sd	ra,24(sp)
    80006530:	e822                	sd	s0,16(sp)
    80006532:	e426                	sd	s1,8(sp)
    80006534:	1000                	addi	s0,sp,32
    80006536:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006538:	00000097          	auipc	ra,0x0
    8000653c:	fa8080e7          	jalr	-88(ra) # 800064e0 <push_off>
  if(holding(lk))
    80006540:	8526                	mv	a0,s1
    80006542:	00000097          	auipc	ra,0x0
    80006546:	f70080e7          	jalr	-144(ra) # 800064b2 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000654a:	4705                	li	a4,1
  if(holding(lk))
    8000654c:	e115                	bnez	a0,80006570 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000654e:	87ba                	mv	a5,a4
    80006550:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006554:	2781                	sext.w	a5,a5
    80006556:	ffe5                	bnez	a5,8000654e <acquire+0x22>
  __sync_synchronize();
    80006558:	0ff0000f          	fence
  lk->cpu = mycpu();
    8000655c:	ffffb097          	auipc	ra,0xffffb
    80006560:	ada080e7          	jalr	-1318(ra) # 80001036 <mycpu>
    80006564:	e888                	sd	a0,16(s1)
}
    80006566:	60e2                	ld	ra,24(sp)
    80006568:	6442                	ld	s0,16(sp)
    8000656a:	64a2                	ld	s1,8(sp)
    8000656c:	6105                	addi	sp,sp,32
    8000656e:	8082                	ret
    panic("acquire");
    80006570:	00002517          	auipc	a0,0x2
    80006574:	36850513          	addi	a0,a0,872 # 800088d8 <digits+0x20>
    80006578:	00000097          	auipc	ra,0x0
    8000657c:	a6a080e7          	jalr	-1430(ra) # 80005fe2 <panic>

0000000080006580 <pop_off>:

void
pop_off(void)
{
    80006580:	1141                	addi	sp,sp,-16
    80006582:	e406                	sd	ra,8(sp)
    80006584:	e022                	sd	s0,0(sp)
    80006586:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006588:	ffffb097          	auipc	ra,0xffffb
    8000658c:	aae080e7          	jalr	-1362(ra) # 80001036 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006590:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006594:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006596:	e78d                	bnez	a5,800065c0 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006598:	5d3c                	lw	a5,120(a0)
    8000659a:	02f05b63          	blez	a5,800065d0 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000659e:	37fd                	addiw	a5,a5,-1
    800065a0:	0007871b          	sext.w	a4,a5
    800065a4:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800065a6:	eb09                	bnez	a4,800065b8 <pop_off+0x38>
    800065a8:	5d7c                	lw	a5,124(a0)
    800065aa:	c799                	beqz	a5,800065b8 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800065ac:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800065b0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800065b4:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800065b8:	60a2                	ld	ra,8(sp)
    800065ba:	6402                	ld	s0,0(sp)
    800065bc:	0141                	addi	sp,sp,16
    800065be:	8082                	ret
    panic("pop_off - interruptible");
    800065c0:	00002517          	auipc	a0,0x2
    800065c4:	32050513          	addi	a0,a0,800 # 800088e0 <digits+0x28>
    800065c8:	00000097          	auipc	ra,0x0
    800065cc:	a1a080e7          	jalr	-1510(ra) # 80005fe2 <panic>
    panic("pop_off");
    800065d0:	00002517          	auipc	a0,0x2
    800065d4:	32850513          	addi	a0,a0,808 # 800088f8 <digits+0x40>
    800065d8:	00000097          	auipc	ra,0x0
    800065dc:	a0a080e7          	jalr	-1526(ra) # 80005fe2 <panic>

00000000800065e0 <release>:
{
    800065e0:	1101                	addi	sp,sp,-32
    800065e2:	ec06                	sd	ra,24(sp)
    800065e4:	e822                	sd	s0,16(sp)
    800065e6:	e426                	sd	s1,8(sp)
    800065e8:	1000                	addi	s0,sp,32
    800065ea:	84aa                	mv	s1,a0
  if(!holding(lk))
    800065ec:	00000097          	auipc	ra,0x0
    800065f0:	ec6080e7          	jalr	-314(ra) # 800064b2 <holding>
    800065f4:	c115                	beqz	a0,80006618 <release+0x38>
  lk->cpu = 0;
    800065f6:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800065fa:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800065fe:	0f50000f          	fence	iorw,ow
    80006602:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006606:	00000097          	auipc	ra,0x0
    8000660a:	f7a080e7          	jalr	-134(ra) # 80006580 <pop_off>
}
    8000660e:	60e2                	ld	ra,24(sp)
    80006610:	6442                	ld	s0,16(sp)
    80006612:	64a2                	ld	s1,8(sp)
    80006614:	6105                	addi	sp,sp,32
    80006616:	8082                	ret
    panic("release");
    80006618:	00002517          	auipc	a0,0x2
    8000661c:	2e850513          	addi	a0,a0,744 # 80008900 <digits+0x48>
    80006620:	00000097          	auipc	ra,0x0
    80006624:	9c2080e7          	jalr	-1598(ra) # 80005fe2 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
