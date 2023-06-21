; 任务1：在代码段中使用栈
; 任务2：利用栈，将代码段中的数据逆序排序 code segment   dw 0123h, 0456h, 0789h, 0abch      0defh, 5555h, 6666h, 7777h
; -----------------若栈空间长度是 16 byte，则会导致 cs:00~cs:0x10 处的数据被修改，很奇怪。---------------

assume cs:code

code segment
    dw 0123h, 0456h, 0789h, 0abch,      0defh, 5555h, 6666h, 7777h ;在内存单元 cs:00 处，因为位于代码段的最开头
    dw 0,0,0,0,     0,0,0,0,   0,0,0,0,     0,0,0,0,               ;我们规定，这是共32byte的栈空间。从 cs:0x10处开始，到cs:0x2f结束
    ;可以看到数据、栈都在代码段的开头

    ; 大致思路：cs:0x10 ~ cs:0x2f 为栈空间，初始栈顶SP=cs:0x30（0x2e+2)，然后依次将程序内的数据（cs:00 ~ cs:0x10)压栈；
    ; 压栈完毕后，栈顶是最后一个元素，然后按顺序出栈放入 cs:00 ~ cs:0x10 

    ; 生成的exe文件中，有描述程序的第一条指令的内存位置，即IP=0030h，前48byte是数据，cs:0x30才是第一条指令；当程序被载入到内存时，加载程序的加载器读取IP，并设置CPU的CS:IP
    start: mov ax, cs
    mov ss, ax
    mov sp, 0030h 
    mov bx, 0 ;索引

    mov cx, 8
    enqueue: push cs:[bx]
    add bx, 2
    loop enqueue

    ; 开始出栈，依次放入 cs:00~cs:0x10
    mov cx, 8
    mov bx, 0 
    dequeue: pop cs:[bx]
    add bx, 2
    loop dequeue
    
    mov ax, 4c00h
    int 21h
code ends


end start