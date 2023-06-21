; 将数据、代码、栈放入不同的段
; 任务 ———— 将数据、栈的内存分配到其他段，不放到代码段
; 任务 ———— 基于以上，完成 6.2 中的任务： 利用栈，将代码段中的数据逆序排序 code segment   dw 0123h, 0456h, 0789h, 0abch      0defh, 5555h, 6666h, 7777h


assume cs:code, ss:stack, ds:data ; 伪指令，可有可无，起到补充说明的作用。


; 内存段 data 表示，在编译后被替换为一个地址（占位），程序载入内存中，再次被调整
data segment
    dw 0123h, 0456h, 0789h, 0abch,      0defh, 5555h, 6666h, 7777h
    ; ds:00 ~ ds:0x0f，一共16byte
data ends

; 内存段 stack 表示，在编译后被替换为一个地址（占位），程序载入内存中，再次被调整
stack segment
    dw 3333h,3333h,3333h,3333h,      3333h,3333h,3333h,3333h,     3333h,3333h,3333h,3333h,     3333h,3333h,3333h,3333h
    ; ss:0x00 ~ ss:0x1f  一共32byte
    ; 栈顶SP=ss:0x20， 0x1f偏移是最后一个字单元的高位地址，最后一个字单元的起始地址是ss:0x1e，那么栈顶就是 SP=ss:(0x2e+2)=ss:0x30
stack ends 


; 程序思路：1）将ds:00~ds:0x0f的16byte数据依次入栈；2）出栈后再次出栈到ds:00~ds:0x0f
code segment
    ; 标记程序(指令)开始的偏移地址，为什么要标记？因为 data、stack段都在code段的上面，不标记以为 data segment 就是程序的第一条指令
    start: mov ax, data
    mov ds, ax
    mov ax, stack
    mov ss, ax
    mov sp, 0020h
    mov bx, 0             

    ; 入栈之前要确认好 SS、SP
    mov cx, 8;    数据段一共8个字单元，一次传输2byte
    pushFor: push ds:[bx]
    add bx, 2
    loop pushFor     ; 1）cx=cx-1；2）cx不为0，则IP=loop的右操作数，  [pushFor]，在汇编后的exe文件已经被替换为 push ds:[bx]指令的所在偏移地址

    ; 出栈
    mov bx, 0
    mov cx, 8
    popFor: pop ds:[bx]
    add bx, 2
    loop popFor

    ; 程序结束
    mov ax, 4c00h
    int 21h
code ends  


end start