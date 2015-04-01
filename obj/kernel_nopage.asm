
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
  100000:	0f 01 15 18 70 11 40 	lgdtl  0x40117018
    movl $KERNEL_DS, %eax
  100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
  100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
  100012:	ea 19 00 10 00 08 00 	ljmp   $0x8,$0x100019

00100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
  100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10001e:	bc 00 70 11 00       	mov    $0x117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  100023:	e8 02 00 00 00       	call   10002a <kern_init>

00100028 <spin>:

# should never get here
spin:
    jmp spin
  100028:	eb fe                	jmp    100028 <spin>

0010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  10002a:	55                   	push   %ebp
  10002b:	89 e5                	mov    %esp,%ebp
  10002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100030:	ba 68 89 11 00       	mov    $0x118968,%edx
  100035:	b8 36 7a 11 00       	mov    $0x117a36,%eax
  10003a:	29 c2                	sub    %eax,%edx
  10003c:	89 d0                	mov    %edx,%eax
  10003e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100049:	00 
  10004a:	c7 04 24 36 7a 11 00 	movl   $0x117a36,(%esp)
  100051:	e8 5d 5d 00 00       	call   105db3 <memset>

    cons_init();                // init the console
  100056:	e8 78 15 00 00       	call   1015d3 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10005b:	c7 45 f4 40 5f 10 00 	movl   $0x105f40,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100065:	89 44 24 04          	mov    %eax,0x4(%esp)
  100069:	c7 04 24 5c 5f 10 00 	movl   $0x105f5c,(%esp)
  100070:	e8 c7 02 00 00       	call   10033c <cprintf>

    print_kerninfo();
  100075:	e8 f6 07 00 00       	call   100870 <print_kerninfo>

    grade_backtrace();
  10007a:	e8 86 00 00 00       	call   100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10007f:	e8 4a 42 00 00       	call   1042ce <pmm_init>

    pic_init();                 // init interrupt controller
  100084:	e8 b3 16 00 00       	call   10173c <pic_init>
    idt_init();                 // init interrupt descriptor table
  100089:	e8 05 18 00 00       	call   101893 <idt_init>

    clock_init();               // init clock interrupt
  10008e:	e8 f6 0c 00 00       	call   100d89 <clock_init>
    intr_enable();              // enable irq interrupt
  100093:	e8 12 16 00 00       	call   1016aa <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  100098:	eb fe                	jmp    100098 <kern_init+0x6e>

0010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  10009a:	55                   	push   %ebp
  10009b:	89 e5                	mov    %esp,%ebp
  10009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000a7:	00 
  1000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000af:	00 
  1000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000b7:	e8 ff 0b 00 00       	call   100cbb <mon_backtrace>
}
  1000bc:	c9                   	leave  
  1000bd:	c3                   	ret    

001000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000be:	55                   	push   %ebp
  1000bf:	89 e5                	mov    %esp,%ebp
  1000c1:	53                   	push   %ebx
  1000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  1000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000cb:	8d 55 08             	lea    0x8(%ebp),%edx
  1000ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000dd:	89 04 24             	mov    %eax,(%esp)
  1000e0:	e8 b5 ff ff ff       	call   10009a <grade_backtrace2>
}
  1000e5:	83 c4 14             	add    $0x14,%esp
  1000e8:	5b                   	pop    %ebx
  1000e9:	5d                   	pop    %ebp
  1000ea:	c3                   	ret    

001000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000eb:	55                   	push   %ebp
  1000ec:	89 e5                	mov    %esp,%ebp
  1000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000f1:	8b 45 10             	mov    0x10(%ebp),%eax
  1000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1000fb:	89 04 24             	mov    %eax,(%esp)
  1000fe:	e8 bb ff ff ff       	call   1000be <grade_backtrace1>
}
  100103:	c9                   	leave  
  100104:	c3                   	ret    

00100105 <grade_backtrace>:

void
grade_backtrace(void) {
  100105:	55                   	push   %ebp
  100106:	89 e5                	mov    %esp,%ebp
  100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10010b:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100117:	ff 
  100118:	89 44 24 04          	mov    %eax,0x4(%esp)
  10011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100123:	e8 c3 ff ff ff       	call   1000eb <grade_backtrace0>
}
  100128:	c9                   	leave  
  100129:	c3                   	ret    

0010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10012a:	55                   	push   %ebp
  10012b:	89 e5                	mov    %esp,%ebp
  10012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100140:	0f b7 c0             	movzwl %ax,%eax
  100143:	83 e0 03             	and    $0x3,%eax
  100146:	89 c2                	mov    %eax,%edx
  100148:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10014d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100151:	89 44 24 04          	mov    %eax,0x4(%esp)
  100155:	c7 04 24 61 5f 10 00 	movl   $0x105f61,(%esp)
  10015c:	e8 db 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100165:	0f b7 d0             	movzwl %ax,%edx
  100168:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10016d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100171:	89 44 24 04          	mov    %eax,0x4(%esp)
  100175:	c7 04 24 6f 5f 10 00 	movl   $0x105f6f,(%esp)
  10017c:	e8 bb 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100185:	0f b7 d0             	movzwl %ax,%edx
  100188:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10018d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100191:	89 44 24 04          	mov    %eax,0x4(%esp)
  100195:	c7 04 24 7d 5f 10 00 	movl   $0x105f7d,(%esp)
  10019c:	e8 9b 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001a5:	0f b7 d0             	movzwl %ax,%edx
  1001a8:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b5:	c7 04 24 8b 5f 10 00 	movl   $0x105f8b,(%esp)
  1001bc:	e8 7b 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001c5:	0f b7 d0             	movzwl %ax,%edx
  1001c8:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001d5:	c7 04 24 99 5f 10 00 	movl   $0x105f99,(%esp)
  1001dc:	e8 5b 01 00 00       	call   10033c <cprintf>
    round ++;
  1001e1:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001e6:	83 c0 01             	add    $0x1,%eax
  1001e9:	a3 40 7a 11 00       	mov    %eax,0x117a40
}
  1001ee:	c9                   	leave  
  1001ef:	c3                   	ret    

001001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001f0:	55                   	push   %ebp
  1001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001f3:	5d                   	pop    %ebp
  1001f4:	c3                   	ret    

001001f5 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001f5:	55                   	push   %ebp
  1001f6:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001f8:	5d                   	pop    %ebp
  1001f9:	c3                   	ret    

001001fa <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001fa:	55                   	push   %ebp
  1001fb:	89 e5                	mov    %esp,%ebp
  1001fd:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100200:	e8 25 ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100205:	c7 04 24 a8 5f 10 00 	movl   $0x105fa8,(%esp)
  10020c:	e8 2b 01 00 00       	call   10033c <cprintf>
    lab1_switch_to_user();
  100211:	e8 da ff ff ff       	call   1001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
  100216:	e8 0f ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10021b:	c7 04 24 c8 5f 10 00 	movl   $0x105fc8,(%esp)
  100222:	e8 15 01 00 00       	call   10033c <cprintf>
    lab1_switch_to_kernel();
  100227:	e8 c9 ff ff ff       	call   1001f5 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  10022c:	e8 f9 fe ff ff       	call   10012a <lab1_print_cur_status>
}
  100231:	c9                   	leave  
  100232:	c3                   	ret    

00100233 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100233:	55                   	push   %ebp
  100234:	89 e5                	mov    %esp,%ebp
  100236:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100239:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10023d:	74 13                	je     100252 <readline+0x1f>
        cprintf("%s", prompt);
  10023f:	8b 45 08             	mov    0x8(%ebp),%eax
  100242:	89 44 24 04          	mov    %eax,0x4(%esp)
  100246:	c7 04 24 e7 5f 10 00 	movl   $0x105fe7,(%esp)
  10024d:	e8 ea 00 00 00       	call   10033c <cprintf>
    }
    int i = 0, c;
  100252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100259:	e8 66 01 00 00       	call   1003c4 <getchar>
  10025e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100261:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100265:	79 07                	jns    10026e <readline+0x3b>
            return NULL;
  100267:	b8 00 00 00 00       	mov    $0x0,%eax
  10026c:	eb 79                	jmp    1002e7 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10026e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100272:	7e 28                	jle    10029c <readline+0x69>
  100274:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10027b:	7f 1f                	jg     10029c <readline+0x69>
            cputchar(c);
  10027d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100280:	89 04 24             	mov    %eax,(%esp)
  100283:	e8 da 00 00 00       	call   100362 <cputchar>
            buf[i ++] = c;
  100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10028b:	8d 50 01             	lea    0x1(%eax),%edx
  10028e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100291:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100294:	88 90 60 7a 11 00    	mov    %dl,0x117a60(%eax)
  10029a:	eb 46                	jmp    1002e2 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  10029c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1002a0:	75 17                	jne    1002b9 <readline+0x86>
  1002a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002a6:	7e 11                	jle    1002b9 <readline+0x86>
            cputchar(c);
  1002a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002ab:	89 04 24             	mov    %eax,(%esp)
  1002ae:	e8 af 00 00 00       	call   100362 <cputchar>
            i --;
  1002b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1002b7:	eb 29                	jmp    1002e2 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  1002b9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002bd:	74 06                	je     1002c5 <readline+0x92>
  1002bf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002c3:	75 1d                	jne    1002e2 <readline+0xaf>
            cputchar(c);
  1002c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002c8:	89 04 24             	mov    %eax,(%esp)
  1002cb:	e8 92 00 00 00       	call   100362 <cputchar>
            buf[i] = '\0';
  1002d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002d3:	05 60 7a 11 00       	add    $0x117a60,%eax
  1002d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002db:	b8 60 7a 11 00       	mov    $0x117a60,%eax
  1002e0:	eb 05                	jmp    1002e7 <readline+0xb4>
        }
    }
  1002e2:	e9 72 ff ff ff       	jmp    100259 <readline+0x26>
}
  1002e7:	c9                   	leave  
  1002e8:	c3                   	ret    

001002e9 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002e9:	55                   	push   %ebp
  1002ea:	89 e5                	mov    %esp,%ebp
  1002ec:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1002f2:	89 04 24             	mov    %eax,(%esp)
  1002f5:	e8 05 13 00 00       	call   1015ff <cons_putc>
    (*cnt) ++;
  1002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002fd:	8b 00                	mov    (%eax),%eax
  1002ff:	8d 50 01             	lea    0x1(%eax),%edx
  100302:	8b 45 0c             	mov    0xc(%ebp),%eax
  100305:	89 10                	mov    %edx,(%eax)
}
  100307:	c9                   	leave  
  100308:	c3                   	ret    

00100309 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100309:	55                   	push   %ebp
  10030a:	89 e5                	mov    %esp,%ebp
  10030c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10030f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100316:	8b 45 0c             	mov    0xc(%ebp),%eax
  100319:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10031d:	8b 45 08             	mov    0x8(%ebp),%eax
  100320:	89 44 24 08          	mov    %eax,0x8(%esp)
  100324:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100327:	89 44 24 04          	mov    %eax,0x4(%esp)
  10032b:	c7 04 24 e9 02 10 00 	movl   $0x1002e9,(%esp)
  100332:	e8 95 52 00 00       	call   1055cc <vprintfmt>
    return cnt;
  100337:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10033a:	c9                   	leave  
  10033b:	c3                   	ret    

0010033c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10033c:	55                   	push   %ebp
  10033d:	89 e5                	mov    %esp,%ebp
  10033f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100342:	8d 45 0c             	lea    0xc(%ebp),%eax
  100345:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100348:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10034b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10034f:	8b 45 08             	mov    0x8(%ebp),%eax
  100352:	89 04 24             	mov    %eax,(%esp)
  100355:	e8 af ff ff ff       	call   100309 <vcprintf>
  10035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10035d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100360:	c9                   	leave  
  100361:	c3                   	ret    

00100362 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100362:	55                   	push   %ebp
  100363:	89 e5                	mov    %esp,%ebp
  100365:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100368:	8b 45 08             	mov    0x8(%ebp),%eax
  10036b:	89 04 24             	mov    %eax,(%esp)
  10036e:	e8 8c 12 00 00       	call   1015ff <cons_putc>
}
  100373:	c9                   	leave  
  100374:	c3                   	ret    

00100375 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100375:	55                   	push   %ebp
  100376:	89 e5                	mov    %esp,%ebp
  100378:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10037b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100382:	eb 13                	jmp    100397 <cputs+0x22>
        cputch(c, &cnt);
  100384:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100388:	8d 55 f0             	lea    -0x10(%ebp),%edx
  10038b:	89 54 24 04          	mov    %edx,0x4(%esp)
  10038f:	89 04 24             	mov    %eax,(%esp)
  100392:	e8 52 ff ff ff       	call   1002e9 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  100397:	8b 45 08             	mov    0x8(%ebp),%eax
  10039a:	8d 50 01             	lea    0x1(%eax),%edx
  10039d:	89 55 08             	mov    %edx,0x8(%ebp)
  1003a0:	0f b6 00             	movzbl (%eax),%eax
  1003a3:	88 45 f7             	mov    %al,-0x9(%ebp)
  1003a6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003aa:	75 d8                	jne    100384 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1003ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003af:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003b3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003ba:	e8 2a ff ff ff       	call   1002e9 <cputch>
    return cnt;
  1003bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003c2:	c9                   	leave  
  1003c3:	c3                   	ret    

001003c4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003c4:	55                   	push   %ebp
  1003c5:	89 e5                	mov    %esp,%ebp
  1003c7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003ca:	e8 6c 12 00 00       	call   10163b <cons_getc>
  1003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003d6:	74 f2                	je     1003ca <getchar+0x6>
        /* do nothing */;
    return c;
  1003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003db:	c9                   	leave  
  1003dc:	c3                   	ret    

001003dd <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003dd:	55                   	push   %ebp
  1003de:	89 e5                	mov    %esp,%ebp
  1003e0:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003e6:	8b 00                	mov    (%eax),%eax
  1003e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1003ee:	8b 00                	mov    (%eax),%eax
  1003f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003fa:	e9 d2 00 00 00       	jmp    1004d1 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1003ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100402:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100405:	01 d0                	add    %edx,%eax
  100407:	89 c2                	mov    %eax,%edx
  100409:	c1 ea 1f             	shr    $0x1f,%edx
  10040c:	01 d0                	add    %edx,%eax
  10040e:	d1 f8                	sar    %eax
  100410:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100413:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100416:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100419:	eb 04                	jmp    10041f <stab_binsearch+0x42>
            m --;
  10041b:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10041f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100422:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100425:	7c 1f                	jl     100446 <stab_binsearch+0x69>
  100427:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10042a:	89 d0                	mov    %edx,%eax
  10042c:	01 c0                	add    %eax,%eax
  10042e:	01 d0                	add    %edx,%eax
  100430:	c1 e0 02             	shl    $0x2,%eax
  100433:	89 c2                	mov    %eax,%edx
  100435:	8b 45 08             	mov    0x8(%ebp),%eax
  100438:	01 d0                	add    %edx,%eax
  10043a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10043e:	0f b6 c0             	movzbl %al,%eax
  100441:	3b 45 14             	cmp    0x14(%ebp),%eax
  100444:	75 d5                	jne    10041b <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  100446:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100449:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10044c:	7d 0b                	jge    100459 <stab_binsearch+0x7c>
            l = true_m + 1;
  10044e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100451:	83 c0 01             	add    $0x1,%eax
  100454:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100457:	eb 78                	jmp    1004d1 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  100459:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100460:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100463:	89 d0                	mov    %edx,%eax
  100465:	01 c0                	add    %eax,%eax
  100467:	01 d0                	add    %edx,%eax
  100469:	c1 e0 02             	shl    $0x2,%eax
  10046c:	89 c2                	mov    %eax,%edx
  10046e:	8b 45 08             	mov    0x8(%ebp),%eax
  100471:	01 d0                	add    %edx,%eax
  100473:	8b 40 08             	mov    0x8(%eax),%eax
  100476:	3b 45 18             	cmp    0x18(%ebp),%eax
  100479:	73 13                	jae    10048e <stab_binsearch+0xb1>
            *region_left = m;
  10047b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10047e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100481:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100483:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100486:	83 c0 01             	add    $0x1,%eax
  100489:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10048c:	eb 43                	jmp    1004d1 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  10048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100491:	89 d0                	mov    %edx,%eax
  100493:	01 c0                	add    %eax,%eax
  100495:	01 d0                	add    %edx,%eax
  100497:	c1 e0 02             	shl    $0x2,%eax
  10049a:	89 c2                	mov    %eax,%edx
  10049c:	8b 45 08             	mov    0x8(%ebp),%eax
  10049f:	01 d0                	add    %edx,%eax
  1004a1:	8b 40 08             	mov    0x8(%eax),%eax
  1004a4:	3b 45 18             	cmp    0x18(%ebp),%eax
  1004a7:	76 16                	jbe    1004bf <stab_binsearch+0xe2>
            *region_right = m - 1;
  1004a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ac:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004af:	8b 45 10             	mov    0x10(%ebp),%eax
  1004b2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b7:	83 e8 01             	sub    $0x1,%eax
  1004ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004bd:	eb 12                	jmp    1004d1 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004c5:	89 10                	mov    %edx,(%eax)
            l = m;
  1004c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004cd:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004d7:	0f 8e 22 ff ff ff    	jle    1003ff <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004e1:	75 0f                	jne    1004f2 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004e6:	8b 00                	mov    (%eax),%eax
  1004e8:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1004ee:	89 10                	mov    %edx,(%eax)
  1004f0:	eb 3f                	jmp    100531 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004f2:	8b 45 10             	mov    0x10(%ebp),%eax
  1004f5:	8b 00                	mov    (%eax),%eax
  1004f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004fa:	eb 04                	jmp    100500 <stab_binsearch+0x123>
  1004fc:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  100500:	8b 45 0c             	mov    0xc(%ebp),%eax
  100503:	8b 00                	mov    (%eax),%eax
  100505:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100508:	7d 1f                	jge    100529 <stab_binsearch+0x14c>
  10050a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10050d:	89 d0                	mov    %edx,%eax
  10050f:	01 c0                	add    %eax,%eax
  100511:	01 d0                	add    %edx,%eax
  100513:	c1 e0 02             	shl    $0x2,%eax
  100516:	89 c2                	mov    %eax,%edx
  100518:	8b 45 08             	mov    0x8(%ebp),%eax
  10051b:	01 d0                	add    %edx,%eax
  10051d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100521:	0f b6 c0             	movzbl %al,%eax
  100524:	3b 45 14             	cmp    0x14(%ebp),%eax
  100527:	75 d3                	jne    1004fc <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  100529:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10052f:	89 10                	mov    %edx,(%eax)
    }
}
  100531:	c9                   	leave  
  100532:	c3                   	ret    

00100533 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100533:	55                   	push   %ebp
  100534:	89 e5                	mov    %esp,%ebp
  100536:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100539:	8b 45 0c             	mov    0xc(%ebp),%eax
  10053c:	c7 00 ec 5f 10 00    	movl   $0x105fec,(%eax)
    info->eip_line = 0;
  100542:	8b 45 0c             	mov    0xc(%ebp),%eax
  100545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10054c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10054f:	c7 40 08 ec 5f 10 00 	movl   $0x105fec,0x8(%eax)
    info->eip_fn_namelen = 9;
  100556:	8b 45 0c             	mov    0xc(%ebp),%eax
  100559:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100560:	8b 45 0c             	mov    0xc(%ebp),%eax
  100563:	8b 55 08             	mov    0x8(%ebp),%edx
  100566:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100569:	8b 45 0c             	mov    0xc(%ebp),%eax
  10056c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100573:	c7 45 f4 18 72 10 00 	movl   $0x107218,-0xc(%ebp)
    stab_end = __STAB_END__;
  10057a:	c7 45 f0 cc 1d 11 00 	movl   $0x111dcc,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100581:	c7 45 ec cd 1d 11 00 	movl   $0x111dcd,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100588:	c7 45 e8 12 48 11 00 	movl   $0x114812,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10058f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100592:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100595:	76 0d                	jbe    1005a4 <debuginfo_eip+0x71>
  100597:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10059a:	83 e8 01             	sub    $0x1,%eax
  10059d:	0f b6 00             	movzbl (%eax),%eax
  1005a0:	84 c0                	test   %al,%al
  1005a2:	74 0a                	je     1005ae <debuginfo_eip+0x7b>
        return -1;
  1005a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005a9:	e9 c0 02 00 00       	jmp    10086e <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1005ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1005b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005bb:	29 c2                	sub    %eax,%edx
  1005bd:	89 d0                	mov    %edx,%eax
  1005bf:	c1 f8 02             	sar    $0x2,%eax
  1005c2:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005c8:	83 e8 01             	sub    $0x1,%eax
  1005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1005d1:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005d5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005dc:	00 
  1005dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005e0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005ee:	89 04 24             	mov    %eax,(%esp)
  1005f1:	e8 e7 fd ff ff       	call   1003dd <stab_binsearch>
    if (lfile == 0)
  1005f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005f9:	85 c0                	test   %eax,%eax
  1005fb:	75 0a                	jne    100607 <debuginfo_eip+0xd4>
        return -1;
  1005fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100602:	e9 67 02 00 00       	jmp    10086e <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  100607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10060a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100610:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100613:	8b 45 08             	mov    0x8(%ebp),%eax
  100616:	89 44 24 10          	mov    %eax,0x10(%esp)
  10061a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100621:	00 
  100622:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100625:	89 44 24 08          	mov    %eax,0x8(%esp)
  100629:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10062c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100633:	89 04 24             	mov    %eax,(%esp)
  100636:	e8 a2 fd ff ff       	call   1003dd <stab_binsearch>

    if (lfun <= rfun) {
  10063b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10063e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100641:	39 c2                	cmp    %eax,%edx
  100643:	7f 7c                	jg     1006c1 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100645:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100648:	89 c2                	mov    %eax,%edx
  10064a:	89 d0                	mov    %edx,%eax
  10064c:	01 c0                	add    %eax,%eax
  10064e:	01 d0                	add    %edx,%eax
  100650:	c1 e0 02             	shl    $0x2,%eax
  100653:	89 c2                	mov    %eax,%edx
  100655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100658:	01 d0                	add    %edx,%eax
  10065a:	8b 10                	mov    (%eax),%edx
  10065c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10065f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100662:	29 c1                	sub    %eax,%ecx
  100664:	89 c8                	mov    %ecx,%eax
  100666:	39 c2                	cmp    %eax,%edx
  100668:	73 22                	jae    10068c <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10066a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10066d:	89 c2                	mov    %eax,%edx
  10066f:	89 d0                	mov    %edx,%eax
  100671:	01 c0                	add    %eax,%eax
  100673:	01 d0                	add    %edx,%eax
  100675:	c1 e0 02             	shl    $0x2,%eax
  100678:	89 c2                	mov    %eax,%edx
  10067a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10067d:	01 d0                	add    %edx,%eax
  10067f:	8b 10                	mov    (%eax),%edx
  100681:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100684:	01 c2                	add    %eax,%edx
  100686:	8b 45 0c             	mov    0xc(%ebp),%eax
  100689:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10068c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10068f:	89 c2                	mov    %eax,%edx
  100691:	89 d0                	mov    %edx,%eax
  100693:	01 c0                	add    %eax,%eax
  100695:	01 d0                	add    %edx,%eax
  100697:	c1 e0 02             	shl    $0x2,%eax
  10069a:	89 c2                	mov    %eax,%edx
  10069c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10069f:	01 d0                	add    %edx,%eax
  1006a1:	8b 50 08             	mov    0x8(%eax),%edx
  1006a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006a7:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006ad:	8b 40 10             	mov    0x10(%eax),%eax
  1006b0:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1006b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1006b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006bf:	eb 15                	jmp    1006d6 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c4:	8b 55 08             	mov    0x8(%ebp),%edx
  1006c7:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d9:	8b 40 08             	mov    0x8(%eax),%eax
  1006dc:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006e3:	00 
  1006e4:	89 04 24             	mov    %eax,(%esp)
  1006e7:	e8 3b 55 00 00       	call   105c27 <strfind>
  1006ec:	89 c2                	mov    %eax,%edx
  1006ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f1:	8b 40 08             	mov    0x8(%eax),%eax
  1006f4:	29 c2                	sub    %eax,%edx
  1006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f9:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1006ff:	89 44 24 10          	mov    %eax,0x10(%esp)
  100703:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  10070a:	00 
  10070b:	8d 45 d0             	lea    -0x30(%ebp),%eax
  10070e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100712:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100715:	89 44 24 04          	mov    %eax,0x4(%esp)
  100719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10071c:	89 04 24             	mov    %eax,(%esp)
  10071f:	e8 b9 fc ff ff       	call   1003dd <stab_binsearch>
    if (lline <= rline) {
  100724:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100727:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10072a:	39 c2                	cmp    %eax,%edx
  10072c:	7f 24                	jg     100752 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  10072e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100731:	89 c2                	mov    %eax,%edx
  100733:	89 d0                	mov    %edx,%eax
  100735:	01 c0                	add    %eax,%eax
  100737:	01 d0                	add    %edx,%eax
  100739:	c1 e0 02             	shl    $0x2,%eax
  10073c:	89 c2                	mov    %eax,%edx
  10073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100741:	01 d0                	add    %edx,%eax
  100743:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100747:	0f b7 d0             	movzwl %ax,%edx
  10074a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10074d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100750:	eb 13                	jmp    100765 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  100752:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100757:	e9 12 01 00 00       	jmp    10086e <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10075c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10075f:	83 e8 01             	sub    $0x1,%eax
  100762:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100765:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10076b:	39 c2                	cmp    %eax,%edx
  10076d:	7c 56                	jl     1007c5 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  10076f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100772:	89 c2                	mov    %eax,%edx
  100774:	89 d0                	mov    %edx,%eax
  100776:	01 c0                	add    %eax,%eax
  100778:	01 d0                	add    %edx,%eax
  10077a:	c1 e0 02             	shl    $0x2,%eax
  10077d:	89 c2                	mov    %eax,%edx
  10077f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100782:	01 d0                	add    %edx,%eax
  100784:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100788:	3c 84                	cmp    $0x84,%al
  10078a:	74 39                	je     1007c5 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10078c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10078f:	89 c2                	mov    %eax,%edx
  100791:	89 d0                	mov    %edx,%eax
  100793:	01 c0                	add    %eax,%eax
  100795:	01 d0                	add    %edx,%eax
  100797:	c1 e0 02             	shl    $0x2,%eax
  10079a:	89 c2                	mov    %eax,%edx
  10079c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10079f:	01 d0                	add    %edx,%eax
  1007a1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007a5:	3c 64                	cmp    $0x64,%al
  1007a7:	75 b3                	jne    10075c <debuginfo_eip+0x229>
  1007a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007ac:	89 c2                	mov    %eax,%edx
  1007ae:	89 d0                	mov    %edx,%eax
  1007b0:	01 c0                	add    %eax,%eax
  1007b2:	01 d0                	add    %edx,%eax
  1007b4:	c1 e0 02             	shl    $0x2,%eax
  1007b7:	89 c2                	mov    %eax,%edx
  1007b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007bc:	01 d0                	add    %edx,%eax
  1007be:	8b 40 08             	mov    0x8(%eax),%eax
  1007c1:	85 c0                	test   %eax,%eax
  1007c3:	74 97                	je     10075c <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007cb:	39 c2                	cmp    %eax,%edx
  1007cd:	7c 46                	jl     100815 <debuginfo_eip+0x2e2>
  1007cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007d2:	89 c2                	mov    %eax,%edx
  1007d4:	89 d0                	mov    %edx,%eax
  1007d6:	01 c0                	add    %eax,%eax
  1007d8:	01 d0                	add    %edx,%eax
  1007da:	c1 e0 02             	shl    $0x2,%eax
  1007dd:	89 c2                	mov    %eax,%edx
  1007df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007e2:	01 d0                	add    %edx,%eax
  1007e4:	8b 10                	mov    (%eax),%edx
  1007e6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007ec:	29 c1                	sub    %eax,%ecx
  1007ee:	89 c8                	mov    %ecx,%eax
  1007f0:	39 c2                	cmp    %eax,%edx
  1007f2:	73 21                	jae    100815 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007f7:	89 c2                	mov    %eax,%edx
  1007f9:	89 d0                	mov    %edx,%eax
  1007fb:	01 c0                	add    %eax,%eax
  1007fd:	01 d0                	add    %edx,%eax
  1007ff:	c1 e0 02             	shl    $0x2,%eax
  100802:	89 c2                	mov    %eax,%edx
  100804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100807:	01 d0                	add    %edx,%eax
  100809:	8b 10                	mov    (%eax),%edx
  10080b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10080e:	01 c2                	add    %eax,%edx
  100810:	8b 45 0c             	mov    0xc(%ebp),%eax
  100813:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100815:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100818:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10081b:	39 c2                	cmp    %eax,%edx
  10081d:	7d 4a                	jge    100869 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  10081f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100822:	83 c0 01             	add    $0x1,%eax
  100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100828:	eb 18                	jmp    100842 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  10082a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10082d:	8b 40 14             	mov    0x14(%eax),%eax
  100830:	8d 50 01             	lea    0x1(%eax),%edx
  100833:	8b 45 0c             	mov    0xc(%ebp),%eax
  100836:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  100839:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10083c:	83 c0 01             	add    $0x1,%eax
  10083f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100842:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100845:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  100848:	39 c2                	cmp    %eax,%edx
  10084a:	7d 1d                	jge    100869 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10084c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10084f:	89 c2                	mov    %eax,%edx
  100851:	89 d0                	mov    %edx,%eax
  100853:	01 c0                	add    %eax,%eax
  100855:	01 d0                	add    %edx,%eax
  100857:	c1 e0 02             	shl    $0x2,%eax
  10085a:	89 c2                	mov    %eax,%edx
  10085c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10085f:	01 d0                	add    %edx,%eax
  100861:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100865:	3c a0                	cmp    $0xa0,%al
  100867:	74 c1                	je     10082a <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  100869:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10086e:	c9                   	leave  
  10086f:	c3                   	ret    

00100870 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100870:	55                   	push   %ebp
  100871:	89 e5                	mov    %esp,%ebp
  100873:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100876:	c7 04 24 f6 5f 10 00 	movl   $0x105ff6,(%esp)
  10087d:	e8 ba fa ff ff       	call   10033c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100882:	c7 44 24 04 2a 00 10 	movl   $0x10002a,0x4(%esp)
  100889:	00 
  10088a:	c7 04 24 0f 60 10 00 	movl   $0x10600f,(%esp)
  100891:	e8 a6 fa ff ff       	call   10033c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100896:	c7 44 24 04 3c 5f 10 	movl   $0x105f3c,0x4(%esp)
  10089d:	00 
  10089e:	c7 04 24 27 60 10 00 	movl   $0x106027,(%esp)
  1008a5:	e8 92 fa ff ff       	call   10033c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1008aa:	c7 44 24 04 36 7a 11 	movl   $0x117a36,0x4(%esp)
  1008b1:	00 
  1008b2:	c7 04 24 3f 60 10 00 	movl   $0x10603f,(%esp)
  1008b9:	e8 7e fa ff ff       	call   10033c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008be:	c7 44 24 04 68 89 11 	movl   $0x118968,0x4(%esp)
  1008c5:	00 
  1008c6:	c7 04 24 57 60 10 00 	movl   $0x106057,(%esp)
  1008cd:	e8 6a fa ff ff       	call   10033c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008d2:	b8 68 89 11 00       	mov    $0x118968,%eax
  1008d7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008dd:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  1008e2:	29 c2                	sub    %eax,%edx
  1008e4:	89 d0                	mov    %edx,%eax
  1008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008ec:	85 c0                	test   %eax,%eax
  1008ee:	0f 48 c2             	cmovs  %edx,%eax
  1008f1:	c1 f8 0a             	sar    $0xa,%eax
  1008f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008f8:	c7 04 24 70 60 10 00 	movl   $0x106070,(%esp)
  1008ff:	e8 38 fa ff ff       	call   10033c <cprintf>
}
  100904:	c9                   	leave  
  100905:	c3                   	ret    

00100906 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100906:	55                   	push   %ebp
  100907:	89 e5                	mov    %esp,%ebp
  100909:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  10090f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100912:	89 44 24 04          	mov    %eax,0x4(%esp)
  100916:	8b 45 08             	mov    0x8(%ebp),%eax
  100919:	89 04 24             	mov    %eax,(%esp)
  10091c:	e8 12 fc ff ff       	call   100533 <debuginfo_eip>
  100921:	85 c0                	test   %eax,%eax
  100923:	74 15                	je     10093a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100925:	8b 45 08             	mov    0x8(%ebp),%eax
  100928:	89 44 24 04          	mov    %eax,0x4(%esp)
  10092c:	c7 04 24 9a 60 10 00 	movl   $0x10609a,(%esp)
  100933:	e8 04 fa ff ff       	call   10033c <cprintf>
  100938:	eb 6d                	jmp    1009a7 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100941:	eb 1c                	jmp    10095f <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100949:	01 d0                	add    %edx,%eax
  10094b:	0f b6 00             	movzbl (%eax),%eax
  10094e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100954:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100957:	01 ca                	add    %ecx,%edx
  100959:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10095b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10095f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100962:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  100965:	7f dc                	jg     100943 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  100967:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  10096d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100970:	01 d0                	add    %edx,%eax
  100972:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100975:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100978:	8b 55 08             	mov    0x8(%ebp),%edx
  10097b:	89 d1                	mov    %edx,%ecx
  10097d:	29 c1                	sub    %eax,%ecx
  10097f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100982:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100985:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100989:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10098f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100993:	89 54 24 08          	mov    %edx,0x8(%esp)
  100997:	89 44 24 04          	mov    %eax,0x4(%esp)
  10099b:	c7 04 24 b6 60 10 00 	movl   $0x1060b6,(%esp)
  1009a2:	e8 95 f9 ff ff       	call   10033c <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  1009a7:	c9                   	leave  
  1009a8:	c3                   	ret    

001009a9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  1009a9:	55                   	push   %ebp
  1009aa:	89 e5                	mov    %esp,%ebp
  1009ac:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  1009af:	8b 45 04             	mov    0x4(%ebp),%eax
  1009b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  1009b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1009b8:	c9                   	leave  
  1009b9:	c3                   	ret    

001009ba <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  1009ba:	55                   	push   %ebp
  1009bb:	89 e5                	mov    %esp,%ebp
  1009bd:	83 ec 28             	sub    $0x28,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009c0:	89 e8                	mov    %ebp,%eax
  1009c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return ebp;
  1009c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t current_ebp = read_ebp();
  1009c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t current_eip = read_eip();
  1009cb:	e8 d9 ff ff ff       	call   1009a9 <read_eip>
  1009d0:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while(current_ebp != 0)
  1009d3:	e9 9b 00 00 00       	jmp    100a73 <print_stackframe+0xb9>
	{
		cprintf("ebp:0x%08x ", current_ebp);
  1009d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009db:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009df:	c7 04 24 c8 60 10 00 	movl   $0x1060c8,(%esp)
  1009e6:	e8 51 f9 ff ff       	call   10033c <cprintf>
		cprintf("eip:0x%08x ", current_eip);
  1009eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009f2:	c7 04 24 d4 60 10 00 	movl   $0x1060d4,(%esp)
  1009f9:	e8 3e f9 ff ff       	call   10033c <cprintf>

		cprintf("args:");
  1009fe:	c7 04 24 e0 60 10 00 	movl   $0x1060e0,(%esp)
  100a05:	e8 32 f9 ff ff       	call   10033c <cprintf>
		int i = 0;
  100a0a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(i = 0; i < 4; i ++)
  100a11:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100a18:	eb 26                	jmp    100a40 <print_stackframe+0x86>
			cprintf("0x%08x ", (uint32_t)(*(uint32_t*)(current_ebp + 8 + 4*i)));
  100a1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100a1d:	c1 e0 02             	shl    $0x2,%eax
  100a20:	89 c2                	mov    %eax,%edx
  100a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a25:	01 d0                	add    %edx,%eax
  100a27:	83 c0 08             	add    $0x8,%eax
  100a2a:	8b 00                	mov    (%eax),%eax
  100a2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a30:	c7 04 24 e6 60 10 00 	movl   $0x1060e6,(%esp)
  100a37:	e8 00 f9 ff ff       	call   10033c <cprintf>
		cprintf("ebp:0x%08x ", current_ebp);
		cprintf("eip:0x%08x ", current_eip);

		cprintf("args:");
		int i = 0;
		for(i = 0; i < 4; i ++)
  100a3c:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a40:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
  100a44:	7e d4                	jle    100a1a <print_stackframe+0x60>
			cprintf("0x%08x ", (uint32_t)(*(uint32_t*)(current_ebp + 8 + 4*i)));
		cprintf("\n");
  100a46:	c7 04 24 ee 60 10 00 	movl   $0x1060ee,(%esp)
  100a4d:	e8 ea f8 ff ff       	call   10033c <cprintf>

		print_debuginfo(current_eip - sizeof(uint32_t));
  100a52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a55:	83 e8 04             	sub    $0x4,%eax
  100a58:	89 04 24             	mov    %eax,(%esp)
  100a5b:	e8 a6 fe ff ff       	call   100906 <print_debuginfo>

		current_eip = (uint32_t)(*(uint32_t*)(current_ebp + 4));
  100a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a63:	83 c0 04             	add    $0x4,%eax
  100a66:	8b 00                	mov    (%eax),%eax
  100a68:	89 45 f0             	mov    %eax,-0x10(%ebp)
		current_ebp = (uint32_t)(*(uint32_t*)current_ebp);
  100a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a6e:	8b 00                	mov    (%eax),%eax
  100a70:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t current_ebp = read_ebp();
	uint32_t current_eip = read_eip();

	while(current_ebp != 0)
  100a73:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a77:	0f 85 5b ff ff ff    	jne    1009d8 <print_stackframe+0x1e>

		current_eip = (uint32_t)(*(uint32_t*)(current_ebp + 4));
		current_ebp = (uint32_t)(*(uint32_t*)current_ebp);
	}

	return;
  100a7d:	90                   	nop
}
  100a7e:	c9                   	leave  
  100a7f:	c3                   	ret    

00100a80 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a80:	55                   	push   %ebp
  100a81:	89 e5                	mov    %esp,%ebp
  100a83:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a86:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a8d:	eb 0c                	jmp    100a9b <parse+0x1b>
            *buf ++ = '\0';
  100a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  100a92:	8d 50 01             	lea    0x1(%eax),%edx
  100a95:	89 55 08             	mov    %edx,0x8(%ebp)
  100a98:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  100a9e:	0f b6 00             	movzbl (%eax),%eax
  100aa1:	84 c0                	test   %al,%al
  100aa3:	74 1d                	je     100ac2 <parse+0x42>
  100aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  100aa8:	0f b6 00             	movzbl (%eax),%eax
  100aab:	0f be c0             	movsbl %al,%eax
  100aae:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ab2:	c7 04 24 70 61 10 00 	movl   $0x106170,(%esp)
  100ab9:	e8 36 51 00 00       	call   105bf4 <strchr>
  100abe:	85 c0                	test   %eax,%eax
  100ac0:	75 cd                	jne    100a8f <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  100ac5:	0f b6 00             	movzbl (%eax),%eax
  100ac8:	84 c0                	test   %al,%al
  100aca:	75 02                	jne    100ace <parse+0x4e>
            break;
  100acc:	eb 67                	jmp    100b35 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100ace:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100ad2:	75 14                	jne    100ae8 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100ad4:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100adb:	00 
  100adc:	c7 04 24 75 61 10 00 	movl   $0x106175,(%esp)
  100ae3:	e8 54 f8 ff ff       	call   10033c <cprintf>
        }
        argv[argc ++] = buf;
  100ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100aeb:	8d 50 01             	lea    0x1(%eax),%edx
  100aee:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100af1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100af8:	8b 45 0c             	mov    0xc(%ebp),%eax
  100afb:	01 c2                	add    %eax,%edx
  100afd:	8b 45 08             	mov    0x8(%ebp),%eax
  100b00:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b02:	eb 04                	jmp    100b08 <parse+0x88>
            buf ++;
  100b04:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b08:	8b 45 08             	mov    0x8(%ebp),%eax
  100b0b:	0f b6 00             	movzbl (%eax),%eax
  100b0e:	84 c0                	test   %al,%al
  100b10:	74 1d                	je     100b2f <parse+0xaf>
  100b12:	8b 45 08             	mov    0x8(%ebp),%eax
  100b15:	0f b6 00             	movzbl (%eax),%eax
  100b18:	0f be c0             	movsbl %al,%eax
  100b1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b1f:	c7 04 24 70 61 10 00 	movl   $0x106170,(%esp)
  100b26:	e8 c9 50 00 00       	call   105bf4 <strchr>
  100b2b:	85 c0                	test   %eax,%eax
  100b2d:	74 d5                	je     100b04 <parse+0x84>
            buf ++;
        }
    }
  100b2f:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b30:	e9 66 ff ff ff       	jmp    100a9b <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b38:	c9                   	leave  
  100b39:	c3                   	ret    

00100b3a <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b3a:	55                   	push   %ebp
  100b3b:	89 e5                	mov    %esp,%ebp
  100b3d:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b40:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b43:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b47:	8b 45 08             	mov    0x8(%ebp),%eax
  100b4a:	89 04 24             	mov    %eax,(%esp)
  100b4d:	e8 2e ff ff ff       	call   100a80 <parse>
  100b52:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b55:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b59:	75 0a                	jne    100b65 <runcmd+0x2b>
        return 0;
  100b5b:	b8 00 00 00 00       	mov    $0x0,%eax
  100b60:	e9 85 00 00 00       	jmp    100bea <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b65:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b6c:	eb 5c                	jmp    100bca <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b6e:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b74:	89 d0                	mov    %edx,%eax
  100b76:	01 c0                	add    %eax,%eax
  100b78:	01 d0                	add    %edx,%eax
  100b7a:	c1 e0 02             	shl    $0x2,%eax
  100b7d:	05 20 70 11 00       	add    $0x117020,%eax
  100b82:	8b 00                	mov    (%eax),%eax
  100b84:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b88:	89 04 24             	mov    %eax,(%esp)
  100b8b:	e8 c5 4f 00 00       	call   105b55 <strcmp>
  100b90:	85 c0                	test   %eax,%eax
  100b92:	75 32                	jne    100bc6 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b97:	89 d0                	mov    %edx,%eax
  100b99:	01 c0                	add    %eax,%eax
  100b9b:	01 d0                	add    %edx,%eax
  100b9d:	c1 e0 02             	shl    $0x2,%eax
  100ba0:	05 20 70 11 00       	add    $0x117020,%eax
  100ba5:	8b 40 08             	mov    0x8(%eax),%eax
  100ba8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100bab:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100bae:	8b 55 0c             	mov    0xc(%ebp),%edx
  100bb1:	89 54 24 08          	mov    %edx,0x8(%esp)
  100bb5:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100bb8:	83 c2 04             	add    $0x4,%edx
  100bbb:	89 54 24 04          	mov    %edx,0x4(%esp)
  100bbf:	89 0c 24             	mov    %ecx,(%esp)
  100bc2:	ff d0                	call   *%eax
  100bc4:	eb 24                	jmp    100bea <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bc6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bcd:	83 f8 02             	cmp    $0x2,%eax
  100bd0:	76 9c                	jbe    100b6e <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bd2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bd5:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bd9:	c7 04 24 93 61 10 00 	movl   $0x106193,(%esp)
  100be0:	e8 57 f7 ff ff       	call   10033c <cprintf>
    return 0;
  100be5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bea:	c9                   	leave  
  100beb:	c3                   	ret    

00100bec <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bec:	55                   	push   %ebp
  100bed:	89 e5                	mov    %esp,%ebp
  100bef:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bf2:	c7 04 24 ac 61 10 00 	movl   $0x1061ac,(%esp)
  100bf9:	e8 3e f7 ff ff       	call   10033c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bfe:	c7 04 24 d4 61 10 00 	movl   $0x1061d4,(%esp)
  100c05:	e8 32 f7 ff ff       	call   10033c <cprintf>

    if (tf != NULL) {
  100c0a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c0e:	74 0b                	je     100c1b <kmonitor+0x2f>
        print_trapframe(tf);
  100c10:	8b 45 08             	mov    0x8(%ebp),%eax
  100c13:	89 04 24             	mov    %eax,(%esp)
  100c16:	e8 89 0e 00 00       	call   101aa4 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c1b:	c7 04 24 f9 61 10 00 	movl   $0x1061f9,(%esp)
  100c22:	e8 0c f6 ff ff       	call   100233 <readline>
  100c27:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c2a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c2e:	74 18                	je     100c48 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100c30:	8b 45 08             	mov    0x8(%ebp),%eax
  100c33:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c3a:	89 04 24             	mov    %eax,(%esp)
  100c3d:	e8 f8 fe ff ff       	call   100b3a <runcmd>
  100c42:	85 c0                	test   %eax,%eax
  100c44:	79 02                	jns    100c48 <kmonitor+0x5c>
                break;
  100c46:	eb 02                	jmp    100c4a <kmonitor+0x5e>
            }
        }
    }
  100c48:	eb d1                	jmp    100c1b <kmonitor+0x2f>
}
  100c4a:	c9                   	leave  
  100c4b:	c3                   	ret    

00100c4c <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c4c:	55                   	push   %ebp
  100c4d:	89 e5                	mov    %esp,%ebp
  100c4f:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c52:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c59:	eb 3f                	jmp    100c9a <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c5e:	89 d0                	mov    %edx,%eax
  100c60:	01 c0                	add    %eax,%eax
  100c62:	01 d0                	add    %edx,%eax
  100c64:	c1 e0 02             	shl    $0x2,%eax
  100c67:	05 20 70 11 00       	add    $0x117020,%eax
  100c6c:	8b 48 04             	mov    0x4(%eax),%ecx
  100c6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c72:	89 d0                	mov    %edx,%eax
  100c74:	01 c0                	add    %eax,%eax
  100c76:	01 d0                	add    %edx,%eax
  100c78:	c1 e0 02             	shl    $0x2,%eax
  100c7b:	05 20 70 11 00       	add    $0x117020,%eax
  100c80:	8b 00                	mov    (%eax),%eax
  100c82:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c86:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c8a:	c7 04 24 fd 61 10 00 	movl   $0x1061fd,(%esp)
  100c91:	e8 a6 f6 ff ff       	call   10033c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c96:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c9d:	83 f8 02             	cmp    $0x2,%eax
  100ca0:	76 b9                	jbe    100c5b <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100ca2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ca7:	c9                   	leave  
  100ca8:	c3                   	ret    

00100ca9 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100ca9:	55                   	push   %ebp
  100caa:	89 e5                	mov    %esp,%ebp
  100cac:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100caf:	e8 bc fb ff ff       	call   100870 <print_kerninfo>
    return 0;
  100cb4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cb9:	c9                   	leave  
  100cba:	c3                   	ret    

00100cbb <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100cbb:	55                   	push   %ebp
  100cbc:	89 e5                	mov    %esp,%ebp
  100cbe:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100cc1:	e8 f4 fc ff ff       	call   1009ba <print_stackframe>
    return 0;
  100cc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ccb:	c9                   	leave  
  100ccc:	c3                   	ret    

00100ccd <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100ccd:	55                   	push   %ebp
  100cce:	89 e5                	mov    %esp,%ebp
  100cd0:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100cd3:	a1 60 7e 11 00       	mov    0x117e60,%eax
  100cd8:	85 c0                	test   %eax,%eax
  100cda:	74 02                	je     100cde <__panic+0x11>
        goto panic_dead;
  100cdc:	eb 48                	jmp    100d26 <__panic+0x59>
    }
    is_panic = 1;
  100cde:	c7 05 60 7e 11 00 01 	movl   $0x1,0x117e60
  100ce5:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100ce8:	8d 45 14             	lea    0x14(%ebp),%eax
  100ceb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100cee:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cf1:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  100cf8:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cfc:	c7 04 24 06 62 10 00 	movl   $0x106206,(%esp)
  100d03:	e8 34 f6 ff ff       	call   10033c <cprintf>
    vcprintf(fmt, ap);
  100d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d0f:	8b 45 10             	mov    0x10(%ebp),%eax
  100d12:	89 04 24             	mov    %eax,(%esp)
  100d15:	e8 ef f5 ff ff       	call   100309 <vcprintf>
    cprintf("\n");
  100d1a:	c7 04 24 22 62 10 00 	movl   $0x106222,(%esp)
  100d21:	e8 16 f6 ff ff       	call   10033c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
  100d26:	e8 85 09 00 00       	call   1016b0 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d2b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d32:	e8 b5 fe ff ff       	call   100bec <kmonitor>
    }
  100d37:	eb f2                	jmp    100d2b <__panic+0x5e>

00100d39 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d39:	55                   	push   %ebp
  100d3a:	89 e5                	mov    %esp,%ebp
  100d3c:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d3f:	8d 45 14             	lea    0x14(%ebp),%eax
  100d42:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d45:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d48:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  100d4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d53:	c7 04 24 24 62 10 00 	movl   $0x106224,(%esp)
  100d5a:	e8 dd f5 ff ff       	call   10033c <cprintf>
    vcprintf(fmt, ap);
  100d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d62:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d66:	8b 45 10             	mov    0x10(%ebp),%eax
  100d69:	89 04 24             	mov    %eax,(%esp)
  100d6c:	e8 98 f5 ff ff       	call   100309 <vcprintf>
    cprintf("\n");
  100d71:	c7 04 24 22 62 10 00 	movl   $0x106222,(%esp)
  100d78:	e8 bf f5 ff ff       	call   10033c <cprintf>
    va_end(ap);
}
  100d7d:	c9                   	leave  
  100d7e:	c3                   	ret    

00100d7f <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d7f:	55                   	push   %ebp
  100d80:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d82:	a1 60 7e 11 00       	mov    0x117e60,%eax
}
  100d87:	5d                   	pop    %ebp
  100d88:	c3                   	ret    

00100d89 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d89:	55                   	push   %ebp
  100d8a:	89 e5                	mov    %esp,%ebp
  100d8c:	83 ec 28             	sub    $0x28,%esp
  100d8f:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d95:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100d99:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d9d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100da1:	ee                   	out    %al,(%dx)
  100da2:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100da8:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100dac:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100db0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100db4:	ee                   	out    %al,(%dx)
  100db5:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100dbb:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100dbf:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100dc3:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dc7:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dc8:	c7 05 4c 89 11 00 00 	movl   $0x0,0x11894c
  100dcf:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100dd2:	c7 04 24 42 62 10 00 	movl   $0x106242,(%esp)
  100dd9:	e8 5e f5 ff ff       	call   10033c <cprintf>
    pic_enable(IRQ_TIMER);
  100dde:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100de5:	e8 24 09 00 00       	call   10170e <pic_enable>
}
  100dea:	c9                   	leave  
  100deb:	c3                   	ret    

00100dec <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100dec:	55                   	push   %ebp
  100ded:	89 e5                	mov    %esp,%ebp
  100def:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100df2:	9c                   	pushf  
  100df3:	58                   	pop    %eax
  100df4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100dfa:	25 00 02 00 00       	and    $0x200,%eax
  100dff:	85 c0                	test   %eax,%eax
  100e01:	74 0c                	je     100e0f <__intr_save+0x23>
        intr_disable();
  100e03:	e8 a8 08 00 00       	call   1016b0 <intr_disable>
        return 1;
  100e08:	b8 01 00 00 00       	mov    $0x1,%eax
  100e0d:	eb 05                	jmp    100e14 <__intr_save+0x28>
    }
    return 0;
  100e0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e14:	c9                   	leave  
  100e15:	c3                   	ret    

00100e16 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e16:	55                   	push   %ebp
  100e17:	89 e5                	mov    %esp,%ebp
  100e19:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e1c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e20:	74 05                	je     100e27 <__intr_restore+0x11>
        intr_enable();
  100e22:	e8 83 08 00 00       	call   1016aa <intr_enable>
    }
}
  100e27:	c9                   	leave  
  100e28:	c3                   	ret    

00100e29 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e29:	55                   	push   %ebp
  100e2a:	89 e5                	mov    %esp,%ebp
  100e2c:	83 ec 10             	sub    $0x10,%esp
  100e2f:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e35:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e39:	89 c2                	mov    %eax,%edx
  100e3b:	ec                   	in     (%dx),%al
  100e3c:	88 45 fd             	mov    %al,-0x3(%ebp)
  100e3f:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e45:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e49:	89 c2                	mov    %eax,%edx
  100e4b:	ec                   	in     (%dx),%al
  100e4c:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e4f:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e55:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e59:	89 c2                	mov    %eax,%edx
  100e5b:	ec                   	in     (%dx),%al
  100e5c:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e5f:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e65:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e69:	89 c2                	mov    %eax,%edx
  100e6b:	ec                   	in     (%dx),%al
  100e6c:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e6f:	c9                   	leave  
  100e70:	c3                   	ret    

00100e71 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e71:	55                   	push   %ebp
  100e72:	89 e5                	mov    %esp,%ebp
  100e74:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e77:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e81:	0f b7 00             	movzwl (%eax),%eax
  100e84:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e8b:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e90:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e93:	0f b7 00             	movzwl (%eax),%eax
  100e96:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e9a:	74 12                	je     100eae <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100e9c:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100ea3:	66 c7 05 86 7e 11 00 	movw   $0x3b4,0x117e86
  100eaa:	b4 03 
  100eac:	eb 13                	jmp    100ec1 <cga_init+0x50>
    } else {
        *cp = was;
  100eae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eb1:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100eb5:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100eb8:	66 c7 05 86 7e 11 00 	movw   $0x3d4,0x117e86
  100ebf:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100ec1:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100ec8:	0f b7 c0             	movzwl %ax,%eax
  100ecb:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100ecf:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ed3:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100ed7:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100edb:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100edc:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100ee3:	83 c0 01             	add    $0x1,%eax
  100ee6:	0f b7 c0             	movzwl %ax,%eax
  100ee9:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100eed:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100ef1:	89 c2                	mov    %eax,%edx
  100ef3:	ec                   	in     (%dx),%al
  100ef4:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100ef7:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100efb:	0f b6 c0             	movzbl %al,%eax
  100efe:	c1 e0 08             	shl    $0x8,%eax
  100f01:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f04:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100f0b:	0f b7 c0             	movzwl %ax,%eax
  100f0e:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100f12:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f16:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f1a:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f1e:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100f1f:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100f26:	83 c0 01             	add    $0x1,%eax
  100f29:	0f b7 c0             	movzwl %ax,%eax
  100f2c:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f30:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100f34:	89 c2                	mov    %eax,%edx
  100f36:	ec                   	in     (%dx),%al
  100f37:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100f3a:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f3e:	0f b6 c0             	movzbl %al,%eax
  100f41:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f44:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f47:	a3 80 7e 11 00       	mov    %eax,0x117e80
    crt_pos = pos;
  100f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f4f:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
}
  100f55:	c9                   	leave  
  100f56:	c3                   	ret    

00100f57 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f57:	55                   	push   %ebp
  100f58:	89 e5                	mov    %esp,%ebp
  100f5a:	83 ec 48             	sub    $0x48,%esp
  100f5d:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f63:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f67:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f6b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f6f:	ee                   	out    %al,(%dx)
  100f70:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f76:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f7a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f7e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f82:	ee                   	out    %al,(%dx)
  100f83:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f89:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f8d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f91:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f95:	ee                   	out    %al,(%dx)
  100f96:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f9c:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100fa0:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100fa4:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fa8:	ee                   	out    %al,(%dx)
  100fa9:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100faf:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100fb3:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fb7:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fbb:	ee                   	out    %al,(%dx)
  100fbc:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100fc2:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100fc6:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fca:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fce:	ee                   	out    %al,(%dx)
  100fcf:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fd5:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100fd9:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fdd:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100fe1:	ee                   	out    %al,(%dx)
  100fe2:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fe8:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100fec:	89 c2                	mov    %eax,%edx
  100fee:	ec                   	in     (%dx),%al
  100fef:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100ff2:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100ff6:	3c ff                	cmp    $0xff,%al
  100ff8:	0f 95 c0             	setne  %al
  100ffb:	0f b6 c0             	movzbl %al,%eax
  100ffe:	a3 88 7e 11 00       	mov    %eax,0x117e88
  101003:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101009:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  10100d:	89 c2                	mov    %eax,%edx
  10100f:	ec                   	in     (%dx),%al
  101010:	88 45 d5             	mov    %al,-0x2b(%ebp)
  101013:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  101019:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  10101d:	89 c2                	mov    %eax,%edx
  10101f:	ec                   	in     (%dx),%al
  101020:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  101023:	a1 88 7e 11 00       	mov    0x117e88,%eax
  101028:	85 c0                	test   %eax,%eax
  10102a:	74 0c                	je     101038 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  10102c:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  101033:	e8 d6 06 00 00       	call   10170e <pic_enable>
    }
}
  101038:	c9                   	leave  
  101039:	c3                   	ret    

0010103a <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  10103a:	55                   	push   %ebp
  10103b:	89 e5                	mov    %esp,%ebp
  10103d:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101040:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101047:	eb 09                	jmp    101052 <lpt_putc_sub+0x18>
        delay();
  101049:	e8 db fd ff ff       	call   100e29 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10104e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101052:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  101058:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10105c:	89 c2                	mov    %eax,%edx
  10105e:	ec                   	in     (%dx),%al
  10105f:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101062:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101066:	84 c0                	test   %al,%al
  101068:	78 09                	js     101073 <lpt_putc_sub+0x39>
  10106a:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101071:	7e d6                	jle    101049 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  101073:	8b 45 08             	mov    0x8(%ebp),%eax
  101076:	0f b6 c0             	movzbl %al,%eax
  101079:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  10107f:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101082:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101086:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10108a:	ee                   	out    %al,(%dx)
  10108b:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101091:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101095:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101099:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10109d:	ee                   	out    %al,(%dx)
  10109e:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  1010a4:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  1010a8:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010ac:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010b0:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010b1:	c9                   	leave  
  1010b2:	c3                   	ret    

001010b3 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010b3:	55                   	push   %ebp
  1010b4:	89 e5                	mov    %esp,%ebp
  1010b6:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010b9:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010bd:	74 0d                	je     1010cc <lpt_putc+0x19>
        lpt_putc_sub(c);
  1010bf:	8b 45 08             	mov    0x8(%ebp),%eax
  1010c2:	89 04 24             	mov    %eax,(%esp)
  1010c5:	e8 70 ff ff ff       	call   10103a <lpt_putc_sub>
  1010ca:	eb 24                	jmp    1010f0 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  1010cc:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010d3:	e8 62 ff ff ff       	call   10103a <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010df:	e8 56 ff ff ff       	call   10103a <lpt_putc_sub>
        lpt_putc_sub('\b');
  1010e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010eb:	e8 4a ff ff ff       	call   10103a <lpt_putc_sub>
    }
}
  1010f0:	c9                   	leave  
  1010f1:	c3                   	ret    

001010f2 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010f2:	55                   	push   %ebp
  1010f3:	89 e5                	mov    %esp,%ebp
  1010f5:	53                   	push   %ebx
  1010f6:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1010fc:	b0 00                	mov    $0x0,%al
  1010fe:	85 c0                	test   %eax,%eax
  101100:	75 07                	jne    101109 <cga_putc+0x17>
        c |= 0x0700;
  101102:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101109:	8b 45 08             	mov    0x8(%ebp),%eax
  10110c:	0f b6 c0             	movzbl %al,%eax
  10110f:	83 f8 0a             	cmp    $0xa,%eax
  101112:	74 4c                	je     101160 <cga_putc+0x6e>
  101114:	83 f8 0d             	cmp    $0xd,%eax
  101117:	74 57                	je     101170 <cga_putc+0x7e>
  101119:	83 f8 08             	cmp    $0x8,%eax
  10111c:	0f 85 88 00 00 00    	jne    1011aa <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  101122:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101129:	66 85 c0             	test   %ax,%ax
  10112c:	74 30                	je     10115e <cga_putc+0x6c>
            crt_pos --;
  10112e:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101135:	83 e8 01             	sub    $0x1,%eax
  101138:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  10113e:	a1 80 7e 11 00       	mov    0x117e80,%eax
  101143:	0f b7 15 84 7e 11 00 	movzwl 0x117e84,%edx
  10114a:	0f b7 d2             	movzwl %dx,%edx
  10114d:	01 d2                	add    %edx,%edx
  10114f:	01 c2                	add    %eax,%edx
  101151:	8b 45 08             	mov    0x8(%ebp),%eax
  101154:	b0 00                	mov    $0x0,%al
  101156:	83 c8 20             	or     $0x20,%eax
  101159:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  10115c:	eb 72                	jmp    1011d0 <cga_putc+0xde>
  10115e:	eb 70                	jmp    1011d0 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  101160:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101167:	83 c0 50             	add    $0x50,%eax
  10116a:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101170:	0f b7 1d 84 7e 11 00 	movzwl 0x117e84,%ebx
  101177:	0f b7 0d 84 7e 11 00 	movzwl 0x117e84,%ecx
  10117e:	0f b7 c1             	movzwl %cx,%eax
  101181:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101187:	c1 e8 10             	shr    $0x10,%eax
  10118a:	89 c2                	mov    %eax,%edx
  10118c:	66 c1 ea 06          	shr    $0x6,%dx
  101190:	89 d0                	mov    %edx,%eax
  101192:	c1 e0 02             	shl    $0x2,%eax
  101195:	01 d0                	add    %edx,%eax
  101197:	c1 e0 04             	shl    $0x4,%eax
  10119a:	29 c1                	sub    %eax,%ecx
  10119c:	89 ca                	mov    %ecx,%edx
  10119e:	89 d8                	mov    %ebx,%eax
  1011a0:	29 d0                	sub    %edx,%eax
  1011a2:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
        break;
  1011a8:	eb 26                	jmp    1011d0 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011aa:	8b 0d 80 7e 11 00    	mov    0x117e80,%ecx
  1011b0:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011b7:	8d 50 01             	lea    0x1(%eax),%edx
  1011ba:	66 89 15 84 7e 11 00 	mov    %dx,0x117e84
  1011c1:	0f b7 c0             	movzwl %ax,%eax
  1011c4:	01 c0                	add    %eax,%eax
  1011c6:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1011c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1011cc:	66 89 02             	mov    %ax,(%edx)
        break;
  1011cf:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011d0:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011d7:	66 3d cf 07          	cmp    $0x7cf,%ax
  1011db:	76 5b                	jbe    101238 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011dd:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011e2:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011e8:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011ed:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1011f4:	00 
  1011f5:	89 54 24 04          	mov    %edx,0x4(%esp)
  1011f9:	89 04 24             	mov    %eax,(%esp)
  1011fc:	e8 f1 4b 00 00       	call   105df2 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101201:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101208:	eb 15                	jmp    10121f <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  10120a:	a1 80 7e 11 00       	mov    0x117e80,%eax
  10120f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101212:	01 d2                	add    %edx,%edx
  101214:	01 d0                	add    %edx,%eax
  101216:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10121b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10121f:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101226:	7e e2                	jle    10120a <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  101228:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10122f:	83 e8 50             	sub    $0x50,%eax
  101232:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101238:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  10123f:	0f b7 c0             	movzwl %ax,%eax
  101242:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  101246:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  10124a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10124e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101252:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101253:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10125a:	66 c1 e8 08          	shr    $0x8,%ax
  10125e:	0f b6 c0             	movzbl %al,%eax
  101261:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  101268:	83 c2 01             	add    $0x1,%edx
  10126b:	0f b7 d2             	movzwl %dx,%edx
  10126e:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  101272:	88 45 ed             	mov    %al,-0x13(%ebp)
  101275:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101279:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10127d:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  10127e:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  101285:	0f b7 c0             	movzwl %ax,%eax
  101288:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  10128c:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  101290:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101294:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101298:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101299:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1012a0:	0f b6 c0             	movzbl %al,%eax
  1012a3:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  1012aa:	83 c2 01             	add    $0x1,%edx
  1012ad:	0f b7 d2             	movzwl %dx,%edx
  1012b0:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  1012b4:	88 45 e5             	mov    %al,-0x1b(%ebp)
  1012b7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1012bb:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012bf:	ee                   	out    %al,(%dx)
}
  1012c0:	83 c4 34             	add    $0x34,%esp
  1012c3:	5b                   	pop    %ebx
  1012c4:	5d                   	pop    %ebp
  1012c5:	c3                   	ret    

001012c6 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012c6:	55                   	push   %ebp
  1012c7:	89 e5                	mov    %esp,%ebp
  1012c9:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012d3:	eb 09                	jmp    1012de <serial_putc_sub+0x18>
        delay();
  1012d5:	e8 4f fb ff ff       	call   100e29 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012da:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1012de:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1012e4:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012e8:	89 c2                	mov    %eax,%edx
  1012ea:	ec                   	in     (%dx),%al
  1012eb:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012ee:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1012f2:	0f b6 c0             	movzbl %al,%eax
  1012f5:	83 e0 20             	and    $0x20,%eax
  1012f8:	85 c0                	test   %eax,%eax
  1012fa:	75 09                	jne    101305 <serial_putc_sub+0x3f>
  1012fc:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101303:	7e d0                	jle    1012d5 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  101305:	8b 45 08             	mov    0x8(%ebp),%eax
  101308:	0f b6 c0             	movzbl %al,%eax
  10130b:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101311:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101314:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101318:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10131c:	ee                   	out    %al,(%dx)
}
  10131d:	c9                   	leave  
  10131e:	c3                   	ret    

0010131f <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  10131f:	55                   	push   %ebp
  101320:	89 e5                	mov    %esp,%ebp
  101322:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101325:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101329:	74 0d                	je     101338 <serial_putc+0x19>
        serial_putc_sub(c);
  10132b:	8b 45 08             	mov    0x8(%ebp),%eax
  10132e:	89 04 24             	mov    %eax,(%esp)
  101331:	e8 90 ff ff ff       	call   1012c6 <serial_putc_sub>
  101336:	eb 24                	jmp    10135c <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  101338:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10133f:	e8 82 ff ff ff       	call   1012c6 <serial_putc_sub>
        serial_putc_sub(' ');
  101344:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10134b:	e8 76 ff ff ff       	call   1012c6 <serial_putc_sub>
        serial_putc_sub('\b');
  101350:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101357:	e8 6a ff ff ff       	call   1012c6 <serial_putc_sub>
    }
}
  10135c:	c9                   	leave  
  10135d:	c3                   	ret    

0010135e <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  10135e:	55                   	push   %ebp
  10135f:	89 e5                	mov    %esp,%ebp
  101361:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101364:	eb 33                	jmp    101399 <cons_intr+0x3b>
        if (c != 0) {
  101366:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10136a:	74 2d                	je     101399 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  10136c:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  101371:	8d 50 01             	lea    0x1(%eax),%edx
  101374:	89 15 a4 80 11 00    	mov    %edx,0x1180a4
  10137a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10137d:	88 90 a0 7e 11 00    	mov    %dl,0x117ea0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101383:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  101388:	3d 00 02 00 00       	cmp    $0x200,%eax
  10138d:	75 0a                	jne    101399 <cons_intr+0x3b>
                cons.wpos = 0;
  10138f:	c7 05 a4 80 11 00 00 	movl   $0x0,0x1180a4
  101396:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  101399:	8b 45 08             	mov    0x8(%ebp),%eax
  10139c:	ff d0                	call   *%eax
  10139e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1013a1:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1013a5:	75 bf                	jne    101366 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  1013a7:	c9                   	leave  
  1013a8:	c3                   	ret    

001013a9 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013a9:	55                   	push   %ebp
  1013aa:	89 e5                	mov    %esp,%ebp
  1013ac:	83 ec 10             	sub    $0x10,%esp
  1013af:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013b5:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013b9:	89 c2                	mov    %eax,%edx
  1013bb:	ec                   	in     (%dx),%al
  1013bc:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013bf:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013c3:	0f b6 c0             	movzbl %al,%eax
  1013c6:	83 e0 01             	and    $0x1,%eax
  1013c9:	85 c0                	test   %eax,%eax
  1013cb:	75 07                	jne    1013d4 <serial_proc_data+0x2b>
        return -1;
  1013cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013d2:	eb 2a                	jmp    1013fe <serial_proc_data+0x55>
  1013d4:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013da:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1013de:	89 c2                	mov    %eax,%edx
  1013e0:	ec                   	in     (%dx),%al
  1013e1:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1013e4:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013e8:	0f b6 c0             	movzbl %al,%eax
  1013eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013ee:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013f2:	75 07                	jne    1013fb <serial_proc_data+0x52>
        c = '\b';
  1013f4:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013fe:	c9                   	leave  
  1013ff:	c3                   	ret    

00101400 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101400:	55                   	push   %ebp
  101401:	89 e5                	mov    %esp,%ebp
  101403:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  101406:	a1 88 7e 11 00       	mov    0x117e88,%eax
  10140b:	85 c0                	test   %eax,%eax
  10140d:	74 0c                	je     10141b <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  10140f:	c7 04 24 a9 13 10 00 	movl   $0x1013a9,(%esp)
  101416:	e8 43 ff ff ff       	call   10135e <cons_intr>
    }
}
  10141b:	c9                   	leave  
  10141c:	c3                   	ret    

0010141d <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  10141d:	55                   	push   %ebp
  10141e:	89 e5                	mov    %esp,%ebp
  101420:	83 ec 38             	sub    $0x38,%esp
  101423:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101429:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10142d:	89 c2                	mov    %eax,%edx
  10142f:	ec                   	in     (%dx),%al
  101430:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  101433:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101437:	0f b6 c0             	movzbl %al,%eax
  10143a:	83 e0 01             	and    $0x1,%eax
  10143d:	85 c0                	test   %eax,%eax
  10143f:	75 0a                	jne    10144b <kbd_proc_data+0x2e>
        return -1;
  101441:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101446:	e9 59 01 00 00       	jmp    1015a4 <kbd_proc_data+0x187>
  10144b:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101451:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101455:	89 c2                	mov    %eax,%edx
  101457:	ec                   	in     (%dx),%al
  101458:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  10145b:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  10145f:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101462:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101466:	75 17                	jne    10147f <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  101468:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10146d:	83 c8 40             	or     $0x40,%eax
  101470:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  101475:	b8 00 00 00 00       	mov    $0x0,%eax
  10147a:	e9 25 01 00 00       	jmp    1015a4 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  10147f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101483:	84 c0                	test   %al,%al
  101485:	79 47                	jns    1014ce <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101487:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10148c:	83 e0 40             	and    $0x40,%eax
  10148f:	85 c0                	test   %eax,%eax
  101491:	75 09                	jne    10149c <kbd_proc_data+0x7f>
  101493:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101497:	83 e0 7f             	and    $0x7f,%eax
  10149a:	eb 04                	jmp    1014a0 <kbd_proc_data+0x83>
  10149c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a0:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1014a3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a7:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1014ae:	83 c8 40             	or     $0x40,%eax
  1014b1:	0f b6 c0             	movzbl %al,%eax
  1014b4:	f7 d0                	not    %eax
  1014b6:	89 c2                	mov    %eax,%edx
  1014b8:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014bd:	21 d0                	and    %edx,%eax
  1014bf:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  1014c4:	b8 00 00 00 00       	mov    $0x0,%eax
  1014c9:	e9 d6 00 00 00       	jmp    1015a4 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  1014ce:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014d3:	83 e0 40             	and    $0x40,%eax
  1014d6:	85 c0                	test   %eax,%eax
  1014d8:	74 11                	je     1014eb <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014da:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014de:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014e3:	83 e0 bf             	and    $0xffffffbf,%eax
  1014e6:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    }

    shift |= shiftcode[data];
  1014eb:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014ef:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1014f6:	0f b6 d0             	movzbl %al,%edx
  1014f9:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014fe:	09 d0                	or     %edx,%eax
  101500:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    shift ^= togglecode[data];
  101505:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101509:	0f b6 80 60 71 11 00 	movzbl 0x117160(%eax),%eax
  101510:	0f b6 d0             	movzbl %al,%edx
  101513:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101518:	31 d0                	xor    %edx,%eax
  10151a:	a3 a8 80 11 00       	mov    %eax,0x1180a8

    c = charcode[shift & (CTL | SHIFT)][data];
  10151f:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101524:	83 e0 03             	and    $0x3,%eax
  101527:	8b 14 85 60 75 11 00 	mov    0x117560(,%eax,4),%edx
  10152e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101532:	01 d0                	add    %edx,%eax
  101534:	0f b6 00             	movzbl (%eax),%eax
  101537:	0f b6 c0             	movzbl %al,%eax
  10153a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  10153d:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101542:	83 e0 08             	and    $0x8,%eax
  101545:	85 c0                	test   %eax,%eax
  101547:	74 22                	je     10156b <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  101549:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  10154d:	7e 0c                	jle    10155b <kbd_proc_data+0x13e>
  10154f:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101553:	7f 06                	jg     10155b <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  101555:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101559:	eb 10                	jmp    10156b <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  10155b:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  10155f:	7e 0a                	jle    10156b <kbd_proc_data+0x14e>
  101561:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101565:	7f 04                	jg     10156b <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  101567:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  10156b:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101570:	f7 d0                	not    %eax
  101572:	83 e0 06             	and    $0x6,%eax
  101575:	85 c0                	test   %eax,%eax
  101577:	75 28                	jne    1015a1 <kbd_proc_data+0x184>
  101579:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101580:	75 1f                	jne    1015a1 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  101582:	c7 04 24 5d 62 10 00 	movl   $0x10625d,(%esp)
  101589:	e8 ae ed ff ff       	call   10033c <cprintf>
  10158e:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101594:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101598:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  10159c:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  1015a0:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1015a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1015a4:	c9                   	leave  
  1015a5:	c3                   	ret    

001015a6 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1015a6:	55                   	push   %ebp
  1015a7:	89 e5                	mov    %esp,%ebp
  1015a9:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1015ac:	c7 04 24 1d 14 10 00 	movl   $0x10141d,(%esp)
  1015b3:	e8 a6 fd ff ff       	call   10135e <cons_intr>
}
  1015b8:	c9                   	leave  
  1015b9:	c3                   	ret    

001015ba <kbd_init>:

static void
kbd_init(void) {
  1015ba:	55                   	push   %ebp
  1015bb:	89 e5                	mov    %esp,%ebp
  1015bd:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1015c0:	e8 e1 ff ff ff       	call   1015a6 <kbd_intr>
    pic_enable(IRQ_KBD);
  1015c5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1015cc:	e8 3d 01 00 00       	call   10170e <pic_enable>
}
  1015d1:	c9                   	leave  
  1015d2:	c3                   	ret    

001015d3 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015d3:	55                   	push   %ebp
  1015d4:	89 e5                	mov    %esp,%ebp
  1015d6:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1015d9:	e8 93 f8 ff ff       	call   100e71 <cga_init>
    serial_init();
  1015de:	e8 74 f9 ff ff       	call   100f57 <serial_init>
    kbd_init();
  1015e3:	e8 d2 ff ff ff       	call   1015ba <kbd_init>
    if (!serial_exists) {
  1015e8:	a1 88 7e 11 00       	mov    0x117e88,%eax
  1015ed:	85 c0                	test   %eax,%eax
  1015ef:	75 0c                	jne    1015fd <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  1015f1:	c7 04 24 69 62 10 00 	movl   $0x106269,(%esp)
  1015f8:	e8 3f ed ff ff       	call   10033c <cprintf>
    }
}
  1015fd:	c9                   	leave  
  1015fe:	c3                   	ret    

001015ff <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015ff:	55                   	push   %ebp
  101600:	89 e5                	mov    %esp,%ebp
  101602:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  101605:	e8 e2 f7 ff ff       	call   100dec <__intr_save>
  10160a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  10160d:	8b 45 08             	mov    0x8(%ebp),%eax
  101610:	89 04 24             	mov    %eax,(%esp)
  101613:	e8 9b fa ff ff       	call   1010b3 <lpt_putc>
        cga_putc(c);
  101618:	8b 45 08             	mov    0x8(%ebp),%eax
  10161b:	89 04 24             	mov    %eax,(%esp)
  10161e:	e8 cf fa ff ff       	call   1010f2 <cga_putc>
        serial_putc(c);
  101623:	8b 45 08             	mov    0x8(%ebp),%eax
  101626:	89 04 24             	mov    %eax,(%esp)
  101629:	e8 f1 fc ff ff       	call   10131f <serial_putc>
    }
    local_intr_restore(intr_flag);
  10162e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101631:	89 04 24             	mov    %eax,(%esp)
  101634:	e8 dd f7 ff ff       	call   100e16 <__intr_restore>
}
  101639:	c9                   	leave  
  10163a:	c3                   	ret    

0010163b <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  10163b:	55                   	push   %ebp
  10163c:	89 e5                	mov    %esp,%ebp
  10163e:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  101641:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  101648:	e8 9f f7 ff ff       	call   100dec <__intr_save>
  10164d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  101650:	e8 ab fd ff ff       	call   101400 <serial_intr>
        kbd_intr();
  101655:	e8 4c ff ff ff       	call   1015a6 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  10165a:	8b 15 a0 80 11 00    	mov    0x1180a0,%edx
  101660:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  101665:	39 c2                	cmp    %eax,%edx
  101667:	74 31                	je     10169a <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  101669:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  10166e:	8d 50 01             	lea    0x1(%eax),%edx
  101671:	89 15 a0 80 11 00    	mov    %edx,0x1180a0
  101677:	0f b6 80 a0 7e 11 00 	movzbl 0x117ea0(%eax),%eax
  10167e:	0f b6 c0             	movzbl %al,%eax
  101681:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  101684:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  101689:	3d 00 02 00 00       	cmp    $0x200,%eax
  10168e:	75 0a                	jne    10169a <cons_getc+0x5f>
                cons.rpos = 0;
  101690:	c7 05 a0 80 11 00 00 	movl   $0x0,0x1180a0
  101697:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  10169a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10169d:	89 04 24             	mov    %eax,(%esp)
  1016a0:	e8 71 f7 ff ff       	call   100e16 <__intr_restore>
    return c;
  1016a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1016a8:	c9                   	leave  
  1016a9:	c3                   	ret    

001016aa <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1016aa:	55                   	push   %ebp
  1016ab:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
  1016ad:	fb                   	sti    
    sti();
}
  1016ae:	5d                   	pop    %ebp
  1016af:	c3                   	ret    

001016b0 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1016b0:	55                   	push   %ebp
  1016b1:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
  1016b3:	fa                   	cli    
    cli();
}
  1016b4:	5d                   	pop    %ebp
  1016b5:	c3                   	ret    

001016b6 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016b6:	55                   	push   %ebp
  1016b7:	89 e5                	mov    %esp,%ebp
  1016b9:	83 ec 14             	sub    $0x14,%esp
  1016bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1016bf:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016c3:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016c7:	66 a3 70 75 11 00    	mov    %ax,0x117570
    if (did_init) {
  1016cd:	a1 ac 80 11 00       	mov    0x1180ac,%eax
  1016d2:	85 c0                	test   %eax,%eax
  1016d4:	74 36                	je     10170c <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1016d6:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016da:	0f b6 c0             	movzbl %al,%eax
  1016dd:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016e3:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1016e6:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016ea:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016ee:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  1016ef:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016f3:	66 c1 e8 08          	shr    $0x8,%ax
  1016f7:	0f b6 c0             	movzbl %al,%eax
  1016fa:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101700:	88 45 f9             	mov    %al,-0x7(%ebp)
  101703:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101707:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10170b:	ee                   	out    %al,(%dx)
    }
}
  10170c:	c9                   	leave  
  10170d:	c3                   	ret    

0010170e <pic_enable>:

void
pic_enable(unsigned int irq) {
  10170e:	55                   	push   %ebp
  10170f:	89 e5                	mov    %esp,%ebp
  101711:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101714:	8b 45 08             	mov    0x8(%ebp),%eax
  101717:	ba 01 00 00 00       	mov    $0x1,%edx
  10171c:	89 c1                	mov    %eax,%ecx
  10171e:	d3 e2                	shl    %cl,%edx
  101720:	89 d0                	mov    %edx,%eax
  101722:	f7 d0                	not    %eax
  101724:	89 c2                	mov    %eax,%edx
  101726:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  10172d:	21 d0                	and    %edx,%eax
  10172f:	0f b7 c0             	movzwl %ax,%eax
  101732:	89 04 24             	mov    %eax,(%esp)
  101735:	e8 7c ff ff ff       	call   1016b6 <pic_setmask>
}
  10173a:	c9                   	leave  
  10173b:	c3                   	ret    

0010173c <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10173c:	55                   	push   %ebp
  10173d:	89 e5                	mov    %esp,%ebp
  10173f:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101742:	c7 05 ac 80 11 00 01 	movl   $0x1,0x1180ac
  101749:	00 00 00 
  10174c:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101752:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  101756:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10175a:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10175e:	ee                   	out    %al,(%dx)
  10175f:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101765:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  101769:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10176d:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101771:	ee                   	out    %al,(%dx)
  101772:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101778:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  10177c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101780:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101784:	ee                   	out    %al,(%dx)
  101785:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  10178b:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  10178f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101793:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101797:	ee                   	out    %al,(%dx)
  101798:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  10179e:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  1017a2:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1017a6:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1017aa:	ee                   	out    %al,(%dx)
  1017ab:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  1017b1:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  1017b5:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1017b9:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1017bd:	ee                   	out    %al,(%dx)
  1017be:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  1017c4:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  1017c8:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1017cc:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017d0:	ee                   	out    %al,(%dx)
  1017d1:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  1017d7:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  1017db:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017df:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1017e3:	ee                   	out    %al,(%dx)
  1017e4:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  1017ea:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  1017ee:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017f2:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1017f6:	ee                   	out    %al,(%dx)
  1017f7:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  1017fd:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  101801:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101805:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101809:	ee                   	out    %al,(%dx)
  10180a:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  101810:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  101814:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101818:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10181c:	ee                   	out    %al,(%dx)
  10181d:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101823:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  101827:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  10182b:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  10182f:	ee                   	out    %al,(%dx)
  101830:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  101836:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  10183a:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  10183e:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101842:	ee                   	out    %al,(%dx)
  101843:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  101849:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  10184d:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  101851:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  101855:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101856:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  10185d:	66 83 f8 ff          	cmp    $0xffff,%ax
  101861:	74 12                	je     101875 <pic_init+0x139>
        pic_setmask(irq_mask);
  101863:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  10186a:	0f b7 c0             	movzwl %ax,%eax
  10186d:	89 04 24             	mov    %eax,(%esp)
  101870:	e8 41 fe ff ff       	call   1016b6 <pic_setmask>
    }
}
  101875:	c9                   	leave  
  101876:	c3                   	ret    

00101877 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101877:	55                   	push   %ebp
  101878:	89 e5                	mov    %esp,%ebp
  10187a:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  10187d:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101884:	00 
  101885:	c7 04 24 a0 62 10 00 	movl   $0x1062a0,(%esp)
  10188c:	e8 ab ea ff ff       	call   10033c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  101891:	c9                   	leave  
  101892:	c3                   	ret    

00101893 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101893:	55                   	push   %ebp
  101894:	89 e5                	mov    %esp,%ebp
  101896:	83 ec 10             	sub    $0x10,%esp
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	int i = 0;
  101899:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for(i = 0; i < 256; i ++)
  1018a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1018a7:	e9 94 01 00 00       	jmp    101a40 <idt_init+0x1ad>
	{
		if(i != T_SYSCALL)
  1018ac:	81 7d fc 80 00 00 00 	cmpl   $0x80,-0x4(%ebp)
  1018b3:	0f 84 c4 00 00 00    	je     10197d <idt_init+0xea>
		{
			SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  1018b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018bc:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  1018c3:	89 c2                	mov    %eax,%edx
  1018c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018c8:	66 89 14 c5 c0 80 11 	mov    %dx,0x1180c0(,%eax,8)
  1018cf:	00 
  1018d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018d3:	66 c7 04 c5 c2 80 11 	movw   $0x8,0x1180c2(,%eax,8)
  1018da:	00 08 00 
  1018dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e0:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  1018e7:	00 
  1018e8:	83 e2 e0             	and    $0xffffffe0,%edx
  1018eb:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  1018f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f5:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  1018fc:	00 
  1018fd:	83 e2 1f             	and    $0x1f,%edx
  101900:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  101907:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10190a:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101911:	00 
  101912:	83 e2 f0             	and    $0xfffffff0,%edx
  101915:	83 ca 0e             	or     $0xe,%edx
  101918:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  10191f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101922:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101929:	00 
  10192a:	83 e2 ef             	and    $0xffffffef,%edx
  10192d:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101934:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101937:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  10193e:	00 
  10193f:	83 e2 9f             	and    $0xffffff9f,%edx
  101942:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101949:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10194c:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101953:	00 
  101954:	83 ca 80             	or     $0xffffff80,%edx
  101957:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  10195e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101961:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  101968:	c1 e8 10             	shr    $0x10,%eax
  10196b:	89 c2                	mov    %eax,%edx
  10196d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101970:	66 89 14 c5 c6 80 11 	mov    %dx,0x1180c6(,%eax,8)
  101977:	00 
  101978:	e9 bf 00 00 00       	jmp    101a3c <idt_init+0x1a9>
		}
		else
		{
			SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_USER);
  10197d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101980:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  101987:	89 c2                	mov    %eax,%edx
  101989:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10198c:	66 89 14 c5 c0 80 11 	mov    %dx,0x1180c0(,%eax,8)
  101993:	00 
  101994:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101997:	66 c7 04 c5 c2 80 11 	movw   $0x8,0x1180c2(,%eax,8)
  10199e:	00 08 00 
  1019a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019a4:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  1019ab:	00 
  1019ac:	83 e2 e0             	and    $0xffffffe0,%edx
  1019af:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  1019b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019b9:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  1019c0:	00 
  1019c1:	83 e2 1f             	and    $0x1f,%edx
  1019c4:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  1019cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019ce:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  1019d5:	00 
  1019d6:	83 e2 f0             	and    $0xfffffff0,%edx
  1019d9:	83 ca 0e             	or     $0xe,%edx
  1019dc:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  1019e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019e6:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  1019ed:	00 
  1019ee:	83 e2 ef             	and    $0xffffffef,%edx
  1019f1:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  1019f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019fb:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101a02:	00 
  101a03:	83 ca 60             	or     $0x60,%edx
  101a06:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101a0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a10:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101a17:	00 
  101a18:	83 ca 80             	or     $0xffffff80,%edx
  101a1b:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101a22:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a25:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  101a2c:	c1 e8 10             	shr    $0x10,%eax
  101a2f:	89 c2                	mov    %eax,%edx
  101a31:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a34:	66 89 14 c5 c6 80 11 	mov    %dx,0x1180c6(,%eax,8)
  101a3b:	00 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	int i = 0;
	for(i = 0; i < 256; i ++)
  101a3c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101a40:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  101a47:	0f 8e 5f fe ff ff    	jle    1018ac <idt_init+0x19>
  101a4d:	c7 45 f8 80 75 11 00 	movl   $0x117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101a54:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101a57:	0f 01 18             	lidtl  (%eax)
		}
	}

	lidt(&idt_pd);

	return;
  101a5a:	90                   	nop
}
  101a5b:	c9                   	leave  
  101a5c:	c3                   	ret    

00101a5d <trapname>:

static const char *
trapname(int trapno) {
  101a5d:	55                   	push   %ebp
  101a5e:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101a60:	8b 45 08             	mov    0x8(%ebp),%eax
  101a63:	83 f8 13             	cmp    $0x13,%eax
  101a66:	77 0c                	ja     101a74 <trapname+0x17>
        return excnames[trapno];
  101a68:	8b 45 08             	mov    0x8(%ebp),%eax
  101a6b:	8b 04 85 00 66 10 00 	mov    0x106600(,%eax,4),%eax
  101a72:	eb 18                	jmp    101a8c <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101a74:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a78:	7e 0d                	jle    101a87 <trapname+0x2a>
  101a7a:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a7e:	7f 07                	jg     101a87 <trapname+0x2a>
        return "Hardware Interrupt";
  101a80:	b8 aa 62 10 00       	mov    $0x1062aa,%eax
  101a85:	eb 05                	jmp    101a8c <trapname+0x2f>
    }
    return "(unknown trap)";
  101a87:	b8 bd 62 10 00       	mov    $0x1062bd,%eax
}
  101a8c:	5d                   	pop    %ebp
  101a8d:	c3                   	ret    

00101a8e <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101a8e:	55                   	push   %ebp
  101a8f:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a91:	8b 45 08             	mov    0x8(%ebp),%eax
  101a94:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a98:	66 83 f8 08          	cmp    $0x8,%ax
  101a9c:	0f 94 c0             	sete   %al
  101a9f:	0f b6 c0             	movzbl %al,%eax
}
  101aa2:	5d                   	pop    %ebp
  101aa3:	c3                   	ret    

00101aa4 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101aa4:	55                   	push   %ebp
  101aa5:	89 e5                	mov    %esp,%ebp
  101aa7:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  101aad:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ab1:	c7 04 24 fe 62 10 00 	movl   $0x1062fe,(%esp)
  101ab8:	e8 7f e8 ff ff       	call   10033c <cprintf>
    print_regs(&tf->tf_regs);
  101abd:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac0:	89 04 24             	mov    %eax,(%esp)
  101ac3:	e8 a1 01 00 00       	call   101c69 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  101acb:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101acf:	0f b7 c0             	movzwl %ax,%eax
  101ad2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ad6:	c7 04 24 0f 63 10 00 	movl   $0x10630f,(%esp)
  101add:	e8 5a e8 ff ff       	call   10033c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  101ae5:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101ae9:	0f b7 c0             	movzwl %ax,%eax
  101aec:	89 44 24 04          	mov    %eax,0x4(%esp)
  101af0:	c7 04 24 22 63 10 00 	movl   $0x106322,(%esp)
  101af7:	e8 40 e8 ff ff       	call   10033c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101afc:	8b 45 08             	mov    0x8(%ebp),%eax
  101aff:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101b03:	0f b7 c0             	movzwl %ax,%eax
  101b06:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b0a:	c7 04 24 35 63 10 00 	movl   $0x106335,(%esp)
  101b11:	e8 26 e8 ff ff       	call   10033c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101b16:	8b 45 08             	mov    0x8(%ebp),%eax
  101b19:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101b1d:	0f b7 c0             	movzwl %ax,%eax
  101b20:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b24:	c7 04 24 48 63 10 00 	movl   $0x106348,(%esp)
  101b2b:	e8 0c e8 ff ff       	call   10033c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101b30:	8b 45 08             	mov    0x8(%ebp),%eax
  101b33:	8b 40 30             	mov    0x30(%eax),%eax
  101b36:	89 04 24             	mov    %eax,(%esp)
  101b39:	e8 1f ff ff ff       	call   101a5d <trapname>
  101b3e:	8b 55 08             	mov    0x8(%ebp),%edx
  101b41:	8b 52 30             	mov    0x30(%edx),%edx
  101b44:	89 44 24 08          	mov    %eax,0x8(%esp)
  101b48:	89 54 24 04          	mov    %edx,0x4(%esp)
  101b4c:	c7 04 24 5b 63 10 00 	movl   $0x10635b,(%esp)
  101b53:	e8 e4 e7 ff ff       	call   10033c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b58:	8b 45 08             	mov    0x8(%ebp),%eax
  101b5b:	8b 40 34             	mov    0x34(%eax),%eax
  101b5e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b62:	c7 04 24 6d 63 10 00 	movl   $0x10636d,(%esp)
  101b69:	e8 ce e7 ff ff       	call   10033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b71:	8b 40 38             	mov    0x38(%eax),%eax
  101b74:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b78:	c7 04 24 7c 63 10 00 	movl   $0x10637c,(%esp)
  101b7f:	e8 b8 e7 ff ff       	call   10033c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b84:	8b 45 08             	mov    0x8(%ebp),%eax
  101b87:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b8b:	0f b7 c0             	movzwl %ax,%eax
  101b8e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b92:	c7 04 24 8b 63 10 00 	movl   $0x10638b,(%esp)
  101b99:	e8 9e e7 ff ff       	call   10033c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  101ba1:	8b 40 40             	mov    0x40(%eax),%eax
  101ba4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ba8:	c7 04 24 9e 63 10 00 	movl   $0x10639e,(%esp)
  101baf:	e8 88 e7 ff ff       	call   10033c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101bb4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101bbb:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101bc2:	eb 3e                	jmp    101c02 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  101bc7:	8b 50 40             	mov    0x40(%eax),%edx
  101bca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101bcd:	21 d0                	and    %edx,%eax
  101bcf:	85 c0                	test   %eax,%eax
  101bd1:	74 28                	je     101bfb <print_trapframe+0x157>
  101bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bd6:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101bdd:	85 c0                	test   %eax,%eax
  101bdf:	74 1a                	je     101bfb <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101be1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101be4:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101beb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bef:	c7 04 24 ad 63 10 00 	movl   $0x1063ad,(%esp)
  101bf6:	e8 41 e7 ff ff       	call   10033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101bfb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101bff:	d1 65 f0             	shll   -0x10(%ebp)
  101c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c05:	83 f8 17             	cmp    $0x17,%eax
  101c08:	76 ba                	jbe    101bc4 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  101c0d:	8b 40 40             	mov    0x40(%eax),%eax
  101c10:	25 00 30 00 00       	and    $0x3000,%eax
  101c15:	c1 e8 0c             	shr    $0xc,%eax
  101c18:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c1c:	c7 04 24 b1 63 10 00 	movl   $0x1063b1,(%esp)
  101c23:	e8 14 e7 ff ff       	call   10033c <cprintf>

    if (!trap_in_kernel(tf)) {
  101c28:	8b 45 08             	mov    0x8(%ebp),%eax
  101c2b:	89 04 24             	mov    %eax,(%esp)
  101c2e:	e8 5b fe ff ff       	call   101a8e <trap_in_kernel>
  101c33:	85 c0                	test   %eax,%eax
  101c35:	75 30                	jne    101c67 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101c37:	8b 45 08             	mov    0x8(%ebp),%eax
  101c3a:	8b 40 44             	mov    0x44(%eax),%eax
  101c3d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c41:	c7 04 24 ba 63 10 00 	movl   $0x1063ba,(%esp)
  101c48:	e8 ef e6 ff ff       	call   10033c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  101c50:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101c54:	0f b7 c0             	movzwl %ax,%eax
  101c57:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c5b:	c7 04 24 c9 63 10 00 	movl   $0x1063c9,(%esp)
  101c62:	e8 d5 e6 ff ff       	call   10033c <cprintf>
    }
}
  101c67:	c9                   	leave  
  101c68:	c3                   	ret    

00101c69 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c69:	55                   	push   %ebp
  101c6a:	89 e5                	mov    %esp,%ebp
  101c6c:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  101c72:	8b 00                	mov    (%eax),%eax
  101c74:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c78:	c7 04 24 dc 63 10 00 	movl   $0x1063dc,(%esp)
  101c7f:	e8 b8 e6 ff ff       	call   10033c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c84:	8b 45 08             	mov    0x8(%ebp),%eax
  101c87:	8b 40 04             	mov    0x4(%eax),%eax
  101c8a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c8e:	c7 04 24 eb 63 10 00 	movl   $0x1063eb,(%esp)
  101c95:	e8 a2 e6 ff ff       	call   10033c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  101c9d:	8b 40 08             	mov    0x8(%eax),%eax
  101ca0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ca4:	c7 04 24 fa 63 10 00 	movl   $0x1063fa,(%esp)
  101cab:	e8 8c e6 ff ff       	call   10033c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  101cb3:	8b 40 0c             	mov    0xc(%eax),%eax
  101cb6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cba:	c7 04 24 09 64 10 00 	movl   $0x106409,(%esp)
  101cc1:	e8 76 e6 ff ff       	call   10033c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  101cc9:	8b 40 10             	mov    0x10(%eax),%eax
  101ccc:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cd0:	c7 04 24 18 64 10 00 	movl   $0x106418,(%esp)
  101cd7:	e8 60 e6 ff ff       	call   10033c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  101cdf:	8b 40 14             	mov    0x14(%eax),%eax
  101ce2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ce6:	c7 04 24 27 64 10 00 	movl   $0x106427,(%esp)
  101ced:	e8 4a e6 ff ff       	call   10033c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  101cf5:	8b 40 18             	mov    0x18(%eax),%eax
  101cf8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cfc:	c7 04 24 36 64 10 00 	movl   $0x106436,(%esp)
  101d03:	e8 34 e6 ff ff       	call   10033c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101d08:	8b 45 08             	mov    0x8(%ebp),%eax
  101d0b:	8b 40 1c             	mov    0x1c(%eax),%eax
  101d0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d12:	c7 04 24 45 64 10 00 	movl   $0x106445,(%esp)
  101d19:	e8 1e e6 ff ff       	call   10033c <cprintf>
}
  101d1e:	c9                   	leave  
  101d1f:	c3                   	ret    

00101d20 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101d20:	55                   	push   %ebp
  101d21:	89 e5                	mov    %esp,%ebp
  101d23:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101d26:	8b 45 08             	mov    0x8(%ebp),%eax
  101d29:	8b 40 30             	mov    0x30(%eax),%eax
  101d2c:	83 f8 2f             	cmp    $0x2f,%eax
  101d2f:	77 21                	ja     101d52 <trap_dispatch+0x32>
  101d31:	83 f8 2e             	cmp    $0x2e,%eax
  101d34:	0f 83 04 01 00 00    	jae    101e3e <trap_dispatch+0x11e>
  101d3a:	83 f8 21             	cmp    $0x21,%eax
  101d3d:	0f 84 81 00 00 00    	je     101dc4 <trap_dispatch+0xa4>
  101d43:	83 f8 24             	cmp    $0x24,%eax
  101d46:	74 56                	je     101d9e <trap_dispatch+0x7e>
  101d48:	83 f8 20             	cmp    $0x20,%eax
  101d4b:	74 16                	je     101d63 <trap_dispatch+0x43>
  101d4d:	e9 b4 00 00 00       	jmp    101e06 <trap_dispatch+0xe6>
  101d52:	83 e8 78             	sub    $0x78,%eax
  101d55:	83 f8 01             	cmp    $0x1,%eax
  101d58:	0f 87 a8 00 00 00    	ja     101e06 <trap_dispatch+0xe6>
  101d5e:	e9 87 00 00 00       	jmp    101dea <trap_dispatch+0xca>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
    	ticks ++;
  101d63:	a1 4c 89 11 00       	mov    0x11894c,%eax
  101d68:	83 c0 01             	add    $0x1,%eax
  101d6b:	a3 4c 89 11 00       	mov    %eax,0x11894c
		if(ticks % 100 == 0)
  101d70:	8b 0d 4c 89 11 00    	mov    0x11894c,%ecx
  101d76:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101d7b:	89 c8                	mov    %ecx,%eax
  101d7d:	f7 e2                	mul    %edx
  101d7f:	89 d0                	mov    %edx,%eax
  101d81:	c1 e8 05             	shr    $0x5,%eax
  101d84:	6b c0 64             	imul   $0x64,%eax,%eax
  101d87:	29 c1                	sub    %eax,%ecx
  101d89:	89 c8                	mov    %ecx,%eax
  101d8b:	85 c0                	test   %eax,%eax
  101d8d:	75 0a                	jne    101d99 <trap_dispatch+0x79>
			print_ticks();
  101d8f:	e8 e3 fa ff ff       	call   101877 <print_ticks>
		break;
  101d94:	e9 a6 00 00 00       	jmp    101e3f <trap_dispatch+0x11f>
  101d99:	e9 a1 00 00 00       	jmp    101e3f <trap_dispatch+0x11f>
        break;
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d9e:	e8 98 f8 ff ff       	call   10163b <cons_getc>
  101da3:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101da6:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101daa:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101dae:	89 54 24 08          	mov    %edx,0x8(%esp)
  101db2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101db6:	c7 04 24 54 64 10 00 	movl   $0x106454,(%esp)
  101dbd:	e8 7a e5 ff ff       	call   10033c <cprintf>
        break;
  101dc2:	eb 7b                	jmp    101e3f <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101dc4:	e8 72 f8 ff ff       	call   10163b <cons_getc>
  101dc9:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101dcc:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101dd0:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101dd4:	89 54 24 08          	mov    %edx,0x8(%esp)
  101dd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ddc:	c7 04 24 66 64 10 00 	movl   $0x106466,(%esp)
  101de3:	e8 54 e5 ff ff       	call   10033c <cprintf>
        break;
  101de8:	eb 55                	jmp    101e3f <trap_dispatch+0x11f>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101dea:	c7 44 24 08 75 64 10 	movl   $0x106475,0x8(%esp)
  101df1:	00 
  101df2:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
  101df9:	00 
  101dfa:	c7 04 24 85 64 10 00 	movl   $0x106485,(%esp)
  101e01:	e8 c7 ee ff ff       	call   100ccd <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101e06:	8b 45 08             	mov    0x8(%ebp),%eax
  101e09:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e0d:	0f b7 c0             	movzwl %ax,%eax
  101e10:	83 e0 03             	and    $0x3,%eax
  101e13:	85 c0                	test   %eax,%eax
  101e15:	75 28                	jne    101e3f <trap_dispatch+0x11f>
            print_trapframe(tf);
  101e17:	8b 45 08             	mov    0x8(%ebp),%eax
  101e1a:	89 04 24             	mov    %eax,(%esp)
  101e1d:	e8 82 fc ff ff       	call   101aa4 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101e22:	c7 44 24 08 96 64 10 	movl   $0x106496,0x8(%esp)
  101e29:	00 
  101e2a:	c7 44 24 04 c1 00 00 	movl   $0xc1,0x4(%esp)
  101e31:	00 
  101e32:	c7 04 24 85 64 10 00 	movl   $0x106485,(%esp)
  101e39:	e8 8f ee ff ff       	call   100ccd <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101e3e:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101e3f:	c9                   	leave  
  101e40:	c3                   	ret    

00101e41 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101e41:	55                   	push   %ebp
  101e42:	89 e5                	mov    %esp,%ebp
  101e44:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101e47:	8b 45 08             	mov    0x8(%ebp),%eax
  101e4a:	89 04 24             	mov    %eax,(%esp)
  101e4d:	e8 ce fe ff ff       	call   101d20 <trap_dispatch>
}
  101e52:	c9                   	leave  
  101e53:	c3                   	ret    

00101e54 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101e54:	1e                   	push   %ds
    pushl %es
  101e55:	06                   	push   %es
    pushl %fs
  101e56:	0f a0                	push   %fs
    pushl %gs
  101e58:	0f a8                	push   %gs
    pushal
  101e5a:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101e5b:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101e60:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101e62:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101e64:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101e65:	e8 d7 ff ff ff       	call   101e41 <trap>

    # pop the pushed stack pointer
    popl %esp
  101e6a:	5c                   	pop    %esp

00101e6b <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101e6b:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101e6c:	0f a9                	pop    %gs
    popl %fs
  101e6e:	0f a1                	pop    %fs
    popl %es
  101e70:	07                   	pop    %es
    popl %ds
  101e71:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101e72:	83 c4 08             	add    $0x8,%esp
    iret
  101e75:	cf                   	iret   

00101e76 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101e76:	6a 00                	push   $0x0
  pushl $0
  101e78:	6a 00                	push   $0x0
  jmp __alltraps
  101e7a:	e9 d5 ff ff ff       	jmp    101e54 <__alltraps>

00101e7f <vector1>:
.globl vector1
vector1:
  pushl $0
  101e7f:	6a 00                	push   $0x0
  pushl $1
  101e81:	6a 01                	push   $0x1
  jmp __alltraps
  101e83:	e9 cc ff ff ff       	jmp    101e54 <__alltraps>

00101e88 <vector2>:
.globl vector2
vector2:
  pushl $0
  101e88:	6a 00                	push   $0x0
  pushl $2
  101e8a:	6a 02                	push   $0x2
  jmp __alltraps
  101e8c:	e9 c3 ff ff ff       	jmp    101e54 <__alltraps>

00101e91 <vector3>:
.globl vector3
vector3:
  pushl $0
  101e91:	6a 00                	push   $0x0
  pushl $3
  101e93:	6a 03                	push   $0x3
  jmp __alltraps
  101e95:	e9 ba ff ff ff       	jmp    101e54 <__alltraps>

00101e9a <vector4>:
.globl vector4
vector4:
  pushl $0
  101e9a:	6a 00                	push   $0x0
  pushl $4
  101e9c:	6a 04                	push   $0x4
  jmp __alltraps
  101e9e:	e9 b1 ff ff ff       	jmp    101e54 <__alltraps>

00101ea3 <vector5>:
.globl vector5
vector5:
  pushl $0
  101ea3:	6a 00                	push   $0x0
  pushl $5
  101ea5:	6a 05                	push   $0x5
  jmp __alltraps
  101ea7:	e9 a8 ff ff ff       	jmp    101e54 <__alltraps>

00101eac <vector6>:
.globl vector6
vector6:
  pushl $0
  101eac:	6a 00                	push   $0x0
  pushl $6
  101eae:	6a 06                	push   $0x6
  jmp __alltraps
  101eb0:	e9 9f ff ff ff       	jmp    101e54 <__alltraps>

00101eb5 <vector7>:
.globl vector7
vector7:
  pushl $0
  101eb5:	6a 00                	push   $0x0
  pushl $7
  101eb7:	6a 07                	push   $0x7
  jmp __alltraps
  101eb9:	e9 96 ff ff ff       	jmp    101e54 <__alltraps>

00101ebe <vector8>:
.globl vector8
vector8:
  pushl $8
  101ebe:	6a 08                	push   $0x8
  jmp __alltraps
  101ec0:	e9 8f ff ff ff       	jmp    101e54 <__alltraps>

00101ec5 <vector9>:
.globl vector9
vector9:
  pushl $9
  101ec5:	6a 09                	push   $0x9
  jmp __alltraps
  101ec7:	e9 88 ff ff ff       	jmp    101e54 <__alltraps>

00101ecc <vector10>:
.globl vector10
vector10:
  pushl $10
  101ecc:	6a 0a                	push   $0xa
  jmp __alltraps
  101ece:	e9 81 ff ff ff       	jmp    101e54 <__alltraps>

00101ed3 <vector11>:
.globl vector11
vector11:
  pushl $11
  101ed3:	6a 0b                	push   $0xb
  jmp __alltraps
  101ed5:	e9 7a ff ff ff       	jmp    101e54 <__alltraps>

00101eda <vector12>:
.globl vector12
vector12:
  pushl $12
  101eda:	6a 0c                	push   $0xc
  jmp __alltraps
  101edc:	e9 73 ff ff ff       	jmp    101e54 <__alltraps>

00101ee1 <vector13>:
.globl vector13
vector13:
  pushl $13
  101ee1:	6a 0d                	push   $0xd
  jmp __alltraps
  101ee3:	e9 6c ff ff ff       	jmp    101e54 <__alltraps>

00101ee8 <vector14>:
.globl vector14
vector14:
  pushl $14
  101ee8:	6a 0e                	push   $0xe
  jmp __alltraps
  101eea:	e9 65 ff ff ff       	jmp    101e54 <__alltraps>

00101eef <vector15>:
.globl vector15
vector15:
  pushl $0
  101eef:	6a 00                	push   $0x0
  pushl $15
  101ef1:	6a 0f                	push   $0xf
  jmp __alltraps
  101ef3:	e9 5c ff ff ff       	jmp    101e54 <__alltraps>

00101ef8 <vector16>:
.globl vector16
vector16:
  pushl $0
  101ef8:	6a 00                	push   $0x0
  pushl $16
  101efa:	6a 10                	push   $0x10
  jmp __alltraps
  101efc:	e9 53 ff ff ff       	jmp    101e54 <__alltraps>

00101f01 <vector17>:
.globl vector17
vector17:
  pushl $17
  101f01:	6a 11                	push   $0x11
  jmp __alltraps
  101f03:	e9 4c ff ff ff       	jmp    101e54 <__alltraps>

00101f08 <vector18>:
.globl vector18
vector18:
  pushl $0
  101f08:	6a 00                	push   $0x0
  pushl $18
  101f0a:	6a 12                	push   $0x12
  jmp __alltraps
  101f0c:	e9 43 ff ff ff       	jmp    101e54 <__alltraps>

00101f11 <vector19>:
.globl vector19
vector19:
  pushl $0
  101f11:	6a 00                	push   $0x0
  pushl $19
  101f13:	6a 13                	push   $0x13
  jmp __alltraps
  101f15:	e9 3a ff ff ff       	jmp    101e54 <__alltraps>

00101f1a <vector20>:
.globl vector20
vector20:
  pushl $0
  101f1a:	6a 00                	push   $0x0
  pushl $20
  101f1c:	6a 14                	push   $0x14
  jmp __alltraps
  101f1e:	e9 31 ff ff ff       	jmp    101e54 <__alltraps>

00101f23 <vector21>:
.globl vector21
vector21:
  pushl $0
  101f23:	6a 00                	push   $0x0
  pushl $21
  101f25:	6a 15                	push   $0x15
  jmp __alltraps
  101f27:	e9 28 ff ff ff       	jmp    101e54 <__alltraps>

00101f2c <vector22>:
.globl vector22
vector22:
  pushl $0
  101f2c:	6a 00                	push   $0x0
  pushl $22
  101f2e:	6a 16                	push   $0x16
  jmp __alltraps
  101f30:	e9 1f ff ff ff       	jmp    101e54 <__alltraps>

00101f35 <vector23>:
.globl vector23
vector23:
  pushl $0
  101f35:	6a 00                	push   $0x0
  pushl $23
  101f37:	6a 17                	push   $0x17
  jmp __alltraps
  101f39:	e9 16 ff ff ff       	jmp    101e54 <__alltraps>

00101f3e <vector24>:
.globl vector24
vector24:
  pushl $0
  101f3e:	6a 00                	push   $0x0
  pushl $24
  101f40:	6a 18                	push   $0x18
  jmp __alltraps
  101f42:	e9 0d ff ff ff       	jmp    101e54 <__alltraps>

00101f47 <vector25>:
.globl vector25
vector25:
  pushl $0
  101f47:	6a 00                	push   $0x0
  pushl $25
  101f49:	6a 19                	push   $0x19
  jmp __alltraps
  101f4b:	e9 04 ff ff ff       	jmp    101e54 <__alltraps>

00101f50 <vector26>:
.globl vector26
vector26:
  pushl $0
  101f50:	6a 00                	push   $0x0
  pushl $26
  101f52:	6a 1a                	push   $0x1a
  jmp __alltraps
  101f54:	e9 fb fe ff ff       	jmp    101e54 <__alltraps>

00101f59 <vector27>:
.globl vector27
vector27:
  pushl $0
  101f59:	6a 00                	push   $0x0
  pushl $27
  101f5b:	6a 1b                	push   $0x1b
  jmp __alltraps
  101f5d:	e9 f2 fe ff ff       	jmp    101e54 <__alltraps>

00101f62 <vector28>:
.globl vector28
vector28:
  pushl $0
  101f62:	6a 00                	push   $0x0
  pushl $28
  101f64:	6a 1c                	push   $0x1c
  jmp __alltraps
  101f66:	e9 e9 fe ff ff       	jmp    101e54 <__alltraps>

00101f6b <vector29>:
.globl vector29
vector29:
  pushl $0
  101f6b:	6a 00                	push   $0x0
  pushl $29
  101f6d:	6a 1d                	push   $0x1d
  jmp __alltraps
  101f6f:	e9 e0 fe ff ff       	jmp    101e54 <__alltraps>

00101f74 <vector30>:
.globl vector30
vector30:
  pushl $0
  101f74:	6a 00                	push   $0x0
  pushl $30
  101f76:	6a 1e                	push   $0x1e
  jmp __alltraps
  101f78:	e9 d7 fe ff ff       	jmp    101e54 <__alltraps>

00101f7d <vector31>:
.globl vector31
vector31:
  pushl $0
  101f7d:	6a 00                	push   $0x0
  pushl $31
  101f7f:	6a 1f                	push   $0x1f
  jmp __alltraps
  101f81:	e9 ce fe ff ff       	jmp    101e54 <__alltraps>

00101f86 <vector32>:
.globl vector32
vector32:
  pushl $0
  101f86:	6a 00                	push   $0x0
  pushl $32
  101f88:	6a 20                	push   $0x20
  jmp __alltraps
  101f8a:	e9 c5 fe ff ff       	jmp    101e54 <__alltraps>

00101f8f <vector33>:
.globl vector33
vector33:
  pushl $0
  101f8f:	6a 00                	push   $0x0
  pushl $33
  101f91:	6a 21                	push   $0x21
  jmp __alltraps
  101f93:	e9 bc fe ff ff       	jmp    101e54 <__alltraps>

00101f98 <vector34>:
.globl vector34
vector34:
  pushl $0
  101f98:	6a 00                	push   $0x0
  pushl $34
  101f9a:	6a 22                	push   $0x22
  jmp __alltraps
  101f9c:	e9 b3 fe ff ff       	jmp    101e54 <__alltraps>

00101fa1 <vector35>:
.globl vector35
vector35:
  pushl $0
  101fa1:	6a 00                	push   $0x0
  pushl $35
  101fa3:	6a 23                	push   $0x23
  jmp __alltraps
  101fa5:	e9 aa fe ff ff       	jmp    101e54 <__alltraps>

00101faa <vector36>:
.globl vector36
vector36:
  pushl $0
  101faa:	6a 00                	push   $0x0
  pushl $36
  101fac:	6a 24                	push   $0x24
  jmp __alltraps
  101fae:	e9 a1 fe ff ff       	jmp    101e54 <__alltraps>

00101fb3 <vector37>:
.globl vector37
vector37:
  pushl $0
  101fb3:	6a 00                	push   $0x0
  pushl $37
  101fb5:	6a 25                	push   $0x25
  jmp __alltraps
  101fb7:	e9 98 fe ff ff       	jmp    101e54 <__alltraps>

00101fbc <vector38>:
.globl vector38
vector38:
  pushl $0
  101fbc:	6a 00                	push   $0x0
  pushl $38
  101fbe:	6a 26                	push   $0x26
  jmp __alltraps
  101fc0:	e9 8f fe ff ff       	jmp    101e54 <__alltraps>

00101fc5 <vector39>:
.globl vector39
vector39:
  pushl $0
  101fc5:	6a 00                	push   $0x0
  pushl $39
  101fc7:	6a 27                	push   $0x27
  jmp __alltraps
  101fc9:	e9 86 fe ff ff       	jmp    101e54 <__alltraps>

00101fce <vector40>:
.globl vector40
vector40:
  pushl $0
  101fce:	6a 00                	push   $0x0
  pushl $40
  101fd0:	6a 28                	push   $0x28
  jmp __alltraps
  101fd2:	e9 7d fe ff ff       	jmp    101e54 <__alltraps>

00101fd7 <vector41>:
.globl vector41
vector41:
  pushl $0
  101fd7:	6a 00                	push   $0x0
  pushl $41
  101fd9:	6a 29                	push   $0x29
  jmp __alltraps
  101fdb:	e9 74 fe ff ff       	jmp    101e54 <__alltraps>

00101fe0 <vector42>:
.globl vector42
vector42:
  pushl $0
  101fe0:	6a 00                	push   $0x0
  pushl $42
  101fe2:	6a 2a                	push   $0x2a
  jmp __alltraps
  101fe4:	e9 6b fe ff ff       	jmp    101e54 <__alltraps>

00101fe9 <vector43>:
.globl vector43
vector43:
  pushl $0
  101fe9:	6a 00                	push   $0x0
  pushl $43
  101feb:	6a 2b                	push   $0x2b
  jmp __alltraps
  101fed:	e9 62 fe ff ff       	jmp    101e54 <__alltraps>

00101ff2 <vector44>:
.globl vector44
vector44:
  pushl $0
  101ff2:	6a 00                	push   $0x0
  pushl $44
  101ff4:	6a 2c                	push   $0x2c
  jmp __alltraps
  101ff6:	e9 59 fe ff ff       	jmp    101e54 <__alltraps>

00101ffb <vector45>:
.globl vector45
vector45:
  pushl $0
  101ffb:	6a 00                	push   $0x0
  pushl $45
  101ffd:	6a 2d                	push   $0x2d
  jmp __alltraps
  101fff:	e9 50 fe ff ff       	jmp    101e54 <__alltraps>

00102004 <vector46>:
.globl vector46
vector46:
  pushl $0
  102004:	6a 00                	push   $0x0
  pushl $46
  102006:	6a 2e                	push   $0x2e
  jmp __alltraps
  102008:	e9 47 fe ff ff       	jmp    101e54 <__alltraps>

0010200d <vector47>:
.globl vector47
vector47:
  pushl $0
  10200d:	6a 00                	push   $0x0
  pushl $47
  10200f:	6a 2f                	push   $0x2f
  jmp __alltraps
  102011:	e9 3e fe ff ff       	jmp    101e54 <__alltraps>

00102016 <vector48>:
.globl vector48
vector48:
  pushl $0
  102016:	6a 00                	push   $0x0
  pushl $48
  102018:	6a 30                	push   $0x30
  jmp __alltraps
  10201a:	e9 35 fe ff ff       	jmp    101e54 <__alltraps>

0010201f <vector49>:
.globl vector49
vector49:
  pushl $0
  10201f:	6a 00                	push   $0x0
  pushl $49
  102021:	6a 31                	push   $0x31
  jmp __alltraps
  102023:	e9 2c fe ff ff       	jmp    101e54 <__alltraps>

00102028 <vector50>:
.globl vector50
vector50:
  pushl $0
  102028:	6a 00                	push   $0x0
  pushl $50
  10202a:	6a 32                	push   $0x32
  jmp __alltraps
  10202c:	e9 23 fe ff ff       	jmp    101e54 <__alltraps>

00102031 <vector51>:
.globl vector51
vector51:
  pushl $0
  102031:	6a 00                	push   $0x0
  pushl $51
  102033:	6a 33                	push   $0x33
  jmp __alltraps
  102035:	e9 1a fe ff ff       	jmp    101e54 <__alltraps>

0010203a <vector52>:
.globl vector52
vector52:
  pushl $0
  10203a:	6a 00                	push   $0x0
  pushl $52
  10203c:	6a 34                	push   $0x34
  jmp __alltraps
  10203e:	e9 11 fe ff ff       	jmp    101e54 <__alltraps>

00102043 <vector53>:
.globl vector53
vector53:
  pushl $0
  102043:	6a 00                	push   $0x0
  pushl $53
  102045:	6a 35                	push   $0x35
  jmp __alltraps
  102047:	e9 08 fe ff ff       	jmp    101e54 <__alltraps>

0010204c <vector54>:
.globl vector54
vector54:
  pushl $0
  10204c:	6a 00                	push   $0x0
  pushl $54
  10204e:	6a 36                	push   $0x36
  jmp __alltraps
  102050:	e9 ff fd ff ff       	jmp    101e54 <__alltraps>

00102055 <vector55>:
.globl vector55
vector55:
  pushl $0
  102055:	6a 00                	push   $0x0
  pushl $55
  102057:	6a 37                	push   $0x37
  jmp __alltraps
  102059:	e9 f6 fd ff ff       	jmp    101e54 <__alltraps>

0010205e <vector56>:
.globl vector56
vector56:
  pushl $0
  10205e:	6a 00                	push   $0x0
  pushl $56
  102060:	6a 38                	push   $0x38
  jmp __alltraps
  102062:	e9 ed fd ff ff       	jmp    101e54 <__alltraps>

00102067 <vector57>:
.globl vector57
vector57:
  pushl $0
  102067:	6a 00                	push   $0x0
  pushl $57
  102069:	6a 39                	push   $0x39
  jmp __alltraps
  10206b:	e9 e4 fd ff ff       	jmp    101e54 <__alltraps>

00102070 <vector58>:
.globl vector58
vector58:
  pushl $0
  102070:	6a 00                	push   $0x0
  pushl $58
  102072:	6a 3a                	push   $0x3a
  jmp __alltraps
  102074:	e9 db fd ff ff       	jmp    101e54 <__alltraps>

00102079 <vector59>:
.globl vector59
vector59:
  pushl $0
  102079:	6a 00                	push   $0x0
  pushl $59
  10207b:	6a 3b                	push   $0x3b
  jmp __alltraps
  10207d:	e9 d2 fd ff ff       	jmp    101e54 <__alltraps>

00102082 <vector60>:
.globl vector60
vector60:
  pushl $0
  102082:	6a 00                	push   $0x0
  pushl $60
  102084:	6a 3c                	push   $0x3c
  jmp __alltraps
  102086:	e9 c9 fd ff ff       	jmp    101e54 <__alltraps>

0010208b <vector61>:
.globl vector61
vector61:
  pushl $0
  10208b:	6a 00                	push   $0x0
  pushl $61
  10208d:	6a 3d                	push   $0x3d
  jmp __alltraps
  10208f:	e9 c0 fd ff ff       	jmp    101e54 <__alltraps>

00102094 <vector62>:
.globl vector62
vector62:
  pushl $0
  102094:	6a 00                	push   $0x0
  pushl $62
  102096:	6a 3e                	push   $0x3e
  jmp __alltraps
  102098:	e9 b7 fd ff ff       	jmp    101e54 <__alltraps>

0010209d <vector63>:
.globl vector63
vector63:
  pushl $0
  10209d:	6a 00                	push   $0x0
  pushl $63
  10209f:	6a 3f                	push   $0x3f
  jmp __alltraps
  1020a1:	e9 ae fd ff ff       	jmp    101e54 <__alltraps>

001020a6 <vector64>:
.globl vector64
vector64:
  pushl $0
  1020a6:	6a 00                	push   $0x0
  pushl $64
  1020a8:	6a 40                	push   $0x40
  jmp __alltraps
  1020aa:	e9 a5 fd ff ff       	jmp    101e54 <__alltraps>

001020af <vector65>:
.globl vector65
vector65:
  pushl $0
  1020af:	6a 00                	push   $0x0
  pushl $65
  1020b1:	6a 41                	push   $0x41
  jmp __alltraps
  1020b3:	e9 9c fd ff ff       	jmp    101e54 <__alltraps>

001020b8 <vector66>:
.globl vector66
vector66:
  pushl $0
  1020b8:	6a 00                	push   $0x0
  pushl $66
  1020ba:	6a 42                	push   $0x42
  jmp __alltraps
  1020bc:	e9 93 fd ff ff       	jmp    101e54 <__alltraps>

001020c1 <vector67>:
.globl vector67
vector67:
  pushl $0
  1020c1:	6a 00                	push   $0x0
  pushl $67
  1020c3:	6a 43                	push   $0x43
  jmp __alltraps
  1020c5:	e9 8a fd ff ff       	jmp    101e54 <__alltraps>

001020ca <vector68>:
.globl vector68
vector68:
  pushl $0
  1020ca:	6a 00                	push   $0x0
  pushl $68
  1020cc:	6a 44                	push   $0x44
  jmp __alltraps
  1020ce:	e9 81 fd ff ff       	jmp    101e54 <__alltraps>

001020d3 <vector69>:
.globl vector69
vector69:
  pushl $0
  1020d3:	6a 00                	push   $0x0
  pushl $69
  1020d5:	6a 45                	push   $0x45
  jmp __alltraps
  1020d7:	e9 78 fd ff ff       	jmp    101e54 <__alltraps>

001020dc <vector70>:
.globl vector70
vector70:
  pushl $0
  1020dc:	6a 00                	push   $0x0
  pushl $70
  1020de:	6a 46                	push   $0x46
  jmp __alltraps
  1020e0:	e9 6f fd ff ff       	jmp    101e54 <__alltraps>

001020e5 <vector71>:
.globl vector71
vector71:
  pushl $0
  1020e5:	6a 00                	push   $0x0
  pushl $71
  1020e7:	6a 47                	push   $0x47
  jmp __alltraps
  1020e9:	e9 66 fd ff ff       	jmp    101e54 <__alltraps>

001020ee <vector72>:
.globl vector72
vector72:
  pushl $0
  1020ee:	6a 00                	push   $0x0
  pushl $72
  1020f0:	6a 48                	push   $0x48
  jmp __alltraps
  1020f2:	e9 5d fd ff ff       	jmp    101e54 <__alltraps>

001020f7 <vector73>:
.globl vector73
vector73:
  pushl $0
  1020f7:	6a 00                	push   $0x0
  pushl $73
  1020f9:	6a 49                	push   $0x49
  jmp __alltraps
  1020fb:	e9 54 fd ff ff       	jmp    101e54 <__alltraps>

00102100 <vector74>:
.globl vector74
vector74:
  pushl $0
  102100:	6a 00                	push   $0x0
  pushl $74
  102102:	6a 4a                	push   $0x4a
  jmp __alltraps
  102104:	e9 4b fd ff ff       	jmp    101e54 <__alltraps>

00102109 <vector75>:
.globl vector75
vector75:
  pushl $0
  102109:	6a 00                	push   $0x0
  pushl $75
  10210b:	6a 4b                	push   $0x4b
  jmp __alltraps
  10210d:	e9 42 fd ff ff       	jmp    101e54 <__alltraps>

00102112 <vector76>:
.globl vector76
vector76:
  pushl $0
  102112:	6a 00                	push   $0x0
  pushl $76
  102114:	6a 4c                	push   $0x4c
  jmp __alltraps
  102116:	e9 39 fd ff ff       	jmp    101e54 <__alltraps>

0010211b <vector77>:
.globl vector77
vector77:
  pushl $0
  10211b:	6a 00                	push   $0x0
  pushl $77
  10211d:	6a 4d                	push   $0x4d
  jmp __alltraps
  10211f:	e9 30 fd ff ff       	jmp    101e54 <__alltraps>

00102124 <vector78>:
.globl vector78
vector78:
  pushl $0
  102124:	6a 00                	push   $0x0
  pushl $78
  102126:	6a 4e                	push   $0x4e
  jmp __alltraps
  102128:	e9 27 fd ff ff       	jmp    101e54 <__alltraps>

0010212d <vector79>:
.globl vector79
vector79:
  pushl $0
  10212d:	6a 00                	push   $0x0
  pushl $79
  10212f:	6a 4f                	push   $0x4f
  jmp __alltraps
  102131:	e9 1e fd ff ff       	jmp    101e54 <__alltraps>

00102136 <vector80>:
.globl vector80
vector80:
  pushl $0
  102136:	6a 00                	push   $0x0
  pushl $80
  102138:	6a 50                	push   $0x50
  jmp __alltraps
  10213a:	e9 15 fd ff ff       	jmp    101e54 <__alltraps>

0010213f <vector81>:
.globl vector81
vector81:
  pushl $0
  10213f:	6a 00                	push   $0x0
  pushl $81
  102141:	6a 51                	push   $0x51
  jmp __alltraps
  102143:	e9 0c fd ff ff       	jmp    101e54 <__alltraps>

00102148 <vector82>:
.globl vector82
vector82:
  pushl $0
  102148:	6a 00                	push   $0x0
  pushl $82
  10214a:	6a 52                	push   $0x52
  jmp __alltraps
  10214c:	e9 03 fd ff ff       	jmp    101e54 <__alltraps>

00102151 <vector83>:
.globl vector83
vector83:
  pushl $0
  102151:	6a 00                	push   $0x0
  pushl $83
  102153:	6a 53                	push   $0x53
  jmp __alltraps
  102155:	e9 fa fc ff ff       	jmp    101e54 <__alltraps>

0010215a <vector84>:
.globl vector84
vector84:
  pushl $0
  10215a:	6a 00                	push   $0x0
  pushl $84
  10215c:	6a 54                	push   $0x54
  jmp __alltraps
  10215e:	e9 f1 fc ff ff       	jmp    101e54 <__alltraps>

00102163 <vector85>:
.globl vector85
vector85:
  pushl $0
  102163:	6a 00                	push   $0x0
  pushl $85
  102165:	6a 55                	push   $0x55
  jmp __alltraps
  102167:	e9 e8 fc ff ff       	jmp    101e54 <__alltraps>

0010216c <vector86>:
.globl vector86
vector86:
  pushl $0
  10216c:	6a 00                	push   $0x0
  pushl $86
  10216e:	6a 56                	push   $0x56
  jmp __alltraps
  102170:	e9 df fc ff ff       	jmp    101e54 <__alltraps>

00102175 <vector87>:
.globl vector87
vector87:
  pushl $0
  102175:	6a 00                	push   $0x0
  pushl $87
  102177:	6a 57                	push   $0x57
  jmp __alltraps
  102179:	e9 d6 fc ff ff       	jmp    101e54 <__alltraps>

0010217e <vector88>:
.globl vector88
vector88:
  pushl $0
  10217e:	6a 00                	push   $0x0
  pushl $88
  102180:	6a 58                	push   $0x58
  jmp __alltraps
  102182:	e9 cd fc ff ff       	jmp    101e54 <__alltraps>

00102187 <vector89>:
.globl vector89
vector89:
  pushl $0
  102187:	6a 00                	push   $0x0
  pushl $89
  102189:	6a 59                	push   $0x59
  jmp __alltraps
  10218b:	e9 c4 fc ff ff       	jmp    101e54 <__alltraps>

00102190 <vector90>:
.globl vector90
vector90:
  pushl $0
  102190:	6a 00                	push   $0x0
  pushl $90
  102192:	6a 5a                	push   $0x5a
  jmp __alltraps
  102194:	e9 bb fc ff ff       	jmp    101e54 <__alltraps>

00102199 <vector91>:
.globl vector91
vector91:
  pushl $0
  102199:	6a 00                	push   $0x0
  pushl $91
  10219b:	6a 5b                	push   $0x5b
  jmp __alltraps
  10219d:	e9 b2 fc ff ff       	jmp    101e54 <__alltraps>

001021a2 <vector92>:
.globl vector92
vector92:
  pushl $0
  1021a2:	6a 00                	push   $0x0
  pushl $92
  1021a4:	6a 5c                	push   $0x5c
  jmp __alltraps
  1021a6:	e9 a9 fc ff ff       	jmp    101e54 <__alltraps>

001021ab <vector93>:
.globl vector93
vector93:
  pushl $0
  1021ab:	6a 00                	push   $0x0
  pushl $93
  1021ad:	6a 5d                	push   $0x5d
  jmp __alltraps
  1021af:	e9 a0 fc ff ff       	jmp    101e54 <__alltraps>

001021b4 <vector94>:
.globl vector94
vector94:
  pushl $0
  1021b4:	6a 00                	push   $0x0
  pushl $94
  1021b6:	6a 5e                	push   $0x5e
  jmp __alltraps
  1021b8:	e9 97 fc ff ff       	jmp    101e54 <__alltraps>

001021bd <vector95>:
.globl vector95
vector95:
  pushl $0
  1021bd:	6a 00                	push   $0x0
  pushl $95
  1021bf:	6a 5f                	push   $0x5f
  jmp __alltraps
  1021c1:	e9 8e fc ff ff       	jmp    101e54 <__alltraps>

001021c6 <vector96>:
.globl vector96
vector96:
  pushl $0
  1021c6:	6a 00                	push   $0x0
  pushl $96
  1021c8:	6a 60                	push   $0x60
  jmp __alltraps
  1021ca:	e9 85 fc ff ff       	jmp    101e54 <__alltraps>

001021cf <vector97>:
.globl vector97
vector97:
  pushl $0
  1021cf:	6a 00                	push   $0x0
  pushl $97
  1021d1:	6a 61                	push   $0x61
  jmp __alltraps
  1021d3:	e9 7c fc ff ff       	jmp    101e54 <__alltraps>

001021d8 <vector98>:
.globl vector98
vector98:
  pushl $0
  1021d8:	6a 00                	push   $0x0
  pushl $98
  1021da:	6a 62                	push   $0x62
  jmp __alltraps
  1021dc:	e9 73 fc ff ff       	jmp    101e54 <__alltraps>

001021e1 <vector99>:
.globl vector99
vector99:
  pushl $0
  1021e1:	6a 00                	push   $0x0
  pushl $99
  1021e3:	6a 63                	push   $0x63
  jmp __alltraps
  1021e5:	e9 6a fc ff ff       	jmp    101e54 <__alltraps>

001021ea <vector100>:
.globl vector100
vector100:
  pushl $0
  1021ea:	6a 00                	push   $0x0
  pushl $100
  1021ec:	6a 64                	push   $0x64
  jmp __alltraps
  1021ee:	e9 61 fc ff ff       	jmp    101e54 <__alltraps>

001021f3 <vector101>:
.globl vector101
vector101:
  pushl $0
  1021f3:	6a 00                	push   $0x0
  pushl $101
  1021f5:	6a 65                	push   $0x65
  jmp __alltraps
  1021f7:	e9 58 fc ff ff       	jmp    101e54 <__alltraps>

001021fc <vector102>:
.globl vector102
vector102:
  pushl $0
  1021fc:	6a 00                	push   $0x0
  pushl $102
  1021fe:	6a 66                	push   $0x66
  jmp __alltraps
  102200:	e9 4f fc ff ff       	jmp    101e54 <__alltraps>

00102205 <vector103>:
.globl vector103
vector103:
  pushl $0
  102205:	6a 00                	push   $0x0
  pushl $103
  102207:	6a 67                	push   $0x67
  jmp __alltraps
  102209:	e9 46 fc ff ff       	jmp    101e54 <__alltraps>

0010220e <vector104>:
.globl vector104
vector104:
  pushl $0
  10220e:	6a 00                	push   $0x0
  pushl $104
  102210:	6a 68                	push   $0x68
  jmp __alltraps
  102212:	e9 3d fc ff ff       	jmp    101e54 <__alltraps>

00102217 <vector105>:
.globl vector105
vector105:
  pushl $0
  102217:	6a 00                	push   $0x0
  pushl $105
  102219:	6a 69                	push   $0x69
  jmp __alltraps
  10221b:	e9 34 fc ff ff       	jmp    101e54 <__alltraps>

00102220 <vector106>:
.globl vector106
vector106:
  pushl $0
  102220:	6a 00                	push   $0x0
  pushl $106
  102222:	6a 6a                	push   $0x6a
  jmp __alltraps
  102224:	e9 2b fc ff ff       	jmp    101e54 <__alltraps>

00102229 <vector107>:
.globl vector107
vector107:
  pushl $0
  102229:	6a 00                	push   $0x0
  pushl $107
  10222b:	6a 6b                	push   $0x6b
  jmp __alltraps
  10222d:	e9 22 fc ff ff       	jmp    101e54 <__alltraps>

00102232 <vector108>:
.globl vector108
vector108:
  pushl $0
  102232:	6a 00                	push   $0x0
  pushl $108
  102234:	6a 6c                	push   $0x6c
  jmp __alltraps
  102236:	e9 19 fc ff ff       	jmp    101e54 <__alltraps>

0010223b <vector109>:
.globl vector109
vector109:
  pushl $0
  10223b:	6a 00                	push   $0x0
  pushl $109
  10223d:	6a 6d                	push   $0x6d
  jmp __alltraps
  10223f:	e9 10 fc ff ff       	jmp    101e54 <__alltraps>

00102244 <vector110>:
.globl vector110
vector110:
  pushl $0
  102244:	6a 00                	push   $0x0
  pushl $110
  102246:	6a 6e                	push   $0x6e
  jmp __alltraps
  102248:	e9 07 fc ff ff       	jmp    101e54 <__alltraps>

0010224d <vector111>:
.globl vector111
vector111:
  pushl $0
  10224d:	6a 00                	push   $0x0
  pushl $111
  10224f:	6a 6f                	push   $0x6f
  jmp __alltraps
  102251:	e9 fe fb ff ff       	jmp    101e54 <__alltraps>

00102256 <vector112>:
.globl vector112
vector112:
  pushl $0
  102256:	6a 00                	push   $0x0
  pushl $112
  102258:	6a 70                	push   $0x70
  jmp __alltraps
  10225a:	e9 f5 fb ff ff       	jmp    101e54 <__alltraps>

0010225f <vector113>:
.globl vector113
vector113:
  pushl $0
  10225f:	6a 00                	push   $0x0
  pushl $113
  102261:	6a 71                	push   $0x71
  jmp __alltraps
  102263:	e9 ec fb ff ff       	jmp    101e54 <__alltraps>

00102268 <vector114>:
.globl vector114
vector114:
  pushl $0
  102268:	6a 00                	push   $0x0
  pushl $114
  10226a:	6a 72                	push   $0x72
  jmp __alltraps
  10226c:	e9 e3 fb ff ff       	jmp    101e54 <__alltraps>

00102271 <vector115>:
.globl vector115
vector115:
  pushl $0
  102271:	6a 00                	push   $0x0
  pushl $115
  102273:	6a 73                	push   $0x73
  jmp __alltraps
  102275:	e9 da fb ff ff       	jmp    101e54 <__alltraps>

0010227a <vector116>:
.globl vector116
vector116:
  pushl $0
  10227a:	6a 00                	push   $0x0
  pushl $116
  10227c:	6a 74                	push   $0x74
  jmp __alltraps
  10227e:	e9 d1 fb ff ff       	jmp    101e54 <__alltraps>

00102283 <vector117>:
.globl vector117
vector117:
  pushl $0
  102283:	6a 00                	push   $0x0
  pushl $117
  102285:	6a 75                	push   $0x75
  jmp __alltraps
  102287:	e9 c8 fb ff ff       	jmp    101e54 <__alltraps>

0010228c <vector118>:
.globl vector118
vector118:
  pushl $0
  10228c:	6a 00                	push   $0x0
  pushl $118
  10228e:	6a 76                	push   $0x76
  jmp __alltraps
  102290:	e9 bf fb ff ff       	jmp    101e54 <__alltraps>

00102295 <vector119>:
.globl vector119
vector119:
  pushl $0
  102295:	6a 00                	push   $0x0
  pushl $119
  102297:	6a 77                	push   $0x77
  jmp __alltraps
  102299:	e9 b6 fb ff ff       	jmp    101e54 <__alltraps>

0010229e <vector120>:
.globl vector120
vector120:
  pushl $0
  10229e:	6a 00                	push   $0x0
  pushl $120
  1022a0:	6a 78                	push   $0x78
  jmp __alltraps
  1022a2:	e9 ad fb ff ff       	jmp    101e54 <__alltraps>

001022a7 <vector121>:
.globl vector121
vector121:
  pushl $0
  1022a7:	6a 00                	push   $0x0
  pushl $121
  1022a9:	6a 79                	push   $0x79
  jmp __alltraps
  1022ab:	e9 a4 fb ff ff       	jmp    101e54 <__alltraps>

001022b0 <vector122>:
.globl vector122
vector122:
  pushl $0
  1022b0:	6a 00                	push   $0x0
  pushl $122
  1022b2:	6a 7a                	push   $0x7a
  jmp __alltraps
  1022b4:	e9 9b fb ff ff       	jmp    101e54 <__alltraps>

001022b9 <vector123>:
.globl vector123
vector123:
  pushl $0
  1022b9:	6a 00                	push   $0x0
  pushl $123
  1022bb:	6a 7b                	push   $0x7b
  jmp __alltraps
  1022bd:	e9 92 fb ff ff       	jmp    101e54 <__alltraps>

001022c2 <vector124>:
.globl vector124
vector124:
  pushl $0
  1022c2:	6a 00                	push   $0x0
  pushl $124
  1022c4:	6a 7c                	push   $0x7c
  jmp __alltraps
  1022c6:	e9 89 fb ff ff       	jmp    101e54 <__alltraps>

001022cb <vector125>:
.globl vector125
vector125:
  pushl $0
  1022cb:	6a 00                	push   $0x0
  pushl $125
  1022cd:	6a 7d                	push   $0x7d
  jmp __alltraps
  1022cf:	e9 80 fb ff ff       	jmp    101e54 <__alltraps>

001022d4 <vector126>:
.globl vector126
vector126:
  pushl $0
  1022d4:	6a 00                	push   $0x0
  pushl $126
  1022d6:	6a 7e                	push   $0x7e
  jmp __alltraps
  1022d8:	e9 77 fb ff ff       	jmp    101e54 <__alltraps>

001022dd <vector127>:
.globl vector127
vector127:
  pushl $0
  1022dd:	6a 00                	push   $0x0
  pushl $127
  1022df:	6a 7f                	push   $0x7f
  jmp __alltraps
  1022e1:	e9 6e fb ff ff       	jmp    101e54 <__alltraps>

001022e6 <vector128>:
.globl vector128
vector128:
  pushl $0
  1022e6:	6a 00                	push   $0x0
  pushl $128
  1022e8:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1022ed:	e9 62 fb ff ff       	jmp    101e54 <__alltraps>

001022f2 <vector129>:
.globl vector129
vector129:
  pushl $0
  1022f2:	6a 00                	push   $0x0
  pushl $129
  1022f4:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1022f9:	e9 56 fb ff ff       	jmp    101e54 <__alltraps>

001022fe <vector130>:
.globl vector130
vector130:
  pushl $0
  1022fe:	6a 00                	push   $0x0
  pushl $130
  102300:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102305:	e9 4a fb ff ff       	jmp    101e54 <__alltraps>

0010230a <vector131>:
.globl vector131
vector131:
  pushl $0
  10230a:	6a 00                	push   $0x0
  pushl $131
  10230c:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102311:	e9 3e fb ff ff       	jmp    101e54 <__alltraps>

00102316 <vector132>:
.globl vector132
vector132:
  pushl $0
  102316:	6a 00                	push   $0x0
  pushl $132
  102318:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  10231d:	e9 32 fb ff ff       	jmp    101e54 <__alltraps>

00102322 <vector133>:
.globl vector133
vector133:
  pushl $0
  102322:	6a 00                	push   $0x0
  pushl $133
  102324:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102329:	e9 26 fb ff ff       	jmp    101e54 <__alltraps>

0010232e <vector134>:
.globl vector134
vector134:
  pushl $0
  10232e:	6a 00                	push   $0x0
  pushl $134
  102330:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102335:	e9 1a fb ff ff       	jmp    101e54 <__alltraps>

0010233a <vector135>:
.globl vector135
vector135:
  pushl $0
  10233a:	6a 00                	push   $0x0
  pushl $135
  10233c:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102341:	e9 0e fb ff ff       	jmp    101e54 <__alltraps>

00102346 <vector136>:
.globl vector136
vector136:
  pushl $0
  102346:	6a 00                	push   $0x0
  pushl $136
  102348:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  10234d:	e9 02 fb ff ff       	jmp    101e54 <__alltraps>

00102352 <vector137>:
.globl vector137
vector137:
  pushl $0
  102352:	6a 00                	push   $0x0
  pushl $137
  102354:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102359:	e9 f6 fa ff ff       	jmp    101e54 <__alltraps>

0010235e <vector138>:
.globl vector138
vector138:
  pushl $0
  10235e:	6a 00                	push   $0x0
  pushl $138
  102360:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102365:	e9 ea fa ff ff       	jmp    101e54 <__alltraps>

0010236a <vector139>:
.globl vector139
vector139:
  pushl $0
  10236a:	6a 00                	push   $0x0
  pushl $139
  10236c:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102371:	e9 de fa ff ff       	jmp    101e54 <__alltraps>

00102376 <vector140>:
.globl vector140
vector140:
  pushl $0
  102376:	6a 00                	push   $0x0
  pushl $140
  102378:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  10237d:	e9 d2 fa ff ff       	jmp    101e54 <__alltraps>

00102382 <vector141>:
.globl vector141
vector141:
  pushl $0
  102382:	6a 00                	push   $0x0
  pushl $141
  102384:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102389:	e9 c6 fa ff ff       	jmp    101e54 <__alltraps>

0010238e <vector142>:
.globl vector142
vector142:
  pushl $0
  10238e:	6a 00                	push   $0x0
  pushl $142
  102390:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102395:	e9 ba fa ff ff       	jmp    101e54 <__alltraps>

0010239a <vector143>:
.globl vector143
vector143:
  pushl $0
  10239a:	6a 00                	push   $0x0
  pushl $143
  10239c:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1023a1:	e9 ae fa ff ff       	jmp    101e54 <__alltraps>

001023a6 <vector144>:
.globl vector144
vector144:
  pushl $0
  1023a6:	6a 00                	push   $0x0
  pushl $144
  1023a8:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1023ad:	e9 a2 fa ff ff       	jmp    101e54 <__alltraps>

001023b2 <vector145>:
.globl vector145
vector145:
  pushl $0
  1023b2:	6a 00                	push   $0x0
  pushl $145
  1023b4:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1023b9:	e9 96 fa ff ff       	jmp    101e54 <__alltraps>

001023be <vector146>:
.globl vector146
vector146:
  pushl $0
  1023be:	6a 00                	push   $0x0
  pushl $146
  1023c0:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1023c5:	e9 8a fa ff ff       	jmp    101e54 <__alltraps>

001023ca <vector147>:
.globl vector147
vector147:
  pushl $0
  1023ca:	6a 00                	push   $0x0
  pushl $147
  1023cc:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1023d1:	e9 7e fa ff ff       	jmp    101e54 <__alltraps>

001023d6 <vector148>:
.globl vector148
vector148:
  pushl $0
  1023d6:	6a 00                	push   $0x0
  pushl $148
  1023d8:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1023dd:	e9 72 fa ff ff       	jmp    101e54 <__alltraps>

001023e2 <vector149>:
.globl vector149
vector149:
  pushl $0
  1023e2:	6a 00                	push   $0x0
  pushl $149
  1023e4:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1023e9:	e9 66 fa ff ff       	jmp    101e54 <__alltraps>

001023ee <vector150>:
.globl vector150
vector150:
  pushl $0
  1023ee:	6a 00                	push   $0x0
  pushl $150
  1023f0:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1023f5:	e9 5a fa ff ff       	jmp    101e54 <__alltraps>

001023fa <vector151>:
.globl vector151
vector151:
  pushl $0
  1023fa:	6a 00                	push   $0x0
  pushl $151
  1023fc:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102401:	e9 4e fa ff ff       	jmp    101e54 <__alltraps>

00102406 <vector152>:
.globl vector152
vector152:
  pushl $0
  102406:	6a 00                	push   $0x0
  pushl $152
  102408:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  10240d:	e9 42 fa ff ff       	jmp    101e54 <__alltraps>

00102412 <vector153>:
.globl vector153
vector153:
  pushl $0
  102412:	6a 00                	push   $0x0
  pushl $153
  102414:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102419:	e9 36 fa ff ff       	jmp    101e54 <__alltraps>

0010241e <vector154>:
.globl vector154
vector154:
  pushl $0
  10241e:	6a 00                	push   $0x0
  pushl $154
  102420:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102425:	e9 2a fa ff ff       	jmp    101e54 <__alltraps>

0010242a <vector155>:
.globl vector155
vector155:
  pushl $0
  10242a:	6a 00                	push   $0x0
  pushl $155
  10242c:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102431:	e9 1e fa ff ff       	jmp    101e54 <__alltraps>

00102436 <vector156>:
.globl vector156
vector156:
  pushl $0
  102436:	6a 00                	push   $0x0
  pushl $156
  102438:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  10243d:	e9 12 fa ff ff       	jmp    101e54 <__alltraps>

00102442 <vector157>:
.globl vector157
vector157:
  pushl $0
  102442:	6a 00                	push   $0x0
  pushl $157
  102444:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102449:	e9 06 fa ff ff       	jmp    101e54 <__alltraps>

0010244e <vector158>:
.globl vector158
vector158:
  pushl $0
  10244e:	6a 00                	push   $0x0
  pushl $158
  102450:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102455:	e9 fa f9 ff ff       	jmp    101e54 <__alltraps>

0010245a <vector159>:
.globl vector159
vector159:
  pushl $0
  10245a:	6a 00                	push   $0x0
  pushl $159
  10245c:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102461:	e9 ee f9 ff ff       	jmp    101e54 <__alltraps>

00102466 <vector160>:
.globl vector160
vector160:
  pushl $0
  102466:	6a 00                	push   $0x0
  pushl $160
  102468:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  10246d:	e9 e2 f9 ff ff       	jmp    101e54 <__alltraps>

00102472 <vector161>:
.globl vector161
vector161:
  pushl $0
  102472:	6a 00                	push   $0x0
  pushl $161
  102474:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102479:	e9 d6 f9 ff ff       	jmp    101e54 <__alltraps>

0010247e <vector162>:
.globl vector162
vector162:
  pushl $0
  10247e:	6a 00                	push   $0x0
  pushl $162
  102480:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102485:	e9 ca f9 ff ff       	jmp    101e54 <__alltraps>

0010248a <vector163>:
.globl vector163
vector163:
  pushl $0
  10248a:	6a 00                	push   $0x0
  pushl $163
  10248c:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102491:	e9 be f9 ff ff       	jmp    101e54 <__alltraps>

00102496 <vector164>:
.globl vector164
vector164:
  pushl $0
  102496:	6a 00                	push   $0x0
  pushl $164
  102498:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  10249d:	e9 b2 f9 ff ff       	jmp    101e54 <__alltraps>

001024a2 <vector165>:
.globl vector165
vector165:
  pushl $0
  1024a2:	6a 00                	push   $0x0
  pushl $165
  1024a4:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1024a9:	e9 a6 f9 ff ff       	jmp    101e54 <__alltraps>

001024ae <vector166>:
.globl vector166
vector166:
  pushl $0
  1024ae:	6a 00                	push   $0x0
  pushl $166
  1024b0:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1024b5:	e9 9a f9 ff ff       	jmp    101e54 <__alltraps>

001024ba <vector167>:
.globl vector167
vector167:
  pushl $0
  1024ba:	6a 00                	push   $0x0
  pushl $167
  1024bc:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1024c1:	e9 8e f9 ff ff       	jmp    101e54 <__alltraps>

001024c6 <vector168>:
.globl vector168
vector168:
  pushl $0
  1024c6:	6a 00                	push   $0x0
  pushl $168
  1024c8:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1024cd:	e9 82 f9 ff ff       	jmp    101e54 <__alltraps>

001024d2 <vector169>:
.globl vector169
vector169:
  pushl $0
  1024d2:	6a 00                	push   $0x0
  pushl $169
  1024d4:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1024d9:	e9 76 f9 ff ff       	jmp    101e54 <__alltraps>

001024de <vector170>:
.globl vector170
vector170:
  pushl $0
  1024de:	6a 00                	push   $0x0
  pushl $170
  1024e0:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1024e5:	e9 6a f9 ff ff       	jmp    101e54 <__alltraps>

001024ea <vector171>:
.globl vector171
vector171:
  pushl $0
  1024ea:	6a 00                	push   $0x0
  pushl $171
  1024ec:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1024f1:	e9 5e f9 ff ff       	jmp    101e54 <__alltraps>

001024f6 <vector172>:
.globl vector172
vector172:
  pushl $0
  1024f6:	6a 00                	push   $0x0
  pushl $172
  1024f8:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1024fd:	e9 52 f9 ff ff       	jmp    101e54 <__alltraps>

00102502 <vector173>:
.globl vector173
vector173:
  pushl $0
  102502:	6a 00                	push   $0x0
  pushl $173
  102504:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102509:	e9 46 f9 ff ff       	jmp    101e54 <__alltraps>

0010250e <vector174>:
.globl vector174
vector174:
  pushl $0
  10250e:	6a 00                	push   $0x0
  pushl $174
  102510:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102515:	e9 3a f9 ff ff       	jmp    101e54 <__alltraps>

0010251a <vector175>:
.globl vector175
vector175:
  pushl $0
  10251a:	6a 00                	push   $0x0
  pushl $175
  10251c:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102521:	e9 2e f9 ff ff       	jmp    101e54 <__alltraps>

00102526 <vector176>:
.globl vector176
vector176:
  pushl $0
  102526:	6a 00                	push   $0x0
  pushl $176
  102528:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  10252d:	e9 22 f9 ff ff       	jmp    101e54 <__alltraps>

00102532 <vector177>:
.globl vector177
vector177:
  pushl $0
  102532:	6a 00                	push   $0x0
  pushl $177
  102534:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102539:	e9 16 f9 ff ff       	jmp    101e54 <__alltraps>

0010253e <vector178>:
.globl vector178
vector178:
  pushl $0
  10253e:	6a 00                	push   $0x0
  pushl $178
  102540:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102545:	e9 0a f9 ff ff       	jmp    101e54 <__alltraps>

0010254a <vector179>:
.globl vector179
vector179:
  pushl $0
  10254a:	6a 00                	push   $0x0
  pushl $179
  10254c:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102551:	e9 fe f8 ff ff       	jmp    101e54 <__alltraps>

00102556 <vector180>:
.globl vector180
vector180:
  pushl $0
  102556:	6a 00                	push   $0x0
  pushl $180
  102558:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  10255d:	e9 f2 f8 ff ff       	jmp    101e54 <__alltraps>

00102562 <vector181>:
.globl vector181
vector181:
  pushl $0
  102562:	6a 00                	push   $0x0
  pushl $181
  102564:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102569:	e9 e6 f8 ff ff       	jmp    101e54 <__alltraps>

0010256e <vector182>:
.globl vector182
vector182:
  pushl $0
  10256e:	6a 00                	push   $0x0
  pushl $182
  102570:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102575:	e9 da f8 ff ff       	jmp    101e54 <__alltraps>

0010257a <vector183>:
.globl vector183
vector183:
  pushl $0
  10257a:	6a 00                	push   $0x0
  pushl $183
  10257c:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102581:	e9 ce f8 ff ff       	jmp    101e54 <__alltraps>

00102586 <vector184>:
.globl vector184
vector184:
  pushl $0
  102586:	6a 00                	push   $0x0
  pushl $184
  102588:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  10258d:	e9 c2 f8 ff ff       	jmp    101e54 <__alltraps>

00102592 <vector185>:
.globl vector185
vector185:
  pushl $0
  102592:	6a 00                	push   $0x0
  pushl $185
  102594:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102599:	e9 b6 f8 ff ff       	jmp    101e54 <__alltraps>

0010259e <vector186>:
.globl vector186
vector186:
  pushl $0
  10259e:	6a 00                	push   $0x0
  pushl $186
  1025a0:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1025a5:	e9 aa f8 ff ff       	jmp    101e54 <__alltraps>

001025aa <vector187>:
.globl vector187
vector187:
  pushl $0
  1025aa:	6a 00                	push   $0x0
  pushl $187
  1025ac:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1025b1:	e9 9e f8 ff ff       	jmp    101e54 <__alltraps>

001025b6 <vector188>:
.globl vector188
vector188:
  pushl $0
  1025b6:	6a 00                	push   $0x0
  pushl $188
  1025b8:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1025bd:	e9 92 f8 ff ff       	jmp    101e54 <__alltraps>

001025c2 <vector189>:
.globl vector189
vector189:
  pushl $0
  1025c2:	6a 00                	push   $0x0
  pushl $189
  1025c4:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1025c9:	e9 86 f8 ff ff       	jmp    101e54 <__alltraps>

001025ce <vector190>:
.globl vector190
vector190:
  pushl $0
  1025ce:	6a 00                	push   $0x0
  pushl $190
  1025d0:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1025d5:	e9 7a f8 ff ff       	jmp    101e54 <__alltraps>

001025da <vector191>:
.globl vector191
vector191:
  pushl $0
  1025da:	6a 00                	push   $0x0
  pushl $191
  1025dc:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1025e1:	e9 6e f8 ff ff       	jmp    101e54 <__alltraps>

001025e6 <vector192>:
.globl vector192
vector192:
  pushl $0
  1025e6:	6a 00                	push   $0x0
  pushl $192
  1025e8:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1025ed:	e9 62 f8 ff ff       	jmp    101e54 <__alltraps>

001025f2 <vector193>:
.globl vector193
vector193:
  pushl $0
  1025f2:	6a 00                	push   $0x0
  pushl $193
  1025f4:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1025f9:	e9 56 f8 ff ff       	jmp    101e54 <__alltraps>

001025fe <vector194>:
.globl vector194
vector194:
  pushl $0
  1025fe:	6a 00                	push   $0x0
  pushl $194
  102600:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102605:	e9 4a f8 ff ff       	jmp    101e54 <__alltraps>

0010260a <vector195>:
.globl vector195
vector195:
  pushl $0
  10260a:	6a 00                	push   $0x0
  pushl $195
  10260c:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102611:	e9 3e f8 ff ff       	jmp    101e54 <__alltraps>

00102616 <vector196>:
.globl vector196
vector196:
  pushl $0
  102616:	6a 00                	push   $0x0
  pushl $196
  102618:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  10261d:	e9 32 f8 ff ff       	jmp    101e54 <__alltraps>

00102622 <vector197>:
.globl vector197
vector197:
  pushl $0
  102622:	6a 00                	push   $0x0
  pushl $197
  102624:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102629:	e9 26 f8 ff ff       	jmp    101e54 <__alltraps>

0010262e <vector198>:
.globl vector198
vector198:
  pushl $0
  10262e:	6a 00                	push   $0x0
  pushl $198
  102630:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102635:	e9 1a f8 ff ff       	jmp    101e54 <__alltraps>

0010263a <vector199>:
.globl vector199
vector199:
  pushl $0
  10263a:	6a 00                	push   $0x0
  pushl $199
  10263c:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102641:	e9 0e f8 ff ff       	jmp    101e54 <__alltraps>

00102646 <vector200>:
.globl vector200
vector200:
  pushl $0
  102646:	6a 00                	push   $0x0
  pushl $200
  102648:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  10264d:	e9 02 f8 ff ff       	jmp    101e54 <__alltraps>

00102652 <vector201>:
.globl vector201
vector201:
  pushl $0
  102652:	6a 00                	push   $0x0
  pushl $201
  102654:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102659:	e9 f6 f7 ff ff       	jmp    101e54 <__alltraps>

0010265e <vector202>:
.globl vector202
vector202:
  pushl $0
  10265e:	6a 00                	push   $0x0
  pushl $202
  102660:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102665:	e9 ea f7 ff ff       	jmp    101e54 <__alltraps>

0010266a <vector203>:
.globl vector203
vector203:
  pushl $0
  10266a:	6a 00                	push   $0x0
  pushl $203
  10266c:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102671:	e9 de f7 ff ff       	jmp    101e54 <__alltraps>

00102676 <vector204>:
.globl vector204
vector204:
  pushl $0
  102676:	6a 00                	push   $0x0
  pushl $204
  102678:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  10267d:	e9 d2 f7 ff ff       	jmp    101e54 <__alltraps>

00102682 <vector205>:
.globl vector205
vector205:
  pushl $0
  102682:	6a 00                	push   $0x0
  pushl $205
  102684:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102689:	e9 c6 f7 ff ff       	jmp    101e54 <__alltraps>

0010268e <vector206>:
.globl vector206
vector206:
  pushl $0
  10268e:	6a 00                	push   $0x0
  pushl $206
  102690:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102695:	e9 ba f7 ff ff       	jmp    101e54 <__alltraps>

0010269a <vector207>:
.globl vector207
vector207:
  pushl $0
  10269a:	6a 00                	push   $0x0
  pushl $207
  10269c:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1026a1:	e9 ae f7 ff ff       	jmp    101e54 <__alltraps>

001026a6 <vector208>:
.globl vector208
vector208:
  pushl $0
  1026a6:	6a 00                	push   $0x0
  pushl $208
  1026a8:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1026ad:	e9 a2 f7 ff ff       	jmp    101e54 <__alltraps>

001026b2 <vector209>:
.globl vector209
vector209:
  pushl $0
  1026b2:	6a 00                	push   $0x0
  pushl $209
  1026b4:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1026b9:	e9 96 f7 ff ff       	jmp    101e54 <__alltraps>

001026be <vector210>:
.globl vector210
vector210:
  pushl $0
  1026be:	6a 00                	push   $0x0
  pushl $210
  1026c0:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1026c5:	e9 8a f7 ff ff       	jmp    101e54 <__alltraps>

001026ca <vector211>:
.globl vector211
vector211:
  pushl $0
  1026ca:	6a 00                	push   $0x0
  pushl $211
  1026cc:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1026d1:	e9 7e f7 ff ff       	jmp    101e54 <__alltraps>

001026d6 <vector212>:
.globl vector212
vector212:
  pushl $0
  1026d6:	6a 00                	push   $0x0
  pushl $212
  1026d8:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1026dd:	e9 72 f7 ff ff       	jmp    101e54 <__alltraps>

001026e2 <vector213>:
.globl vector213
vector213:
  pushl $0
  1026e2:	6a 00                	push   $0x0
  pushl $213
  1026e4:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1026e9:	e9 66 f7 ff ff       	jmp    101e54 <__alltraps>

001026ee <vector214>:
.globl vector214
vector214:
  pushl $0
  1026ee:	6a 00                	push   $0x0
  pushl $214
  1026f0:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1026f5:	e9 5a f7 ff ff       	jmp    101e54 <__alltraps>

001026fa <vector215>:
.globl vector215
vector215:
  pushl $0
  1026fa:	6a 00                	push   $0x0
  pushl $215
  1026fc:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102701:	e9 4e f7 ff ff       	jmp    101e54 <__alltraps>

00102706 <vector216>:
.globl vector216
vector216:
  pushl $0
  102706:	6a 00                	push   $0x0
  pushl $216
  102708:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  10270d:	e9 42 f7 ff ff       	jmp    101e54 <__alltraps>

00102712 <vector217>:
.globl vector217
vector217:
  pushl $0
  102712:	6a 00                	push   $0x0
  pushl $217
  102714:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102719:	e9 36 f7 ff ff       	jmp    101e54 <__alltraps>

0010271e <vector218>:
.globl vector218
vector218:
  pushl $0
  10271e:	6a 00                	push   $0x0
  pushl $218
  102720:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102725:	e9 2a f7 ff ff       	jmp    101e54 <__alltraps>

0010272a <vector219>:
.globl vector219
vector219:
  pushl $0
  10272a:	6a 00                	push   $0x0
  pushl $219
  10272c:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102731:	e9 1e f7 ff ff       	jmp    101e54 <__alltraps>

00102736 <vector220>:
.globl vector220
vector220:
  pushl $0
  102736:	6a 00                	push   $0x0
  pushl $220
  102738:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  10273d:	e9 12 f7 ff ff       	jmp    101e54 <__alltraps>

00102742 <vector221>:
.globl vector221
vector221:
  pushl $0
  102742:	6a 00                	push   $0x0
  pushl $221
  102744:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102749:	e9 06 f7 ff ff       	jmp    101e54 <__alltraps>

0010274e <vector222>:
.globl vector222
vector222:
  pushl $0
  10274e:	6a 00                	push   $0x0
  pushl $222
  102750:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102755:	e9 fa f6 ff ff       	jmp    101e54 <__alltraps>

0010275a <vector223>:
.globl vector223
vector223:
  pushl $0
  10275a:	6a 00                	push   $0x0
  pushl $223
  10275c:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102761:	e9 ee f6 ff ff       	jmp    101e54 <__alltraps>

00102766 <vector224>:
.globl vector224
vector224:
  pushl $0
  102766:	6a 00                	push   $0x0
  pushl $224
  102768:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  10276d:	e9 e2 f6 ff ff       	jmp    101e54 <__alltraps>

00102772 <vector225>:
.globl vector225
vector225:
  pushl $0
  102772:	6a 00                	push   $0x0
  pushl $225
  102774:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102779:	e9 d6 f6 ff ff       	jmp    101e54 <__alltraps>

0010277e <vector226>:
.globl vector226
vector226:
  pushl $0
  10277e:	6a 00                	push   $0x0
  pushl $226
  102780:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102785:	e9 ca f6 ff ff       	jmp    101e54 <__alltraps>

0010278a <vector227>:
.globl vector227
vector227:
  pushl $0
  10278a:	6a 00                	push   $0x0
  pushl $227
  10278c:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102791:	e9 be f6 ff ff       	jmp    101e54 <__alltraps>

00102796 <vector228>:
.globl vector228
vector228:
  pushl $0
  102796:	6a 00                	push   $0x0
  pushl $228
  102798:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  10279d:	e9 b2 f6 ff ff       	jmp    101e54 <__alltraps>

001027a2 <vector229>:
.globl vector229
vector229:
  pushl $0
  1027a2:	6a 00                	push   $0x0
  pushl $229
  1027a4:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1027a9:	e9 a6 f6 ff ff       	jmp    101e54 <__alltraps>

001027ae <vector230>:
.globl vector230
vector230:
  pushl $0
  1027ae:	6a 00                	push   $0x0
  pushl $230
  1027b0:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1027b5:	e9 9a f6 ff ff       	jmp    101e54 <__alltraps>

001027ba <vector231>:
.globl vector231
vector231:
  pushl $0
  1027ba:	6a 00                	push   $0x0
  pushl $231
  1027bc:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1027c1:	e9 8e f6 ff ff       	jmp    101e54 <__alltraps>

001027c6 <vector232>:
.globl vector232
vector232:
  pushl $0
  1027c6:	6a 00                	push   $0x0
  pushl $232
  1027c8:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1027cd:	e9 82 f6 ff ff       	jmp    101e54 <__alltraps>

001027d2 <vector233>:
.globl vector233
vector233:
  pushl $0
  1027d2:	6a 00                	push   $0x0
  pushl $233
  1027d4:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1027d9:	e9 76 f6 ff ff       	jmp    101e54 <__alltraps>

001027de <vector234>:
.globl vector234
vector234:
  pushl $0
  1027de:	6a 00                	push   $0x0
  pushl $234
  1027e0:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1027e5:	e9 6a f6 ff ff       	jmp    101e54 <__alltraps>

001027ea <vector235>:
.globl vector235
vector235:
  pushl $0
  1027ea:	6a 00                	push   $0x0
  pushl $235
  1027ec:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1027f1:	e9 5e f6 ff ff       	jmp    101e54 <__alltraps>

001027f6 <vector236>:
.globl vector236
vector236:
  pushl $0
  1027f6:	6a 00                	push   $0x0
  pushl $236
  1027f8:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1027fd:	e9 52 f6 ff ff       	jmp    101e54 <__alltraps>

00102802 <vector237>:
.globl vector237
vector237:
  pushl $0
  102802:	6a 00                	push   $0x0
  pushl $237
  102804:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102809:	e9 46 f6 ff ff       	jmp    101e54 <__alltraps>

0010280e <vector238>:
.globl vector238
vector238:
  pushl $0
  10280e:	6a 00                	push   $0x0
  pushl $238
  102810:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102815:	e9 3a f6 ff ff       	jmp    101e54 <__alltraps>

0010281a <vector239>:
.globl vector239
vector239:
  pushl $0
  10281a:	6a 00                	push   $0x0
  pushl $239
  10281c:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102821:	e9 2e f6 ff ff       	jmp    101e54 <__alltraps>

00102826 <vector240>:
.globl vector240
vector240:
  pushl $0
  102826:	6a 00                	push   $0x0
  pushl $240
  102828:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  10282d:	e9 22 f6 ff ff       	jmp    101e54 <__alltraps>

00102832 <vector241>:
.globl vector241
vector241:
  pushl $0
  102832:	6a 00                	push   $0x0
  pushl $241
  102834:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102839:	e9 16 f6 ff ff       	jmp    101e54 <__alltraps>

0010283e <vector242>:
.globl vector242
vector242:
  pushl $0
  10283e:	6a 00                	push   $0x0
  pushl $242
  102840:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102845:	e9 0a f6 ff ff       	jmp    101e54 <__alltraps>

0010284a <vector243>:
.globl vector243
vector243:
  pushl $0
  10284a:	6a 00                	push   $0x0
  pushl $243
  10284c:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102851:	e9 fe f5 ff ff       	jmp    101e54 <__alltraps>

00102856 <vector244>:
.globl vector244
vector244:
  pushl $0
  102856:	6a 00                	push   $0x0
  pushl $244
  102858:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  10285d:	e9 f2 f5 ff ff       	jmp    101e54 <__alltraps>

00102862 <vector245>:
.globl vector245
vector245:
  pushl $0
  102862:	6a 00                	push   $0x0
  pushl $245
  102864:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102869:	e9 e6 f5 ff ff       	jmp    101e54 <__alltraps>

0010286e <vector246>:
.globl vector246
vector246:
  pushl $0
  10286e:	6a 00                	push   $0x0
  pushl $246
  102870:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102875:	e9 da f5 ff ff       	jmp    101e54 <__alltraps>

0010287a <vector247>:
.globl vector247
vector247:
  pushl $0
  10287a:	6a 00                	push   $0x0
  pushl $247
  10287c:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102881:	e9 ce f5 ff ff       	jmp    101e54 <__alltraps>

00102886 <vector248>:
.globl vector248
vector248:
  pushl $0
  102886:	6a 00                	push   $0x0
  pushl $248
  102888:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  10288d:	e9 c2 f5 ff ff       	jmp    101e54 <__alltraps>

00102892 <vector249>:
.globl vector249
vector249:
  pushl $0
  102892:	6a 00                	push   $0x0
  pushl $249
  102894:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102899:	e9 b6 f5 ff ff       	jmp    101e54 <__alltraps>

0010289e <vector250>:
.globl vector250
vector250:
  pushl $0
  10289e:	6a 00                	push   $0x0
  pushl $250
  1028a0:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1028a5:	e9 aa f5 ff ff       	jmp    101e54 <__alltraps>

001028aa <vector251>:
.globl vector251
vector251:
  pushl $0
  1028aa:	6a 00                	push   $0x0
  pushl $251
  1028ac:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1028b1:	e9 9e f5 ff ff       	jmp    101e54 <__alltraps>

001028b6 <vector252>:
.globl vector252
vector252:
  pushl $0
  1028b6:	6a 00                	push   $0x0
  pushl $252
  1028b8:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1028bd:	e9 92 f5 ff ff       	jmp    101e54 <__alltraps>

001028c2 <vector253>:
.globl vector253
vector253:
  pushl $0
  1028c2:	6a 00                	push   $0x0
  pushl $253
  1028c4:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1028c9:	e9 86 f5 ff ff       	jmp    101e54 <__alltraps>

001028ce <vector254>:
.globl vector254
vector254:
  pushl $0
  1028ce:	6a 00                	push   $0x0
  pushl $254
  1028d0:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1028d5:	e9 7a f5 ff ff       	jmp    101e54 <__alltraps>

001028da <vector255>:
.globl vector255
vector255:
  pushl $0
  1028da:	6a 00                	push   $0x0
  pushl $255
  1028dc:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  1028e1:	e9 6e f5 ff ff       	jmp    101e54 <__alltraps>

001028e6 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  1028e6:	55                   	push   %ebp
  1028e7:	89 e5                	mov    %esp,%ebp
    return page - pages;
  1028e9:	8b 55 08             	mov    0x8(%ebp),%edx
  1028ec:	a1 64 89 11 00       	mov    0x118964,%eax
  1028f1:	29 c2                	sub    %eax,%edx
  1028f3:	89 d0                	mov    %edx,%eax
  1028f5:	c1 f8 02             	sar    $0x2,%eax
  1028f8:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  1028fe:	5d                   	pop    %ebp
  1028ff:	c3                   	ret    

00102900 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  102900:	55                   	push   %ebp
  102901:	89 e5                	mov    %esp,%ebp
  102903:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  102906:	8b 45 08             	mov    0x8(%ebp),%eax
  102909:	89 04 24             	mov    %eax,(%esp)
  10290c:	e8 d5 ff ff ff       	call   1028e6 <page2ppn>
  102911:	c1 e0 0c             	shl    $0xc,%eax
}
  102914:	c9                   	leave  
  102915:	c3                   	ret    

00102916 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  102916:	55                   	push   %ebp
  102917:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102919:	8b 45 08             	mov    0x8(%ebp),%eax
  10291c:	8b 00                	mov    (%eax),%eax
}
  10291e:	5d                   	pop    %ebp
  10291f:	c3                   	ret    

00102920 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  102920:	55                   	push   %ebp
  102921:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  102923:	8b 45 08             	mov    0x8(%ebp),%eax
  102926:	8b 55 0c             	mov    0xc(%ebp),%edx
  102929:	89 10                	mov    %edx,(%eax)
}
  10292b:	5d                   	pop    %ebp
  10292c:	c3                   	ret    

0010292d <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  10292d:	55                   	push   %ebp
  10292e:	89 e5                	mov    %esp,%ebp
  102930:	83 ec 10             	sub    $0x10,%esp
  102933:	c7 45 fc 50 89 11 00 	movl   $0x118950,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  10293a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10293d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  102940:	89 50 04             	mov    %edx,0x4(%eax)
  102943:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102946:	8b 50 04             	mov    0x4(%eax),%edx
  102949:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10294c:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  10294e:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  102955:	00 00 00 
}
  102958:	c9                   	leave  
  102959:	c3                   	ret    

0010295a <default_init_memmap>:

void
default_init_memmap(struct Page *base, size_t n) {
  10295a:	55                   	push   %ebp
  10295b:	89 e5                	mov    %esp,%ebp
  10295d:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
  102960:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102964:	75 24                	jne    10298a <default_init_memmap+0x30>
  102966:	c7 44 24 0c 50 66 10 	movl   $0x106650,0xc(%esp)
  10296d:	00 
  10296e:	c7 44 24 08 56 66 10 	movl   $0x106656,0x8(%esp)
  102975:	00 
  102976:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
  10297d:	00 
  10297e:	c7 04 24 6b 66 10 00 	movl   $0x10666b,(%esp)
  102985:	e8 43 e3 ff ff       	call   100ccd <__panic>
    struct Page *p = base;
  10298a:	8b 45 08             	mov    0x8(%ebp),%eax
  10298d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (p = base; p != base + n; p ++)
  102990:	8b 45 08             	mov    0x8(%ebp),%eax
  102993:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102996:	e9 dc 00 00 00       	jmp    102a77 <default_init_memmap+0x11d>
    {
        assert(PageReserved(p));
  10299b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10299e:	83 c0 04             	add    $0x4,%eax
  1029a1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  1029a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1029ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1029ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1029b1:	0f a3 10             	bt     %edx,(%eax)
  1029b4:	19 c0                	sbb    %eax,%eax
  1029b6:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  1029b9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1029bd:	0f 95 c0             	setne  %al
  1029c0:	0f b6 c0             	movzbl %al,%eax
  1029c3:	85 c0                	test   %eax,%eax
  1029c5:	75 24                	jne    1029eb <default_init_memmap+0x91>
  1029c7:	c7 44 24 0c 81 66 10 	movl   $0x106681,0xc(%esp)
  1029ce:	00 
  1029cf:	c7 44 24 08 56 66 10 	movl   $0x106656,0x8(%esp)
  1029d6:	00 
  1029d7:	c7 44 24 04 4a 00 00 	movl   $0x4a,0x4(%esp)
  1029de:	00 
  1029df:	c7 04 24 6b 66 10 00 	movl   $0x10666b,(%esp)
  1029e6:	e8 e2 e2 ff ff       	call   100ccd <__panic>
        p->flags = 0;
  1029eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        SetPageProperty(p);
  1029f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029f8:	83 c0 04             	add    $0x4,%eax
  1029fb:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  102a02:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102a05:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102a08:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102a0b:	0f ab 10             	bts    %edx,(%eax)
        p->property = 0;
  102a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a11:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        set_page_ref(p, 0);
  102a18:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102a1f:	00 
  102a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a23:	89 04 24             	mov    %eax,(%esp)
  102a26:	e8 f5 fe ff ff       	call   102920 <set_page_ref>
        list_add_before(&free_list, &(p->page_link));
  102a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a2e:	83 c0 0c             	add    $0xc,%eax
  102a31:	c7 45 dc 50 89 11 00 	movl   $0x118950,-0x24(%ebp)
  102a38:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102a3b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102a3e:	8b 00                	mov    (%eax),%eax
  102a40:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102a43:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102a46:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102a49:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102a4c:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102a4f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102a52:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102a55:	89 10                	mov    %edx,(%eax)
  102a57:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102a5a:	8b 10                	mov    (%eax),%edx
  102a5c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102a5f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102a62:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102a65:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102a68:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102a6b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102a6e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102a71:	89 10                	mov    %edx,(%eax)

void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (p = base; p != base + n; p ++)
  102a73:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102a77:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a7a:	89 d0                	mov    %edx,%eax
  102a7c:	c1 e0 02             	shl    $0x2,%eax
  102a7f:	01 d0                	add    %edx,%eax
  102a81:	c1 e0 02             	shl    $0x2,%eax
  102a84:	89 c2                	mov    %eax,%edx
  102a86:	8b 45 08             	mov    0x8(%ebp),%eax
  102a89:	01 d0                	add    %edx,%eax
  102a8b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102a8e:	0f 85 07 ff ff ff    	jne    10299b <default_init_memmap+0x41>
        SetPageProperty(p);
        p->property = 0;
        set_page_ref(p, 0);
        list_add_before(&free_list, &(p->page_link));
    }
    nr_free = nr_free + n;
  102a94:	8b 15 58 89 11 00    	mov    0x118958,%edx
  102a9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a9d:	01 d0                	add    %edx,%eax
  102a9f:	a3 58 89 11 00       	mov    %eax,0x118958
    base->property = n;
  102aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  102aa7:	8b 55 0c             	mov    0xc(%ebp),%edx
  102aaa:	89 50 08             	mov    %edx,0x8(%eax)
}
  102aad:	c9                   	leave  
  102aae:	c3                   	ret    

00102aaf <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  102aaf:	55                   	push   %ebp
  102ab0:	89 e5                	mov    %esp,%ebp
  102ab2:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  102ab5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102ab9:	75 24                	jne    102adf <default_alloc_pages+0x30>
  102abb:	c7 44 24 0c 50 66 10 	movl   $0x106650,0xc(%esp)
  102ac2:	00 
  102ac3:	c7 44 24 08 56 66 10 	movl   $0x106656,0x8(%esp)
  102aca:	00 
  102acb:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
  102ad2:	00 
  102ad3:	c7 04 24 6b 66 10 00 	movl   $0x10666b,(%esp)
  102ada:	e8 ee e1 ff ff       	call   100ccd <__panic>

    if (n > nr_free) {
  102adf:	a1 58 89 11 00       	mov    0x118958,%eax
  102ae4:	3b 45 08             	cmp    0x8(%ebp),%eax
  102ae7:	73 0a                	jae    102af3 <default_alloc_pages+0x44>
        return NULL;
  102ae9:	b8 00 00 00 00       	mov    $0x0,%eax
  102aee:	e9 43 01 00 00       	jmp    102c36 <default_alloc_pages+0x187>
    }

    list_entry_t *le = &free_list, *le_next = NULL;
  102af3:	c7 45 f4 50 89 11 00 	movl   $0x118950,-0xc(%ebp)
  102afa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

    struct Page* result = NULL;
  102b01:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    while((le=list_next(le)) != &free_list)
  102b08:	e9 0a 01 00 00       	jmp    102c17 <default_alloc_pages+0x168>
    {
    	struct Page *p = le2page(le, page_link);
  102b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b10:	83 e8 0c             	sub    $0xc,%eax
  102b13:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    	if(p->property >= n)
  102b16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102b19:	8b 40 08             	mov    0x8(%eax),%eax
  102b1c:	3b 45 08             	cmp    0x8(%ebp),%eax
  102b1f:	0f 82 f2 00 00 00    	jb     102c17 <default_alloc_pages+0x168>
    	{
    		int i;
    		for(i=0;i<n;i++)
  102b25:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  102b2c:	eb 79                	jmp    102ba7 <default_alloc_pages+0xf8>
  102b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b31:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102b34:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102b37:	8b 40 04             	mov    0x4(%eax),%eax
    		{
    			le_next = list_next(le);
  102b3a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    			SetPageReserved(le2page(le, page_link));
  102b3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b40:	83 e8 0c             	sub    $0xc,%eax
  102b43:	83 c0 04             	add    $0x4,%eax
  102b46:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102b4d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  102b50:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102b53:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102b56:	0f ab 10             	bts    %edx,(%eax)
				ClearPageProperty(le2page(le, page_link));
  102b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b5c:	83 e8 0c             	sub    $0xc,%eax
  102b5f:	83 c0 04             	add    $0x4,%eax
  102b62:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  102b69:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102b6c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102b6f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102b72:	0f b3 10             	btr    %edx,(%eax)
  102b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b78:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102b7b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102b7e:	8b 40 04             	mov    0x4(%eax),%eax
  102b81:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102b84:	8b 12                	mov    (%edx),%edx
  102b86:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102b89:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102b8c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102b8f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102b92:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102b95:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102b98:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102b9b:	89 10                	mov    %edx,(%eax)
				list_del(le);
				le = le_next;
  102b9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102ba0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
    	struct Page *p = le2page(le, page_link);
    	if(p->property >= n)
    	{
    		int i;
    		for(i=0;i<n;i++)
  102ba3:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  102ba7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102baa:	3b 45 08             	cmp    0x8(%ebp),%eax
  102bad:	0f 82 7b ff ff ff    	jb     102b2e <default_alloc_pages+0x7f>
    			SetPageReserved(le2page(le, page_link));
				ClearPageProperty(le2page(le, page_link));
				list_del(le);
				le = le_next;
			}
			if(p->property > n)
  102bb3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102bb6:	8b 40 08             	mov    0x8(%eax),%eax
  102bb9:	3b 45 08             	cmp    0x8(%ebp),%eax
  102bbc:	76 12                	jbe    102bd0 <default_alloc_pages+0x121>
			{
				(le2page(le, page_link))->property = p->property - n;
  102bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bc1:	8d 50 f4             	lea    -0xc(%eax),%edx
  102bc4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102bc7:	8b 40 08             	mov    0x8(%eax),%eax
  102bca:	2b 45 08             	sub    0x8(%ebp),%eax
  102bcd:	89 42 08             	mov    %eax,0x8(%edx)
			}
			ClearPageProperty(p);
  102bd0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102bd3:	83 c0 04             	add    $0x4,%eax
  102bd6:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  102bdd:	89 45 bc             	mov    %eax,-0x44(%ebp)
  102be0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102be3:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102be6:	0f b3 10             	btr    %edx,(%eax)
			SetPageReserved(p);
  102be9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102bec:	83 c0 04             	add    $0x4,%eax
  102bef:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
  102bf6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102bf9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102bfc:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102bff:	0f ab 10             	bts    %edx,(%eax)
			nr_free = nr_free - n;
  102c02:	a1 58 89 11 00       	mov    0x118958,%eax
  102c07:	2b 45 08             	sub    0x8(%ebp),%eax
  102c0a:	a3 58 89 11 00       	mov    %eax,0x118958
			result = p;
  102c0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102c12:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
  102c15:	eb 1c                	jmp    102c33 <default_alloc_pages+0x184>
  102c17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c1a:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102c1d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102c20:	8b 40 04             	mov    0x4(%eax),%eax

    list_entry_t *le = &free_list, *le_next = NULL;

    struct Page* result = NULL;

    while((le=list_next(le)) != &free_list)
  102c23:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102c26:	81 7d f4 50 89 11 00 	cmpl   $0x118950,-0xc(%ebp)
  102c2d:	0f 85 da fe ff ff    	jne    102b0d <default_alloc_pages+0x5e>
			result = p;
			break;
		}
    }

    return result;
  102c33:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  102c36:	c9                   	leave  
  102c37:	c3                   	ret    

00102c38 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  102c38:	55                   	push   %ebp
  102c39:	89 e5                	mov    %esp,%ebp
  102c3b:	83 ec 48             	sub    $0x48,%esp
    list_entry_t *le = &free_list;
  102c3e:	c7 45 fc 50 89 11 00 	movl   $0x118950,-0x4(%ebp)
    struct Page * p = NULL;
  102c45:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    while((le=list_next(le)) != &free_list)
  102c4c:	eb 13                	jmp    102c61 <default_free_pages+0x29>
    {
    	p = le2page(le, page_link);
  102c4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102c51:	83 e8 0c             	sub    $0xc,%eax
  102c54:	89 45 f8             	mov    %eax,-0x8(%ebp)
    	if(p > base)
  102c57:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102c5a:	3b 45 08             	cmp    0x8(%ebp),%eax
  102c5d:	76 02                	jbe    102c61 <default_free_pages+0x29>
    	{
    		break;
  102c5f:	eb 18                	jmp    102c79 <default_free_pages+0x41>
  102c61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102c64:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102c67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c6a:	8b 40 04             	mov    0x4(%eax),%eax

static void
default_free_pages(struct Page *base, size_t n) {
    list_entry_t *le = &free_list;
    struct Page * p = NULL;
    while((le=list_next(le)) != &free_list)
  102c6d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  102c70:	81 7d fc 50 89 11 00 	cmpl   $0x118950,-0x4(%ebp)
  102c77:	75 d5                	jne    102c4e <default_free_pages+0x16>
    	if(p > base)
    	{
    		break;
    	}
    }
    for(p = base; p < base + n; p ++)
  102c79:	8b 45 08             	mov    0x8(%ebp),%eax
  102c7c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  102c7f:	eb 4b                	jmp    102ccc <default_free_pages+0x94>
    {
    	list_add_before(le, &(p->page_link));
  102c81:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102c84:	8d 50 0c             	lea    0xc(%eax),%edx
  102c87:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102c8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102c8d:	89 55 ec             	mov    %edx,-0x14(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102c90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c93:	8b 00                	mov    (%eax),%eax
  102c95:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102c98:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102c9b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102c9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ca1:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102ca4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102ca7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  102caa:	89 10                	mov    %edx,(%eax)
  102cac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102caf:	8b 10                	mov    (%eax),%edx
  102cb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102cb4:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102cb7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102cba:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102cbd:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102cc0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102cc3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102cc6:	89 10                	mov    %edx,(%eax)
    	if(p > base)
    	{
    		break;
    	}
    }
    for(p = base; p < base + n; p ++)
  102cc8:	83 45 f8 14          	addl   $0x14,-0x8(%ebp)
  102ccc:	8b 55 0c             	mov    0xc(%ebp),%edx
  102ccf:	89 d0                	mov    %edx,%eax
  102cd1:	c1 e0 02             	shl    $0x2,%eax
  102cd4:	01 d0                	add    %edx,%eax
  102cd6:	c1 e0 02             	shl    $0x2,%eax
  102cd9:	89 c2                	mov    %eax,%edx
  102cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  102cde:	01 d0                	add    %edx,%eax
  102ce0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  102ce3:	77 9c                	ja     102c81 <default_free_pages+0x49>
    {
    	list_add_before(le, &(p->page_link));
    }
    base->flags = 0;
  102ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  102ce8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    ClearPageProperty(base);
  102cef:	8b 45 08             	mov    0x8(%ebp),%eax
  102cf2:	83 c0 04             	add    $0x4,%eax
  102cf5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
  102cfc:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102cff:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102d02:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102d05:	0f b3 10             	btr    %edx,(%eax)
    SetPageProperty(base);
  102d08:	8b 45 08             	mov    0x8(%ebp),%eax
  102d0b:	83 c0 04             	add    $0x4,%eax
  102d0e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  102d15:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102d18:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102d1b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102d1e:	0f ab 10             	bts    %edx,(%eax)
    set_page_ref(base, 0);
  102d21:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102d28:	00 
  102d29:	8b 45 08             	mov    0x8(%ebp),%eax
  102d2c:	89 04 24             	mov    %eax,(%esp)
  102d2f:	e8 ec fb ff ff       	call   102920 <set_page_ref>
    base->property = n;
  102d34:	8b 45 08             	mov    0x8(%ebp),%eax
  102d37:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d3a:	89 50 08             	mov    %edx,0x8(%eax)

    p = le2page(le,page_link) ;
  102d3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102d40:	83 e8 0c             	sub    $0xc,%eax
  102d43:	89 45 f8             	mov    %eax,-0x8(%ebp)
    if(base + n == p)
  102d46:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d49:	89 d0                	mov    %edx,%eax
  102d4b:	c1 e0 02             	shl    $0x2,%eax
  102d4e:	01 d0                	add    %edx,%eax
  102d50:	c1 e0 02             	shl    $0x2,%eax
  102d53:	89 c2                	mov    %eax,%edx
  102d55:	8b 45 08             	mov    0x8(%ebp),%eax
  102d58:	01 d0                	add    %edx,%eax
  102d5a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  102d5d:	75 1e                	jne    102d7d <default_free_pages+0x145>
    {
    	base->property += p->property;
  102d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  102d62:	8b 50 08             	mov    0x8(%eax),%edx
  102d65:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102d68:	8b 40 08             	mov    0x8(%eax),%eax
  102d6b:	01 c2                	add    %eax,%edx
  102d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  102d70:	89 50 08             	mov    %edx,0x8(%eax)
    	p->property = 0;
  102d73:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102d76:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    }
    le = list_prev(&(base->page_link));
  102d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  102d80:	83 c0 0c             	add    $0xc,%eax
  102d83:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
  102d86:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102d89:	8b 00                	mov    (%eax),%eax
  102d8b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    p = le2page(le, page_link);
  102d8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102d91:	83 e8 0c             	sub    $0xc,%eax
  102d94:	89 45 f8             	mov    %eax,-0x8(%ebp)
    if((le != &free_list) && (p == base - 1)){
  102d97:	81 7d fc 50 89 11 00 	cmpl   $0x118950,-0x4(%ebp)
  102d9e:	74 57                	je     102df7 <default_free_pages+0x1bf>
  102da0:	8b 45 08             	mov    0x8(%ebp),%eax
  102da3:	83 e8 14             	sub    $0x14,%eax
  102da6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  102da9:	75 4c                	jne    102df7 <default_free_pages+0x1bf>
    	while(le != &free_list)
  102dab:	eb 41                	jmp    102dee <default_free_pages+0x1b6>
    	{
			if(p->property)
  102dad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102db0:	8b 40 08             	mov    0x8(%eax),%eax
  102db3:	85 c0                	test   %eax,%eax
  102db5:	74 20                	je     102dd7 <default_free_pages+0x19f>
			{
				p->property += base->property;
  102db7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102dba:	8b 50 08             	mov    0x8(%eax),%edx
  102dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  102dc0:	8b 40 08             	mov    0x8(%eax),%eax
  102dc3:	01 c2                	add    %eax,%edx
  102dc5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102dc8:	89 50 08             	mov    %edx,0x8(%eax)
				base->property = 0;
  102dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  102dce:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				break;
  102dd5:	eb 20                	jmp    102df7 <default_free_pages+0x1bf>
  102dd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102dda:	89 45 c8             	mov    %eax,-0x38(%ebp)
  102ddd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102de0:	8b 00                	mov    (%eax),%eax
			}
        le = list_prev(le);
  102de2:	89 45 fc             	mov    %eax,-0x4(%ebp)
        p = le2page(le,page_link);
  102de5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102de8:	83 e8 0c             	sub    $0xc,%eax
  102deb:	89 45 f8             	mov    %eax,-0x8(%ebp)
    	p->property = 0;
    }
    le = list_prev(&(base->page_link));
    p = le2page(le, page_link);
    if((le != &free_list) && (p == base - 1)){
    	while(le != &free_list)
  102dee:	81 7d fc 50 89 11 00 	cmpl   $0x118950,-0x4(%ebp)
  102df5:	75 b6                	jne    102dad <default_free_pages+0x175>
        le = list_prev(le);
        p = le2page(le,page_link);
    	}
    }

    nr_free += n;
  102df7:	8b 15 58 89 11 00    	mov    0x118958,%edx
  102dfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e00:	01 d0                	add    %edx,%eax
  102e02:	a3 58 89 11 00       	mov    %eax,0x118958
    return ;
  102e07:	90                   	nop
}
  102e08:	c9                   	leave  
  102e09:	c3                   	ret    

00102e0a <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  102e0a:	55                   	push   %ebp
  102e0b:	89 e5                	mov    %esp,%ebp
    return nr_free;
  102e0d:	a1 58 89 11 00       	mov    0x118958,%eax
}
  102e12:	5d                   	pop    %ebp
  102e13:	c3                   	ret    

00102e14 <basic_check>:

static void
basic_check(void) {
  102e14:	55                   	push   %ebp
  102e15:	89 e5                	mov    %esp,%ebp
  102e17:	83 ec 48             	sub    $0x48,%esp
	struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  102e1a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  102e21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e24:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e2a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  102e2d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102e34:	e8 85 0e 00 00       	call   103cbe <alloc_pages>
  102e39:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102e3c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  102e40:	75 24                	jne    102e66 <basic_check+0x52>
  102e42:	c7 44 24 0c 91 66 10 	movl   $0x106691,0xc(%esp)
  102e49:	00 
  102e4a:	c7 44 24 08 56 66 10 	movl   $0x106656,0x8(%esp)
  102e51:	00 
  102e52:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
  102e59:	00 
  102e5a:	c7 04 24 6b 66 10 00 	movl   $0x10666b,(%esp)
  102e61:	e8 67 de ff ff       	call   100ccd <__panic>
    assert((p1 = alloc_page()) != NULL);
  102e66:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102e6d:	e8 4c 0e 00 00       	call   103cbe <alloc_pages>
  102e72:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e75:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102e79:	75 24                	jne    102e9f <basic_check+0x8b>
  102e7b:	c7 44 24 0c ad 66 10 	movl   $0x1066ad,0xc(%esp)
  102e82:	00 
  102e83:	c7 44 24 08 56 66 10 	movl   $0x106656,0x8(%esp)
  102e8a:	00 
  102e8b:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
  102e92:	00 
  102e93:	c7 04 24 6b 66 10 00 	movl   $0x10666b,(%esp)
  102e9a:	e8 2e de ff ff       	call   100ccd <__panic>
    assert((p2 = alloc_page()) != NULL);
  102e9f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102ea6:	e8 13 0e 00 00       	call   103cbe <alloc_pages>
  102eab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102eae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102eb2:	75 24                	jne    102ed8 <basic_check+0xc4>
  102eb4:	c7 44 24 0c c9 66 10 	movl   $0x1066c9,0xc(%esp)
  102ebb:	00 
  102ebc:	c7 44 24 08 56 66 10 	movl   $0x106656,0x8(%esp)
  102ec3:	00 
  102ec4:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
  102ecb:	00 
  102ecc:	c7 04 24 6b 66 10 00 	movl   $0x10666b,(%esp)
  102ed3:	e8 f5 dd ff ff       	call   100ccd <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  102ed8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102edb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102ede:	74 10                	je     102ef0 <basic_check+0xdc>
  102ee0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ee3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102ee6:	74 08                	je     102ef0 <basic_check+0xdc>
  102ee8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102eeb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102eee:	75 24                	jne    102f14 <basic_check+0x100>
  102ef0:	c7 44 24 0c e8 66 10 	movl   $0x1066e8,0xc(%esp)
  102ef7:	00 
  102ef8:	c7 44 24 08 56 66 10 	movl   $0x106656,0x8(%esp)
  102eff:	00 
  102f00:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
  102f07:	00 
  102f08:	c7 04 24 6b 66 10 00 	movl   $0x10666b,(%esp)
  102f0f:	e8 b9 dd ff ff       	call   100ccd <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  102f14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f17:	89 04 24             	mov    %eax,(%esp)
  102f1a:	e8 f7 f9 ff ff       	call   102916 <page_ref>
  102f1f:	85 c0                	test   %eax,%eax
  102f21:	75 1e                	jne    102f41 <basic_check+0x12d>
  102f23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f26:	89 04 24             	mov    %eax,(%esp)
  102f29:	e8 e8 f9 ff ff       	call   102916 <page_ref>
  102f2e:	85 c0                	test   %eax,%eax
  102f30:	75 0f                	jne    102f41 <basic_check+0x12d>
  102f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f35:	89 04 24             	mov    %eax,(%esp)
  102f38:	e8 d9 f9 ff ff       	call   102916 <page_ref>
  102f3d:	85 c0                	test   %eax,%eax
  102f3f:	74 24                	je     102f65 <basic_check+0x151>
  102f41:	c7 44 24 0c 0c 67 10 	movl   $0x10670c,0xc(%esp)
  102f48:	00 
  102f49:	c7 44 24 08 56 66 10 	movl   $0x106656,0x8(%esp)
  102f50:	00 
  102f51:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
  102f58:	00 
  102f59:	c7 04 24 6b 66 10 00 	movl   $0x10666b,(%esp)
  102f60:	e8 68 dd ff ff       	call   100ccd <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  102f65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f68:	89 04 24             	mov    %eax,(%esp)
  102f6b:	e8 90 f9 ff ff       	call   102900 <page2pa>
  102f70:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  102f76:	c1 e2 0c             	shl    $0xc,%edx
  102f79:	39 d0                	cmp    %edx,%eax
  102f7b:	72 24                	jb     102fa1 <basic_check+0x18d>
  102f7d:	c7 44 24 0c 48 67 10 	movl   $0x106748,0xc(%esp)
  102f84:	00 
  102f85:	c7 44 24 08 56 66 10 	movl   $0x106656,0x8(%esp)
  102f8c:	00 
  102f8d:	c7 44 24 04 be 00 00 	movl   $0xbe,0x4(%esp)
  102f94:	00 
  102f95:	c7 04 24 6b 66 10 00 	movl   $0x10666b,(%esp)
  102f9c:	e8 2c dd ff ff       	call   100ccd <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  102fa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fa4:	89 04 24             	mov    %eax,(%esp)
  102fa7:	e8 54 f9 ff ff       	call   102900 <page2pa>
  102fac:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  102fb2:	c1 e2 0c             	shl    $0xc,%edx
  102fb5:	39 d0                	cmp    %edx,%eax
  102fb7:	72 24                	jb     102fdd <basic_check+0x1c9>
  102fb9:	c7 44 24 0c 65 67 10 	movl   $0x106765,0xc(%esp)
  102fc0:	00 
  102fc1:	c7 44 24 08 56 66 10 	movl   $0x106656,0x8(%esp)
  102fc8:	00 
  102fc9:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
  102fd0:	00 
  102fd1:	c7 04 24 6b 66 10 00 	movl   $0x10666b,(%esp)
  102fd8:	e8 f0 dc ff ff       	call   100ccd <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  102fdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102fe0:	89 04 24             	mov    %eax,(%esp)
  102fe3:	e8 18 f9 ff ff       	call   102900 <page2pa>
  102fe8:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  102fee:	c1 e2 0c             	shl    $0xc,%edx
  102ff1:	39 d0                	cmp    %edx,%eax
  102ff3:	72 24                	jb     103019 <basic_check+0x205>
  102ff5:	c7 44 24 0c 82 67 10 	movl   $0x106782,0xc(%esp)
  102ffc:	00 
  102ffd:	c7 44 24 08 56 66 10 	movl   $0x106656,0x8(%esp)
  103004:	00 
  103005:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
  10300c:	00 
  10300d:	c7 04 24 6b 66 10 00 	movl   $0x10666b,(%esp)
  103014:	e8 b4 dc ff ff       	call   100ccd <__panic>

    list_entry_t free_list_store = free_list;
  103019:	a1 50 89 11 00       	mov    0x118950,%eax
  10301e:	8b 15 54 89 11 00    	mov    0x118954,%edx
  103024:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103027:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10302a:	c7 45 e0 50 89 11 00 	movl   $0x118950,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  103031:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103034:	8b 55 e0             	mov    -0x20(%ebp),%edx
  103037:	89 50 04             	mov    %edx,0x4(%eax)
  10303a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10303d:	8b 50 04             	mov    0x4(%eax),%edx
  103040:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103043:	89 10                	mov    %edx,(%eax)
  103045:	c7 45 dc 50 89 11 00 	movl   $0x118950,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  10304c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10304f:	8b 40 04             	mov    0x4(%eax),%eax
  103052:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  103055:	0f 94 c0             	sete   %al
  103058:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  10305b:	85 c0                	test   %eax,%eax
  10305d:	75 24                	jne    103083 <basic_check+0x26f>
  10305f:	c7 44 24 0c 9f 67 10 	movl   $0x10679f,0xc(%esp)
  103066:	00 
  103067:	c7 44 24 08 56 66 10 	movl   $0x106656,0x8(%esp)
  10306e:	00 
  10306f:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
  103076:	00 
  103077:	c7 04 24 6b 66 10 00 	movl   $0x10666b,(%esp)
  10307e:	e8 4a dc ff ff       	call   100ccd <__panic>

    unsigned int nr_free_store = nr_free;
  103083:	a1 58 89 11 00       	mov    0x118958,%eax
  103088:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  10308b:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  103092:	00 00 00 

    assert(alloc_page() == NULL);
  103095:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10309c:	e8 1d 0c 00 00       	call   103cbe <alloc_pages>
  1030a1:	85 c0                	test   %eax,%eax
  1030a3:	74 24                	je     1030c9 <basic_check+0x2b5>
  1030a5:	c7 44 24 0c b6 67 10 	movl   $0x1067b6,0xc(%esp)
  1030ac:	00 
  1030ad:	c7 44 24 08 56 66 10 	movl   $0x106656,0x8(%esp)
  1030b4:	00 
  1030b5:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
  1030bc:	00 
  1030bd:	c7 04 24 6b 66 10 00 	movl   $0x10666b,(%esp)
  1030c4:	e8 04 dc ff ff       	call   100ccd <__panic>

    free_page(p0);
  1030c9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1030d0:	00 
  1030d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1030d4:	89 04 24             	mov    %eax,(%esp)
  1030d7:	e8 1a 0c 00 00       	call   103cf6 <free_pages>
    free_page(p1);
  1030dc:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1030e3:	00 
  1030e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030e7:	89 04 24             	mov    %eax,(%esp)
  1030ea:	e8 07 0c 00 00       	call   103cf6 <free_pages>
    free_page(p2);
  1030ef:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1030f6:	00 
  1030f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1030fa:	89 04 24             	mov    %eax,(%esp)
  1030fd:	e8 f4 0b 00 00       	call   103cf6 <free_pages>
    assert(nr_free == 3);
  103102:	a1 58 89 11 00       	mov    0x118958,%eax
  103107:	83 f8 03             	cmp    $0x3,%eax
  10310a:	74 24                	je     103130 <basic_check+0x31c>
  10310c:	c7 44 24 0c cb 67 10 	movl   $0x1067cb,0xc(%esp)
  103113:	00 
  103114:	c7 44 24 08 56 66 10 	movl   $0x106656,0x8(%esp)
  10311b:	00 
  10311c:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
  103123:	00 
  103124:	c7 04 24 6b 66 10 00 	movl   $0x10666b,(%esp)
  10312b:	e8 9d db ff ff       	call   100ccd <__panic>

    assert((p0 = alloc_page()) != NULL);
  103130:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103137:	e8 82 0b 00 00       	call   103cbe <alloc_pages>
  10313c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10313f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  103143:	75 24                	jne    103169 <basic_check+0x355>
  103145:	c7 44 24 0c 91 66 10 	movl   $0x106691,0xc(%esp)
  10314c:	00 
  10314d:	c7 44 24 08 56 66 10 	movl   $0x106656,0x8(%esp)
  103154:	00 
  103155:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
  10315c:	00 
  10315d:	c7 04 24 6b 66 10 00 	movl   $0x10666b,(%esp)
  103164:	e8 64 db ff ff       	call   100ccd <__panic>
    assert((p1 = alloc_page()) != NULL);
  103169:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103170:	e8 49 0b 00 00       	call   103cbe <alloc_pages>
  103175:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103178:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10317c:	75 24                	jne    1031a2 <basic_check+0x38e>
  10317e:	c7 44 24 0c ad 66 10 	movl   $0x1066ad,0xc(%esp)
  103185:	00 
  103186:	c7 44 24 08 56 66 10 	movl   $0x106656,0x8(%esp)
  10318d:	00 
  10318e:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
  103195:	00 
  103196:	c7 04 24 6b 66 10 00 	movl   $0x10666b,(%esp)
  10319d:	e8 2b db ff ff       	call   100ccd <__panic>
    assert((p2 = alloc_page()) != NULL);
  1031a2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1031a9:	e8 10 0b 00 00       	call   103cbe <alloc_pages>
  1031ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1031b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1031b5:	75 24                	jne    1031db <basic_check+0x3c7>
  1031b7:	c7 44 24 0c c9 66 10 	movl   $0x1066c9,0xc(%esp)
  1031be:	00 
  1031bf:	c7 44 24 08 56 66 10 	movl   $0x106656,0x8(%esp)
  1031c6:	00 
  1031c7:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
  1031ce:	00 
  1031cf:	c7 04 24 6b 66 10 00 	movl   $0x10666b,(%esp)
  1031d6:	e8 f2 da ff ff       	call   100ccd <__panic>

    assert(alloc_page() == NULL);
  1031db:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1031e2:	e8 d7 0a 00 00       	call   103cbe <alloc_pages>
  1031e7:	85 c0                	test   %eax,%eax
  1031e9:	74 24                	je     10320f <basic_check+0x3fb>
  1031eb:	c7 44 24 0c b6 67 10 	movl   $0x1067b6,0xc(%esp)
  1031f2:	00 
  1031f3:	c7 44 24 08 56 66 10 	movl   $0x106656,0x8(%esp)
  1031fa:	00 
  1031fb:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
  103202:	00 
  103203:	c7 04 24 6b 66 10 00 	movl   $0x10666b,(%esp)
  10320a:	e8 be da ff ff       	call   100ccd <__panic>

    free_page(p0);
  10320f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103216:	00 
  103217:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10321a:	89 04 24             	mov    %eax,(%esp)
  10321d:	e8 d4 0a 00 00       	call   103cf6 <free_pages>
  103222:	c7 45 d8 50 89 11 00 	movl   $0x118950,-0x28(%ebp)
  103229:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10322c:	8b 40 04             	mov    0x4(%eax),%eax
  10322f:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  103232:	0f 94 c0             	sete   %al
  103235:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  103238:	85 c0                	test   %eax,%eax
  10323a:	74 24                	je     103260 <basic_check+0x44c>
  10323c:	c7 44 24 0c d8 67 10 	movl   $0x1067d8,0xc(%esp)
  103243:	00 
  103244:	c7 44 24 08 56 66 10 	movl   $0x106656,0x8(%esp)
  10324b:	00 
  10324c:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
  103253:	00 
  103254:	c7 04 24 6b 66 10 00 	movl   $0x10666b,(%esp)
  10325b:	e8 6d da ff ff       	call   100ccd <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  103260:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103267:	e8 52 0a 00 00       	call   103cbe <alloc_pages>
  10326c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10326f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103272:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103275:	74 24                	je     10329b <basic_check+0x487>
  103277:	c7 44 24 0c f0 67 10 	movl   $0x1067f0,0xc(%esp)
  10327e:	00 
  10327f:	c7 44 24 08 56 66 10 	movl   $0x106656,0x8(%esp)
  103286:	00 
  103287:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
  10328e:	00 
  10328f:	c7 04 24 6b 66 10 00 	movl   $0x10666b,(%esp)
  103296:	e8 32 da ff ff       	call   100ccd <__panic>
    assert(alloc_page() == NULL);
  10329b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1032a2:	e8 17 0a 00 00       	call   103cbe <alloc_pages>
  1032a7:	85 c0                	test   %eax,%eax
  1032a9:	74 24                	je     1032cf <basic_check+0x4bb>
  1032ab:	c7 44 24 0c b6 67 10 	movl   $0x1067b6,0xc(%esp)
  1032b2:	00 
  1032b3:	c7 44 24 08 56 66 10 	movl   $0x106656,0x8(%esp)
  1032ba:	00 
  1032bb:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  1032c2:	00 
  1032c3:	c7 04 24 6b 66 10 00 	movl   $0x10666b,(%esp)
  1032ca:	e8 fe d9 ff ff       	call   100ccd <__panic>

    assert(nr_free == 0);
  1032cf:	a1 58 89 11 00       	mov    0x118958,%eax
  1032d4:	85 c0                	test   %eax,%eax
  1032d6:	74 24                	je     1032fc <basic_check+0x4e8>
  1032d8:	c7 44 24 0c 09 68 10 	movl   $0x106809,0xc(%esp)
  1032df:	00 
  1032e0:	c7 44 24 08 56 66 10 	movl   $0x106656,0x8(%esp)
  1032e7:	00 
  1032e8:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
  1032ef:	00 
  1032f0:	c7 04 24 6b 66 10 00 	movl   $0x10666b,(%esp)
  1032f7:	e8 d1 d9 ff ff       	call   100ccd <__panic>
    free_list = free_list_store;
  1032fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1032ff:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103302:	a3 50 89 11 00       	mov    %eax,0x118950
  103307:	89 15 54 89 11 00    	mov    %edx,0x118954
    nr_free = nr_free_store;
  10330d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103310:	a3 58 89 11 00       	mov    %eax,0x118958

    free_page(p);
  103315:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10331c:	00 
  10331d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103320:	89 04 24             	mov    %eax,(%esp)
  103323:	e8 ce 09 00 00       	call   103cf6 <free_pages>
    free_page(p1);
  103328:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10332f:	00 
  103330:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103333:	89 04 24             	mov    %eax,(%esp)
  103336:	e8 bb 09 00 00       	call   103cf6 <free_pages>
    free_page(p2);
  10333b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103342:	00 
  103343:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103346:	89 04 24             	mov    %eax,(%esp)
  103349:	e8 a8 09 00 00       	call   103cf6 <free_pages>
}
  10334e:	c9                   	leave  
  10334f:	c3                   	ret    

00103350 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  103350:	55                   	push   %ebp
  103351:	89 e5                	mov    %esp,%ebp
  103353:	53                   	push   %ebx
  103354:	81 ec 94 00 00 00    	sub    $0x94,%esp
	int count = 0, total = 0;
  10335a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103361:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  103368:	c7 45 ec 50 89 11 00 	movl   $0x118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  10336f:	eb 6b                	jmp    1033dc <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
  103371:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103374:	83 e8 0c             	sub    $0xc,%eax
  103377:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
  10337a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10337d:	83 c0 04             	add    $0x4,%eax
  103380:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  103387:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10338a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10338d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  103390:	0f a3 10             	bt     %edx,(%eax)
  103393:	19 c0                	sbb    %eax,%eax
  103395:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  103398:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  10339c:	0f 95 c0             	setne  %al
  10339f:	0f b6 c0             	movzbl %al,%eax
  1033a2:	85 c0                	test   %eax,%eax
  1033a4:	75 24                	jne    1033ca <default_check+0x7a>
  1033a6:	c7 44 24 0c 16 68 10 	movl   $0x106816,0xc(%esp)
  1033ad:	00 
  1033ae:	c7 44 24 08 56 66 10 	movl   $0x106656,0x8(%esp)
  1033b5:	00 
  1033b6:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
  1033bd:	00 
  1033be:	c7 04 24 6b 66 10 00 	movl   $0x10666b,(%esp)
  1033c5:	e8 03 d9 ff ff       	call   100ccd <__panic>
        count ++, total += p->property;
  1033ca:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1033ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033d1:	8b 50 08             	mov    0x8(%eax),%edx
  1033d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033d7:	01 d0                	add    %edx,%eax
  1033d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033df:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  1033e2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1033e5:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
	int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  1033e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1033eb:	81 7d ec 50 89 11 00 	cmpl   $0x118950,-0x14(%ebp)
  1033f2:	0f 85 79 ff ff ff    	jne    103371 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
  1033f8:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  1033fb:	e8 28 09 00 00       	call   103d28 <nr_free_pages>
  103400:	39 c3                	cmp    %eax,%ebx
  103402:	74 24                	je     103428 <default_check+0xd8>
  103404:	c7 44 24 0c 26 68 10 	movl   $0x106826,0xc(%esp)
  10340b:	00 
  10340c:	c7 44 24 08 56 66 10 	movl   $0x106656,0x8(%esp)
  103413:	00 
  103414:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
  10341b:	00 
  10341c:	c7 04 24 6b 66 10 00 	movl   $0x10666b,(%esp)
  103423:	e8 a5 d8 ff ff       	call   100ccd <__panic>

    basic_check();
  103428:	e8 e7 f9 ff ff       	call   102e14 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  10342d:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  103434:	e8 85 08 00 00       	call   103cbe <alloc_pages>
  103439:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
  10343c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103440:	75 24                	jne    103466 <default_check+0x116>
  103442:	c7 44 24 0c 3f 68 10 	movl   $0x10683f,0xc(%esp)
  103449:	00 
  10344a:	c7 44 24 08 56 66 10 	movl   $0x106656,0x8(%esp)
  103451:	00 
  103452:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
  103459:	00 
  10345a:	c7 04 24 6b 66 10 00 	movl   $0x10666b,(%esp)
  103461:	e8 67 d8 ff ff       	call   100ccd <__panic>
    assert(!PageProperty(p0));
  103466:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103469:	83 c0 04             	add    $0x4,%eax
  10346c:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  103473:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103476:	8b 45 bc             	mov    -0x44(%ebp),%eax
  103479:	8b 55 c0             	mov    -0x40(%ebp),%edx
  10347c:	0f a3 10             	bt     %edx,(%eax)
  10347f:	19 c0                	sbb    %eax,%eax
  103481:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  103484:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  103488:	0f 95 c0             	setne  %al
  10348b:	0f b6 c0             	movzbl %al,%eax
  10348e:	85 c0                	test   %eax,%eax
  103490:	74 24                	je     1034b6 <default_check+0x166>
  103492:	c7 44 24 0c 4a 68 10 	movl   $0x10684a,0xc(%esp)
  103499:	00 
  10349a:	c7 44 24 08 56 66 10 	movl   $0x106656,0x8(%esp)
  1034a1:	00 
  1034a2:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
  1034a9:	00 
  1034aa:	c7 04 24 6b 66 10 00 	movl   $0x10666b,(%esp)
  1034b1:	e8 17 d8 ff ff       	call   100ccd <__panic>

    list_entry_t free_list_store = free_list;
  1034b6:	a1 50 89 11 00       	mov    0x118950,%eax
  1034bb:	8b 15 54 89 11 00    	mov    0x118954,%edx
  1034c1:	89 45 80             	mov    %eax,-0x80(%ebp)
  1034c4:	89 55 84             	mov    %edx,-0x7c(%ebp)
  1034c7:	c7 45 b4 50 89 11 00 	movl   $0x118950,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1034ce:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1034d1:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  1034d4:	89 50 04             	mov    %edx,0x4(%eax)
  1034d7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1034da:	8b 50 04             	mov    0x4(%eax),%edx
  1034dd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1034e0:	89 10                	mov    %edx,(%eax)
  1034e2:	c7 45 b0 50 89 11 00 	movl   $0x118950,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  1034e9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1034ec:	8b 40 04             	mov    0x4(%eax),%eax
  1034ef:	39 45 b0             	cmp    %eax,-0x50(%ebp)
  1034f2:	0f 94 c0             	sete   %al
  1034f5:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  1034f8:	85 c0                	test   %eax,%eax
  1034fa:	75 24                	jne    103520 <default_check+0x1d0>
  1034fc:	c7 44 24 0c 9f 67 10 	movl   $0x10679f,0xc(%esp)
  103503:	00 
  103504:	c7 44 24 08 56 66 10 	movl   $0x106656,0x8(%esp)
  10350b:	00 
  10350c:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
  103513:	00 
  103514:	c7 04 24 6b 66 10 00 	movl   $0x10666b,(%esp)
  10351b:	e8 ad d7 ff ff       	call   100ccd <__panic>
    assert(alloc_page() == NULL);
  103520:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103527:	e8 92 07 00 00       	call   103cbe <alloc_pages>
  10352c:	85 c0                	test   %eax,%eax
  10352e:	74 24                	je     103554 <default_check+0x204>
  103530:	c7 44 24 0c b6 67 10 	movl   $0x1067b6,0xc(%esp)
  103537:	00 
  103538:	c7 44 24 08 56 66 10 	movl   $0x106656,0x8(%esp)
  10353f:	00 
  103540:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
  103547:	00 
  103548:	c7 04 24 6b 66 10 00 	movl   $0x10666b,(%esp)
  10354f:	e8 79 d7 ff ff       	call   100ccd <__panic>

    unsigned int nr_free_store = nr_free;
  103554:	a1 58 89 11 00       	mov    0x118958,%eax
  103559:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  10355c:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  103563:	00 00 00 

    free_pages(p0 + 2, 3);
  103566:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103569:	83 c0 28             	add    $0x28,%eax
  10356c:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  103573:	00 
  103574:	89 04 24             	mov    %eax,(%esp)
  103577:	e8 7a 07 00 00       	call   103cf6 <free_pages>
    assert(alloc_pages(4) == NULL);
  10357c:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  103583:	e8 36 07 00 00       	call   103cbe <alloc_pages>
  103588:	85 c0                	test   %eax,%eax
  10358a:	74 24                	je     1035b0 <default_check+0x260>
  10358c:	c7 44 24 0c 5c 68 10 	movl   $0x10685c,0xc(%esp)
  103593:	00 
  103594:	c7 44 24 08 56 66 10 	movl   $0x106656,0x8(%esp)
  10359b:	00 
  10359c:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
  1035a3:	00 
  1035a4:	c7 04 24 6b 66 10 00 	movl   $0x10666b,(%esp)
  1035ab:	e8 1d d7 ff ff       	call   100ccd <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  1035b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1035b3:	83 c0 28             	add    $0x28,%eax
  1035b6:	83 c0 04             	add    $0x4,%eax
  1035b9:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  1035c0:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1035c3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  1035c6:	8b 55 ac             	mov    -0x54(%ebp),%edx
  1035c9:	0f a3 10             	bt     %edx,(%eax)
  1035cc:	19 c0                	sbb    %eax,%eax
  1035ce:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  1035d1:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  1035d5:	0f 95 c0             	setne  %al
  1035d8:	0f b6 c0             	movzbl %al,%eax
  1035db:	85 c0                	test   %eax,%eax
  1035dd:	74 0e                	je     1035ed <default_check+0x29d>
  1035df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1035e2:	83 c0 28             	add    $0x28,%eax
  1035e5:	8b 40 08             	mov    0x8(%eax),%eax
  1035e8:	83 f8 03             	cmp    $0x3,%eax
  1035eb:	74 24                	je     103611 <default_check+0x2c1>
  1035ed:	c7 44 24 0c 74 68 10 	movl   $0x106874,0xc(%esp)
  1035f4:	00 
  1035f5:	c7 44 24 08 56 66 10 	movl   $0x106656,0x8(%esp)
  1035fc:	00 
  1035fd:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
  103604:	00 
  103605:	c7 04 24 6b 66 10 00 	movl   $0x10666b,(%esp)
  10360c:	e8 bc d6 ff ff       	call   100ccd <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  103611:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  103618:	e8 a1 06 00 00       	call   103cbe <alloc_pages>
  10361d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  103620:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103624:	75 24                	jne    10364a <default_check+0x2fa>
  103626:	c7 44 24 0c a0 68 10 	movl   $0x1068a0,0xc(%esp)
  10362d:	00 
  10362e:	c7 44 24 08 56 66 10 	movl   $0x106656,0x8(%esp)
  103635:	00 
  103636:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  10363d:	00 
  10363e:	c7 04 24 6b 66 10 00 	movl   $0x10666b,(%esp)
  103645:	e8 83 d6 ff ff       	call   100ccd <__panic>
    assert(alloc_page() == NULL);
  10364a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103651:	e8 68 06 00 00       	call   103cbe <alloc_pages>
  103656:	85 c0                	test   %eax,%eax
  103658:	74 24                	je     10367e <default_check+0x32e>
  10365a:	c7 44 24 0c b6 67 10 	movl   $0x1067b6,0xc(%esp)
  103661:	00 
  103662:	c7 44 24 08 56 66 10 	movl   $0x106656,0x8(%esp)
  103669:	00 
  10366a:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
  103671:	00 
  103672:	c7 04 24 6b 66 10 00 	movl   $0x10666b,(%esp)
  103679:	e8 4f d6 ff ff       	call   100ccd <__panic>
    assert(p0 + 2 == p1);
  10367e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103681:	83 c0 28             	add    $0x28,%eax
  103684:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  103687:	74 24                	je     1036ad <default_check+0x35d>
  103689:	c7 44 24 0c be 68 10 	movl   $0x1068be,0xc(%esp)
  103690:	00 
  103691:	c7 44 24 08 56 66 10 	movl   $0x106656,0x8(%esp)
  103698:	00 
  103699:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
  1036a0:	00 
  1036a1:	c7 04 24 6b 66 10 00 	movl   $0x10666b,(%esp)
  1036a8:	e8 20 d6 ff ff       	call   100ccd <__panic>

    p2 = p0 + 1;
  1036ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036b0:	83 c0 14             	add    $0x14,%eax
  1036b3:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
  1036b6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1036bd:	00 
  1036be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036c1:	89 04 24             	mov    %eax,(%esp)
  1036c4:	e8 2d 06 00 00       	call   103cf6 <free_pages>
    free_pages(p1, 3);
  1036c9:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1036d0:	00 
  1036d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1036d4:	89 04 24             	mov    %eax,(%esp)
  1036d7:	e8 1a 06 00 00       	call   103cf6 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  1036dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036df:	83 c0 04             	add    $0x4,%eax
  1036e2:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  1036e9:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1036ec:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1036ef:	8b 55 a0             	mov    -0x60(%ebp),%edx
  1036f2:	0f a3 10             	bt     %edx,(%eax)
  1036f5:	19 c0                	sbb    %eax,%eax
  1036f7:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  1036fa:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  1036fe:	0f 95 c0             	setne  %al
  103701:	0f b6 c0             	movzbl %al,%eax
  103704:	85 c0                	test   %eax,%eax
  103706:	74 0b                	je     103713 <default_check+0x3c3>
  103708:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10370b:	8b 40 08             	mov    0x8(%eax),%eax
  10370e:	83 f8 01             	cmp    $0x1,%eax
  103711:	74 24                	je     103737 <default_check+0x3e7>
  103713:	c7 44 24 0c cc 68 10 	movl   $0x1068cc,0xc(%esp)
  10371a:	00 
  10371b:	c7 44 24 08 56 66 10 	movl   $0x106656,0x8(%esp)
  103722:	00 
  103723:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
  10372a:	00 
  10372b:	c7 04 24 6b 66 10 00 	movl   $0x10666b,(%esp)
  103732:	e8 96 d5 ff ff       	call   100ccd <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  103737:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10373a:	83 c0 04             	add    $0x4,%eax
  10373d:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  103744:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103747:	8b 45 90             	mov    -0x70(%ebp),%eax
  10374a:	8b 55 94             	mov    -0x6c(%ebp),%edx
  10374d:	0f a3 10             	bt     %edx,(%eax)
  103750:	19 c0                	sbb    %eax,%eax
  103752:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  103755:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  103759:	0f 95 c0             	setne  %al
  10375c:	0f b6 c0             	movzbl %al,%eax
  10375f:	85 c0                	test   %eax,%eax
  103761:	74 0b                	je     10376e <default_check+0x41e>
  103763:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103766:	8b 40 08             	mov    0x8(%eax),%eax
  103769:	83 f8 03             	cmp    $0x3,%eax
  10376c:	74 24                	je     103792 <default_check+0x442>
  10376e:	c7 44 24 0c f4 68 10 	movl   $0x1068f4,0xc(%esp)
  103775:	00 
  103776:	c7 44 24 08 56 66 10 	movl   $0x106656,0x8(%esp)
  10377d:	00 
  10377e:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  103785:	00 
  103786:	c7 04 24 6b 66 10 00 	movl   $0x10666b,(%esp)
  10378d:	e8 3b d5 ff ff       	call   100ccd <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  103792:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103799:	e8 20 05 00 00       	call   103cbe <alloc_pages>
  10379e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1037a1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1037a4:	83 e8 14             	sub    $0x14,%eax
  1037a7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1037aa:	74 24                	je     1037d0 <default_check+0x480>
  1037ac:	c7 44 24 0c 1a 69 10 	movl   $0x10691a,0xc(%esp)
  1037b3:	00 
  1037b4:	c7 44 24 08 56 66 10 	movl   $0x106656,0x8(%esp)
  1037bb:	00 
  1037bc:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
  1037c3:	00 
  1037c4:	c7 04 24 6b 66 10 00 	movl   $0x10666b,(%esp)
  1037cb:	e8 fd d4 ff ff       	call   100ccd <__panic>
    free_page(p0);
  1037d0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1037d7:	00 
  1037d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1037db:	89 04 24             	mov    %eax,(%esp)
  1037de:	e8 13 05 00 00       	call   103cf6 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  1037e3:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1037ea:	e8 cf 04 00 00       	call   103cbe <alloc_pages>
  1037ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1037f2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1037f5:	83 c0 14             	add    $0x14,%eax
  1037f8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1037fb:	74 24                	je     103821 <default_check+0x4d1>
  1037fd:	c7 44 24 0c 38 69 10 	movl   $0x106938,0xc(%esp)
  103804:	00 
  103805:	c7 44 24 08 56 66 10 	movl   $0x106656,0x8(%esp)
  10380c:	00 
  10380d:	c7 44 24 04 10 01 00 	movl   $0x110,0x4(%esp)
  103814:	00 
  103815:	c7 04 24 6b 66 10 00 	movl   $0x10666b,(%esp)
  10381c:	e8 ac d4 ff ff       	call   100ccd <__panic>

    free_pages(p0, 2);
  103821:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  103828:	00 
  103829:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10382c:	89 04 24             	mov    %eax,(%esp)
  10382f:	e8 c2 04 00 00       	call   103cf6 <free_pages>
    free_page(p2);
  103834:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10383b:	00 
  10383c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10383f:	89 04 24             	mov    %eax,(%esp)
  103842:	e8 af 04 00 00       	call   103cf6 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  103847:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  10384e:	e8 6b 04 00 00       	call   103cbe <alloc_pages>
  103853:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103856:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10385a:	75 24                	jne    103880 <default_check+0x530>
  10385c:	c7 44 24 0c 58 69 10 	movl   $0x106958,0xc(%esp)
  103863:	00 
  103864:	c7 44 24 08 56 66 10 	movl   $0x106656,0x8(%esp)
  10386b:	00 
  10386c:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
  103873:	00 
  103874:	c7 04 24 6b 66 10 00 	movl   $0x10666b,(%esp)
  10387b:	e8 4d d4 ff ff       	call   100ccd <__panic>
    assert(alloc_page() == NULL);
  103880:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103887:	e8 32 04 00 00       	call   103cbe <alloc_pages>
  10388c:	85 c0                	test   %eax,%eax
  10388e:	74 24                	je     1038b4 <default_check+0x564>
  103890:	c7 44 24 0c b6 67 10 	movl   $0x1067b6,0xc(%esp)
  103897:	00 
  103898:	c7 44 24 08 56 66 10 	movl   $0x106656,0x8(%esp)
  10389f:	00 
  1038a0:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  1038a7:	00 
  1038a8:	c7 04 24 6b 66 10 00 	movl   $0x10666b,(%esp)
  1038af:	e8 19 d4 ff ff       	call   100ccd <__panic>

    assert(nr_free == 0);
  1038b4:	a1 58 89 11 00       	mov    0x118958,%eax
  1038b9:	85 c0                	test   %eax,%eax
  1038bb:	74 24                	je     1038e1 <default_check+0x591>
  1038bd:	c7 44 24 0c 09 68 10 	movl   $0x106809,0xc(%esp)
  1038c4:	00 
  1038c5:	c7 44 24 08 56 66 10 	movl   $0x106656,0x8(%esp)
  1038cc:	00 
  1038cd:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
  1038d4:	00 
  1038d5:	c7 04 24 6b 66 10 00 	movl   $0x10666b,(%esp)
  1038dc:	e8 ec d3 ff ff       	call   100ccd <__panic>
    nr_free = nr_free_store;
  1038e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1038e4:	a3 58 89 11 00       	mov    %eax,0x118958

    free_list = free_list_store;
  1038e9:	8b 45 80             	mov    -0x80(%ebp),%eax
  1038ec:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1038ef:	a3 50 89 11 00       	mov    %eax,0x118950
  1038f4:	89 15 54 89 11 00    	mov    %edx,0x118954
    free_pages(p0, 5);
  1038fa:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  103901:	00 
  103902:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103905:	89 04 24             	mov    %eax,(%esp)
  103908:	e8 e9 03 00 00       	call   103cf6 <free_pages>

    le = &free_list;
  10390d:	c7 45 ec 50 89 11 00 	movl   $0x118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  103914:	eb 1d                	jmp    103933 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
  103916:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103919:	83 e8 0c             	sub    $0xc,%eax
  10391c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
  10391f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  103923:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103926:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103929:	8b 40 08             	mov    0x8(%eax),%eax
  10392c:	29 c2                	sub    %eax,%edx
  10392e:	89 d0                	mov    %edx,%eax
  103930:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103933:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103936:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  103939:	8b 45 88             	mov    -0x78(%ebp),%eax
  10393c:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  10393f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103942:	81 7d ec 50 89 11 00 	cmpl   $0x118950,-0x14(%ebp)
  103949:	75 cb                	jne    103916 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
  10394b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10394f:	74 24                	je     103975 <default_check+0x625>
  103951:	c7 44 24 0c 76 69 10 	movl   $0x106976,0xc(%esp)
  103958:	00 
  103959:	c7 44 24 08 56 66 10 	movl   $0x106656,0x8(%esp)
  103960:	00 
  103961:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
  103968:	00 
  103969:	c7 04 24 6b 66 10 00 	movl   $0x10666b,(%esp)
  103970:	e8 58 d3 ff ff       	call   100ccd <__panic>
    assert(total == 0);
  103975:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103979:	74 24                	je     10399f <default_check+0x64f>
  10397b:	c7 44 24 0c 81 69 10 	movl   $0x106981,0xc(%esp)
  103982:	00 
  103983:	c7 44 24 08 56 66 10 	movl   $0x106656,0x8(%esp)
  10398a:	00 
  10398b:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
  103992:	00 
  103993:	c7 04 24 6b 66 10 00 	movl   $0x10666b,(%esp)
  10399a:	e8 2e d3 ff ff       	call   100ccd <__panic>
}
  10399f:	81 c4 94 00 00 00    	add    $0x94,%esp
  1039a5:	5b                   	pop    %ebx
  1039a6:	5d                   	pop    %ebp
  1039a7:	c3                   	ret    

001039a8 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  1039a8:	55                   	push   %ebp
  1039a9:	89 e5                	mov    %esp,%ebp
    return page - pages;
  1039ab:	8b 55 08             	mov    0x8(%ebp),%edx
  1039ae:	a1 64 89 11 00       	mov    0x118964,%eax
  1039b3:	29 c2                	sub    %eax,%edx
  1039b5:	89 d0                	mov    %edx,%eax
  1039b7:	c1 f8 02             	sar    $0x2,%eax
  1039ba:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  1039c0:	5d                   	pop    %ebp
  1039c1:	c3                   	ret    

001039c2 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  1039c2:	55                   	push   %ebp
  1039c3:	89 e5                	mov    %esp,%ebp
  1039c5:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  1039c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1039cb:	89 04 24             	mov    %eax,(%esp)
  1039ce:	e8 d5 ff ff ff       	call   1039a8 <page2ppn>
  1039d3:	c1 e0 0c             	shl    $0xc,%eax
}
  1039d6:	c9                   	leave  
  1039d7:	c3                   	ret    

001039d8 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  1039d8:	55                   	push   %ebp
  1039d9:	89 e5                	mov    %esp,%ebp
  1039db:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  1039de:	8b 45 08             	mov    0x8(%ebp),%eax
  1039e1:	c1 e8 0c             	shr    $0xc,%eax
  1039e4:	89 c2                	mov    %eax,%edx
  1039e6:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1039eb:	39 c2                	cmp    %eax,%edx
  1039ed:	72 1c                	jb     103a0b <pa2page+0x33>
        panic("pa2page called with invalid pa");
  1039ef:	c7 44 24 08 bc 69 10 	movl   $0x1069bc,0x8(%esp)
  1039f6:	00 
  1039f7:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  1039fe:	00 
  1039ff:	c7 04 24 db 69 10 00 	movl   $0x1069db,(%esp)
  103a06:	e8 c2 d2 ff ff       	call   100ccd <__panic>
    }
    return &pages[PPN(pa)];
  103a0b:	8b 0d 64 89 11 00    	mov    0x118964,%ecx
  103a11:	8b 45 08             	mov    0x8(%ebp),%eax
  103a14:	c1 e8 0c             	shr    $0xc,%eax
  103a17:	89 c2                	mov    %eax,%edx
  103a19:	89 d0                	mov    %edx,%eax
  103a1b:	c1 e0 02             	shl    $0x2,%eax
  103a1e:	01 d0                	add    %edx,%eax
  103a20:	c1 e0 02             	shl    $0x2,%eax
  103a23:	01 c8                	add    %ecx,%eax
}
  103a25:	c9                   	leave  
  103a26:	c3                   	ret    

00103a27 <page2kva>:

static inline void *
page2kva(struct Page *page) {
  103a27:	55                   	push   %ebp
  103a28:	89 e5                	mov    %esp,%ebp
  103a2a:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  103a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  103a30:	89 04 24             	mov    %eax,(%esp)
  103a33:	e8 8a ff ff ff       	call   1039c2 <page2pa>
  103a38:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a3e:	c1 e8 0c             	shr    $0xc,%eax
  103a41:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103a44:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103a49:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103a4c:	72 23                	jb     103a71 <page2kva+0x4a>
  103a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a51:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103a55:	c7 44 24 08 ec 69 10 	movl   $0x1069ec,0x8(%esp)
  103a5c:	00 
  103a5d:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  103a64:	00 
  103a65:	c7 04 24 db 69 10 00 	movl   $0x1069db,(%esp)
  103a6c:	e8 5c d2 ff ff       	call   100ccd <__panic>
  103a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a74:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  103a79:	c9                   	leave  
  103a7a:	c3                   	ret    

00103a7b <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  103a7b:	55                   	push   %ebp
  103a7c:	89 e5                	mov    %esp,%ebp
  103a7e:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  103a81:	8b 45 08             	mov    0x8(%ebp),%eax
  103a84:	83 e0 01             	and    $0x1,%eax
  103a87:	85 c0                	test   %eax,%eax
  103a89:	75 1c                	jne    103aa7 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  103a8b:	c7 44 24 08 10 6a 10 	movl   $0x106a10,0x8(%esp)
  103a92:	00 
  103a93:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  103a9a:	00 
  103a9b:	c7 04 24 db 69 10 00 	movl   $0x1069db,(%esp)
  103aa2:	e8 26 d2 ff ff       	call   100ccd <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  103aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  103aaa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103aaf:	89 04 24             	mov    %eax,(%esp)
  103ab2:	e8 21 ff ff ff       	call   1039d8 <pa2page>
}
  103ab7:	c9                   	leave  
  103ab8:	c3                   	ret    

00103ab9 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  103ab9:	55                   	push   %ebp
  103aba:	89 e5                	mov    %esp,%ebp
    return page->ref;
  103abc:	8b 45 08             	mov    0x8(%ebp),%eax
  103abf:	8b 00                	mov    (%eax),%eax
}
  103ac1:	5d                   	pop    %ebp
  103ac2:	c3                   	ret    

00103ac3 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  103ac3:	55                   	push   %ebp
  103ac4:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  103ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  103ac9:	8b 55 0c             	mov    0xc(%ebp),%edx
  103acc:	89 10                	mov    %edx,(%eax)
}
  103ace:	5d                   	pop    %ebp
  103acf:	c3                   	ret    

00103ad0 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  103ad0:	55                   	push   %ebp
  103ad1:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  103ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  103ad6:	8b 00                	mov    (%eax),%eax
  103ad8:	8d 50 01             	lea    0x1(%eax),%edx
  103adb:	8b 45 08             	mov    0x8(%ebp),%eax
  103ade:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  103ae3:	8b 00                	mov    (%eax),%eax
}
  103ae5:	5d                   	pop    %ebp
  103ae6:	c3                   	ret    

00103ae7 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  103ae7:	55                   	push   %ebp
  103ae8:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  103aea:	8b 45 08             	mov    0x8(%ebp),%eax
  103aed:	8b 00                	mov    (%eax),%eax
  103aef:	8d 50 ff             	lea    -0x1(%eax),%edx
  103af2:	8b 45 08             	mov    0x8(%ebp),%eax
  103af5:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103af7:	8b 45 08             	mov    0x8(%ebp),%eax
  103afa:	8b 00                	mov    (%eax),%eax
}
  103afc:	5d                   	pop    %ebp
  103afd:	c3                   	ret    

00103afe <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  103afe:	55                   	push   %ebp
  103aff:	89 e5                	mov    %esp,%ebp
  103b01:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  103b04:	9c                   	pushf  
  103b05:	58                   	pop    %eax
  103b06:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  103b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  103b0c:	25 00 02 00 00       	and    $0x200,%eax
  103b11:	85 c0                	test   %eax,%eax
  103b13:	74 0c                	je     103b21 <__intr_save+0x23>
        intr_disable();
  103b15:	e8 96 db ff ff       	call   1016b0 <intr_disable>
        return 1;
  103b1a:	b8 01 00 00 00       	mov    $0x1,%eax
  103b1f:	eb 05                	jmp    103b26 <__intr_save+0x28>
    }
    return 0;
  103b21:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103b26:	c9                   	leave  
  103b27:	c3                   	ret    

00103b28 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  103b28:	55                   	push   %ebp
  103b29:	89 e5                	mov    %esp,%ebp
  103b2b:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  103b2e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103b32:	74 05                	je     103b39 <__intr_restore+0x11>
        intr_enable();
  103b34:	e8 71 db ff ff       	call   1016aa <intr_enable>
    }
}
  103b39:	c9                   	leave  
  103b3a:	c3                   	ret    

00103b3b <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  103b3b:	55                   	push   %ebp
  103b3c:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  103b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  103b41:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  103b44:	b8 23 00 00 00       	mov    $0x23,%eax
  103b49:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  103b4b:	b8 23 00 00 00       	mov    $0x23,%eax
  103b50:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  103b52:	b8 10 00 00 00       	mov    $0x10,%eax
  103b57:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  103b59:	b8 10 00 00 00       	mov    $0x10,%eax
  103b5e:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  103b60:	b8 10 00 00 00       	mov    $0x10,%eax
  103b65:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  103b67:	ea 6e 3b 10 00 08 00 	ljmp   $0x8,$0x103b6e
}
  103b6e:	5d                   	pop    %ebp
  103b6f:	c3                   	ret    

00103b70 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  103b70:	55                   	push   %ebp
  103b71:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  103b73:	8b 45 08             	mov    0x8(%ebp),%eax
  103b76:	a3 e4 88 11 00       	mov    %eax,0x1188e4
}
  103b7b:	5d                   	pop    %ebp
  103b7c:	c3                   	ret    

00103b7d <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  103b7d:	55                   	push   %ebp
  103b7e:	89 e5                	mov    %esp,%ebp
  103b80:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  103b83:	b8 00 70 11 00       	mov    $0x117000,%eax
  103b88:	89 04 24             	mov    %eax,(%esp)
  103b8b:	e8 e0 ff ff ff       	call   103b70 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  103b90:	66 c7 05 e8 88 11 00 	movw   $0x10,0x1188e8
  103b97:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  103b99:	66 c7 05 28 7a 11 00 	movw   $0x68,0x117a28
  103ba0:	68 00 
  103ba2:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103ba7:	66 a3 2a 7a 11 00    	mov    %ax,0x117a2a
  103bad:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103bb2:	c1 e8 10             	shr    $0x10,%eax
  103bb5:	a2 2c 7a 11 00       	mov    %al,0x117a2c
  103bba:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103bc1:	83 e0 f0             	and    $0xfffffff0,%eax
  103bc4:	83 c8 09             	or     $0x9,%eax
  103bc7:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103bcc:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103bd3:	83 e0 ef             	and    $0xffffffef,%eax
  103bd6:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103bdb:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103be2:	83 e0 9f             	and    $0xffffff9f,%eax
  103be5:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103bea:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103bf1:	83 c8 80             	or     $0xffffff80,%eax
  103bf4:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103bf9:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c00:	83 e0 f0             	and    $0xfffffff0,%eax
  103c03:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c08:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c0f:	83 e0 ef             	and    $0xffffffef,%eax
  103c12:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c17:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c1e:	83 e0 df             	and    $0xffffffdf,%eax
  103c21:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c26:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c2d:	83 c8 40             	or     $0x40,%eax
  103c30:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c35:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c3c:	83 e0 7f             	and    $0x7f,%eax
  103c3f:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c44:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103c49:	c1 e8 18             	shr    $0x18,%eax
  103c4c:	a2 2f 7a 11 00       	mov    %al,0x117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  103c51:	c7 04 24 30 7a 11 00 	movl   $0x117a30,(%esp)
  103c58:	e8 de fe ff ff       	call   103b3b <lgdt>
  103c5d:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  103c63:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  103c67:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  103c6a:	c9                   	leave  
  103c6b:	c3                   	ret    

00103c6c <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  103c6c:	55                   	push   %ebp
  103c6d:	89 e5                	mov    %esp,%ebp
  103c6f:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  103c72:	c7 05 5c 89 11 00 a0 	movl   $0x1069a0,0x11895c
  103c79:	69 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  103c7c:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103c81:	8b 00                	mov    (%eax),%eax
  103c83:	89 44 24 04          	mov    %eax,0x4(%esp)
  103c87:	c7 04 24 3c 6a 10 00 	movl   $0x106a3c,(%esp)
  103c8e:	e8 a9 c6 ff ff       	call   10033c <cprintf>
    pmm_manager->init();
  103c93:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103c98:	8b 40 04             	mov    0x4(%eax),%eax
  103c9b:	ff d0                	call   *%eax
}
  103c9d:	c9                   	leave  
  103c9e:	c3                   	ret    

00103c9f <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  103c9f:	55                   	push   %ebp
  103ca0:	89 e5                	mov    %esp,%ebp
  103ca2:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  103ca5:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103caa:	8b 40 08             	mov    0x8(%eax),%eax
  103cad:	8b 55 0c             	mov    0xc(%ebp),%edx
  103cb0:	89 54 24 04          	mov    %edx,0x4(%esp)
  103cb4:	8b 55 08             	mov    0x8(%ebp),%edx
  103cb7:	89 14 24             	mov    %edx,(%esp)
  103cba:	ff d0                	call   *%eax
}
  103cbc:	c9                   	leave  
  103cbd:	c3                   	ret    

00103cbe <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  103cbe:	55                   	push   %ebp
  103cbf:	89 e5                	mov    %esp,%ebp
  103cc1:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  103cc4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  103ccb:	e8 2e fe ff ff       	call   103afe <__intr_save>
  103cd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  103cd3:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103cd8:	8b 40 0c             	mov    0xc(%eax),%eax
  103cdb:	8b 55 08             	mov    0x8(%ebp),%edx
  103cde:	89 14 24             	mov    %edx,(%esp)
  103ce1:	ff d0                	call   *%eax
  103ce3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  103ce6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103ce9:	89 04 24             	mov    %eax,(%esp)
  103cec:	e8 37 fe ff ff       	call   103b28 <__intr_restore>
    return page;
  103cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103cf4:	c9                   	leave  
  103cf5:	c3                   	ret    

00103cf6 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  103cf6:	55                   	push   %ebp
  103cf7:	89 e5                	mov    %esp,%ebp
  103cf9:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  103cfc:	e8 fd fd ff ff       	call   103afe <__intr_save>
  103d01:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  103d04:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103d09:	8b 40 10             	mov    0x10(%eax),%eax
  103d0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  103d0f:	89 54 24 04          	mov    %edx,0x4(%esp)
  103d13:	8b 55 08             	mov    0x8(%ebp),%edx
  103d16:	89 14 24             	mov    %edx,(%esp)
  103d19:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  103d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d1e:	89 04 24             	mov    %eax,(%esp)
  103d21:	e8 02 fe ff ff       	call   103b28 <__intr_restore>
}
  103d26:	c9                   	leave  
  103d27:	c3                   	ret    

00103d28 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  103d28:	55                   	push   %ebp
  103d29:	89 e5                	mov    %esp,%ebp
  103d2b:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  103d2e:	e8 cb fd ff ff       	call   103afe <__intr_save>
  103d33:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  103d36:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103d3b:	8b 40 14             	mov    0x14(%eax),%eax
  103d3e:	ff d0                	call   *%eax
  103d40:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  103d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d46:	89 04 24             	mov    %eax,(%esp)
  103d49:	e8 da fd ff ff       	call   103b28 <__intr_restore>
    return ret;
  103d4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  103d51:	c9                   	leave  
  103d52:	c3                   	ret    

00103d53 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  103d53:	55                   	push   %ebp
  103d54:	89 e5                	mov    %esp,%ebp
  103d56:	57                   	push   %edi
  103d57:	56                   	push   %esi
  103d58:	53                   	push   %ebx
  103d59:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  103d5f:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  103d66:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  103d6d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  103d74:	c7 04 24 53 6a 10 00 	movl   $0x106a53,(%esp)
  103d7b:	e8 bc c5 ff ff       	call   10033c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103d80:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103d87:	e9 15 01 00 00       	jmp    103ea1 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103d8c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103d8f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103d92:	89 d0                	mov    %edx,%eax
  103d94:	c1 e0 02             	shl    $0x2,%eax
  103d97:	01 d0                	add    %edx,%eax
  103d99:	c1 e0 02             	shl    $0x2,%eax
  103d9c:	01 c8                	add    %ecx,%eax
  103d9e:	8b 50 08             	mov    0x8(%eax),%edx
  103da1:	8b 40 04             	mov    0x4(%eax),%eax
  103da4:	89 45 b8             	mov    %eax,-0x48(%ebp)
  103da7:	89 55 bc             	mov    %edx,-0x44(%ebp)
  103daa:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103dad:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103db0:	89 d0                	mov    %edx,%eax
  103db2:	c1 e0 02             	shl    $0x2,%eax
  103db5:	01 d0                	add    %edx,%eax
  103db7:	c1 e0 02             	shl    $0x2,%eax
  103dba:	01 c8                	add    %ecx,%eax
  103dbc:	8b 48 0c             	mov    0xc(%eax),%ecx
  103dbf:	8b 58 10             	mov    0x10(%eax),%ebx
  103dc2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103dc5:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103dc8:	01 c8                	add    %ecx,%eax
  103dca:	11 da                	adc    %ebx,%edx
  103dcc:	89 45 b0             	mov    %eax,-0x50(%ebp)
  103dcf:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  103dd2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103dd5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103dd8:	89 d0                	mov    %edx,%eax
  103dda:	c1 e0 02             	shl    $0x2,%eax
  103ddd:	01 d0                	add    %edx,%eax
  103ddf:	c1 e0 02             	shl    $0x2,%eax
  103de2:	01 c8                	add    %ecx,%eax
  103de4:	83 c0 14             	add    $0x14,%eax
  103de7:	8b 00                	mov    (%eax),%eax
  103de9:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  103def:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103df2:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103df5:	83 c0 ff             	add    $0xffffffff,%eax
  103df8:	83 d2 ff             	adc    $0xffffffff,%edx
  103dfb:	89 c6                	mov    %eax,%esi
  103dfd:	89 d7                	mov    %edx,%edi
  103dff:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103e02:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e05:	89 d0                	mov    %edx,%eax
  103e07:	c1 e0 02             	shl    $0x2,%eax
  103e0a:	01 d0                	add    %edx,%eax
  103e0c:	c1 e0 02             	shl    $0x2,%eax
  103e0f:	01 c8                	add    %ecx,%eax
  103e11:	8b 48 0c             	mov    0xc(%eax),%ecx
  103e14:	8b 58 10             	mov    0x10(%eax),%ebx
  103e17:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  103e1d:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  103e21:	89 74 24 14          	mov    %esi,0x14(%esp)
  103e25:	89 7c 24 18          	mov    %edi,0x18(%esp)
  103e29:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103e2c:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103e2f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103e33:	89 54 24 10          	mov    %edx,0x10(%esp)
  103e37:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  103e3b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  103e3f:	c7 04 24 60 6a 10 00 	movl   $0x106a60,(%esp)
  103e46:	e8 f1 c4 ff ff       	call   10033c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  103e4b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103e4e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e51:	89 d0                	mov    %edx,%eax
  103e53:	c1 e0 02             	shl    $0x2,%eax
  103e56:	01 d0                	add    %edx,%eax
  103e58:	c1 e0 02             	shl    $0x2,%eax
  103e5b:	01 c8                	add    %ecx,%eax
  103e5d:	83 c0 14             	add    $0x14,%eax
  103e60:	8b 00                	mov    (%eax),%eax
  103e62:	83 f8 01             	cmp    $0x1,%eax
  103e65:	75 36                	jne    103e9d <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
  103e67:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103e6a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103e6d:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103e70:	77 2b                	ja     103e9d <page_init+0x14a>
  103e72:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103e75:	72 05                	jb     103e7c <page_init+0x129>
  103e77:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  103e7a:	73 21                	jae    103e9d <page_init+0x14a>
  103e7c:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103e80:	77 1b                	ja     103e9d <page_init+0x14a>
  103e82:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103e86:	72 09                	jb     103e91 <page_init+0x13e>
  103e88:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  103e8f:	77 0c                	ja     103e9d <page_init+0x14a>
                maxpa = end;
  103e91:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103e94:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103e97:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103e9a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103e9d:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103ea1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103ea4:	8b 00                	mov    (%eax),%eax
  103ea6:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  103ea9:	0f 8f dd fe ff ff    	jg     103d8c <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  103eaf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103eb3:	72 1d                	jb     103ed2 <page_init+0x17f>
  103eb5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103eb9:	77 09                	ja     103ec4 <page_init+0x171>
  103ebb:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  103ec2:	76 0e                	jbe    103ed2 <page_init+0x17f>
        maxpa = KMEMSIZE;
  103ec4:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  103ecb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  103ed2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103ed5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103ed8:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  103edc:	c1 ea 0c             	shr    $0xc,%edx
  103edf:	a3 c0 88 11 00       	mov    %eax,0x1188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  103ee4:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  103eeb:	b8 68 89 11 00       	mov    $0x118968,%eax
  103ef0:	8d 50 ff             	lea    -0x1(%eax),%edx
  103ef3:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103ef6:	01 d0                	add    %edx,%eax
  103ef8:	89 45 a8             	mov    %eax,-0x58(%ebp)
  103efb:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103efe:	ba 00 00 00 00       	mov    $0x0,%edx
  103f03:	f7 75 ac             	divl   -0x54(%ebp)
  103f06:	89 d0                	mov    %edx,%eax
  103f08:	8b 55 a8             	mov    -0x58(%ebp),%edx
  103f0b:	29 c2                	sub    %eax,%edx
  103f0d:	89 d0                	mov    %edx,%eax
  103f0f:	a3 64 89 11 00       	mov    %eax,0x118964

    for (i = 0; i < npage; i ++) {
  103f14:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103f1b:	eb 2f                	jmp    103f4c <page_init+0x1f9>
        SetPageReserved(pages + i);
  103f1d:	8b 0d 64 89 11 00    	mov    0x118964,%ecx
  103f23:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f26:	89 d0                	mov    %edx,%eax
  103f28:	c1 e0 02             	shl    $0x2,%eax
  103f2b:	01 d0                	add    %edx,%eax
  103f2d:	c1 e0 02             	shl    $0x2,%eax
  103f30:	01 c8                	add    %ecx,%eax
  103f32:	83 c0 04             	add    $0x4,%eax
  103f35:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  103f3c:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  103f3f:	8b 45 8c             	mov    -0x74(%ebp),%eax
  103f42:	8b 55 90             	mov    -0x70(%ebp),%edx
  103f45:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
  103f48:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103f4c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f4f:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103f54:	39 c2                	cmp    %eax,%edx
  103f56:	72 c5                	jb     103f1d <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  103f58:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  103f5e:	89 d0                	mov    %edx,%eax
  103f60:	c1 e0 02             	shl    $0x2,%eax
  103f63:	01 d0                	add    %edx,%eax
  103f65:	c1 e0 02             	shl    $0x2,%eax
  103f68:	89 c2                	mov    %eax,%edx
  103f6a:	a1 64 89 11 00       	mov    0x118964,%eax
  103f6f:	01 d0                	add    %edx,%eax
  103f71:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  103f74:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  103f7b:	77 23                	ja     103fa0 <page_init+0x24d>
  103f7d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  103f80:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103f84:	c7 44 24 08 90 6a 10 	movl   $0x106a90,0x8(%esp)
  103f8b:	00 
  103f8c:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  103f93:	00 
  103f94:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  103f9b:	e8 2d cd ff ff       	call   100ccd <__panic>
  103fa0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  103fa3:	05 00 00 00 40       	add    $0x40000000,%eax
  103fa8:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  103fab:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103fb2:	e9 74 01 00 00       	jmp    10412b <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103fb7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103fba:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103fbd:	89 d0                	mov    %edx,%eax
  103fbf:	c1 e0 02             	shl    $0x2,%eax
  103fc2:	01 d0                	add    %edx,%eax
  103fc4:	c1 e0 02             	shl    $0x2,%eax
  103fc7:	01 c8                	add    %ecx,%eax
  103fc9:	8b 50 08             	mov    0x8(%eax),%edx
  103fcc:	8b 40 04             	mov    0x4(%eax),%eax
  103fcf:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103fd2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103fd5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103fd8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103fdb:	89 d0                	mov    %edx,%eax
  103fdd:	c1 e0 02             	shl    $0x2,%eax
  103fe0:	01 d0                	add    %edx,%eax
  103fe2:	c1 e0 02             	shl    $0x2,%eax
  103fe5:	01 c8                	add    %ecx,%eax
  103fe7:	8b 48 0c             	mov    0xc(%eax),%ecx
  103fea:	8b 58 10             	mov    0x10(%eax),%ebx
  103fed:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103ff0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103ff3:	01 c8                	add    %ecx,%eax
  103ff5:	11 da                	adc    %ebx,%edx
  103ff7:	89 45 c8             	mov    %eax,-0x38(%ebp)
  103ffa:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  103ffd:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104000:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104003:	89 d0                	mov    %edx,%eax
  104005:	c1 e0 02             	shl    $0x2,%eax
  104008:	01 d0                	add    %edx,%eax
  10400a:	c1 e0 02             	shl    $0x2,%eax
  10400d:	01 c8                	add    %ecx,%eax
  10400f:	83 c0 14             	add    $0x14,%eax
  104012:	8b 00                	mov    (%eax),%eax
  104014:	83 f8 01             	cmp    $0x1,%eax
  104017:	0f 85 0a 01 00 00    	jne    104127 <page_init+0x3d4>
            if (begin < freemem) {
  10401d:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104020:	ba 00 00 00 00       	mov    $0x0,%edx
  104025:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  104028:	72 17                	jb     104041 <page_init+0x2ee>
  10402a:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  10402d:	77 05                	ja     104034 <page_init+0x2e1>
  10402f:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  104032:	76 0d                	jbe    104041 <page_init+0x2ee>
                begin = freemem;
  104034:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104037:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10403a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  104041:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  104045:	72 1d                	jb     104064 <page_init+0x311>
  104047:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  10404b:	77 09                	ja     104056 <page_init+0x303>
  10404d:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  104054:	76 0e                	jbe    104064 <page_init+0x311>
                end = KMEMSIZE;
  104056:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  10405d:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  104064:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104067:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10406a:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  10406d:	0f 87 b4 00 00 00    	ja     104127 <page_init+0x3d4>
  104073:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  104076:	72 09                	jb     104081 <page_init+0x32e>
  104078:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  10407b:	0f 83 a6 00 00 00    	jae    104127 <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
  104081:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  104088:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10408b:	8b 45 9c             	mov    -0x64(%ebp),%eax
  10408e:	01 d0                	add    %edx,%eax
  104090:	83 e8 01             	sub    $0x1,%eax
  104093:	89 45 98             	mov    %eax,-0x68(%ebp)
  104096:	8b 45 98             	mov    -0x68(%ebp),%eax
  104099:	ba 00 00 00 00       	mov    $0x0,%edx
  10409e:	f7 75 9c             	divl   -0x64(%ebp)
  1040a1:	89 d0                	mov    %edx,%eax
  1040a3:	8b 55 98             	mov    -0x68(%ebp),%edx
  1040a6:	29 c2                	sub    %eax,%edx
  1040a8:	89 d0                	mov    %edx,%eax
  1040aa:	ba 00 00 00 00       	mov    $0x0,%edx
  1040af:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1040b2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  1040b5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1040b8:	89 45 94             	mov    %eax,-0x6c(%ebp)
  1040bb:	8b 45 94             	mov    -0x6c(%ebp),%eax
  1040be:	ba 00 00 00 00       	mov    $0x0,%edx
  1040c3:	89 c7                	mov    %eax,%edi
  1040c5:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  1040cb:	89 7d 80             	mov    %edi,-0x80(%ebp)
  1040ce:	89 d0                	mov    %edx,%eax
  1040d0:	83 e0 00             	and    $0x0,%eax
  1040d3:	89 45 84             	mov    %eax,-0x7c(%ebp)
  1040d6:	8b 45 80             	mov    -0x80(%ebp),%eax
  1040d9:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1040dc:	89 45 c8             	mov    %eax,-0x38(%ebp)
  1040df:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  1040e2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1040e5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1040e8:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1040eb:	77 3a                	ja     104127 <page_init+0x3d4>
  1040ed:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1040f0:	72 05                	jb     1040f7 <page_init+0x3a4>
  1040f2:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1040f5:	73 30                	jae    104127 <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  1040f7:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  1040fa:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  1040fd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104100:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104103:	29 c8                	sub    %ecx,%eax
  104105:	19 da                	sbb    %ebx,%edx
  104107:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  10410b:	c1 ea 0c             	shr    $0xc,%edx
  10410e:	89 c3                	mov    %eax,%ebx
  104110:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104113:	89 04 24             	mov    %eax,(%esp)
  104116:	e8 bd f8 ff ff       	call   1039d8 <pa2page>
  10411b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  10411f:	89 04 24             	mov    %eax,(%esp)
  104122:	e8 78 fb ff ff       	call   103c9f <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
  104127:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  10412b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10412e:	8b 00                	mov    (%eax),%eax
  104130:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  104133:	0f 8f 7e fe ff ff    	jg     103fb7 <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
  104139:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  10413f:	5b                   	pop    %ebx
  104140:	5e                   	pop    %esi
  104141:	5f                   	pop    %edi
  104142:	5d                   	pop    %ebp
  104143:	c3                   	ret    

00104144 <enable_paging>:

static void
enable_paging(void) {
  104144:	55                   	push   %ebp
  104145:	89 e5                	mov    %esp,%ebp
  104147:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
  10414a:	a1 60 89 11 00       	mov    0x118960,%eax
  10414f:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
  104152:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104155:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
  104158:	0f 20 c0             	mov    %cr0,%eax
  10415b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
  10415e:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
  104161:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
  104164:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
  10416b:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
  10416f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104172:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
  104175:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104178:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
  10417b:	c9                   	leave  
  10417c:	c3                   	ret    

0010417d <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  10417d:	55                   	push   %ebp
  10417e:	89 e5                	mov    %esp,%ebp
  104180:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  104183:	8b 45 14             	mov    0x14(%ebp),%eax
  104186:	8b 55 0c             	mov    0xc(%ebp),%edx
  104189:	31 d0                	xor    %edx,%eax
  10418b:	25 ff 0f 00 00       	and    $0xfff,%eax
  104190:	85 c0                	test   %eax,%eax
  104192:	74 24                	je     1041b8 <boot_map_segment+0x3b>
  104194:	c7 44 24 0c c2 6a 10 	movl   $0x106ac2,0xc(%esp)
  10419b:	00 
  10419c:	c7 44 24 08 d9 6a 10 	movl   $0x106ad9,0x8(%esp)
  1041a3:	00 
  1041a4:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  1041ab:	00 
  1041ac:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  1041b3:	e8 15 cb ff ff       	call   100ccd <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  1041b8:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  1041bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1041c2:	25 ff 0f 00 00       	and    $0xfff,%eax
  1041c7:	89 c2                	mov    %eax,%edx
  1041c9:	8b 45 10             	mov    0x10(%ebp),%eax
  1041cc:	01 c2                	add    %eax,%edx
  1041ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1041d1:	01 d0                	add    %edx,%eax
  1041d3:	83 e8 01             	sub    $0x1,%eax
  1041d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1041d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1041dc:	ba 00 00 00 00       	mov    $0x0,%edx
  1041e1:	f7 75 f0             	divl   -0x10(%ebp)
  1041e4:	89 d0                	mov    %edx,%eax
  1041e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1041e9:	29 c2                	sub    %eax,%edx
  1041eb:	89 d0                	mov    %edx,%eax
  1041ed:	c1 e8 0c             	shr    $0xc,%eax
  1041f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  1041f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1041f6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1041f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1041fc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104201:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  104204:	8b 45 14             	mov    0x14(%ebp),%eax
  104207:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10420a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10420d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104212:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  104215:	eb 6b                	jmp    104282 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
  104217:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  10421e:	00 
  10421f:	8b 45 0c             	mov    0xc(%ebp),%eax
  104222:	89 44 24 04          	mov    %eax,0x4(%esp)
  104226:	8b 45 08             	mov    0x8(%ebp),%eax
  104229:	89 04 24             	mov    %eax,(%esp)
  10422c:	e8 cc 01 00 00       	call   1043fd <get_pte>
  104231:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  104234:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  104238:	75 24                	jne    10425e <boot_map_segment+0xe1>
  10423a:	c7 44 24 0c ee 6a 10 	movl   $0x106aee,0xc(%esp)
  104241:	00 
  104242:	c7 44 24 08 d9 6a 10 	movl   $0x106ad9,0x8(%esp)
  104249:	00 
  10424a:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
  104251:	00 
  104252:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  104259:	e8 6f ca ff ff       	call   100ccd <__panic>
        *ptep = pa | PTE_P | perm;
  10425e:	8b 45 18             	mov    0x18(%ebp),%eax
  104261:	8b 55 14             	mov    0x14(%ebp),%edx
  104264:	09 d0                	or     %edx,%eax
  104266:	83 c8 01             	or     $0x1,%eax
  104269:	89 c2                	mov    %eax,%edx
  10426b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10426e:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  104270:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  104274:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  10427b:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  104282:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104286:	75 8f                	jne    104217 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
  104288:	c9                   	leave  
  104289:	c3                   	ret    

0010428a <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  10428a:	55                   	push   %ebp
  10428b:	89 e5                	mov    %esp,%ebp
  10428d:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  104290:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104297:	e8 22 fa ff ff       	call   103cbe <alloc_pages>
  10429c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  10429f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1042a3:	75 1c                	jne    1042c1 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  1042a5:	c7 44 24 08 fb 6a 10 	movl   $0x106afb,0x8(%esp)
  1042ac:	00 
  1042ad:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  1042b4:	00 
  1042b5:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  1042bc:	e8 0c ca ff ff       	call   100ccd <__panic>
    }
    return page2kva(p);
  1042c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1042c4:	89 04 24             	mov    %eax,(%esp)
  1042c7:	e8 5b f7 ff ff       	call   103a27 <page2kva>
}
  1042cc:	c9                   	leave  
  1042cd:	c3                   	ret    

001042ce <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  1042ce:	55                   	push   %ebp
  1042cf:	89 e5                	mov    %esp,%ebp
  1042d1:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  1042d4:	e8 93 f9 ff ff       	call   103c6c <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  1042d9:	e8 75 fa ff ff       	call   103d53 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  1042de:	e8 67 04 00 00       	call   10474a <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
  1042e3:	e8 a2 ff ff ff       	call   10428a <boot_alloc_page>
  1042e8:	a3 c4 88 11 00       	mov    %eax,0x1188c4
    memset(boot_pgdir, 0, PGSIZE);
  1042ed:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1042f2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1042f9:	00 
  1042fa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104301:	00 
  104302:	89 04 24             	mov    %eax,(%esp)
  104305:	e8 a9 1a 00 00       	call   105db3 <memset>
    boot_cr3 = PADDR(boot_pgdir);
  10430a:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10430f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104312:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  104319:	77 23                	ja     10433e <pmm_init+0x70>
  10431b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10431e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104322:	c7 44 24 08 90 6a 10 	movl   $0x106a90,0x8(%esp)
  104329:	00 
  10432a:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
  104331:	00 
  104332:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  104339:	e8 8f c9 ff ff       	call   100ccd <__panic>
  10433e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104341:	05 00 00 00 40       	add    $0x40000000,%eax
  104346:	a3 60 89 11 00       	mov    %eax,0x118960

    check_pgdir();
  10434b:	e8 18 04 00 00       	call   104768 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  104350:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104355:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  10435b:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104360:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104363:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  10436a:	77 23                	ja     10438f <pmm_init+0xc1>
  10436c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10436f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104373:	c7 44 24 08 90 6a 10 	movl   $0x106a90,0x8(%esp)
  10437a:	00 
  10437b:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
  104382:	00 
  104383:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  10438a:	e8 3e c9 ff ff       	call   100ccd <__panic>
  10438f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104392:	05 00 00 00 40       	add    $0x40000000,%eax
  104397:	83 c8 03             	or     $0x3,%eax
  10439a:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  10439c:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1043a1:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  1043a8:	00 
  1043a9:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1043b0:	00 
  1043b1:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  1043b8:	38 
  1043b9:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  1043c0:	c0 
  1043c1:	89 04 24             	mov    %eax,(%esp)
  1043c4:	e8 b4 fd ff ff       	call   10417d <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
  1043c9:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1043ce:	8b 15 c4 88 11 00    	mov    0x1188c4,%edx
  1043d4:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
  1043da:	89 10                	mov    %edx,(%eax)

    enable_paging();
  1043dc:	e8 63 fd ff ff       	call   104144 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  1043e1:	e8 97 f7 ff ff       	call   103b7d <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
  1043e6:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1043eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  1043f1:	e8 0d 0a 00 00       	call   104e03 <check_boot_pgdir>

    print_pgdir();
  1043f6:	e8 9a 0e 00 00       	call   105295 <print_pgdir>

}
  1043fb:	c9                   	leave  
  1043fc:	c3                   	ret    

001043fd <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  1043fd:	55                   	push   %ebp
  1043fe:	89 e5                	mov    %esp,%ebp
  104400:	83 ec 38             	sub    $0x38,%esp
     * DEFINEs:
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     *   PTE_W           0x002                   // page table/directory entry flags bit : Writeable
     *   PTE_U           0x004                   // page table/directory entry flags bit : User can access
     */
	pde_t *pdep = &pgdir[PDX(la)];
  104403:	8b 45 0c             	mov    0xc(%ebp),%eax
  104406:	c1 e8 16             	shr    $0x16,%eax
  104409:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104410:	8b 45 08             	mov    0x8(%ebp),%eax
  104413:	01 d0                	add    %edx,%eax
  104415:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (!(*pdep & PTE_P))
  104418:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10441b:	8b 00                	mov    (%eax),%eax
  10441d:	83 e0 01             	and    $0x1,%eax
  104420:	85 c0                	test   %eax,%eax
  104422:	0f 85 af 00 00 00    	jne    1044d7 <get_pte+0xda>
	{
		struct Page *p;
		p = alloc_page();
  104428:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10442f:	e8 8a f8 ff ff       	call   103cbe <alloc_pages>
  104434:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if ((!create) || (p  == NULL))
  104437:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10443b:	74 06                	je     104443 <get_pte+0x46>
  10443d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104441:	75 0a                	jne    10444d <get_pte+0x50>
		{
			return NULL;
  104443:	b8 00 00 00 00       	mov    $0x0,%eax
  104448:	e9 e6 00 00 00       	jmp    104533 <get_pte+0x136>
		}
		set_page_ref(p, 1);
  10444d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104454:	00 
  104455:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104458:	89 04 24             	mov    %eax,(%esp)
  10445b:	e8 63 f6 ff ff       	call   103ac3 <set_page_ref>
		uintptr_t pa = page2pa(p);
  104460:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104463:	89 04 24             	mov    %eax,(%esp)
  104466:	e8 57 f5 ff ff       	call   1039c2 <page2pa>
  10446b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		memset(KADDR(pa), 0, PGSIZE);
  10446e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104471:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104474:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104477:	c1 e8 0c             	shr    $0xc,%eax
  10447a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10447d:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104482:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  104485:	72 23                	jb     1044aa <get_pte+0xad>
  104487:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10448a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10448e:	c7 44 24 08 ec 69 10 	movl   $0x1069ec,0x8(%esp)
  104495:	00 
  104496:	c7 44 24 04 7e 01 00 	movl   $0x17e,0x4(%esp)
  10449d:	00 
  10449e:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  1044a5:	e8 23 c8 ff ff       	call   100ccd <__panic>
  1044aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1044ad:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1044b2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1044b9:	00 
  1044ba:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1044c1:	00 
  1044c2:	89 04 24             	mov    %eax,(%esp)
  1044c5:	e8 e9 18 00 00       	call   105db3 <memset>
		*pdep = pa | PTE_U | PTE_W | PTE_P;
  1044ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1044cd:	83 c8 07             	or     $0x7,%eax
  1044d0:	89 c2                	mov    %eax,%edx
  1044d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044d5:	89 10                	mov    %edx,(%eax)
	}
	return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
  1044d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044da:	8b 00                	mov    (%eax),%eax
  1044dc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1044e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1044e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1044e7:	c1 e8 0c             	shr    $0xc,%eax
  1044ea:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1044ed:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1044f2:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1044f5:	72 23                	jb     10451a <get_pte+0x11d>
  1044f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1044fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1044fe:	c7 44 24 08 ec 69 10 	movl   $0x1069ec,0x8(%esp)
  104505:	00 
  104506:	c7 44 24 04 81 01 00 	movl   $0x181,0x4(%esp)
  10450d:	00 
  10450e:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  104515:	e8 b3 c7 ff ff       	call   100ccd <__panic>
  10451a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10451d:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104522:	8b 55 0c             	mov    0xc(%ebp),%edx
  104525:	c1 ea 0c             	shr    $0xc,%edx
  104528:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  10452e:	c1 e2 02             	shl    $0x2,%edx
  104531:	01 d0                	add    %edx,%eax
}
  104533:	c9                   	leave  
  104534:	c3                   	ret    

00104535 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  104535:	55                   	push   %ebp
  104536:	89 e5                	mov    %esp,%ebp
  104538:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  10453b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104542:	00 
  104543:	8b 45 0c             	mov    0xc(%ebp),%eax
  104546:	89 44 24 04          	mov    %eax,0x4(%esp)
  10454a:	8b 45 08             	mov    0x8(%ebp),%eax
  10454d:	89 04 24             	mov    %eax,(%esp)
  104550:	e8 a8 fe ff ff       	call   1043fd <get_pte>
  104555:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  104558:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10455c:	74 08                	je     104566 <get_page+0x31>
        *ptep_store = ptep;
  10455e:	8b 45 10             	mov    0x10(%ebp),%eax
  104561:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104564:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  104566:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10456a:	74 1b                	je     104587 <get_page+0x52>
  10456c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10456f:	8b 00                	mov    (%eax),%eax
  104571:	83 e0 01             	and    $0x1,%eax
  104574:	85 c0                	test   %eax,%eax
  104576:	74 0f                	je     104587 <get_page+0x52>
        return pa2page(*ptep);
  104578:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10457b:	8b 00                	mov    (%eax),%eax
  10457d:	89 04 24             	mov    %eax,(%esp)
  104580:	e8 53 f4 ff ff       	call   1039d8 <pa2page>
  104585:	eb 05                	jmp    10458c <get_page+0x57>
    }
    return NULL;
  104587:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10458c:	c9                   	leave  
  10458d:	c3                   	ret    

0010458e <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  10458e:	55                   	push   %ebp
  10458f:	89 e5                	mov    %esp,%ebp
  104591:	83 ec 28             	sub    $0x28,%esp
     *   tlb_invalidate(pde_t *pgdir, uintptr_t la) : Invalidate a TLB entry, but only if the page tables being
     *                        edited are the ones currently in use by the processor.
     * DEFINEs:
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     */
	if (*ptep & PTE_P)
  104594:	8b 45 10             	mov    0x10(%ebp),%eax
  104597:	8b 00                	mov    (%eax),%eax
  104599:	83 e0 01             	and    $0x1,%eax
  10459c:	85 c0                	test   %eax,%eax
  10459e:	74 4d                	je     1045ed <page_remove_pte+0x5f>
	{
		struct Page *p = pte2page(*ptep);
  1045a0:	8b 45 10             	mov    0x10(%ebp),%eax
  1045a3:	8b 00                	mov    (%eax),%eax
  1045a5:	89 04 24             	mov    %eax,(%esp)
  1045a8:	e8 ce f4 ff ff       	call   103a7b <pte2page>
  1045ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (page_ref_dec(p) == 0)
  1045b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045b3:	89 04 24             	mov    %eax,(%esp)
  1045b6:	e8 2c f5 ff ff       	call   103ae7 <page_ref_dec>
  1045bb:	85 c0                	test   %eax,%eax
  1045bd:	75 13                	jne    1045d2 <page_remove_pte+0x44>
		{
			free_page(p);
  1045bf:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1045c6:	00 
  1045c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045ca:	89 04 24             	mov    %eax,(%esp)
  1045cd:	e8 24 f7 ff ff       	call   103cf6 <free_pages>
		}
		*ptep = 0;
  1045d2:	8b 45 10             	mov    0x10(%ebp),%eax
  1045d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		tlb_invalidate(pgdir, la);
  1045db:	8b 45 0c             	mov    0xc(%ebp),%eax
  1045de:	89 44 24 04          	mov    %eax,0x4(%esp)
  1045e2:	8b 45 08             	mov    0x8(%ebp),%eax
  1045e5:	89 04 24             	mov    %eax,(%esp)
  1045e8:	e8 00 01 00 00       	call   1046ed <tlb_invalidate>
	}
	return;
  1045ed:	90                   	nop
}
  1045ee:	c9                   	leave  
  1045ef:	c3                   	ret    

001045f0 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  1045f0:	55                   	push   %ebp
  1045f1:	89 e5                	mov    %esp,%ebp
  1045f3:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1045f6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1045fd:	00 
  1045fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  104601:	89 44 24 04          	mov    %eax,0x4(%esp)
  104605:	8b 45 08             	mov    0x8(%ebp),%eax
  104608:	89 04 24             	mov    %eax,(%esp)
  10460b:	e8 ed fd ff ff       	call   1043fd <get_pte>
  104610:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  104613:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104617:	74 19                	je     104632 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  104619:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10461c:	89 44 24 08          	mov    %eax,0x8(%esp)
  104620:	8b 45 0c             	mov    0xc(%ebp),%eax
  104623:	89 44 24 04          	mov    %eax,0x4(%esp)
  104627:	8b 45 08             	mov    0x8(%ebp),%eax
  10462a:	89 04 24             	mov    %eax,(%esp)
  10462d:	e8 5c ff ff ff       	call   10458e <page_remove_pte>
    }
}
  104632:	c9                   	leave  
  104633:	c3                   	ret    

00104634 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  104634:	55                   	push   %ebp
  104635:	89 e5                	mov    %esp,%ebp
  104637:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  10463a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  104641:	00 
  104642:	8b 45 10             	mov    0x10(%ebp),%eax
  104645:	89 44 24 04          	mov    %eax,0x4(%esp)
  104649:	8b 45 08             	mov    0x8(%ebp),%eax
  10464c:	89 04 24             	mov    %eax,(%esp)
  10464f:	e8 a9 fd ff ff       	call   1043fd <get_pte>
  104654:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  104657:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10465b:	75 0a                	jne    104667 <page_insert+0x33>
        return -E_NO_MEM;
  10465d:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  104662:	e9 84 00 00 00       	jmp    1046eb <page_insert+0xb7>
    }
    page_ref_inc(page);
  104667:	8b 45 0c             	mov    0xc(%ebp),%eax
  10466a:	89 04 24             	mov    %eax,(%esp)
  10466d:	e8 5e f4 ff ff       	call   103ad0 <page_ref_inc>
    if (*ptep & PTE_P) {
  104672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104675:	8b 00                	mov    (%eax),%eax
  104677:	83 e0 01             	and    $0x1,%eax
  10467a:	85 c0                	test   %eax,%eax
  10467c:	74 3e                	je     1046bc <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  10467e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104681:	8b 00                	mov    (%eax),%eax
  104683:	89 04 24             	mov    %eax,(%esp)
  104686:	e8 f0 f3 ff ff       	call   103a7b <pte2page>
  10468b:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  10468e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104691:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104694:	75 0d                	jne    1046a3 <page_insert+0x6f>
            page_ref_dec(page);
  104696:	8b 45 0c             	mov    0xc(%ebp),%eax
  104699:	89 04 24             	mov    %eax,(%esp)
  10469c:	e8 46 f4 ff ff       	call   103ae7 <page_ref_dec>
  1046a1:	eb 19                	jmp    1046bc <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  1046a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046a6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1046aa:	8b 45 10             	mov    0x10(%ebp),%eax
  1046ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  1046b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1046b4:	89 04 24             	mov    %eax,(%esp)
  1046b7:	e8 d2 fe ff ff       	call   10458e <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  1046bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1046bf:	89 04 24             	mov    %eax,(%esp)
  1046c2:	e8 fb f2 ff ff       	call   1039c2 <page2pa>
  1046c7:	0b 45 14             	or     0x14(%ebp),%eax
  1046ca:	83 c8 01             	or     $0x1,%eax
  1046cd:	89 c2                	mov    %eax,%edx
  1046cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046d2:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  1046d4:	8b 45 10             	mov    0x10(%ebp),%eax
  1046d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1046db:	8b 45 08             	mov    0x8(%ebp),%eax
  1046de:	89 04 24             	mov    %eax,(%esp)
  1046e1:	e8 07 00 00 00       	call   1046ed <tlb_invalidate>
    return 0;
  1046e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1046eb:	c9                   	leave  
  1046ec:	c3                   	ret    

001046ed <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  1046ed:	55                   	push   %ebp
  1046ee:	89 e5                	mov    %esp,%ebp
  1046f0:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  1046f3:	0f 20 d8             	mov    %cr3,%eax
  1046f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  1046f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
  1046fc:	89 c2                	mov    %eax,%edx
  1046fe:	8b 45 08             	mov    0x8(%ebp),%eax
  104701:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104704:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  10470b:	77 23                	ja     104730 <tlb_invalidate+0x43>
  10470d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104710:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104714:	c7 44 24 08 90 6a 10 	movl   $0x106a90,0x8(%esp)
  10471b:	00 
  10471c:	c7 44 24 04 dd 01 00 	movl   $0x1dd,0x4(%esp)
  104723:	00 
  104724:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  10472b:	e8 9d c5 ff ff       	call   100ccd <__panic>
  104730:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104733:	05 00 00 00 40       	add    $0x40000000,%eax
  104738:	39 c2                	cmp    %eax,%edx
  10473a:	75 0c                	jne    104748 <tlb_invalidate+0x5b>
        invlpg((void *)la);
  10473c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10473f:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  104742:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104745:	0f 01 38             	invlpg (%eax)
    }
}
  104748:	c9                   	leave  
  104749:	c3                   	ret    

0010474a <check_alloc_page>:

static void
check_alloc_page(void) {
  10474a:	55                   	push   %ebp
  10474b:	89 e5                	mov    %esp,%ebp
  10474d:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  104750:	a1 5c 89 11 00       	mov    0x11895c,%eax
  104755:	8b 40 18             	mov    0x18(%eax),%eax
  104758:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  10475a:	c7 04 24 14 6b 10 00 	movl   $0x106b14,(%esp)
  104761:	e8 d6 bb ff ff       	call   10033c <cprintf>
}
  104766:	c9                   	leave  
  104767:	c3                   	ret    

00104768 <check_pgdir>:

static void
check_pgdir(void) {
  104768:	55                   	push   %ebp
  104769:	89 e5                	mov    %esp,%ebp
  10476b:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  10476e:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104773:	3d 00 80 03 00       	cmp    $0x38000,%eax
  104778:	76 24                	jbe    10479e <check_pgdir+0x36>
  10477a:	c7 44 24 0c 33 6b 10 	movl   $0x106b33,0xc(%esp)
  104781:	00 
  104782:	c7 44 24 08 d9 6a 10 	movl   $0x106ad9,0x8(%esp)
  104789:	00 
  10478a:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
  104791:	00 
  104792:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  104799:	e8 2f c5 ff ff       	call   100ccd <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  10479e:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1047a3:	85 c0                	test   %eax,%eax
  1047a5:	74 0e                	je     1047b5 <check_pgdir+0x4d>
  1047a7:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1047ac:	25 ff 0f 00 00       	and    $0xfff,%eax
  1047b1:	85 c0                	test   %eax,%eax
  1047b3:	74 24                	je     1047d9 <check_pgdir+0x71>
  1047b5:	c7 44 24 0c 50 6b 10 	movl   $0x106b50,0xc(%esp)
  1047bc:	00 
  1047bd:	c7 44 24 08 d9 6a 10 	movl   $0x106ad9,0x8(%esp)
  1047c4:	00 
  1047c5:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
  1047cc:	00 
  1047cd:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  1047d4:	e8 f4 c4 ff ff       	call   100ccd <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  1047d9:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1047de:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1047e5:	00 
  1047e6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1047ed:	00 
  1047ee:	89 04 24             	mov    %eax,(%esp)
  1047f1:	e8 3f fd ff ff       	call   104535 <get_page>
  1047f6:	85 c0                	test   %eax,%eax
  1047f8:	74 24                	je     10481e <check_pgdir+0xb6>
  1047fa:	c7 44 24 0c 88 6b 10 	movl   $0x106b88,0xc(%esp)
  104801:	00 
  104802:	c7 44 24 08 d9 6a 10 	movl   $0x106ad9,0x8(%esp)
  104809:	00 
  10480a:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
  104811:	00 
  104812:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  104819:	e8 af c4 ff ff       	call   100ccd <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  10481e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104825:	e8 94 f4 ff ff       	call   103cbe <alloc_pages>
  10482a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  10482d:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104832:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104839:	00 
  10483a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104841:	00 
  104842:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104845:	89 54 24 04          	mov    %edx,0x4(%esp)
  104849:	89 04 24             	mov    %eax,(%esp)
  10484c:	e8 e3 fd ff ff       	call   104634 <page_insert>
  104851:	85 c0                	test   %eax,%eax
  104853:	74 24                	je     104879 <check_pgdir+0x111>
  104855:	c7 44 24 0c b0 6b 10 	movl   $0x106bb0,0xc(%esp)
  10485c:	00 
  10485d:	c7 44 24 08 d9 6a 10 	movl   $0x106ad9,0x8(%esp)
  104864:	00 
  104865:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
  10486c:	00 
  10486d:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  104874:	e8 54 c4 ff ff       	call   100ccd <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  104879:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10487e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104885:	00 
  104886:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10488d:	00 
  10488e:	89 04 24             	mov    %eax,(%esp)
  104891:	e8 67 fb ff ff       	call   1043fd <get_pte>
  104896:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104899:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10489d:	75 24                	jne    1048c3 <check_pgdir+0x15b>
  10489f:	c7 44 24 0c dc 6b 10 	movl   $0x106bdc,0xc(%esp)
  1048a6:	00 
  1048a7:	c7 44 24 08 d9 6a 10 	movl   $0x106ad9,0x8(%esp)
  1048ae:	00 
  1048af:	c7 44 24 04 f3 01 00 	movl   $0x1f3,0x4(%esp)
  1048b6:	00 
  1048b7:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  1048be:	e8 0a c4 ff ff       	call   100ccd <__panic>
    assert(pa2page(*ptep) == p1);
  1048c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1048c6:	8b 00                	mov    (%eax),%eax
  1048c8:	89 04 24             	mov    %eax,(%esp)
  1048cb:	e8 08 f1 ff ff       	call   1039d8 <pa2page>
  1048d0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1048d3:	74 24                	je     1048f9 <check_pgdir+0x191>
  1048d5:	c7 44 24 0c 09 6c 10 	movl   $0x106c09,0xc(%esp)
  1048dc:	00 
  1048dd:	c7 44 24 08 d9 6a 10 	movl   $0x106ad9,0x8(%esp)
  1048e4:	00 
  1048e5:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
  1048ec:	00 
  1048ed:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  1048f4:	e8 d4 c3 ff ff       	call   100ccd <__panic>
    assert(page_ref(p1) == 1);
  1048f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048fc:	89 04 24             	mov    %eax,(%esp)
  1048ff:	e8 b5 f1 ff ff       	call   103ab9 <page_ref>
  104904:	83 f8 01             	cmp    $0x1,%eax
  104907:	74 24                	je     10492d <check_pgdir+0x1c5>
  104909:	c7 44 24 0c 1e 6c 10 	movl   $0x106c1e,0xc(%esp)
  104910:	00 
  104911:	c7 44 24 08 d9 6a 10 	movl   $0x106ad9,0x8(%esp)
  104918:	00 
  104919:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
  104920:	00 
  104921:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  104928:	e8 a0 c3 ff ff       	call   100ccd <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  10492d:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104932:	8b 00                	mov    (%eax),%eax
  104934:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104939:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10493c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10493f:	c1 e8 0c             	shr    $0xc,%eax
  104942:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104945:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  10494a:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  10494d:	72 23                	jb     104972 <check_pgdir+0x20a>
  10494f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104952:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104956:	c7 44 24 08 ec 69 10 	movl   $0x1069ec,0x8(%esp)
  10495d:	00 
  10495e:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
  104965:	00 
  104966:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  10496d:	e8 5b c3 ff ff       	call   100ccd <__panic>
  104972:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104975:	2d 00 00 00 40       	sub    $0x40000000,%eax
  10497a:	83 c0 04             	add    $0x4,%eax
  10497d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  104980:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104985:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10498c:	00 
  10498d:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104994:	00 
  104995:	89 04 24             	mov    %eax,(%esp)
  104998:	e8 60 fa ff ff       	call   1043fd <get_pte>
  10499d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  1049a0:	74 24                	je     1049c6 <check_pgdir+0x25e>
  1049a2:	c7 44 24 0c 30 6c 10 	movl   $0x106c30,0xc(%esp)
  1049a9:	00 
  1049aa:	c7 44 24 08 d9 6a 10 	movl   $0x106ad9,0x8(%esp)
  1049b1:	00 
  1049b2:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
  1049b9:	00 
  1049ba:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  1049c1:	e8 07 c3 ff ff       	call   100ccd <__panic>

    p2 = alloc_page();
  1049c6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1049cd:	e8 ec f2 ff ff       	call   103cbe <alloc_pages>
  1049d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  1049d5:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1049da:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  1049e1:	00 
  1049e2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1049e9:	00 
  1049ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1049ed:	89 54 24 04          	mov    %edx,0x4(%esp)
  1049f1:	89 04 24             	mov    %eax,(%esp)
  1049f4:	e8 3b fc ff ff       	call   104634 <page_insert>
  1049f9:	85 c0                	test   %eax,%eax
  1049fb:	74 24                	je     104a21 <check_pgdir+0x2b9>
  1049fd:	c7 44 24 0c 58 6c 10 	movl   $0x106c58,0xc(%esp)
  104a04:	00 
  104a05:	c7 44 24 08 d9 6a 10 	movl   $0x106ad9,0x8(%esp)
  104a0c:	00 
  104a0d:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
  104a14:	00 
  104a15:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  104a1c:	e8 ac c2 ff ff       	call   100ccd <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104a21:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104a26:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104a2d:	00 
  104a2e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104a35:	00 
  104a36:	89 04 24             	mov    %eax,(%esp)
  104a39:	e8 bf f9 ff ff       	call   1043fd <get_pte>
  104a3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104a41:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104a45:	75 24                	jne    104a6b <check_pgdir+0x303>
  104a47:	c7 44 24 0c 90 6c 10 	movl   $0x106c90,0xc(%esp)
  104a4e:	00 
  104a4f:	c7 44 24 08 d9 6a 10 	movl   $0x106ad9,0x8(%esp)
  104a56:	00 
  104a57:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
  104a5e:	00 
  104a5f:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  104a66:	e8 62 c2 ff ff       	call   100ccd <__panic>
    assert(*ptep & PTE_U);
  104a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a6e:	8b 00                	mov    (%eax),%eax
  104a70:	83 e0 04             	and    $0x4,%eax
  104a73:	85 c0                	test   %eax,%eax
  104a75:	75 24                	jne    104a9b <check_pgdir+0x333>
  104a77:	c7 44 24 0c c0 6c 10 	movl   $0x106cc0,0xc(%esp)
  104a7e:	00 
  104a7f:	c7 44 24 08 d9 6a 10 	movl   $0x106ad9,0x8(%esp)
  104a86:	00 
  104a87:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
  104a8e:	00 
  104a8f:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  104a96:	e8 32 c2 ff ff       	call   100ccd <__panic>
    assert(*ptep & PTE_W);
  104a9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a9e:	8b 00                	mov    (%eax),%eax
  104aa0:	83 e0 02             	and    $0x2,%eax
  104aa3:	85 c0                	test   %eax,%eax
  104aa5:	75 24                	jne    104acb <check_pgdir+0x363>
  104aa7:	c7 44 24 0c ce 6c 10 	movl   $0x106cce,0xc(%esp)
  104aae:	00 
  104aaf:	c7 44 24 08 d9 6a 10 	movl   $0x106ad9,0x8(%esp)
  104ab6:	00 
  104ab7:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
  104abe:	00 
  104abf:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  104ac6:	e8 02 c2 ff ff       	call   100ccd <__panic>
    assert(boot_pgdir[0] & PTE_U);
  104acb:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104ad0:	8b 00                	mov    (%eax),%eax
  104ad2:	83 e0 04             	and    $0x4,%eax
  104ad5:	85 c0                	test   %eax,%eax
  104ad7:	75 24                	jne    104afd <check_pgdir+0x395>
  104ad9:	c7 44 24 0c dc 6c 10 	movl   $0x106cdc,0xc(%esp)
  104ae0:	00 
  104ae1:	c7 44 24 08 d9 6a 10 	movl   $0x106ad9,0x8(%esp)
  104ae8:	00 
  104ae9:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
  104af0:	00 
  104af1:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  104af8:	e8 d0 c1 ff ff       	call   100ccd <__panic>
    assert(page_ref(p2) == 1);
  104afd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104b00:	89 04 24             	mov    %eax,(%esp)
  104b03:	e8 b1 ef ff ff       	call   103ab9 <page_ref>
  104b08:	83 f8 01             	cmp    $0x1,%eax
  104b0b:	74 24                	je     104b31 <check_pgdir+0x3c9>
  104b0d:	c7 44 24 0c f2 6c 10 	movl   $0x106cf2,0xc(%esp)
  104b14:	00 
  104b15:	c7 44 24 08 d9 6a 10 	movl   $0x106ad9,0x8(%esp)
  104b1c:	00 
  104b1d:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
  104b24:	00 
  104b25:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  104b2c:	e8 9c c1 ff ff       	call   100ccd <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  104b31:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104b36:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104b3d:	00 
  104b3e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104b45:	00 
  104b46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104b49:	89 54 24 04          	mov    %edx,0x4(%esp)
  104b4d:	89 04 24             	mov    %eax,(%esp)
  104b50:	e8 df fa ff ff       	call   104634 <page_insert>
  104b55:	85 c0                	test   %eax,%eax
  104b57:	74 24                	je     104b7d <check_pgdir+0x415>
  104b59:	c7 44 24 0c 04 6d 10 	movl   $0x106d04,0xc(%esp)
  104b60:	00 
  104b61:	c7 44 24 08 d9 6a 10 	movl   $0x106ad9,0x8(%esp)
  104b68:	00 
  104b69:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  104b70:	00 
  104b71:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  104b78:	e8 50 c1 ff ff       	call   100ccd <__panic>
    assert(page_ref(p1) == 2);
  104b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b80:	89 04 24             	mov    %eax,(%esp)
  104b83:	e8 31 ef ff ff       	call   103ab9 <page_ref>
  104b88:	83 f8 02             	cmp    $0x2,%eax
  104b8b:	74 24                	je     104bb1 <check_pgdir+0x449>
  104b8d:	c7 44 24 0c 30 6d 10 	movl   $0x106d30,0xc(%esp)
  104b94:	00 
  104b95:	c7 44 24 08 d9 6a 10 	movl   $0x106ad9,0x8(%esp)
  104b9c:	00 
  104b9d:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  104ba4:	00 
  104ba5:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  104bac:	e8 1c c1 ff ff       	call   100ccd <__panic>
    assert(page_ref(p2) == 0);
  104bb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104bb4:	89 04 24             	mov    %eax,(%esp)
  104bb7:	e8 fd ee ff ff       	call   103ab9 <page_ref>
  104bbc:	85 c0                	test   %eax,%eax
  104bbe:	74 24                	je     104be4 <check_pgdir+0x47c>
  104bc0:	c7 44 24 0c 42 6d 10 	movl   $0x106d42,0xc(%esp)
  104bc7:	00 
  104bc8:	c7 44 24 08 d9 6a 10 	movl   $0x106ad9,0x8(%esp)
  104bcf:	00 
  104bd0:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
  104bd7:	00 
  104bd8:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  104bdf:	e8 e9 c0 ff ff       	call   100ccd <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104be4:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104be9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104bf0:	00 
  104bf1:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104bf8:	00 
  104bf9:	89 04 24             	mov    %eax,(%esp)
  104bfc:	e8 fc f7 ff ff       	call   1043fd <get_pte>
  104c01:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104c04:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104c08:	75 24                	jne    104c2e <check_pgdir+0x4c6>
  104c0a:	c7 44 24 0c 90 6c 10 	movl   $0x106c90,0xc(%esp)
  104c11:	00 
  104c12:	c7 44 24 08 d9 6a 10 	movl   $0x106ad9,0x8(%esp)
  104c19:	00 
  104c1a:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
  104c21:	00 
  104c22:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  104c29:	e8 9f c0 ff ff       	call   100ccd <__panic>
    assert(pa2page(*ptep) == p1);
  104c2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c31:	8b 00                	mov    (%eax),%eax
  104c33:	89 04 24             	mov    %eax,(%esp)
  104c36:	e8 9d ed ff ff       	call   1039d8 <pa2page>
  104c3b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104c3e:	74 24                	je     104c64 <check_pgdir+0x4fc>
  104c40:	c7 44 24 0c 09 6c 10 	movl   $0x106c09,0xc(%esp)
  104c47:	00 
  104c48:	c7 44 24 08 d9 6a 10 	movl   $0x106ad9,0x8(%esp)
  104c4f:	00 
  104c50:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
  104c57:	00 
  104c58:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  104c5f:	e8 69 c0 ff ff       	call   100ccd <__panic>
    assert((*ptep & PTE_U) == 0);
  104c64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c67:	8b 00                	mov    (%eax),%eax
  104c69:	83 e0 04             	and    $0x4,%eax
  104c6c:	85 c0                	test   %eax,%eax
  104c6e:	74 24                	je     104c94 <check_pgdir+0x52c>
  104c70:	c7 44 24 0c 54 6d 10 	movl   $0x106d54,0xc(%esp)
  104c77:	00 
  104c78:	c7 44 24 08 d9 6a 10 	movl   $0x106ad9,0x8(%esp)
  104c7f:	00 
  104c80:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  104c87:	00 
  104c88:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  104c8f:	e8 39 c0 ff ff       	call   100ccd <__panic>

    page_remove(boot_pgdir, 0x0);
  104c94:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104c99:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104ca0:	00 
  104ca1:	89 04 24             	mov    %eax,(%esp)
  104ca4:	e8 47 f9 ff ff       	call   1045f0 <page_remove>
    assert(page_ref(p1) == 1);
  104ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104cac:	89 04 24             	mov    %eax,(%esp)
  104caf:	e8 05 ee ff ff       	call   103ab9 <page_ref>
  104cb4:	83 f8 01             	cmp    $0x1,%eax
  104cb7:	74 24                	je     104cdd <check_pgdir+0x575>
  104cb9:	c7 44 24 0c 1e 6c 10 	movl   $0x106c1e,0xc(%esp)
  104cc0:	00 
  104cc1:	c7 44 24 08 d9 6a 10 	movl   $0x106ad9,0x8(%esp)
  104cc8:	00 
  104cc9:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
  104cd0:	00 
  104cd1:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  104cd8:	e8 f0 bf ff ff       	call   100ccd <__panic>
    assert(page_ref(p2) == 0);
  104cdd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104ce0:	89 04 24             	mov    %eax,(%esp)
  104ce3:	e8 d1 ed ff ff       	call   103ab9 <page_ref>
  104ce8:	85 c0                	test   %eax,%eax
  104cea:	74 24                	je     104d10 <check_pgdir+0x5a8>
  104cec:	c7 44 24 0c 42 6d 10 	movl   $0x106d42,0xc(%esp)
  104cf3:	00 
  104cf4:	c7 44 24 08 d9 6a 10 	movl   $0x106ad9,0x8(%esp)
  104cfb:	00 
  104cfc:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
  104d03:	00 
  104d04:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  104d0b:	e8 bd bf ff ff       	call   100ccd <__panic>

    page_remove(boot_pgdir, PGSIZE);
  104d10:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104d15:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104d1c:	00 
  104d1d:	89 04 24             	mov    %eax,(%esp)
  104d20:	e8 cb f8 ff ff       	call   1045f0 <page_remove>
    assert(page_ref(p1) == 0);
  104d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d28:	89 04 24             	mov    %eax,(%esp)
  104d2b:	e8 89 ed ff ff       	call   103ab9 <page_ref>
  104d30:	85 c0                	test   %eax,%eax
  104d32:	74 24                	je     104d58 <check_pgdir+0x5f0>
  104d34:	c7 44 24 0c 69 6d 10 	movl   $0x106d69,0xc(%esp)
  104d3b:	00 
  104d3c:	c7 44 24 08 d9 6a 10 	movl   $0x106ad9,0x8(%esp)
  104d43:	00 
  104d44:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
  104d4b:	00 
  104d4c:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  104d53:	e8 75 bf ff ff       	call   100ccd <__panic>
    assert(page_ref(p2) == 0);
  104d58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d5b:	89 04 24             	mov    %eax,(%esp)
  104d5e:	e8 56 ed ff ff       	call   103ab9 <page_ref>
  104d63:	85 c0                	test   %eax,%eax
  104d65:	74 24                	je     104d8b <check_pgdir+0x623>
  104d67:	c7 44 24 0c 42 6d 10 	movl   $0x106d42,0xc(%esp)
  104d6e:	00 
  104d6f:	c7 44 24 08 d9 6a 10 	movl   $0x106ad9,0x8(%esp)
  104d76:	00 
  104d77:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
  104d7e:	00 
  104d7f:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  104d86:	e8 42 bf ff ff       	call   100ccd <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
  104d8b:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104d90:	8b 00                	mov    (%eax),%eax
  104d92:	89 04 24             	mov    %eax,(%esp)
  104d95:	e8 3e ec ff ff       	call   1039d8 <pa2page>
  104d9a:	89 04 24             	mov    %eax,(%esp)
  104d9d:	e8 17 ed ff ff       	call   103ab9 <page_ref>
  104da2:	83 f8 01             	cmp    $0x1,%eax
  104da5:	74 24                	je     104dcb <check_pgdir+0x663>
  104da7:	c7 44 24 0c 7c 6d 10 	movl   $0x106d7c,0xc(%esp)
  104dae:	00 
  104daf:	c7 44 24 08 d9 6a 10 	movl   $0x106ad9,0x8(%esp)
  104db6:	00 
  104db7:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
  104dbe:	00 
  104dbf:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  104dc6:	e8 02 bf ff ff       	call   100ccd <__panic>
    free_page(pa2page(boot_pgdir[0]));
  104dcb:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104dd0:	8b 00                	mov    (%eax),%eax
  104dd2:	89 04 24             	mov    %eax,(%esp)
  104dd5:	e8 fe eb ff ff       	call   1039d8 <pa2page>
  104dda:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104de1:	00 
  104de2:	89 04 24             	mov    %eax,(%esp)
  104de5:	e8 0c ef ff ff       	call   103cf6 <free_pages>
    boot_pgdir[0] = 0;
  104dea:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104def:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  104df5:	c7 04 24 a2 6d 10 00 	movl   $0x106da2,(%esp)
  104dfc:	e8 3b b5 ff ff       	call   10033c <cprintf>
}
  104e01:	c9                   	leave  
  104e02:	c3                   	ret    

00104e03 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  104e03:	55                   	push   %ebp
  104e04:	89 e5                	mov    %esp,%ebp
  104e06:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104e09:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104e10:	e9 ca 00 00 00       	jmp    104edf <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  104e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104e18:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104e1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e1e:	c1 e8 0c             	shr    $0xc,%eax
  104e21:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104e24:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104e29:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  104e2c:	72 23                	jb     104e51 <check_boot_pgdir+0x4e>
  104e2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e31:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104e35:	c7 44 24 08 ec 69 10 	movl   $0x1069ec,0x8(%esp)
  104e3c:	00 
  104e3d:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
  104e44:	00 
  104e45:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  104e4c:	e8 7c be ff ff       	call   100ccd <__panic>
  104e51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e54:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104e59:	89 c2                	mov    %eax,%edx
  104e5b:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104e60:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104e67:	00 
  104e68:	89 54 24 04          	mov    %edx,0x4(%esp)
  104e6c:	89 04 24             	mov    %eax,(%esp)
  104e6f:	e8 89 f5 ff ff       	call   1043fd <get_pte>
  104e74:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104e77:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  104e7b:	75 24                	jne    104ea1 <check_boot_pgdir+0x9e>
  104e7d:	c7 44 24 0c bc 6d 10 	movl   $0x106dbc,0xc(%esp)
  104e84:	00 
  104e85:	c7 44 24 08 d9 6a 10 	movl   $0x106ad9,0x8(%esp)
  104e8c:	00 
  104e8d:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
  104e94:	00 
  104e95:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  104e9c:	e8 2c be ff ff       	call   100ccd <__panic>
        assert(PTE_ADDR(*ptep) == i);
  104ea1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104ea4:	8b 00                	mov    (%eax),%eax
  104ea6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104eab:	89 c2                	mov    %eax,%edx
  104ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104eb0:	39 c2                	cmp    %eax,%edx
  104eb2:	74 24                	je     104ed8 <check_boot_pgdir+0xd5>
  104eb4:	c7 44 24 0c f9 6d 10 	movl   $0x106df9,0xc(%esp)
  104ebb:	00 
  104ebc:	c7 44 24 08 d9 6a 10 	movl   $0x106ad9,0x8(%esp)
  104ec3:	00 
  104ec4:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
  104ecb:	00 
  104ecc:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  104ed3:	e8 f5 bd ff ff       	call   100ccd <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104ed8:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  104edf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104ee2:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104ee7:	39 c2                	cmp    %eax,%edx
  104ee9:	0f 82 26 ff ff ff    	jb     104e15 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  104eef:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104ef4:	05 ac 0f 00 00       	add    $0xfac,%eax
  104ef9:	8b 00                	mov    (%eax),%eax
  104efb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104f00:	89 c2                	mov    %eax,%edx
  104f02:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104f07:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104f0a:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  104f11:	77 23                	ja     104f36 <check_boot_pgdir+0x133>
  104f13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f16:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104f1a:	c7 44 24 08 90 6a 10 	movl   $0x106a90,0x8(%esp)
  104f21:	00 
  104f22:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
  104f29:	00 
  104f2a:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  104f31:	e8 97 bd ff ff       	call   100ccd <__panic>
  104f36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f39:	05 00 00 00 40       	add    $0x40000000,%eax
  104f3e:	39 c2                	cmp    %eax,%edx
  104f40:	74 24                	je     104f66 <check_boot_pgdir+0x163>
  104f42:	c7 44 24 0c 10 6e 10 	movl   $0x106e10,0xc(%esp)
  104f49:	00 
  104f4a:	c7 44 24 08 d9 6a 10 	movl   $0x106ad9,0x8(%esp)
  104f51:	00 
  104f52:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
  104f59:	00 
  104f5a:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  104f61:	e8 67 bd ff ff       	call   100ccd <__panic>

    assert(boot_pgdir[0] == 0);
  104f66:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104f6b:	8b 00                	mov    (%eax),%eax
  104f6d:	85 c0                	test   %eax,%eax
  104f6f:	74 24                	je     104f95 <check_boot_pgdir+0x192>
  104f71:	c7 44 24 0c 44 6e 10 	movl   $0x106e44,0xc(%esp)
  104f78:	00 
  104f79:	c7 44 24 08 d9 6a 10 	movl   $0x106ad9,0x8(%esp)
  104f80:	00 
  104f81:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
  104f88:	00 
  104f89:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  104f90:	e8 38 bd ff ff       	call   100ccd <__panic>

    struct Page *p;
    p = alloc_page();
  104f95:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104f9c:	e8 1d ed ff ff       	call   103cbe <alloc_pages>
  104fa1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  104fa4:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104fa9:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  104fb0:	00 
  104fb1:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  104fb8:	00 
  104fb9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104fbc:	89 54 24 04          	mov    %edx,0x4(%esp)
  104fc0:	89 04 24             	mov    %eax,(%esp)
  104fc3:	e8 6c f6 ff ff       	call   104634 <page_insert>
  104fc8:	85 c0                	test   %eax,%eax
  104fca:	74 24                	je     104ff0 <check_boot_pgdir+0x1ed>
  104fcc:	c7 44 24 0c 58 6e 10 	movl   $0x106e58,0xc(%esp)
  104fd3:	00 
  104fd4:	c7 44 24 08 d9 6a 10 	movl   $0x106ad9,0x8(%esp)
  104fdb:	00 
  104fdc:	c7 44 24 04 27 02 00 	movl   $0x227,0x4(%esp)
  104fe3:	00 
  104fe4:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  104feb:	e8 dd bc ff ff       	call   100ccd <__panic>
    assert(page_ref(p) == 1);
  104ff0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104ff3:	89 04 24             	mov    %eax,(%esp)
  104ff6:	e8 be ea ff ff       	call   103ab9 <page_ref>
  104ffb:	83 f8 01             	cmp    $0x1,%eax
  104ffe:	74 24                	je     105024 <check_boot_pgdir+0x221>
  105000:	c7 44 24 0c 86 6e 10 	movl   $0x106e86,0xc(%esp)
  105007:	00 
  105008:	c7 44 24 08 d9 6a 10 	movl   $0x106ad9,0x8(%esp)
  10500f:	00 
  105010:	c7 44 24 04 28 02 00 	movl   $0x228,0x4(%esp)
  105017:	00 
  105018:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  10501f:	e8 a9 bc ff ff       	call   100ccd <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  105024:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  105029:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  105030:	00 
  105031:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  105038:	00 
  105039:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10503c:	89 54 24 04          	mov    %edx,0x4(%esp)
  105040:	89 04 24             	mov    %eax,(%esp)
  105043:	e8 ec f5 ff ff       	call   104634 <page_insert>
  105048:	85 c0                	test   %eax,%eax
  10504a:	74 24                	je     105070 <check_boot_pgdir+0x26d>
  10504c:	c7 44 24 0c 98 6e 10 	movl   $0x106e98,0xc(%esp)
  105053:	00 
  105054:	c7 44 24 08 d9 6a 10 	movl   $0x106ad9,0x8(%esp)
  10505b:	00 
  10505c:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
  105063:	00 
  105064:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  10506b:	e8 5d bc ff ff       	call   100ccd <__panic>
    assert(page_ref(p) == 2);
  105070:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105073:	89 04 24             	mov    %eax,(%esp)
  105076:	e8 3e ea ff ff       	call   103ab9 <page_ref>
  10507b:	83 f8 02             	cmp    $0x2,%eax
  10507e:	74 24                	je     1050a4 <check_boot_pgdir+0x2a1>
  105080:	c7 44 24 0c cf 6e 10 	movl   $0x106ecf,0xc(%esp)
  105087:	00 
  105088:	c7 44 24 08 d9 6a 10 	movl   $0x106ad9,0x8(%esp)
  10508f:	00 
  105090:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
  105097:	00 
  105098:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  10509f:	e8 29 bc ff ff       	call   100ccd <__panic>

    const char *str = "ucore: Hello world!!";
  1050a4:	c7 45 dc e0 6e 10 00 	movl   $0x106ee0,-0x24(%ebp)
    strcpy((void *)0x100, str);
  1050ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1050ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  1050b2:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1050b9:	e8 1e 0a 00 00       	call   105adc <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  1050be:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  1050c5:	00 
  1050c6:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1050cd:	e8 83 0a 00 00       	call   105b55 <strcmp>
  1050d2:	85 c0                	test   %eax,%eax
  1050d4:	74 24                	je     1050fa <check_boot_pgdir+0x2f7>
  1050d6:	c7 44 24 0c f8 6e 10 	movl   $0x106ef8,0xc(%esp)
  1050dd:	00 
  1050de:	c7 44 24 08 d9 6a 10 	movl   $0x106ad9,0x8(%esp)
  1050e5:	00 
  1050e6:	c7 44 24 04 2e 02 00 	movl   $0x22e,0x4(%esp)
  1050ed:	00 
  1050ee:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  1050f5:	e8 d3 bb ff ff       	call   100ccd <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  1050fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1050fd:	89 04 24             	mov    %eax,(%esp)
  105100:	e8 22 e9 ff ff       	call   103a27 <page2kva>
  105105:	05 00 01 00 00       	add    $0x100,%eax
  10510a:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  10510d:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  105114:	e8 6b 09 00 00       	call   105a84 <strlen>
  105119:	85 c0                	test   %eax,%eax
  10511b:	74 24                	je     105141 <check_boot_pgdir+0x33e>
  10511d:	c7 44 24 0c 30 6f 10 	movl   $0x106f30,0xc(%esp)
  105124:	00 
  105125:	c7 44 24 08 d9 6a 10 	movl   $0x106ad9,0x8(%esp)
  10512c:	00 
  10512d:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
  105134:	00 
  105135:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  10513c:	e8 8c bb ff ff       	call   100ccd <__panic>

    free_page(p);
  105141:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105148:	00 
  105149:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10514c:	89 04 24             	mov    %eax,(%esp)
  10514f:	e8 a2 eb ff ff       	call   103cf6 <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
  105154:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  105159:	8b 00                	mov    (%eax),%eax
  10515b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  105160:	89 04 24             	mov    %eax,(%esp)
  105163:	e8 70 e8 ff ff       	call   1039d8 <pa2page>
  105168:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10516f:	00 
  105170:	89 04 24             	mov    %eax,(%esp)
  105173:	e8 7e eb ff ff       	call   103cf6 <free_pages>
    boot_pgdir[0] = 0;
  105178:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10517d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  105183:	c7 04 24 54 6f 10 00 	movl   $0x106f54,(%esp)
  10518a:	e8 ad b1 ff ff       	call   10033c <cprintf>
}
  10518f:	c9                   	leave  
  105190:	c3                   	ret    

00105191 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  105191:	55                   	push   %ebp
  105192:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  105194:	8b 45 08             	mov    0x8(%ebp),%eax
  105197:	83 e0 04             	and    $0x4,%eax
  10519a:	85 c0                	test   %eax,%eax
  10519c:	74 07                	je     1051a5 <perm2str+0x14>
  10519e:	b8 75 00 00 00       	mov    $0x75,%eax
  1051a3:	eb 05                	jmp    1051aa <perm2str+0x19>
  1051a5:	b8 2d 00 00 00       	mov    $0x2d,%eax
  1051aa:	a2 48 89 11 00       	mov    %al,0x118948
    str[1] = 'r';
  1051af:	c6 05 49 89 11 00 72 	movb   $0x72,0x118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
  1051b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1051b9:	83 e0 02             	and    $0x2,%eax
  1051bc:	85 c0                	test   %eax,%eax
  1051be:	74 07                	je     1051c7 <perm2str+0x36>
  1051c0:	b8 77 00 00 00       	mov    $0x77,%eax
  1051c5:	eb 05                	jmp    1051cc <perm2str+0x3b>
  1051c7:	b8 2d 00 00 00       	mov    $0x2d,%eax
  1051cc:	a2 4a 89 11 00       	mov    %al,0x11894a
    str[3] = '\0';
  1051d1:	c6 05 4b 89 11 00 00 	movb   $0x0,0x11894b
    return str;
  1051d8:	b8 48 89 11 00       	mov    $0x118948,%eax
}
  1051dd:	5d                   	pop    %ebp
  1051de:	c3                   	ret    

001051df <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  1051df:	55                   	push   %ebp
  1051e0:	89 e5                	mov    %esp,%ebp
  1051e2:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  1051e5:	8b 45 10             	mov    0x10(%ebp),%eax
  1051e8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1051eb:	72 0a                	jb     1051f7 <get_pgtable_items+0x18>
        return 0;
  1051ed:	b8 00 00 00 00       	mov    $0x0,%eax
  1051f2:	e9 9c 00 00 00       	jmp    105293 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
  1051f7:	eb 04                	jmp    1051fd <get_pgtable_items+0x1e>
        start ++;
  1051f9:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
  1051fd:	8b 45 10             	mov    0x10(%ebp),%eax
  105200:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105203:	73 18                	jae    10521d <get_pgtable_items+0x3e>
  105205:	8b 45 10             	mov    0x10(%ebp),%eax
  105208:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10520f:	8b 45 14             	mov    0x14(%ebp),%eax
  105212:	01 d0                	add    %edx,%eax
  105214:	8b 00                	mov    (%eax),%eax
  105216:	83 e0 01             	and    $0x1,%eax
  105219:	85 c0                	test   %eax,%eax
  10521b:	74 dc                	je     1051f9 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
  10521d:	8b 45 10             	mov    0x10(%ebp),%eax
  105220:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105223:	73 69                	jae    10528e <get_pgtable_items+0xaf>
        if (left_store != NULL) {
  105225:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  105229:	74 08                	je     105233 <get_pgtable_items+0x54>
            *left_store = start;
  10522b:	8b 45 18             	mov    0x18(%ebp),%eax
  10522e:	8b 55 10             	mov    0x10(%ebp),%edx
  105231:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  105233:	8b 45 10             	mov    0x10(%ebp),%eax
  105236:	8d 50 01             	lea    0x1(%eax),%edx
  105239:	89 55 10             	mov    %edx,0x10(%ebp)
  10523c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105243:	8b 45 14             	mov    0x14(%ebp),%eax
  105246:	01 d0                	add    %edx,%eax
  105248:	8b 00                	mov    (%eax),%eax
  10524a:	83 e0 07             	and    $0x7,%eax
  10524d:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  105250:	eb 04                	jmp    105256 <get_pgtable_items+0x77>
            start ++;
  105252:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
  105256:	8b 45 10             	mov    0x10(%ebp),%eax
  105259:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10525c:	73 1d                	jae    10527b <get_pgtable_items+0x9c>
  10525e:	8b 45 10             	mov    0x10(%ebp),%eax
  105261:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105268:	8b 45 14             	mov    0x14(%ebp),%eax
  10526b:	01 d0                	add    %edx,%eax
  10526d:	8b 00                	mov    (%eax),%eax
  10526f:	83 e0 07             	and    $0x7,%eax
  105272:	89 c2                	mov    %eax,%edx
  105274:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105277:	39 c2                	cmp    %eax,%edx
  105279:	74 d7                	je     105252 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
  10527b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10527f:	74 08                	je     105289 <get_pgtable_items+0xaa>
            *right_store = start;
  105281:	8b 45 1c             	mov    0x1c(%ebp),%eax
  105284:	8b 55 10             	mov    0x10(%ebp),%edx
  105287:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  105289:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10528c:	eb 05                	jmp    105293 <get_pgtable_items+0xb4>
    }
    return 0;
  10528e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105293:	c9                   	leave  
  105294:	c3                   	ret    

00105295 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  105295:	55                   	push   %ebp
  105296:	89 e5                	mov    %esp,%ebp
  105298:	57                   	push   %edi
  105299:	56                   	push   %esi
  10529a:	53                   	push   %ebx
  10529b:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  10529e:	c7 04 24 74 6f 10 00 	movl   $0x106f74,(%esp)
  1052a5:	e8 92 b0 ff ff       	call   10033c <cprintf>
    size_t left, right = 0, perm;
  1052aa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  1052b1:	e9 fa 00 00 00       	jmp    1053b0 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1052b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1052b9:	89 04 24             	mov    %eax,(%esp)
  1052bc:	e8 d0 fe ff ff       	call   105191 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  1052c1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1052c4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1052c7:	29 d1                	sub    %edx,%ecx
  1052c9:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1052cb:	89 d6                	mov    %edx,%esi
  1052cd:	c1 e6 16             	shl    $0x16,%esi
  1052d0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1052d3:	89 d3                	mov    %edx,%ebx
  1052d5:	c1 e3 16             	shl    $0x16,%ebx
  1052d8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1052db:	89 d1                	mov    %edx,%ecx
  1052dd:	c1 e1 16             	shl    $0x16,%ecx
  1052e0:	8b 7d dc             	mov    -0x24(%ebp),%edi
  1052e3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1052e6:	29 d7                	sub    %edx,%edi
  1052e8:	89 fa                	mov    %edi,%edx
  1052ea:	89 44 24 14          	mov    %eax,0x14(%esp)
  1052ee:	89 74 24 10          	mov    %esi,0x10(%esp)
  1052f2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1052f6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1052fa:	89 54 24 04          	mov    %edx,0x4(%esp)
  1052fe:	c7 04 24 a5 6f 10 00 	movl   $0x106fa5,(%esp)
  105305:	e8 32 b0 ff ff       	call   10033c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
  10530a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10530d:	c1 e0 0a             	shl    $0xa,%eax
  105310:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  105313:	eb 54                	jmp    105369 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  105315:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105318:	89 04 24             	mov    %eax,(%esp)
  10531b:	e8 71 fe ff ff       	call   105191 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  105320:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  105323:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105326:	29 d1                	sub    %edx,%ecx
  105328:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  10532a:	89 d6                	mov    %edx,%esi
  10532c:	c1 e6 0c             	shl    $0xc,%esi
  10532f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105332:	89 d3                	mov    %edx,%ebx
  105334:	c1 e3 0c             	shl    $0xc,%ebx
  105337:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10533a:	c1 e2 0c             	shl    $0xc,%edx
  10533d:	89 d1                	mov    %edx,%ecx
  10533f:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  105342:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105345:	29 d7                	sub    %edx,%edi
  105347:	89 fa                	mov    %edi,%edx
  105349:	89 44 24 14          	mov    %eax,0x14(%esp)
  10534d:	89 74 24 10          	mov    %esi,0x10(%esp)
  105351:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105355:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  105359:	89 54 24 04          	mov    %edx,0x4(%esp)
  10535d:	c7 04 24 c4 6f 10 00 	movl   $0x106fc4,(%esp)
  105364:	e8 d3 af ff ff       	call   10033c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  105369:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
  10536e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  105371:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105374:	89 ce                	mov    %ecx,%esi
  105376:	c1 e6 0a             	shl    $0xa,%esi
  105379:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  10537c:	89 cb                	mov    %ecx,%ebx
  10537e:	c1 e3 0a             	shl    $0xa,%ebx
  105381:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
  105384:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  105388:	8d 4d d8             	lea    -0x28(%ebp),%ecx
  10538b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  10538f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105393:	89 44 24 08          	mov    %eax,0x8(%esp)
  105397:	89 74 24 04          	mov    %esi,0x4(%esp)
  10539b:	89 1c 24             	mov    %ebx,(%esp)
  10539e:	e8 3c fe ff ff       	call   1051df <get_pgtable_items>
  1053a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1053a6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1053aa:	0f 85 65 ff ff ff    	jne    105315 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  1053b0:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
  1053b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1053b8:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  1053bb:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  1053bf:	8d 4d e0             	lea    -0x20(%ebp),%ecx
  1053c2:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  1053c6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1053ca:	89 44 24 08          	mov    %eax,0x8(%esp)
  1053ce:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  1053d5:	00 
  1053d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1053dd:	e8 fd fd ff ff       	call   1051df <get_pgtable_items>
  1053e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1053e5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1053e9:	0f 85 c7 fe ff ff    	jne    1052b6 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
  1053ef:	c7 04 24 e8 6f 10 00 	movl   $0x106fe8,(%esp)
  1053f6:	e8 41 af ff ff       	call   10033c <cprintf>
}
  1053fb:	83 c4 4c             	add    $0x4c,%esp
  1053fe:	5b                   	pop    %ebx
  1053ff:	5e                   	pop    %esi
  105400:	5f                   	pop    %edi
  105401:	5d                   	pop    %ebp
  105402:	c3                   	ret    

00105403 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  105403:	55                   	push   %ebp
  105404:	89 e5                	mov    %esp,%ebp
  105406:	83 ec 58             	sub    $0x58,%esp
  105409:	8b 45 10             	mov    0x10(%ebp),%eax
  10540c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10540f:	8b 45 14             	mov    0x14(%ebp),%eax
  105412:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  105415:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105418:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10541b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10541e:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  105421:	8b 45 18             	mov    0x18(%ebp),%eax
  105424:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105427:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10542a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10542d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105430:	89 55 f0             	mov    %edx,-0x10(%ebp)
  105433:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105436:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105439:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10543d:	74 1c                	je     10545b <printnum+0x58>
  10543f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105442:	ba 00 00 00 00       	mov    $0x0,%edx
  105447:	f7 75 e4             	divl   -0x1c(%ebp)
  10544a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10544d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105450:	ba 00 00 00 00       	mov    $0x0,%edx
  105455:	f7 75 e4             	divl   -0x1c(%ebp)
  105458:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10545b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10545e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105461:	f7 75 e4             	divl   -0x1c(%ebp)
  105464:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105467:	89 55 dc             	mov    %edx,-0x24(%ebp)
  10546a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10546d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105470:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105473:	89 55 ec             	mov    %edx,-0x14(%ebp)
  105476:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105479:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  10547c:	8b 45 18             	mov    0x18(%ebp),%eax
  10547f:	ba 00 00 00 00       	mov    $0x0,%edx
  105484:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  105487:	77 56                	ja     1054df <printnum+0xdc>
  105489:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  10548c:	72 05                	jb     105493 <printnum+0x90>
  10548e:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  105491:	77 4c                	ja     1054df <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  105493:	8b 45 1c             	mov    0x1c(%ebp),%eax
  105496:	8d 50 ff             	lea    -0x1(%eax),%edx
  105499:	8b 45 20             	mov    0x20(%ebp),%eax
  10549c:	89 44 24 18          	mov    %eax,0x18(%esp)
  1054a0:	89 54 24 14          	mov    %edx,0x14(%esp)
  1054a4:	8b 45 18             	mov    0x18(%ebp),%eax
  1054a7:	89 44 24 10          	mov    %eax,0x10(%esp)
  1054ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1054ae:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1054b1:	89 44 24 08          	mov    %eax,0x8(%esp)
  1054b5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1054b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1054bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1054c0:	8b 45 08             	mov    0x8(%ebp),%eax
  1054c3:	89 04 24             	mov    %eax,(%esp)
  1054c6:	e8 38 ff ff ff       	call   105403 <printnum>
  1054cb:	eb 1c                	jmp    1054e9 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  1054cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1054d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1054d4:	8b 45 20             	mov    0x20(%ebp),%eax
  1054d7:	89 04 24             	mov    %eax,(%esp)
  1054da:	8b 45 08             	mov    0x8(%ebp),%eax
  1054dd:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  1054df:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  1054e3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1054e7:	7f e4                	jg     1054cd <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  1054e9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1054ec:	05 9c 70 10 00       	add    $0x10709c,%eax
  1054f1:	0f b6 00             	movzbl (%eax),%eax
  1054f4:	0f be c0             	movsbl %al,%eax
  1054f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  1054fa:	89 54 24 04          	mov    %edx,0x4(%esp)
  1054fe:	89 04 24             	mov    %eax,(%esp)
  105501:	8b 45 08             	mov    0x8(%ebp),%eax
  105504:	ff d0                	call   *%eax
}
  105506:	c9                   	leave  
  105507:	c3                   	ret    

00105508 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  105508:	55                   	push   %ebp
  105509:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  10550b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  10550f:	7e 14                	jle    105525 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  105511:	8b 45 08             	mov    0x8(%ebp),%eax
  105514:	8b 00                	mov    (%eax),%eax
  105516:	8d 48 08             	lea    0x8(%eax),%ecx
  105519:	8b 55 08             	mov    0x8(%ebp),%edx
  10551c:	89 0a                	mov    %ecx,(%edx)
  10551e:	8b 50 04             	mov    0x4(%eax),%edx
  105521:	8b 00                	mov    (%eax),%eax
  105523:	eb 30                	jmp    105555 <getuint+0x4d>
    }
    else if (lflag) {
  105525:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105529:	74 16                	je     105541 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  10552b:	8b 45 08             	mov    0x8(%ebp),%eax
  10552e:	8b 00                	mov    (%eax),%eax
  105530:	8d 48 04             	lea    0x4(%eax),%ecx
  105533:	8b 55 08             	mov    0x8(%ebp),%edx
  105536:	89 0a                	mov    %ecx,(%edx)
  105538:	8b 00                	mov    (%eax),%eax
  10553a:	ba 00 00 00 00       	mov    $0x0,%edx
  10553f:	eb 14                	jmp    105555 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  105541:	8b 45 08             	mov    0x8(%ebp),%eax
  105544:	8b 00                	mov    (%eax),%eax
  105546:	8d 48 04             	lea    0x4(%eax),%ecx
  105549:	8b 55 08             	mov    0x8(%ebp),%edx
  10554c:	89 0a                	mov    %ecx,(%edx)
  10554e:	8b 00                	mov    (%eax),%eax
  105550:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  105555:	5d                   	pop    %ebp
  105556:	c3                   	ret    

00105557 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  105557:	55                   	push   %ebp
  105558:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  10555a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  10555e:	7e 14                	jle    105574 <getint+0x1d>
        return va_arg(*ap, long long);
  105560:	8b 45 08             	mov    0x8(%ebp),%eax
  105563:	8b 00                	mov    (%eax),%eax
  105565:	8d 48 08             	lea    0x8(%eax),%ecx
  105568:	8b 55 08             	mov    0x8(%ebp),%edx
  10556b:	89 0a                	mov    %ecx,(%edx)
  10556d:	8b 50 04             	mov    0x4(%eax),%edx
  105570:	8b 00                	mov    (%eax),%eax
  105572:	eb 28                	jmp    10559c <getint+0x45>
    }
    else if (lflag) {
  105574:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105578:	74 12                	je     10558c <getint+0x35>
        return va_arg(*ap, long);
  10557a:	8b 45 08             	mov    0x8(%ebp),%eax
  10557d:	8b 00                	mov    (%eax),%eax
  10557f:	8d 48 04             	lea    0x4(%eax),%ecx
  105582:	8b 55 08             	mov    0x8(%ebp),%edx
  105585:	89 0a                	mov    %ecx,(%edx)
  105587:	8b 00                	mov    (%eax),%eax
  105589:	99                   	cltd   
  10558a:	eb 10                	jmp    10559c <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  10558c:	8b 45 08             	mov    0x8(%ebp),%eax
  10558f:	8b 00                	mov    (%eax),%eax
  105591:	8d 48 04             	lea    0x4(%eax),%ecx
  105594:	8b 55 08             	mov    0x8(%ebp),%edx
  105597:	89 0a                	mov    %ecx,(%edx)
  105599:	8b 00                	mov    (%eax),%eax
  10559b:	99                   	cltd   
    }
}
  10559c:	5d                   	pop    %ebp
  10559d:	c3                   	ret    

0010559e <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  10559e:	55                   	push   %ebp
  10559f:	89 e5                	mov    %esp,%ebp
  1055a1:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  1055a4:	8d 45 14             	lea    0x14(%ebp),%eax
  1055a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  1055aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1055ad:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1055b1:	8b 45 10             	mov    0x10(%ebp),%eax
  1055b4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1055b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1055bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055bf:	8b 45 08             	mov    0x8(%ebp),%eax
  1055c2:	89 04 24             	mov    %eax,(%esp)
  1055c5:	e8 02 00 00 00       	call   1055cc <vprintfmt>
    va_end(ap);
}
  1055ca:	c9                   	leave  
  1055cb:	c3                   	ret    

001055cc <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  1055cc:	55                   	push   %ebp
  1055cd:	89 e5                	mov    %esp,%ebp
  1055cf:	56                   	push   %esi
  1055d0:	53                   	push   %ebx
  1055d1:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1055d4:	eb 18                	jmp    1055ee <vprintfmt+0x22>
            if (ch == '\0') {
  1055d6:	85 db                	test   %ebx,%ebx
  1055d8:	75 05                	jne    1055df <vprintfmt+0x13>
                return;
  1055da:	e9 d1 03 00 00       	jmp    1059b0 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  1055df:	8b 45 0c             	mov    0xc(%ebp),%eax
  1055e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055e6:	89 1c 24             	mov    %ebx,(%esp)
  1055e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1055ec:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1055ee:	8b 45 10             	mov    0x10(%ebp),%eax
  1055f1:	8d 50 01             	lea    0x1(%eax),%edx
  1055f4:	89 55 10             	mov    %edx,0x10(%ebp)
  1055f7:	0f b6 00             	movzbl (%eax),%eax
  1055fa:	0f b6 d8             	movzbl %al,%ebx
  1055fd:	83 fb 25             	cmp    $0x25,%ebx
  105600:	75 d4                	jne    1055d6 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  105602:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  105606:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  10560d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105610:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  105613:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10561a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10561d:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  105620:	8b 45 10             	mov    0x10(%ebp),%eax
  105623:	8d 50 01             	lea    0x1(%eax),%edx
  105626:	89 55 10             	mov    %edx,0x10(%ebp)
  105629:	0f b6 00             	movzbl (%eax),%eax
  10562c:	0f b6 d8             	movzbl %al,%ebx
  10562f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  105632:	83 f8 55             	cmp    $0x55,%eax
  105635:	0f 87 44 03 00 00    	ja     10597f <vprintfmt+0x3b3>
  10563b:	8b 04 85 c0 70 10 00 	mov    0x1070c0(,%eax,4),%eax
  105642:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  105644:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  105648:	eb d6                	jmp    105620 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  10564a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  10564e:	eb d0                	jmp    105620 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105650:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  105657:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10565a:	89 d0                	mov    %edx,%eax
  10565c:	c1 e0 02             	shl    $0x2,%eax
  10565f:	01 d0                	add    %edx,%eax
  105661:	01 c0                	add    %eax,%eax
  105663:	01 d8                	add    %ebx,%eax
  105665:	83 e8 30             	sub    $0x30,%eax
  105668:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  10566b:	8b 45 10             	mov    0x10(%ebp),%eax
  10566e:	0f b6 00             	movzbl (%eax),%eax
  105671:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  105674:	83 fb 2f             	cmp    $0x2f,%ebx
  105677:	7e 0b                	jle    105684 <vprintfmt+0xb8>
  105679:	83 fb 39             	cmp    $0x39,%ebx
  10567c:	7f 06                	jg     105684 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  10567e:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  105682:	eb d3                	jmp    105657 <vprintfmt+0x8b>
            goto process_precision;
  105684:	eb 33                	jmp    1056b9 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  105686:	8b 45 14             	mov    0x14(%ebp),%eax
  105689:	8d 50 04             	lea    0x4(%eax),%edx
  10568c:	89 55 14             	mov    %edx,0x14(%ebp)
  10568f:	8b 00                	mov    (%eax),%eax
  105691:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  105694:	eb 23                	jmp    1056b9 <vprintfmt+0xed>

        case '.':
            if (width < 0)
  105696:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10569a:	79 0c                	jns    1056a8 <vprintfmt+0xdc>
                width = 0;
  10569c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  1056a3:	e9 78 ff ff ff       	jmp    105620 <vprintfmt+0x54>
  1056a8:	e9 73 ff ff ff       	jmp    105620 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  1056ad:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  1056b4:	e9 67 ff ff ff       	jmp    105620 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  1056b9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1056bd:	79 12                	jns    1056d1 <vprintfmt+0x105>
                width = precision, precision = -1;
  1056bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1056c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1056c5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  1056cc:	e9 4f ff ff ff       	jmp    105620 <vprintfmt+0x54>
  1056d1:	e9 4a ff ff ff       	jmp    105620 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  1056d6:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  1056da:	e9 41 ff ff ff       	jmp    105620 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  1056df:	8b 45 14             	mov    0x14(%ebp),%eax
  1056e2:	8d 50 04             	lea    0x4(%eax),%edx
  1056e5:	89 55 14             	mov    %edx,0x14(%ebp)
  1056e8:	8b 00                	mov    (%eax),%eax
  1056ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  1056ed:	89 54 24 04          	mov    %edx,0x4(%esp)
  1056f1:	89 04 24             	mov    %eax,(%esp)
  1056f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1056f7:	ff d0                	call   *%eax
            break;
  1056f9:	e9 ac 02 00 00       	jmp    1059aa <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  1056fe:	8b 45 14             	mov    0x14(%ebp),%eax
  105701:	8d 50 04             	lea    0x4(%eax),%edx
  105704:	89 55 14             	mov    %edx,0x14(%ebp)
  105707:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  105709:	85 db                	test   %ebx,%ebx
  10570b:	79 02                	jns    10570f <vprintfmt+0x143>
                err = -err;
  10570d:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  10570f:	83 fb 06             	cmp    $0x6,%ebx
  105712:	7f 0b                	jg     10571f <vprintfmt+0x153>
  105714:	8b 34 9d 80 70 10 00 	mov    0x107080(,%ebx,4),%esi
  10571b:	85 f6                	test   %esi,%esi
  10571d:	75 23                	jne    105742 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  10571f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105723:	c7 44 24 08 ad 70 10 	movl   $0x1070ad,0x8(%esp)
  10572a:	00 
  10572b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10572e:	89 44 24 04          	mov    %eax,0x4(%esp)
  105732:	8b 45 08             	mov    0x8(%ebp),%eax
  105735:	89 04 24             	mov    %eax,(%esp)
  105738:	e8 61 fe ff ff       	call   10559e <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  10573d:	e9 68 02 00 00       	jmp    1059aa <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  105742:	89 74 24 0c          	mov    %esi,0xc(%esp)
  105746:	c7 44 24 08 b6 70 10 	movl   $0x1070b6,0x8(%esp)
  10574d:	00 
  10574e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105751:	89 44 24 04          	mov    %eax,0x4(%esp)
  105755:	8b 45 08             	mov    0x8(%ebp),%eax
  105758:	89 04 24             	mov    %eax,(%esp)
  10575b:	e8 3e fe ff ff       	call   10559e <printfmt>
            }
            break;
  105760:	e9 45 02 00 00       	jmp    1059aa <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  105765:	8b 45 14             	mov    0x14(%ebp),%eax
  105768:	8d 50 04             	lea    0x4(%eax),%edx
  10576b:	89 55 14             	mov    %edx,0x14(%ebp)
  10576e:	8b 30                	mov    (%eax),%esi
  105770:	85 f6                	test   %esi,%esi
  105772:	75 05                	jne    105779 <vprintfmt+0x1ad>
                p = "(null)";
  105774:	be b9 70 10 00       	mov    $0x1070b9,%esi
            }
            if (width > 0 && padc != '-') {
  105779:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10577d:	7e 3e                	jle    1057bd <vprintfmt+0x1f1>
  10577f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  105783:	74 38                	je     1057bd <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  105785:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  105788:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10578b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10578f:	89 34 24             	mov    %esi,(%esp)
  105792:	e8 15 03 00 00       	call   105aac <strnlen>
  105797:	29 c3                	sub    %eax,%ebx
  105799:	89 d8                	mov    %ebx,%eax
  10579b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10579e:	eb 17                	jmp    1057b7 <vprintfmt+0x1eb>
                    putch(padc, putdat);
  1057a0:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1057a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  1057a7:	89 54 24 04          	mov    %edx,0x4(%esp)
  1057ab:	89 04 24             	mov    %eax,(%esp)
  1057ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1057b1:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  1057b3:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1057b7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1057bb:	7f e3                	jg     1057a0 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1057bd:	eb 38                	jmp    1057f7 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  1057bf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1057c3:	74 1f                	je     1057e4 <vprintfmt+0x218>
  1057c5:	83 fb 1f             	cmp    $0x1f,%ebx
  1057c8:	7e 05                	jle    1057cf <vprintfmt+0x203>
  1057ca:	83 fb 7e             	cmp    $0x7e,%ebx
  1057cd:	7e 15                	jle    1057e4 <vprintfmt+0x218>
                    putch('?', putdat);
  1057cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057d6:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  1057dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1057e0:	ff d0                	call   *%eax
  1057e2:	eb 0f                	jmp    1057f3 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  1057e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057eb:	89 1c 24             	mov    %ebx,(%esp)
  1057ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1057f1:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1057f3:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1057f7:	89 f0                	mov    %esi,%eax
  1057f9:	8d 70 01             	lea    0x1(%eax),%esi
  1057fc:	0f b6 00             	movzbl (%eax),%eax
  1057ff:	0f be d8             	movsbl %al,%ebx
  105802:	85 db                	test   %ebx,%ebx
  105804:	74 10                	je     105816 <vprintfmt+0x24a>
  105806:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10580a:	78 b3                	js     1057bf <vprintfmt+0x1f3>
  10580c:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  105810:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105814:	79 a9                	jns    1057bf <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  105816:	eb 17                	jmp    10582f <vprintfmt+0x263>
                putch(' ', putdat);
  105818:	8b 45 0c             	mov    0xc(%ebp),%eax
  10581b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10581f:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  105826:	8b 45 08             	mov    0x8(%ebp),%eax
  105829:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  10582b:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10582f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105833:	7f e3                	jg     105818 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  105835:	e9 70 01 00 00       	jmp    1059aa <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  10583a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10583d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105841:	8d 45 14             	lea    0x14(%ebp),%eax
  105844:	89 04 24             	mov    %eax,(%esp)
  105847:	e8 0b fd ff ff       	call   105557 <getint>
  10584c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10584f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  105852:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105855:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105858:	85 d2                	test   %edx,%edx
  10585a:	79 26                	jns    105882 <vprintfmt+0x2b6>
                putch('-', putdat);
  10585c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10585f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105863:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  10586a:	8b 45 08             	mov    0x8(%ebp),%eax
  10586d:	ff d0                	call   *%eax
                num = -(long long)num;
  10586f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105872:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105875:	f7 d8                	neg    %eax
  105877:	83 d2 00             	adc    $0x0,%edx
  10587a:	f7 da                	neg    %edx
  10587c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10587f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  105882:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105889:	e9 a8 00 00 00       	jmp    105936 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  10588e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105891:	89 44 24 04          	mov    %eax,0x4(%esp)
  105895:	8d 45 14             	lea    0x14(%ebp),%eax
  105898:	89 04 24             	mov    %eax,(%esp)
  10589b:	e8 68 fc ff ff       	call   105508 <getuint>
  1058a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1058a3:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  1058a6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1058ad:	e9 84 00 00 00       	jmp    105936 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  1058b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1058b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058b9:	8d 45 14             	lea    0x14(%ebp),%eax
  1058bc:	89 04 24             	mov    %eax,(%esp)
  1058bf:	e8 44 fc ff ff       	call   105508 <getuint>
  1058c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1058c7:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  1058ca:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  1058d1:	eb 63                	jmp    105936 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  1058d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058da:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  1058e1:	8b 45 08             	mov    0x8(%ebp),%eax
  1058e4:	ff d0                	call   *%eax
            putch('x', putdat);
  1058e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058ed:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  1058f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1058f7:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  1058f9:	8b 45 14             	mov    0x14(%ebp),%eax
  1058fc:	8d 50 04             	lea    0x4(%eax),%edx
  1058ff:	89 55 14             	mov    %edx,0x14(%ebp)
  105902:	8b 00                	mov    (%eax),%eax
  105904:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105907:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  10590e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  105915:	eb 1f                	jmp    105936 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  105917:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10591a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10591e:	8d 45 14             	lea    0x14(%ebp),%eax
  105921:	89 04 24             	mov    %eax,(%esp)
  105924:	e8 df fb ff ff       	call   105508 <getuint>
  105929:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10592c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  10592f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  105936:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  10593a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10593d:	89 54 24 18          	mov    %edx,0x18(%esp)
  105941:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105944:	89 54 24 14          	mov    %edx,0x14(%esp)
  105948:	89 44 24 10          	mov    %eax,0x10(%esp)
  10594c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10594f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105952:	89 44 24 08          	mov    %eax,0x8(%esp)
  105956:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10595a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10595d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105961:	8b 45 08             	mov    0x8(%ebp),%eax
  105964:	89 04 24             	mov    %eax,(%esp)
  105967:	e8 97 fa ff ff       	call   105403 <printnum>
            break;
  10596c:	eb 3c                	jmp    1059aa <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  10596e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105971:	89 44 24 04          	mov    %eax,0x4(%esp)
  105975:	89 1c 24             	mov    %ebx,(%esp)
  105978:	8b 45 08             	mov    0x8(%ebp),%eax
  10597b:	ff d0                	call   *%eax
            break;
  10597d:	eb 2b                	jmp    1059aa <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  10597f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105982:	89 44 24 04          	mov    %eax,0x4(%esp)
  105986:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  10598d:	8b 45 08             	mov    0x8(%ebp),%eax
  105990:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  105992:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105996:	eb 04                	jmp    10599c <vprintfmt+0x3d0>
  105998:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  10599c:	8b 45 10             	mov    0x10(%ebp),%eax
  10599f:	83 e8 01             	sub    $0x1,%eax
  1059a2:	0f b6 00             	movzbl (%eax),%eax
  1059a5:	3c 25                	cmp    $0x25,%al
  1059a7:	75 ef                	jne    105998 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  1059a9:	90                   	nop
        }
    }
  1059aa:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1059ab:	e9 3e fc ff ff       	jmp    1055ee <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  1059b0:	83 c4 40             	add    $0x40,%esp
  1059b3:	5b                   	pop    %ebx
  1059b4:	5e                   	pop    %esi
  1059b5:	5d                   	pop    %ebp
  1059b6:	c3                   	ret    

001059b7 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  1059b7:	55                   	push   %ebp
  1059b8:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  1059ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059bd:	8b 40 08             	mov    0x8(%eax),%eax
  1059c0:	8d 50 01             	lea    0x1(%eax),%edx
  1059c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059c6:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  1059c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059cc:	8b 10                	mov    (%eax),%edx
  1059ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059d1:	8b 40 04             	mov    0x4(%eax),%eax
  1059d4:	39 c2                	cmp    %eax,%edx
  1059d6:	73 12                	jae    1059ea <sprintputch+0x33>
        *b->buf ++ = ch;
  1059d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059db:	8b 00                	mov    (%eax),%eax
  1059dd:	8d 48 01             	lea    0x1(%eax),%ecx
  1059e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  1059e3:	89 0a                	mov    %ecx,(%edx)
  1059e5:	8b 55 08             	mov    0x8(%ebp),%edx
  1059e8:	88 10                	mov    %dl,(%eax)
    }
}
  1059ea:	5d                   	pop    %ebp
  1059eb:	c3                   	ret    

001059ec <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  1059ec:	55                   	push   %ebp
  1059ed:	89 e5                	mov    %esp,%ebp
  1059ef:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1059f2:	8d 45 14             	lea    0x14(%ebp),%eax
  1059f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  1059f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1059fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1059ff:	8b 45 10             	mov    0x10(%ebp),%eax
  105a02:	89 44 24 08          	mov    %eax,0x8(%esp)
  105a06:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a09:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  105a10:	89 04 24             	mov    %eax,(%esp)
  105a13:	e8 08 00 00 00       	call   105a20 <vsnprintf>
  105a18:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  105a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105a1e:	c9                   	leave  
  105a1f:	c3                   	ret    

00105a20 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  105a20:	55                   	push   %ebp
  105a21:	89 e5                	mov    %esp,%ebp
  105a23:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  105a26:	8b 45 08             	mov    0x8(%ebp),%eax
  105a29:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105a2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a2f:	8d 50 ff             	lea    -0x1(%eax),%edx
  105a32:	8b 45 08             	mov    0x8(%ebp),%eax
  105a35:	01 d0                	add    %edx,%eax
  105a37:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a3a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  105a41:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105a45:	74 0a                	je     105a51 <vsnprintf+0x31>
  105a47:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105a4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a4d:	39 c2                	cmp    %eax,%edx
  105a4f:	76 07                	jbe    105a58 <vsnprintf+0x38>
        return -E_INVAL;
  105a51:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  105a56:	eb 2a                	jmp    105a82 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  105a58:	8b 45 14             	mov    0x14(%ebp),%eax
  105a5b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105a5f:	8b 45 10             	mov    0x10(%ebp),%eax
  105a62:	89 44 24 08          	mov    %eax,0x8(%esp)
  105a66:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105a69:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a6d:	c7 04 24 b7 59 10 00 	movl   $0x1059b7,(%esp)
  105a74:	e8 53 fb ff ff       	call   1055cc <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  105a79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105a7c:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  105a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105a82:	c9                   	leave  
  105a83:	c3                   	ret    

00105a84 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105a84:	55                   	push   %ebp
  105a85:	89 e5                	mov    %esp,%ebp
  105a87:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105a8a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105a91:	eb 04                	jmp    105a97 <strlen+0x13>
        cnt ++;
  105a93:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  105a97:	8b 45 08             	mov    0x8(%ebp),%eax
  105a9a:	8d 50 01             	lea    0x1(%eax),%edx
  105a9d:	89 55 08             	mov    %edx,0x8(%ebp)
  105aa0:	0f b6 00             	movzbl (%eax),%eax
  105aa3:	84 c0                	test   %al,%al
  105aa5:	75 ec                	jne    105a93 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  105aa7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105aaa:	c9                   	leave  
  105aab:	c3                   	ret    

00105aac <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  105aac:	55                   	push   %ebp
  105aad:	89 e5                	mov    %esp,%ebp
  105aaf:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105ab2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105ab9:	eb 04                	jmp    105abf <strnlen+0x13>
        cnt ++;
  105abb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  105abf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105ac2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105ac5:	73 10                	jae    105ad7 <strnlen+0x2b>
  105ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  105aca:	8d 50 01             	lea    0x1(%eax),%edx
  105acd:	89 55 08             	mov    %edx,0x8(%ebp)
  105ad0:	0f b6 00             	movzbl (%eax),%eax
  105ad3:	84 c0                	test   %al,%al
  105ad5:	75 e4                	jne    105abb <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  105ad7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105ada:	c9                   	leave  
  105adb:	c3                   	ret    

00105adc <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105adc:	55                   	push   %ebp
  105add:	89 e5                	mov    %esp,%ebp
  105adf:	57                   	push   %edi
  105ae0:	56                   	push   %esi
  105ae1:	83 ec 20             	sub    $0x20,%esp
  105ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  105ae7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105aea:	8b 45 0c             	mov    0xc(%ebp),%eax
  105aed:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105af0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105af3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105af6:	89 d1                	mov    %edx,%ecx
  105af8:	89 c2                	mov    %eax,%edx
  105afa:	89 ce                	mov    %ecx,%esi
  105afc:	89 d7                	mov    %edx,%edi
  105afe:	ac                   	lods   %ds:(%esi),%al
  105aff:	aa                   	stos   %al,%es:(%edi)
  105b00:	84 c0                	test   %al,%al
  105b02:	75 fa                	jne    105afe <strcpy+0x22>
  105b04:	89 fa                	mov    %edi,%edx
  105b06:	89 f1                	mov    %esi,%ecx
  105b08:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105b0b:	89 55 e8             	mov    %edx,-0x18(%ebp)
  105b0e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105b14:	83 c4 20             	add    $0x20,%esp
  105b17:	5e                   	pop    %esi
  105b18:	5f                   	pop    %edi
  105b19:	5d                   	pop    %ebp
  105b1a:	c3                   	ret    

00105b1b <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105b1b:	55                   	push   %ebp
  105b1c:	89 e5                	mov    %esp,%ebp
  105b1e:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105b21:	8b 45 08             	mov    0x8(%ebp),%eax
  105b24:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105b27:	eb 21                	jmp    105b4a <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  105b29:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b2c:	0f b6 10             	movzbl (%eax),%edx
  105b2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105b32:	88 10                	mov    %dl,(%eax)
  105b34:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105b37:	0f b6 00             	movzbl (%eax),%eax
  105b3a:	84 c0                	test   %al,%al
  105b3c:	74 04                	je     105b42 <strncpy+0x27>
            src ++;
  105b3e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  105b42:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105b46:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  105b4a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105b4e:	75 d9                	jne    105b29 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  105b50:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105b53:	c9                   	leave  
  105b54:	c3                   	ret    

00105b55 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105b55:	55                   	push   %ebp
  105b56:	89 e5                	mov    %esp,%ebp
  105b58:	57                   	push   %edi
  105b59:	56                   	push   %esi
  105b5a:	83 ec 20             	sub    $0x20,%esp
  105b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  105b60:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105b63:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b66:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  105b69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105b6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b6f:	89 d1                	mov    %edx,%ecx
  105b71:	89 c2                	mov    %eax,%edx
  105b73:	89 ce                	mov    %ecx,%esi
  105b75:	89 d7                	mov    %edx,%edi
  105b77:	ac                   	lods   %ds:(%esi),%al
  105b78:	ae                   	scas   %es:(%edi),%al
  105b79:	75 08                	jne    105b83 <strcmp+0x2e>
  105b7b:	84 c0                	test   %al,%al
  105b7d:	75 f8                	jne    105b77 <strcmp+0x22>
  105b7f:	31 c0                	xor    %eax,%eax
  105b81:	eb 04                	jmp    105b87 <strcmp+0x32>
  105b83:	19 c0                	sbb    %eax,%eax
  105b85:	0c 01                	or     $0x1,%al
  105b87:	89 fa                	mov    %edi,%edx
  105b89:	89 f1                	mov    %esi,%ecx
  105b8b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105b8e:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105b91:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  105b94:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105b97:	83 c4 20             	add    $0x20,%esp
  105b9a:	5e                   	pop    %esi
  105b9b:	5f                   	pop    %edi
  105b9c:	5d                   	pop    %ebp
  105b9d:	c3                   	ret    

00105b9e <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105b9e:	55                   	push   %ebp
  105b9f:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105ba1:	eb 0c                	jmp    105baf <strncmp+0x11>
        n --, s1 ++, s2 ++;
  105ba3:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105ba7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105bab:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105baf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105bb3:	74 1a                	je     105bcf <strncmp+0x31>
  105bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  105bb8:	0f b6 00             	movzbl (%eax),%eax
  105bbb:	84 c0                	test   %al,%al
  105bbd:	74 10                	je     105bcf <strncmp+0x31>
  105bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  105bc2:	0f b6 10             	movzbl (%eax),%edx
  105bc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bc8:	0f b6 00             	movzbl (%eax),%eax
  105bcb:	38 c2                	cmp    %al,%dl
  105bcd:	74 d4                	je     105ba3 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105bcf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105bd3:	74 18                	je     105bed <strncmp+0x4f>
  105bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  105bd8:	0f b6 00             	movzbl (%eax),%eax
  105bdb:	0f b6 d0             	movzbl %al,%edx
  105bde:	8b 45 0c             	mov    0xc(%ebp),%eax
  105be1:	0f b6 00             	movzbl (%eax),%eax
  105be4:	0f b6 c0             	movzbl %al,%eax
  105be7:	29 c2                	sub    %eax,%edx
  105be9:	89 d0                	mov    %edx,%eax
  105beb:	eb 05                	jmp    105bf2 <strncmp+0x54>
  105bed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105bf2:	5d                   	pop    %ebp
  105bf3:	c3                   	ret    

00105bf4 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105bf4:	55                   	push   %ebp
  105bf5:	89 e5                	mov    %esp,%ebp
  105bf7:	83 ec 04             	sub    $0x4,%esp
  105bfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bfd:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105c00:	eb 14                	jmp    105c16 <strchr+0x22>
        if (*s == c) {
  105c02:	8b 45 08             	mov    0x8(%ebp),%eax
  105c05:	0f b6 00             	movzbl (%eax),%eax
  105c08:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105c0b:	75 05                	jne    105c12 <strchr+0x1e>
            return (char *)s;
  105c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  105c10:	eb 13                	jmp    105c25 <strchr+0x31>
        }
        s ++;
  105c12:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  105c16:	8b 45 08             	mov    0x8(%ebp),%eax
  105c19:	0f b6 00             	movzbl (%eax),%eax
  105c1c:	84 c0                	test   %al,%al
  105c1e:	75 e2                	jne    105c02 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  105c20:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105c25:	c9                   	leave  
  105c26:	c3                   	ret    

00105c27 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105c27:	55                   	push   %ebp
  105c28:	89 e5                	mov    %esp,%ebp
  105c2a:	83 ec 04             	sub    $0x4,%esp
  105c2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c30:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105c33:	eb 11                	jmp    105c46 <strfind+0x1f>
        if (*s == c) {
  105c35:	8b 45 08             	mov    0x8(%ebp),%eax
  105c38:	0f b6 00             	movzbl (%eax),%eax
  105c3b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105c3e:	75 02                	jne    105c42 <strfind+0x1b>
            break;
  105c40:	eb 0e                	jmp    105c50 <strfind+0x29>
        }
        s ++;
  105c42:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  105c46:	8b 45 08             	mov    0x8(%ebp),%eax
  105c49:	0f b6 00             	movzbl (%eax),%eax
  105c4c:	84 c0                	test   %al,%al
  105c4e:	75 e5                	jne    105c35 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  105c50:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105c53:	c9                   	leave  
  105c54:	c3                   	ret    

00105c55 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105c55:	55                   	push   %ebp
  105c56:	89 e5                	mov    %esp,%ebp
  105c58:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105c5b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105c62:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105c69:	eb 04                	jmp    105c6f <strtol+0x1a>
        s ++;
  105c6b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  105c72:	0f b6 00             	movzbl (%eax),%eax
  105c75:	3c 20                	cmp    $0x20,%al
  105c77:	74 f2                	je     105c6b <strtol+0x16>
  105c79:	8b 45 08             	mov    0x8(%ebp),%eax
  105c7c:	0f b6 00             	movzbl (%eax),%eax
  105c7f:	3c 09                	cmp    $0x9,%al
  105c81:	74 e8                	je     105c6b <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  105c83:	8b 45 08             	mov    0x8(%ebp),%eax
  105c86:	0f b6 00             	movzbl (%eax),%eax
  105c89:	3c 2b                	cmp    $0x2b,%al
  105c8b:	75 06                	jne    105c93 <strtol+0x3e>
        s ++;
  105c8d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105c91:	eb 15                	jmp    105ca8 <strtol+0x53>
    }
    else if (*s == '-') {
  105c93:	8b 45 08             	mov    0x8(%ebp),%eax
  105c96:	0f b6 00             	movzbl (%eax),%eax
  105c99:	3c 2d                	cmp    $0x2d,%al
  105c9b:	75 0b                	jne    105ca8 <strtol+0x53>
        s ++, neg = 1;
  105c9d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105ca1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105ca8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105cac:	74 06                	je     105cb4 <strtol+0x5f>
  105cae:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105cb2:	75 24                	jne    105cd8 <strtol+0x83>
  105cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  105cb7:	0f b6 00             	movzbl (%eax),%eax
  105cba:	3c 30                	cmp    $0x30,%al
  105cbc:	75 1a                	jne    105cd8 <strtol+0x83>
  105cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  105cc1:	83 c0 01             	add    $0x1,%eax
  105cc4:	0f b6 00             	movzbl (%eax),%eax
  105cc7:	3c 78                	cmp    $0x78,%al
  105cc9:	75 0d                	jne    105cd8 <strtol+0x83>
        s += 2, base = 16;
  105ccb:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105ccf:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105cd6:	eb 2a                	jmp    105d02 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  105cd8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105cdc:	75 17                	jne    105cf5 <strtol+0xa0>
  105cde:	8b 45 08             	mov    0x8(%ebp),%eax
  105ce1:	0f b6 00             	movzbl (%eax),%eax
  105ce4:	3c 30                	cmp    $0x30,%al
  105ce6:	75 0d                	jne    105cf5 <strtol+0xa0>
        s ++, base = 8;
  105ce8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105cec:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105cf3:	eb 0d                	jmp    105d02 <strtol+0xad>
    }
    else if (base == 0) {
  105cf5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105cf9:	75 07                	jne    105d02 <strtol+0xad>
        base = 10;
  105cfb:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105d02:	8b 45 08             	mov    0x8(%ebp),%eax
  105d05:	0f b6 00             	movzbl (%eax),%eax
  105d08:	3c 2f                	cmp    $0x2f,%al
  105d0a:	7e 1b                	jle    105d27 <strtol+0xd2>
  105d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  105d0f:	0f b6 00             	movzbl (%eax),%eax
  105d12:	3c 39                	cmp    $0x39,%al
  105d14:	7f 11                	jg     105d27 <strtol+0xd2>
            dig = *s - '0';
  105d16:	8b 45 08             	mov    0x8(%ebp),%eax
  105d19:	0f b6 00             	movzbl (%eax),%eax
  105d1c:	0f be c0             	movsbl %al,%eax
  105d1f:	83 e8 30             	sub    $0x30,%eax
  105d22:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105d25:	eb 48                	jmp    105d6f <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105d27:	8b 45 08             	mov    0x8(%ebp),%eax
  105d2a:	0f b6 00             	movzbl (%eax),%eax
  105d2d:	3c 60                	cmp    $0x60,%al
  105d2f:	7e 1b                	jle    105d4c <strtol+0xf7>
  105d31:	8b 45 08             	mov    0x8(%ebp),%eax
  105d34:	0f b6 00             	movzbl (%eax),%eax
  105d37:	3c 7a                	cmp    $0x7a,%al
  105d39:	7f 11                	jg     105d4c <strtol+0xf7>
            dig = *s - 'a' + 10;
  105d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  105d3e:	0f b6 00             	movzbl (%eax),%eax
  105d41:	0f be c0             	movsbl %al,%eax
  105d44:	83 e8 57             	sub    $0x57,%eax
  105d47:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105d4a:	eb 23                	jmp    105d6f <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  105d4f:	0f b6 00             	movzbl (%eax),%eax
  105d52:	3c 40                	cmp    $0x40,%al
  105d54:	7e 3d                	jle    105d93 <strtol+0x13e>
  105d56:	8b 45 08             	mov    0x8(%ebp),%eax
  105d59:	0f b6 00             	movzbl (%eax),%eax
  105d5c:	3c 5a                	cmp    $0x5a,%al
  105d5e:	7f 33                	jg     105d93 <strtol+0x13e>
            dig = *s - 'A' + 10;
  105d60:	8b 45 08             	mov    0x8(%ebp),%eax
  105d63:	0f b6 00             	movzbl (%eax),%eax
  105d66:	0f be c0             	movsbl %al,%eax
  105d69:	83 e8 37             	sub    $0x37,%eax
  105d6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105d72:	3b 45 10             	cmp    0x10(%ebp),%eax
  105d75:	7c 02                	jl     105d79 <strtol+0x124>
            break;
  105d77:	eb 1a                	jmp    105d93 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  105d79:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105d7d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105d80:	0f af 45 10          	imul   0x10(%ebp),%eax
  105d84:	89 c2                	mov    %eax,%edx
  105d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105d89:	01 d0                	add    %edx,%eax
  105d8b:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  105d8e:	e9 6f ff ff ff       	jmp    105d02 <strtol+0xad>

    if (endptr) {
  105d93:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105d97:	74 08                	je     105da1 <strtol+0x14c>
        *endptr = (char *) s;
  105d99:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d9c:	8b 55 08             	mov    0x8(%ebp),%edx
  105d9f:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105da1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105da5:	74 07                	je     105dae <strtol+0x159>
  105da7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105daa:	f7 d8                	neg    %eax
  105dac:	eb 03                	jmp    105db1 <strtol+0x15c>
  105dae:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105db1:	c9                   	leave  
  105db2:	c3                   	ret    

00105db3 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105db3:	55                   	push   %ebp
  105db4:	89 e5                	mov    %esp,%ebp
  105db6:	57                   	push   %edi
  105db7:	83 ec 24             	sub    $0x24,%esp
  105dba:	8b 45 0c             	mov    0xc(%ebp),%eax
  105dbd:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105dc0:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  105dc4:	8b 55 08             	mov    0x8(%ebp),%edx
  105dc7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  105dca:	88 45 f7             	mov    %al,-0x9(%ebp)
  105dcd:	8b 45 10             	mov    0x10(%ebp),%eax
  105dd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105dd3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105dd6:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105dda:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105ddd:	89 d7                	mov    %edx,%edi
  105ddf:	f3 aa                	rep stos %al,%es:(%edi)
  105de1:	89 fa                	mov    %edi,%edx
  105de3:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105de6:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105de9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105dec:	83 c4 24             	add    $0x24,%esp
  105def:	5f                   	pop    %edi
  105df0:	5d                   	pop    %ebp
  105df1:	c3                   	ret    

00105df2 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105df2:	55                   	push   %ebp
  105df3:	89 e5                	mov    %esp,%ebp
  105df5:	57                   	push   %edi
  105df6:	56                   	push   %esi
  105df7:	53                   	push   %ebx
  105df8:	83 ec 30             	sub    $0x30,%esp
  105dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  105dfe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105e01:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e04:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105e07:	8b 45 10             	mov    0x10(%ebp),%eax
  105e0a:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  105e0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e10:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105e13:	73 42                	jae    105e57 <memmove+0x65>
  105e15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e18:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105e1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105e1e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105e21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105e24:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105e27:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105e2a:	c1 e8 02             	shr    $0x2,%eax
  105e2d:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105e2f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105e32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105e35:	89 d7                	mov    %edx,%edi
  105e37:	89 c6                	mov    %eax,%esi
  105e39:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105e3b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105e3e:	83 e1 03             	and    $0x3,%ecx
  105e41:	74 02                	je     105e45 <memmove+0x53>
  105e43:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105e45:	89 f0                	mov    %esi,%eax
  105e47:	89 fa                	mov    %edi,%edx
  105e49:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  105e4c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105e4f:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105e52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105e55:	eb 36                	jmp    105e8d <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  105e57:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105e5a:	8d 50 ff             	lea    -0x1(%eax),%edx
  105e5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105e60:	01 c2                	add    %eax,%edx
  105e62:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105e65:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105e68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e6b:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  105e6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105e71:	89 c1                	mov    %eax,%ecx
  105e73:	89 d8                	mov    %ebx,%eax
  105e75:	89 d6                	mov    %edx,%esi
  105e77:	89 c7                	mov    %eax,%edi
  105e79:	fd                   	std    
  105e7a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105e7c:	fc                   	cld    
  105e7d:	89 f8                	mov    %edi,%eax
  105e7f:	89 f2                	mov    %esi,%edx
  105e81:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  105e84:	89 55 c8             	mov    %edx,-0x38(%ebp)
  105e87:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  105e8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  105e8d:	83 c4 30             	add    $0x30,%esp
  105e90:	5b                   	pop    %ebx
  105e91:	5e                   	pop    %esi
  105e92:	5f                   	pop    %edi
  105e93:	5d                   	pop    %ebp
  105e94:	c3                   	ret    

00105e95 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  105e95:	55                   	push   %ebp
  105e96:	89 e5                	mov    %esp,%ebp
  105e98:	57                   	push   %edi
  105e99:	56                   	push   %esi
  105e9a:	83 ec 20             	sub    $0x20,%esp
  105e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  105ea0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105ea3:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ea6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105ea9:	8b 45 10             	mov    0x10(%ebp),%eax
  105eac:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105eaf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105eb2:	c1 e8 02             	shr    $0x2,%eax
  105eb5:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105eb7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105eba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ebd:	89 d7                	mov    %edx,%edi
  105ebf:	89 c6                	mov    %eax,%esi
  105ec1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105ec3:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  105ec6:	83 e1 03             	and    $0x3,%ecx
  105ec9:	74 02                	je     105ecd <memcpy+0x38>
  105ecb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105ecd:	89 f0                	mov    %esi,%eax
  105ecf:	89 fa                	mov    %edi,%edx
  105ed1:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105ed4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  105ed7:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105eda:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  105edd:	83 c4 20             	add    $0x20,%esp
  105ee0:	5e                   	pop    %esi
  105ee1:	5f                   	pop    %edi
  105ee2:	5d                   	pop    %ebp
  105ee3:	c3                   	ret    

00105ee4 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  105ee4:	55                   	push   %ebp
  105ee5:	89 e5                	mov    %esp,%ebp
  105ee7:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  105eea:	8b 45 08             	mov    0x8(%ebp),%eax
  105eed:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  105ef0:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ef3:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  105ef6:	eb 30                	jmp    105f28 <memcmp+0x44>
        if (*s1 != *s2) {
  105ef8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105efb:	0f b6 10             	movzbl (%eax),%edx
  105efe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105f01:	0f b6 00             	movzbl (%eax),%eax
  105f04:	38 c2                	cmp    %al,%dl
  105f06:	74 18                	je     105f20 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  105f08:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105f0b:	0f b6 00             	movzbl (%eax),%eax
  105f0e:	0f b6 d0             	movzbl %al,%edx
  105f11:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105f14:	0f b6 00             	movzbl (%eax),%eax
  105f17:	0f b6 c0             	movzbl %al,%eax
  105f1a:	29 c2                	sub    %eax,%edx
  105f1c:	89 d0                	mov    %edx,%eax
  105f1e:	eb 1a                	jmp    105f3a <memcmp+0x56>
        }
        s1 ++, s2 ++;
  105f20:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105f24:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  105f28:	8b 45 10             	mov    0x10(%ebp),%eax
  105f2b:	8d 50 ff             	lea    -0x1(%eax),%edx
  105f2e:	89 55 10             	mov    %edx,0x10(%ebp)
  105f31:	85 c0                	test   %eax,%eax
  105f33:	75 c3                	jne    105ef8 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  105f35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105f3a:	c9                   	leave  
  105f3b:	c3                   	ret    
