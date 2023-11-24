; 按下Esc键，改变文字显示颜色
; 程序结束之前，恢复中断处理程序。（为什么？因为我们写的 int 9 中断例程在程序退出后这块内存空间就可能会被回收）

; 步骤：
    ; 1）
    ; 2）
    ; 3）重写int9例程，内部实现：按下Esc键，改变文字显示颜色
    ; 4）程序结束前，将原BIOS int9中断例程的物理地址在中断向量表中重置
assume cs:code, ss:stack


stack segment
    db 128 dup(10100101B)
stack ends

data segment
    db 8 dup(10100101B) ;该魔术数字的含义是:标识是不是我设置的区域
data ends

code segment 
    _start: 
    ;mainProcess: 初始化栈、数据内存
    mov ax, data
    mov ds, ax
    mov ax, stack
    mov ss, ax
    mov sp, 128

    ;mainProcess: 保存BIOS int9中断例程的物理地址（CS、IP）到数据内存中，重写int9中断向量表内容
    ;low 16-bit -> IP、height 16-bit->CS
    mov ax, 0
    mov es, ax ;0000段地址是中断向量表的内存区域
    push es:[4*9]
    pop ds:[0]
    push es:[4*9+2]
    pop ds:[2]
    ;mov word ptr ds:[0], es:[4*9]   ;ip
    ;mov word ptr ds:[2], es:[4*9+2] ;cs
    ; 重新int9中断向量表
    ; ------------------------------------------------------------- 重点注意 -------------------------------------------------
    ; 若下一行代码被执行完，此时触发了一个键盘中断。那将会发生错误，因为新的int9中断例程的cs还没有写入到中断向量表。因此从一开始写入就要屏蔽可屏蔽中断。
    cli
    mov word ptr es:[4*9], offset int9
    mov es:[4*9+2], cs 
    sti

    ;mainProcess: 主程序
    mov ax, 0b800h
    mov es, ax
    mov di, 160*12+40*2
    mov ah, 01000000B
    mov al, 'a'
    a_to_z:
        mov es:[di], ax
        
        call delay
        
        inc al
        cmp al, 'z'
        jna a_to_z ;al <= 'z'

    ;mainProcess：退出之前，恢复中断向量表int9BIOS
    mov ax, 0
    mov es, ax
    push ds:[0]
    pop es:[4*9]
    push ds:[2]
    pop es:[4*9+2]
    
    mov ax, 4c00h
    int 21h


    delay:
        push ax
        push dx

        mov dx, 0005h
        mov ax, 0
        each_sub:
            sub ax,1
            sbb dx,0
            cmp ax,0
            jne each_sub
            cmp dx,0
            jne each_sub

        pop dx
        pop ax
        ret

    ;mainProcess: 新的int9中断例程
    int9:
        push ax
        push bx 
        push es
        
        in al, 60h ;键盘扫描码端口寄存器
        mov bl, al;  暂存al键盘扫描码

        ;模拟BIOS的int9例程触发
        ;中断过程：1)获取中断号；2）pushf；3）IF、TF=0；4）push cs、push ip；5）R[IP] <- M[N*4], R[CS] <- M[N*4+2]
        pushf
        ;TF、IF在标志寄存器（16-bit）的第8、9位
        ;TF、IF设置0可省略，因为中断过程本身就会设置TF、IF=0
        pushf ;标志位（2byte）入栈
        pop ax;标志位数据
        and ah, 11111100B ;高字节低两位是IF、TF
        push ax
        popf
        ;push cs 
        ;push ip
        ;jmp dword ptr ds:[0]
        call dword ptr ds:[0]

        cmp bl, 01h
        jne int9_end        ;不相等
        ;按下ESC，改变颜色
        mov ax, 0b800h
        mov es, ax
        inc byte ptr es:[160*12+40*2 + 1] ;高位存放的是字符属性（颜色）
        
        int9_end: 
        pop es
        pop bx
        pop ax
        iret 
code ends

end _start