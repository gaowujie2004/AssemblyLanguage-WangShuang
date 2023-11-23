;编写并安装 int 7ch 中断例程，功能：完成loop指令的功能，在屏幕中间显示80个"！"，中断例程安装在0:200处。
;参数：dh=循环次数、bx=位移。

assume cs:codesg


codesg segment
    _install:   ;将d07ch代码安装到0000:0200h处
        ;es:[di] <- ds:[si]

        ;es:[di]
        mov ax, 0000h
        mov es, ax
        mov di, 0200h
        ;ds:[si]
        mov ax, cs
        mov ds, ax
        mov si, offset do7ch
        ;长度，循环次数
        mov cx, offset do7ch_end_next - offset do7ch    
        ;设置方向，开始循环
        cld
        rep movsb
    _set_table:  ; 7ch
        ;M[7ch*4]   <- 中断例程地址的ip=0200h
        ;M[7ch*4+2] <- 中断例程地址的cs=0000h
        ;7ch*4 = 01f0h
        mov ax, 0
        mov ds, ax
        mov word ptr ds:[01f0h], 0200h
        mov word ptr ds:[01f2h], 0000h
    _main: 
        mov ax, 0b800h
        mov es, ax
        mov di, 160*12
        mov ah, 01000000B
        mov al, '!'
        mov cx, 80
        mov bx, offset each_write - offset each_write_next
        each_write:
            mov es:[di], ax
            add di, 2
            int 7ch 

        ; 返回操作系统
        each_write_next:
        mov ax, 4c00h
        int 21h

    do7ch: ;判断cx!=0，则跳转；  等于零不跳转
        push bp
        ;修改栈中的ip，间接等于跳转。因为当前是中断故，此时的栈内存是   
        ; pushf， CS,   IP，  bp     ->push方向，地址在减小
        ;                     👆ss:sp，此时的ip指向的是触发中断的下一行指令
        
        ; 这样写的原因：ss:[sp] 不合法，sp不能作为索引寄存器， 故用bp代替sp
        mov bp, sp 
        dec cx
        jcxz do7ch_end       ;cx==0，则跳转
        add ss:[bp+2], bx
        do7ch_end: pop bp
        iret
        do7ch_end_next: nop
codesg ends

end _install