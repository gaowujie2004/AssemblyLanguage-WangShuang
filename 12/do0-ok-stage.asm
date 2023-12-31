; 编写 0 号中断处理程序


; 1.编写中断处理程序
; 2.将do0送入0000:0200H处
; 3.将do0的入口地址写入中断向量表的0号表项中 

assume cs:code

code segment
    _install: 
        ; 源
        mov ax, cs 
        mov ds, ax
        mov si, do0
        ; 目的
        mov ax, 0
        mov es, ax
        mov di, 0200H
        ; 写入目的位置
        mov cx, offset do0_ok - offset do0
        cld
        rep movsb
        ; 以上do0安装完成
    _set_interrupt_vector_table:
        ; do0 指令已载入内存空间0000:0200H处
        ; 0号中断处理程序。 内存空间N*4处，存放0号中断处理程序入口地址的偏移地址； 内存空间N*4+2处，存放0号中断处理程序入口的段地址
        mov ax, 0
        mov ds, ax
        mov word ptr ds:[0], 0200H ; 0号中断处理程序入口地址的 段内偏移地址
        mov word ptr ds:[2], 0000H ; 0号中断处理程序入口地址的 段地址

        ; int 0h
        mov ax, 1000H
        mov bh, 1     ; 被除数（16-bit）/ 除数（8-bit）= 商（AL）、余数（AH）
        div bh        ; 内中断——0号中断

        mov ax, 4c00h
        int 21h


    do0:
        jmp start
        data: db 'GWJ: div overflow!!!', 0
    start:
        push es
        push ds
        push di 
        push si 
        push ax
        push bx
        push cx
        push dx

        mov ax, cs
        mov ds, ax
        mov si, 0200h + (offset data - offset do0)  ; 200h 是当前do0程序所在的内存位置的段内起始偏移地址; 这段代码很牛逼。【Good】
        mov dh, 12
        mov dl, 30
        mov cl, 10011000B
    show_str:
        ; 写入目标内存起始地址的——段地址
        mov ax, 0B800H
        mov es, ax
        ; 写入目标内存起始地址的——偏移地址
        mov al, 2
        mul dl
        mov di, ax
        mov al, 160
        mul dh
        add di, ax  ; R*160 + C*2结果在 AX 中，现在放入 di
    
       ; 遍历字符串
        mov ah, cl  ; 颜色
        mov ch, 0
        each_str: 
            mov al, ds:[si]   ; 当前字符
            mov cl, al
            inc cx   ; loop会cx--
            
            jcxz ok

            mov es:[di], ax  ; 写入显存

            inc si
            add di, 2
            loop each_str   
    ok: 
        pop dx
        pop cx
        pop bx
        pop ax
        pop si 
        pop di 
        pop ds
        pop es

        ; 这样可返回到 div 指令的下一条指令。div xx 指令长度=2byte
        ; push bp
        ; mov bp, sp
        ; add ss:[bp + 2], 2
        ; pop bp
        iret ;回到中断前的执行点
    do0_ok: 
        nop

code ends

end _install


; 第一行：B800:00 ~ B800:9F（80个字符占160-byte）
; 第二行：B800:A0 ~ B800:13F
; .........
; 第N行：160*(N-1) ~ 160*(N-1) + 159   N从1开始，若是从0开始，则不需要-1
; 第25行：B800:f00 ~ B800:f9f


;第R行，第C列，对应的地址=160*R + 2*C