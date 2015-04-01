
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 70 11 00 	lgdtl  0x117018
    movl $KERNEL_DS, %eax
c0100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
c0100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
c0100012:	ea 19 00 10 c0 08 00 	ljmp   $0x8,$0xc0100019

c0100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
c0100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010001e:	bc 00 70 11 c0       	mov    $0xc0117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c0100023:	e8 02 00 00 00       	call   c010002a <kern_init>

c0100028 <spin>:

# should never get here
spin:
    jmp spin
c0100028:	eb fe                	jmp    c0100028 <spin>

c010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c010002a:	55                   	push   %ebp
c010002b:	89 e5                	mov    %esp,%ebp
c010002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100030:	ba 68 89 11 c0       	mov    $0xc0118968,%edx
c0100035:	b8 36 7a 11 c0       	mov    $0xc0117a36,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 36 7a 11 c0 	movl   $0xc0117a36,(%esp)
c0100051:	e8 5d 5d 00 00       	call   c0105db3 <memset>

    cons_init();                // init the console
c0100056:	e8 78 15 00 00       	call   c01015d3 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 40 5f 10 c0 	movl   $0xc0105f40,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 5c 5f 10 c0 	movl   $0xc0105f5c,(%esp)
c0100070:	e8 c7 02 00 00       	call   c010033c <cprintf>

    print_kerninfo();
c0100075:	e8 f6 07 00 00       	call   c0100870 <print_kerninfo>

    grade_backtrace();
c010007a:	e8 86 00 00 00       	call   c0100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 4a 42 00 00       	call   c01042ce <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 b3 16 00 00       	call   c010173c <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 05 18 00 00       	call   c0101893 <idt_init>

    clock_init();               // init clock interrupt
c010008e:	e8 f6 0c 00 00       	call   c0100d89 <clock_init>
    intr_enable();              // enable irq interrupt
c0100093:	e8 12 16 00 00       	call   c01016aa <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c0100098:	eb fe                	jmp    c0100098 <kern_init+0x6e>

c010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c010009a:	55                   	push   %ebp
c010009b:	89 e5                	mov    %esp,%ebp
c010009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000a7:	00 
c01000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000af:	00 
c01000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000b7:	e8 ff 0b 00 00       	call   c0100cbb <mon_backtrace>
}
c01000bc:	c9                   	leave  
c01000bd:	c3                   	ret    

c01000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000be:	55                   	push   %ebp
c01000bf:	89 e5                	mov    %esp,%ebp
c01000c1:	53                   	push   %ebx
c01000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000cb:	8d 55 08             	lea    0x8(%ebp),%edx
c01000ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000dd:	89 04 24             	mov    %eax,(%esp)
c01000e0:	e8 b5 ff ff ff       	call   c010009a <grade_backtrace2>
}
c01000e5:	83 c4 14             	add    $0x14,%esp
c01000e8:	5b                   	pop    %ebx
c01000e9:	5d                   	pop    %ebp
c01000ea:	c3                   	ret    

c01000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000eb:	55                   	push   %ebp
c01000ec:	89 e5                	mov    %esp,%ebp
c01000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c01000f1:	8b 45 10             	mov    0x10(%ebp),%eax
c01000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01000f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01000fb:	89 04 24             	mov    %eax,(%esp)
c01000fe:	e8 bb ff ff ff       	call   c01000be <grade_backtrace1>
}
c0100103:	c9                   	leave  
c0100104:	c3                   	ret    

c0100105 <grade_backtrace>:

void
grade_backtrace(void) {
c0100105:	55                   	push   %ebp
c0100106:	89 e5                	mov    %esp,%ebp
c0100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010010b:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c0100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100117:	ff 
c0100118:	89 44 24 04          	mov    %eax,0x4(%esp)
c010011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100123:	e8 c3 ff ff ff       	call   c01000eb <grade_backtrace0>
}
c0100128:	c9                   	leave  
c0100129:	c3                   	ret    

c010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010012a:	55                   	push   %ebp
c010012b:	89 e5                	mov    %esp,%ebp
c010012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c010013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100140:	0f b7 c0             	movzwl %ax,%eax
c0100143:	83 e0 03             	and    $0x3,%eax
c0100146:	89 c2                	mov    %eax,%edx
c0100148:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010014d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100151:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100155:	c7 04 24 61 5f 10 c0 	movl   $0xc0105f61,(%esp)
c010015c:	e8 db 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100165:	0f b7 d0             	movzwl %ax,%edx
c0100168:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010016d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100171:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100175:	c7 04 24 6f 5f 10 c0 	movl   $0xc0105f6f,(%esp)
c010017c:	e8 bb 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100185:	0f b7 d0             	movzwl %ax,%edx
c0100188:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010018d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100191:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100195:	c7 04 24 7d 5f 10 c0 	movl   $0xc0105f7d,(%esp)
c010019c:	e8 9b 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001a5:	0f b7 d0             	movzwl %ax,%edx
c01001a8:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b5:	c7 04 24 8b 5f 10 c0 	movl   $0xc0105f8b,(%esp)
c01001bc:	e8 7b 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001c5:	0f b7 d0             	movzwl %ax,%edx
c01001c8:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d5:	c7 04 24 99 5f 10 c0 	movl   $0xc0105f99,(%esp)
c01001dc:	e8 5b 01 00 00       	call   c010033c <cprintf>
    round ++;
c01001e1:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001e6:	83 c0 01             	add    $0x1,%eax
c01001e9:	a3 40 7a 11 c0       	mov    %eax,0xc0117a40
}
c01001ee:	c9                   	leave  
c01001ef:	c3                   	ret    

c01001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001f0:	55                   	push   %ebp
c01001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c01001f3:	5d                   	pop    %ebp
c01001f4:	c3                   	ret    

c01001f5 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001f5:	55                   	push   %ebp
c01001f6:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c01001f8:	5d                   	pop    %ebp
c01001f9:	c3                   	ret    

c01001fa <lab1_switch_test>:

static void
lab1_switch_test(void) {
c01001fa:	55                   	push   %ebp
c01001fb:	89 e5                	mov    %esp,%ebp
c01001fd:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100200:	e8 25 ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100205:	c7 04 24 a8 5f 10 c0 	movl   $0xc0105fa8,(%esp)
c010020c:	e8 2b 01 00 00       	call   c010033c <cprintf>
    lab1_switch_to_user();
c0100211:	e8 da ff ff ff       	call   c01001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
c0100216:	e8 0f ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010021b:	c7 04 24 c8 5f 10 c0 	movl   $0xc0105fc8,(%esp)
c0100222:	e8 15 01 00 00       	call   c010033c <cprintf>
    lab1_switch_to_kernel();
c0100227:	e8 c9 ff ff ff       	call   c01001f5 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010022c:	e8 f9 fe ff ff       	call   c010012a <lab1_print_cur_status>
}
c0100231:	c9                   	leave  
c0100232:	c3                   	ret    

c0100233 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100233:	55                   	push   %ebp
c0100234:	89 e5                	mov    %esp,%ebp
c0100236:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100239:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010023d:	74 13                	je     c0100252 <readline+0x1f>
        cprintf("%s", prompt);
c010023f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100242:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100246:	c7 04 24 e7 5f 10 c0 	movl   $0xc0105fe7,(%esp)
c010024d:	e8 ea 00 00 00       	call   c010033c <cprintf>
    }
    int i = 0, c;
c0100252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100259:	e8 66 01 00 00       	call   c01003c4 <getchar>
c010025e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100261:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100265:	79 07                	jns    c010026e <readline+0x3b>
            return NULL;
c0100267:	b8 00 00 00 00       	mov    $0x0,%eax
c010026c:	eb 79                	jmp    c01002e7 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010026e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100272:	7e 28                	jle    c010029c <readline+0x69>
c0100274:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010027b:	7f 1f                	jg     c010029c <readline+0x69>
            cputchar(c);
c010027d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100280:	89 04 24             	mov    %eax,(%esp)
c0100283:	e8 da 00 00 00       	call   c0100362 <cputchar>
            buf[i ++] = c;
c0100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010028b:	8d 50 01             	lea    0x1(%eax),%edx
c010028e:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100291:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100294:	88 90 60 7a 11 c0    	mov    %dl,-0x3fee85a0(%eax)
c010029a:	eb 46                	jmp    c01002e2 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c010029c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002a0:	75 17                	jne    c01002b9 <readline+0x86>
c01002a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002a6:	7e 11                	jle    c01002b9 <readline+0x86>
            cputchar(c);
c01002a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002ab:	89 04 24             	mov    %eax,(%esp)
c01002ae:	e8 af 00 00 00       	call   c0100362 <cputchar>
            i --;
c01002b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002b7:	eb 29                	jmp    c01002e2 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002b9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002bd:	74 06                	je     c01002c5 <readline+0x92>
c01002bf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002c3:	75 1d                	jne    c01002e2 <readline+0xaf>
            cputchar(c);
c01002c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002c8:	89 04 24             	mov    %eax,(%esp)
c01002cb:	e8 92 00 00 00       	call   c0100362 <cputchar>
            buf[i] = '\0';
c01002d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002d3:	05 60 7a 11 c0       	add    $0xc0117a60,%eax
c01002d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002db:	b8 60 7a 11 c0       	mov    $0xc0117a60,%eax
c01002e0:	eb 05                	jmp    c01002e7 <readline+0xb4>
        }
    }
c01002e2:	e9 72 ff ff ff       	jmp    c0100259 <readline+0x26>
}
c01002e7:	c9                   	leave  
c01002e8:	c3                   	ret    

c01002e9 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002e9:	55                   	push   %ebp
c01002ea:	89 e5                	mov    %esp,%ebp
c01002ec:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01002f2:	89 04 24             	mov    %eax,(%esp)
c01002f5:	e8 05 13 00 00       	call   c01015ff <cons_putc>
    (*cnt) ++;
c01002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01002fd:	8b 00                	mov    (%eax),%eax
c01002ff:	8d 50 01             	lea    0x1(%eax),%edx
c0100302:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100305:	89 10                	mov    %edx,(%eax)
}
c0100307:	c9                   	leave  
c0100308:	c3                   	ret    

c0100309 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100309:	55                   	push   %ebp
c010030a:	89 e5                	mov    %esp,%ebp
c010030c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010030f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100316:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100319:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010031d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100320:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100324:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100327:	89 44 24 04          	mov    %eax,0x4(%esp)
c010032b:	c7 04 24 e9 02 10 c0 	movl   $0xc01002e9,(%esp)
c0100332:	e8 95 52 00 00       	call   c01055cc <vprintfmt>
    return cnt;
c0100337:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010033a:	c9                   	leave  
c010033b:	c3                   	ret    

c010033c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c010033c:	55                   	push   %ebp
c010033d:	89 e5                	mov    %esp,%ebp
c010033f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100342:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100345:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100348:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010034b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010034f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100352:	89 04 24             	mov    %eax,(%esp)
c0100355:	e8 af ff ff ff       	call   c0100309 <vcprintf>
c010035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010035d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100360:	c9                   	leave  
c0100361:	c3                   	ret    

c0100362 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100362:	55                   	push   %ebp
c0100363:	89 e5                	mov    %esp,%ebp
c0100365:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100368:	8b 45 08             	mov    0x8(%ebp),%eax
c010036b:	89 04 24             	mov    %eax,(%esp)
c010036e:	e8 8c 12 00 00       	call   c01015ff <cons_putc>
}
c0100373:	c9                   	leave  
c0100374:	c3                   	ret    

c0100375 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100375:	55                   	push   %ebp
c0100376:	89 e5                	mov    %esp,%ebp
c0100378:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010037b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c0100382:	eb 13                	jmp    c0100397 <cputs+0x22>
        cputch(c, &cnt);
c0100384:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100388:	8d 55 f0             	lea    -0x10(%ebp),%edx
c010038b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010038f:	89 04 24             	mov    %eax,(%esp)
c0100392:	e8 52 ff ff ff       	call   c01002e9 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c0100397:	8b 45 08             	mov    0x8(%ebp),%eax
c010039a:	8d 50 01             	lea    0x1(%eax),%edx
c010039d:	89 55 08             	mov    %edx,0x8(%ebp)
c01003a0:	0f b6 00             	movzbl (%eax),%eax
c01003a3:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003a6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003aa:	75 d8                	jne    c0100384 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003af:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003b3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003ba:	e8 2a ff ff ff       	call   c01002e9 <cputch>
    return cnt;
c01003bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003c2:	c9                   	leave  
c01003c3:	c3                   	ret    

c01003c4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003c4:	55                   	push   %ebp
c01003c5:	89 e5                	mov    %esp,%ebp
c01003c7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003ca:	e8 6c 12 00 00       	call   c010163b <cons_getc>
c01003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003d6:	74 f2                	je     c01003ca <getchar+0x6>
        /* do nothing */;
    return c;
c01003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003db:	c9                   	leave  
c01003dc:	c3                   	ret    

c01003dd <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003dd:	55                   	push   %ebp
c01003de:	89 e5                	mov    %esp,%ebp
c01003e0:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003e6:	8b 00                	mov    (%eax),%eax
c01003e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01003eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01003ee:	8b 00                	mov    (%eax),%eax
c01003f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01003f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01003fa:	e9 d2 00 00 00       	jmp    c01004d1 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c01003ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100402:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100405:	01 d0                	add    %edx,%eax
c0100407:	89 c2                	mov    %eax,%edx
c0100409:	c1 ea 1f             	shr    $0x1f,%edx
c010040c:	01 d0                	add    %edx,%eax
c010040e:	d1 f8                	sar    %eax
c0100410:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100413:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100416:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100419:	eb 04                	jmp    c010041f <stab_binsearch+0x42>
            m --;
c010041b:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010041f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100422:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100425:	7c 1f                	jl     c0100446 <stab_binsearch+0x69>
c0100427:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010042a:	89 d0                	mov    %edx,%eax
c010042c:	01 c0                	add    %eax,%eax
c010042e:	01 d0                	add    %edx,%eax
c0100430:	c1 e0 02             	shl    $0x2,%eax
c0100433:	89 c2                	mov    %eax,%edx
c0100435:	8b 45 08             	mov    0x8(%ebp),%eax
c0100438:	01 d0                	add    %edx,%eax
c010043a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010043e:	0f b6 c0             	movzbl %al,%eax
c0100441:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100444:	75 d5                	jne    c010041b <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100446:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100449:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010044c:	7d 0b                	jge    c0100459 <stab_binsearch+0x7c>
            l = true_m + 1;
c010044e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100451:	83 c0 01             	add    $0x1,%eax
c0100454:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100457:	eb 78                	jmp    c01004d1 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100459:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100460:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100463:	89 d0                	mov    %edx,%eax
c0100465:	01 c0                	add    %eax,%eax
c0100467:	01 d0                	add    %edx,%eax
c0100469:	c1 e0 02             	shl    $0x2,%eax
c010046c:	89 c2                	mov    %eax,%edx
c010046e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100471:	01 d0                	add    %edx,%eax
c0100473:	8b 40 08             	mov    0x8(%eax),%eax
c0100476:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100479:	73 13                	jae    c010048e <stab_binsearch+0xb1>
            *region_left = m;
c010047b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010047e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100481:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100483:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100486:	83 c0 01             	add    $0x1,%eax
c0100489:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010048c:	eb 43                	jmp    c01004d1 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c010048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100491:	89 d0                	mov    %edx,%eax
c0100493:	01 c0                	add    %eax,%eax
c0100495:	01 d0                	add    %edx,%eax
c0100497:	c1 e0 02             	shl    $0x2,%eax
c010049a:	89 c2                	mov    %eax,%edx
c010049c:	8b 45 08             	mov    0x8(%ebp),%eax
c010049f:	01 d0                	add    %edx,%eax
c01004a1:	8b 40 08             	mov    0x8(%eax),%eax
c01004a4:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004a7:	76 16                	jbe    c01004bf <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ac:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004af:	8b 45 10             	mov    0x10(%ebp),%eax
c01004b2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004b7:	83 e8 01             	sub    $0x1,%eax
c01004ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004bd:	eb 12                	jmp    c01004d1 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004c5:	89 10                	mov    %edx,(%eax)
            l = m;
c01004c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004cd:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004d7:	0f 8e 22 ff ff ff    	jle    c01003ff <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004e1:	75 0f                	jne    c01004f2 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004e6:	8b 00                	mov    (%eax),%eax
c01004e8:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01004ee:	89 10                	mov    %edx,(%eax)
c01004f0:	eb 3f                	jmp    c0100531 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01004f2:	8b 45 10             	mov    0x10(%ebp),%eax
c01004f5:	8b 00                	mov    (%eax),%eax
c01004f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01004fa:	eb 04                	jmp    c0100500 <stab_binsearch+0x123>
c01004fc:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c0100500:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100503:	8b 00                	mov    (%eax),%eax
c0100505:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100508:	7d 1f                	jge    c0100529 <stab_binsearch+0x14c>
c010050a:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010050d:	89 d0                	mov    %edx,%eax
c010050f:	01 c0                	add    %eax,%eax
c0100511:	01 d0                	add    %edx,%eax
c0100513:	c1 e0 02             	shl    $0x2,%eax
c0100516:	89 c2                	mov    %eax,%edx
c0100518:	8b 45 08             	mov    0x8(%ebp),%eax
c010051b:	01 d0                	add    %edx,%eax
c010051d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100521:	0f b6 c0             	movzbl %al,%eax
c0100524:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100527:	75 d3                	jne    c01004fc <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100529:	8b 45 0c             	mov    0xc(%ebp),%eax
c010052c:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010052f:	89 10                	mov    %edx,(%eax)
    }
}
c0100531:	c9                   	leave  
c0100532:	c3                   	ret    

c0100533 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100533:	55                   	push   %ebp
c0100534:	89 e5                	mov    %esp,%ebp
c0100536:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100539:	8b 45 0c             	mov    0xc(%ebp),%eax
c010053c:	c7 00 ec 5f 10 c0    	movl   $0xc0105fec,(%eax)
    info->eip_line = 0;
c0100542:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010054c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010054f:	c7 40 08 ec 5f 10 c0 	movl   $0xc0105fec,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100556:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100559:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100560:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100563:	8b 55 08             	mov    0x8(%ebp),%edx
c0100566:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100569:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100573:	c7 45 f4 18 72 10 c0 	movl   $0xc0107218,-0xc(%ebp)
    stab_end = __STAB_END__;
c010057a:	c7 45 f0 cc 1d 11 c0 	movl   $0xc0111dcc,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100581:	c7 45 ec cd 1d 11 c0 	movl   $0xc0111dcd,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100588:	c7 45 e8 12 48 11 c0 	movl   $0xc0114812,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010058f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100592:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0100595:	76 0d                	jbe    c01005a4 <debuginfo_eip+0x71>
c0100597:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010059a:	83 e8 01             	sub    $0x1,%eax
c010059d:	0f b6 00             	movzbl (%eax),%eax
c01005a0:	84 c0                	test   %al,%al
c01005a2:	74 0a                	je     c01005ae <debuginfo_eip+0x7b>
        return -1;
c01005a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005a9:	e9 c0 02 00 00       	jmp    c010086e <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005bb:	29 c2                	sub    %eax,%edx
c01005bd:	89 d0                	mov    %edx,%eax
c01005bf:	c1 f8 02             	sar    $0x2,%eax
c01005c2:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005c8:	83 e8 01             	sub    $0x1,%eax
c01005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01005d1:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005d5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005dc:	00 
c01005dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005e0:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005e7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005ee:	89 04 24             	mov    %eax,(%esp)
c01005f1:	e8 e7 fd ff ff       	call   c01003dd <stab_binsearch>
    if (lfile == 0)
c01005f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01005f9:	85 c0                	test   %eax,%eax
c01005fb:	75 0a                	jne    c0100607 <debuginfo_eip+0xd4>
        return -1;
c01005fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100602:	e9 67 02 00 00       	jmp    c010086e <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010060a:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100610:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100613:	8b 45 08             	mov    0x8(%ebp),%eax
c0100616:	89 44 24 10          	mov    %eax,0x10(%esp)
c010061a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100621:	00 
c0100622:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100625:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100629:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010062c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100630:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100633:	89 04 24             	mov    %eax,(%esp)
c0100636:	e8 a2 fd ff ff       	call   c01003dd <stab_binsearch>

    if (lfun <= rfun) {
c010063b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010063e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100641:	39 c2                	cmp    %eax,%edx
c0100643:	7f 7c                	jg     c01006c1 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100645:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100648:	89 c2                	mov    %eax,%edx
c010064a:	89 d0                	mov    %edx,%eax
c010064c:	01 c0                	add    %eax,%eax
c010064e:	01 d0                	add    %edx,%eax
c0100650:	c1 e0 02             	shl    $0x2,%eax
c0100653:	89 c2                	mov    %eax,%edx
c0100655:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100658:	01 d0                	add    %edx,%eax
c010065a:	8b 10                	mov    (%eax),%edx
c010065c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010065f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100662:	29 c1                	sub    %eax,%ecx
c0100664:	89 c8                	mov    %ecx,%eax
c0100666:	39 c2                	cmp    %eax,%edx
c0100668:	73 22                	jae    c010068c <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010066a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010066d:	89 c2                	mov    %eax,%edx
c010066f:	89 d0                	mov    %edx,%eax
c0100671:	01 c0                	add    %eax,%eax
c0100673:	01 d0                	add    %edx,%eax
c0100675:	c1 e0 02             	shl    $0x2,%eax
c0100678:	89 c2                	mov    %eax,%edx
c010067a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010067d:	01 d0                	add    %edx,%eax
c010067f:	8b 10                	mov    (%eax),%edx
c0100681:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100684:	01 c2                	add    %eax,%edx
c0100686:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100689:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010068c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010068f:	89 c2                	mov    %eax,%edx
c0100691:	89 d0                	mov    %edx,%eax
c0100693:	01 c0                	add    %eax,%eax
c0100695:	01 d0                	add    %edx,%eax
c0100697:	c1 e0 02             	shl    $0x2,%eax
c010069a:	89 c2                	mov    %eax,%edx
c010069c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010069f:	01 d0                	add    %edx,%eax
c01006a1:	8b 50 08             	mov    0x8(%eax),%edx
c01006a4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006a7:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006ad:	8b 40 10             	mov    0x10(%eax),%eax
c01006b0:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006bf:	eb 15                	jmp    c01006d6 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006c4:	8b 55 08             	mov    0x8(%ebp),%edx
c01006c7:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006d9:	8b 40 08             	mov    0x8(%eax),%eax
c01006dc:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006e3:	00 
c01006e4:	89 04 24             	mov    %eax,(%esp)
c01006e7:	e8 3b 55 00 00       	call   c0105c27 <strfind>
c01006ec:	89 c2                	mov    %eax,%edx
c01006ee:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f1:	8b 40 08             	mov    0x8(%eax),%eax
c01006f4:	29 c2                	sub    %eax,%edx
c01006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f9:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01006fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01006ff:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100703:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c010070a:	00 
c010070b:	8d 45 d0             	lea    -0x30(%ebp),%eax
c010070e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100712:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100715:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100719:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010071c:	89 04 24             	mov    %eax,(%esp)
c010071f:	e8 b9 fc ff ff       	call   c01003dd <stab_binsearch>
    if (lline <= rline) {
c0100724:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100727:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010072a:	39 c2                	cmp    %eax,%edx
c010072c:	7f 24                	jg     c0100752 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c010072e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100731:	89 c2                	mov    %eax,%edx
c0100733:	89 d0                	mov    %edx,%eax
c0100735:	01 c0                	add    %eax,%eax
c0100737:	01 d0                	add    %edx,%eax
c0100739:	c1 e0 02             	shl    $0x2,%eax
c010073c:	89 c2                	mov    %eax,%edx
c010073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100741:	01 d0                	add    %edx,%eax
c0100743:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100747:	0f b7 d0             	movzwl %ax,%edx
c010074a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010074d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100750:	eb 13                	jmp    c0100765 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100752:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100757:	e9 12 01 00 00       	jmp    c010086e <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010075c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010075f:	83 e8 01             	sub    $0x1,%eax
c0100762:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100765:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010076b:	39 c2                	cmp    %eax,%edx
c010076d:	7c 56                	jl     c01007c5 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c010076f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100772:	89 c2                	mov    %eax,%edx
c0100774:	89 d0                	mov    %edx,%eax
c0100776:	01 c0                	add    %eax,%eax
c0100778:	01 d0                	add    %edx,%eax
c010077a:	c1 e0 02             	shl    $0x2,%eax
c010077d:	89 c2                	mov    %eax,%edx
c010077f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100782:	01 d0                	add    %edx,%eax
c0100784:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100788:	3c 84                	cmp    $0x84,%al
c010078a:	74 39                	je     c01007c5 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010078c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010078f:	89 c2                	mov    %eax,%edx
c0100791:	89 d0                	mov    %edx,%eax
c0100793:	01 c0                	add    %eax,%eax
c0100795:	01 d0                	add    %edx,%eax
c0100797:	c1 e0 02             	shl    $0x2,%eax
c010079a:	89 c2                	mov    %eax,%edx
c010079c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010079f:	01 d0                	add    %edx,%eax
c01007a1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007a5:	3c 64                	cmp    $0x64,%al
c01007a7:	75 b3                	jne    c010075c <debuginfo_eip+0x229>
c01007a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007ac:	89 c2                	mov    %eax,%edx
c01007ae:	89 d0                	mov    %edx,%eax
c01007b0:	01 c0                	add    %eax,%eax
c01007b2:	01 d0                	add    %edx,%eax
c01007b4:	c1 e0 02             	shl    $0x2,%eax
c01007b7:	89 c2                	mov    %eax,%edx
c01007b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007bc:	01 d0                	add    %edx,%eax
c01007be:	8b 40 08             	mov    0x8(%eax),%eax
c01007c1:	85 c0                	test   %eax,%eax
c01007c3:	74 97                	je     c010075c <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007cb:	39 c2                	cmp    %eax,%edx
c01007cd:	7c 46                	jl     c0100815 <debuginfo_eip+0x2e2>
c01007cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007d2:	89 c2                	mov    %eax,%edx
c01007d4:	89 d0                	mov    %edx,%eax
c01007d6:	01 c0                	add    %eax,%eax
c01007d8:	01 d0                	add    %edx,%eax
c01007da:	c1 e0 02             	shl    $0x2,%eax
c01007dd:	89 c2                	mov    %eax,%edx
c01007df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007e2:	01 d0                	add    %edx,%eax
c01007e4:	8b 10                	mov    (%eax),%edx
c01007e6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01007e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007ec:	29 c1                	sub    %eax,%ecx
c01007ee:	89 c8                	mov    %ecx,%eax
c01007f0:	39 c2                	cmp    %eax,%edx
c01007f2:	73 21                	jae    c0100815 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01007f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007f7:	89 c2                	mov    %eax,%edx
c01007f9:	89 d0                	mov    %edx,%eax
c01007fb:	01 c0                	add    %eax,%eax
c01007fd:	01 d0                	add    %edx,%eax
c01007ff:	c1 e0 02             	shl    $0x2,%eax
c0100802:	89 c2                	mov    %eax,%edx
c0100804:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100807:	01 d0                	add    %edx,%eax
c0100809:	8b 10                	mov    (%eax),%edx
c010080b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010080e:	01 c2                	add    %eax,%edx
c0100810:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100813:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100815:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100818:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010081b:	39 c2                	cmp    %eax,%edx
c010081d:	7d 4a                	jge    c0100869 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c010081f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100822:	83 c0 01             	add    $0x1,%eax
c0100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100828:	eb 18                	jmp    c0100842 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c010082a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010082d:	8b 40 14             	mov    0x14(%eax),%eax
c0100830:	8d 50 01             	lea    0x1(%eax),%edx
c0100833:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100836:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100839:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010083c:	83 c0 01             	add    $0x1,%eax
c010083f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100842:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100845:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100848:	39 c2                	cmp    %eax,%edx
c010084a:	7d 1d                	jge    c0100869 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010084c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010084f:	89 c2                	mov    %eax,%edx
c0100851:	89 d0                	mov    %edx,%eax
c0100853:	01 c0                	add    %eax,%eax
c0100855:	01 d0                	add    %edx,%eax
c0100857:	c1 e0 02             	shl    $0x2,%eax
c010085a:	89 c2                	mov    %eax,%edx
c010085c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010085f:	01 d0                	add    %edx,%eax
c0100861:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100865:	3c a0                	cmp    $0xa0,%al
c0100867:	74 c1                	je     c010082a <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100869:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010086e:	c9                   	leave  
c010086f:	c3                   	ret    

c0100870 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100870:	55                   	push   %ebp
c0100871:	89 e5                	mov    %esp,%ebp
c0100873:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100876:	c7 04 24 f6 5f 10 c0 	movl   $0xc0105ff6,(%esp)
c010087d:	e8 ba fa ff ff       	call   c010033c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100882:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c0100889:	c0 
c010088a:	c7 04 24 0f 60 10 c0 	movl   $0xc010600f,(%esp)
c0100891:	e8 a6 fa ff ff       	call   c010033c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c0100896:	c7 44 24 04 3c 5f 10 	movl   $0xc0105f3c,0x4(%esp)
c010089d:	c0 
c010089e:	c7 04 24 27 60 10 c0 	movl   $0xc0106027,(%esp)
c01008a5:	e8 92 fa ff ff       	call   c010033c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008aa:	c7 44 24 04 36 7a 11 	movl   $0xc0117a36,0x4(%esp)
c01008b1:	c0 
c01008b2:	c7 04 24 3f 60 10 c0 	movl   $0xc010603f,(%esp)
c01008b9:	e8 7e fa ff ff       	call   c010033c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008be:	c7 44 24 04 68 89 11 	movl   $0xc0118968,0x4(%esp)
c01008c5:	c0 
c01008c6:	c7 04 24 57 60 10 c0 	movl   $0xc0106057,(%esp)
c01008cd:	e8 6a fa ff ff       	call   c010033c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008d2:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c01008d7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008dd:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01008e2:	29 c2                	sub    %eax,%edx
c01008e4:	89 d0                	mov    %edx,%eax
c01008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008ec:	85 c0                	test   %eax,%eax
c01008ee:	0f 48 c2             	cmovs  %edx,%eax
c01008f1:	c1 f8 0a             	sar    $0xa,%eax
c01008f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01008f8:	c7 04 24 70 60 10 c0 	movl   $0xc0106070,(%esp)
c01008ff:	e8 38 fa ff ff       	call   c010033c <cprintf>
}
c0100904:	c9                   	leave  
c0100905:	c3                   	ret    

c0100906 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100906:	55                   	push   %ebp
c0100907:	89 e5                	mov    %esp,%ebp
c0100909:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c010090f:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100912:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100916:	8b 45 08             	mov    0x8(%ebp),%eax
c0100919:	89 04 24             	mov    %eax,(%esp)
c010091c:	e8 12 fc ff ff       	call   c0100533 <debuginfo_eip>
c0100921:	85 c0                	test   %eax,%eax
c0100923:	74 15                	je     c010093a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100925:	8b 45 08             	mov    0x8(%ebp),%eax
c0100928:	89 44 24 04          	mov    %eax,0x4(%esp)
c010092c:	c7 04 24 9a 60 10 c0 	movl   $0xc010609a,(%esp)
c0100933:	e8 04 fa ff ff       	call   c010033c <cprintf>
c0100938:	eb 6d                	jmp    c01009a7 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100941:	eb 1c                	jmp    c010095f <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c0100943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100946:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100949:	01 d0                	add    %edx,%eax
c010094b:	0f b6 00             	movzbl (%eax),%eax
c010094e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100954:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100957:	01 ca                	add    %ecx,%edx
c0100959:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010095b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010095f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100962:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100965:	7f dc                	jg     c0100943 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100967:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c010096d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100970:	01 d0                	add    %edx,%eax
c0100972:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100975:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100978:	8b 55 08             	mov    0x8(%ebp),%edx
c010097b:	89 d1                	mov    %edx,%ecx
c010097d:	29 c1                	sub    %eax,%ecx
c010097f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100982:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100985:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100989:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010098f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100993:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100997:	89 44 24 04          	mov    %eax,0x4(%esp)
c010099b:	c7 04 24 b6 60 10 c0 	movl   $0xc01060b6,(%esp)
c01009a2:	e8 95 f9 ff ff       	call   c010033c <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009a7:	c9                   	leave  
c01009a8:	c3                   	ret    

c01009a9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009a9:	55                   	push   %ebp
c01009aa:	89 e5                	mov    %esp,%ebp
c01009ac:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009af:	8b 45 04             	mov    0x4(%ebp),%eax
c01009b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009b8:	c9                   	leave  
c01009b9:	c3                   	ret    

c01009ba <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009ba:	55                   	push   %ebp
c01009bb:	89 e5                	mov    %esp,%ebp
c01009bd:	83 ec 28             	sub    $0x28,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009c0:	89 e8                	mov    %ebp,%eax
c01009c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return ebp;
c01009c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t current_ebp = read_ebp();
c01009c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t current_eip = read_eip();
c01009cb:	e8 d9 ff ff ff       	call   c01009a9 <read_eip>
c01009d0:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while(current_ebp != 0)
c01009d3:	e9 9b 00 00 00       	jmp    c0100a73 <print_stackframe+0xb9>
	{
		cprintf("ebp:0x%08x ", current_ebp);
c01009d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009db:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009df:	c7 04 24 c8 60 10 c0 	movl   $0xc01060c8,(%esp)
c01009e6:	e8 51 f9 ff ff       	call   c010033c <cprintf>
		cprintf("eip:0x%08x ", current_eip);
c01009eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009ee:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009f2:	c7 04 24 d4 60 10 c0 	movl   $0xc01060d4,(%esp)
c01009f9:	e8 3e f9 ff ff       	call   c010033c <cprintf>

		cprintf("args:");
c01009fe:	c7 04 24 e0 60 10 c0 	movl   $0xc01060e0,(%esp)
c0100a05:	e8 32 f9 ff ff       	call   c010033c <cprintf>
		int i = 0;
c0100a0a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(i = 0; i < 4; i ++)
c0100a11:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0100a18:	eb 26                	jmp    c0100a40 <print_stackframe+0x86>
			cprintf("0x%08x ", (uint32_t)(*(uint32_t*)(current_ebp + 8 + 4*i)));
c0100a1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100a1d:	c1 e0 02             	shl    $0x2,%eax
c0100a20:	89 c2                	mov    %eax,%edx
c0100a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a25:	01 d0                	add    %edx,%eax
c0100a27:	83 c0 08             	add    $0x8,%eax
c0100a2a:	8b 00                	mov    (%eax),%eax
c0100a2c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a30:	c7 04 24 e6 60 10 c0 	movl   $0xc01060e6,(%esp)
c0100a37:	e8 00 f9 ff ff       	call   c010033c <cprintf>
		cprintf("ebp:0x%08x ", current_ebp);
		cprintf("eip:0x%08x ", current_eip);

		cprintf("args:");
		int i = 0;
		for(i = 0; i < 4; i ++)
c0100a3c:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a40:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0100a44:	7e d4                	jle    c0100a1a <print_stackframe+0x60>
			cprintf("0x%08x ", (uint32_t)(*(uint32_t*)(current_ebp + 8 + 4*i)));
		cprintf("\n");
c0100a46:	c7 04 24 ee 60 10 c0 	movl   $0xc01060ee,(%esp)
c0100a4d:	e8 ea f8 ff ff       	call   c010033c <cprintf>

		print_debuginfo(current_eip - sizeof(uint32_t));
c0100a52:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a55:	83 e8 04             	sub    $0x4,%eax
c0100a58:	89 04 24             	mov    %eax,(%esp)
c0100a5b:	e8 a6 fe ff ff       	call   c0100906 <print_debuginfo>

		current_eip = (uint32_t)(*(uint32_t*)(current_ebp + 4));
c0100a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a63:	83 c0 04             	add    $0x4,%eax
c0100a66:	8b 00                	mov    (%eax),%eax
c0100a68:	89 45 f0             	mov    %eax,-0x10(%ebp)
		current_ebp = (uint32_t)(*(uint32_t*)current_ebp);
c0100a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a6e:	8b 00                	mov    (%eax),%eax
c0100a70:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t current_ebp = read_ebp();
	uint32_t current_eip = read_eip();

	while(current_ebp != 0)
c0100a73:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a77:	0f 85 5b ff ff ff    	jne    c01009d8 <print_stackframe+0x1e>

		current_eip = (uint32_t)(*(uint32_t*)(current_ebp + 4));
		current_ebp = (uint32_t)(*(uint32_t*)current_ebp);
	}

	return;
c0100a7d:	90                   	nop
}
c0100a7e:	c9                   	leave  
c0100a7f:	c3                   	ret    

c0100a80 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a80:	55                   	push   %ebp
c0100a81:	89 e5                	mov    %esp,%ebp
c0100a83:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a86:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a8d:	eb 0c                	jmp    c0100a9b <parse+0x1b>
            *buf ++ = '\0';
c0100a8f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a92:	8d 50 01             	lea    0x1(%eax),%edx
c0100a95:	89 55 08             	mov    %edx,0x8(%ebp)
c0100a98:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a9b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a9e:	0f b6 00             	movzbl (%eax),%eax
c0100aa1:	84 c0                	test   %al,%al
c0100aa3:	74 1d                	je     c0100ac2 <parse+0x42>
c0100aa5:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa8:	0f b6 00             	movzbl (%eax),%eax
c0100aab:	0f be c0             	movsbl %al,%eax
c0100aae:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ab2:	c7 04 24 70 61 10 c0 	movl   $0xc0106170,(%esp)
c0100ab9:	e8 36 51 00 00       	call   c0105bf4 <strchr>
c0100abe:	85 c0                	test   %eax,%eax
c0100ac0:	75 cd                	jne    c0100a8f <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100ac2:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ac5:	0f b6 00             	movzbl (%eax),%eax
c0100ac8:	84 c0                	test   %al,%al
c0100aca:	75 02                	jne    c0100ace <parse+0x4e>
            break;
c0100acc:	eb 67                	jmp    c0100b35 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100ace:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100ad2:	75 14                	jne    c0100ae8 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100ad4:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100adb:	00 
c0100adc:	c7 04 24 75 61 10 c0 	movl   $0xc0106175,(%esp)
c0100ae3:	e8 54 f8 ff ff       	call   c010033c <cprintf>
        }
        argv[argc ++] = buf;
c0100ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100aeb:	8d 50 01             	lea    0x1(%eax),%edx
c0100aee:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100af1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100af8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100afb:	01 c2                	add    %eax,%edx
c0100afd:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b00:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b02:	eb 04                	jmp    c0100b08 <parse+0x88>
            buf ++;
c0100b04:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b08:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b0b:	0f b6 00             	movzbl (%eax),%eax
c0100b0e:	84 c0                	test   %al,%al
c0100b10:	74 1d                	je     c0100b2f <parse+0xaf>
c0100b12:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b15:	0f b6 00             	movzbl (%eax),%eax
c0100b18:	0f be c0             	movsbl %al,%eax
c0100b1b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b1f:	c7 04 24 70 61 10 c0 	movl   $0xc0106170,(%esp)
c0100b26:	e8 c9 50 00 00       	call   c0105bf4 <strchr>
c0100b2b:	85 c0                	test   %eax,%eax
c0100b2d:	74 d5                	je     c0100b04 <parse+0x84>
            buf ++;
        }
    }
c0100b2f:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b30:	e9 66 ff ff ff       	jmp    c0100a9b <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b38:	c9                   	leave  
c0100b39:	c3                   	ret    

c0100b3a <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b3a:	55                   	push   %ebp
c0100b3b:	89 e5                	mov    %esp,%ebp
c0100b3d:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b40:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b43:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b47:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b4a:	89 04 24             	mov    %eax,(%esp)
c0100b4d:	e8 2e ff ff ff       	call   c0100a80 <parse>
c0100b52:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b55:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b59:	75 0a                	jne    c0100b65 <runcmd+0x2b>
        return 0;
c0100b5b:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b60:	e9 85 00 00 00       	jmp    c0100bea <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b65:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b6c:	eb 5c                	jmp    c0100bca <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b6e:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b71:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b74:	89 d0                	mov    %edx,%eax
c0100b76:	01 c0                	add    %eax,%eax
c0100b78:	01 d0                	add    %edx,%eax
c0100b7a:	c1 e0 02             	shl    $0x2,%eax
c0100b7d:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100b82:	8b 00                	mov    (%eax),%eax
c0100b84:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b88:	89 04 24             	mov    %eax,(%esp)
c0100b8b:	e8 c5 4f 00 00       	call   c0105b55 <strcmp>
c0100b90:	85 c0                	test   %eax,%eax
c0100b92:	75 32                	jne    c0100bc6 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100b94:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b97:	89 d0                	mov    %edx,%eax
c0100b99:	01 c0                	add    %eax,%eax
c0100b9b:	01 d0                	add    %edx,%eax
c0100b9d:	c1 e0 02             	shl    $0x2,%eax
c0100ba0:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100ba5:	8b 40 08             	mov    0x8(%eax),%eax
c0100ba8:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100bab:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100bae:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100bb1:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100bb5:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100bb8:	83 c2 04             	add    $0x4,%edx
c0100bbb:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100bbf:	89 0c 24             	mov    %ecx,(%esp)
c0100bc2:	ff d0                	call   *%eax
c0100bc4:	eb 24                	jmp    c0100bea <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bc6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bcd:	83 f8 02             	cmp    $0x2,%eax
c0100bd0:	76 9c                	jbe    c0100b6e <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100bd2:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100bd5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bd9:	c7 04 24 93 61 10 c0 	movl   $0xc0106193,(%esp)
c0100be0:	e8 57 f7 ff ff       	call   c010033c <cprintf>
    return 0;
c0100be5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bea:	c9                   	leave  
c0100beb:	c3                   	ret    

c0100bec <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100bec:	55                   	push   %ebp
c0100bed:	89 e5                	mov    %esp,%ebp
c0100bef:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100bf2:	c7 04 24 ac 61 10 c0 	movl   $0xc01061ac,(%esp)
c0100bf9:	e8 3e f7 ff ff       	call   c010033c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100bfe:	c7 04 24 d4 61 10 c0 	movl   $0xc01061d4,(%esp)
c0100c05:	e8 32 f7 ff ff       	call   c010033c <cprintf>

    if (tf != NULL) {
c0100c0a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c0e:	74 0b                	je     c0100c1b <kmonitor+0x2f>
        print_trapframe(tf);
c0100c10:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c13:	89 04 24             	mov    %eax,(%esp)
c0100c16:	e8 89 0e 00 00       	call   c0101aa4 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c1b:	c7 04 24 f9 61 10 c0 	movl   $0xc01061f9,(%esp)
c0100c22:	e8 0c f6 ff ff       	call   c0100233 <readline>
c0100c27:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c2a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c2e:	74 18                	je     c0100c48 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100c30:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c33:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c3a:	89 04 24             	mov    %eax,(%esp)
c0100c3d:	e8 f8 fe ff ff       	call   c0100b3a <runcmd>
c0100c42:	85 c0                	test   %eax,%eax
c0100c44:	79 02                	jns    c0100c48 <kmonitor+0x5c>
                break;
c0100c46:	eb 02                	jmp    c0100c4a <kmonitor+0x5e>
            }
        }
    }
c0100c48:	eb d1                	jmp    c0100c1b <kmonitor+0x2f>
}
c0100c4a:	c9                   	leave  
c0100c4b:	c3                   	ret    

c0100c4c <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c4c:	55                   	push   %ebp
c0100c4d:	89 e5                	mov    %esp,%ebp
c0100c4f:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c52:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c59:	eb 3f                	jmp    c0100c9a <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c5e:	89 d0                	mov    %edx,%eax
c0100c60:	01 c0                	add    %eax,%eax
c0100c62:	01 d0                	add    %edx,%eax
c0100c64:	c1 e0 02             	shl    $0x2,%eax
c0100c67:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c6c:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c72:	89 d0                	mov    %edx,%eax
c0100c74:	01 c0                	add    %eax,%eax
c0100c76:	01 d0                	add    %edx,%eax
c0100c78:	c1 e0 02             	shl    $0x2,%eax
c0100c7b:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c80:	8b 00                	mov    (%eax),%eax
c0100c82:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c86:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c8a:	c7 04 24 fd 61 10 c0 	movl   $0xc01061fd,(%esp)
c0100c91:	e8 a6 f6 ff ff       	call   c010033c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c96:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c9d:	83 f8 02             	cmp    $0x2,%eax
c0100ca0:	76 b9                	jbe    c0100c5b <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100ca2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ca7:	c9                   	leave  
c0100ca8:	c3                   	ret    

c0100ca9 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100ca9:	55                   	push   %ebp
c0100caa:	89 e5                	mov    %esp,%ebp
c0100cac:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100caf:	e8 bc fb ff ff       	call   c0100870 <print_kerninfo>
    return 0;
c0100cb4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cb9:	c9                   	leave  
c0100cba:	c3                   	ret    

c0100cbb <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100cbb:	55                   	push   %ebp
c0100cbc:	89 e5                	mov    %esp,%ebp
c0100cbe:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cc1:	e8 f4 fc ff ff       	call   c01009ba <print_stackframe>
    return 0;
c0100cc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ccb:	c9                   	leave  
c0100ccc:	c3                   	ret    

c0100ccd <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100ccd:	55                   	push   %ebp
c0100cce:	89 e5                	mov    %esp,%ebp
c0100cd0:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100cd3:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
c0100cd8:	85 c0                	test   %eax,%eax
c0100cda:	74 02                	je     c0100cde <__panic+0x11>
        goto panic_dead;
c0100cdc:	eb 48                	jmp    c0100d26 <__panic+0x59>
    }
    is_panic = 1;
c0100cde:	c7 05 60 7e 11 c0 01 	movl   $0x1,0xc0117e60
c0100ce5:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100ce8:	8d 45 14             	lea    0x14(%ebp),%eax
c0100ceb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100cee:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100cf1:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100cf5:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cf8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cfc:	c7 04 24 06 62 10 c0 	movl   $0xc0106206,(%esp)
c0100d03:	e8 34 f6 ff ff       	call   c010033c <cprintf>
    vcprintf(fmt, ap);
c0100d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d0b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d0f:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d12:	89 04 24             	mov    %eax,(%esp)
c0100d15:	e8 ef f5 ff ff       	call   c0100309 <vcprintf>
    cprintf("\n");
c0100d1a:	c7 04 24 22 62 10 c0 	movl   $0xc0106222,(%esp)
c0100d21:	e8 16 f6 ff ff       	call   c010033c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100d26:	e8 85 09 00 00       	call   c01016b0 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d2b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d32:	e8 b5 fe ff ff       	call   c0100bec <kmonitor>
    }
c0100d37:	eb f2                	jmp    c0100d2b <__panic+0x5e>

c0100d39 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d39:	55                   	push   %ebp
c0100d3a:	89 e5                	mov    %esp,%ebp
c0100d3c:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d3f:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d42:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d45:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d48:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d4c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d4f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d53:	c7 04 24 24 62 10 c0 	movl   $0xc0106224,(%esp)
c0100d5a:	e8 dd f5 ff ff       	call   c010033c <cprintf>
    vcprintf(fmt, ap);
c0100d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d62:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d66:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d69:	89 04 24             	mov    %eax,(%esp)
c0100d6c:	e8 98 f5 ff ff       	call   c0100309 <vcprintf>
    cprintf("\n");
c0100d71:	c7 04 24 22 62 10 c0 	movl   $0xc0106222,(%esp)
c0100d78:	e8 bf f5 ff ff       	call   c010033c <cprintf>
    va_end(ap);
}
c0100d7d:	c9                   	leave  
c0100d7e:	c3                   	ret    

c0100d7f <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d7f:	55                   	push   %ebp
c0100d80:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d82:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
}
c0100d87:	5d                   	pop    %ebp
c0100d88:	c3                   	ret    

c0100d89 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d89:	55                   	push   %ebp
c0100d8a:	89 e5                	mov    %esp,%ebp
c0100d8c:	83 ec 28             	sub    $0x28,%esp
c0100d8f:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100d95:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d99:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100d9d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100da1:	ee                   	out    %al,(%dx)
c0100da2:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100da8:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100dac:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100db0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100db4:	ee                   	out    %al,(%dx)
c0100db5:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100dbb:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100dbf:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dc3:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dc7:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dc8:	c7 05 4c 89 11 c0 00 	movl   $0x0,0xc011894c
c0100dcf:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100dd2:	c7 04 24 42 62 10 c0 	movl   $0xc0106242,(%esp)
c0100dd9:	e8 5e f5 ff ff       	call   c010033c <cprintf>
    pic_enable(IRQ_TIMER);
c0100dde:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100de5:	e8 24 09 00 00       	call   c010170e <pic_enable>
}
c0100dea:	c9                   	leave  
c0100deb:	c3                   	ret    

c0100dec <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100dec:	55                   	push   %ebp
c0100ded:	89 e5                	mov    %esp,%ebp
c0100def:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100df2:	9c                   	pushf  
c0100df3:	58                   	pop    %eax
c0100df4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100dfa:	25 00 02 00 00       	and    $0x200,%eax
c0100dff:	85 c0                	test   %eax,%eax
c0100e01:	74 0c                	je     c0100e0f <__intr_save+0x23>
        intr_disable();
c0100e03:	e8 a8 08 00 00       	call   c01016b0 <intr_disable>
        return 1;
c0100e08:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e0d:	eb 05                	jmp    c0100e14 <__intr_save+0x28>
    }
    return 0;
c0100e0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e14:	c9                   	leave  
c0100e15:	c3                   	ret    

c0100e16 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e16:	55                   	push   %ebp
c0100e17:	89 e5                	mov    %esp,%ebp
c0100e19:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e1c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e20:	74 05                	je     c0100e27 <__intr_restore+0x11>
        intr_enable();
c0100e22:	e8 83 08 00 00       	call   c01016aa <intr_enable>
    }
}
c0100e27:	c9                   	leave  
c0100e28:	c3                   	ret    

c0100e29 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e29:	55                   	push   %ebp
c0100e2a:	89 e5                	mov    %esp,%ebp
c0100e2c:	83 ec 10             	sub    $0x10,%esp
c0100e2f:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e35:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e39:	89 c2                	mov    %eax,%edx
c0100e3b:	ec                   	in     (%dx),%al
c0100e3c:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e3f:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e45:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e49:	89 c2                	mov    %eax,%edx
c0100e4b:	ec                   	in     (%dx),%al
c0100e4c:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e4f:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e55:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e59:	89 c2                	mov    %eax,%edx
c0100e5b:	ec                   	in     (%dx),%al
c0100e5c:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e5f:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e65:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e69:	89 c2                	mov    %eax,%edx
c0100e6b:	ec                   	in     (%dx),%al
c0100e6c:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e6f:	c9                   	leave  
c0100e70:	c3                   	ret    

c0100e71 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e71:	55                   	push   %ebp
c0100e72:	89 e5                	mov    %esp,%ebp
c0100e74:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e77:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e81:	0f b7 00             	movzwl (%eax),%eax
c0100e84:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e88:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e8b:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e90:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e93:	0f b7 00             	movzwl (%eax),%eax
c0100e96:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100e9a:	74 12                	je     c0100eae <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100e9c:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100ea3:	66 c7 05 86 7e 11 c0 	movw   $0x3b4,0xc0117e86
c0100eaa:	b4 03 
c0100eac:	eb 13                	jmp    c0100ec1 <cga_init+0x50>
    } else {
        *cp = was;
c0100eae:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100eb1:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100eb5:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100eb8:	66 c7 05 86 7e 11 c0 	movw   $0x3d4,0xc0117e86
c0100ebf:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ec1:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100ec8:	0f b7 c0             	movzwl %ax,%eax
c0100ecb:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100ecf:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ed3:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100ed7:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100edb:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100edc:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100ee3:	83 c0 01             	add    $0x1,%eax
c0100ee6:	0f b7 c0             	movzwl %ax,%eax
c0100ee9:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100eed:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100ef1:	89 c2                	mov    %eax,%edx
c0100ef3:	ec                   	in     (%dx),%al
c0100ef4:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100ef7:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100efb:	0f b6 c0             	movzbl %al,%eax
c0100efe:	c1 e0 08             	shl    $0x8,%eax
c0100f01:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f04:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100f0b:	0f b7 c0             	movzwl %ax,%eax
c0100f0e:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100f12:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f16:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f1a:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f1e:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f1f:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100f26:	83 c0 01             	add    $0x1,%eax
c0100f29:	0f b7 c0             	movzwl %ax,%eax
c0100f2c:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f30:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f34:	89 c2                	mov    %eax,%edx
c0100f36:	ec                   	in     (%dx),%al
c0100f37:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f3a:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f3e:	0f b6 c0             	movzbl %al,%eax
c0100f41:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f44:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f47:	a3 80 7e 11 c0       	mov    %eax,0xc0117e80
    crt_pos = pos;
c0100f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f4f:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
}
c0100f55:	c9                   	leave  
c0100f56:	c3                   	ret    

c0100f57 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f57:	55                   	push   %ebp
c0100f58:	89 e5                	mov    %esp,%ebp
c0100f5a:	83 ec 48             	sub    $0x48,%esp
c0100f5d:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f63:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f67:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f6b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f6f:	ee                   	out    %al,(%dx)
c0100f70:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f76:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f7a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f7e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f82:	ee                   	out    %al,(%dx)
c0100f83:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100f89:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100f8d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f91:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f95:	ee                   	out    %al,(%dx)
c0100f96:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100f9c:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100fa0:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fa4:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fa8:	ee                   	out    %al,(%dx)
c0100fa9:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100faf:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fb3:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fb7:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fbb:	ee                   	out    %al,(%dx)
c0100fbc:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fc2:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100fc6:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fca:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fce:	ee                   	out    %al,(%dx)
c0100fcf:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fd5:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100fd9:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fdd:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100fe1:	ee                   	out    %al,(%dx)
c0100fe2:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fe8:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0100fec:	89 c2                	mov    %eax,%edx
c0100fee:	ec                   	in     (%dx),%al
c0100fef:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0100ff2:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100ff6:	3c ff                	cmp    $0xff,%al
c0100ff8:	0f 95 c0             	setne  %al
c0100ffb:	0f b6 c0             	movzbl %al,%eax
c0100ffe:	a3 88 7e 11 c0       	mov    %eax,0xc0117e88
c0101003:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101009:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c010100d:	89 c2                	mov    %eax,%edx
c010100f:	ec                   	in     (%dx),%al
c0101010:	88 45 d5             	mov    %al,-0x2b(%ebp)
c0101013:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c0101019:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c010101d:	89 c2                	mov    %eax,%edx
c010101f:	ec                   	in     (%dx),%al
c0101020:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101023:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c0101028:	85 c0                	test   %eax,%eax
c010102a:	74 0c                	je     c0101038 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c010102c:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0101033:	e8 d6 06 00 00       	call   c010170e <pic_enable>
    }
}
c0101038:	c9                   	leave  
c0101039:	c3                   	ret    

c010103a <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c010103a:	55                   	push   %ebp
c010103b:	89 e5                	mov    %esp,%ebp
c010103d:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101040:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101047:	eb 09                	jmp    c0101052 <lpt_putc_sub+0x18>
        delay();
c0101049:	e8 db fd ff ff       	call   c0100e29 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010104e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101052:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0101058:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010105c:	89 c2                	mov    %eax,%edx
c010105e:	ec                   	in     (%dx),%al
c010105f:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101062:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101066:	84 c0                	test   %al,%al
c0101068:	78 09                	js     c0101073 <lpt_putc_sub+0x39>
c010106a:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101071:	7e d6                	jle    c0101049 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c0101073:	8b 45 08             	mov    0x8(%ebp),%eax
c0101076:	0f b6 c0             	movzbl %al,%eax
c0101079:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c010107f:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101082:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101086:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010108a:	ee                   	out    %al,(%dx)
c010108b:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c0101091:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c0101095:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101099:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010109d:	ee                   	out    %al,(%dx)
c010109e:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01010a4:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01010a8:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010ac:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010b0:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010b1:	c9                   	leave  
c01010b2:	c3                   	ret    

c01010b3 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010b3:	55                   	push   %ebp
c01010b4:	89 e5                	mov    %esp,%ebp
c01010b6:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010b9:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010bd:	74 0d                	je     c01010cc <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01010c2:	89 04 24             	mov    %eax,(%esp)
c01010c5:	e8 70 ff ff ff       	call   c010103a <lpt_putc_sub>
c01010ca:	eb 24                	jmp    c01010f0 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010cc:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010d3:	e8 62 ff ff ff       	call   c010103a <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010df:	e8 56 ff ff ff       	call   c010103a <lpt_putc_sub>
        lpt_putc_sub('\b');
c01010e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010eb:	e8 4a ff ff ff       	call   c010103a <lpt_putc_sub>
    }
}
c01010f0:	c9                   	leave  
c01010f1:	c3                   	ret    

c01010f2 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01010f2:	55                   	push   %ebp
c01010f3:	89 e5                	mov    %esp,%ebp
c01010f5:	53                   	push   %ebx
c01010f6:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c01010f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01010fc:	b0 00                	mov    $0x0,%al
c01010fe:	85 c0                	test   %eax,%eax
c0101100:	75 07                	jne    c0101109 <cga_putc+0x17>
        c |= 0x0700;
c0101102:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101109:	8b 45 08             	mov    0x8(%ebp),%eax
c010110c:	0f b6 c0             	movzbl %al,%eax
c010110f:	83 f8 0a             	cmp    $0xa,%eax
c0101112:	74 4c                	je     c0101160 <cga_putc+0x6e>
c0101114:	83 f8 0d             	cmp    $0xd,%eax
c0101117:	74 57                	je     c0101170 <cga_putc+0x7e>
c0101119:	83 f8 08             	cmp    $0x8,%eax
c010111c:	0f 85 88 00 00 00    	jne    c01011aa <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c0101122:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101129:	66 85 c0             	test   %ax,%ax
c010112c:	74 30                	je     c010115e <cga_putc+0x6c>
            crt_pos --;
c010112e:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101135:	83 e8 01             	sub    $0x1,%eax
c0101138:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c010113e:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c0101143:	0f b7 15 84 7e 11 c0 	movzwl 0xc0117e84,%edx
c010114a:	0f b7 d2             	movzwl %dx,%edx
c010114d:	01 d2                	add    %edx,%edx
c010114f:	01 c2                	add    %eax,%edx
c0101151:	8b 45 08             	mov    0x8(%ebp),%eax
c0101154:	b0 00                	mov    $0x0,%al
c0101156:	83 c8 20             	or     $0x20,%eax
c0101159:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c010115c:	eb 72                	jmp    c01011d0 <cga_putc+0xde>
c010115e:	eb 70                	jmp    c01011d0 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c0101160:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101167:	83 c0 50             	add    $0x50,%eax
c010116a:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101170:	0f b7 1d 84 7e 11 c0 	movzwl 0xc0117e84,%ebx
c0101177:	0f b7 0d 84 7e 11 c0 	movzwl 0xc0117e84,%ecx
c010117e:	0f b7 c1             	movzwl %cx,%eax
c0101181:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c0101187:	c1 e8 10             	shr    $0x10,%eax
c010118a:	89 c2                	mov    %eax,%edx
c010118c:	66 c1 ea 06          	shr    $0x6,%dx
c0101190:	89 d0                	mov    %edx,%eax
c0101192:	c1 e0 02             	shl    $0x2,%eax
c0101195:	01 d0                	add    %edx,%eax
c0101197:	c1 e0 04             	shl    $0x4,%eax
c010119a:	29 c1                	sub    %eax,%ecx
c010119c:	89 ca                	mov    %ecx,%edx
c010119e:	89 d8                	mov    %ebx,%eax
c01011a0:	29 d0                	sub    %edx,%eax
c01011a2:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
        break;
c01011a8:	eb 26                	jmp    c01011d0 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011aa:	8b 0d 80 7e 11 c0    	mov    0xc0117e80,%ecx
c01011b0:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011b7:	8d 50 01             	lea    0x1(%eax),%edx
c01011ba:	66 89 15 84 7e 11 c0 	mov    %dx,0xc0117e84
c01011c1:	0f b7 c0             	movzwl %ax,%eax
c01011c4:	01 c0                	add    %eax,%eax
c01011c6:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01011cc:	66 89 02             	mov    %ax,(%edx)
        break;
c01011cf:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011d0:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011d7:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011db:	76 5b                	jbe    c0101238 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011dd:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011e2:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011e8:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011ed:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c01011f4:	00 
c01011f5:	89 54 24 04          	mov    %edx,0x4(%esp)
c01011f9:	89 04 24             	mov    %eax,(%esp)
c01011fc:	e8 f1 4b 00 00       	call   c0105df2 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101201:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101208:	eb 15                	jmp    c010121f <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c010120a:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c010120f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101212:	01 d2                	add    %edx,%edx
c0101214:	01 d0                	add    %edx,%eax
c0101216:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010121b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010121f:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101226:	7e e2                	jle    c010120a <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c0101228:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010122f:	83 e8 50             	sub    $0x50,%eax
c0101232:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101238:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c010123f:	0f b7 c0             	movzwl %ax,%eax
c0101242:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101246:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c010124a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010124e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101252:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101253:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010125a:	66 c1 e8 08          	shr    $0x8,%ax
c010125e:	0f b6 c0             	movzbl %al,%eax
c0101261:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c0101268:	83 c2 01             	add    $0x1,%edx
c010126b:	0f b7 d2             	movzwl %dx,%edx
c010126e:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c0101272:	88 45 ed             	mov    %al,-0x13(%ebp)
c0101275:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101279:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010127d:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c010127e:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0101285:	0f b7 c0             	movzwl %ax,%eax
c0101288:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c010128c:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c0101290:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101294:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101298:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c0101299:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01012a0:	0f b6 c0             	movzbl %al,%eax
c01012a3:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c01012aa:	83 c2 01             	add    $0x1,%edx
c01012ad:	0f b7 d2             	movzwl %dx,%edx
c01012b0:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012b4:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012b7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012bb:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012bf:	ee                   	out    %al,(%dx)
}
c01012c0:	83 c4 34             	add    $0x34,%esp
c01012c3:	5b                   	pop    %ebx
c01012c4:	5d                   	pop    %ebp
c01012c5:	c3                   	ret    

c01012c6 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012c6:	55                   	push   %ebp
c01012c7:	89 e5                	mov    %esp,%ebp
c01012c9:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012d3:	eb 09                	jmp    c01012de <serial_putc_sub+0x18>
        delay();
c01012d5:	e8 4f fb ff ff       	call   c0100e29 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012da:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012de:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012e4:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012e8:	89 c2                	mov    %eax,%edx
c01012ea:	ec                   	in     (%dx),%al
c01012eb:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012ee:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01012f2:	0f b6 c0             	movzbl %al,%eax
c01012f5:	83 e0 20             	and    $0x20,%eax
c01012f8:	85 c0                	test   %eax,%eax
c01012fa:	75 09                	jne    c0101305 <serial_putc_sub+0x3f>
c01012fc:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101303:	7e d0                	jle    c01012d5 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c0101305:	8b 45 08             	mov    0x8(%ebp),%eax
c0101308:	0f b6 c0             	movzbl %al,%eax
c010130b:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101311:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101314:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101318:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010131c:	ee                   	out    %al,(%dx)
}
c010131d:	c9                   	leave  
c010131e:	c3                   	ret    

c010131f <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c010131f:	55                   	push   %ebp
c0101320:	89 e5                	mov    %esp,%ebp
c0101322:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101325:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101329:	74 0d                	je     c0101338 <serial_putc+0x19>
        serial_putc_sub(c);
c010132b:	8b 45 08             	mov    0x8(%ebp),%eax
c010132e:	89 04 24             	mov    %eax,(%esp)
c0101331:	e8 90 ff ff ff       	call   c01012c6 <serial_putc_sub>
c0101336:	eb 24                	jmp    c010135c <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c0101338:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010133f:	e8 82 ff ff ff       	call   c01012c6 <serial_putc_sub>
        serial_putc_sub(' ');
c0101344:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010134b:	e8 76 ff ff ff       	call   c01012c6 <serial_putc_sub>
        serial_putc_sub('\b');
c0101350:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101357:	e8 6a ff ff ff       	call   c01012c6 <serial_putc_sub>
    }
}
c010135c:	c9                   	leave  
c010135d:	c3                   	ret    

c010135e <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c010135e:	55                   	push   %ebp
c010135f:	89 e5                	mov    %esp,%ebp
c0101361:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101364:	eb 33                	jmp    c0101399 <cons_intr+0x3b>
        if (c != 0) {
c0101366:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010136a:	74 2d                	je     c0101399 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c010136c:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c0101371:	8d 50 01             	lea    0x1(%eax),%edx
c0101374:	89 15 a4 80 11 c0    	mov    %edx,0xc01180a4
c010137a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010137d:	88 90 a0 7e 11 c0    	mov    %dl,-0x3fee8160(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101383:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c0101388:	3d 00 02 00 00       	cmp    $0x200,%eax
c010138d:	75 0a                	jne    c0101399 <cons_intr+0x3b>
                cons.wpos = 0;
c010138f:	c7 05 a4 80 11 c0 00 	movl   $0x0,0xc01180a4
c0101396:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c0101399:	8b 45 08             	mov    0x8(%ebp),%eax
c010139c:	ff d0                	call   *%eax
c010139e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01013a1:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01013a5:	75 bf                	jne    c0101366 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01013a7:	c9                   	leave  
c01013a8:	c3                   	ret    

c01013a9 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013a9:	55                   	push   %ebp
c01013aa:	89 e5                	mov    %esp,%ebp
c01013ac:	83 ec 10             	sub    $0x10,%esp
c01013af:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013b5:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013b9:	89 c2                	mov    %eax,%edx
c01013bb:	ec                   	in     (%dx),%al
c01013bc:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013bf:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013c3:	0f b6 c0             	movzbl %al,%eax
c01013c6:	83 e0 01             	and    $0x1,%eax
c01013c9:	85 c0                	test   %eax,%eax
c01013cb:	75 07                	jne    c01013d4 <serial_proc_data+0x2b>
        return -1;
c01013cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013d2:	eb 2a                	jmp    c01013fe <serial_proc_data+0x55>
c01013d4:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013da:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013de:	89 c2                	mov    %eax,%edx
c01013e0:	ec                   	in     (%dx),%al
c01013e1:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013e4:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013e8:	0f b6 c0             	movzbl %al,%eax
c01013eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013ee:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01013f2:	75 07                	jne    c01013fb <serial_proc_data+0x52>
        c = '\b';
c01013f4:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01013fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01013fe:	c9                   	leave  
c01013ff:	c3                   	ret    

c0101400 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101400:	55                   	push   %ebp
c0101401:	89 e5                	mov    %esp,%ebp
c0101403:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101406:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c010140b:	85 c0                	test   %eax,%eax
c010140d:	74 0c                	je     c010141b <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c010140f:	c7 04 24 a9 13 10 c0 	movl   $0xc01013a9,(%esp)
c0101416:	e8 43 ff ff ff       	call   c010135e <cons_intr>
    }
}
c010141b:	c9                   	leave  
c010141c:	c3                   	ret    

c010141d <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c010141d:	55                   	push   %ebp
c010141e:	89 e5                	mov    %esp,%ebp
c0101420:	83 ec 38             	sub    $0x38,%esp
c0101423:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101429:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c010142d:	89 c2                	mov    %eax,%edx
c010142f:	ec                   	in     (%dx),%al
c0101430:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101433:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101437:	0f b6 c0             	movzbl %al,%eax
c010143a:	83 e0 01             	and    $0x1,%eax
c010143d:	85 c0                	test   %eax,%eax
c010143f:	75 0a                	jne    c010144b <kbd_proc_data+0x2e>
        return -1;
c0101441:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101446:	e9 59 01 00 00       	jmp    c01015a4 <kbd_proc_data+0x187>
c010144b:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101451:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101455:	89 c2                	mov    %eax,%edx
c0101457:	ec                   	in     (%dx),%al
c0101458:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c010145b:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c010145f:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101462:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101466:	75 17                	jne    c010147f <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101468:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010146d:	83 c8 40             	or     $0x40,%eax
c0101470:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c0101475:	b8 00 00 00 00       	mov    $0x0,%eax
c010147a:	e9 25 01 00 00       	jmp    c01015a4 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c010147f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101483:	84 c0                	test   %al,%al
c0101485:	79 47                	jns    c01014ce <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101487:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010148c:	83 e0 40             	and    $0x40,%eax
c010148f:	85 c0                	test   %eax,%eax
c0101491:	75 09                	jne    c010149c <kbd_proc_data+0x7f>
c0101493:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101497:	83 e0 7f             	and    $0x7f,%eax
c010149a:	eb 04                	jmp    c01014a0 <kbd_proc_data+0x83>
c010149c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a0:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01014a3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a7:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c01014ae:	83 c8 40             	or     $0x40,%eax
c01014b1:	0f b6 c0             	movzbl %al,%eax
c01014b4:	f7 d0                	not    %eax
c01014b6:	89 c2                	mov    %eax,%edx
c01014b8:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014bd:	21 d0                	and    %edx,%eax
c01014bf:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c01014c4:	b8 00 00 00 00       	mov    $0x0,%eax
c01014c9:	e9 d6 00 00 00       	jmp    c01015a4 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014ce:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014d3:	83 e0 40             	and    $0x40,%eax
c01014d6:	85 c0                	test   %eax,%eax
c01014d8:	74 11                	je     c01014eb <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014da:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014de:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014e3:	83 e0 bf             	and    $0xffffffbf,%eax
c01014e6:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    }

    shift |= shiftcode[data];
c01014eb:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014ef:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c01014f6:	0f b6 d0             	movzbl %al,%edx
c01014f9:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014fe:	09 d0                	or     %edx,%eax
c0101500:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    shift ^= togglecode[data];
c0101505:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101509:	0f b6 80 60 71 11 c0 	movzbl -0x3fee8ea0(%eax),%eax
c0101510:	0f b6 d0             	movzbl %al,%edx
c0101513:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101518:	31 d0                	xor    %edx,%eax
c010151a:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8

    c = charcode[shift & (CTL | SHIFT)][data];
c010151f:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101524:	83 e0 03             	and    $0x3,%eax
c0101527:	8b 14 85 60 75 11 c0 	mov    -0x3fee8aa0(,%eax,4),%edx
c010152e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101532:	01 d0                	add    %edx,%eax
c0101534:	0f b6 00             	movzbl (%eax),%eax
c0101537:	0f b6 c0             	movzbl %al,%eax
c010153a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c010153d:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101542:	83 e0 08             	and    $0x8,%eax
c0101545:	85 c0                	test   %eax,%eax
c0101547:	74 22                	je     c010156b <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101549:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c010154d:	7e 0c                	jle    c010155b <kbd_proc_data+0x13e>
c010154f:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101553:	7f 06                	jg     c010155b <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101555:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101559:	eb 10                	jmp    c010156b <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c010155b:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c010155f:	7e 0a                	jle    c010156b <kbd_proc_data+0x14e>
c0101561:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101565:	7f 04                	jg     c010156b <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101567:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c010156b:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101570:	f7 d0                	not    %eax
c0101572:	83 e0 06             	and    $0x6,%eax
c0101575:	85 c0                	test   %eax,%eax
c0101577:	75 28                	jne    c01015a1 <kbd_proc_data+0x184>
c0101579:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101580:	75 1f                	jne    c01015a1 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c0101582:	c7 04 24 5d 62 10 c0 	movl   $0xc010625d,(%esp)
c0101589:	e8 ae ed ff ff       	call   c010033c <cprintf>
c010158e:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c0101594:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101598:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c010159c:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01015a0:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01015a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015a4:	c9                   	leave  
c01015a5:	c3                   	ret    

c01015a6 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01015a6:	55                   	push   %ebp
c01015a7:	89 e5                	mov    %esp,%ebp
c01015a9:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015ac:	c7 04 24 1d 14 10 c0 	movl   $0xc010141d,(%esp)
c01015b3:	e8 a6 fd ff ff       	call   c010135e <cons_intr>
}
c01015b8:	c9                   	leave  
c01015b9:	c3                   	ret    

c01015ba <kbd_init>:

static void
kbd_init(void) {
c01015ba:	55                   	push   %ebp
c01015bb:	89 e5                	mov    %esp,%ebp
c01015bd:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015c0:	e8 e1 ff ff ff       	call   c01015a6 <kbd_intr>
    pic_enable(IRQ_KBD);
c01015c5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015cc:	e8 3d 01 00 00       	call   c010170e <pic_enable>
}
c01015d1:	c9                   	leave  
c01015d2:	c3                   	ret    

c01015d3 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015d3:	55                   	push   %ebp
c01015d4:	89 e5                	mov    %esp,%ebp
c01015d6:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015d9:	e8 93 f8 ff ff       	call   c0100e71 <cga_init>
    serial_init();
c01015de:	e8 74 f9 ff ff       	call   c0100f57 <serial_init>
    kbd_init();
c01015e3:	e8 d2 ff ff ff       	call   c01015ba <kbd_init>
    if (!serial_exists) {
c01015e8:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c01015ed:	85 c0                	test   %eax,%eax
c01015ef:	75 0c                	jne    c01015fd <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c01015f1:	c7 04 24 69 62 10 c0 	movl   $0xc0106269,(%esp)
c01015f8:	e8 3f ed ff ff       	call   c010033c <cprintf>
    }
}
c01015fd:	c9                   	leave  
c01015fe:	c3                   	ret    

c01015ff <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c01015ff:	55                   	push   %ebp
c0101600:	89 e5                	mov    %esp,%ebp
c0101602:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101605:	e8 e2 f7 ff ff       	call   c0100dec <__intr_save>
c010160a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c010160d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101610:	89 04 24             	mov    %eax,(%esp)
c0101613:	e8 9b fa ff ff       	call   c01010b3 <lpt_putc>
        cga_putc(c);
c0101618:	8b 45 08             	mov    0x8(%ebp),%eax
c010161b:	89 04 24             	mov    %eax,(%esp)
c010161e:	e8 cf fa ff ff       	call   c01010f2 <cga_putc>
        serial_putc(c);
c0101623:	8b 45 08             	mov    0x8(%ebp),%eax
c0101626:	89 04 24             	mov    %eax,(%esp)
c0101629:	e8 f1 fc ff ff       	call   c010131f <serial_putc>
    }
    local_intr_restore(intr_flag);
c010162e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101631:	89 04 24             	mov    %eax,(%esp)
c0101634:	e8 dd f7 ff ff       	call   c0100e16 <__intr_restore>
}
c0101639:	c9                   	leave  
c010163a:	c3                   	ret    

c010163b <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c010163b:	55                   	push   %ebp
c010163c:	89 e5                	mov    %esp,%ebp
c010163e:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101641:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101648:	e8 9f f7 ff ff       	call   c0100dec <__intr_save>
c010164d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101650:	e8 ab fd ff ff       	call   c0101400 <serial_intr>
        kbd_intr();
c0101655:	e8 4c ff ff ff       	call   c01015a6 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c010165a:	8b 15 a0 80 11 c0    	mov    0xc01180a0,%edx
c0101660:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c0101665:	39 c2                	cmp    %eax,%edx
c0101667:	74 31                	je     c010169a <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101669:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c010166e:	8d 50 01             	lea    0x1(%eax),%edx
c0101671:	89 15 a0 80 11 c0    	mov    %edx,0xc01180a0
c0101677:	0f b6 80 a0 7e 11 c0 	movzbl -0x3fee8160(%eax),%eax
c010167e:	0f b6 c0             	movzbl %al,%eax
c0101681:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101684:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c0101689:	3d 00 02 00 00       	cmp    $0x200,%eax
c010168e:	75 0a                	jne    c010169a <cons_getc+0x5f>
                cons.rpos = 0;
c0101690:	c7 05 a0 80 11 c0 00 	movl   $0x0,0xc01180a0
c0101697:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c010169a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010169d:	89 04 24             	mov    %eax,(%esp)
c01016a0:	e8 71 f7 ff ff       	call   c0100e16 <__intr_restore>
    return c;
c01016a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016a8:	c9                   	leave  
c01016a9:	c3                   	ret    

c01016aa <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c01016aa:	55                   	push   %ebp
c01016ab:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c01016ad:	fb                   	sti    
    sti();
}
c01016ae:	5d                   	pop    %ebp
c01016af:	c3                   	ret    

c01016b0 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c01016b0:	55                   	push   %ebp
c01016b1:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c01016b3:	fa                   	cli    
    cli();
}
c01016b4:	5d                   	pop    %ebp
c01016b5:	c3                   	ret    

c01016b6 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01016b6:	55                   	push   %ebp
c01016b7:	89 e5                	mov    %esp,%ebp
c01016b9:	83 ec 14             	sub    $0x14,%esp
c01016bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01016bf:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016c3:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016c7:	66 a3 70 75 11 c0    	mov    %ax,0xc0117570
    if (did_init) {
c01016cd:	a1 ac 80 11 c0       	mov    0xc01180ac,%eax
c01016d2:	85 c0                	test   %eax,%eax
c01016d4:	74 36                	je     c010170c <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c01016d6:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016da:	0f b6 c0             	movzbl %al,%eax
c01016dd:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01016e3:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01016e6:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01016ea:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01016ee:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c01016ef:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016f3:	66 c1 e8 08          	shr    $0x8,%ax
c01016f7:	0f b6 c0             	movzbl %al,%eax
c01016fa:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101700:	88 45 f9             	mov    %al,-0x7(%ebp)
c0101703:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101707:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010170b:	ee                   	out    %al,(%dx)
    }
}
c010170c:	c9                   	leave  
c010170d:	c3                   	ret    

c010170e <pic_enable>:

void
pic_enable(unsigned int irq) {
c010170e:	55                   	push   %ebp
c010170f:	89 e5                	mov    %esp,%ebp
c0101711:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101714:	8b 45 08             	mov    0x8(%ebp),%eax
c0101717:	ba 01 00 00 00       	mov    $0x1,%edx
c010171c:	89 c1                	mov    %eax,%ecx
c010171e:	d3 e2                	shl    %cl,%edx
c0101720:	89 d0                	mov    %edx,%eax
c0101722:	f7 d0                	not    %eax
c0101724:	89 c2                	mov    %eax,%edx
c0101726:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c010172d:	21 d0                	and    %edx,%eax
c010172f:	0f b7 c0             	movzwl %ax,%eax
c0101732:	89 04 24             	mov    %eax,(%esp)
c0101735:	e8 7c ff ff ff       	call   c01016b6 <pic_setmask>
}
c010173a:	c9                   	leave  
c010173b:	c3                   	ret    

c010173c <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c010173c:	55                   	push   %ebp
c010173d:	89 e5                	mov    %esp,%ebp
c010173f:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101742:	c7 05 ac 80 11 c0 01 	movl   $0x1,0xc01180ac
c0101749:	00 00 00 
c010174c:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101752:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c0101756:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c010175a:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010175e:	ee                   	out    %al,(%dx)
c010175f:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101765:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c0101769:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010176d:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101771:	ee                   	out    %al,(%dx)
c0101772:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101778:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c010177c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101780:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101784:	ee                   	out    %al,(%dx)
c0101785:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c010178b:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c010178f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101793:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101797:	ee                   	out    %al,(%dx)
c0101798:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c010179e:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c01017a2:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01017a6:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01017aa:	ee                   	out    %al,(%dx)
c01017ab:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c01017b1:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c01017b5:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01017b9:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01017bd:	ee                   	out    %al,(%dx)
c01017be:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c01017c4:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c01017c8:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01017cc:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01017d0:	ee                   	out    %al,(%dx)
c01017d1:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c01017d7:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c01017db:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01017df:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01017e3:	ee                   	out    %al,(%dx)
c01017e4:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c01017ea:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c01017ee:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01017f2:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01017f6:	ee                   	out    %al,(%dx)
c01017f7:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c01017fd:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c0101801:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101805:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101809:	ee                   	out    %al,(%dx)
c010180a:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c0101810:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c0101814:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101818:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c010181c:	ee                   	out    %al,(%dx)
c010181d:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0101823:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c0101827:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c010182b:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c010182f:	ee                   	out    %al,(%dx)
c0101830:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c0101836:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c010183a:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c010183e:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101842:	ee                   	out    %al,(%dx)
c0101843:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c0101849:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c010184d:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101851:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0101855:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c0101856:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c010185d:	66 83 f8 ff          	cmp    $0xffff,%ax
c0101861:	74 12                	je     c0101875 <pic_init+0x139>
        pic_setmask(irq_mask);
c0101863:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c010186a:	0f b7 c0             	movzwl %ax,%eax
c010186d:	89 04 24             	mov    %eax,(%esp)
c0101870:	e8 41 fe ff ff       	call   c01016b6 <pic_setmask>
    }
}
c0101875:	c9                   	leave  
c0101876:	c3                   	ret    

c0101877 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0101877:	55                   	push   %ebp
c0101878:	89 e5                	mov    %esp,%ebp
c010187a:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c010187d:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0101884:	00 
c0101885:	c7 04 24 a0 62 10 c0 	movl   $0xc01062a0,(%esp)
c010188c:	e8 ab ea ff ff       	call   c010033c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c0101891:	c9                   	leave  
c0101892:	c3                   	ret    

c0101893 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c0101893:	55                   	push   %ebp
c0101894:	89 e5                	mov    %esp,%ebp
c0101896:	83 ec 10             	sub    $0x10,%esp
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	int i = 0;
c0101899:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for(i = 0; i < 256; i ++)
c01018a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01018a7:	e9 94 01 00 00       	jmp    c0101a40 <idt_init+0x1ad>
	{
		if(i != T_SYSCALL)
c01018ac:	81 7d fc 80 00 00 00 	cmpl   $0x80,-0x4(%ebp)
c01018b3:	0f 84 c4 00 00 00    	je     c010197d <idt_init+0xea>
		{
			SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c01018b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018bc:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c01018c3:	89 c2                	mov    %eax,%edx
c01018c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018c8:	66 89 14 c5 c0 80 11 	mov    %dx,-0x3fee7f40(,%eax,8)
c01018cf:	c0 
c01018d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018d3:	66 c7 04 c5 c2 80 11 	movw   $0x8,-0x3fee7f3e(,%eax,8)
c01018da:	c0 08 00 
c01018dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018e0:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c01018e7:	c0 
c01018e8:	83 e2 e0             	and    $0xffffffe0,%edx
c01018eb:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c01018f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018f5:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c01018fc:	c0 
c01018fd:	83 e2 1f             	and    $0x1f,%edx
c0101900:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c0101907:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010190a:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101911:	c0 
c0101912:	83 e2 f0             	and    $0xfffffff0,%edx
c0101915:	83 ca 0e             	or     $0xe,%edx
c0101918:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c010191f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101922:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101929:	c0 
c010192a:	83 e2 ef             	and    $0xffffffef,%edx
c010192d:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101934:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101937:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c010193e:	c0 
c010193f:	83 e2 9f             	and    $0xffffff9f,%edx
c0101942:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101949:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010194c:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101953:	c0 
c0101954:	83 ca 80             	or     $0xffffff80,%edx
c0101957:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c010195e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101961:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c0101968:	c1 e8 10             	shr    $0x10,%eax
c010196b:	89 c2                	mov    %eax,%edx
c010196d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101970:	66 89 14 c5 c6 80 11 	mov    %dx,-0x3fee7f3a(,%eax,8)
c0101977:	c0 
c0101978:	e9 bf 00 00 00       	jmp    c0101a3c <idt_init+0x1a9>
		}
		else
		{
			SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_USER);
c010197d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101980:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c0101987:	89 c2                	mov    %eax,%edx
c0101989:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010198c:	66 89 14 c5 c0 80 11 	mov    %dx,-0x3fee7f40(,%eax,8)
c0101993:	c0 
c0101994:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101997:	66 c7 04 c5 c2 80 11 	movw   $0x8,-0x3fee7f3e(,%eax,8)
c010199e:	c0 08 00 
c01019a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019a4:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c01019ab:	c0 
c01019ac:	83 e2 e0             	and    $0xffffffe0,%edx
c01019af:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c01019b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019b9:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c01019c0:	c0 
c01019c1:	83 e2 1f             	and    $0x1f,%edx
c01019c4:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c01019cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019ce:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c01019d5:	c0 
c01019d6:	83 e2 f0             	and    $0xfffffff0,%edx
c01019d9:	83 ca 0e             	or     $0xe,%edx
c01019dc:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c01019e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019e6:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c01019ed:	c0 
c01019ee:	83 e2 ef             	and    $0xffffffef,%edx
c01019f1:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c01019f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019fb:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101a02:	c0 
c0101a03:	83 ca 60             	or     $0x60,%edx
c0101a06:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101a0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a10:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101a17:	c0 
c0101a18:	83 ca 80             	or     $0xffffff80,%edx
c0101a1b:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101a22:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a25:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c0101a2c:	c1 e8 10             	shr    $0x10,%eax
c0101a2f:	89 c2                	mov    %eax,%edx
c0101a31:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a34:	66 89 14 c5 c6 80 11 	mov    %dx,-0x3fee7f3a(,%eax,8)
c0101a3b:	c0 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	int i = 0;
	for(i = 0; i < 256; i ++)
c0101a3c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101a40:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c0101a47:	0f 8e 5f fe ff ff    	jle    c01018ac <idt_init+0x19>
c0101a4d:	c7 45 f8 80 75 11 c0 	movl   $0xc0117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101a54:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101a57:	0f 01 18             	lidtl  (%eax)
		}
	}

	lidt(&idt_pd);

	return;
c0101a5a:	90                   	nop
}
c0101a5b:	c9                   	leave  
c0101a5c:	c3                   	ret    

c0101a5d <trapname>:

static const char *
trapname(int trapno) {
c0101a5d:	55                   	push   %ebp
c0101a5e:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101a60:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a63:	83 f8 13             	cmp    $0x13,%eax
c0101a66:	77 0c                	ja     c0101a74 <trapname+0x17>
        return excnames[trapno];
c0101a68:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a6b:	8b 04 85 00 66 10 c0 	mov    -0x3fef9a00(,%eax,4),%eax
c0101a72:	eb 18                	jmp    c0101a8c <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101a74:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101a78:	7e 0d                	jle    c0101a87 <trapname+0x2a>
c0101a7a:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101a7e:	7f 07                	jg     c0101a87 <trapname+0x2a>
        return "Hardware Interrupt";
c0101a80:	b8 aa 62 10 c0       	mov    $0xc01062aa,%eax
c0101a85:	eb 05                	jmp    c0101a8c <trapname+0x2f>
    }
    return "(unknown trap)";
c0101a87:	b8 bd 62 10 c0       	mov    $0xc01062bd,%eax
}
c0101a8c:	5d                   	pop    %ebp
c0101a8d:	c3                   	ret    

c0101a8e <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101a8e:	55                   	push   %ebp
c0101a8f:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101a91:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a94:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101a98:	66 83 f8 08          	cmp    $0x8,%ax
c0101a9c:	0f 94 c0             	sete   %al
c0101a9f:	0f b6 c0             	movzbl %al,%eax
}
c0101aa2:	5d                   	pop    %ebp
c0101aa3:	c3                   	ret    

c0101aa4 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101aa4:	55                   	push   %ebp
c0101aa5:	89 e5                	mov    %esp,%ebp
c0101aa7:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101aaa:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aad:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ab1:	c7 04 24 fe 62 10 c0 	movl   $0xc01062fe,(%esp)
c0101ab8:	e8 7f e8 ff ff       	call   c010033c <cprintf>
    print_regs(&tf->tf_regs);
c0101abd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ac0:	89 04 24             	mov    %eax,(%esp)
c0101ac3:	e8 a1 01 00 00       	call   c0101c69 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101ac8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101acb:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101acf:	0f b7 c0             	movzwl %ax,%eax
c0101ad2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ad6:	c7 04 24 0f 63 10 c0 	movl   $0xc010630f,(%esp)
c0101add:	e8 5a e8 ff ff       	call   c010033c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101ae2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ae5:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101ae9:	0f b7 c0             	movzwl %ax,%eax
c0101aec:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101af0:	c7 04 24 22 63 10 c0 	movl   $0xc0106322,(%esp)
c0101af7:	e8 40 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101afc:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aff:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101b03:	0f b7 c0             	movzwl %ax,%eax
c0101b06:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b0a:	c7 04 24 35 63 10 c0 	movl   $0xc0106335,(%esp)
c0101b11:	e8 26 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101b16:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b19:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101b1d:	0f b7 c0             	movzwl %ax,%eax
c0101b20:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b24:	c7 04 24 48 63 10 c0 	movl   $0xc0106348,(%esp)
c0101b2b:	e8 0c e8 ff ff       	call   c010033c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101b30:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b33:	8b 40 30             	mov    0x30(%eax),%eax
c0101b36:	89 04 24             	mov    %eax,(%esp)
c0101b39:	e8 1f ff ff ff       	call   c0101a5d <trapname>
c0101b3e:	8b 55 08             	mov    0x8(%ebp),%edx
c0101b41:	8b 52 30             	mov    0x30(%edx),%edx
c0101b44:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101b48:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101b4c:	c7 04 24 5b 63 10 c0 	movl   $0xc010635b,(%esp)
c0101b53:	e8 e4 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101b58:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b5b:	8b 40 34             	mov    0x34(%eax),%eax
c0101b5e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b62:	c7 04 24 6d 63 10 c0 	movl   $0xc010636d,(%esp)
c0101b69:	e8 ce e7 ff ff       	call   c010033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101b6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b71:	8b 40 38             	mov    0x38(%eax),%eax
c0101b74:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b78:	c7 04 24 7c 63 10 c0 	movl   $0xc010637c,(%esp)
c0101b7f:	e8 b8 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101b84:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b87:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b8b:	0f b7 c0             	movzwl %ax,%eax
c0101b8e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b92:	c7 04 24 8b 63 10 c0 	movl   $0xc010638b,(%esp)
c0101b99:	e8 9e e7 ff ff       	call   c010033c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101b9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ba1:	8b 40 40             	mov    0x40(%eax),%eax
c0101ba4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ba8:	c7 04 24 9e 63 10 c0 	movl   $0xc010639e,(%esp)
c0101baf:	e8 88 e7 ff ff       	call   c010033c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101bb4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101bbb:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101bc2:	eb 3e                	jmp    c0101c02 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101bc4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bc7:	8b 50 40             	mov    0x40(%eax),%edx
c0101bca:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101bcd:	21 d0                	and    %edx,%eax
c0101bcf:	85 c0                	test   %eax,%eax
c0101bd1:	74 28                	je     c0101bfb <print_trapframe+0x157>
c0101bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bd6:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101bdd:	85 c0                	test   %eax,%eax
c0101bdf:	74 1a                	je     c0101bfb <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0101be1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101be4:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101beb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bef:	c7 04 24 ad 63 10 c0 	movl   $0xc01063ad,(%esp)
c0101bf6:	e8 41 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101bfb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101bff:	d1 65 f0             	shll   -0x10(%ebp)
c0101c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c05:	83 f8 17             	cmp    $0x17,%eax
c0101c08:	76 ba                	jbe    c0101bc4 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101c0a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c0d:	8b 40 40             	mov    0x40(%eax),%eax
c0101c10:	25 00 30 00 00       	and    $0x3000,%eax
c0101c15:	c1 e8 0c             	shr    $0xc,%eax
c0101c18:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c1c:	c7 04 24 b1 63 10 c0 	movl   $0xc01063b1,(%esp)
c0101c23:	e8 14 e7 ff ff       	call   c010033c <cprintf>

    if (!trap_in_kernel(tf)) {
c0101c28:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c2b:	89 04 24             	mov    %eax,(%esp)
c0101c2e:	e8 5b fe ff ff       	call   c0101a8e <trap_in_kernel>
c0101c33:	85 c0                	test   %eax,%eax
c0101c35:	75 30                	jne    c0101c67 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101c37:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c3a:	8b 40 44             	mov    0x44(%eax),%eax
c0101c3d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c41:	c7 04 24 ba 63 10 c0 	movl   $0xc01063ba,(%esp)
c0101c48:	e8 ef e6 ff ff       	call   c010033c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101c4d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c50:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101c54:	0f b7 c0             	movzwl %ax,%eax
c0101c57:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c5b:	c7 04 24 c9 63 10 c0 	movl   $0xc01063c9,(%esp)
c0101c62:	e8 d5 e6 ff ff       	call   c010033c <cprintf>
    }
}
c0101c67:	c9                   	leave  
c0101c68:	c3                   	ret    

c0101c69 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101c69:	55                   	push   %ebp
c0101c6a:	89 e5                	mov    %esp,%ebp
c0101c6c:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101c6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c72:	8b 00                	mov    (%eax),%eax
c0101c74:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c78:	c7 04 24 dc 63 10 c0 	movl   $0xc01063dc,(%esp)
c0101c7f:	e8 b8 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101c84:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c87:	8b 40 04             	mov    0x4(%eax),%eax
c0101c8a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c8e:	c7 04 24 eb 63 10 c0 	movl   $0xc01063eb,(%esp)
c0101c95:	e8 a2 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101c9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c9d:	8b 40 08             	mov    0x8(%eax),%eax
c0101ca0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ca4:	c7 04 24 fa 63 10 c0 	movl   $0xc01063fa,(%esp)
c0101cab:	e8 8c e6 ff ff       	call   c010033c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101cb0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cb3:	8b 40 0c             	mov    0xc(%eax),%eax
c0101cb6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cba:	c7 04 24 09 64 10 c0 	movl   $0xc0106409,(%esp)
c0101cc1:	e8 76 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101cc6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cc9:	8b 40 10             	mov    0x10(%eax),%eax
c0101ccc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cd0:	c7 04 24 18 64 10 c0 	movl   $0xc0106418,(%esp)
c0101cd7:	e8 60 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101cdc:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cdf:	8b 40 14             	mov    0x14(%eax),%eax
c0101ce2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ce6:	c7 04 24 27 64 10 c0 	movl   $0xc0106427,(%esp)
c0101ced:	e8 4a e6 ff ff       	call   c010033c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101cf2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cf5:	8b 40 18             	mov    0x18(%eax),%eax
c0101cf8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cfc:	c7 04 24 36 64 10 c0 	movl   $0xc0106436,(%esp)
c0101d03:	e8 34 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101d08:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d0b:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101d0e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d12:	c7 04 24 45 64 10 c0 	movl   $0xc0106445,(%esp)
c0101d19:	e8 1e e6 ff ff       	call   c010033c <cprintf>
}
c0101d1e:	c9                   	leave  
c0101d1f:	c3                   	ret    

c0101d20 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101d20:	55                   	push   %ebp
c0101d21:	89 e5                	mov    %esp,%ebp
c0101d23:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
c0101d26:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d29:	8b 40 30             	mov    0x30(%eax),%eax
c0101d2c:	83 f8 2f             	cmp    $0x2f,%eax
c0101d2f:	77 21                	ja     c0101d52 <trap_dispatch+0x32>
c0101d31:	83 f8 2e             	cmp    $0x2e,%eax
c0101d34:	0f 83 04 01 00 00    	jae    c0101e3e <trap_dispatch+0x11e>
c0101d3a:	83 f8 21             	cmp    $0x21,%eax
c0101d3d:	0f 84 81 00 00 00    	je     c0101dc4 <trap_dispatch+0xa4>
c0101d43:	83 f8 24             	cmp    $0x24,%eax
c0101d46:	74 56                	je     c0101d9e <trap_dispatch+0x7e>
c0101d48:	83 f8 20             	cmp    $0x20,%eax
c0101d4b:	74 16                	je     c0101d63 <trap_dispatch+0x43>
c0101d4d:	e9 b4 00 00 00       	jmp    c0101e06 <trap_dispatch+0xe6>
c0101d52:	83 e8 78             	sub    $0x78,%eax
c0101d55:	83 f8 01             	cmp    $0x1,%eax
c0101d58:	0f 87 a8 00 00 00    	ja     c0101e06 <trap_dispatch+0xe6>
c0101d5e:	e9 87 00 00 00       	jmp    c0101dea <trap_dispatch+0xca>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
    	ticks ++;
c0101d63:	a1 4c 89 11 c0       	mov    0xc011894c,%eax
c0101d68:	83 c0 01             	add    $0x1,%eax
c0101d6b:	a3 4c 89 11 c0       	mov    %eax,0xc011894c
		if(ticks % 100 == 0)
c0101d70:	8b 0d 4c 89 11 c0    	mov    0xc011894c,%ecx
c0101d76:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101d7b:	89 c8                	mov    %ecx,%eax
c0101d7d:	f7 e2                	mul    %edx
c0101d7f:	89 d0                	mov    %edx,%eax
c0101d81:	c1 e8 05             	shr    $0x5,%eax
c0101d84:	6b c0 64             	imul   $0x64,%eax,%eax
c0101d87:	29 c1                	sub    %eax,%ecx
c0101d89:	89 c8                	mov    %ecx,%eax
c0101d8b:	85 c0                	test   %eax,%eax
c0101d8d:	75 0a                	jne    c0101d99 <trap_dispatch+0x79>
			print_ticks();
c0101d8f:	e8 e3 fa ff ff       	call   c0101877 <print_ticks>
		break;
c0101d94:	e9 a6 00 00 00       	jmp    c0101e3f <trap_dispatch+0x11f>
c0101d99:	e9 a1 00 00 00       	jmp    c0101e3f <trap_dispatch+0x11f>
        break;
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101d9e:	e8 98 f8 ff ff       	call   c010163b <cons_getc>
c0101da3:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101da6:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101daa:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101dae:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101db2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101db6:	c7 04 24 54 64 10 c0 	movl   $0xc0106454,(%esp)
c0101dbd:	e8 7a e5 ff ff       	call   c010033c <cprintf>
        break;
c0101dc2:	eb 7b                	jmp    c0101e3f <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101dc4:	e8 72 f8 ff ff       	call   c010163b <cons_getc>
c0101dc9:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101dcc:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101dd0:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101dd4:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101dd8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ddc:	c7 04 24 66 64 10 c0 	movl   $0xc0106466,(%esp)
c0101de3:	e8 54 e5 ff ff       	call   c010033c <cprintf>
        break;
c0101de8:	eb 55                	jmp    c0101e3f <trap_dispatch+0x11f>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101dea:	c7 44 24 08 75 64 10 	movl   $0xc0106475,0x8(%esp)
c0101df1:	c0 
c0101df2:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
c0101df9:	00 
c0101dfa:	c7 04 24 85 64 10 c0 	movl   $0xc0106485,(%esp)
c0101e01:	e8 c7 ee ff ff       	call   c0100ccd <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101e06:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e09:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101e0d:	0f b7 c0             	movzwl %ax,%eax
c0101e10:	83 e0 03             	and    $0x3,%eax
c0101e13:	85 c0                	test   %eax,%eax
c0101e15:	75 28                	jne    c0101e3f <trap_dispatch+0x11f>
            print_trapframe(tf);
c0101e17:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e1a:	89 04 24             	mov    %eax,(%esp)
c0101e1d:	e8 82 fc ff ff       	call   c0101aa4 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101e22:	c7 44 24 08 96 64 10 	movl   $0xc0106496,0x8(%esp)
c0101e29:	c0 
c0101e2a:	c7 44 24 04 c1 00 00 	movl   $0xc1,0x4(%esp)
c0101e31:	00 
c0101e32:	c7 04 24 85 64 10 c0 	movl   $0xc0106485,(%esp)
c0101e39:	e8 8f ee ff ff       	call   c0100ccd <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0101e3e:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0101e3f:	c9                   	leave  
c0101e40:	c3                   	ret    

c0101e41 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101e41:	55                   	push   %ebp
c0101e42:	89 e5                	mov    %esp,%ebp
c0101e44:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101e47:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e4a:	89 04 24             	mov    %eax,(%esp)
c0101e4d:	e8 ce fe ff ff       	call   c0101d20 <trap_dispatch>
}
c0101e52:	c9                   	leave  
c0101e53:	c3                   	ret    

c0101e54 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0101e54:	1e                   	push   %ds
    pushl %es
c0101e55:	06                   	push   %es
    pushl %fs
c0101e56:	0f a0                	push   %fs
    pushl %gs
c0101e58:	0f a8                	push   %gs
    pushal
c0101e5a:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0101e5b:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0101e60:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0101e62:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0101e64:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0101e65:	e8 d7 ff ff ff       	call   c0101e41 <trap>

    # pop the pushed stack pointer
    popl %esp
c0101e6a:	5c                   	pop    %esp

c0101e6b <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0101e6b:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0101e6c:	0f a9                	pop    %gs
    popl %fs
c0101e6e:	0f a1                	pop    %fs
    popl %es
c0101e70:	07                   	pop    %es
    popl %ds
c0101e71:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0101e72:	83 c4 08             	add    $0x8,%esp
    iret
c0101e75:	cf                   	iret   

c0101e76 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101e76:	6a 00                	push   $0x0
  pushl $0
c0101e78:	6a 00                	push   $0x0
  jmp __alltraps
c0101e7a:	e9 d5 ff ff ff       	jmp    c0101e54 <__alltraps>

c0101e7f <vector1>:
.globl vector1
vector1:
  pushl $0
c0101e7f:	6a 00                	push   $0x0
  pushl $1
c0101e81:	6a 01                	push   $0x1
  jmp __alltraps
c0101e83:	e9 cc ff ff ff       	jmp    c0101e54 <__alltraps>

c0101e88 <vector2>:
.globl vector2
vector2:
  pushl $0
c0101e88:	6a 00                	push   $0x0
  pushl $2
c0101e8a:	6a 02                	push   $0x2
  jmp __alltraps
c0101e8c:	e9 c3 ff ff ff       	jmp    c0101e54 <__alltraps>

c0101e91 <vector3>:
.globl vector3
vector3:
  pushl $0
c0101e91:	6a 00                	push   $0x0
  pushl $3
c0101e93:	6a 03                	push   $0x3
  jmp __alltraps
c0101e95:	e9 ba ff ff ff       	jmp    c0101e54 <__alltraps>

c0101e9a <vector4>:
.globl vector4
vector4:
  pushl $0
c0101e9a:	6a 00                	push   $0x0
  pushl $4
c0101e9c:	6a 04                	push   $0x4
  jmp __alltraps
c0101e9e:	e9 b1 ff ff ff       	jmp    c0101e54 <__alltraps>

c0101ea3 <vector5>:
.globl vector5
vector5:
  pushl $0
c0101ea3:	6a 00                	push   $0x0
  pushl $5
c0101ea5:	6a 05                	push   $0x5
  jmp __alltraps
c0101ea7:	e9 a8 ff ff ff       	jmp    c0101e54 <__alltraps>

c0101eac <vector6>:
.globl vector6
vector6:
  pushl $0
c0101eac:	6a 00                	push   $0x0
  pushl $6
c0101eae:	6a 06                	push   $0x6
  jmp __alltraps
c0101eb0:	e9 9f ff ff ff       	jmp    c0101e54 <__alltraps>

c0101eb5 <vector7>:
.globl vector7
vector7:
  pushl $0
c0101eb5:	6a 00                	push   $0x0
  pushl $7
c0101eb7:	6a 07                	push   $0x7
  jmp __alltraps
c0101eb9:	e9 96 ff ff ff       	jmp    c0101e54 <__alltraps>

c0101ebe <vector8>:
.globl vector8
vector8:
  pushl $8
c0101ebe:	6a 08                	push   $0x8
  jmp __alltraps
c0101ec0:	e9 8f ff ff ff       	jmp    c0101e54 <__alltraps>

c0101ec5 <vector9>:
.globl vector9
vector9:
  pushl $9
c0101ec5:	6a 09                	push   $0x9
  jmp __alltraps
c0101ec7:	e9 88 ff ff ff       	jmp    c0101e54 <__alltraps>

c0101ecc <vector10>:
.globl vector10
vector10:
  pushl $10
c0101ecc:	6a 0a                	push   $0xa
  jmp __alltraps
c0101ece:	e9 81 ff ff ff       	jmp    c0101e54 <__alltraps>

c0101ed3 <vector11>:
.globl vector11
vector11:
  pushl $11
c0101ed3:	6a 0b                	push   $0xb
  jmp __alltraps
c0101ed5:	e9 7a ff ff ff       	jmp    c0101e54 <__alltraps>

c0101eda <vector12>:
.globl vector12
vector12:
  pushl $12
c0101eda:	6a 0c                	push   $0xc
  jmp __alltraps
c0101edc:	e9 73 ff ff ff       	jmp    c0101e54 <__alltraps>

c0101ee1 <vector13>:
.globl vector13
vector13:
  pushl $13
c0101ee1:	6a 0d                	push   $0xd
  jmp __alltraps
c0101ee3:	e9 6c ff ff ff       	jmp    c0101e54 <__alltraps>

c0101ee8 <vector14>:
.globl vector14
vector14:
  pushl $14
c0101ee8:	6a 0e                	push   $0xe
  jmp __alltraps
c0101eea:	e9 65 ff ff ff       	jmp    c0101e54 <__alltraps>

c0101eef <vector15>:
.globl vector15
vector15:
  pushl $0
c0101eef:	6a 00                	push   $0x0
  pushl $15
c0101ef1:	6a 0f                	push   $0xf
  jmp __alltraps
c0101ef3:	e9 5c ff ff ff       	jmp    c0101e54 <__alltraps>

c0101ef8 <vector16>:
.globl vector16
vector16:
  pushl $0
c0101ef8:	6a 00                	push   $0x0
  pushl $16
c0101efa:	6a 10                	push   $0x10
  jmp __alltraps
c0101efc:	e9 53 ff ff ff       	jmp    c0101e54 <__alltraps>

c0101f01 <vector17>:
.globl vector17
vector17:
  pushl $17
c0101f01:	6a 11                	push   $0x11
  jmp __alltraps
c0101f03:	e9 4c ff ff ff       	jmp    c0101e54 <__alltraps>

c0101f08 <vector18>:
.globl vector18
vector18:
  pushl $0
c0101f08:	6a 00                	push   $0x0
  pushl $18
c0101f0a:	6a 12                	push   $0x12
  jmp __alltraps
c0101f0c:	e9 43 ff ff ff       	jmp    c0101e54 <__alltraps>

c0101f11 <vector19>:
.globl vector19
vector19:
  pushl $0
c0101f11:	6a 00                	push   $0x0
  pushl $19
c0101f13:	6a 13                	push   $0x13
  jmp __alltraps
c0101f15:	e9 3a ff ff ff       	jmp    c0101e54 <__alltraps>

c0101f1a <vector20>:
.globl vector20
vector20:
  pushl $0
c0101f1a:	6a 00                	push   $0x0
  pushl $20
c0101f1c:	6a 14                	push   $0x14
  jmp __alltraps
c0101f1e:	e9 31 ff ff ff       	jmp    c0101e54 <__alltraps>

c0101f23 <vector21>:
.globl vector21
vector21:
  pushl $0
c0101f23:	6a 00                	push   $0x0
  pushl $21
c0101f25:	6a 15                	push   $0x15
  jmp __alltraps
c0101f27:	e9 28 ff ff ff       	jmp    c0101e54 <__alltraps>

c0101f2c <vector22>:
.globl vector22
vector22:
  pushl $0
c0101f2c:	6a 00                	push   $0x0
  pushl $22
c0101f2e:	6a 16                	push   $0x16
  jmp __alltraps
c0101f30:	e9 1f ff ff ff       	jmp    c0101e54 <__alltraps>

c0101f35 <vector23>:
.globl vector23
vector23:
  pushl $0
c0101f35:	6a 00                	push   $0x0
  pushl $23
c0101f37:	6a 17                	push   $0x17
  jmp __alltraps
c0101f39:	e9 16 ff ff ff       	jmp    c0101e54 <__alltraps>

c0101f3e <vector24>:
.globl vector24
vector24:
  pushl $0
c0101f3e:	6a 00                	push   $0x0
  pushl $24
c0101f40:	6a 18                	push   $0x18
  jmp __alltraps
c0101f42:	e9 0d ff ff ff       	jmp    c0101e54 <__alltraps>

c0101f47 <vector25>:
.globl vector25
vector25:
  pushl $0
c0101f47:	6a 00                	push   $0x0
  pushl $25
c0101f49:	6a 19                	push   $0x19
  jmp __alltraps
c0101f4b:	e9 04 ff ff ff       	jmp    c0101e54 <__alltraps>

c0101f50 <vector26>:
.globl vector26
vector26:
  pushl $0
c0101f50:	6a 00                	push   $0x0
  pushl $26
c0101f52:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101f54:	e9 fb fe ff ff       	jmp    c0101e54 <__alltraps>

c0101f59 <vector27>:
.globl vector27
vector27:
  pushl $0
c0101f59:	6a 00                	push   $0x0
  pushl $27
c0101f5b:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101f5d:	e9 f2 fe ff ff       	jmp    c0101e54 <__alltraps>

c0101f62 <vector28>:
.globl vector28
vector28:
  pushl $0
c0101f62:	6a 00                	push   $0x0
  pushl $28
c0101f64:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101f66:	e9 e9 fe ff ff       	jmp    c0101e54 <__alltraps>

c0101f6b <vector29>:
.globl vector29
vector29:
  pushl $0
c0101f6b:	6a 00                	push   $0x0
  pushl $29
c0101f6d:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101f6f:	e9 e0 fe ff ff       	jmp    c0101e54 <__alltraps>

c0101f74 <vector30>:
.globl vector30
vector30:
  pushl $0
c0101f74:	6a 00                	push   $0x0
  pushl $30
c0101f76:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101f78:	e9 d7 fe ff ff       	jmp    c0101e54 <__alltraps>

c0101f7d <vector31>:
.globl vector31
vector31:
  pushl $0
c0101f7d:	6a 00                	push   $0x0
  pushl $31
c0101f7f:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101f81:	e9 ce fe ff ff       	jmp    c0101e54 <__alltraps>

c0101f86 <vector32>:
.globl vector32
vector32:
  pushl $0
c0101f86:	6a 00                	push   $0x0
  pushl $32
c0101f88:	6a 20                	push   $0x20
  jmp __alltraps
c0101f8a:	e9 c5 fe ff ff       	jmp    c0101e54 <__alltraps>

c0101f8f <vector33>:
.globl vector33
vector33:
  pushl $0
c0101f8f:	6a 00                	push   $0x0
  pushl $33
c0101f91:	6a 21                	push   $0x21
  jmp __alltraps
c0101f93:	e9 bc fe ff ff       	jmp    c0101e54 <__alltraps>

c0101f98 <vector34>:
.globl vector34
vector34:
  pushl $0
c0101f98:	6a 00                	push   $0x0
  pushl $34
c0101f9a:	6a 22                	push   $0x22
  jmp __alltraps
c0101f9c:	e9 b3 fe ff ff       	jmp    c0101e54 <__alltraps>

c0101fa1 <vector35>:
.globl vector35
vector35:
  pushl $0
c0101fa1:	6a 00                	push   $0x0
  pushl $35
c0101fa3:	6a 23                	push   $0x23
  jmp __alltraps
c0101fa5:	e9 aa fe ff ff       	jmp    c0101e54 <__alltraps>

c0101faa <vector36>:
.globl vector36
vector36:
  pushl $0
c0101faa:	6a 00                	push   $0x0
  pushl $36
c0101fac:	6a 24                	push   $0x24
  jmp __alltraps
c0101fae:	e9 a1 fe ff ff       	jmp    c0101e54 <__alltraps>

c0101fb3 <vector37>:
.globl vector37
vector37:
  pushl $0
c0101fb3:	6a 00                	push   $0x0
  pushl $37
c0101fb5:	6a 25                	push   $0x25
  jmp __alltraps
c0101fb7:	e9 98 fe ff ff       	jmp    c0101e54 <__alltraps>

c0101fbc <vector38>:
.globl vector38
vector38:
  pushl $0
c0101fbc:	6a 00                	push   $0x0
  pushl $38
c0101fbe:	6a 26                	push   $0x26
  jmp __alltraps
c0101fc0:	e9 8f fe ff ff       	jmp    c0101e54 <__alltraps>

c0101fc5 <vector39>:
.globl vector39
vector39:
  pushl $0
c0101fc5:	6a 00                	push   $0x0
  pushl $39
c0101fc7:	6a 27                	push   $0x27
  jmp __alltraps
c0101fc9:	e9 86 fe ff ff       	jmp    c0101e54 <__alltraps>

c0101fce <vector40>:
.globl vector40
vector40:
  pushl $0
c0101fce:	6a 00                	push   $0x0
  pushl $40
c0101fd0:	6a 28                	push   $0x28
  jmp __alltraps
c0101fd2:	e9 7d fe ff ff       	jmp    c0101e54 <__alltraps>

c0101fd7 <vector41>:
.globl vector41
vector41:
  pushl $0
c0101fd7:	6a 00                	push   $0x0
  pushl $41
c0101fd9:	6a 29                	push   $0x29
  jmp __alltraps
c0101fdb:	e9 74 fe ff ff       	jmp    c0101e54 <__alltraps>

c0101fe0 <vector42>:
.globl vector42
vector42:
  pushl $0
c0101fe0:	6a 00                	push   $0x0
  pushl $42
c0101fe2:	6a 2a                	push   $0x2a
  jmp __alltraps
c0101fe4:	e9 6b fe ff ff       	jmp    c0101e54 <__alltraps>

c0101fe9 <vector43>:
.globl vector43
vector43:
  pushl $0
c0101fe9:	6a 00                	push   $0x0
  pushl $43
c0101feb:	6a 2b                	push   $0x2b
  jmp __alltraps
c0101fed:	e9 62 fe ff ff       	jmp    c0101e54 <__alltraps>

c0101ff2 <vector44>:
.globl vector44
vector44:
  pushl $0
c0101ff2:	6a 00                	push   $0x0
  pushl $44
c0101ff4:	6a 2c                	push   $0x2c
  jmp __alltraps
c0101ff6:	e9 59 fe ff ff       	jmp    c0101e54 <__alltraps>

c0101ffb <vector45>:
.globl vector45
vector45:
  pushl $0
c0101ffb:	6a 00                	push   $0x0
  pushl $45
c0101ffd:	6a 2d                	push   $0x2d
  jmp __alltraps
c0101fff:	e9 50 fe ff ff       	jmp    c0101e54 <__alltraps>

c0102004 <vector46>:
.globl vector46
vector46:
  pushl $0
c0102004:	6a 00                	push   $0x0
  pushl $46
c0102006:	6a 2e                	push   $0x2e
  jmp __alltraps
c0102008:	e9 47 fe ff ff       	jmp    c0101e54 <__alltraps>

c010200d <vector47>:
.globl vector47
vector47:
  pushl $0
c010200d:	6a 00                	push   $0x0
  pushl $47
c010200f:	6a 2f                	push   $0x2f
  jmp __alltraps
c0102011:	e9 3e fe ff ff       	jmp    c0101e54 <__alltraps>

c0102016 <vector48>:
.globl vector48
vector48:
  pushl $0
c0102016:	6a 00                	push   $0x0
  pushl $48
c0102018:	6a 30                	push   $0x30
  jmp __alltraps
c010201a:	e9 35 fe ff ff       	jmp    c0101e54 <__alltraps>

c010201f <vector49>:
.globl vector49
vector49:
  pushl $0
c010201f:	6a 00                	push   $0x0
  pushl $49
c0102021:	6a 31                	push   $0x31
  jmp __alltraps
c0102023:	e9 2c fe ff ff       	jmp    c0101e54 <__alltraps>

c0102028 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102028:	6a 00                	push   $0x0
  pushl $50
c010202a:	6a 32                	push   $0x32
  jmp __alltraps
c010202c:	e9 23 fe ff ff       	jmp    c0101e54 <__alltraps>

c0102031 <vector51>:
.globl vector51
vector51:
  pushl $0
c0102031:	6a 00                	push   $0x0
  pushl $51
c0102033:	6a 33                	push   $0x33
  jmp __alltraps
c0102035:	e9 1a fe ff ff       	jmp    c0101e54 <__alltraps>

c010203a <vector52>:
.globl vector52
vector52:
  pushl $0
c010203a:	6a 00                	push   $0x0
  pushl $52
c010203c:	6a 34                	push   $0x34
  jmp __alltraps
c010203e:	e9 11 fe ff ff       	jmp    c0101e54 <__alltraps>

c0102043 <vector53>:
.globl vector53
vector53:
  pushl $0
c0102043:	6a 00                	push   $0x0
  pushl $53
c0102045:	6a 35                	push   $0x35
  jmp __alltraps
c0102047:	e9 08 fe ff ff       	jmp    c0101e54 <__alltraps>

c010204c <vector54>:
.globl vector54
vector54:
  pushl $0
c010204c:	6a 00                	push   $0x0
  pushl $54
c010204e:	6a 36                	push   $0x36
  jmp __alltraps
c0102050:	e9 ff fd ff ff       	jmp    c0101e54 <__alltraps>

c0102055 <vector55>:
.globl vector55
vector55:
  pushl $0
c0102055:	6a 00                	push   $0x0
  pushl $55
c0102057:	6a 37                	push   $0x37
  jmp __alltraps
c0102059:	e9 f6 fd ff ff       	jmp    c0101e54 <__alltraps>

c010205e <vector56>:
.globl vector56
vector56:
  pushl $0
c010205e:	6a 00                	push   $0x0
  pushl $56
c0102060:	6a 38                	push   $0x38
  jmp __alltraps
c0102062:	e9 ed fd ff ff       	jmp    c0101e54 <__alltraps>

c0102067 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102067:	6a 00                	push   $0x0
  pushl $57
c0102069:	6a 39                	push   $0x39
  jmp __alltraps
c010206b:	e9 e4 fd ff ff       	jmp    c0101e54 <__alltraps>

c0102070 <vector58>:
.globl vector58
vector58:
  pushl $0
c0102070:	6a 00                	push   $0x0
  pushl $58
c0102072:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102074:	e9 db fd ff ff       	jmp    c0101e54 <__alltraps>

c0102079 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102079:	6a 00                	push   $0x0
  pushl $59
c010207b:	6a 3b                	push   $0x3b
  jmp __alltraps
c010207d:	e9 d2 fd ff ff       	jmp    c0101e54 <__alltraps>

c0102082 <vector60>:
.globl vector60
vector60:
  pushl $0
c0102082:	6a 00                	push   $0x0
  pushl $60
c0102084:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102086:	e9 c9 fd ff ff       	jmp    c0101e54 <__alltraps>

c010208b <vector61>:
.globl vector61
vector61:
  pushl $0
c010208b:	6a 00                	push   $0x0
  pushl $61
c010208d:	6a 3d                	push   $0x3d
  jmp __alltraps
c010208f:	e9 c0 fd ff ff       	jmp    c0101e54 <__alltraps>

c0102094 <vector62>:
.globl vector62
vector62:
  pushl $0
c0102094:	6a 00                	push   $0x0
  pushl $62
c0102096:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102098:	e9 b7 fd ff ff       	jmp    c0101e54 <__alltraps>

c010209d <vector63>:
.globl vector63
vector63:
  pushl $0
c010209d:	6a 00                	push   $0x0
  pushl $63
c010209f:	6a 3f                	push   $0x3f
  jmp __alltraps
c01020a1:	e9 ae fd ff ff       	jmp    c0101e54 <__alltraps>

c01020a6 <vector64>:
.globl vector64
vector64:
  pushl $0
c01020a6:	6a 00                	push   $0x0
  pushl $64
c01020a8:	6a 40                	push   $0x40
  jmp __alltraps
c01020aa:	e9 a5 fd ff ff       	jmp    c0101e54 <__alltraps>

c01020af <vector65>:
.globl vector65
vector65:
  pushl $0
c01020af:	6a 00                	push   $0x0
  pushl $65
c01020b1:	6a 41                	push   $0x41
  jmp __alltraps
c01020b3:	e9 9c fd ff ff       	jmp    c0101e54 <__alltraps>

c01020b8 <vector66>:
.globl vector66
vector66:
  pushl $0
c01020b8:	6a 00                	push   $0x0
  pushl $66
c01020ba:	6a 42                	push   $0x42
  jmp __alltraps
c01020bc:	e9 93 fd ff ff       	jmp    c0101e54 <__alltraps>

c01020c1 <vector67>:
.globl vector67
vector67:
  pushl $0
c01020c1:	6a 00                	push   $0x0
  pushl $67
c01020c3:	6a 43                	push   $0x43
  jmp __alltraps
c01020c5:	e9 8a fd ff ff       	jmp    c0101e54 <__alltraps>

c01020ca <vector68>:
.globl vector68
vector68:
  pushl $0
c01020ca:	6a 00                	push   $0x0
  pushl $68
c01020cc:	6a 44                	push   $0x44
  jmp __alltraps
c01020ce:	e9 81 fd ff ff       	jmp    c0101e54 <__alltraps>

c01020d3 <vector69>:
.globl vector69
vector69:
  pushl $0
c01020d3:	6a 00                	push   $0x0
  pushl $69
c01020d5:	6a 45                	push   $0x45
  jmp __alltraps
c01020d7:	e9 78 fd ff ff       	jmp    c0101e54 <__alltraps>

c01020dc <vector70>:
.globl vector70
vector70:
  pushl $0
c01020dc:	6a 00                	push   $0x0
  pushl $70
c01020de:	6a 46                	push   $0x46
  jmp __alltraps
c01020e0:	e9 6f fd ff ff       	jmp    c0101e54 <__alltraps>

c01020e5 <vector71>:
.globl vector71
vector71:
  pushl $0
c01020e5:	6a 00                	push   $0x0
  pushl $71
c01020e7:	6a 47                	push   $0x47
  jmp __alltraps
c01020e9:	e9 66 fd ff ff       	jmp    c0101e54 <__alltraps>

c01020ee <vector72>:
.globl vector72
vector72:
  pushl $0
c01020ee:	6a 00                	push   $0x0
  pushl $72
c01020f0:	6a 48                	push   $0x48
  jmp __alltraps
c01020f2:	e9 5d fd ff ff       	jmp    c0101e54 <__alltraps>

c01020f7 <vector73>:
.globl vector73
vector73:
  pushl $0
c01020f7:	6a 00                	push   $0x0
  pushl $73
c01020f9:	6a 49                	push   $0x49
  jmp __alltraps
c01020fb:	e9 54 fd ff ff       	jmp    c0101e54 <__alltraps>

c0102100 <vector74>:
.globl vector74
vector74:
  pushl $0
c0102100:	6a 00                	push   $0x0
  pushl $74
c0102102:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102104:	e9 4b fd ff ff       	jmp    c0101e54 <__alltraps>

c0102109 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102109:	6a 00                	push   $0x0
  pushl $75
c010210b:	6a 4b                	push   $0x4b
  jmp __alltraps
c010210d:	e9 42 fd ff ff       	jmp    c0101e54 <__alltraps>

c0102112 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102112:	6a 00                	push   $0x0
  pushl $76
c0102114:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102116:	e9 39 fd ff ff       	jmp    c0101e54 <__alltraps>

c010211b <vector77>:
.globl vector77
vector77:
  pushl $0
c010211b:	6a 00                	push   $0x0
  pushl $77
c010211d:	6a 4d                	push   $0x4d
  jmp __alltraps
c010211f:	e9 30 fd ff ff       	jmp    c0101e54 <__alltraps>

c0102124 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102124:	6a 00                	push   $0x0
  pushl $78
c0102126:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102128:	e9 27 fd ff ff       	jmp    c0101e54 <__alltraps>

c010212d <vector79>:
.globl vector79
vector79:
  pushl $0
c010212d:	6a 00                	push   $0x0
  pushl $79
c010212f:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102131:	e9 1e fd ff ff       	jmp    c0101e54 <__alltraps>

c0102136 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102136:	6a 00                	push   $0x0
  pushl $80
c0102138:	6a 50                	push   $0x50
  jmp __alltraps
c010213a:	e9 15 fd ff ff       	jmp    c0101e54 <__alltraps>

c010213f <vector81>:
.globl vector81
vector81:
  pushl $0
c010213f:	6a 00                	push   $0x0
  pushl $81
c0102141:	6a 51                	push   $0x51
  jmp __alltraps
c0102143:	e9 0c fd ff ff       	jmp    c0101e54 <__alltraps>

c0102148 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102148:	6a 00                	push   $0x0
  pushl $82
c010214a:	6a 52                	push   $0x52
  jmp __alltraps
c010214c:	e9 03 fd ff ff       	jmp    c0101e54 <__alltraps>

c0102151 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102151:	6a 00                	push   $0x0
  pushl $83
c0102153:	6a 53                	push   $0x53
  jmp __alltraps
c0102155:	e9 fa fc ff ff       	jmp    c0101e54 <__alltraps>

c010215a <vector84>:
.globl vector84
vector84:
  pushl $0
c010215a:	6a 00                	push   $0x0
  pushl $84
c010215c:	6a 54                	push   $0x54
  jmp __alltraps
c010215e:	e9 f1 fc ff ff       	jmp    c0101e54 <__alltraps>

c0102163 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102163:	6a 00                	push   $0x0
  pushl $85
c0102165:	6a 55                	push   $0x55
  jmp __alltraps
c0102167:	e9 e8 fc ff ff       	jmp    c0101e54 <__alltraps>

c010216c <vector86>:
.globl vector86
vector86:
  pushl $0
c010216c:	6a 00                	push   $0x0
  pushl $86
c010216e:	6a 56                	push   $0x56
  jmp __alltraps
c0102170:	e9 df fc ff ff       	jmp    c0101e54 <__alltraps>

c0102175 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102175:	6a 00                	push   $0x0
  pushl $87
c0102177:	6a 57                	push   $0x57
  jmp __alltraps
c0102179:	e9 d6 fc ff ff       	jmp    c0101e54 <__alltraps>

c010217e <vector88>:
.globl vector88
vector88:
  pushl $0
c010217e:	6a 00                	push   $0x0
  pushl $88
c0102180:	6a 58                	push   $0x58
  jmp __alltraps
c0102182:	e9 cd fc ff ff       	jmp    c0101e54 <__alltraps>

c0102187 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102187:	6a 00                	push   $0x0
  pushl $89
c0102189:	6a 59                	push   $0x59
  jmp __alltraps
c010218b:	e9 c4 fc ff ff       	jmp    c0101e54 <__alltraps>

c0102190 <vector90>:
.globl vector90
vector90:
  pushl $0
c0102190:	6a 00                	push   $0x0
  pushl $90
c0102192:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102194:	e9 bb fc ff ff       	jmp    c0101e54 <__alltraps>

c0102199 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102199:	6a 00                	push   $0x0
  pushl $91
c010219b:	6a 5b                	push   $0x5b
  jmp __alltraps
c010219d:	e9 b2 fc ff ff       	jmp    c0101e54 <__alltraps>

c01021a2 <vector92>:
.globl vector92
vector92:
  pushl $0
c01021a2:	6a 00                	push   $0x0
  pushl $92
c01021a4:	6a 5c                	push   $0x5c
  jmp __alltraps
c01021a6:	e9 a9 fc ff ff       	jmp    c0101e54 <__alltraps>

c01021ab <vector93>:
.globl vector93
vector93:
  pushl $0
c01021ab:	6a 00                	push   $0x0
  pushl $93
c01021ad:	6a 5d                	push   $0x5d
  jmp __alltraps
c01021af:	e9 a0 fc ff ff       	jmp    c0101e54 <__alltraps>

c01021b4 <vector94>:
.globl vector94
vector94:
  pushl $0
c01021b4:	6a 00                	push   $0x0
  pushl $94
c01021b6:	6a 5e                	push   $0x5e
  jmp __alltraps
c01021b8:	e9 97 fc ff ff       	jmp    c0101e54 <__alltraps>

c01021bd <vector95>:
.globl vector95
vector95:
  pushl $0
c01021bd:	6a 00                	push   $0x0
  pushl $95
c01021bf:	6a 5f                	push   $0x5f
  jmp __alltraps
c01021c1:	e9 8e fc ff ff       	jmp    c0101e54 <__alltraps>

c01021c6 <vector96>:
.globl vector96
vector96:
  pushl $0
c01021c6:	6a 00                	push   $0x0
  pushl $96
c01021c8:	6a 60                	push   $0x60
  jmp __alltraps
c01021ca:	e9 85 fc ff ff       	jmp    c0101e54 <__alltraps>

c01021cf <vector97>:
.globl vector97
vector97:
  pushl $0
c01021cf:	6a 00                	push   $0x0
  pushl $97
c01021d1:	6a 61                	push   $0x61
  jmp __alltraps
c01021d3:	e9 7c fc ff ff       	jmp    c0101e54 <__alltraps>

c01021d8 <vector98>:
.globl vector98
vector98:
  pushl $0
c01021d8:	6a 00                	push   $0x0
  pushl $98
c01021da:	6a 62                	push   $0x62
  jmp __alltraps
c01021dc:	e9 73 fc ff ff       	jmp    c0101e54 <__alltraps>

c01021e1 <vector99>:
.globl vector99
vector99:
  pushl $0
c01021e1:	6a 00                	push   $0x0
  pushl $99
c01021e3:	6a 63                	push   $0x63
  jmp __alltraps
c01021e5:	e9 6a fc ff ff       	jmp    c0101e54 <__alltraps>

c01021ea <vector100>:
.globl vector100
vector100:
  pushl $0
c01021ea:	6a 00                	push   $0x0
  pushl $100
c01021ec:	6a 64                	push   $0x64
  jmp __alltraps
c01021ee:	e9 61 fc ff ff       	jmp    c0101e54 <__alltraps>

c01021f3 <vector101>:
.globl vector101
vector101:
  pushl $0
c01021f3:	6a 00                	push   $0x0
  pushl $101
c01021f5:	6a 65                	push   $0x65
  jmp __alltraps
c01021f7:	e9 58 fc ff ff       	jmp    c0101e54 <__alltraps>

c01021fc <vector102>:
.globl vector102
vector102:
  pushl $0
c01021fc:	6a 00                	push   $0x0
  pushl $102
c01021fe:	6a 66                	push   $0x66
  jmp __alltraps
c0102200:	e9 4f fc ff ff       	jmp    c0101e54 <__alltraps>

c0102205 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102205:	6a 00                	push   $0x0
  pushl $103
c0102207:	6a 67                	push   $0x67
  jmp __alltraps
c0102209:	e9 46 fc ff ff       	jmp    c0101e54 <__alltraps>

c010220e <vector104>:
.globl vector104
vector104:
  pushl $0
c010220e:	6a 00                	push   $0x0
  pushl $104
c0102210:	6a 68                	push   $0x68
  jmp __alltraps
c0102212:	e9 3d fc ff ff       	jmp    c0101e54 <__alltraps>

c0102217 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102217:	6a 00                	push   $0x0
  pushl $105
c0102219:	6a 69                	push   $0x69
  jmp __alltraps
c010221b:	e9 34 fc ff ff       	jmp    c0101e54 <__alltraps>

c0102220 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102220:	6a 00                	push   $0x0
  pushl $106
c0102222:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102224:	e9 2b fc ff ff       	jmp    c0101e54 <__alltraps>

c0102229 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102229:	6a 00                	push   $0x0
  pushl $107
c010222b:	6a 6b                	push   $0x6b
  jmp __alltraps
c010222d:	e9 22 fc ff ff       	jmp    c0101e54 <__alltraps>

c0102232 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102232:	6a 00                	push   $0x0
  pushl $108
c0102234:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102236:	e9 19 fc ff ff       	jmp    c0101e54 <__alltraps>

c010223b <vector109>:
.globl vector109
vector109:
  pushl $0
c010223b:	6a 00                	push   $0x0
  pushl $109
c010223d:	6a 6d                	push   $0x6d
  jmp __alltraps
c010223f:	e9 10 fc ff ff       	jmp    c0101e54 <__alltraps>

c0102244 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102244:	6a 00                	push   $0x0
  pushl $110
c0102246:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102248:	e9 07 fc ff ff       	jmp    c0101e54 <__alltraps>

c010224d <vector111>:
.globl vector111
vector111:
  pushl $0
c010224d:	6a 00                	push   $0x0
  pushl $111
c010224f:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102251:	e9 fe fb ff ff       	jmp    c0101e54 <__alltraps>

c0102256 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102256:	6a 00                	push   $0x0
  pushl $112
c0102258:	6a 70                	push   $0x70
  jmp __alltraps
c010225a:	e9 f5 fb ff ff       	jmp    c0101e54 <__alltraps>

c010225f <vector113>:
.globl vector113
vector113:
  pushl $0
c010225f:	6a 00                	push   $0x0
  pushl $113
c0102261:	6a 71                	push   $0x71
  jmp __alltraps
c0102263:	e9 ec fb ff ff       	jmp    c0101e54 <__alltraps>

c0102268 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102268:	6a 00                	push   $0x0
  pushl $114
c010226a:	6a 72                	push   $0x72
  jmp __alltraps
c010226c:	e9 e3 fb ff ff       	jmp    c0101e54 <__alltraps>

c0102271 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102271:	6a 00                	push   $0x0
  pushl $115
c0102273:	6a 73                	push   $0x73
  jmp __alltraps
c0102275:	e9 da fb ff ff       	jmp    c0101e54 <__alltraps>

c010227a <vector116>:
.globl vector116
vector116:
  pushl $0
c010227a:	6a 00                	push   $0x0
  pushl $116
c010227c:	6a 74                	push   $0x74
  jmp __alltraps
c010227e:	e9 d1 fb ff ff       	jmp    c0101e54 <__alltraps>

c0102283 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102283:	6a 00                	push   $0x0
  pushl $117
c0102285:	6a 75                	push   $0x75
  jmp __alltraps
c0102287:	e9 c8 fb ff ff       	jmp    c0101e54 <__alltraps>

c010228c <vector118>:
.globl vector118
vector118:
  pushl $0
c010228c:	6a 00                	push   $0x0
  pushl $118
c010228e:	6a 76                	push   $0x76
  jmp __alltraps
c0102290:	e9 bf fb ff ff       	jmp    c0101e54 <__alltraps>

c0102295 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102295:	6a 00                	push   $0x0
  pushl $119
c0102297:	6a 77                	push   $0x77
  jmp __alltraps
c0102299:	e9 b6 fb ff ff       	jmp    c0101e54 <__alltraps>

c010229e <vector120>:
.globl vector120
vector120:
  pushl $0
c010229e:	6a 00                	push   $0x0
  pushl $120
c01022a0:	6a 78                	push   $0x78
  jmp __alltraps
c01022a2:	e9 ad fb ff ff       	jmp    c0101e54 <__alltraps>

c01022a7 <vector121>:
.globl vector121
vector121:
  pushl $0
c01022a7:	6a 00                	push   $0x0
  pushl $121
c01022a9:	6a 79                	push   $0x79
  jmp __alltraps
c01022ab:	e9 a4 fb ff ff       	jmp    c0101e54 <__alltraps>

c01022b0 <vector122>:
.globl vector122
vector122:
  pushl $0
c01022b0:	6a 00                	push   $0x0
  pushl $122
c01022b2:	6a 7a                	push   $0x7a
  jmp __alltraps
c01022b4:	e9 9b fb ff ff       	jmp    c0101e54 <__alltraps>

c01022b9 <vector123>:
.globl vector123
vector123:
  pushl $0
c01022b9:	6a 00                	push   $0x0
  pushl $123
c01022bb:	6a 7b                	push   $0x7b
  jmp __alltraps
c01022bd:	e9 92 fb ff ff       	jmp    c0101e54 <__alltraps>

c01022c2 <vector124>:
.globl vector124
vector124:
  pushl $0
c01022c2:	6a 00                	push   $0x0
  pushl $124
c01022c4:	6a 7c                	push   $0x7c
  jmp __alltraps
c01022c6:	e9 89 fb ff ff       	jmp    c0101e54 <__alltraps>

c01022cb <vector125>:
.globl vector125
vector125:
  pushl $0
c01022cb:	6a 00                	push   $0x0
  pushl $125
c01022cd:	6a 7d                	push   $0x7d
  jmp __alltraps
c01022cf:	e9 80 fb ff ff       	jmp    c0101e54 <__alltraps>

c01022d4 <vector126>:
.globl vector126
vector126:
  pushl $0
c01022d4:	6a 00                	push   $0x0
  pushl $126
c01022d6:	6a 7e                	push   $0x7e
  jmp __alltraps
c01022d8:	e9 77 fb ff ff       	jmp    c0101e54 <__alltraps>

c01022dd <vector127>:
.globl vector127
vector127:
  pushl $0
c01022dd:	6a 00                	push   $0x0
  pushl $127
c01022df:	6a 7f                	push   $0x7f
  jmp __alltraps
c01022e1:	e9 6e fb ff ff       	jmp    c0101e54 <__alltraps>

c01022e6 <vector128>:
.globl vector128
vector128:
  pushl $0
c01022e6:	6a 00                	push   $0x0
  pushl $128
c01022e8:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c01022ed:	e9 62 fb ff ff       	jmp    c0101e54 <__alltraps>

c01022f2 <vector129>:
.globl vector129
vector129:
  pushl $0
c01022f2:	6a 00                	push   $0x0
  pushl $129
c01022f4:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c01022f9:	e9 56 fb ff ff       	jmp    c0101e54 <__alltraps>

c01022fe <vector130>:
.globl vector130
vector130:
  pushl $0
c01022fe:	6a 00                	push   $0x0
  pushl $130
c0102300:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102305:	e9 4a fb ff ff       	jmp    c0101e54 <__alltraps>

c010230a <vector131>:
.globl vector131
vector131:
  pushl $0
c010230a:	6a 00                	push   $0x0
  pushl $131
c010230c:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102311:	e9 3e fb ff ff       	jmp    c0101e54 <__alltraps>

c0102316 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102316:	6a 00                	push   $0x0
  pushl $132
c0102318:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c010231d:	e9 32 fb ff ff       	jmp    c0101e54 <__alltraps>

c0102322 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102322:	6a 00                	push   $0x0
  pushl $133
c0102324:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102329:	e9 26 fb ff ff       	jmp    c0101e54 <__alltraps>

c010232e <vector134>:
.globl vector134
vector134:
  pushl $0
c010232e:	6a 00                	push   $0x0
  pushl $134
c0102330:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102335:	e9 1a fb ff ff       	jmp    c0101e54 <__alltraps>

c010233a <vector135>:
.globl vector135
vector135:
  pushl $0
c010233a:	6a 00                	push   $0x0
  pushl $135
c010233c:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102341:	e9 0e fb ff ff       	jmp    c0101e54 <__alltraps>

c0102346 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102346:	6a 00                	push   $0x0
  pushl $136
c0102348:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c010234d:	e9 02 fb ff ff       	jmp    c0101e54 <__alltraps>

c0102352 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102352:	6a 00                	push   $0x0
  pushl $137
c0102354:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102359:	e9 f6 fa ff ff       	jmp    c0101e54 <__alltraps>

c010235e <vector138>:
.globl vector138
vector138:
  pushl $0
c010235e:	6a 00                	push   $0x0
  pushl $138
c0102360:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102365:	e9 ea fa ff ff       	jmp    c0101e54 <__alltraps>

c010236a <vector139>:
.globl vector139
vector139:
  pushl $0
c010236a:	6a 00                	push   $0x0
  pushl $139
c010236c:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102371:	e9 de fa ff ff       	jmp    c0101e54 <__alltraps>

c0102376 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102376:	6a 00                	push   $0x0
  pushl $140
c0102378:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c010237d:	e9 d2 fa ff ff       	jmp    c0101e54 <__alltraps>

c0102382 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102382:	6a 00                	push   $0x0
  pushl $141
c0102384:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102389:	e9 c6 fa ff ff       	jmp    c0101e54 <__alltraps>

c010238e <vector142>:
.globl vector142
vector142:
  pushl $0
c010238e:	6a 00                	push   $0x0
  pushl $142
c0102390:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102395:	e9 ba fa ff ff       	jmp    c0101e54 <__alltraps>

c010239a <vector143>:
.globl vector143
vector143:
  pushl $0
c010239a:	6a 00                	push   $0x0
  pushl $143
c010239c:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c01023a1:	e9 ae fa ff ff       	jmp    c0101e54 <__alltraps>

c01023a6 <vector144>:
.globl vector144
vector144:
  pushl $0
c01023a6:	6a 00                	push   $0x0
  pushl $144
c01023a8:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c01023ad:	e9 a2 fa ff ff       	jmp    c0101e54 <__alltraps>

c01023b2 <vector145>:
.globl vector145
vector145:
  pushl $0
c01023b2:	6a 00                	push   $0x0
  pushl $145
c01023b4:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c01023b9:	e9 96 fa ff ff       	jmp    c0101e54 <__alltraps>

c01023be <vector146>:
.globl vector146
vector146:
  pushl $0
c01023be:	6a 00                	push   $0x0
  pushl $146
c01023c0:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c01023c5:	e9 8a fa ff ff       	jmp    c0101e54 <__alltraps>

c01023ca <vector147>:
.globl vector147
vector147:
  pushl $0
c01023ca:	6a 00                	push   $0x0
  pushl $147
c01023cc:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c01023d1:	e9 7e fa ff ff       	jmp    c0101e54 <__alltraps>

c01023d6 <vector148>:
.globl vector148
vector148:
  pushl $0
c01023d6:	6a 00                	push   $0x0
  pushl $148
c01023d8:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c01023dd:	e9 72 fa ff ff       	jmp    c0101e54 <__alltraps>

c01023e2 <vector149>:
.globl vector149
vector149:
  pushl $0
c01023e2:	6a 00                	push   $0x0
  pushl $149
c01023e4:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c01023e9:	e9 66 fa ff ff       	jmp    c0101e54 <__alltraps>

c01023ee <vector150>:
.globl vector150
vector150:
  pushl $0
c01023ee:	6a 00                	push   $0x0
  pushl $150
c01023f0:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c01023f5:	e9 5a fa ff ff       	jmp    c0101e54 <__alltraps>

c01023fa <vector151>:
.globl vector151
vector151:
  pushl $0
c01023fa:	6a 00                	push   $0x0
  pushl $151
c01023fc:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102401:	e9 4e fa ff ff       	jmp    c0101e54 <__alltraps>

c0102406 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102406:	6a 00                	push   $0x0
  pushl $152
c0102408:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c010240d:	e9 42 fa ff ff       	jmp    c0101e54 <__alltraps>

c0102412 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102412:	6a 00                	push   $0x0
  pushl $153
c0102414:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102419:	e9 36 fa ff ff       	jmp    c0101e54 <__alltraps>

c010241e <vector154>:
.globl vector154
vector154:
  pushl $0
c010241e:	6a 00                	push   $0x0
  pushl $154
c0102420:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102425:	e9 2a fa ff ff       	jmp    c0101e54 <__alltraps>

c010242a <vector155>:
.globl vector155
vector155:
  pushl $0
c010242a:	6a 00                	push   $0x0
  pushl $155
c010242c:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102431:	e9 1e fa ff ff       	jmp    c0101e54 <__alltraps>

c0102436 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102436:	6a 00                	push   $0x0
  pushl $156
c0102438:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c010243d:	e9 12 fa ff ff       	jmp    c0101e54 <__alltraps>

c0102442 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102442:	6a 00                	push   $0x0
  pushl $157
c0102444:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102449:	e9 06 fa ff ff       	jmp    c0101e54 <__alltraps>

c010244e <vector158>:
.globl vector158
vector158:
  pushl $0
c010244e:	6a 00                	push   $0x0
  pushl $158
c0102450:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102455:	e9 fa f9 ff ff       	jmp    c0101e54 <__alltraps>

c010245a <vector159>:
.globl vector159
vector159:
  pushl $0
c010245a:	6a 00                	push   $0x0
  pushl $159
c010245c:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102461:	e9 ee f9 ff ff       	jmp    c0101e54 <__alltraps>

c0102466 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102466:	6a 00                	push   $0x0
  pushl $160
c0102468:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c010246d:	e9 e2 f9 ff ff       	jmp    c0101e54 <__alltraps>

c0102472 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102472:	6a 00                	push   $0x0
  pushl $161
c0102474:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102479:	e9 d6 f9 ff ff       	jmp    c0101e54 <__alltraps>

c010247e <vector162>:
.globl vector162
vector162:
  pushl $0
c010247e:	6a 00                	push   $0x0
  pushl $162
c0102480:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102485:	e9 ca f9 ff ff       	jmp    c0101e54 <__alltraps>

c010248a <vector163>:
.globl vector163
vector163:
  pushl $0
c010248a:	6a 00                	push   $0x0
  pushl $163
c010248c:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102491:	e9 be f9 ff ff       	jmp    c0101e54 <__alltraps>

c0102496 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102496:	6a 00                	push   $0x0
  pushl $164
c0102498:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c010249d:	e9 b2 f9 ff ff       	jmp    c0101e54 <__alltraps>

c01024a2 <vector165>:
.globl vector165
vector165:
  pushl $0
c01024a2:	6a 00                	push   $0x0
  pushl $165
c01024a4:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c01024a9:	e9 a6 f9 ff ff       	jmp    c0101e54 <__alltraps>

c01024ae <vector166>:
.globl vector166
vector166:
  pushl $0
c01024ae:	6a 00                	push   $0x0
  pushl $166
c01024b0:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c01024b5:	e9 9a f9 ff ff       	jmp    c0101e54 <__alltraps>

c01024ba <vector167>:
.globl vector167
vector167:
  pushl $0
c01024ba:	6a 00                	push   $0x0
  pushl $167
c01024bc:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c01024c1:	e9 8e f9 ff ff       	jmp    c0101e54 <__alltraps>

c01024c6 <vector168>:
.globl vector168
vector168:
  pushl $0
c01024c6:	6a 00                	push   $0x0
  pushl $168
c01024c8:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c01024cd:	e9 82 f9 ff ff       	jmp    c0101e54 <__alltraps>

c01024d2 <vector169>:
.globl vector169
vector169:
  pushl $0
c01024d2:	6a 00                	push   $0x0
  pushl $169
c01024d4:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c01024d9:	e9 76 f9 ff ff       	jmp    c0101e54 <__alltraps>

c01024de <vector170>:
.globl vector170
vector170:
  pushl $0
c01024de:	6a 00                	push   $0x0
  pushl $170
c01024e0:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c01024e5:	e9 6a f9 ff ff       	jmp    c0101e54 <__alltraps>

c01024ea <vector171>:
.globl vector171
vector171:
  pushl $0
c01024ea:	6a 00                	push   $0x0
  pushl $171
c01024ec:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c01024f1:	e9 5e f9 ff ff       	jmp    c0101e54 <__alltraps>

c01024f6 <vector172>:
.globl vector172
vector172:
  pushl $0
c01024f6:	6a 00                	push   $0x0
  pushl $172
c01024f8:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c01024fd:	e9 52 f9 ff ff       	jmp    c0101e54 <__alltraps>

c0102502 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102502:	6a 00                	push   $0x0
  pushl $173
c0102504:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102509:	e9 46 f9 ff ff       	jmp    c0101e54 <__alltraps>

c010250e <vector174>:
.globl vector174
vector174:
  pushl $0
c010250e:	6a 00                	push   $0x0
  pushl $174
c0102510:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102515:	e9 3a f9 ff ff       	jmp    c0101e54 <__alltraps>

c010251a <vector175>:
.globl vector175
vector175:
  pushl $0
c010251a:	6a 00                	push   $0x0
  pushl $175
c010251c:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102521:	e9 2e f9 ff ff       	jmp    c0101e54 <__alltraps>

c0102526 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102526:	6a 00                	push   $0x0
  pushl $176
c0102528:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c010252d:	e9 22 f9 ff ff       	jmp    c0101e54 <__alltraps>

c0102532 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102532:	6a 00                	push   $0x0
  pushl $177
c0102534:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102539:	e9 16 f9 ff ff       	jmp    c0101e54 <__alltraps>

c010253e <vector178>:
.globl vector178
vector178:
  pushl $0
c010253e:	6a 00                	push   $0x0
  pushl $178
c0102540:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102545:	e9 0a f9 ff ff       	jmp    c0101e54 <__alltraps>

c010254a <vector179>:
.globl vector179
vector179:
  pushl $0
c010254a:	6a 00                	push   $0x0
  pushl $179
c010254c:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102551:	e9 fe f8 ff ff       	jmp    c0101e54 <__alltraps>

c0102556 <vector180>:
.globl vector180
vector180:
  pushl $0
c0102556:	6a 00                	push   $0x0
  pushl $180
c0102558:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c010255d:	e9 f2 f8 ff ff       	jmp    c0101e54 <__alltraps>

c0102562 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102562:	6a 00                	push   $0x0
  pushl $181
c0102564:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102569:	e9 e6 f8 ff ff       	jmp    c0101e54 <__alltraps>

c010256e <vector182>:
.globl vector182
vector182:
  pushl $0
c010256e:	6a 00                	push   $0x0
  pushl $182
c0102570:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102575:	e9 da f8 ff ff       	jmp    c0101e54 <__alltraps>

c010257a <vector183>:
.globl vector183
vector183:
  pushl $0
c010257a:	6a 00                	push   $0x0
  pushl $183
c010257c:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102581:	e9 ce f8 ff ff       	jmp    c0101e54 <__alltraps>

c0102586 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102586:	6a 00                	push   $0x0
  pushl $184
c0102588:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c010258d:	e9 c2 f8 ff ff       	jmp    c0101e54 <__alltraps>

c0102592 <vector185>:
.globl vector185
vector185:
  pushl $0
c0102592:	6a 00                	push   $0x0
  pushl $185
c0102594:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102599:	e9 b6 f8 ff ff       	jmp    c0101e54 <__alltraps>

c010259e <vector186>:
.globl vector186
vector186:
  pushl $0
c010259e:	6a 00                	push   $0x0
  pushl $186
c01025a0:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c01025a5:	e9 aa f8 ff ff       	jmp    c0101e54 <__alltraps>

c01025aa <vector187>:
.globl vector187
vector187:
  pushl $0
c01025aa:	6a 00                	push   $0x0
  pushl $187
c01025ac:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c01025b1:	e9 9e f8 ff ff       	jmp    c0101e54 <__alltraps>

c01025b6 <vector188>:
.globl vector188
vector188:
  pushl $0
c01025b6:	6a 00                	push   $0x0
  pushl $188
c01025b8:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c01025bd:	e9 92 f8 ff ff       	jmp    c0101e54 <__alltraps>

c01025c2 <vector189>:
.globl vector189
vector189:
  pushl $0
c01025c2:	6a 00                	push   $0x0
  pushl $189
c01025c4:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c01025c9:	e9 86 f8 ff ff       	jmp    c0101e54 <__alltraps>

c01025ce <vector190>:
.globl vector190
vector190:
  pushl $0
c01025ce:	6a 00                	push   $0x0
  pushl $190
c01025d0:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c01025d5:	e9 7a f8 ff ff       	jmp    c0101e54 <__alltraps>

c01025da <vector191>:
.globl vector191
vector191:
  pushl $0
c01025da:	6a 00                	push   $0x0
  pushl $191
c01025dc:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c01025e1:	e9 6e f8 ff ff       	jmp    c0101e54 <__alltraps>

c01025e6 <vector192>:
.globl vector192
vector192:
  pushl $0
c01025e6:	6a 00                	push   $0x0
  pushl $192
c01025e8:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c01025ed:	e9 62 f8 ff ff       	jmp    c0101e54 <__alltraps>

c01025f2 <vector193>:
.globl vector193
vector193:
  pushl $0
c01025f2:	6a 00                	push   $0x0
  pushl $193
c01025f4:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c01025f9:	e9 56 f8 ff ff       	jmp    c0101e54 <__alltraps>

c01025fe <vector194>:
.globl vector194
vector194:
  pushl $0
c01025fe:	6a 00                	push   $0x0
  pushl $194
c0102600:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102605:	e9 4a f8 ff ff       	jmp    c0101e54 <__alltraps>

c010260a <vector195>:
.globl vector195
vector195:
  pushl $0
c010260a:	6a 00                	push   $0x0
  pushl $195
c010260c:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102611:	e9 3e f8 ff ff       	jmp    c0101e54 <__alltraps>

c0102616 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102616:	6a 00                	push   $0x0
  pushl $196
c0102618:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c010261d:	e9 32 f8 ff ff       	jmp    c0101e54 <__alltraps>

c0102622 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102622:	6a 00                	push   $0x0
  pushl $197
c0102624:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102629:	e9 26 f8 ff ff       	jmp    c0101e54 <__alltraps>

c010262e <vector198>:
.globl vector198
vector198:
  pushl $0
c010262e:	6a 00                	push   $0x0
  pushl $198
c0102630:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102635:	e9 1a f8 ff ff       	jmp    c0101e54 <__alltraps>

c010263a <vector199>:
.globl vector199
vector199:
  pushl $0
c010263a:	6a 00                	push   $0x0
  pushl $199
c010263c:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102641:	e9 0e f8 ff ff       	jmp    c0101e54 <__alltraps>

c0102646 <vector200>:
.globl vector200
vector200:
  pushl $0
c0102646:	6a 00                	push   $0x0
  pushl $200
c0102648:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c010264d:	e9 02 f8 ff ff       	jmp    c0101e54 <__alltraps>

c0102652 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102652:	6a 00                	push   $0x0
  pushl $201
c0102654:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102659:	e9 f6 f7 ff ff       	jmp    c0101e54 <__alltraps>

c010265e <vector202>:
.globl vector202
vector202:
  pushl $0
c010265e:	6a 00                	push   $0x0
  pushl $202
c0102660:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102665:	e9 ea f7 ff ff       	jmp    c0101e54 <__alltraps>

c010266a <vector203>:
.globl vector203
vector203:
  pushl $0
c010266a:	6a 00                	push   $0x0
  pushl $203
c010266c:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102671:	e9 de f7 ff ff       	jmp    c0101e54 <__alltraps>

c0102676 <vector204>:
.globl vector204
vector204:
  pushl $0
c0102676:	6a 00                	push   $0x0
  pushl $204
c0102678:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c010267d:	e9 d2 f7 ff ff       	jmp    c0101e54 <__alltraps>

c0102682 <vector205>:
.globl vector205
vector205:
  pushl $0
c0102682:	6a 00                	push   $0x0
  pushl $205
c0102684:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102689:	e9 c6 f7 ff ff       	jmp    c0101e54 <__alltraps>

c010268e <vector206>:
.globl vector206
vector206:
  pushl $0
c010268e:	6a 00                	push   $0x0
  pushl $206
c0102690:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0102695:	e9 ba f7 ff ff       	jmp    c0101e54 <__alltraps>

c010269a <vector207>:
.globl vector207
vector207:
  pushl $0
c010269a:	6a 00                	push   $0x0
  pushl $207
c010269c:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c01026a1:	e9 ae f7 ff ff       	jmp    c0101e54 <__alltraps>

c01026a6 <vector208>:
.globl vector208
vector208:
  pushl $0
c01026a6:	6a 00                	push   $0x0
  pushl $208
c01026a8:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c01026ad:	e9 a2 f7 ff ff       	jmp    c0101e54 <__alltraps>

c01026b2 <vector209>:
.globl vector209
vector209:
  pushl $0
c01026b2:	6a 00                	push   $0x0
  pushl $209
c01026b4:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c01026b9:	e9 96 f7 ff ff       	jmp    c0101e54 <__alltraps>

c01026be <vector210>:
.globl vector210
vector210:
  pushl $0
c01026be:	6a 00                	push   $0x0
  pushl $210
c01026c0:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c01026c5:	e9 8a f7 ff ff       	jmp    c0101e54 <__alltraps>

c01026ca <vector211>:
.globl vector211
vector211:
  pushl $0
c01026ca:	6a 00                	push   $0x0
  pushl $211
c01026cc:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c01026d1:	e9 7e f7 ff ff       	jmp    c0101e54 <__alltraps>

c01026d6 <vector212>:
.globl vector212
vector212:
  pushl $0
c01026d6:	6a 00                	push   $0x0
  pushl $212
c01026d8:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c01026dd:	e9 72 f7 ff ff       	jmp    c0101e54 <__alltraps>

c01026e2 <vector213>:
.globl vector213
vector213:
  pushl $0
c01026e2:	6a 00                	push   $0x0
  pushl $213
c01026e4:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c01026e9:	e9 66 f7 ff ff       	jmp    c0101e54 <__alltraps>

c01026ee <vector214>:
.globl vector214
vector214:
  pushl $0
c01026ee:	6a 00                	push   $0x0
  pushl $214
c01026f0:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c01026f5:	e9 5a f7 ff ff       	jmp    c0101e54 <__alltraps>

c01026fa <vector215>:
.globl vector215
vector215:
  pushl $0
c01026fa:	6a 00                	push   $0x0
  pushl $215
c01026fc:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0102701:	e9 4e f7 ff ff       	jmp    c0101e54 <__alltraps>

c0102706 <vector216>:
.globl vector216
vector216:
  pushl $0
c0102706:	6a 00                	push   $0x0
  pushl $216
c0102708:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c010270d:	e9 42 f7 ff ff       	jmp    c0101e54 <__alltraps>

c0102712 <vector217>:
.globl vector217
vector217:
  pushl $0
c0102712:	6a 00                	push   $0x0
  pushl $217
c0102714:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102719:	e9 36 f7 ff ff       	jmp    c0101e54 <__alltraps>

c010271e <vector218>:
.globl vector218
vector218:
  pushl $0
c010271e:	6a 00                	push   $0x0
  pushl $218
c0102720:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0102725:	e9 2a f7 ff ff       	jmp    c0101e54 <__alltraps>

c010272a <vector219>:
.globl vector219
vector219:
  pushl $0
c010272a:	6a 00                	push   $0x0
  pushl $219
c010272c:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0102731:	e9 1e f7 ff ff       	jmp    c0101e54 <__alltraps>

c0102736 <vector220>:
.globl vector220
vector220:
  pushl $0
c0102736:	6a 00                	push   $0x0
  pushl $220
c0102738:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c010273d:	e9 12 f7 ff ff       	jmp    c0101e54 <__alltraps>

c0102742 <vector221>:
.globl vector221
vector221:
  pushl $0
c0102742:	6a 00                	push   $0x0
  pushl $221
c0102744:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102749:	e9 06 f7 ff ff       	jmp    c0101e54 <__alltraps>

c010274e <vector222>:
.globl vector222
vector222:
  pushl $0
c010274e:	6a 00                	push   $0x0
  pushl $222
c0102750:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0102755:	e9 fa f6 ff ff       	jmp    c0101e54 <__alltraps>

c010275a <vector223>:
.globl vector223
vector223:
  pushl $0
c010275a:	6a 00                	push   $0x0
  pushl $223
c010275c:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0102761:	e9 ee f6 ff ff       	jmp    c0101e54 <__alltraps>

c0102766 <vector224>:
.globl vector224
vector224:
  pushl $0
c0102766:	6a 00                	push   $0x0
  pushl $224
c0102768:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c010276d:	e9 e2 f6 ff ff       	jmp    c0101e54 <__alltraps>

c0102772 <vector225>:
.globl vector225
vector225:
  pushl $0
c0102772:	6a 00                	push   $0x0
  pushl $225
c0102774:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0102779:	e9 d6 f6 ff ff       	jmp    c0101e54 <__alltraps>

c010277e <vector226>:
.globl vector226
vector226:
  pushl $0
c010277e:	6a 00                	push   $0x0
  pushl $226
c0102780:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0102785:	e9 ca f6 ff ff       	jmp    c0101e54 <__alltraps>

c010278a <vector227>:
.globl vector227
vector227:
  pushl $0
c010278a:	6a 00                	push   $0x0
  pushl $227
c010278c:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0102791:	e9 be f6 ff ff       	jmp    c0101e54 <__alltraps>

c0102796 <vector228>:
.globl vector228
vector228:
  pushl $0
c0102796:	6a 00                	push   $0x0
  pushl $228
c0102798:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c010279d:	e9 b2 f6 ff ff       	jmp    c0101e54 <__alltraps>

c01027a2 <vector229>:
.globl vector229
vector229:
  pushl $0
c01027a2:	6a 00                	push   $0x0
  pushl $229
c01027a4:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01027a9:	e9 a6 f6 ff ff       	jmp    c0101e54 <__alltraps>

c01027ae <vector230>:
.globl vector230
vector230:
  pushl $0
c01027ae:	6a 00                	push   $0x0
  pushl $230
c01027b0:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c01027b5:	e9 9a f6 ff ff       	jmp    c0101e54 <__alltraps>

c01027ba <vector231>:
.globl vector231
vector231:
  pushl $0
c01027ba:	6a 00                	push   $0x0
  pushl $231
c01027bc:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c01027c1:	e9 8e f6 ff ff       	jmp    c0101e54 <__alltraps>

c01027c6 <vector232>:
.globl vector232
vector232:
  pushl $0
c01027c6:	6a 00                	push   $0x0
  pushl $232
c01027c8:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c01027cd:	e9 82 f6 ff ff       	jmp    c0101e54 <__alltraps>

c01027d2 <vector233>:
.globl vector233
vector233:
  pushl $0
c01027d2:	6a 00                	push   $0x0
  pushl $233
c01027d4:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c01027d9:	e9 76 f6 ff ff       	jmp    c0101e54 <__alltraps>

c01027de <vector234>:
.globl vector234
vector234:
  pushl $0
c01027de:	6a 00                	push   $0x0
  pushl $234
c01027e0:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c01027e5:	e9 6a f6 ff ff       	jmp    c0101e54 <__alltraps>

c01027ea <vector235>:
.globl vector235
vector235:
  pushl $0
c01027ea:	6a 00                	push   $0x0
  pushl $235
c01027ec:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c01027f1:	e9 5e f6 ff ff       	jmp    c0101e54 <__alltraps>

c01027f6 <vector236>:
.globl vector236
vector236:
  pushl $0
c01027f6:	6a 00                	push   $0x0
  pushl $236
c01027f8:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c01027fd:	e9 52 f6 ff ff       	jmp    c0101e54 <__alltraps>

c0102802 <vector237>:
.globl vector237
vector237:
  pushl $0
c0102802:	6a 00                	push   $0x0
  pushl $237
c0102804:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0102809:	e9 46 f6 ff ff       	jmp    c0101e54 <__alltraps>

c010280e <vector238>:
.globl vector238
vector238:
  pushl $0
c010280e:	6a 00                	push   $0x0
  pushl $238
c0102810:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0102815:	e9 3a f6 ff ff       	jmp    c0101e54 <__alltraps>

c010281a <vector239>:
.globl vector239
vector239:
  pushl $0
c010281a:	6a 00                	push   $0x0
  pushl $239
c010281c:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0102821:	e9 2e f6 ff ff       	jmp    c0101e54 <__alltraps>

c0102826 <vector240>:
.globl vector240
vector240:
  pushl $0
c0102826:	6a 00                	push   $0x0
  pushl $240
c0102828:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c010282d:	e9 22 f6 ff ff       	jmp    c0101e54 <__alltraps>

c0102832 <vector241>:
.globl vector241
vector241:
  pushl $0
c0102832:	6a 00                	push   $0x0
  pushl $241
c0102834:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102839:	e9 16 f6 ff ff       	jmp    c0101e54 <__alltraps>

c010283e <vector242>:
.globl vector242
vector242:
  pushl $0
c010283e:	6a 00                	push   $0x0
  pushl $242
c0102840:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0102845:	e9 0a f6 ff ff       	jmp    c0101e54 <__alltraps>

c010284a <vector243>:
.globl vector243
vector243:
  pushl $0
c010284a:	6a 00                	push   $0x0
  pushl $243
c010284c:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0102851:	e9 fe f5 ff ff       	jmp    c0101e54 <__alltraps>

c0102856 <vector244>:
.globl vector244
vector244:
  pushl $0
c0102856:	6a 00                	push   $0x0
  pushl $244
c0102858:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c010285d:	e9 f2 f5 ff ff       	jmp    c0101e54 <__alltraps>

c0102862 <vector245>:
.globl vector245
vector245:
  pushl $0
c0102862:	6a 00                	push   $0x0
  pushl $245
c0102864:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0102869:	e9 e6 f5 ff ff       	jmp    c0101e54 <__alltraps>

c010286e <vector246>:
.globl vector246
vector246:
  pushl $0
c010286e:	6a 00                	push   $0x0
  pushl $246
c0102870:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0102875:	e9 da f5 ff ff       	jmp    c0101e54 <__alltraps>

c010287a <vector247>:
.globl vector247
vector247:
  pushl $0
c010287a:	6a 00                	push   $0x0
  pushl $247
c010287c:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0102881:	e9 ce f5 ff ff       	jmp    c0101e54 <__alltraps>

c0102886 <vector248>:
.globl vector248
vector248:
  pushl $0
c0102886:	6a 00                	push   $0x0
  pushl $248
c0102888:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c010288d:	e9 c2 f5 ff ff       	jmp    c0101e54 <__alltraps>

c0102892 <vector249>:
.globl vector249
vector249:
  pushl $0
c0102892:	6a 00                	push   $0x0
  pushl $249
c0102894:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0102899:	e9 b6 f5 ff ff       	jmp    c0101e54 <__alltraps>

c010289e <vector250>:
.globl vector250
vector250:
  pushl $0
c010289e:	6a 00                	push   $0x0
  pushl $250
c01028a0:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01028a5:	e9 aa f5 ff ff       	jmp    c0101e54 <__alltraps>

c01028aa <vector251>:
.globl vector251
vector251:
  pushl $0
c01028aa:	6a 00                	push   $0x0
  pushl $251
c01028ac:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01028b1:	e9 9e f5 ff ff       	jmp    c0101e54 <__alltraps>

c01028b6 <vector252>:
.globl vector252
vector252:
  pushl $0
c01028b6:	6a 00                	push   $0x0
  pushl $252
c01028b8:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c01028bd:	e9 92 f5 ff ff       	jmp    c0101e54 <__alltraps>

c01028c2 <vector253>:
.globl vector253
vector253:
  pushl $0
c01028c2:	6a 00                	push   $0x0
  pushl $253
c01028c4:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c01028c9:	e9 86 f5 ff ff       	jmp    c0101e54 <__alltraps>

c01028ce <vector254>:
.globl vector254
vector254:
  pushl $0
c01028ce:	6a 00                	push   $0x0
  pushl $254
c01028d0:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c01028d5:	e9 7a f5 ff ff       	jmp    c0101e54 <__alltraps>

c01028da <vector255>:
.globl vector255
vector255:
  pushl $0
c01028da:	6a 00                	push   $0x0
  pushl $255
c01028dc:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c01028e1:	e9 6e f5 ff ff       	jmp    c0101e54 <__alltraps>

c01028e6 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01028e6:	55                   	push   %ebp
c01028e7:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01028e9:	8b 55 08             	mov    0x8(%ebp),%edx
c01028ec:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c01028f1:	29 c2                	sub    %eax,%edx
c01028f3:	89 d0                	mov    %edx,%eax
c01028f5:	c1 f8 02             	sar    $0x2,%eax
c01028f8:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c01028fe:	5d                   	pop    %ebp
c01028ff:	c3                   	ret    

c0102900 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0102900:	55                   	push   %ebp
c0102901:	89 e5                	mov    %esp,%ebp
c0102903:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0102906:	8b 45 08             	mov    0x8(%ebp),%eax
c0102909:	89 04 24             	mov    %eax,(%esp)
c010290c:	e8 d5 ff ff ff       	call   c01028e6 <page2ppn>
c0102911:	c1 e0 0c             	shl    $0xc,%eax
}
c0102914:	c9                   	leave  
c0102915:	c3                   	ret    

c0102916 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0102916:	55                   	push   %ebp
c0102917:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102919:	8b 45 08             	mov    0x8(%ebp),%eax
c010291c:	8b 00                	mov    (%eax),%eax
}
c010291e:	5d                   	pop    %ebp
c010291f:	c3                   	ret    

c0102920 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0102920:	55                   	push   %ebp
c0102921:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0102923:	8b 45 08             	mov    0x8(%ebp),%eax
c0102926:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102929:	89 10                	mov    %edx,(%eax)
}
c010292b:	5d                   	pop    %ebp
c010292c:	c3                   	ret    

c010292d <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c010292d:	55                   	push   %ebp
c010292e:	89 e5                	mov    %esp,%ebp
c0102930:	83 ec 10             	sub    $0x10,%esp
c0102933:	c7 45 fc 50 89 11 c0 	movl   $0xc0118950,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010293a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010293d:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102940:	89 50 04             	mov    %edx,0x4(%eax)
c0102943:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102946:	8b 50 04             	mov    0x4(%eax),%edx
c0102949:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010294c:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c010294e:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c0102955:	00 00 00 
}
c0102958:	c9                   	leave  
c0102959:	c3                   	ret    

c010295a <default_init_memmap>:

void
default_init_memmap(struct Page *base, size_t n) {
c010295a:	55                   	push   %ebp
c010295b:	89 e5                	mov    %esp,%ebp
c010295d:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c0102960:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102964:	75 24                	jne    c010298a <default_init_memmap+0x30>
c0102966:	c7 44 24 0c 50 66 10 	movl   $0xc0106650,0xc(%esp)
c010296d:	c0 
c010296e:	c7 44 24 08 56 66 10 	movl   $0xc0106656,0x8(%esp)
c0102975:	c0 
c0102976:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c010297d:	00 
c010297e:	c7 04 24 6b 66 10 c0 	movl   $0xc010666b,(%esp)
c0102985:	e8 43 e3 ff ff       	call   c0100ccd <__panic>
    struct Page *p = base;
c010298a:	8b 45 08             	mov    0x8(%ebp),%eax
c010298d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (p = base; p != base + n; p ++)
c0102990:	8b 45 08             	mov    0x8(%ebp),%eax
c0102993:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102996:	e9 dc 00 00 00       	jmp    c0102a77 <default_init_memmap+0x11d>
    {
        assert(PageReserved(p));
c010299b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010299e:	83 c0 04             	add    $0x4,%eax
c01029a1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01029a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01029ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01029ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01029b1:	0f a3 10             	bt     %edx,(%eax)
c01029b4:	19 c0                	sbb    %eax,%eax
c01029b6:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c01029b9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01029bd:	0f 95 c0             	setne  %al
c01029c0:	0f b6 c0             	movzbl %al,%eax
c01029c3:	85 c0                	test   %eax,%eax
c01029c5:	75 24                	jne    c01029eb <default_init_memmap+0x91>
c01029c7:	c7 44 24 0c 81 66 10 	movl   $0xc0106681,0xc(%esp)
c01029ce:	c0 
c01029cf:	c7 44 24 08 56 66 10 	movl   $0xc0106656,0x8(%esp)
c01029d6:	c0 
c01029d7:	c7 44 24 04 4a 00 00 	movl   $0x4a,0x4(%esp)
c01029de:	00 
c01029df:	c7 04 24 6b 66 10 c0 	movl   $0xc010666b,(%esp)
c01029e6:	e8 e2 e2 ff ff       	call   c0100ccd <__panic>
        p->flags = 0;
c01029eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        SetPageProperty(p);
c01029f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029f8:	83 c0 04             	add    $0x4,%eax
c01029fb:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0102a02:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102a05:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102a08:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102a0b:	0f ab 10             	bts    %edx,(%eax)
        p->property = 0;
c0102a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a11:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        set_page_ref(p, 0);
c0102a18:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102a1f:	00 
c0102a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a23:	89 04 24             	mov    %eax,(%esp)
c0102a26:	e8 f5 fe ff ff       	call   c0102920 <set_page_ref>
        list_add_before(&free_list, &(p->page_link));
c0102a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a2e:	83 c0 0c             	add    $0xc,%eax
c0102a31:	c7 45 dc 50 89 11 c0 	movl   $0xc0118950,-0x24(%ebp)
c0102a38:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102a3b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102a3e:	8b 00                	mov    (%eax),%eax
c0102a40:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102a43:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102a46:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102a49:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102a4c:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102a4f:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102a52:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102a55:	89 10                	mov    %edx,(%eax)
c0102a57:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102a5a:	8b 10                	mov    (%eax),%edx
c0102a5c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102a5f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102a62:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102a65:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102a68:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102a6b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102a6e:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102a71:	89 10                	mov    %edx,(%eax)

void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (p = base; p != base + n; p ++)
c0102a73:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102a77:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a7a:	89 d0                	mov    %edx,%eax
c0102a7c:	c1 e0 02             	shl    $0x2,%eax
c0102a7f:	01 d0                	add    %edx,%eax
c0102a81:	c1 e0 02             	shl    $0x2,%eax
c0102a84:	89 c2                	mov    %eax,%edx
c0102a86:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a89:	01 d0                	add    %edx,%eax
c0102a8b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102a8e:	0f 85 07 ff ff ff    	jne    c010299b <default_init_memmap+0x41>
        SetPageProperty(p);
        p->property = 0;
        set_page_ref(p, 0);
        list_add_before(&free_list, &(p->page_link));
    }
    nr_free = nr_free + n;
c0102a94:	8b 15 58 89 11 c0    	mov    0xc0118958,%edx
c0102a9a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102a9d:	01 d0                	add    %edx,%eax
c0102a9f:	a3 58 89 11 c0       	mov    %eax,0xc0118958
    base->property = n;
c0102aa4:	8b 45 08             	mov    0x8(%ebp),%eax
c0102aa7:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102aaa:	89 50 08             	mov    %edx,0x8(%eax)
}
c0102aad:	c9                   	leave  
c0102aae:	c3                   	ret    

c0102aaf <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0102aaf:	55                   	push   %ebp
c0102ab0:	89 e5                	mov    %esp,%ebp
c0102ab2:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0102ab5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102ab9:	75 24                	jne    c0102adf <default_alloc_pages+0x30>
c0102abb:	c7 44 24 0c 50 66 10 	movl   $0xc0106650,0xc(%esp)
c0102ac2:	c0 
c0102ac3:	c7 44 24 08 56 66 10 	movl   $0xc0106656,0x8(%esp)
c0102aca:	c0 
c0102acb:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
c0102ad2:	00 
c0102ad3:	c7 04 24 6b 66 10 c0 	movl   $0xc010666b,(%esp)
c0102ada:	e8 ee e1 ff ff       	call   c0100ccd <__panic>

    if (n > nr_free) {
c0102adf:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0102ae4:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102ae7:	73 0a                	jae    c0102af3 <default_alloc_pages+0x44>
        return NULL;
c0102ae9:	b8 00 00 00 00       	mov    $0x0,%eax
c0102aee:	e9 43 01 00 00       	jmp    c0102c36 <default_alloc_pages+0x187>
    }

    list_entry_t *le = &free_list, *le_next = NULL;
c0102af3:	c7 45 f4 50 89 11 c0 	movl   $0xc0118950,-0xc(%ebp)
c0102afa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

    struct Page* result = NULL;
c0102b01:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    while((le=list_next(le)) != &free_list)
c0102b08:	e9 0a 01 00 00       	jmp    c0102c17 <default_alloc_pages+0x168>
    {
    	struct Page *p = le2page(le, page_link);
c0102b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b10:	83 e8 0c             	sub    $0xc,%eax
c0102b13:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    	if(p->property >= n)
c0102b16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102b19:	8b 40 08             	mov    0x8(%eax),%eax
c0102b1c:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102b1f:	0f 82 f2 00 00 00    	jb     c0102c17 <default_alloc_pages+0x168>
    	{
    		int i;
    		for(i=0;i<n;i++)
c0102b25:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0102b2c:	eb 79                	jmp    c0102ba7 <default_alloc_pages+0xf8>
c0102b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b31:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102b34:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102b37:	8b 40 04             	mov    0x4(%eax),%eax
    		{
    			le_next = list_next(le);
c0102b3a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    			SetPageReserved(le2page(le, page_link));
c0102b3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b40:	83 e8 0c             	sub    $0xc,%eax
c0102b43:	83 c0 04             	add    $0x4,%eax
c0102b46:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102b4d:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0102b50:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102b53:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102b56:	0f ab 10             	bts    %edx,(%eax)
				ClearPageProperty(le2page(le, page_link));
c0102b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b5c:	83 e8 0c             	sub    $0xc,%eax
c0102b5f:	83 c0 04             	add    $0x4,%eax
c0102b62:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0102b69:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102b6c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102b6f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102b72:	0f b3 10             	btr    %edx,(%eax)
c0102b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b78:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102b7b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102b7e:	8b 40 04             	mov    0x4(%eax),%eax
c0102b81:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102b84:	8b 12                	mov    (%edx),%edx
c0102b86:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0102b89:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102b8c:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102b8f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102b92:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102b95:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102b98:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102b9b:	89 10                	mov    %edx,(%eax)
				list_del(le);
				le = le_next;
c0102b9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102ba0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
    	struct Page *p = le2page(le, page_link);
    	if(p->property >= n)
    	{
    		int i;
    		for(i=0;i<n;i++)
c0102ba3:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0102ba7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102baa:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102bad:	0f 82 7b ff ff ff    	jb     c0102b2e <default_alloc_pages+0x7f>
    			SetPageReserved(le2page(le, page_link));
				ClearPageProperty(le2page(le, page_link));
				list_del(le);
				le = le_next;
			}
			if(p->property > n)
c0102bb3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102bb6:	8b 40 08             	mov    0x8(%eax),%eax
c0102bb9:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102bbc:	76 12                	jbe    c0102bd0 <default_alloc_pages+0x121>
			{
				(le2page(le, page_link))->property = p->property - n;
c0102bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bc1:	8d 50 f4             	lea    -0xc(%eax),%edx
c0102bc4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102bc7:	8b 40 08             	mov    0x8(%eax),%eax
c0102bca:	2b 45 08             	sub    0x8(%ebp),%eax
c0102bcd:	89 42 08             	mov    %eax,0x8(%edx)
			}
			ClearPageProperty(p);
c0102bd0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102bd3:	83 c0 04             	add    $0x4,%eax
c0102bd6:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0102bdd:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0102be0:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102be3:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102be6:	0f b3 10             	btr    %edx,(%eax)
			SetPageReserved(p);
c0102be9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102bec:	83 c0 04             	add    $0x4,%eax
c0102bef:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
c0102bf6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102bf9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102bfc:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102bff:	0f ab 10             	bts    %edx,(%eax)
			nr_free = nr_free - n;
c0102c02:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0102c07:	2b 45 08             	sub    0x8(%ebp),%eax
c0102c0a:	a3 58 89 11 c0       	mov    %eax,0xc0118958
			result = p;
c0102c0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102c12:	89 45 f0             	mov    %eax,-0x10(%ebp)
			break;
c0102c15:	eb 1c                	jmp    c0102c33 <default_alloc_pages+0x184>
c0102c17:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c1a:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102c1d:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102c20:	8b 40 04             	mov    0x4(%eax),%eax

    list_entry_t *le = &free_list, *le_next = NULL;

    struct Page* result = NULL;

    while((le=list_next(le)) != &free_list)
c0102c23:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102c26:	81 7d f4 50 89 11 c0 	cmpl   $0xc0118950,-0xc(%ebp)
c0102c2d:	0f 85 da fe ff ff    	jne    c0102b0d <default_alloc_pages+0x5e>
			result = p;
			break;
		}
    }

    return result;
c0102c33:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0102c36:	c9                   	leave  
c0102c37:	c3                   	ret    

c0102c38 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0102c38:	55                   	push   %ebp
c0102c39:	89 e5                	mov    %esp,%ebp
c0102c3b:	83 ec 48             	sub    $0x48,%esp
    list_entry_t *le = &free_list;
c0102c3e:	c7 45 fc 50 89 11 c0 	movl   $0xc0118950,-0x4(%ebp)
    struct Page * p = NULL;
c0102c45:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    while((le=list_next(le)) != &free_list)
c0102c4c:	eb 13                	jmp    c0102c61 <default_free_pages+0x29>
    {
    	p = le2page(le, page_link);
c0102c4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102c51:	83 e8 0c             	sub    $0xc,%eax
c0102c54:	89 45 f8             	mov    %eax,-0x8(%ebp)
    	if(p > base)
c0102c57:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102c5a:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102c5d:	76 02                	jbe    c0102c61 <default_free_pages+0x29>
    	{
    		break;
c0102c5f:	eb 18                	jmp    c0102c79 <default_free_pages+0x41>
c0102c61:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102c64:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102c67:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c6a:	8b 40 04             	mov    0x4(%eax),%eax

static void
default_free_pages(struct Page *base, size_t n) {
    list_entry_t *le = &free_list;
    struct Page * p = NULL;
    while((le=list_next(le)) != &free_list)
c0102c6d:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0102c70:	81 7d fc 50 89 11 c0 	cmpl   $0xc0118950,-0x4(%ebp)
c0102c77:	75 d5                	jne    c0102c4e <default_free_pages+0x16>
    	if(p > base)
    	{
    		break;
    	}
    }
    for(p = base; p < base + n; p ++)
c0102c79:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c7c:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0102c7f:	eb 4b                	jmp    c0102ccc <default_free_pages+0x94>
    {
    	list_add_before(le, &(p->page_link));
c0102c81:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102c84:	8d 50 0c             	lea    0xc(%eax),%edx
c0102c87:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102c8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102c8d:	89 55 ec             	mov    %edx,-0x14(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102c90:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102c93:	8b 00                	mov    (%eax),%eax
c0102c95:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102c98:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0102c9b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0102c9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ca1:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102ca4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102ca7:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0102caa:	89 10                	mov    %edx,(%eax)
c0102cac:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102caf:	8b 10                	mov    (%eax),%edx
c0102cb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102cb4:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102cb7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102cba:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102cbd:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102cc0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102cc3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102cc6:	89 10                	mov    %edx,(%eax)
    	if(p > base)
    	{
    		break;
    	}
    }
    for(p = base; p < base + n; p ++)
c0102cc8:	83 45 f8 14          	addl   $0x14,-0x8(%ebp)
c0102ccc:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102ccf:	89 d0                	mov    %edx,%eax
c0102cd1:	c1 e0 02             	shl    $0x2,%eax
c0102cd4:	01 d0                	add    %edx,%eax
c0102cd6:	c1 e0 02             	shl    $0x2,%eax
c0102cd9:	89 c2                	mov    %eax,%edx
c0102cdb:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cde:	01 d0                	add    %edx,%eax
c0102ce0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c0102ce3:	77 9c                	ja     c0102c81 <default_free_pages+0x49>
    {
    	list_add_before(le, &(p->page_link));
    }
    base->flags = 0;
c0102ce5:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ce8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    ClearPageProperty(base);
c0102cef:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cf2:	83 c0 04             	add    $0x4,%eax
c0102cf5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
c0102cfc:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102cff:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102d02:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102d05:	0f b3 10             	btr    %edx,(%eax)
    SetPageProperty(base);
c0102d08:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d0b:	83 c0 04             	add    $0x4,%eax
c0102d0e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0102d15:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102d18:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102d1b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102d1e:	0f ab 10             	bts    %edx,(%eax)
    set_page_ref(base, 0);
c0102d21:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102d28:	00 
c0102d29:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d2c:	89 04 24             	mov    %eax,(%esp)
c0102d2f:	e8 ec fb ff ff       	call   c0102920 <set_page_ref>
    base->property = n;
c0102d34:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d37:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102d3a:	89 50 08             	mov    %edx,0x8(%eax)

    p = le2page(le,page_link) ;
c0102d3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102d40:	83 e8 0c             	sub    $0xc,%eax
c0102d43:	89 45 f8             	mov    %eax,-0x8(%ebp)
    if(base + n == p)
c0102d46:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102d49:	89 d0                	mov    %edx,%eax
c0102d4b:	c1 e0 02             	shl    $0x2,%eax
c0102d4e:	01 d0                	add    %edx,%eax
c0102d50:	c1 e0 02             	shl    $0x2,%eax
c0102d53:	89 c2                	mov    %eax,%edx
c0102d55:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d58:	01 d0                	add    %edx,%eax
c0102d5a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c0102d5d:	75 1e                	jne    c0102d7d <default_free_pages+0x145>
    {
    	base->property += p->property;
c0102d5f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d62:	8b 50 08             	mov    0x8(%eax),%edx
c0102d65:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102d68:	8b 40 08             	mov    0x8(%eax),%eax
c0102d6b:	01 c2                	add    %eax,%edx
c0102d6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d70:	89 50 08             	mov    %edx,0x8(%eax)
    	p->property = 0;
c0102d73:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102d76:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    }
    le = list_prev(&(base->page_link));
c0102d7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d80:	83 c0 0c             	add    $0xc,%eax
c0102d83:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c0102d86:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102d89:	8b 00                	mov    (%eax),%eax
c0102d8b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    p = le2page(le, page_link);
c0102d8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102d91:	83 e8 0c             	sub    $0xc,%eax
c0102d94:	89 45 f8             	mov    %eax,-0x8(%ebp)
    if((le != &free_list) && (p == base - 1)){
c0102d97:	81 7d fc 50 89 11 c0 	cmpl   $0xc0118950,-0x4(%ebp)
c0102d9e:	74 57                	je     c0102df7 <default_free_pages+0x1bf>
c0102da0:	8b 45 08             	mov    0x8(%ebp),%eax
c0102da3:	83 e8 14             	sub    $0x14,%eax
c0102da6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c0102da9:	75 4c                	jne    c0102df7 <default_free_pages+0x1bf>
    	while(le != &free_list)
c0102dab:	eb 41                	jmp    c0102dee <default_free_pages+0x1b6>
    	{
			if(p->property)
c0102dad:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102db0:	8b 40 08             	mov    0x8(%eax),%eax
c0102db3:	85 c0                	test   %eax,%eax
c0102db5:	74 20                	je     c0102dd7 <default_free_pages+0x19f>
			{
				p->property += base->property;
c0102db7:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102dba:	8b 50 08             	mov    0x8(%eax),%edx
c0102dbd:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dc0:	8b 40 08             	mov    0x8(%eax),%eax
c0102dc3:	01 c2                	add    %eax,%edx
c0102dc5:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102dc8:	89 50 08             	mov    %edx,0x8(%eax)
				base->property = 0;
c0102dcb:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dce:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				break;
c0102dd5:	eb 20                	jmp    c0102df7 <default_free_pages+0x1bf>
c0102dd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102dda:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0102ddd:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102de0:	8b 00                	mov    (%eax),%eax
			}
        le = list_prev(le);
c0102de2:	89 45 fc             	mov    %eax,-0x4(%ebp)
        p = le2page(le,page_link);
c0102de5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102de8:	83 e8 0c             	sub    $0xc,%eax
c0102deb:	89 45 f8             	mov    %eax,-0x8(%ebp)
    	p->property = 0;
    }
    le = list_prev(&(base->page_link));
    p = le2page(le, page_link);
    if((le != &free_list) && (p == base - 1)){
    	while(le != &free_list)
c0102dee:	81 7d fc 50 89 11 c0 	cmpl   $0xc0118950,-0x4(%ebp)
c0102df5:	75 b6                	jne    c0102dad <default_free_pages+0x175>
        le = list_prev(le);
        p = le2page(le,page_link);
    	}
    }

    nr_free += n;
c0102df7:	8b 15 58 89 11 c0    	mov    0xc0118958,%edx
c0102dfd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102e00:	01 d0                	add    %edx,%eax
c0102e02:	a3 58 89 11 c0       	mov    %eax,0xc0118958
    return ;
c0102e07:	90                   	nop
}
c0102e08:	c9                   	leave  
c0102e09:	c3                   	ret    

c0102e0a <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0102e0a:	55                   	push   %ebp
c0102e0b:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0102e0d:	a1 58 89 11 c0       	mov    0xc0118958,%eax
}
c0102e12:	5d                   	pop    %ebp
c0102e13:	c3                   	ret    

c0102e14 <basic_check>:

static void
basic_check(void) {
c0102e14:	55                   	push   %ebp
c0102e15:	89 e5                	mov    %esp,%ebp
c0102e17:	83 ec 48             	sub    $0x48,%esp
	struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0102e1a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102e21:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e24:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102e27:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e2a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0102e2d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102e34:	e8 85 0e 00 00       	call   c0103cbe <alloc_pages>
c0102e39:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102e3c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0102e40:	75 24                	jne    c0102e66 <basic_check+0x52>
c0102e42:	c7 44 24 0c 91 66 10 	movl   $0xc0106691,0xc(%esp)
c0102e49:	c0 
c0102e4a:	c7 44 24 08 56 66 10 	movl   $0xc0106656,0x8(%esp)
c0102e51:	c0 
c0102e52:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
c0102e59:	00 
c0102e5a:	c7 04 24 6b 66 10 c0 	movl   $0xc010666b,(%esp)
c0102e61:	e8 67 de ff ff       	call   c0100ccd <__panic>
    assert((p1 = alloc_page()) != NULL);
c0102e66:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102e6d:	e8 4c 0e 00 00       	call   c0103cbe <alloc_pages>
c0102e72:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102e75:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0102e79:	75 24                	jne    c0102e9f <basic_check+0x8b>
c0102e7b:	c7 44 24 0c ad 66 10 	movl   $0xc01066ad,0xc(%esp)
c0102e82:	c0 
c0102e83:	c7 44 24 08 56 66 10 	movl   $0xc0106656,0x8(%esp)
c0102e8a:	c0 
c0102e8b:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
c0102e92:	00 
c0102e93:	c7 04 24 6b 66 10 c0 	movl   $0xc010666b,(%esp)
c0102e9a:	e8 2e de ff ff       	call   c0100ccd <__panic>
    assert((p2 = alloc_page()) != NULL);
c0102e9f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102ea6:	e8 13 0e 00 00       	call   c0103cbe <alloc_pages>
c0102eab:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102eae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102eb2:	75 24                	jne    c0102ed8 <basic_check+0xc4>
c0102eb4:	c7 44 24 0c c9 66 10 	movl   $0xc01066c9,0xc(%esp)
c0102ebb:	c0 
c0102ebc:	c7 44 24 08 56 66 10 	movl   $0xc0106656,0x8(%esp)
c0102ec3:	c0 
c0102ec4:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c0102ecb:	00 
c0102ecc:	c7 04 24 6b 66 10 c0 	movl   $0xc010666b,(%esp)
c0102ed3:	e8 f5 dd ff ff       	call   c0100ccd <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0102ed8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102edb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102ede:	74 10                	je     c0102ef0 <basic_check+0xdc>
c0102ee0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102ee3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102ee6:	74 08                	je     c0102ef0 <basic_check+0xdc>
c0102ee8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102eeb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102eee:	75 24                	jne    c0102f14 <basic_check+0x100>
c0102ef0:	c7 44 24 0c e8 66 10 	movl   $0xc01066e8,0xc(%esp)
c0102ef7:	c0 
c0102ef8:	c7 44 24 08 56 66 10 	movl   $0xc0106656,0x8(%esp)
c0102eff:	c0 
c0102f00:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
c0102f07:	00 
c0102f08:	c7 04 24 6b 66 10 c0 	movl   $0xc010666b,(%esp)
c0102f0f:	e8 b9 dd ff ff       	call   c0100ccd <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0102f14:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f17:	89 04 24             	mov    %eax,(%esp)
c0102f1a:	e8 f7 f9 ff ff       	call   c0102916 <page_ref>
c0102f1f:	85 c0                	test   %eax,%eax
c0102f21:	75 1e                	jne    c0102f41 <basic_check+0x12d>
c0102f23:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f26:	89 04 24             	mov    %eax,(%esp)
c0102f29:	e8 e8 f9 ff ff       	call   c0102916 <page_ref>
c0102f2e:	85 c0                	test   %eax,%eax
c0102f30:	75 0f                	jne    c0102f41 <basic_check+0x12d>
c0102f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f35:	89 04 24             	mov    %eax,(%esp)
c0102f38:	e8 d9 f9 ff ff       	call   c0102916 <page_ref>
c0102f3d:	85 c0                	test   %eax,%eax
c0102f3f:	74 24                	je     c0102f65 <basic_check+0x151>
c0102f41:	c7 44 24 0c 0c 67 10 	movl   $0xc010670c,0xc(%esp)
c0102f48:	c0 
c0102f49:	c7 44 24 08 56 66 10 	movl   $0xc0106656,0x8(%esp)
c0102f50:	c0 
c0102f51:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0102f58:	00 
c0102f59:	c7 04 24 6b 66 10 c0 	movl   $0xc010666b,(%esp)
c0102f60:	e8 68 dd ff ff       	call   c0100ccd <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0102f65:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f68:	89 04 24             	mov    %eax,(%esp)
c0102f6b:	e8 90 f9 ff ff       	call   c0102900 <page2pa>
c0102f70:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0102f76:	c1 e2 0c             	shl    $0xc,%edx
c0102f79:	39 d0                	cmp    %edx,%eax
c0102f7b:	72 24                	jb     c0102fa1 <basic_check+0x18d>
c0102f7d:	c7 44 24 0c 48 67 10 	movl   $0xc0106748,0xc(%esp)
c0102f84:	c0 
c0102f85:	c7 44 24 08 56 66 10 	movl   $0xc0106656,0x8(%esp)
c0102f8c:	c0 
c0102f8d:	c7 44 24 04 be 00 00 	movl   $0xbe,0x4(%esp)
c0102f94:	00 
c0102f95:	c7 04 24 6b 66 10 c0 	movl   $0xc010666b,(%esp)
c0102f9c:	e8 2c dd ff ff       	call   c0100ccd <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0102fa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102fa4:	89 04 24             	mov    %eax,(%esp)
c0102fa7:	e8 54 f9 ff ff       	call   c0102900 <page2pa>
c0102fac:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0102fb2:	c1 e2 0c             	shl    $0xc,%edx
c0102fb5:	39 d0                	cmp    %edx,%eax
c0102fb7:	72 24                	jb     c0102fdd <basic_check+0x1c9>
c0102fb9:	c7 44 24 0c 65 67 10 	movl   $0xc0106765,0xc(%esp)
c0102fc0:	c0 
c0102fc1:	c7 44 24 08 56 66 10 	movl   $0xc0106656,0x8(%esp)
c0102fc8:	c0 
c0102fc9:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
c0102fd0:	00 
c0102fd1:	c7 04 24 6b 66 10 c0 	movl   $0xc010666b,(%esp)
c0102fd8:	e8 f0 dc ff ff       	call   c0100ccd <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0102fdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102fe0:	89 04 24             	mov    %eax,(%esp)
c0102fe3:	e8 18 f9 ff ff       	call   c0102900 <page2pa>
c0102fe8:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0102fee:	c1 e2 0c             	shl    $0xc,%edx
c0102ff1:	39 d0                	cmp    %edx,%eax
c0102ff3:	72 24                	jb     c0103019 <basic_check+0x205>
c0102ff5:	c7 44 24 0c 82 67 10 	movl   $0xc0106782,0xc(%esp)
c0102ffc:	c0 
c0102ffd:	c7 44 24 08 56 66 10 	movl   $0xc0106656,0x8(%esp)
c0103004:	c0 
c0103005:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c010300c:	00 
c010300d:	c7 04 24 6b 66 10 c0 	movl   $0xc010666b,(%esp)
c0103014:	e8 b4 dc ff ff       	call   c0100ccd <__panic>

    list_entry_t free_list_store = free_list;
c0103019:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c010301e:	8b 15 54 89 11 c0    	mov    0xc0118954,%edx
c0103024:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103027:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010302a:	c7 45 e0 50 89 11 c0 	movl   $0xc0118950,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103031:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103034:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103037:	89 50 04             	mov    %edx,0x4(%eax)
c010303a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010303d:	8b 50 04             	mov    0x4(%eax),%edx
c0103040:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103043:	89 10                	mov    %edx,(%eax)
c0103045:	c7 45 dc 50 89 11 c0 	movl   $0xc0118950,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c010304c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010304f:	8b 40 04             	mov    0x4(%eax),%eax
c0103052:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103055:	0f 94 c0             	sete   %al
c0103058:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010305b:	85 c0                	test   %eax,%eax
c010305d:	75 24                	jne    c0103083 <basic_check+0x26f>
c010305f:	c7 44 24 0c 9f 67 10 	movl   $0xc010679f,0xc(%esp)
c0103066:	c0 
c0103067:	c7 44 24 08 56 66 10 	movl   $0xc0106656,0x8(%esp)
c010306e:	c0 
c010306f:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
c0103076:	00 
c0103077:	c7 04 24 6b 66 10 c0 	movl   $0xc010666b,(%esp)
c010307e:	e8 4a dc ff ff       	call   c0100ccd <__panic>

    unsigned int nr_free_store = nr_free;
c0103083:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0103088:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c010308b:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c0103092:	00 00 00 

    assert(alloc_page() == NULL);
c0103095:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010309c:	e8 1d 0c 00 00       	call   c0103cbe <alloc_pages>
c01030a1:	85 c0                	test   %eax,%eax
c01030a3:	74 24                	je     c01030c9 <basic_check+0x2b5>
c01030a5:	c7 44 24 0c b6 67 10 	movl   $0xc01067b6,0xc(%esp)
c01030ac:	c0 
c01030ad:	c7 44 24 08 56 66 10 	movl   $0xc0106656,0x8(%esp)
c01030b4:	c0 
c01030b5:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c01030bc:	00 
c01030bd:	c7 04 24 6b 66 10 c0 	movl   $0xc010666b,(%esp)
c01030c4:	e8 04 dc ff ff       	call   c0100ccd <__panic>

    free_page(p0);
c01030c9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01030d0:	00 
c01030d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01030d4:	89 04 24             	mov    %eax,(%esp)
c01030d7:	e8 1a 0c 00 00       	call   c0103cf6 <free_pages>
    free_page(p1);
c01030dc:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01030e3:	00 
c01030e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01030e7:	89 04 24             	mov    %eax,(%esp)
c01030ea:	e8 07 0c 00 00       	call   c0103cf6 <free_pages>
    free_page(p2);
c01030ef:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01030f6:	00 
c01030f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01030fa:	89 04 24             	mov    %eax,(%esp)
c01030fd:	e8 f4 0b 00 00       	call   c0103cf6 <free_pages>
    assert(nr_free == 3);
c0103102:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0103107:	83 f8 03             	cmp    $0x3,%eax
c010310a:	74 24                	je     c0103130 <basic_check+0x31c>
c010310c:	c7 44 24 0c cb 67 10 	movl   $0xc01067cb,0xc(%esp)
c0103113:	c0 
c0103114:	c7 44 24 08 56 66 10 	movl   $0xc0106656,0x8(%esp)
c010311b:	c0 
c010311c:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c0103123:	00 
c0103124:	c7 04 24 6b 66 10 c0 	movl   $0xc010666b,(%esp)
c010312b:	e8 9d db ff ff       	call   c0100ccd <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103130:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103137:	e8 82 0b 00 00       	call   c0103cbe <alloc_pages>
c010313c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010313f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103143:	75 24                	jne    c0103169 <basic_check+0x355>
c0103145:	c7 44 24 0c 91 66 10 	movl   $0xc0106691,0xc(%esp)
c010314c:	c0 
c010314d:	c7 44 24 08 56 66 10 	movl   $0xc0106656,0x8(%esp)
c0103154:	c0 
c0103155:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c010315c:	00 
c010315d:	c7 04 24 6b 66 10 c0 	movl   $0xc010666b,(%esp)
c0103164:	e8 64 db ff ff       	call   c0100ccd <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103169:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103170:	e8 49 0b 00 00       	call   c0103cbe <alloc_pages>
c0103175:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103178:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010317c:	75 24                	jne    c01031a2 <basic_check+0x38e>
c010317e:	c7 44 24 0c ad 66 10 	movl   $0xc01066ad,0xc(%esp)
c0103185:	c0 
c0103186:	c7 44 24 08 56 66 10 	movl   $0xc0106656,0x8(%esp)
c010318d:	c0 
c010318e:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c0103195:	00 
c0103196:	c7 04 24 6b 66 10 c0 	movl   $0xc010666b,(%esp)
c010319d:	e8 2b db ff ff       	call   c0100ccd <__panic>
    assert((p2 = alloc_page()) != NULL);
c01031a2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01031a9:	e8 10 0b 00 00       	call   c0103cbe <alloc_pages>
c01031ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01031b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01031b5:	75 24                	jne    c01031db <basic_check+0x3c7>
c01031b7:	c7 44 24 0c c9 66 10 	movl   $0xc01066c9,0xc(%esp)
c01031be:	c0 
c01031bf:	c7 44 24 08 56 66 10 	movl   $0xc0106656,0x8(%esp)
c01031c6:	c0 
c01031c7:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c01031ce:	00 
c01031cf:	c7 04 24 6b 66 10 c0 	movl   $0xc010666b,(%esp)
c01031d6:	e8 f2 da ff ff       	call   c0100ccd <__panic>

    assert(alloc_page() == NULL);
c01031db:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01031e2:	e8 d7 0a 00 00       	call   c0103cbe <alloc_pages>
c01031e7:	85 c0                	test   %eax,%eax
c01031e9:	74 24                	je     c010320f <basic_check+0x3fb>
c01031eb:	c7 44 24 0c b6 67 10 	movl   $0xc01067b6,0xc(%esp)
c01031f2:	c0 
c01031f3:	c7 44 24 08 56 66 10 	movl   $0xc0106656,0x8(%esp)
c01031fa:	c0 
c01031fb:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c0103202:	00 
c0103203:	c7 04 24 6b 66 10 c0 	movl   $0xc010666b,(%esp)
c010320a:	e8 be da ff ff       	call   c0100ccd <__panic>

    free_page(p0);
c010320f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103216:	00 
c0103217:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010321a:	89 04 24             	mov    %eax,(%esp)
c010321d:	e8 d4 0a 00 00       	call   c0103cf6 <free_pages>
c0103222:	c7 45 d8 50 89 11 c0 	movl   $0xc0118950,-0x28(%ebp)
c0103229:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010322c:	8b 40 04             	mov    0x4(%eax),%eax
c010322f:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103232:	0f 94 c0             	sete   %al
c0103235:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0103238:	85 c0                	test   %eax,%eax
c010323a:	74 24                	je     c0103260 <basic_check+0x44c>
c010323c:	c7 44 24 0c d8 67 10 	movl   $0xc01067d8,0xc(%esp)
c0103243:	c0 
c0103244:	c7 44 24 08 56 66 10 	movl   $0xc0106656,0x8(%esp)
c010324b:	c0 
c010324c:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0103253:	00 
c0103254:	c7 04 24 6b 66 10 c0 	movl   $0xc010666b,(%esp)
c010325b:	e8 6d da ff ff       	call   c0100ccd <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0103260:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103267:	e8 52 0a 00 00       	call   c0103cbe <alloc_pages>
c010326c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010326f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103272:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103275:	74 24                	je     c010329b <basic_check+0x487>
c0103277:	c7 44 24 0c f0 67 10 	movl   $0xc01067f0,0xc(%esp)
c010327e:	c0 
c010327f:	c7 44 24 08 56 66 10 	movl   $0xc0106656,0x8(%esp)
c0103286:	c0 
c0103287:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c010328e:	00 
c010328f:	c7 04 24 6b 66 10 c0 	movl   $0xc010666b,(%esp)
c0103296:	e8 32 da ff ff       	call   c0100ccd <__panic>
    assert(alloc_page() == NULL);
c010329b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01032a2:	e8 17 0a 00 00       	call   c0103cbe <alloc_pages>
c01032a7:	85 c0                	test   %eax,%eax
c01032a9:	74 24                	je     c01032cf <basic_check+0x4bb>
c01032ab:	c7 44 24 0c b6 67 10 	movl   $0xc01067b6,0xc(%esp)
c01032b2:	c0 
c01032b3:	c7 44 24 08 56 66 10 	movl   $0xc0106656,0x8(%esp)
c01032ba:	c0 
c01032bb:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c01032c2:	00 
c01032c3:	c7 04 24 6b 66 10 c0 	movl   $0xc010666b,(%esp)
c01032ca:	e8 fe d9 ff ff       	call   c0100ccd <__panic>

    assert(nr_free == 0);
c01032cf:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c01032d4:	85 c0                	test   %eax,%eax
c01032d6:	74 24                	je     c01032fc <basic_check+0x4e8>
c01032d8:	c7 44 24 0c 09 68 10 	movl   $0xc0106809,0xc(%esp)
c01032df:	c0 
c01032e0:	c7 44 24 08 56 66 10 	movl   $0xc0106656,0x8(%esp)
c01032e7:	c0 
c01032e8:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
c01032ef:	00 
c01032f0:	c7 04 24 6b 66 10 c0 	movl   $0xc010666b,(%esp)
c01032f7:	e8 d1 d9 ff ff       	call   c0100ccd <__panic>
    free_list = free_list_store;
c01032fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01032ff:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103302:	a3 50 89 11 c0       	mov    %eax,0xc0118950
c0103307:	89 15 54 89 11 c0    	mov    %edx,0xc0118954
    nr_free = nr_free_store;
c010330d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103310:	a3 58 89 11 c0       	mov    %eax,0xc0118958

    free_page(p);
c0103315:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010331c:	00 
c010331d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103320:	89 04 24             	mov    %eax,(%esp)
c0103323:	e8 ce 09 00 00       	call   c0103cf6 <free_pages>
    free_page(p1);
c0103328:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010332f:	00 
c0103330:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103333:	89 04 24             	mov    %eax,(%esp)
c0103336:	e8 bb 09 00 00       	call   c0103cf6 <free_pages>
    free_page(p2);
c010333b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103342:	00 
c0103343:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103346:	89 04 24             	mov    %eax,(%esp)
c0103349:	e8 a8 09 00 00       	call   c0103cf6 <free_pages>
}
c010334e:	c9                   	leave  
c010334f:	c3                   	ret    

c0103350 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0103350:	55                   	push   %ebp
c0103351:	89 e5                	mov    %esp,%ebp
c0103353:	53                   	push   %ebx
c0103354:	81 ec 94 00 00 00    	sub    $0x94,%esp
	int count = 0, total = 0;
c010335a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103361:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0103368:	c7 45 ec 50 89 11 c0 	movl   $0xc0118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c010336f:	eb 6b                	jmp    c01033dc <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c0103371:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103374:	83 e8 0c             	sub    $0xc,%eax
c0103377:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c010337a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010337d:	83 c0 04             	add    $0x4,%eax
c0103380:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103387:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010338a:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010338d:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103390:	0f a3 10             	bt     %edx,(%eax)
c0103393:	19 c0                	sbb    %eax,%eax
c0103395:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0103398:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c010339c:	0f 95 c0             	setne  %al
c010339f:	0f b6 c0             	movzbl %al,%eax
c01033a2:	85 c0                	test   %eax,%eax
c01033a4:	75 24                	jne    c01033ca <default_check+0x7a>
c01033a6:	c7 44 24 0c 16 68 10 	movl   $0xc0106816,0xc(%esp)
c01033ad:	c0 
c01033ae:	c7 44 24 08 56 66 10 	movl   $0xc0106656,0x8(%esp)
c01033b5:	c0 
c01033b6:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c01033bd:	00 
c01033be:	c7 04 24 6b 66 10 c0 	movl   $0xc010666b,(%esp)
c01033c5:	e8 03 d9 ff ff       	call   c0100ccd <__panic>
        count ++, total += p->property;
c01033ca:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01033ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01033d1:	8b 50 08             	mov    0x8(%eax),%edx
c01033d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01033d7:	01 d0                	add    %edx,%eax
c01033d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01033dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01033df:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01033e2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01033e5:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
	int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01033e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01033eb:	81 7d ec 50 89 11 c0 	cmpl   $0xc0118950,-0x14(%ebp)
c01033f2:	0f 85 79 ff ff ff    	jne    c0103371 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c01033f8:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c01033fb:	e8 28 09 00 00       	call   c0103d28 <nr_free_pages>
c0103400:	39 c3                	cmp    %eax,%ebx
c0103402:	74 24                	je     c0103428 <default_check+0xd8>
c0103404:	c7 44 24 0c 26 68 10 	movl   $0xc0106826,0xc(%esp)
c010340b:	c0 
c010340c:	c7 44 24 08 56 66 10 	movl   $0xc0106656,0x8(%esp)
c0103413:	c0 
c0103414:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
c010341b:	00 
c010341c:	c7 04 24 6b 66 10 c0 	movl   $0xc010666b,(%esp)
c0103423:	e8 a5 d8 ff ff       	call   c0100ccd <__panic>

    basic_check();
c0103428:	e8 e7 f9 ff ff       	call   c0102e14 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c010342d:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103434:	e8 85 08 00 00       	call   c0103cbe <alloc_pages>
c0103439:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c010343c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103440:	75 24                	jne    c0103466 <default_check+0x116>
c0103442:	c7 44 24 0c 3f 68 10 	movl   $0xc010683f,0xc(%esp)
c0103449:	c0 
c010344a:	c7 44 24 08 56 66 10 	movl   $0xc0106656,0x8(%esp)
c0103451:	c0 
c0103452:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
c0103459:	00 
c010345a:	c7 04 24 6b 66 10 c0 	movl   $0xc010666b,(%esp)
c0103461:	e8 67 d8 ff ff       	call   c0100ccd <__panic>
    assert(!PageProperty(p0));
c0103466:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103469:	83 c0 04             	add    $0x4,%eax
c010346c:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0103473:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103476:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103479:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010347c:	0f a3 10             	bt     %edx,(%eax)
c010347f:	19 c0                	sbb    %eax,%eax
c0103481:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0103484:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103488:	0f 95 c0             	setne  %al
c010348b:	0f b6 c0             	movzbl %al,%eax
c010348e:	85 c0                	test   %eax,%eax
c0103490:	74 24                	je     c01034b6 <default_check+0x166>
c0103492:	c7 44 24 0c 4a 68 10 	movl   $0xc010684a,0xc(%esp)
c0103499:	c0 
c010349a:	c7 44 24 08 56 66 10 	movl   $0xc0106656,0x8(%esp)
c01034a1:	c0 
c01034a2:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
c01034a9:	00 
c01034aa:	c7 04 24 6b 66 10 c0 	movl   $0xc010666b,(%esp)
c01034b1:	e8 17 d8 ff ff       	call   c0100ccd <__panic>

    list_entry_t free_list_store = free_list;
c01034b6:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c01034bb:	8b 15 54 89 11 c0    	mov    0xc0118954,%edx
c01034c1:	89 45 80             	mov    %eax,-0x80(%ebp)
c01034c4:	89 55 84             	mov    %edx,-0x7c(%ebp)
c01034c7:	c7 45 b4 50 89 11 c0 	movl   $0xc0118950,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01034ce:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01034d1:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01034d4:	89 50 04             	mov    %edx,0x4(%eax)
c01034d7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01034da:	8b 50 04             	mov    0x4(%eax),%edx
c01034dd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01034e0:	89 10                	mov    %edx,(%eax)
c01034e2:	c7 45 b0 50 89 11 c0 	movl   $0xc0118950,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01034e9:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01034ec:	8b 40 04             	mov    0x4(%eax),%eax
c01034ef:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c01034f2:	0f 94 c0             	sete   %al
c01034f5:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01034f8:	85 c0                	test   %eax,%eax
c01034fa:	75 24                	jne    c0103520 <default_check+0x1d0>
c01034fc:	c7 44 24 0c 9f 67 10 	movl   $0xc010679f,0xc(%esp)
c0103503:	c0 
c0103504:	c7 44 24 08 56 66 10 	movl   $0xc0106656,0x8(%esp)
c010350b:	c0 
c010350c:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c0103513:	00 
c0103514:	c7 04 24 6b 66 10 c0 	movl   $0xc010666b,(%esp)
c010351b:	e8 ad d7 ff ff       	call   c0100ccd <__panic>
    assert(alloc_page() == NULL);
c0103520:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103527:	e8 92 07 00 00       	call   c0103cbe <alloc_pages>
c010352c:	85 c0                	test   %eax,%eax
c010352e:	74 24                	je     c0103554 <default_check+0x204>
c0103530:	c7 44 24 0c b6 67 10 	movl   $0xc01067b6,0xc(%esp)
c0103537:	c0 
c0103538:	c7 44 24 08 56 66 10 	movl   $0xc0106656,0x8(%esp)
c010353f:	c0 
c0103540:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c0103547:	00 
c0103548:	c7 04 24 6b 66 10 c0 	movl   $0xc010666b,(%esp)
c010354f:	e8 79 d7 ff ff       	call   c0100ccd <__panic>

    unsigned int nr_free_store = nr_free;
c0103554:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0103559:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c010355c:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c0103563:	00 00 00 

    free_pages(p0 + 2, 3);
c0103566:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103569:	83 c0 28             	add    $0x28,%eax
c010356c:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103573:	00 
c0103574:	89 04 24             	mov    %eax,(%esp)
c0103577:	e8 7a 07 00 00       	call   c0103cf6 <free_pages>
    assert(alloc_pages(4) == NULL);
c010357c:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0103583:	e8 36 07 00 00       	call   c0103cbe <alloc_pages>
c0103588:	85 c0                	test   %eax,%eax
c010358a:	74 24                	je     c01035b0 <default_check+0x260>
c010358c:	c7 44 24 0c 5c 68 10 	movl   $0xc010685c,0xc(%esp)
c0103593:	c0 
c0103594:	c7 44 24 08 56 66 10 	movl   $0xc0106656,0x8(%esp)
c010359b:	c0 
c010359c:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c01035a3:	00 
c01035a4:	c7 04 24 6b 66 10 c0 	movl   $0xc010666b,(%esp)
c01035ab:	e8 1d d7 ff ff       	call   c0100ccd <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c01035b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01035b3:	83 c0 28             	add    $0x28,%eax
c01035b6:	83 c0 04             	add    $0x4,%eax
c01035b9:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c01035c0:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01035c3:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01035c6:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01035c9:	0f a3 10             	bt     %edx,(%eax)
c01035cc:	19 c0                	sbb    %eax,%eax
c01035ce:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c01035d1:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c01035d5:	0f 95 c0             	setne  %al
c01035d8:	0f b6 c0             	movzbl %al,%eax
c01035db:	85 c0                	test   %eax,%eax
c01035dd:	74 0e                	je     c01035ed <default_check+0x29d>
c01035df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01035e2:	83 c0 28             	add    $0x28,%eax
c01035e5:	8b 40 08             	mov    0x8(%eax),%eax
c01035e8:	83 f8 03             	cmp    $0x3,%eax
c01035eb:	74 24                	je     c0103611 <default_check+0x2c1>
c01035ed:	c7 44 24 0c 74 68 10 	movl   $0xc0106874,0xc(%esp)
c01035f4:	c0 
c01035f5:	c7 44 24 08 56 66 10 	movl   $0xc0106656,0x8(%esp)
c01035fc:	c0 
c01035fd:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
c0103604:	00 
c0103605:	c7 04 24 6b 66 10 c0 	movl   $0xc010666b,(%esp)
c010360c:	e8 bc d6 ff ff       	call   c0100ccd <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0103611:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0103618:	e8 a1 06 00 00       	call   c0103cbe <alloc_pages>
c010361d:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103620:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103624:	75 24                	jne    c010364a <default_check+0x2fa>
c0103626:	c7 44 24 0c a0 68 10 	movl   $0xc01068a0,0xc(%esp)
c010362d:	c0 
c010362e:	c7 44 24 08 56 66 10 	movl   $0xc0106656,0x8(%esp)
c0103635:	c0 
c0103636:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c010363d:	00 
c010363e:	c7 04 24 6b 66 10 c0 	movl   $0xc010666b,(%esp)
c0103645:	e8 83 d6 ff ff       	call   c0100ccd <__panic>
    assert(alloc_page() == NULL);
c010364a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103651:	e8 68 06 00 00       	call   c0103cbe <alloc_pages>
c0103656:	85 c0                	test   %eax,%eax
c0103658:	74 24                	je     c010367e <default_check+0x32e>
c010365a:	c7 44 24 0c b6 67 10 	movl   $0xc01067b6,0xc(%esp)
c0103661:	c0 
c0103662:	c7 44 24 08 56 66 10 	movl   $0xc0106656,0x8(%esp)
c0103669:	c0 
c010366a:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
c0103671:	00 
c0103672:	c7 04 24 6b 66 10 c0 	movl   $0xc010666b,(%esp)
c0103679:	e8 4f d6 ff ff       	call   c0100ccd <__panic>
    assert(p0 + 2 == p1);
c010367e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103681:	83 c0 28             	add    $0x28,%eax
c0103684:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103687:	74 24                	je     c01036ad <default_check+0x35d>
c0103689:	c7 44 24 0c be 68 10 	movl   $0xc01068be,0xc(%esp)
c0103690:	c0 
c0103691:	c7 44 24 08 56 66 10 	movl   $0xc0106656,0x8(%esp)
c0103698:	c0 
c0103699:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
c01036a0:	00 
c01036a1:	c7 04 24 6b 66 10 c0 	movl   $0xc010666b,(%esp)
c01036a8:	e8 20 d6 ff ff       	call   c0100ccd <__panic>

    p2 = p0 + 1;
c01036ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036b0:	83 c0 14             	add    $0x14,%eax
c01036b3:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c01036b6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01036bd:	00 
c01036be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036c1:	89 04 24             	mov    %eax,(%esp)
c01036c4:	e8 2d 06 00 00       	call   c0103cf6 <free_pages>
    free_pages(p1, 3);
c01036c9:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01036d0:	00 
c01036d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01036d4:	89 04 24             	mov    %eax,(%esp)
c01036d7:	e8 1a 06 00 00       	call   c0103cf6 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c01036dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036df:	83 c0 04             	add    $0x4,%eax
c01036e2:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c01036e9:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01036ec:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01036ef:	8b 55 a0             	mov    -0x60(%ebp),%edx
c01036f2:	0f a3 10             	bt     %edx,(%eax)
c01036f5:	19 c0                	sbb    %eax,%eax
c01036f7:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c01036fa:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c01036fe:	0f 95 c0             	setne  %al
c0103701:	0f b6 c0             	movzbl %al,%eax
c0103704:	85 c0                	test   %eax,%eax
c0103706:	74 0b                	je     c0103713 <default_check+0x3c3>
c0103708:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010370b:	8b 40 08             	mov    0x8(%eax),%eax
c010370e:	83 f8 01             	cmp    $0x1,%eax
c0103711:	74 24                	je     c0103737 <default_check+0x3e7>
c0103713:	c7 44 24 0c cc 68 10 	movl   $0xc01068cc,0xc(%esp)
c010371a:	c0 
c010371b:	c7 44 24 08 56 66 10 	movl   $0xc0106656,0x8(%esp)
c0103722:	c0 
c0103723:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
c010372a:	00 
c010372b:	c7 04 24 6b 66 10 c0 	movl   $0xc010666b,(%esp)
c0103732:	e8 96 d5 ff ff       	call   c0100ccd <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0103737:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010373a:	83 c0 04             	add    $0x4,%eax
c010373d:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0103744:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103747:	8b 45 90             	mov    -0x70(%ebp),%eax
c010374a:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010374d:	0f a3 10             	bt     %edx,(%eax)
c0103750:	19 c0                	sbb    %eax,%eax
c0103752:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0103755:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0103759:	0f 95 c0             	setne  %al
c010375c:	0f b6 c0             	movzbl %al,%eax
c010375f:	85 c0                	test   %eax,%eax
c0103761:	74 0b                	je     c010376e <default_check+0x41e>
c0103763:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103766:	8b 40 08             	mov    0x8(%eax),%eax
c0103769:	83 f8 03             	cmp    $0x3,%eax
c010376c:	74 24                	je     c0103792 <default_check+0x442>
c010376e:	c7 44 24 0c f4 68 10 	movl   $0xc01068f4,0xc(%esp)
c0103775:	c0 
c0103776:	c7 44 24 08 56 66 10 	movl   $0xc0106656,0x8(%esp)
c010377d:	c0 
c010377e:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c0103785:	00 
c0103786:	c7 04 24 6b 66 10 c0 	movl   $0xc010666b,(%esp)
c010378d:	e8 3b d5 ff ff       	call   c0100ccd <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0103792:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103799:	e8 20 05 00 00       	call   c0103cbe <alloc_pages>
c010379e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01037a1:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01037a4:	83 e8 14             	sub    $0x14,%eax
c01037a7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01037aa:	74 24                	je     c01037d0 <default_check+0x480>
c01037ac:	c7 44 24 0c 1a 69 10 	movl   $0xc010691a,0xc(%esp)
c01037b3:	c0 
c01037b4:	c7 44 24 08 56 66 10 	movl   $0xc0106656,0x8(%esp)
c01037bb:	c0 
c01037bc:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c01037c3:	00 
c01037c4:	c7 04 24 6b 66 10 c0 	movl   $0xc010666b,(%esp)
c01037cb:	e8 fd d4 ff ff       	call   c0100ccd <__panic>
    free_page(p0);
c01037d0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01037d7:	00 
c01037d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01037db:	89 04 24             	mov    %eax,(%esp)
c01037de:	e8 13 05 00 00       	call   c0103cf6 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c01037e3:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c01037ea:	e8 cf 04 00 00       	call   c0103cbe <alloc_pages>
c01037ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01037f2:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01037f5:	83 c0 14             	add    $0x14,%eax
c01037f8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01037fb:	74 24                	je     c0103821 <default_check+0x4d1>
c01037fd:	c7 44 24 0c 38 69 10 	movl   $0xc0106938,0xc(%esp)
c0103804:	c0 
c0103805:	c7 44 24 08 56 66 10 	movl   $0xc0106656,0x8(%esp)
c010380c:	c0 
c010380d:	c7 44 24 04 10 01 00 	movl   $0x110,0x4(%esp)
c0103814:	00 
c0103815:	c7 04 24 6b 66 10 c0 	movl   $0xc010666b,(%esp)
c010381c:	e8 ac d4 ff ff       	call   c0100ccd <__panic>

    free_pages(p0, 2);
c0103821:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0103828:	00 
c0103829:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010382c:	89 04 24             	mov    %eax,(%esp)
c010382f:	e8 c2 04 00 00       	call   c0103cf6 <free_pages>
    free_page(p2);
c0103834:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010383b:	00 
c010383c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010383f:	89 04 24             	mov    %eax,(%esp)
c0103842:	e8 af 04 00 00       	call   c0103cf6 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0103847:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c010384e:	e8 6b 04 00 00       	call   c0103cbe <alloc_pages>
c0103853:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103856:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010385a:	75 24                	jne    c0103880 <default_check+0x530>
c010385c:	c7 44 24 0c 58 69 10 	movl   $0xc0106958,0xc(%esp)
c0103863:	c0 
c0103864:	c7 44 24 08 56 66 10 	movl   $0xc0106656,0x8(%esp)
c010386b:	c0 
c010386c:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
c0103873:	00 
c0103874:	c7 04 24 6b 66 10 c0 	movl   $0xc010666b,(%esp)
c010387b:	e8 4d d4 ff ff       	call   c0100ccd <__panic>
    assert(alloc_page() == NULL);
c0103880:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103887:	e8 32 04 00 00       	call   c0103cbe <alloc_pages>
c010388c:	85 c0                	test   %eax,%eax
c010388e:	74 24                	je     c01038b4 <default_check+0x564>
c0103890:	c7 44 24 0c b6 67 10 	movl   $0xc01067b6,0xc(%esp)
c0103897:	c0 
c0103898:	c7 44 24 08 56 66 10 	movl   $0xc0106656,0x8(%esp)
c010389f:	c0 
c01038a0:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c01038a7:	00 
c01038a8:	c7 04 24 6b 66 10 c0 	movl   $0xc010666b,(%esp)
c01038af:	e8 19 d4 ff ff       	call   c0100ccd <__panic>

    assert(nr_free == 0);
c01038b4:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c01038b9:	85 c0                	test   %eax,%eax
c01038bb:	74 24                	je     c01038e1 <default_check+0x591>
c01038bd:	c7 44 24 0c 09 68 10 	movl   $0xc0106809,0xc(%esp)
c01038c4:	c0 
c01038c5:	c7 44 24 08 56 66 10 	movl   $0xc0106656,0x8(%esp)
c01038cc:	c0 
c01038cd:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c01038d4:	00 
c01038d5:	c7 04 24 6b 66 10 c0 	movl   $0xc010666b,(%esp)
c01038dc:	e8 ec d3 ff ff       	call   c0100ccd <__panic>
    nr_free = nr_free_store;
c01038e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01038e4:	a3 58 89 11 c0       	mov    %eax,0xc0118958

    free_list = free_list_store;
c01038e9:	8b 45 80             	mov    -0x80(%ebp),%eax
c01038ec:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01038ef:	a3 50 89 11 c0       	mov    %eax,0xc0118950
c01038f4:	89 15 54 89 11 c0    	mov    %edx,0xc0118954
    free_pages(p0, 5);
c01038fa:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0103901:	00 
c0103902:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103905:	89 04 24             	mov    %eax,(%esp)
c0103908:	e8 e9 03 00 00       	call   c0103cf6 <free_pages>

    le = &free_list;
c010390d:	c7 45 ec 50 89 11 c0 	movl   $0xc0118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103914:	eb 1d                	jmp    c0103933 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c0103916:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103919:	83 e8 0c             	sub    $0xc,%eax
c010391c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c010391f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0103923:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103926:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103929:	8b 40 08             	mov    0x8(%eax),%eax
c010392c:	29 c2                	sub    %eax,%edx
c010392e:	89 d0                	mov    %edx,%eax
c0103930:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103933:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103936:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103939:	8b 45 88             	mov    -0x78(%ebp),%eax
c010393c:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c010393f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103942:	81 7d ec 50 89 11 c0 	cmpl   $0xc0118950,-0x14(%ebp)
c0103949:	75 cb                	jne    c0103916 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c010394b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010394f:	74 24                	je     c0103975 <default_check+0x625>
c0103951:	c7 44 24 0c 76 69 10 	movl   $0xc0106976,0xc(%esp)
c0103958:	c0 
c0103959:	c7 44 24 08 56 66 10 	movl   $0xc0106656,0x8(%esp)
c0103960:	c0 
c0103961:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c0103968:	00 
c0103969:	c7 04 24 6b 66 10 c0 	movl   $0xc010666b,(%esp)
c0103970:	e8 58 d3 ff ff       	call   c0100ccd <__panic>
    assert(total == 0);
c0103975:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103979:	74 24                	je     c010399f <default_check+0x64f>
c010397b:	c7 44 24 0c 81 69 10 	movl   $0xc0106981,0xc(%esp)
c0103982:	c0 
c0103983:	c7 44 24 08 56 66 10 	movl   $0xc0106656,0x8(%esp)
c010398a:	c0 
c010398b:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
c0103992:	00 
c0103993:	c7 04 24 6b 66 10 c0 	movl   $0xc010666b,(%esp)
c010399a:	e8 2e d3 ff ff       	call   c0100ccd <__panic>
}
c010399f:	81 c4 94 00 00 00    	add    $0x94,%esp
c01039a5:	5b                   	pop    %ebx
c01039a6:	5d                   	pop    %ebp
c01039a7:	c3                   	ret    

c01039a8 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01039a8:	55                   	push   %ebp
c01039a9:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01039ab:	8b 55 08             	mov    0x8(%ebp),%edx
c01039ae:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c01039b3:	29 c2                	sub    %eax,%edx
c01039b5:	89 d0                	mov    %edx,%eax
c01039b7:	c1 f8 02             	sar    $0x2,%eax
c01039ba:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c01039c0:	5d                   	pop    %ebp
c01039c1:	c3                   	ret    

c01039c2 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01039c2:	55                   	push   %ebp
c01039c3:	89 e5                	mov    %esp,%ebp
c01039c5:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01039c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01039cb:	89 04 24             	mov    %eax,(%esp)
c01039ce:	e8 d5 ff ff ff       	call   c01039a8 <page2ppn>
c01039d3:	c1 e0 0c             	shl    $0xc,%eax
}
c01039d6:	c9                   	leave  
c01039d7:	c3                   	ret    

c01039d8 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c01039d8:	55                   	push   %ebp
c01039d9:	89 e5                	mov    %esp,%ebp
c01039db:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c01039de:	8b 45 08             	mov    0x8(%ebp),%eax
c01039e1:	c1 e8 0c             	shr    $0xc,%eax
c01039e4:	89 c2                	mov    %eax,%edx
c01039e6:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01039eb:	39 c2                	cmp    %eax,%edx
c01039ed:	72 1c                	jb     c0103a0b <pa2page+0x33>
        panic("pa2page called with invalid pa");
c01039ef:	c7 44 24 08 bc 69 10 	movl   $0xc01069bc,0x8(%esp)
c01039f6:	c0 
c01039f7:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c01039fe:	00 
c01039ff:	c7 04 24 db 69 10 c0 	movl   $0xc01069db,(%esp)
c0103a06:	e8 c2 d2 ff ff       	call   c0100ccd <__panic>
    }
    return &pages[PPN(pa)];
c0103a0b:	8b 0d 64 89 11 c0    	mov    0xc0118964,%ecx
c0103a11:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a14:	c1 e8 0c             	shr    $0xc,%eax
c0103a17:	89 c2                	mov    %eax,%edx
c0103a19:	89 d0                	mov    %edx,%eax
c0103a1b:	c1 e0 02             	shl    $0x2,%eax
c0103a1e:	01 d0                	add    %edx,%eax
c0103a20:	c1 e0 02             	shl    $0x2,%eax
c0103a23:	01 c8                	add    %ecx,%eax
}
c0103a25:	c9                   	leave  
c0103a26:	c3                   	ret    

c0103a27 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0103a27:	55                   	push   %ebp
c0103a28:	89 e5                	mov    %esp,%ebp
c0103a2a:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0103a2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a30:	89 04 24             	mov    %eax,(%esp)
c0103a33:	e8 8a ff ff ff       	call   c01039c2 <page2pa>
c0103a38:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a3e:	c1 e8 0c             	shr    $0xc,%eax
c0103a41:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103a44:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103a49:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103a4c:	72 23                	jb     c0103a71 <page2kva+0x4a>
c0103a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a51:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103a55:	c7 44 24 08 ec 69 10 	movl   $0xc01069ec,0x8(%esp)
c0103a5c:	c0 
c0103a5d:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0103a64:	00 
c0103a65:	c7 04 24 db 69 10 c0 	movl   $0xc01069db,(%esp)
c0103a6c:	e8 5c d2 ff ff       	call   c0100ccd <__panic>
c0103a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a74:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0103a79:	c9                   	leave  
c0103a7a:	c3                   	ret    

c0103a7b <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0103a7b:	55                   	push   %ebp
c0103a7c:	89 e5                	mov    %esp,%ebp
c0103a7e:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0103a81:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a84:	83 e0 01             	and    $0x1,%eax
c0103a87:	85 c0                	test   %eax,%eax
c0103a89:	75 1c                	jne    c0103aa7 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0103a8b:	c7 44 24 08 10 6a 10 	movl   $0xc0106a10,0x8(%esp)
c0103a92:	c0 
c0103a93:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0103a9a:	00 
c0103a9b:	c7 04 24 db 69 10 c0 	movl   $0xc01069db,(%esp)
c0103aa2:	e8 26 d2 ff ff       	call   c0100ccd <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0103aa7:	8b 45 08             	mov    0x8(%ebp),%eax
c0103aaa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103aaf:	89 04 24             	mov    %eax,(%esp)
c0103ab2:	e8 21 ff ff ff       	call   c01039d8 <pa2page>
}
c0103ab7:	c9                   	leave  
c0103ab8:	c3                   	ret    

c0103ab9 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0103ab9:	55                   	push   %ebp
c0103aba:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103abc:	8b 45 08             	mov    0x8(%ebp),%eax
c0103abf:	8b 00                	mov    (%eax),%eax
}
c0103ac1:	5d                   	pop    %ebp
c0103ac2:	c3                   	ret    

c0103ac3 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0103ac3:	55                   	push   %ebp
c0103ac4:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103ac6:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ac9:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103acc:	89 10                	mov    %edx,(%eax)
}
c0103ace:	5d                   	pop    %ebp
c0103acf:	c3                   	ret    

c0103ad0 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0103ad0:	55                   	push   %ebp
c0103ad1:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0103ad3:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ad6:	8b 00                	mov    (%eax),%eax
c0103ad8:	8d 50 01             	lea    0x1(%eax),%edx
c0103adb:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ade:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103ae0:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ae3:	8b 00                	mov    (%eax),%eax
}
c0103ae5:	5d                   	pop    %ebp
c0103ae6:	c3                   	ret    

c0103ae7 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0103ae7:	55                   	push   %ebp
c0103ae8:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0103aea:	8b 45 08             	mov    0x8(%ebp),%eax
c0103aed:	8b 00                	mov    (%eax),%eax
c0103aef:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103af2:	8b 45 08             	mov    0x8(%ebp),%eax
c0103af5:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103af7:	8b 45 08             	mov    0x8(%ebp),%eax
c0103afa:	8b 00                	mov    (%eax),%eax
}
c0103afc:	5d                   	pop    %ebp
c0103afd:	c3                   	ret    

c0103afe <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0103afe:	55                   	push   %ebp
c0103aff:	89 e5                	mov    %esp,%ebp
c0103b01:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0103b04:	9c                   	pushf  
c0103b05:	58                   	pop    %eax
c0103b06:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0103b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0103b0c:	25 00 02 00 00       	and    $0x200,%eax
c0103b11:	85 c0                	test   %eax,%eax
c0103b13:	74 0c                	je     c0103b21 <__intr_save+0x23>
        intr_disable();
c0103b15:	e8 96 db ff ff       	call   c01016b0 <intr_disable>
        return 1;
c0103b1a:	b8 01 00 00 00       	mov    $0x1,%eax
c0103b1f:	eb 05                	jmp    c0103b26 <__intr_save+0x28>
    }
    return 0;
c0103b21:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103b26:	c9                   	leave  
c0103b27:	c3                   	ret    

c0103b28 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0103b28:	55                   	push   %ebp
c0103b29:	89 e5                	mov    %esp,%ebp
c0103b2b:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0103b2e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103b32:	74 05                	je     c0103b39 <__intr_restore+0x11>
        intr_enable();
c0103b34:	e8 71 db ff ff       	call   c01016aa <intr_enable>
    }
}
c0103b39:	c9                   	leave  
c0103b3a:	c3                   	ret    

c0103b3b <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103b3b:	55                   	push   %ebp
c0103b3c:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103b3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b41:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0103b44:	b8 23 00 00 00       	mov    $0x23,%eax
c0103b49:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103b4b:	b8 23 00 00 00       	mov    $0x23,%eax
c0103b50:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0103b52:	b8 10 00 00 00       	mov    $0x10,%eax
c0103b57:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103b59:	b8 10 00 00 00       	mov    $0x10,%eax
c0103b5e:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0103b60:	b8 10 00 00 00       	mov    $0x10,%eax
c0103b65:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103b67:	ea 6e 3b 10 c0 08 00 	ljmp   $0x8,$0xc0103b6e
}
c0103b6e:	5d                   	pop    %ebp
c0103b6f:	c3                   	ret    

c0103b70 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103b70:	55                   	push   %ebp
c0103b71:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103b73:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b76:	a3 e4 88 11 c0       	mov    %eax,0xc01188e4
}
c0103b7b:	5d                   	pop    %ebp
c0103b7c:	c3                   	ret    

c0103b7d <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103b7d:	55                   	push   %ebp
c0103b7e:	89 e5                	mov    %esp,%ebp
c0103b80:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0103b83:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c0103b88:	89 04 24             	mov    %eax,(%esp)
c0103b8b:	e8 e0 ff ff ff       	call   c0103b70 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0103b90:	66 c7 05 e8 88 11 c0 	movw   $0x10,0xc01188e8
c0103b97:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103b99:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c0103ba0:	68 00 
c0103ba2:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103ba7:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c0103bad:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103bb2:	c1 e8 10             	shr    $0x10,%eax
c0103bb5:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0103bba:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103bc1:	83 e0 f0             	and    $0xfffffff0,%eax
c0103bc4:	83 c8 09             	or     $0x9,%eax
c0103bc7:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103bcc:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103bd3:	83 e0 ef             	and    $0xffffffef,%eax
c0103bd6:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103bdb:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103be2:	83 e0 9f             	and    $0xffffff9f,%eax
c0103be5:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103bea:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103bf1:	83 c8 80             	or     $0xffffff80,%eax
c0103bf4:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103bf9:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c00:	83 e0 f0             	and    $0xfffffff0,%eax
c0103c03:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c08:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c0f:	83 e0 ef             	and    $0xffffffef,%eax
c0103c12:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c17:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c1e:	83 e0 df             	and    $0xffffffdf,%eax
c0103c21:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c26:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c2d:	83 c8 40             	or     $0x40,%eax
c0103c30:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c35:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c3c:	83 e0 7f             	and    $0x7f,%eax
c0103c3f:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c44:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103c49:	c1 e8 18             	shr    $0x18,%eax
c0103c4c:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103c51:	c7 04 24 30 7a 11 c0 	movl   $0xc0117a30,(%esp)
c0103c58:	e8 de fe ff ff       	call   c0103b3b <lgdt>
c0103c5d:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103c63:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103c67:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0103c6a:	c9                   	leave  
c0103c6b:	c3                   	ret    

c0103c6c <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103c6c:	55                   	push   %ebp
c0103c6d:	89 e5                	mov    %esp,%ebp
c0103c6f:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0103c72:	c7 05 5c 89 11 c0 a0 	movl   $0xc01069a0,0xc011895c
c0103c79:	69 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103c7c:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103c81:	8b 00                	mov    (%eax),%eax
c0103c83:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103c87:	c7 04 24 3c 6a 10 c0 	movl   $0xc0106a3c,(%esp)
c0103c8e:	e8 a9 c6 ff ff       	call   c010033c <cprintf>
    pmm_manager->init();
c0103c93:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103c98:	8b 40 04             	mov    0x4(%eax),%eax
c0103c9b:	ff d0                	call   *%eax
}
c0103c9d:	c9                   	leave  
c0103c9e:	c3                   	ret    

c0103c9f <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103c9f:	55                   	push   %ebp
c0103ca0:	89 e5                	mov    %esp,%ebp
c0103ca2:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0103ca5:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103caa:	8b 40 08             	mov    0x8(%eax),%eax
c0103cad:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103cb0:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103cb4:	8b 55 08             	mov    0x8(%ebp),%edx
c0103cb7:	89 14 24             	mov    %edx,(%esp)
c0103cba:	ff d0                	call   *%eax
}
c0103cbc:	c9                   	leave  
c0103cbd:	c3                   	ret    

c0103cbe <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103cbe:	55                   	push   %ebp
c0103cbf:	89 e5                	mov    %esp,%ebp
c0103cc1:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0103cc4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103ccb:	e8 2e fe ff ff       	call   c0103afe <__intr_save>
c0103cd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103cd3:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103cd8:	8b 40 0c             	mov    0xc(%eax),%eax
c0103cdb:	8b 55 08             	mov    0x8(%ebp),%edx
c0103cde:	89 14 24             	mov    %edx,(%esp)
c0103ce1:	ff d0                	call   *%eax
c0103ce3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103ce6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ce9:	89 04 24             	mov    %eax,(%esp)
c0103cec:	e8 37 fe ff ff       	call   c0103b28 <__intr_restore>
    return page;
c0103cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103cf4:	c9                   	leave  
c0103cf5:	c3                   	ret    

c0103cf6 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103cf6:	55                   	push   %ebp
c0103cf7:	89 e5                	mov    %esp,%ebp
c0103cf9:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103cfc:	e8 fd fd ff ff       	call   c0103afe <__intr_save>
c0103d01:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103d04:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103d09:	8b 40 10             	mov    0x10(%eax),%eax
c0103d0c:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103d0f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103d13:	8b 55 08             	mov    0x8(%ebp),%edx
c0103d16:	89 14 24             	mov    %edx,(%esp)
c0103d19:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0103d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d1e:	89 04 24             	mov    %eax,(%esp)
c0103d21:	e8 02 fe ff ff       	call   c0103b28 <__intr_restore>
}
c0103d26:	c9                   	leave  
c0103d27:	c3                   	ret    

c0103d28 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103d28:	55                   	push   %ebp
c0103d29:	89 e5                	mov    %esp,%ebp
c0103d2b:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103d2e:	e8 cb fd ff ff       	call   c0103afe <__intr_save>
c0103d33:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103d36:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103d3b:	8b 40 14             	mov    0x14(%eax),%eax
c0103d3e:	ff d0                	call   *%eax
c0103d40:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0103d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d46:	89 04 24             	mov    %eax,(%esp)
c0103d49:	e8 da fd ff ff       	call   c0103b28 <__intr_restore>
    return ret;
c0103d4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103d51:	c9                   	leave  
c0103d52:	c3                   	ret    

c0103d53 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0103d53:	55                   	push   %ebp
c0103d54:	89 e5                	mov    %esp,%ebp
c0103d56:	57                   	push   %edi
c0103d57:	56                   	push   %esi
c0103d58:	53                   	push   %ebx
c0103d59:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0103d5f:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0103d66:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0103d6d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0103d74:	c7 04 24 53 6a 10 c0 	movl   $0xc0106a53,(%esp)
c0103d7b:	e8 bc c5 ff ff       	call   c010033c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103d80:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103d87:	e9 15 01 00 00       	jmp    c0103ea1 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103d8c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103d8f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103d92:	89 d0                	mov    %edx,%eax
c0103d94:	c1 e0 02             	shl    $0x2,%eax
c0103d97:	01 d0                	add    %edx,%eax
c0103d99:	c1 e0 02             	shl    $0x2,%eax
c0103d9c:	01 c8                	add    %ecx,%eax
c0103d9e:	8b 50 08             	mov    0x8(%eax),%edx
c0103da1:	8b 40 04             	mov    0x4(%eax),%eax
c0103da4:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103da7:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0103daa:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103dad:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103db0:	89 d0                	mov    %edx,%eax
c0103db2:	c1 e0 02             	shl    $0x2,%eax
c0103db5:	01 d0                	add    %edx,%eax
c0103db7:	c1 e0 02             	shl    $0x2,%eax
c0103dba:	01 c8                	add    %ecx,%eax
c0103dbc:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103dbf:	8b 58 10             	mov    0x10(%eax),%ebx
c0103dc2:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103dc5:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103dc8:	01 c8                	add    %ecx,%eax
c0103dca:	11 da                	adc    %ebx,%edx
c0103dcc:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0103dcf:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0103dd2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103dd5:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103dd8:	89 d0                	mov    %edx,%eax
c0103dda:	c1 e0 02             	shl    $0x2,%eax
c0103ddd:	01 d0                	add    %edx,%eax
c0103ddf:	c1 e0 02             	shl    $0x2,%eax
c0103de2:	01 c8                	add    %ecx,%eax
c0103de4:	83 c0 14             	add    $0x14,%eax
c0103de7:	8b 00                	mov    (%eax),%eax
c0103de9:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0103def:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103df2:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103df5:	83 c0 ff             	add    $0xffffffff,%eax
c0103df8:	83 d2 ff             	adc    $0xffffffff,%edx
c0103dfb:	89 c6                	mov    %eax,%esi
c0103dfd:	89 d7                	mov    %edx,%edi
c0103dff:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e02:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e05:	89 d0                	mov    %edx,%eax
c0103e07:	c1 e0 02             	shl    $0x2,%eax
c0103e0a:	01 d0                	add    %edx,%eax
c0103e0c:	c1 e0 02             	shl    $0x2,%eax
c0103e0f:	01 c8                	add    %ecx,%eax
c0103e11:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103e14:	8b 58 10             	mov    0x10(%eax),%ebx
c0103e17:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0103e1d:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0103e21:	89 74 24 14          	mov    %esi,0x14(%esp)
c0103e25:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0103e29:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103e2c:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103e2f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103e33:	89 54 24 10          	mov    %edx,0x10(%esp)
c0103e37:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0103e3b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0103e3f:	c7 04 24 60 6a 10 c0 	movl   $0xc0106a60,(%esp)
c0103e46:	e8 f1 c4 ff ff       	call   c010033c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0103e4b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e4e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e51:	89 d0                	mov    %edx,%eax
c0103e53:	c1 e0 02             	shl    $0x2,%eax
c0103e56:	01 d0                	add    %edx,%eax
c0103e58:	c1 e0 02             	shl    $0x2,%eax
c0103e5b:	01 c8                	add    %ecx,%eax
c0103e5d:	83 c0 14             	add    $0x14,%eax
c0103e60:	8b 00                	mov    (%eax),%eax
c0103e62:	83 f8 01             	cmp    $0x1,%eax
c0103e65:	75 36                	jne    c0103e9d <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c0103e67:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103e6a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103e6d:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103e70:	77 2b                	ja     c0103e9d <page_init+0x14a>
c0103e72:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103e75:	72 05                	jb     c0103e7c <page_init+0x129>
c0103e77:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0103e7a:	73 21                	jae    c0103e9d <page_init+0x14a>
c0103e7c:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103e80:	77 1b                	ja     c0103e9d <page_init+0x14a>
c0103e82:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103e86:	72 09                	jb     c0103e91 <page_init+0x13e>
c0103e88:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0103e8f:	77 0c                	ja     c0103e9d <page_init+0x14a>
                maxpa = end;
c0103e91:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103e94:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103e97:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103e9a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103e9d:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103ea1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103ea4:	8b 00                	mov    (%eax),%eax
c0103ea6:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103ea9:	0f 8f dd fe ff ff    	jg     c0103d8c <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0103eaf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103eb3:	72 1d                	jb     c0103ed2 <page_init+0x17f>
c0103eb5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103eb9:	77 09                	ja     c0103ec4 <page_init+0x171>
c0103ebb:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0103ec2:	76 0e                	jbe    c0103ed2 <page_init+0x17f>
        maxpa = KMEMSIZE;
c0103ec4:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0103ecb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0103ed2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103ed5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103ed8:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103edc:	c1 ea 0c             	shr    $0xc,%edx
c0103edf:	a3 c0 88 11 c0       	mov    %eax,0xc01188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0103ee4:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0103eeb:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c0103ef0:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103ef3:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103ef6:	01 d0                	add    %edx,%eax
c0103ef8:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0103efb:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103efe:	ba 00 00 00 00       	mov    $0x0,%edx
c0103f03:	f7 75 ac             	divl   -0x54(%ebp)
c0103f06:	89 d0                	mov    %edx,%eax
c0103f08:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0103f0b:	29 c2                	sub    %eax,%edx
c0103f0d:	89 d0                	mov    %edx,%eax
c0103f0f:	a3 64 89 11 c0       	mov    %eax,0xc0118964

    for (i = 0; i < npage; i ++) {
c0103f14:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103f1b:	eb 2f                	jmp    c0103f4c <page_init+0x1f9>
        SetPageReserved(pages + i);
c0103f1d:	8b 0d 64 89 11 c0    	mov    0xc0118964,%ecx
c0103f23:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f26:	89 d0                	mov    %edx,%eax
c0103f28:	c1 e0 02             	shl    $0x2,%eax
c0103f2b:	01 d0                	add    %edx,%eax
c0103f2d:	c1 e0 02             	shl    $0x2,%eax
c0103f30:	01 c8                	add    %ecx,%eax
c0103f32:	83 c0 04             	add    $0x4,%eax
c0103f35:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0103f3c:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103f3f:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0103f42:	8b 55 90             	mov    -0x70(%ebp),%edx
c0103f45:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0103f48:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103f4c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f4f:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103f54:	39 c2                	cmp    %eax,%edx
c0103f56:	72 c5                	jb     c0103f1d <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0103f58:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0103f5e:	89 d0                	mov    %edx,%eax
c0103f60:	c1 e0 02             	shl    $0x2,%eax
c0103f63:	01 d0                	add    %edx,%eax
c0103f65:	c1 e0 02             	shl    $0x2,%eax
c0103f68:	89 c2                	mov    %eax,%edx
c0103f6a:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0103f6f:	01 d0                	add    %edx,%eax
c0103f71:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0103f74:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0103f7b:	77 23                	ja     c0103fa0 <page_init+0x24d>
c0103f7d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103f80:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103f84:	c7 44 24 08 90 6a 10 	movl   $0xc0106a90,0x8(%esp)
c0103f8b:	c0 
c0103f8c:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0103f93:	00 
c0103f94:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c0103f9b:	e8 2d cd ff ff       	call   c0100ccd <__panic>
c0103fa0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103fa3:	05 00 00 00 40       	add    $0x40000000,%eax
c0103fa8:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0103fab:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103fb2:	e9 74 01 00 00       	jmp    c010412b <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103fb7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103fba:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103fbd:	89 d0                	mov    %edx,%eax
c0103fbf:	c1 e0 02             	shl    $0x2,%eax
c0103fc2:	01 d0                	add    %edx,%eax
c0103fc4:	c1 e0 02             	shl    $0x2,%eax
c0103fc7:	01 c8                	add    %ecx,%eax
c0103fc9:	8b 50 08             	mov    0x8(%eax),%edx
c0103fcc:	8b 40 04             	mov    0x4(%eax),%eax
c0103fcf:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103fd2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103fd5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103fd8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103fdb:	89 d0                	mov    %edx,%eax
c0103fdd:	c1 e0 02             	shl    $0x2,%eax
c0103fe0:	01 d0                	add    %edx,%eax
c0103fe2:	c1 e0 02             	shl    $0x2,%eax
c0103fe5:	01 c8                	add    %ecx,%eax
c0103fe7:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103fea:	8b 58 10             	mov    0x10(%eax),%ebx
c0103fed:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103ff0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103ff3:	01 c8                	add    %ecx,%eax
c0103ff5:	11 da                	adc    %ebx,%edx
c0103ff7:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0103ffa:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0103ffd:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104000:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104003:	89 d0                	mov    %edx,%eax
c0104005:	c1 e0 02             	shl    $0x2,%eax
c0104008:	01 d0                	add    %edx,%eax
c010400a:	c1 e0 02             	shl    $0x2,%eax
c010400d:	01 c8                	add    %ecx,%eax
c010400f:	83 c0 14             	add    $0x14,%eax
c0104012:	8b 00                	mov    (%eax),%eax
c0104014:	83 f8 01             	cmp    $0x1,%eax
c0104017:	0f 85 0a 01 00 00    	jne    c0104127 <page_init+0x3d4>
            if (begin < freemem) {
c010401d:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104020:	ba 00 00 00 00       	mov    $0x0,%edx
c0104025:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0104028:	72 17                	jb     c0104041 <page_init+0x2ee>
c010402a:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010402d:	77 05                	ja     c0104034 <page_init+0x2e1>
c010402f:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0104032:	76 0d                	jbe    c0104041 <page_init+0x2ee>
                begin = freemem;
c0104034:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104037:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010403a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0104041:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0104045:	72 1d                	jb     c0104064 <page_init+0x311>
c0104047:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010404b:	77 09                	ja     c0104056 <page_init+0x303>
c010404d:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0104054:	76 0e                	jbe    c0104064 <page_init+0x311>
                end = KMEMSIZE;
c0104056:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c010405d:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0104064:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104067:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010406a:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010406d:	0f 87 b4 00 00 00    	ja     c0104127 <page_init+0x3d4>
c0104073:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104076:	72 09                	jb     c0104081 <page_init+0x32e>
c0104078:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c010407b:	0f 83 a6 00 00 00    	jae    c0104127 <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
c0104081:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0104088:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010408b:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010408e:	01 d0                	add    %edx,%eax
c0104090:	83 e8 01             	sub    $0x1,%eax
c0104093:	89 45 98             	mov    %eax,-0x68(%ebp)
c0104096:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104099:	ba 00 00 00 00       	mov    $0x0,%edx
c010409e:	f7 75 9c             	divl   -0x64(%ebp)
c01040a1:	89 d0                	mov    %edx,%eax
c01040a3:	8b 55 98             	mov    -0x68(%ebp),%edx
c01040a6:	29 c2                	sub    %eax,%edx
c01040a8:	89 d0                	mov    %edx,%eax
c01040aa:	ba 00 00 00 00       	mov    $0x0,%edx
c01040af:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01040b2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c01040b5:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01040b8:	89 45 94             	mov    %eax,-0x6c(%ebp)
c01040bb:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01040be:	ba 00 00 00 00       	mov    $0x0,%edx
c01040c3:	89 c7                	mov    %eax,%edi
c01040c5:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c01040cb:	89 7d 80             	mov    %edi,-0x80(%ebp)
c01040ce:	89 d0                	mov    %edx,%eax
c01040d0:	83 e0 00             	and    $0x0,%eax
c01040d3:	89 45 84             	mov    %eax,-0x7c(%ebp)
c01040d6:	8b 45 80             	mov    -0x80(%ebp),%eax
c01040d9:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01040dc:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01040df:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c01040e2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01040e5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01040e8:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01040eb:	77 3a                	ja     c0104127 <page_init+0x3d4>
c01040ed:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01040f0:	72 05                	jb     c01040f7 <page_init+0x3a4>
c01040f2:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01040f5:	73 30                	jae    c0104127 <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c01040f7:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c01040fa:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c01040fd:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104100:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104103:	29 c8                	sub    %ecx,%eax
c0104105:	19 da                	sbb    %ebx,%edx
c0104107:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010410b:	c1 ea 0c             	shr    $0xc,%edx
c010410e:	89 c3                	mov    %eax,%ebx
c0104110:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104113:	89 04 24             	mov    %eax,(%esp)
c0104116:	e8 bd f8 ff ff       	call   c01039d8 <pa2page>
c010411b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c010411f:	89 04 24             	mov    %eax,(%esp)
c0104122:	e8 78 fb ff ff       	call   c0103c9f <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c0104127:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c010412b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010412e:	8b 00                	mov    (%eax),%eax
c0104130:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104133:	0f 8f 7e fe ff ff    	jg     c0103fb7 <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c0104139:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c010413f:	5b                   	pop    %ebx
c0104140:	5e                   	pop    %esi
c0104141:	5f                   	pop    %edi
c0104142:	5d                   	pop    %ebp
c0104143:	c3                   	ret    

c0104144 <enable_paging>:

static void
enable_paging(void) {
c0104144:	55                   	push   %ebp
c0104145:	89 e5                	mov    %esp,%ebp
c0104147:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c010414a:	a1 60 89 11 c0       	mov    0xc0118960,%eax
c010414f:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c0104152:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0104155:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c0104158:	0f 20 c0             	mov    %cr0,%eax
c010415b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c010415e:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c0104161:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c0104164:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c010416b:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c010416f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104172:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c0104175:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104178:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c010417b:	c9                   	leave  
c010417c:	c3                   	ret    

c010417d <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c010417d:	55                   	push   %ebp
c010417e:	89 e5                	mov    %esp,%ebp
c0104180:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0104183:	8b 45 14             	mov    0x14(%ebp),%eax
c0104186:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104189:	31 d0                	xor    %edx,%eax
c010418b:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104190:	85 c0                	test   %eax,%eax
c0104192:	74 24                	je     c01041b8 <boot_map_segment+0x3b>
c0104194:	c7 44 24 0c c2 6a 10 	movl   $0xc0106ac2,0xc(%esp)
c010419b:	c0 
c010419c:	c7 44 24 08 d9 6a 10 	movl   $0xc0106ad9,0x8(%esp)
c01041a3:	c0 
c01041a4:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c01041ab:	00 
c01041ac:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c01041b3:	e8 15 cb ff ff       	call   c0100ccd <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c01041b8:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c01041bf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01041c2:	25 ff 0f 00 00       	and    $0xfff,%eax
c01041c7:	89 c2                	mov    %eax,%edx
c01041c9:	8b 45 10             	mov    0x10(%ebp),%eax
c01041cc:	01 c2                	add    %eax,%edx
c01041ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01041d1:	01 d0                	add    %edx,%eax
c01041d3:	83 e8 01             	sub    $0x1,%eax
c01041d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01041d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01041dc:	ba 00 00 00 00       	mov    $0x0,%edx
c01041e1:	f7 75 f0             	divl   -0x10(%ebp)
c01041e4:	89 d0                	mov    %edx,%eax
c01041e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01041e9:	29 c2                	sub    %eax,%edx
c01041eb:	89 d0                	mov    %edx,%eax
c01041ed:	c1 e8 0c             	shr    $0xc,%eax
c01041f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c01041f3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01041f6:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01041f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01041fc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104201:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0104204:	8b 45 14             	mov    0x14(%ebp),%eax
c0104207:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010420a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010420d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104212:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104215:	eb 6b                	jmp    c0104282 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0104217:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010421e:	00 
c010421f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104222:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104226:	8b 45 08             	mov    0x8(%ebp),%eax
c0104229:	89 04 24             	mov    %eax,(%esp)
c010422c:	e8 cc 01 00 00       	call   c01043fd <get_pte>
c0104231:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0104234:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104238:	75 24                	jne    c010425e <boot_map_segment+0xe1>
c010423a:	c7 44 24 0c ee 6a 10 	movl   $0xc0106aee,0xc(%esp)
c0104241:	c0 
c0104242:	c7 44 24 08 d9 6a 10 	movl   $0xc0106ad9,0x8(%esp)
c0104249:	c0 
c010424a:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c0104251:	00 
c0104252:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c0104259:	e8 6f ca ff ff       	call   c0100ccd <__panic>
        *ptep = pa | PTE_P | perm;
c010425e:	8b 45 18             	mov    0x18(%ebp),%eax
c0104261:	8b 55 14             	mov    0x14(%ebp),%edx
c0104264:	09 d0                	or     %edx,%eax
c0104266:	83 c8 01             	or     $0x1,%eax
c0104269:	89 c2                	mov    %eax,%edx
c010426b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010426e:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104270:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104274:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c010427b:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0104282:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104286:	75 8f                	jne    c0104217 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c0104288:	c9                   	leave  
c0104289:	c3                   	ret    

c010428a <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c010428a:	55                   	push   %ebp
c010428b:	89 e5                	mov    %esp,%ebp
c010428d:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0104290:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104297:	e8 22 fa ff ff       	call   c0103cbe <alloc_pages>
c010429c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c010429f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01042a3:	75 1c                	jne    c01042c1 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c01042a5:	c7 44 24 08 fb 6a 10 	movl   $0xc0106afb,0x8(%esp)
c01042ac:	c0 
c01042ad:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c01042b4:	00 
c01042b5:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c01042bc:	e8 0c ca ff ff       	call   c0100ccd <__panic>
    }
    return page2kva(p);
c01042c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042c4:	89 04 24             	mov    %eax,(%esp)
c01042c7:	e8 5b f7 ff ff       	call   c0103a27 <page2kva>
}
c01042cc:	c9                   	leave  
c01042cd:	c3                   	ret    

c01042ce <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c01042ce:	55                   	push   %ebp
c01042cf:	89 e5                	mov    %esp,%ebp
c01042d1:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c01042d4:	e8 93 f9 ff ff       	call   c0103c6c <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c01042d9:	e8 75 fa ff ff       	call   c0103d53 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c01042de:	e8 67 04 00 00       	call   c010474a <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c01042e3:	e8 a2 ff ff ff       	call   c010428a <boot_alloc_page>
c01042e8:	a3 c4 88 11 c0       	mov    %eax,0xc01188c4
    memset(boot_pgdir, 0, PGSIZE);
c01042ed:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01042f2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01042f9:	00 
c01042fa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104301:	00 
c0104302:	89 04 24             	mov    %eax,(%esp)
c0104305:	e8 a9 1a 00 00       	call   c0105db3 <memset>
    boot_cr3 = PADDR(boot_pgdir);
c010430a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010430f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104312:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104319:	77 23                	ja     c010433e <pmm_init+0x70>
c010431b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010431e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104322:	c7 44 24 08 90 6a 10 	movl   $0xc0106a90,0x8(%esp)
c0104329:	c0 
c010432a:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c0104331:	00 
c0104332:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c0104339:	e8 8f c9 ff ff       	call   c0100ccd <__panic>
c010433e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104341:	05 00 00 00 40       	add    $0x40000000,%eax
c0104346:	a3 60 89 11 c0       	mov    %eax,0xc0118960

    check_pgdir();
c010434b:	e8 18 04 00 00       	call   c0104768 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0104350:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104355:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c010435b:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104360:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104363:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c010436a:	77 23                	ja     c010438f <pmm_init+0xc1>
c010436c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010436f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104373:	c7 44 24 08 90 6a 10 	movl   $0xc0106a90,0x8(%esp)
c010437a:	c0 
c010437b:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
c0104382:	00 
c0104383:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c010438a:	e8 3e c9 ff ff       	call   c0100ccd <__panic>
c010438f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104392:	05 00 00 00 40       	add    $0x40000000,%eax
c0104397:	83 c8 03             	or     $0x3,%eax
c010439a:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c010439c:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01043a1:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c01043a8:	00 
c01043a9:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01043b0:	00 
c01043b1:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c01043b8:	38 
c01043b9:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c01043c0:	c0 
c01043c1:	89 04 24             	mov    %eax,(%esp)
c01043c4:	e8 b4 fd ff ff       	call   c010417d <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c01043c9:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01043ce:	8b 15 c4 88 11 c0    	mov    0xc01188c4,%edx
c01043d4:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c01043da:	89 10                	mov    %edx,(%eax)

    enable_paging();
c01043dc:	e8 63 fd ff ff       	call   c0104144 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c01043e1:	e8 97 f7 ff ff       	call   c0103b7d <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c01043e6:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01043eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c01043f1:	e8 0d 0a 00 00       	call   c0104e03 <check_boot_pgdir>

    print_pgdir();
c01043f6:	e8 9a 0e 00 00       	call   c0105295 <print_pgdir>

}
c01043fb:	c9                   	leave  
c01043fc:	c3                   	ret    

c01043fd <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01043fd:	55                   	push   %ebp
c01043fe:	89 e5                	mov    %esp,%ebp
c0104400:	83 ec 38             	sub    $0x38,%esp
     * DEFINEs:
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     *   PTE_W           0x002                   // page table/directory entry flags bit : Writeable
     *   PTE_U           0x004                   // page table/directory entry flags bit : User can access
     */
	pde_t *pdep = &pgdir[PDX(la)];
c0104403:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104406:	c1 e8 16             	shr    $0x16,%eax
c0104409:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104410:	8b 45 08             	mov    0x8(%ebp),%eax
c0104413:	01 d0                	add    %edx,%eax
c0104415:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (!(*pdep & PTE_P))
c0104418:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010441b:	8b 00                	mov    (%eax),%eax
c010441d:	83 e0 01             	and    $0x1,%eax
c0104420:	85 c0                	test   %eax,%eax
c0104422:	0f 85 af 00 00 00    	jne    c01044d7 <get_pte+0xda>
	{
		struct Page *p;
		p = alloc_page();
c0104428:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010442f:	e8 8a f8 ff ff       	call   c0103cbe <alloc_pages>
c0104434:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if ((!create) || (p  == NULL))
c0104437:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010443b:	74 06                	je     c0104443 <get_pte+0x46>
c010443d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104441:	75 0a                	jne    c010444d <get_pte+0x50>
		{
			return NULL;
c0104443:	b8 00 00 00 00       	mov    $0x0,%eax
c0104448:	e9 e6 00 00 00       	jmp    c0104533 <get_pte+0x136>
		}
		set_page_ref(p, 1);
c010444d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104454:	00 
c0104455:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104458:	89 04 24             	mov    %eax,(%esp)
c010445b:	e8 63 f6 ff ff       	call   c0103ac3 <set_page_ref>
		uintptr_t pa = page2pa(p);
c0104460:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104463:	89 04 24             	mov    %eax,(%esp)
c0104466:	e8 57 f5 ff ff       	call   c01039c2 <page2pa>
c010446b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		memset(KADDR(pa), 0, PGSIZE);
c010446e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104471:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104474:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104477:	c1 e8 0c             	shr    $0xc,%eax
c010447a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010447d:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104482:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104485:	72 23                	jb     c01044aa <get_pte+0xad>
c0104487:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010448a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010448e:	c7 44 24 08 ec 69 10 	movl   $0xc01069ec,0x8(%esp)
c0104495:	c0 
c0104496:	c7 44 24 04 7e 01 00 	movl   $0x17e,0x4(%esp)
c010449d:	00 
c010449e:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c01044a5:	e8 23 c8 ff ff       	call   c0100ccd <__panic>
c01044aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01044ad:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01044b2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01044b9:	00 
c01044ba:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01044c1:	00 
c01044c2:	89 04 24             	mov    %eax,(%esp)
c01044c5:	e8 e9 18 00 00       	call   c0105db3 <memset>
		*pdep = pa | PTE_U | PTE_W | PTE_P;
c01044ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01044cd:	83 c8 07             	or     $0x7,%eax
c01044d0:	89 c2                	mov    %eax,%edx
c01044d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044d5:	89 10                	mov    %edx,(%eax)
	}
	return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c01044d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044da:	8b 00                	mov    (%eax),%eax
c01044dc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01044e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01044e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01044e7:	c1 e8 0c             	shr    $0xc,%eax
c01044ea:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01044ed:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01044f2:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01044f5:	72 23                	jb     c010451a <get_pte+0x11d>
c01044f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01044fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01044fe:	c7 44 24 08 ec 69 10 	movl   $0xc01069ec,0x8(%esp)
c0104505:	c0 
c0104506:	c7 44 24 04 81 01 00 	movl   $0x181,0x4(%esp)
c010450d:	00 
c010450e:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c0104515:	e8 b3 c7 ff ff       	call   c0100ccd <__panic>
c010451a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010451d:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104522:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104525:	c1 ea 0c             	shr    $0xc,%edx
c0104528:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c010452e:	c1 e2 02             	shl    $0x2,%edx
c0104531:	01 d0                	add    %edx,%eax
}
c0104533:	c9                   	leave  
c0104534:	c3                   	ret    

c0104535 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0104535:	55                   	push   %ebp
c0104536:	89 e5                	mov    %esp,%ebp
c0104538:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010453b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104542:	00 
c0104543:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104546:	89 44 24 04          	mov    %eax,0x4(%esp)
c010454a:	8b 45 08             	mov    0x8(%ebp),%eax
c010454d:	89 04 24             	mov    %eax,(%esp)
c0104550:	e8 a8 fe ff ff       	call   c01043fd <get_pte>
c0104555:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0104558:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010455c:	74 08                	je     c0104566 <get_page+0x31>
        *ptep_store = ptep;
c010455e:	8b 45 10             	mov    0x10(%ebp),%eax
c0104561:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104564:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0104566:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010456a:	74 1b                	je     c0104587 <get_page+0x52>
c010456c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010456f:	8b 00                	mov    (%eax),%eax
c0104571:	83 e0 01             	and    $0x1,%eax
c0104574:	85 c0                	test   %eax,%eax
c0104576:	74 0f                	je     c0104587 <get_page+0x52>
        return pa2page(*ptep);
c0104578:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010457b:	8b 00                	mov    (%eax),%eax
c010457d:	89 04 24             	mov    %eax,(%esp)
c0104580:	e8 53 f4 ff ff       	call   c01039d8 <pa2page>
c0104585:	eb 05                	jmp    c010458c <get_page+0x57>
    }
    return NULL;
c0104587:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010458c:	c9                   	leave  
c010458d:	c3                   	ret    

c010458e <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c010458e:	55                   	push   %ebp
c010458f:	89 e5                	mov    %esp,%ebp
c0104591:	83 ec 28             	sub    $0x28,%esp
     *   tlb_invalidate(pde_t *pgdir, uintptr_t la) : Invalidate a TLB entry, but only if the page tables being
     *                        edited are the ones currently in use by the processor.
     * DEFINEs:
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     */
	if (*ptep & PTE_P)
c0104594:	8b 45 10             	mov    0x10(%ebp),%eax
c0104597:	8b 00                	mov    (%eax),%eax
c0104599:	83 e0 01             	and    $0x1,%eax
c010459c:	85 c0                	test   %eax,%eax
c010459e:	74 4d                	je     c01045ed <page_remove_pte+0x5f>
	{
		struct Page *p = pte2page(*ptep);
c01045a0:	8b 45 10             	mov    0x10(%ebp),%eax
c01045a3:	8b 00                	mov    (%eax),%eax
c01045a5:	89 04 24             	mov    %eax,(%esp)
c01045a8:	e8 ce f4 ff ff       	call   c0103a7b <pte2page>
c01045ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (page_ref_dec(p) == 0)
c01045b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045b3:	89 04 24             	mov    %eax,(%esp)
c01045b6:	e8 2c f5 ff ff       	call   c0103ae7 <page_ref_dec>
c01045bb:	85 c0                	test   %eax,%eax
c01045bd:	75 13                	jne    c01045d2 <page_remove_pte+0x44>
		{
			free_page(p);
c01045bf:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01045c6:	00 
c01045c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045ca:	89 04 24             	mov    %eax,(%esp)
c01045cd:	e8 24 f7 ff ff       	call   c0103cf6 <free_pages>
		}
		*ptep = 0;
c01045d2:	8b 45 10             	mov    0x10(%ebp),%eax
c01045d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		tlb_invalidate(pgdir, la);
c01045db:	8b 45 0c             	mov    0xc(%ebp),%eax
c01045de:	89 44 24 04          	mov    %eax,0x4(%esp)
c01045e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01045e5:	89 04 24             	mov    %eax,(%esp)
c01045e8:	e8 00 01 00 00       	call   c01046ed <tlb_invalidate>
	}
	return;
c01045ed:	90                   	nop
}
c01045ee:	c9                   	leave  
c01045ef:	c3                   	ret    

c01045f0 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c01045f0:	55                   	push   %ebp
c01045f1:	89 e5                	mov    %esp,%ebp
c01045f3:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01045f6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01045fd:	00 
c01045fe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104601:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104605:	8b 45 08             	mov    0x8(%ebp),%eax
c0104608:	89 04 24             	mov    %eax,(%esp)
c010460b:	e8 ed fd ff ff       	call   c01043fd <get_pte>
c0104610:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0104613:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104617:	74 19                	je     c0104632 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c0104619:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010461c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104620:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104623:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104627:	8b 45 08             	mov    0x8(%ebp),%eax
c010462a:	89 04 24             	mov    %eax,(%esp)
c010462d:	e8 5c ff ff ff       	call   c010458e <page_remove_pte>
    }
}
c0104632:	c9                   	leave  
c0104633:	c3                   	ret    

c0104634 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0104634:	55                   	push   %ebp
c0104635:	89 e5                	mov    %esp,%ebp
c0104637:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c010463a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104641:	00 
c0104642:	8b 45 10             	mov    0x10(%ebp),%eax
c0104645:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104649:	8b 45 08             	mov    0x8(%ebp),%eax
c010464c:	89 04 24             	mov    %eax,(%esp)
c010464f:	e8 a9 fd ff ff       	call   c01043fd <get_pte>
c0104654:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0104657:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010465b:	75 0a                	jne    c0104667 <page_insert+0x33>
        return -E_NO_MEM;
c010465d:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0104662:	e9 84 00 00 00       	jmp    c01046eb <page_insert+0xb7>
    }
    page_ref_inc(page);
c0104667:	8b 45 0c             	mov    0xc(%ebp),%eax
c010466a:	89 04 24             	mov    %eax,(%esp)
c010466d:	e8 5e f4 ff ff       	call   c0103ad0 <page_ref_inc>
    if (*ptep & PTE_P) {
c0104672:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104675:	8b 00                	mov    (%eax),%eax
c0104677:	83 e0 01             	and    $0x1,%eax
c010467a:	85 c0                	test   %eax,%eax
c010467c:	74 3e                	je     c01046bc <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c010467e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104681:	8b 00                	mov    (%eax),%eax
c0104683:	89 04 24             	mov    %eax,(%esp)
c0104686:	e8 f0 f3 ff ff       	call   c0103a7b <pte2page>
c010468b:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c010468e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104691:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104694:	75 0d                	jne    c01046a3 <page_insert+0x6f>
            page_ref_dec(page);
c0104696:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104699:	89 04 24             	mov    %eax,(%esp)
c010469c:	e8 46 f4 ff ff       	call   c0103ae7 <page_ref_dec>
c01046a1:	eb 19                	jmp    c01046bc <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c01046a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046a6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01046aa:	8b 45 10             	mov    0x10(%ebp),%eax
c01046ad:	89 44 24 04          	mov    %eax,0x4(%esp)
c01046b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01046b4:	89 04 24             	mov    %eax,(%esp)
c01046b7:	e8 d2 fe ff ff       	call   c010458e <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c01046bc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046bf:	89 04 24             	mov    %eax,(%esp)
c01046c2:	e8 fb f2 ff ff       	call   c01039c2 <page2pa>
c01046c7:	0b 45 14             	or     0x14(%ebp),%eax
c01046ca:	83 c8 01             	or     $0x1,%eax
c01046cd:	89 c2                	mov    %eax,%edx
c01046cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046d2:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c01046d4:	8b 45 10             	mov    0x10(%ebp),%eax
c01046d7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01046db:	8b 45 08             	mov    0x8(%ebp),%eax
c01046de:	89 04 24             	mov    %eax,(%esp)
c01046e1:	e8 07 00 00 00       	call   c01046ed <tlb_invalidate>
    return 0;
c01046e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01046eb:	c9                   	leave  
c01046ec:	c3                   	ret    

c01046ed <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c01046ed:	55                   	push   %ebp
c01046ee:	89 e5                	mov    %esp,%ebp
c01046f0:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c01046f3:	0f 20 d8             	mov    %cr3,%eax
c01046f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c01046f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c01046fc:	89 c2                	mov    %eax,%edx
c01046fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0104701:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104704:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010470b:	77 23                	ja     c0104730 <tlb_invalidate+0x43>
c010470d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104710:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104714:	c7 44 24 08 90 6a 10 	movl   $0xc0106a90,0x8(%esp)
c010471b:	c0 
c010471c:	c7 44 24 04 dd 01 00 	movl   $0x1dd,0x4(%esp)
c0104723:	00 
c0104724:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c010472b:	e8 9d c5 ff ff       	call   c0100ccd <__panic>
c0104730:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104733:	05 00 00 00 40       	add    $0x40000000,%eax
c0104738:	39 c2                	cmp    %eax,%edx
c010473a:	75 0c                	jne    c0104748 <tlb_invalidate+0x5b>
        invlpg((void *)la);
c010473c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010473f:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0104742:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104745:	0f 01 38             	invlpg (%eax)
    }
}
c0104748:	c9                   	leave  
c0104749:	c3                   	ret    

c010474a <check_alloc_page>:

static void
check_alloc_page(void) {
c010474a:	55                   	push   %ebp
c010474b:	89 e5                	mov    %esp,%ebp
c010474d:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0104750:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0104755:	8b 40 18             	mov    0x18(%eax),%eax
c0104758:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c010475a:	c7 04 24 14 6b 10 c0 	movl   $0xc0106b14,(%esp)
c0104761:	e8 d6 bb ff ff       	call   c010033c <cprintf>
}
c0104766:	c9                   	leave  
c0104767:	c3                   	ret    

c0104768 <check_pgdir>:

static void
check_pgdir(void) {
c0104768:	55                   	push   %ebp
c0104769:	89 e5                	mov    %esp,%ebp
c010476b:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c010476e:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104773:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0104778:	76 24                	jbe    c010479e <check_pgdir+0x36>
c010477a:	c7 44 24 0c 33 6b 10 	movl   $0xc0106b33,0xc(%esp)
c0104781:	c0 
c0104782:	c7 44 24 08 d9 6a 10 	movl   $0xc0106ad9,0x8(%esp)
c0104789:	c0 
c010478a:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
c0104791:	00 
c0104792:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c0104799:	e8 2f c5 ff ff       	call   c0100ccd <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c010479e:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01047a3:	85 c0                	test   %eax,%eax
c01047a5:	74 0e                	je     c01047b5 <check_pgdir+0x4d>
c01047a7:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01047ac:	25 ff 0f 00 00       	and    $0xfff,%eax
c01047b1:	85 c0                	test   %eax,%eax
c01047b3:	74 24                	je     c01047d9 <check_pgdir+0x71>
c01047b5:	c7 44 24 0c 50 6b 10 	movl   $0xc0106b50,0xc(%esp)
c01047bc:	c0 
c01047bd:	c7 44 24 08 d9 6a 10 	movl   $0xc0106ad9,0x8(%esp)
c01047c4:	c0 
c01047c5:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
c01047cc:	00 
c01047cd:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c01047d4:	e8 f4 c4 ff ff       	call   c0100ccd <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c01047d9:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01047de:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01047e5:	00 
c01047e6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01047ed:	00 
c01047ee:	89 04 24             	mov    %eax,(%esp)
c01047f1:	e8 3f fd ff ff       	call   c0104535 <get_page>
c01047f6:	85 c0                	test   %eax,%eax
c01047f8:	74 24                	je     c010481e <check_pgdir+0xb6>
c01047fa:	c7 44 24 0c 88 6b 10 	movl   $0xc0106b88,0xc(%esp)
c0104801:	c0 
c0104802:	c7 44 24 08 d9 6a 10 	movl   $0xc0106ad9,0x8(%esp)
c0104809:	c0 
c010480a:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
c0104811:	00 
c0104812:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c0104819:	e8 af c4 ff ff       	call   c0100ccd <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c010481e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104825:	e8 94 f4 ff ff       	call   c0103cbe <alloc_pages>
c010482a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c010482d:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104832:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104839:	00 
c010483a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104841:	00 
c0104842:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104845:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104849:	89 04 24             	mov    %eax,(%esp)
c010484c:	e8 e3 fd ff ff       	call   c0104634 <page_insert>
c0104851:	85 c0                	test   %eax,%eax
c0104853:	74 24                	je     c0104879 <check_pgdir+0x111>
c0104855:	c7 44 24 0c b0 6b 10 	movl   $0xc0106bb0,0xc(%esp)
c010485c:	c0 
c010485d:	c7 44 24 08 d9 6a 10 	movl   $0xc0106ad9,0x8(%esp)
c0104864:	c0 
c0104865:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
c010486c:	00 
c010486d:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c0104874:	e8 54 c4 ff ff       	call   c0100ccd <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0104879:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010487e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104885:	00 
c0104886:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010488d:	00 
c010488e:	89 04 24             	mov    %eax,(%esp)
c0104891:	e8 67 fb ff ff       	call   c01043fd <get_pte>
c0104896:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104899:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010489d:	75 24                	jne    c01048c3 <check_pgdir+0x15b>
c010489f:	c7 44 24 0c dc 6b 10 	movl   $0xc0106bdc,0xc(%esp)
c01048a6:	c0 
c01048a7:	c7 44 24 08 d9 6a 10 	movl   $0xc0106ad9,0x8(%esp)
c01048ae:	c0 
c01048af:	c7 44 24 04 f3 01 00 	movl   $0x1f3,0x4(%esp)
c01048b6:	00 
c01048b7:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c01048be:	e8 0a c4 ff ff       	call   c0100ccd <__panic>
    assert(pa2page(*ptep) == p1);
c01048c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048c6:	8b 00                	mov    (%eax),%eax
c01048c8:	89 04 24             	mov    %eax,(%esp)
c01048cb:	e8 08 f1 ff ff       	call   c01039d8 <pa2page>
c01048d0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01048d3:	74 24                	je     c01048f9 <check_pgdir+0x191>
c01048d5:	c7 44 24 0c 09 6c 10 	movl   $0xc0106c09,0xc(%esp)
c01048dc:	c0 
c01048dd:	c7 44 24 08 d9 6a 10 	movl   $0xc0106ad9,0x8(%esp)
c01048e4:	c0 
c01048e5:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
c01048ec:	00 
c01048ed:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c01048f4:	e8 d4 c3 ff ff       	call   c0100ccd <__panic>
    assert(page_ref(p1) == 1);
c01048f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048fc:	89 04 24             	mov    %eax,(%esp)
c01048ff:	e8 b5 f1 ff ff       	call   c0103ab9 <page_ref>
c0104904:	83 f8 01             	cmp    $0x1,%eax
c0104907:	74 24                	je     c010492d <check_pgdir+0x1c5>
c0104909:	c7 44 24 0c 1e 6c 10 	movl   $0xc0106c1e,0xc(%esp)
c0104910:	c0 
c0104911:	c7 44 24 08 d9 6a 10 	movl   $0xc0106ad9,0x8(%esp)
c0104918:	c0 
c0104919:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
c0104920:	00 
c0104921:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c0104928:	e8 a0 c3 ff ff       	call   c0100ccd <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c010492d:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104932:	8b 00                	mov    (%eax),%eax
c0104934:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104939:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010493c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010493f:	c1 e8 0c             	shr    $0xc,%eax
c0104942:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104945:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c010494a:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c010494d:	72 23                	jb     c0104972 <check_pgdir+0x20a>
c010494f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104952:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104956:	c7 44 24 08 ec 69 10 	movl   $0xc01069ec,0x8(%esp)
c010495d:	c0 
c010495e:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
c0104965:	00 
c0104966:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c010496d:	e8 5b c3 ff ff       	call   c0100ccd <__panic>
c0104972:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104975:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010497a:	83 c0 04             	add    $0x4,%eax
c010497d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0104980:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104985:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010498c:	00 
c010498d:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104994:	00 
c0104995:	89 04 24             	mov    %eax,(%esp)
c0104998:	e8 60 fa ff ff       	call   c01043fd <get_pte>
c010499d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01049a0:	74 24                	je     c01049c6 <check_pgdir+0x25e>
c01049a2:	c7 44 24 0c 30 6c 10 	movl   $0xc0106c30,0xc(%esp)
c01049a9:	c0 
c01049aa:	c7 44 24 08 d9 6a 10 	movl   $0xc0106ad9,0x8(%esp)
c01049b1:	c0 
c01049b2:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
c01049b9:	00 
c01049ba:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c01049c1:	e8 07 c3 ff ff       	call   c0100ccd <__panic>

    p2 = alloc_page();
c01049c6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01049cd:	e8 ec f2 ff ff       	call   c0103cbe <alloc_pages>
c01049d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c01049d5:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01049da:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c01049e1:	00 
c01049e2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01049e9:	00 
c01049ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01049ed:	89 54 24 04          	mov    %edx,0x4(%esp)
c01049f1:	89 04 24             	mov    %eax,(%esp)
c01049f4:	e8 3b fc ff ff       	call   c0104634 <page_insert>
c01049f9:	85 c0                	test   %eax,%eax
c01049fb:	74 24                	je     c0104a21 <check_pgdir+0x2b9>
c01049fd:	c7 44 24 0c 58 6c 10 	movl   $0xc0106c58,0xc(%esp)
c0104a04:	c0 
c0104a05:	c7 44 24 08 d9 6a 10 	movl   $0xc0106ad9,0x8(%esp)
c0104a0c:	c0 
c0104a0d:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
c0104a14:	00 
c0104a15:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c0104a1c:	e8 ac c2 ff ff       	call   c0100ccd <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104a21:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104a26:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104a2d:	00 
c0104a2e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104a35:	00 
c0104a36:	89 04 24             	mov    %eax,(%esp)
c0104a39:	e8 bf f9 ff ff       	call   c01043fd <get_pte>
c0104a3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104a41:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104a45:	75 24                	jne    c0104a6b <check_pgdir+0x303>
c0104a47:	c7 44 24 0c 90 6c 10 	movl   $0xc0106c90,0xc(%esp)
c0104a4e:	c0 
c0104a4f:	c7 44 24 08 d9 6a 10 	movl   $0xc0106ad9,0x8(%esp)
c0104a56:	c0 
c0104a57:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
c0104a5e:	00 
c0104a5f:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c0104a66:	e8 62 c2 ff ff       	call   c0100ccd <__panic>
    assert(*ptep & PTE_U);
c0104a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a6e:	8b 00                	mov    (%eax),%eax
c0104a70:	83 e0 04             	and    $0x4,%eax
c0104a73:	85 c0                	test   %eax,%eax
c0104a75:	75 24                	jne    c0104a9b <check_pgdir+0x333>
c0104a77:	c7 44 24 0c c0 6c 10 	movl   $0xc0106cc0,0xc(%esp)
c0104a7e:	c0 
c0104a7f:	c7 44 24 08 d9 6a 10 	movl   $0xc0106ad9,0x8(%esp)
c0104a86:	c0 
c0104a87:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
c0104a8e:	00 
c0104a8f:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c0104a96:	e8 32 c2 ff ff       	call   c0100ccd <__panic>
    assert(*ptep & PTE_W);
c0104a9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a9e:	8b 00                	mov    (%eax),%eax
c0104aa0:	83 e0 02             	and    $0x2,%eax
c0104aa3:	85 c0                	test   %eax,%eax
c0104aa5:	75 24                	jne    c0104acb <check_pgdir+0x363>
c0104aa7:	c7 44 24 0c ce 6c 10 	movl   $0xc0106cce,0xc(%esp)
c0104aae:	c0 
c0104aaf:	c7 44 24 08 d9 6a 10 	movl   $0xc0106ad9,0x8(%esp)
c0104ab6:	c0 
c0104ab7:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
c0104abe:	00 
c0104abf:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c0104ac6:	e8 02 c2 ff ff       	call   c0100ccd <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0104acb:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104ad0:	8b 00                	mov    (%eax),%eax
c0104ad2:	83 e0 04             	and    $0x4,%eax
c0104ad5:	85 c0                	test   %eax,%eax
c0104ad7:	75 24                	jne    c0104afd <check_pgdir+0x395>
c0104ad9:	c7 44 24 0c dc 6c 10 	movl   $0xc0106cdc,0xc(%esp)
c0104ae0:	c0 
c0104ae1:	c7 44 24 08 d9 6a 10 	movl   $0xc0106ad9,0x8(%esp)
c0104ae8:	c0 
c0104ae9:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
c0104af0:	00 
c0104af1:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c0104af8:	e8 d0 c1 ff ff       	call   c0100ccd <__panic>
    assert(page_ref(p2) == 1);
c0104afd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b00:	89 04 24             	mov    %eax,(%esp)
c0104b03:	e8 b1 ef ff ff       	call   c0103ab9 <page_ref>
c0104b08:	83 f8 01             	cmp    $0x1,%eax
c0104b0b:	74 24                	je     c0104b31 <check_pgdir+0x3c9>
c0104b0d:	c7 44 24 0c f2 6c 10 	movl   $0xc0106cf2,0xc(%esp)
c0104b14:	c0 
c0104b15:	c7 44 24 08 d9 6a 10 	movl   $0xc0106ad9,0x8(%esp)
c0104b1c:	c0 
c0104b1d:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
c0104b24:	00 
c0104b25:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c0104b2c:	e8 9c c1 ff ff       	call   c0100ccd <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0104b31:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104b36:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104b3d:	00 
c0104b3e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104b45:	00 
c0104b46:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104b49:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104b4d:	89 04 24             	mov    %eax,(%esp)
c0104b50:	e8 df fa ff ff       	call   c0104634 <page_insert>
c0104b55:	85 c0                	test   %eax,%eax
c0104b57:	74 24                	je     c0104b7d <check_pgdir+0x415>
c0104b59:	c7 44 24 0c 04 6d 10 	movl   $0xc0106d04,0xc(%esp)
c0104b60:	c0 
c0104b61:	c7 44 24 08 d9 6a 10 	movl   $0xc0106ad9,0x8(%esp)
c0104b68:	c0 
c0104b69:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
c0104b70:	00 
c0104b71:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c0104b78:	e8 50 c1 ff ff       	call   c0100ccd <__panic>
    assert(page_ref(p1) == 2);
c0104b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b80:	89 04 24             	mov    %eax,(%esp)
c0104b83:	e8 31 ef ff ff       	call   c0103ab9 <page_ref>
c0104b88:	83 f8 02             	cmp    $0x2,%eax
c0104b8b:	74 24                	je     c0104bb1 <check_pgdir+0x449>
c0104b8d:	c7 44 24 0c 30 6d 10 	movl   $0xc0106d30,0xc(%esp)
c0104b94:	c0 
c0104b95:	c7 44 24 08 d9 6a 10 	movl   $0xc0106ad9,0x8(%esp)
c0104b9c:	c0 
c0104b9d:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c0104ba4:	00 
c0104ba5:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c0104bac:	e8 1c c1 ff ff       	call   c0100ccd <__panic>
    assert(page_ref(p2) == 0);
c0104bb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104bb4:	89 04 24             	mov    %eax,(%esp)
c0104bb7:	e8 fd ee ff ff       	call   c0103ab9 <page_ref>
c0104bbc:	85 c0                	test   %eax,%eax
c0104bbe:	74 24                	je     c0104be4 <check_pgdir+0x47c>
c0104bc0:	c7 44 24 0c 42 6d 10 	movl   $0xc0106d42,0xc(%esp)
c0104bc7:	c0 
c0104bc8:	c7 44 24 08 d9 6a 10 	movl   $0xc0106ad9,0x8(%esp)
c0104bcf:	c0 
c0104bd0:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
c0104bd7:	00 
c0104bd8:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c0104bdf:	e8 e9 c0 ff ff       	call   c0100ccd <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104be4:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104be9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104bf0:	00 
c0104bf1:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104bf8:	00 
c0104bf9:	89 04 24             	mov    %eax,(%esp)
c0104bfc:	e8 fc f7 ff ff       	call   c01043fd <get_pte>
c0104c01:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104c04:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104c08:	75 24                	jne    c0104c2e <check_pgdir+0x4c6>
c0104c0a:	c7 44 24 0c 90 6c 10 	movl   $0xc0106c90,0xc(%esp)
c0104c11:	c0 
c0104c12:	c7 44 24 08 d9 6a 10 	movl   $0xc0106ad9,0x8(%esp)
c0104c19:	c0 
c0104c1a:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
c0104c21:	00 
c0104c22:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c0104c29:	e8 9f c0 ff ff       	call   c0100ccd <__panic>
    assert(pa2page(*ptep) == p1);
c0104c2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c31:	8b 00                	mov    (%eax),%eax
c0104c33:	89 04 24             	mov    %eax,(%esp)
c0104c36:	e8 9d ed ff ff       	call   c01039d8 <pa2page>
c0104c3b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104c3e:	74 24                	je     c0104c64 <check_pgdir+0x4fc>
c0104c40:	c7 44 24 0c 09 6c 10 	movl   $0xc0106c09,0xc(%esp)
c0104c47:	c0 
c0104c48:	c7 44 24 08 d9 6a 10 	movl   $0xc0106ad9,0x8(%esp)
c0104c4f:	c0 
c0104c50:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
c0104c57:	00 
c0104c58:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c0104c5f:	e8 69 c0 ff ff       	call   c0100ccd <__panic>
    assert((*ptep & PTE_U) == 0);
c0104c64:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c67:	8b 00                	mov    (%eax),%eax
c0104c69:	83 e0 04             	and    $0x4,%eax
c0104c6c:	85 c0                	test   %eax,%eax
c0104c6e:	74 24                	je     c0104c94 <check_pgdir+0x52c>
c0104c70:	c7 44 24 0c 54 6d 10 	movl   $0xc0106d54,0xc(%esp)
c0104c77:	c0 
c0104c78:	c7 44 24 08 d9 6a 10 	movl   $0xc0106ad9,0x8(%esp)
c0104c7f:	c0 
c0104c80:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c0104c87:	00 
c0104c88:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c0104c8f:	e8 39 c0 ff ff       	call   c0100ccd <__panic>

    page_remove(boot_pgdir, 0x0);
c0104c94:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104c99:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104ca0:	00 
c0104ca1:	89 04 24             	mov    %eax,(%esp)
c0104ca4:	e8 47 f9 ff ff       	call   c01045f0 <page_remove>
    assert(page_ref(p1) == 1);
c0104ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104cac:	89 04 24             	mov    %eax,(%esp)
c0104caf:	e8 05 ee ff ff       	call   c0103ab9 <page_ref>
c0104cb4:	83 f8 01             	cmp    $0x1,%eax
c0104cb7:	74 24                	je     c0104cdd <check_pgdir+0x575>
c0104cb9:	c7 44 24 0c 1e 6c 10 	movl   $0xc0106c1e,0xc(%esp)
c0104cc0:	c0 
c0104cc1:	c7 44 24 08 d9 6a 10 	movl   $0xc0106ad9,0x8(%esp)
c0104cc8:	c0 
c0104cc9:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
c0104cd0:	00 
c0104cd1:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c0104cd8:	e8 f0 bf ff ff       	call   c0100ccd <__panic>
    assert(page_ref(p2) == 0);
c0104cdd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104ce0:	89 04 24             	mov    %eax,(%esp)
c0104ce3:	e8 d1 ed ff ff       	call   c0103ab9 <page_ref>
c0104ce8:	85 c0                	test   %eax,%eax
c0104cea:	74 24                	je     c0104d10 <check_pgdir+0x5a8>
c0104cec:	c7 44 24 0c 42 6d 10 	movl   $0xc0106d42,0xc(%esp)
c0104cf3:	c0 
c0104cf4:	c7 44 24 08 d9 6a 10 	movl   $0xc0106ad9,0x8(%esp)
c0104cfb:	c0 
c0104cfc:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
c0104d03:	00 
c0104d04:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c0104d0b:	e8 bd bf ff ff       	call   c0100ccd <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0104d10:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104d15:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104d1c:	00 
c0104d1d:	89 04 24             	mov    %eax,(%esp)
c0104d20:	e8 cb f8 ff ff       	call   c01045f0 <page_remove>
    assert(page_ref(p1) == 0);
c0104d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d28:	89 04 24             	mov    %eax,(%esp)
c0104d2b:	e8 89 ed ff ff       	call   c0103ab9 <page_ref>
c0104d30:	85 c0                	test   %eax,%eax
c0104d32:	74 24                	je     c0104d58 <check_pgdir+0x5f0>
c0104d34:	c7 44 24 0c 69 6d 10 	movl   $0xc0106d69,0xc(%esp)
c0104d3b:	c0 
c0104d3c:	c7 44 24 08 d9 6a 10 	movl   $0xc0106ad9,0x8(%esp)
c0104d43:	c0 
c0104d44:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
c0104d4b:	00 
c0104d4c:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c0104d53:	e8 75 bf ff ff       	call   c0100ccd <__panic>
    assert(page_ref(p2) == 0);
c0104d58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d5b:	89 04 24             	mov    %eax,(%esp)
c0104d5e:	e8 56 ed ff ff       	call   c0103ab9 <page_ref>
c0104d63:	85 c0                	test   %eax,%eax
c0104d65:	74 24                	je     c0104d8b <check_pgdir+0x623>
c0104d67:	c7 44 24 0c 42 6d 10 	movl   $0xc0106d42,0xc(%esp)
c0104d6e:	c0 
c0104d6f:	c7 44 24 08 d9 6a 10 	movl   $0xc0106ad9,0x8(%esp)
c0104d76:	c0 
c0104d77:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c0104d7e:	00 
c0104d7f:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c0104d86:	e8 42 bf ff ff       	call   c0100ccd <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
c0104d8b:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104d90:	8b 00                	mov    (%eax),%eax
c0104d92:	89 04 24             	mov    %eax,(%esp)
c0104d95:	e8 3e ec ff ff       	call   c01039d8 <pa2page>
c0104d9a:	89 04 24             	mov    %eax,(%esp)
c0104d9d:	e8 17 ed ff ff       	call   c0103ab9 <page_ref>
c0104da2:	83 f8 01             	cmp    $0x1,%eax
c0104da5:	74 24                	je     c0104dcb <check_pgdir+0x663>
c0104da7:	c7 44 24 0c 7c 6d 10 	movl   $0xc0106d7c,0xc(%esp)
c0104dae:	c0 
c0104daf:	c7 44 24 08 d9 6a 10 	movl   $0xc0106ad9,0x8(%esp)
c0104db6:	c0 
c0104db7:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
c0104dbe:	00 
c0104dbf:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c0104dc6:	e8 02 bf ff ff       	call   c0100ccd <__panic>
    free_page(pa2page(boot_pgdir[0]));
c0104dcb:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104dd0:	8b 00                	mov    (%eax),%eax
c0104dd2:	89 04 24             	mov    %eax,(%esp)
c0104dd5:	e8 fe eb ff ff       	call   c01039d8 <pa2page>
c0104dda:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104de1:	00 
c0104de2:	89 04 24             	mov    %eax,(%esp)
c0104de5:	e8 0c ef ff ff       	call   c0103cf6 <free_pages>
    boot_pgdir[0] = 0;
c0104dea:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104def:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0104df5:	c7 04 24 a2 6d 10 c0 	movl   $0xc0106da2,(%esp)
c0104dfc:	e8 3b b5 ff ff       	call   c010033c <cprintf>
}
c0104e01:	c9                   	leave  
c0104e02:	c3                   	ret    

c0104e03 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0104e03:	55                   	push   %ebp
c0104e04:	89 e5                	mov    %esp,%ebp
c0104e06:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104e09:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104e10:	e9 ca 00 00 00       	jmp    c0104edf <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0104e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e18:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104e1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e1e:	c1 e8 0c             	shr    $0xc,%eax
c0104e21:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104e24:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104e29:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0104e2c:	72 23                	jb     c0104e51 <check_boot_pgdir+0x4e>
c0104e2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e31:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104e35:	c7 44 24 08 ec 69 10 	movl   $0xc01069ec,0x8(%esp)
c0104e3c:	c0 
c0104e3d:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
c0104e44:	00 
c0104e45:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c0104e4c:	e8 7c be ff ff       	call   c0100ccd <__panic>
c0104e51:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e54:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104e59:	89 c2                	mov    %eax,%edx
c0104e5b:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104e60:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104e67:	00 
c0104e68:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104e6c:	89 04 24             	mov    %eax,(%esp)
c0104e6f:	e8 89 f5 ff ff       	call   c01043fd <get_pte>
c0104e74:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104e77:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104e7b:	75 24                	jne    c0104ea1 <check_boot_pgdir+0x9e>
c0104e7d:	c7 44 24 0c bc 6d 10 	movl   $0xc0106dbc,0xc(%esp)
c0104e84:	c0 
c0104e85:	c7 44 24 08 d9 6a 10 	movl   $0xc0106ad9,0x8(%esp)
c0104e8c:	c0 
c0104e8d:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
c0104e94:	00 
c0104e95:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c0104e9c:	e8 2c be ff ff       	call   c0100ccd <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0104ea1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104ea4:	8b 00                	mov    (%eax),%eax
c0104ea6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104eab:	89 c2                	mov    %eax,%edx
c0104ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104eb0:	39 c2                	cmp    %eax,%edx
c0104eb2:	74 24                	je     c0104ed8 <check_boot_pgdir+0xd5>
c0104eb4:	c7 44 24 0c f9 6d 10 	movl   $0xc0106df9,0xc(%esp)
c0104ebb:	c0 
c0104ebc:	c7 44 24 08 d9 6a 10 	movl   $0xc0106ad9,0x8(%esp)
c0104ec3:	c0 
c0104ec4:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
c0104ecb:	00 
c0104ecc:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c0104ed3:	e8 f5 bd ff ff       	call   c0100ccd <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104ed8:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0104edf:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104ee2:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104ee7:	39 c2                	cmp    %eax,%edx
c0104ee9:	0f 82 26 ff ff ff    	jb     c0104e15 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0104eef:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104ef4:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104ef9:	8b 00                	mov    (%eax),%eax
c0104efb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104f00:	89 c2                	mov    %eax,%edx
c0104f02:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104f07:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104f0a:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0104f11:	77 23                	ja     c0104f36 <check_boot_pgdir+0x133>
c0104f13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f16:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104f1a:	c7 44 24 08 90 6a 10 	movl   $0xc0106a90,0x8(%esp)
c0104f21:	c0 
c0104f22:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
c0104f29:	00 
c0104f2a:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c0104f31:	e8 97 bd ff ff       	call   c0100ccd <__panic>
c0104f36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f39:	05 00 00 00 40       	add    $0x40000000,%eax
c0104f3e:	39 c2                	cmp    %eax,%edx
c0104f40:	74 24                	je     c0104f66 <check_boot_pgdir+0x163>
c0104f42:	c7 44 24 0c 10 6e 10 	movl   $0xc0106e10,0xc(%esp)
c0104f49:	c0 
c0104f4a:	c7 44 24 08 d9 6a 10 	movl   $0xc0106ad9,0x8(%esp)
c0104f51:	c0 
c0104f52:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
c0104f59:	00 
c0104f5a:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c0104f61:	e8 67 bd ff ff       	call   c0100ccd <__panic>

    assert(boot_pgdir[0] == 0);
c0104f66:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104f6b:	8b 00                	mov    (%eax),%eax
c0104f6d:	85 c0                	test   %eax,%eax
c0104f6f:	74 24                	je     c0104f95 <check_boot_pgdir+0x192>
c0104f71:	c7 44 24 0c 44 6e 10 	movl   $0xc0106e44,0xc(%esp)
c0104f78:	c0 
c0104f79:	c7 44 24 08 d9 6a 10 	movl   $0xc0106ad9,0x8(%esp)
c0104f80:	c0 
c0104f81:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
c0104f88:	00 
c0104f89:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c0104f90:	e8 38 bd ff ff       	call   c0100ccd <__panic>

    struct Page *p;
    p = alloc_page();
c0104f95:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104f9c:	e8 1d ed ff ff       	call   c0103cbe <alloc_pages>
c0104fa1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0104fa4:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104fa9:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0104fb0:	00 
c0104fb1:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0104fb8:	00 
c0104fb9:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104fbc:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104fc0:	89 04 24             	mov    %eax,(%esp)
c0104fc3:	e8 6c f6 ff ff       	call   c0104634 <page_insert>
c0104fc8:	85 c0                	test   %eax,%eax
c0104fca:	74 24                	je     c0104ff0 <check_boot_pgdir+0x1ed>
c0104fcc:	c7 44 24 0c 58 6e 10 	movl   $0xc0106e58,0xc(%esp)
c0104fd3:	c0 
c0104fd4:	c7 44 24 08 d9 6a 10 	movl   $0xc0106ad9,0x8(%esp)
c0104fdb:	c0 
c0104fdc:	c7 44 24 04 27 02 00 	movl   $0x227,0x4(%esp)
c0104fe3:	00 
c0104fe4:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c0104feb:	e8 dd bc ff ff       	call   c0100ccd <__panic>
    assert(page_ref(p) == 1);
c0104ff0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104ff3:	89 04 24             	mov    %eax,(%esp)
c0104ff6:	e8 be ea ff ff       	call   c0103ab9 <page_ref>
c0104ffb:	83 f8 01             	cmp    $0x1,%eax
c0104ffe:	74 24                	je     c0105024 <check_boot_pgdir+0x221>
c0105000:	c7 44 24 0c 86 6e 10 	movl   $0xc0106e86,0xc(%esp)
c0105007:	c0 
c0105008:	c7 44 24 08 d9 6a 10 	movl   $0xc0106ad9,0x8(%esp)
c010500f:	c0 
c0105010:	c7 44 24 04 28 02 00 	movl   $0x228,0x4(%esp)
c0105017:	00 
c0105018:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c010501f:	e8 a9 bc ff ff       	call   c0100ccd <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0105024:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0105029:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105030:	00 
c0105031:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0105038:	00 
c0105039:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010503c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105040:	89 04 24             	mov    %eax,(%esp)
c0105043:	e8 ec f5 ff ff       	call   c0104634 <page_insert>
c0105048:	85 c0                	test   %eax,%eax
c010504a:	74 24                	je     c0105070 <check_boot_pgdir+0x26d>
c010504c:	c7 44 24 0c 98 6e 10 	movl   $0xc0106e98,0xc(%esp)
c0105053:	c0 
c0105054:	c7 44 24 08 d9 6a 10 	movl   $0xc0106ad9,0x8(%esp)
c010505b:	c0 
c010505c:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
c0105063:	00 
c0105064:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c010506b:	e8 5d bc ff ff       	call   c0100ccd <__panic>
    assert(page_ref(p) == 2);
c0105070:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105073:	89 04 24             	mov    %eax,(%esp)
c0105076:	e8 3e ea ff ff       	call   c0103ab9 <page_ref>
c010507b:	83 f8 02             	cmp    $0x2,%eax
c010507e:	74 24                	je     c01050a4 <check_boot_pgdir+0x2a1>
c0105080:	c7 44 24 0c cf 6e 10 	movl   $0xc0106ecf,0xc(%esp)
c0105087:	c0 
c0105088:	c7 44 24 08 d9 6a 10 	movl   $0xc0106ad9,0x8(%esp)
c010508f:	c0 
c0105090:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
c0105097:	00 
c0105098:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c010509f:	e8 29 bc ff ff       	call   c0100ccd <__panic>

    const char *str = "ucore: Hello world!!";
c01050a4:	c7 45 dc e0 6e 10 c0 	movl   $0xc0106ee0,-0x24(%ebp)
    strcpy((void *)0x100, str);
c01050ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01050ae:	89 44 24 04          	mov    %eax,0x4(%esp)
c01050b2:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01050b9:	e8 1e 0a 00 00       	call   c0105adc <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c01050be:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c01050c5:	00 
c01050c6:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01050cd:	e8 83 0a 00 00       	call   c0105b55 <strcmp>
c01050d2:	85 c0                	test   %eax,%eax
c01050d4:	74 24                	je     c01050fa <check_boot_pgdir+0x2f7>
c01050d6:	c7 44 24 0c f8 6e 10 	movl   $0xc0106ef8,0xc(%esp)
c01050dd:	c0 
c01050de:	c7 44 24 08 d9 6a 10 	movl   $0xc0106ad9,0x8(%esp)
c01050e5:	c0 
c01050e6:	c7 44 24 04 2e 02 00 	movl   $0x22e,0x4(%esp)
c01050ed:	00 
c01050ee:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c01050f5:	e8 d3 bb ff ff       	call   c0100ccd <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c01050fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01050fd:	89 04 24             	mov    %eax,(%esp)
c0105100:	e8 22 e9 ff ff       	call   c0103a27 <page2kva>
c0105105:	05 00 01 00 00       	add    $0x100,%eax
c010510a:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c010510d:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105114:	e8 6b 09 00 00       	call   c0105a84 <strlen>
c0105119:	85 c0                	test   %eax,%eax
c010511b:	74 24                	je     c0105141 <check_boot_pgdir+0x33e>
c010511d:	c7 44 24 0c 30 6f 10 	movl   $0xc0106f30,0xc(%esp)
c0105124:	c0 
c0105125:	c7 44 24 08 d9 6a 10 	movl   $0xc0106ad9,0x8(%esp)
c010512c:	c0 
c010512d:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
c0105134:	00 
c0105135:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c010513c:	e8 8c bb ff ff       	call   c0100ccd <__panic>

    free_page(p);
c0105141:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105148:	00 
c0105149:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010514c:	89 04 24             	mov    %eax,(%esp)
c010514f:	e8 a2 eb ff ff       	call   c0103cf6 <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
c0105154:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0105159:	8b 00                	mov    (%eax),%eax
c010515b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105160:	89 04 24             	mov    %eax,(%esp)
c0105163:	e8 70 e8 ff ff       	call   c01039d8 <pa2page>
c0105168:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010516f:	00 
c0105170:	89 04 24             	mov    %eax,(%esp)
c0105173:	e8 7e eb ff ff       	call   c0103cf6 <free_pages>
    boot_pgdir[0] = 0;
c0105178:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010517d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0105183:	c7 04 24 54 6f 10 c0 	movl   $0xc0106f54,(%esp)
c010518a:	e8 ad b1 ff ff       	call   c010033c <cprintf>
}
c010518f:	c9                   	leave  
c0105190:	c3                   	ret    

c0105191 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0105191:	55                   	push   %ebp
c0105192:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0105194:	8b 45 08             	mov    0x8(%ebp),%eax
c0105197:	83 e0 04             	and    $0x4,%eax
c010519a:	85 c0                	test   %eax,%eax
c010519c:	74 07                	je     c01051a5 <perm2str+0x14>
c010519e:	b8 75 00 00 00       	mov    $0x75,%eax
c01051a3:	eb 05                	jmp    c01051aa <perm2str+0x19>
c01051a5:	b8 2d 00 00 00       	mov    $0x2d,%eax
c01051aa:	a2 48 89 11 c0       	mov    %al,0xc0118948
    str[1] = 'r';
c01051af:	c6 05 49 89 11 c0 72 	movb   $0x72,0xc0118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
c01051b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01051b9:	83 e0 02             	and    $0x2,%eax
c01051bc:	85 c0                	test   %eax,%eax
c01051be:	74 07                	je     c01051c7 <perm2str+0x36>
c01051c0:	b8 77 00 00 00       	mov    $0x77,%eax
c01051c5:	eb 05                	jmp    c01051cc <perm2str+0x3b>
c01051c7:	b8 2d 00 00 00       	mov    $0x2d,%eax
c01051cc:	a2 4a 89 11 c0       	mov    %al,0xc011894a
    str[3] = '\0';
c01051d1:	c6 05 4b 89 11 c0 00 	movb   $0x0,0xc011894b
    return str;
c01051d8:	b8 48 89 11 c0       	mov    $0xc0118948,%eax
}
c01051dd:	5d                   	pop    %ebp
c01051de:	c3                   	ret    

c01051df <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c01051df:	55                   	push   %ebp
c01051e0:	89 e5                	mov    %esp,%ebp
c01051e2:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c01051e5:	8b 45 10             	mov    0x10(%ebp),%eax
c01051e8:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01051eb:	72 0a                	jb     c01051f7 <get_pgtable_items+0x18>
        return 0;
c01051ed:	b8 00 00 00 00       	mov    $0x0,%eax
c01051f2:	e9 9c 00 00 00       	jmp    c0105293 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c01051f7:	eb 04                	jmp    c01051fd <get_pgtable_items+0x1e>
        start ++;
c01051f9:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c01051fd:	8b 45 10             	mov    0x10(%ebp),%eax
c0105200:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105203:	73 18                	jae    c010521d <get_pgtable_items+0x3e>
c0105205:	8b 45 10             	mov    0x10(%ebp),%eax
c0105208:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010520f:	8b 45 14             	mov    0x14(%ebp),%eax
c0105212:	01 d0                	add    %edx,%eax
c0105214:	8b 00                	mov    (%eax),%eax
c0105216:	83 e0 01             	and    $0x1,%eax
c0105219:	85 c0                	test   %eax,%eax
c010521b:	74 dc                	je     c01051f9 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c010521d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105220:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105223:	73 69                	jae    c010528e <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c0105225:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0105229:	74 08                	je     c0105233 <get_pgtable_items+0x54>
            *left_store = start;
c010522b:	8b 45 18             	mov    0x18(%ebp),%eax
c010522e:	8b 55 10             	mov    0x10(%ebp),%edx
c0105231:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0105233:	8b 45 10             	mov    0x10(%ebp),%eax
c0105236:	8d 50 01             	lea    0x1(%eax),%edx
c0105239:	89 55 10             	mov    %edx,0x10(%ebp)
c010523c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105243:	8b 45 14             	mov    0x14(%ebp),%eax
c0105246:	01 d0                	add    %edx,%eax
c0105248:	8b 00                	mov    (%eax),%eax
c010524a:	83 e0 07             	and    $0x7,%eax
c010524d:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105250:	eb 04                	jmp    c0105256 <get_pgtable_items+0x77>
            start ++;
c0105252:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105256:	8b 45 10             	mov    0x10(%ebp),%eax
c0105259:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010525c:	73 1d                	jae    c010527b <get_pgtable_items+0x9c>
c010525e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105261:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105268:	8b 45 14             	mov    0x14(%ebp),%eax
c010526b:	01 d0                	add    %edx,%eax
c010526d:	8b 00                	mov    (%eax),%eax
c010526f:	83 e0 07             	and    $0x7,%eax
c0105272:	89 c2                	mov    %eax,%edx
c0105274:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105277:	39 c2                	cmp    %eax,%edx
c0105279:	74 d7                	je     c0105252 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c010527b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010527f:	74 08                	je     c0105289 <get_pgtable_items+0xaa>
            *right_store = start;
c0105281:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105284:	8b 55 10             	mov    0x10(%ebp),%edx
c0105287:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0105289:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010528c:	eb 05                	jmp    c0105293 <get_pgtable_items+0xb4>
    }
    return 0;
c010528e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105293:	c9                   	leave  
c0105294:	c3                   	ret    

c0105295 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0105295:	55                   	push   %ebp
c0105296:	89 e5                	mov    %esp,%ebp
c0105298:	57                   	push   %edi
c0105299:	56                   	push   %esi
c010529a:	53                   	push   %ebx
c010529b:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c010529e:	c7 04 24 74 6f 10 c0 	movl   $0xc0106f74,(%esp)
c01052a5:	e8 92 b0 ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
c01052aa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01052b1:	e9 fa 00 00 00       	jmp    c01053b0 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01052b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01052b9:	89 04 24             	mov    %eax,(%esp)
c01052bc:	e8 d0 fe ff ff       	call   c0105191 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c01052c1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01052c4:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01052c7:	29 d1                	sub    %edx,%ecx
c01052c9:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01052cb:	89 d6                	mov    %edx,%esi
c01052cd:	c1 e6 16             	shl    $0x16,%esi
c01052d0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01052d3:	89 d3                	mov    %edx,%ebx
c01052d5:	c1 e3 16             	shl    $0x16,%ebx
c01052d8:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01052db:	89 d1                	mov    %edx,%ecx
c01052dd:	c1 e1 16             	shl    $0x16,%ecx
c01052e0:	8b 7d dc             	mov    -0x24(%ebp),%edi
c01052e3:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01052e6:	29 d7                	sub    %edx,%edi
c01052e8:	89 fa                	mov    %edi,%edx
c01052ea:	89 44 24 14          	mov    %eax,0x14(%esp)
c01052ee:	89 74 24 10          	mov    %esi,0x10(%esp)
c01052f2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01052f6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01052fa:	89 54 24 04          	mov    %edx,0x4(%esp)
c01052fe:	c7 04 24 a5 6f 10 c0 	movl   $0xc0106fa5,(%esp)
c0105305:	e8 32 b0 ff ff       	call   c010033c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c010530a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010530d:	c1 e0 0a             	shl    $0xa,%eax
c0105310:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105313:	eb 54                	jmp    c0105369 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105315:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105318:	89 04 24             	mov    %eax,(%esp)
c010531b:	e8 71 fe ff ff       	call   c0105191 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0105320:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0105323:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105326:	29 d1                	sub    %edx,%ecx
c0105328:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010532a:	89 d6                	mov    %edx,%esi
c010532c:	c1 e6 0c             	shl    $0xc,%esi
c010532f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105332:	89 d3                	mov    %edx,%ebx
c0105334:	c1 e3 0c             	shl    $0xc,%ebx
c0105337:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010533a:	c1 e2 0c             	shl    $0xc,%edx
c010533d:	89 d1                	mov    %edx,%ecx
c010533f:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0105342:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105345:	29 d7                	sub    %edx,%edi
c0105347:	89 fa                	mov    %edi,%edx
c0105349:	89 44 24 14          	mov    %eax,0x14(%esp)
c010534d:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105351:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105355:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105359:	89 54 24 04          	mov    %edx,0x4(%esp)
c010535d:	c7 04 24 c4 6f 10 c0 	movl   $0xc0106fc4,(%esp)
c0105364:	e8 d3 af ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105369:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c010536e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105371:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105374:	89 ce                	mov    %ecx,%esi
c0105376:	c1 e6 0a             	shl    $0xa,%esi
c0105379:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c010537c:	89 cb                	mov    %ecx,%ebx
c010537e:	c1 e3 0a             	shl    $0xa,%ebx
c0105381:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c0105384:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105388:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c010538b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c010538f:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105393:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105397:	89 74 24 04          	mov    %esi,0x4(%esp)
c010539b:	89 1c 24             	mov    %ebx,(%esp)
c010539e:	e8 3c fe ff ff       	call   c01051df <get_pgtable_items>
c01053a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01053a6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01053aa:	0f 85 65 ff ff ff    	jne    c0105315 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01053b0:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c01053b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01053b8:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c01053bb:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c01053bf:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c01053c2:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01053c6:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01053ca:	89 44 24 08          	mov    %eax,0x8(%esp)
c01053ce:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c01053d5:	00 
c01053d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01053dd:	e8 fd fd ff ff       	call   c01051df <get_pgtable_items>
c01053e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01053e5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01053e9:	0f 85 c7 fe ff ff    	jne    c01052b6 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c01053ef:	c7 04 24 e8 6f 10 c0 	movl   $0xc0106fe8,(%esp)
c01053f6:	e8 41 af ff ff       	call   c010033c <cprintf>
}
c01053fb:	83 c4 4c             	add    $0x4c,%esp
c01053fe:	5b                   	pop    %ebx
c01053ff:	5e                   	pop    %esi
c0105400:	5f                   	pop    %edi
c0105401:	5d                   	pop    %ebp
c0105402:	c3                   	ret    

c0105403 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0105403:	55                   	push   %ebp
c0105404:	89 e5                	mov    %esp,%ebp
c0105406:	83 ec 58             	sub    $0x58,%esp
c0105409:	8b 45 10             	mov    0x10(%ebp),%eax
c010540c:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010540f:	8b 45 14             	mov    0x14(%ebp),%eax
c0105412:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0105415:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105418:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010541b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010541e:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0105421:	8b 45 18             	mov    0x18(%ebp),%eax
c0105424:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105427:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010542a:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010542d:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105430:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0105433:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105436:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105439:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010543d:	74 1c                	je     c010545b <printnum+0x58>
c010543f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105442:	ba 00 00 00 00       	mov    $0x0,%edx
c0105447:	f7 75 e4             	divl   -0x1c(%ebp)
c010544a:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010544d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105450:	ba 00 00 00 00       	mov    $0x0,%edx
c0105455:	f7 75 e4             	divl   -0x1c(%ebp)
c0105458:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010545b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010545e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105461:	f7 75 e4             	divl   -0x1c(%ebp)
c0105464:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105467:	89 55 dc             	mov    %edx,-0x24(%ebp)
c010546a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010546d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105470:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105473:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0105476:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105479:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c010547c:	8b 45 18             	mov    0x18(%ebp),%eax
c010547f:	ba 00 00 00 00       	mov    $0x0,%edx
c0105484:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0105487:	77 56                	ja     c01054df <printnum+0xdc>
c0105489:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010548c:	72 05                	jb     c0105493 <printnum+0x90>
c010548e:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0105491:	77 4c                	ja     c01054df <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c0105493:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105496:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105499:	8b 45 20             	mov    0x20(%ebp),%eax
c010549c:	89 44 24 18          	mov    %eax,0x18(%esp)
c01054a0:	89 54 24 14          	mov    %edx,0x14(%esp)
c01054a4:	8b 45 18             	mov    0x18(%ebp),%eax
c01054a7:	89 44 24 10          	mov    %eax,0x10(%esp)
c01054ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01054ae:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01054b1:	89 44 24 08          	mov    %eax,0x8(%esp)
c01054b5:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01054b9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054bc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01054c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01054c3:	89 04 24             	mov    %eax,(%esp)
c01054c6:	e8 38 ff ff ff       	call   c0105403 <printnum>
c01054cb:	eb 1c                	jmp    c01054e9 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c01054cd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054d0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01054d4:	8b 45 20             	mov    0x20(%ebp),%eax
c01054d7:	89 04 24             	mov    %eax,(%esp)
c01054da:	8b 45 08             	mov    0x8(%ebp),%eax
c01054dd:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c01054df:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c01054e3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01054e7:	7f e4                	jg     c01054cd <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c01054e9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01054ec:	05 9c 70 10 c0       	add    $0xc010709c,%eax
c01054f1:	0f b6 00             	movzbl (%eax),%eax
c01054f4:	0f be c0             	movsbl %al,%eax
c01054f7:	8b 55 0c             	mov    0xc(%ebp),%edx
c01054fa:	89 54 24 04          	mov    %edx,0x4(%esp)
c01054fe:	89 04 24             	mov    %eax,(%esp)
c0105501:	8b 45 08             	mov    0x8(%ebp),%eax
c0105504:	ff d0                	call   *%eax
}
c0105506:	c9                   	leave  
c0105507:	c3                   	ret    

c0105508 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0105508:	55                   	push   %ebp
c0105509:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010550b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010550f:	7e 14                	jle    c0105525 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0105511:	8b 45 08             	mov    0x8(%ebp),%eax
c0105514:	8b 00                	mov    (%eax),%eax
c0105516:	8d 48 08             	lea    0x8(%eax),%ecx
c0105519:	8b 55 08             	mov    0x8(%ebp),%edx
c010551c:	89 0a                	mov    %ecx,(%edx)
c010551e:	8b 50 04             	mov    0x4(%eax),%edx
c0105521:	8b 00                	mov    (%eax),%eax
c0105523:	eb 30                	jmp    c0105555 <getuint+0x4d>
    }
    else if (lflag) {
c0105525:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105529:	74 16                	je     c0105541 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c010552b:	8b 45 08             	mov    0x8(%ebp),%eax
c010552e:	8b 00                	mov    (%eax),%eax
c0105530:	8d 48 04             	lea    0x4(%eax),%ecx
c0105533:	8b 55 08             	mov    0x8(%ebp),%edx
c0105536:	89 0a                	mov    %ecx,(%edx)
c0105538:	8b 00                	mov    (%eax),%eax
c010553a:	ba 00 00 00 00       	mov    $0x0,%edx
c010553f:	eb 14                	jmp    c0105555 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0105541:	8b 45 08             	mov    0x8(%ebp),%eax
c0105544:	8b 00                	mov    (%eax),%eax
c0105546:	8d 48 04             	lea    0x4(%eax),%ecx
c0105549:	8b 55 08             	mov    0x8(%ebp),%edx
c010554c:	89 0a                	mov    %ecx,(%edx)
c010554e:	8b 00                	mov    (%eax),%eax
c0105550:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0105555:	5d                   	pop    %ebp
c0105556:	c3                   	ret    

c0105557 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0105557:	55                   	push   %ebp
c0105558:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010555a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010555e:	7e 14                	jle    c0105574 <getint+0x1d>
        return va_arg(*ap, long long);
c0105560:	8b 45 08             	mov    0x8(%ebp),%eax
c0105563:	8b 00                	mov    (%eax),%eax
c0105565:	8d 48 08             	lea    0x8(%eax),%ecx
c0105568:	8b 55 08             	mov    0x8(%ebp),%edx
c010556b:	89 0a                	mov    %ecx,(%edx)
c010556d:	8b 50 04             	mov    0x4(%eax),%edx
c0105570:	8b 00                	mov    (%eax),%eax
c0105572:	eb 28                	jmp    c010559c <getint+0x45>
    }
    else if (lflag) {
c0105574:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105578:	74 12                	je     c010558c <getint+0x35>
        return va_arg(*ap, long);
c010557a:	8b 45 08             	mov    0x8(%ebp),%eax
c010557d:	8b 00                	mov    (%eax),%eax
c010557f:	8d 48 04             	lea    0x4(%eax),%ecx
c0105582:	8b 55 08             	mov    0x8(%ebp),%edx
c0105585:	89 0a                	mov    %ecx,(%edx)
c0105587:	8b 00                	mov    (%eax),%eax
c0105589:	99                   	cltd   
c010558a:	eb 10                	jmp    c010559c <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c010558c:	8b 45 08             	mov    0x8(%ebp),%eax
c010558f:	8b 00                	mov    (%eax),%eax
c0105591:	8d 48 04             	lea    0x4(%eax),%ecx
c0105594:	8b 55 08             	mov    0x8(%ebp),%edx
c0105597:	89 0a                	mov    %ecx,(%edx)
c0105599:	8b 00                	mov    (%eax),%eax
c010559b:	99                   	cltd   
    }
}
c010559c:	5d                   	pop    %ebp
c010559d:	c3                   	ret    

c010559e <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c010559e:	55                   	push   %ebp
c010559f:	89 e5                	mov    %esp,%ebp
c01055a1:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c01055a4:	8d 45 14             	lea    0x14(%ebp),%eax
c01055a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c01055aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01055ad:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01055b1:	8b 45 10             	mov    0x10(%ebp),%eax
c01055b4:	89 44 24 08          	mov    %eax,0x8(%esp)
c01055b8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055bb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01055bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01055c2:	89 04 24             	mov    %eax,(%esp)
c01055c5:	e8 02 00 00 00       	call   c01055cc <vprintfmt>
    va_end(ap);
}
c01055ca:	c9                   	leave  
c01055cb:	c3                   	ret    

c01055cc <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c01055cc:	55                   	push   %ebp
c01055cd:	89 e5                	mov    %esp,%ebp
c01055cf:	56                   	push   %esi
c01055d0:	53                   	push   %ebx
c01055d1:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01055d4:	eb 18                	jmp    c01055ee <vprintfmt+0x22>
            if (ch == '\0') {
c01055d6:	85 db                	test   %ebx,%ebx
c01055d8:	75 05                	jne    c01055df <vprintfmt+0x13>
                return;
c01055da:	e9 d1 03 00 00       	jmp    c01059b0 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c01055df:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055e2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01055e6:	89 1c 24             	mov    %ebx,(%esp)
c01055e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01055ec:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01055ee:	8b 45 10             	mov    0x10(%ebp),%eax
c01055f1:	8d 50 01             	lea    0x1(%eax),%edx
c01055f4:	89 55 10             	mov    %edx,0x10(%ebp)
c01055f7:	0f b6 00             	movzbl (%eax),%eax
c01055fa:	0f b6 d8             	movzbl %al,%ebx
c01055fd:	83 fb 25             	cmp    $0x25,%ebx
c0105600:	75 d4                	jne    c01055d6 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c0105602:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0105606:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c010560d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105610:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0105613:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010561a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010561d:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0105620:	8b 45 10             	mov    0x10(%ebp),%eax
c0105623:	8d 50 01             	lea    0x1(%eax),%edx
c0105626:	89 55 10             	mov    %edx,0x10(%ebp)
c0105629:	0f b6 00             	movzbl (%eax),%eax
c010562c:	0f b6 d8             	movzbl %al,%ebx
c010562f:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0105632:	83 f8 55             	cmp    $0x55,%eax
c0105635:	0f 87 44 03 00 00    	ja     c010597f <vprintfmt+0x3b3>
c010563b:	8b 04 85 c0 70 10 c0 	mov    -0x3fef8f40(,%eax,4),%eax
c0105642:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0105644:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0105648:	eb d6                	jmp    c0105620 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c010564a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c010564e:	eb d0                	jmp    c0105620 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105650:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0105657:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010565a:	89 d0                	mov    %edx,%eax
c010565c:	c1 e0 02             	shl    $0x2,%eax
c010565f:	01 d0                	add    %edx,%eax
c0105661:	01 c0                	add    %eax,%eax
c0105663:	01 d8                	add    %ebx,%eax
c0105665:	83 e8 30             	sub    $0x30,%eax
c0105668:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c010566b:	8b 45 10             	mov    0x10(%ebp),%eax
c010566e:	0f b6 00             	movzbl (%eax),%eax
c0105671:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0105674:	83 fb 2f             	cmp    $0x2f,%ebx
c0105677:	7e 0b                	jle    c0105684 <vprintfmt+0xb8>
c0105679:	83 fb 39             	cmp    $0x39,%ebx
c010567c:	7f 06                	jg     c0105684 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010567e:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c0105682:	eb d3                	jmp    c0105657 <vprintfmt+0x8b>
            goto process_precision;
c0105684:	eb 33                	jmp    c01056b9 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c0105686:	8b 45 14             	mov    0x14(%ebp),%eax
c0105689:	8d 50 04             	lea    0x4(%eax),%edx
c010568c:	89 55 14             	mov    %edx,0x14(%ebp)
c010568f:	8b 00                	mov    (%eax),%eax
c0105691:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0105694:	eb 23                	jmp    c01056b9 <vprintfmt+0xed>

        case '.':
            if (width < 0)
c0105696:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010569a:	79 0c                	jns    c01056a8 <vprintfmt+0xdc>
                width = 0;
c010569c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c01056a3:	e9 78 ff ff ff       	jmp    c0105620 <vprintfmt+0x54>
c01056a8:	e9 73 ff ff ff       	jmp    c0105620 <vprintfmt+0x54>

        case '#':
            altflag = 1;
c01056ad:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c01056b4:	e9 67 ff ff ff       	jmp    c0105620 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c01056b9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01056bd:	79 12                	jns    c01056d1 <vprintfmt+0x105>
                width = precision, precision = -1;
c01056bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01056c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01056c5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c01056cc:	e9 4f ff ff ff       	jmp    c0105620 <vprintfmt+0x54>
c01056d1:	e9 4a ff ff ff       	jmp    c0105620 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c01056d6:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c01056da:	e9 41 ff ff ff       	jmp    c0105620 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c01056df:	8b 45 14             	mov    0x14(%ebp),%eax
c01056e2:	8d 50 04             	lea    0x4(%eax),%edx
c01056e5:	89 55 14             	mov    %edx,0x14(%ebp)
c01056e8:	8b 00                	mov    (%eax),%eax
c01056ea:	8b 55 0c             	mov    0xc(%ebp),%edx
c01056ed:	89 54 24 04          	mov    %edx,0x4(%esp)
c01056f1:	89 04 24             	mov    %eax,(%esp)
c01056f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01056f7:	ff d0                	call   *%eax
            break;
c01056f9:	e9 ac 02 00 00       	jmp    c01059aa <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c01056fe:	8b 45 14             	mov    0x14(%ebp),%eax
c0105701:	8d 50 04             	lea    0x4(%eax),%edx
c0105704:	89 55 14             	mov    %edx,0x14(%ebp)
c0105707:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0105709:	85 db                	test   %ebx,%ebx
c010570b:	79 02                	jns    c010570f <vprintfmt+0x143>
                err = -err;
c010570d:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c010570f:	83 fb 06             	cmp    $0x6,%ebx
c0105712:	7f 0b                	jg     c010571f <vprintfmt+0x153>
c0105714:	8b 34 9d 80 70 10 c0 	mov    -0x3fef8f80(,%ebx,4),%esi
c010571b:	85 f6                	test   %esi,%esi
c010571d:	75 23                	jne    c0105742 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c010571f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105723:	c7 44 24 08 ad 70 10 	movl   $0xc01070ad,0x8(%esp)
c010572a:	c0 
c010572b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010572e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105732:	8b 45 08             	mov    0x8(%ebp),%eax
c0105735:	89 04 24             	mov    %eax,(%esp)
c0105738:	e8 61 fe ff ff       	call   c010559e <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c010573d:	e9 68 02 00 00       	jmp    c01059aa <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c0105742:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0105746:	c7 44 24 08 b6 70 10 	movl   $0xc01070b6,0x8(%esp)
c010574d:	c0 
c010574e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105751:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105755:	8b 45 08             	mov    0x8(%ebp),%eax
c0105758:	89 04 24             	mov    %eax,(%esp)
c010575b:	e8 3e fe ff ff       	call   c010559e <printfmt>
            }
            break;
c0105760:	e9 45 02 00 00       	jmp    c01059aa <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0105765:	8b 45 14             	mov    0x14(%ebp),%eax
c0105768:	8d 50 04             	lea    0x4(%eax),%edx
c010576b:	89 55 14             	mov    %edx,0x14(%ebp)
c010576e:	8b 30                	mov    (%eax),%esi
c0105770:	85 f6                	test   %esi,%esi
c0105772:	75 05                	jne    c0105779 <vprintfmt+0x1ad>
                p = "(null)";
c0105774:	be b9 70 10 c0       	mov    $0xc01070b9,%esi
            }
            if (width > 0 && padc != '-') {
c0105779:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010577d:	7e 3e                	jle    c01057bd <vprintfmt+0x1f1>
c010577f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0105783:	74 38                	je     c01057bd <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105785:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c0105788:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010578b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010578f:	89 34 24             	mov    %esi,(%esp)
c0105792:	e8 15 03 00 00       	call   c0105aac <strnlen>
c0105797:	29 c3                	sub    %eax,%ebx
c0105799:	89 d8                	mov    %ebx,%eax
c010579b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010579e:	eb 17                	jmp    c01057b7 <vprintfmt+0x1eb>
                    putch(padc, putdat);
c01057a0:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c01057a4:	8b 55 0c             	mov    0xc(%ebp),%edx
c01057a7:	89 54 24 04          	mov    %edx,0x4(%esp)
c01057ab:	89 04 24             	mov    %eax,(%esp)
c01057ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01057b1:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c01057b3:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01057b7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01057bb:	7f e3                	jg     c01057a0 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01057bd:	eb 38                	jmp    c01057f7 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c01057bf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01057c3:	74 1f                	je     c01057e4 <vprintfmt+0x218>
c01057c5:	83 fb 1f             	cmp    $0x1f,%ebx
c01057c8:	7e 05                	jle    c01057cf <vprintfmt+0x203>
c01057ca:	83 fb 7e             	cmp    $0x7e,%ebx
c01057cd:	7e 15                	jle    c01057e4 <vprintfmt+0x218>
                    putch('?', putdat);
c01057cf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057d2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057d6:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c01057dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01057e0:	ff d0                	call   *%eax
c01057e2:	eb 0f                	jmp    c01057f3 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c01057e4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057e7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057eb:	89 1c 24             	mov    %ebx,(%esp)
c01057ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01057f1:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01057f3:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01057f7:	89 f0                	mov    %esi,%eax
c01057f9:	8d 70 01             	lea    0x1(%eax),%esi
c01057fc:	0f b6 00             	movzbl (%eax),%eax
c01057ff:	0f be d8             	movsbl %al,%ebx
c0105802:	85 db                	test   %ebx,%ebx
c0105804:	74 10                	je     c0105816 <vprintfmt+0x24a>
c0105806:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010580a:	78 b3                	js     c01057bf <vprintfmt+0x1f3>
c010580c:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0105810:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105814:	79 a9                	jns    c01057bf <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0105816:	eb 17                	jmp    c010582f <vprintfmt+0x263>
                putch(' ', putdat);
c0105818:	8b 45 0c             	mov    0xc(%ebp),%eax
c010581b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010581f:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0105826:	8b 45 08             	mov    0x8(%ebp),%eax
c0105829:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010582b:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010582f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105833:	7f e3                	jg     c0105818 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c0105835:	e9 70 01 00 00       	jmp    c01059aa <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c010583a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010583d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105841:	8d 45 14             	lea    0x14(%ebp),%eax
c0105844:	89 04 24             	mov    %eax,(%esp)
c0105847:	e8 0b fd ff ff       	call   c0105557 <getint>
c010584c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010584f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0105852:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105855:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105858:	85 d2                	test   %edx,%edx
c010585a:	79 26                	jns    c0105882 <vprintfmt+0x2b6>
                putch('-', putdat);
c010585c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010585f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105863:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c010586a:	8b 45 08             	mov    0x8(%ebp),%eax
c010586d:	ff d0                	call   *%eax
                num = -(long long)num;
c010586f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105872:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105875:	f7 d8                	neg    %eax
c0105877:	83 d2 00             	adc    $0x0,%edx
c010587a:	f7 da                	neg    %edx
c010587c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010587f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0105882:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105889:	e9 a8 00 00 00       	jmp    c0105936 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c010588e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105891:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105895:	8d 45 14             	lea    0x14(%ebp),%eax
c0105898:	89 04 24             	mov    %eax,(%esp)
c010589b:	e8 68 fc ff ff       	call   c0105508 <getuint>
c01058a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058a3:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c01058a6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01058ad:	e9 84 00 00 00       	jmp    c0105936 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c01058b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01058b5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058b9:	8d 45 14             	lea    0x14(%ebp),%eax
c01058bc:	89 04 24             	mov    %eax,(%esp)
c01058bf:	e8 44 fc ff ff       	call   c0105508 <getuint>
c01058c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058c7:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c01058ca:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c01058d1:	eb 63                	jmp    c0105936 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c01058d3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058d6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058da:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c01058e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01058e4:	ff d0                	call   *%eax
            putch('x', putdat);
c01058e6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058e9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058ed:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c01058f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01058f7:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c01058f9:	8b 45 14             	mov    0x14(%ebp),%eax
c01058fc:	8d 50 04             	lea    0x4(%eax),%edx
c01058ff:	89 55 14             	mov    %edx,0x14(%ebp)
c0105902:	8b 00                	mov    (%eax),%eax
c0105904:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105907:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c010590e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0105915:	eb 1f                	jmp    c0105936 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0105917:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010591a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010591e:	8d 45 14             	lea    0x14(%ebp),%eax
c0105921:	89 04 24             	mov    %eax,(%esp)
c0105924:	e8 df fb ff ff       	call   c0105508 <getuint>
c0105929:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010592c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c010592f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105936:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c010593a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010593d:	89 54 24 18          	mov    %edx,0x18(%esp)
c0105941:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105944:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105948:	89 44 24 10          	mov    %eax,0x10(%esp)
c010594c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010594f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105952:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105956:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010595a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010595d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105961:	8b 45 08             	mov    0x8(%ebp),%eax
c0105964:	89 04 24             	mov    %eax,(%esp)
c0105967:	e8 97 fa ff ff       	call   c0105403 <printnum>
            break;
c010596c:	eb 3c                	jmp    c01059aa <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c010596e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105971:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105975:	89 1c 24             	mov    %ebx,(%esp)
c0105978:	8b 45 08             	mov    0x8(%ebp),%eax
c010597b:	ff d0                	call   *%eax
            break;
c010597d:	eb 2b                	jmp    c01059aa <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c010597f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105982:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105986:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c010598d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105990:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0105992:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105996:	eb 04                	jmp    c010599c <vprintfmt+0x3d0>
c0105998:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010599c:	8b 45 10             	mov    0x10(%ebp),%eax
c010599f:	83 e8 01             	sub    $0x1,%eax
c01059a2:	0f b6 00             	movzbl (%eax),%eax
c01059a5:	3c 25                	cmp    $0x25,%al
c01059a7:	75 ef                	jne    c0105998 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c01059a9:	90                   	nop
        }
    }
c01059aa:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01059ab:	e9 3e fc ff ff       	jmp    c01055ee <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c01059b0:	83 c4 40             	add    $0x40,%esp
c01059b3:	5b                   	pop    %ebx
c01059b4:	5e                   	pop    %esi
c01059b5:	5d                   	pop    %ebp
c01059b6:	c3                   	ret    

c01059b7 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c01059b7:	55                   	push   %ebp
c01059b8:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c01059ba:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059bd:	8b 40 08             	mov    0x8(%eax),%eax
c01059c0:	8d 50 01             	lea    0x1(%eax),%edx
c01059c3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059c6:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c01059c9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059cc:	8b 10                	mov    (%eax),%edx
c01059ce:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059d1:	8b 40 04             	mov    0x4(%eax),%eax
c01059d4:	39 c2                	cmp    %eax,%edx
c01059d6:	73 12                	jae    c01059ea <sprintputch+0x33>
        *b->buf ++ = ch;
c01059d8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059db:	8b 00                	mov    (%eax),%eax
c01059dd:	8d 48 01             	lea    0x1(%eax),%ecx
c01059e0:	8b 55 0c             	mov    0xc(%ebp),%edx
c01059e3:	89 0a                	mov    %ecx,(%edx)
c01059e5:	8b 55 08             	mov    0x8(%ebp),%edx
c01059e8:	88 10                	mov    %dl,(%eax)
    }
}
c01059ea:	5d                   	pop    %ebp
c01059eb:	c3                   	ret    

c01059ec <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c01059ec:	55                   	push   %ebp
c01059ed:	89 e5                	mov    %esp,%ebp
c01059ef:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c01059f2:	8d 45 14             	lea    0x14(%ebp),%eax
c01059f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c01059f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01059fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01059ff:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a02:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105a06:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a09:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a10:	89 04 24             	mov    %eax,(%esp)
c0105a13:	e8 08 00 00 00       	call   c0105a20 <vsnprintf>
c0105a18:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105a1e:	c9                   	leave  
c0105a1f:	c3                   	ret    

c0105a20 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105a20:	55                   	push   %ebp
c0105a21:	89 e5                	mov    %esp,%ebp
c0105a23:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105a26:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a29:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105a2c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a2f:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105a32:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a35:	01 d0                	add    %edx,%eax
c0105a37:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a3a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105a41:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105a45:	74 0a                	je     c0105a51 <vsnprintf+0x31>
c0105a47:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105a4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a4d:	39 c2                	cmp    %eax,%edx
c0105a4f:	76 07                	jbe    c0105a58 <vsnprintf+0x38>
        return -E_INVAL;
c0105a51:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105a56:	eb 2a                	jmp    c0105a82 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105a58:	8b 45 14             	mov    0x14(%ebp),%eax
c0105a5b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105a5f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a62:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105a66:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105a69:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a6d:	c7 04 24 b7 59 10 c0 	movl   $0xc01059b7,(%esp)
c0105a74:	e8 53 fb ff ff       	call   c01055cc <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0105a79:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105a7c:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105a82:	c9                   	leave  
c0105a83:	c3                   	ret    

c0105a84 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105a84:	55                   	push   %ebp
c0105a85:	89 e5                	mov    %esp,%ebp
c0105a87:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105a8a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105a91:	eb 04                	jmp    c0105a97 <strlen+0x13>
        cnt ++;
c0105a93:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0105a97:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a9a:	8d 50 01             	lea    0x1(%eax),%edx
c0105a9d:	89 55 08             	mov    %edx,0x8(%ebp)
c0105aa0:	0f b6 00             	movzbl (%eax),%eax
c0105aa3:	84 c0                	test   %al,%al
c0105aa5:	75 ec                	jne    c0105a93 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0105aa7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105aaa:	c9                   	leave  
c0105aab:	c3                   	ret    

c0105aac <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105aac:	55                   	push   %ebp
c0105aad:	89 e5                	mov    %esp,%ebp
c0105aaf:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105ab2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105ab9:	eb 04                	jmp    c0105abf <strnlen+0x13>
        cnt ++;
c0105abb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c0105abf:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105ac2:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105ac5:	73 10                	jae    c0105ad7 <strnlen+0x2b>
c0105ac7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105aca:	8d 50 01             	lea    0x1(%eax),%edx
c0105acd:	89 55 08             	mov    %edx,0x8(%ebp)
c0105ad0:	0f b6 00             	movzbl (%eax),%eax
c0105ad3:	84 c0                	test   %al,%al
c0105ad5:	75 e4                	jne    c0105abb <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0105ad7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105ada:	c9                   	leave  
c0105adb:	c3                   	ret    

c0105adc <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105adc:	55                   	push   %ebp
c0105add:	89 e5                	mov    %esp,%ebp
c0105adf:	57                   	push   %edi
c0105ae0:	56                   	push   %esi
c0105ae1:	83 ec 20             	sub    $0x20,%esp
c0105ae4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ae7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105aea:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105aed:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105af0:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105af3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105af6:	89 d1                	mov    %edx,%ecx
c0105af8:	89 c2                	mov    %eax,%edx
c0105afa:	89 ce                	mov    %ecx,%esi
c0105afc:	89 d7                	mov    %edx,%edi
c0105afe:	ac                   	lods   %ds:(%esi),%al
c0105aff:	aa                   	stos   %al,%es:(%edi)
c0105b00:	84 c0                	test   %al,%al
c0105b02:	75 fa                	jne    c0105afe <strcpy+0x22>
c0105b04:	89 fa                	mov    %edi,%edx
c0105b06:	89 f1                	mov    %esi,%ecx
c0105b08:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105b0b:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105b0e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105b14:	83 c4 20             	add    $0x20,%esp
c0105b17:	5e                   	pop    %esi
c0105b18:	5f                   	pop    %edi
c0105b19:	5d                   	pop    %ebp
c0105b1a:	c3                   	ret    

c0105b1b <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105b1b:	55                   	push   %ebp
c0105b1c:	89 e5                	mov    %esp,%ebp
c0105b1e:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105b21:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b24:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105b27:	eb 21                	jmp    c0105b4a <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0105b29:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b2c:	0f b6 10             	movzbl (%eax),%edx
c0105b2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105b32:	88 10                	mov    %dl,(%eax)
c0105b34:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105b37:	0f b6 00             	movzbl (%eax),%eax
c0105b3a:	84 c0                	test   %al,%al
c0105b3c:	74 04                	je     c0105b42 <strncpy+0x27>
            src ++;
c0105b3e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0105b42:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105b46:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0105b4a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105b4e:	75 d9                	jne    c0105b29 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0105b50:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105b53:	c9                   	leave  
c0105b54:	c3                   	ret    

c0105b55 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105b55:	55                   	push   %ebp
c0105b56:	89 e5                	mov    %esp,%ebp
c0105b58:	57                   	push   %edi
c0105b59:	56                   	push   %esi
c0105b5a:	83 ec 20             	sub    $0x20,%esp
c0105b5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b60:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105b63:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b66:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0105b69:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105b6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b6f:	89 d1                	mov    %edx,%ecx
c0105b71:	89 c2                	mov    %eax,%edx
c0105b73:	89 ce                	mov    %ecx,%esi
c0105b75:	89 d7                	mov    %edx,%edi
c0105b77:	ac                   	lods   %ds:(%esi),%al
c0105b78:	ae                   	scas   %es:(%edi),%al
c0105b79:	75 08                	jne    c0105b83 <strcmp+0x2e>
c0105b7b:	84 c0                	test   %al,%al
c0105b7d:	75 f8                	jne    c0105b77 <strcmp+0x22>
c0105b7f:	31 c0                	xor    %eax,%eax
c0105b81:	eb 04                	jmp    c0105b87 <strcmp+0x32>
c0105b83:	19 c0                	sbb    %eax,%eax
c0105b85:	0c 01                	or     $0x1,%al
c0105b87:	89 fa                	mov    %edi,%edx
c0105b89:	89 f1                	mov    %esi,%ecx
c0105b8b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105b8e:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105b91:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0105b94:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105b97:	83 c4 20             	add    $0x20,%esp
c0105b9a:	5e                   	pop    %esi
c0105b9b:	5f                   	pop    %edi
c0105b9c:	5d                   	pop    %ebp
c0105b9d:	c3                   	ret    

c0105b9e <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105b9e:	55                   	push   %ebp
c0105b9f:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105ba1:	eb 0c                	jmp    c0105baf <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0105ba3:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105ba7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105bab:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105baf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105bb3:	74 1a                	je     c0105bcf <strncmp+0x31>
c0105bb5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bb8:	0f b6 00             	movzbl (%eax),%eax
c0105bbb:	84 c0                	test   %al,%al
c0105bbd:	74 10                	je     c0105bcf <strncmp+0x31>
c0105bbf:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bc2:	0f b6 10             	movzbl (%eax),%edx
c0105bc5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bc8:	0f b6 00             	movzbl (%eax),%eax
c0105bcb:	38 c2                	cmp    %al,%dl
c0105bcd:	74 d4                	je     c0105ba3 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105bcf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105bd3:	74 18                	je     c0105bed <strncmp+0x4f>
c0105bd5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bd8:	0f b6 00             	movzbl (%eax),%eax
c0105bdb:	0f b6 d0             	movzbl %al,%edx
c0105bde:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105be1:	0f b6 00             	movzbl (%eax),%eax
c0105be4:	0f b6 c0             	movzbl %al,%eax
c0105be7:	29 c2                	sub    %eax,%edx
c0105be9:	89 d0                	mov    %edx,%eax
c0105beb:	eb 05                	jmp    c0105bf2 <strncmp+0x54>
c0105bed:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105bf2:	5d                   	pop    %ebp
c0105bf3:	c3                   	ret    

c0105bf4 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105bf4:	55                   	push   %ebp
c0105bf5:	89 e5                	mov    %esp,%ebp
c0105bf7:	83 ec 04             	sub    $0x4,%esp
c0105bfa:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bfd:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105c00:	eb 14                	jmp    c0105c16 <strchr+0x22>
        if (*s == c) {
c0105c02:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c05:	0f b6 00             	movzbl (%eax),%eax
c0105c08:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105c0b:	75 05                	jne    c0105c12 <strchr+0x1e>
            return (char *)s;
c0105c0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c10:	eb 13                	jmp    c0105c25 <strchr+0x31>
        }
        s ++;
c0105c12:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0105c16:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c19:	0f b6 00             	movzbl (%eax),%eax
c0105c1c:	84 c0                	test   %al,%al
c0105c1e:	75 e2                	jne    c0105c02 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0105c20:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105c25:	c9                   	leave  
c0105c26:	c3                   	ret    

c0105c27 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105c27:	55                   	push   %ebp
c0105c28:	89 e5                	mov    %esp,%ebp
c0105c2a:	83 ec 04             	sub    $0x4,%esp
c0105c2d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c30:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105c33:	eb 11                	jmp    c0105c46 <strfind+0x1f>
        if (*s == c) {
c0105c35:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c38:	0f b6 00             	movzbl (%eax),%eax
c0105c3b:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105c3e:	75 02                	jne    c0105c42 <strfind+0x1b>
            break;
c0105c40:	eb 0e                	jmp    c0105c50 <strfind+0x29>
        }
        s ++;
c0105c42:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0105c46:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c49:	0f b6 00             	movzbl (%eax),%eax
c0105c4c:	84 c0                	test   %al,%al
c0105c4e:	75 e5                	jne    c0105c35 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c0105c50:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105c53:	c9                   	leave  
c0105c54:	c3                   	ret    

c0105c55 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105c55:	55                   	push   %ebp
c0105c56:	89 e5                	mov    %esp,%ebp
c0105c58:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105c5b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105c62:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105c69:	eb 04                	jmp    c0105c6f <strtol+0x1a>
        s ++;
c0105c6b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105c6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c72:	0f b6 00             	movzbl (%eax),%eax
c0105c75:	3c 20                	cmp    $0x20,%al
c0105c77:	74 f2                	je     c0105c6b <strtol+0x16>
c0105c79:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c7c:	0f b6 00             	movzbl (%eax),%eax
c0105c7f:	3c 09                	cmp    $0x9,%al
c0105c81:	74 e8                	je     c0105c6b <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0105c83:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c86:	0f b6 00             	movzbl (%eax),%eax
c0105c89:	3c 2b                	cmp    $0x2b,%al
c0105c8b:	75 06                	jne    c0105c93 <strtol+0x3e>
        s ++;
c0105c8d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105c91:	eb 15                	jmp    c0105ca8 <strtol+0x53>
    }
    else if (*s == '-') {
c0105c93:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c96:	0f b6 00             	movzbl (%eax),%eax
c0105c99:	3c 2d                	cmp    $0x2d,%al
c0105c9b:	75 0b                	jne    c0105ca8 <strtol+0x53>
        s ++, neg = 1;
c0105c9d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105ca1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105ca8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105cac:	74 06                	je     c0105cb4 <strtol+0x5f>
c0105cae:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105cb2:	75 24                	jne    c0105cd8 <strtol+0x83>
c0105cb4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cb7:	0f b6 00             	movzbl (%eax),%eax
c0105cba:	3c 30                	cmp    $0x30,%al
c0105cbc:	75 1a                	jne    c0105cd8 <strtol+0x83>
c0105cbe:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cc1:	83 c0 01             	add    $0x1,%eax
c0105cc4:	0f b6 00             	movzbl (%eax),%eax
c0105cc7:	3c 78                	cmp    $0x78,%al
c0105cc9:	75 0d                	jne    c0105cd8 <strtol+0x83>
        s += 2, base = 16;
c0105ccb:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105ccf:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105cd6:	eb 2a                	jmp    c0105d02 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0105cd8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105cdc:	75 17                	jne    c0105cf5 <strtol+0xa0>
c0105cde:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ce1:	0f b6 00             	movzbl (%eax),%eax
c0105ce4:	3c 30                	cmp    $0x30,%al
c0105ce6:	75 0d                	jne    c0105cf5 <strtol+0xa0>
        s ++, base = 8;
c0105ce8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105cec:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105cf3:	eb 0d                	jmp    c0105d02 <strtol+0xad>
    }
    else if (base == 0) {
c0105cf5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105cf9:	75 07                	jne    c0105d02 <strtol+0xad>
        base = 10;
c0105cfb:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105d02:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d05:	0f b6 00             	movzbl (%eax),%eax
c0105d08:	3c 2f                	cmp    $0x2f,%al
c0105d0a:	7e 1b                	jle    c0105d27 <strtol+0xd2>
c0105d0c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d0f:	0f b6 00             	movzbl (%eax),%eax
c0105d12:	3c 39                	cmp    $0x39,%al
c0105d14:	7f 11                	jg     c0105d27 <strtol+0xd2>
            dig = *s - '0';
c0105d16:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d19:	0f b6 00             	movzbl (%eax),%eax
c0105d1c:	0f be c0             	movsbl %al,%eax
c0105d1f:	83 e8 30             	sub    $0x30,%eax
c0105d22:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105d25:	eb 48                	jmp    c0105d6f <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105d27:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d2a:	0f b6 00             	movzbl (%eax),%eax
c0105d2d:	3c 60                	cmp    $0x60,%al
c0105d2f:	7e 1b                	jle    c0105d4c <strtol+0xf7>
c0105d31:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d34:	0f b6 00             	movzbl (%eax),%eax
c0105d37:	3c 7a                	cmp    $0x7a,%al
c0105d39:	7f 11                	jg     c0105d4c <strtol+0xf7>
            dig = *s - 'a' + 10;
c0105d3b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d3e:	0f b6 00             	movzbl (%eax),%eax
c0105d41:	0f be c0             	movsbl %al,%eax
c0105d44:	83 e8 57             	sub    $0x57,%eax
c0105d47:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105d4a:	eb 23                	jmp    c0105d6f <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105d4c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d4f:	0f b6 00             	movzbl (%eax),%eax
c0105d52:	3c 40                	cmp    $0x40,%al
c0105d54:	7e 3d                	jle    c0105d93 <strtol+0x13e>
c0105d56:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d59:	0f b6 00             	movzbl (%eax),%eax
c0105d5c:	3c 5a                	cmp    $0x5a,%al
c0105d5e:	7f 33                	jg     c0105d93 <strtol+0x13e>
            dig = *s - 'A' + 10;
c0105d60:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d63:	0f b6 00             	movzbl (%eax),%eax
c0105d66:	0f be c0             	movsbl %al,%eax
c0105d69:	83 e8 37             	sub    $0x37,%eax
c0105d6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d72:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105d75:	7c 02                	jl     c0105d79 <strtol+0x124>
            break;
c0105d77:	eb 1a                	jmp    c0105d93 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0105d79:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105d7d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105d80:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105d84:	89 c2                	mov    %eax,%edx
c0105d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d89:	01 d0                	add    %edx,%eax
c0105d8b:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0105d8e:	e9 6f ff ff ff       	jmp    c0105d02 <strtol+0xad>

    if (endptr) {
c0105d93:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105d97:	74 08                	je     c0105da1 <strtol+0x14c>
        *endptr = (char *) s;
c0105d99:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d9c:	8b 55 08             	mov    0x8(%ebp),%edx
c0105d9f:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105da1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105da5:	74 07                	je     c0105dae <strtol+0x159>
c0105da7:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105daa:	f7 d8                	neg    %eax
c0105dac:	eb 03                	jmp    c0105db1 <strtol+0x15c>
c0105dae:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105db1:	c9                   	leave  
c0105db2:	c3                   	ret    

c0105db3 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105db3:	55                   	push   %ebp
c0105db4:	89 e5                	mov    %esp,%ebp
c0105db6:	57                   	push   %edi
c0105db7:	83 ec 24             	sub    $0x24,%esp
c0105dba:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105dbd:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105dc0:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0105dc4:	8b 55 08             	mov    0x8(%ebp),%edx
c0105dc7:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0105dca:	88 45 f7             	mov    %al,-0x9(%ebp)
c0105dcd:	8b 45 10             	mov    0x10(%ebp),%eax
c0105dd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105dd3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105dd6:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105dda:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105ddd:	89 d7                	mov    %edx,%edi
c0105ddf:	f3 aa                	rep stos %al,%es:(%edi)
c0105de1:	89 fa                	mov    %edi,%edx
c0105de3:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105de6:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105de9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105dec:	83 c4 24             	add    $0x24,%esp
c0105def:	5f                   	pop    %edi
c0105df0:	5d                   	pop    %ebp
c0105df1:	c3                   	ret    

c0105df2 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105df2:	55                   	push   %ebp
c0105df3:	89 e5                	mov    %esp,%ebp
c0105df5:	57                   	push   %edi
c0105df6:	56                   	push   %esi
c0105df7:	53                   	push   %ebx
c0105df8:	83 ec 30             	sub    $0x30,%esp
c0105dfb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dfe:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105e01:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e04:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105e07:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e0a:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105e0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e10:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105e13:	73 42                	jae    c0105e57 <memmove+0x65>
c0105e15:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e18:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105e1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e1e:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105e21:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105e24:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105e27:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105e2a:	c1 e8 02             	shr    $0x2,%eax
c0105e2d:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105e2f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105e32:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105e35:	89 d7                	mov    %edx,%edi
c0105e37:	89 c6                	mov    %eax,%esi
c0105e39:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105e3b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105e3e:	83 e1 03             	and    $0x3,%ecx
c0105e41:	74 02                	je     c0105e45 <memmove+0x53>
c0105e43:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105e45:	89 f0                	mov    %esi,%eax
c0105e47:	89 fa                	mov    %edi,%edx
c0105e49:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105e4c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105e4f:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105e52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105e55:	eb 36                	jmp    c0105e8d <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0105e57:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105e5a:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105e5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e60:	01 c2                	add    %eax,%edx
c0105e62:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105e65:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105e68:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e6b:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0105e6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105e71:	89 c1                	mov    %eax,%ecx
c0105e73:	89 d8                	mov    %ebx,%eax
c0105e75:	89 d6                	mov    %edx,%esi
c0105e77:	89 c7                	mov    %eax,%edi
c0105e79:	fd                   	std    
c0105e7a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105e7c:	fc                   	cld    
c0105e7d:	89 f8                	mov    %edi,%eax
c0105e7f:	89 f2                	mov    %esi,%edx
c0105e81:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105e84:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105e87:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0105e8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105e8d:	83 c4 30             	add    $0x30,%esp
c0105e90:	5b                   	pop    %ebx
c0105e91:	5e                   	pop    %esi
c0105e92:	5f                   	pop    %edi
c0105e93:	5d                   	pop    %ebp
c0105e94:	c3                   	ret    

c0105e95 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105e95:	55                   	push   %ebp
c0105e96:	89 e5                	mov    %esp,%ebp
c0105e98:	57                   	push   %edi
c0105e99:	56                   	push   %esi
c0105e9a:	83 ec 20             	sub    $0x20,%esp
c0105e9d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ea0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105ea3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ea6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105ea9:	8b 45 10             	mov    0x10(%ebp),%eax
c0105eac:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105eaf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105eb2:	c1 e8 02             	shr    $0x2,%eax
c0105eb5:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105eb7:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105eba:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ebd:	89 d7                	mov    %edx,%edi
c0105ebf:	89 c6                	mov    %eax,%esi
c0105ec1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105ec3:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105ec6:	83 e1 03             	and    $0x3,%ecx
c0105ec9:	74 02                	je     c0105ecd <memcpy+0x38>
c0105ecb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105ecd:	89 f0                	mov    %esi,%eax
c0105ecf:	89 fa                	mov    %edi,%edx
c0105ed1:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105ed4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105ed7:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105eda:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105edd:	83 c4 20             	add    $0x20,%esp
c0105ee0:	5e                   	pop    %esi
c0105ee1:	5f                   	pop    %edi
c0105ee2:	5d                   	pop    %ebp
c0105ee3:	c3                   	ret    

c0105ee4 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105ee4:	55                   	push   %ebp
c0105ee5:	89 e5                	mov    %esp,%ebp
c0105ee7:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105eea:	8b 45 08             	mov    0x8(%ebp),%eax
c0105eed:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105ef0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ef3:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105ef6:	eb 30                	jmp    c0105f28 <memcmp+0x44>
        if (*s1 != *s2) {
c0105ef8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105efb:	0f b6 10             	movzbl (%eax),%edx
c0105efe:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105f01:	0f b6 00             	movzbl (%eax),%eax
c0105f04:	38 c2                	cmp    %al,%dl
c0105f06:	74 18                	je     c0105f20 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105f08:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105f0b:	0f b6 00             	movzbl (%eax),%eax
c0105f0e:	0f b6 d0             	movzbl %al,%edx
c0105f11:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105f14:	0f b6 00             	movzbl (%eax),%eax
c0105f17:	0f b6 c0             	movzbl %al,%eax
c0105f1a:	29 c2                	sub    %eax,%edx
c0105f1c:	89 d0                	mov    %edx,%eax
c0105f1e:	eb 1a                	jmp    c0105f3a <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0105f20:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105f24:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0105f28:	8b 45 10             	mov    0x10(%ebp),%eax
c0105f2b:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105f2e:	89 55 10             	mov    %edx,0x10(%ebp)
c0105f31:	85 c0                	test   %eax,%eax
c0105f33:	75 c3                	jne    c0105ef8 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0105f35:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105f3a:	c9                   	leave  
c0105f3b:	c3                   	ret    
