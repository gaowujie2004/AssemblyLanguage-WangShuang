;安装一个新的int 9中断例程，功能：在DOS下，按下“A”键后，除非不再松开，如果松开，就显示满屏幕的“A”,其他的键照常处理。
;这一次将新的int9中断例程写入0000:0204h处。
assume cs:code, ss:stack

stack segment
    db 128 dup(10100101B)
stack ends


code segment 
    _start: 
    ;mainProcess: 初始化栈、数据内存
    mov ax, stack
    mov ss, ax
    mov sp, 128

    _save_old_int9:  ;0000:0200h -> BIOS-int9 ip;  0000:0202h-> BIOS-int9 cs
    mov ax, 0
    mov ds, ax
    push ds:[9*4] ;BIOS-int9 ip
    pop ds:[0200h]
    push ds:[9*4+2] ;BIOS-int9 cs
    pop ds:[0202h]

    _install:
    ;mainProcess: int9安装到0000:0204h
    ;ds:[si] 数据源
    mov ax, cs
    mov ds, ax
    mov si, int9
    ;es:[di] 目标
    mov ax, 0
    mov es, ax
    mov di, 0204h
    ;长度
    mov cx, offset int9_end - offset int9
    ;传输开始
    cld 
    rep movsb 

    _set_interrupt_vector_table:
    ; ------------------------------------------------------------- 重点注意 -------------------------------------------------
    ; 若下一行代码被执行完，此时触发了一个键盘中断。那将会发生错误，因为新的int9中断例程的cs还没有写入到中断向量表。因此从一开始写入就要屏蔽可屏蔽中断。
    cli
    mov word ptr es:[4*9], 0204h 
    mov word ptr es:[4*9+2],0h  
    sti

    _main:
    mov ax, 4c00h
    int 21h

    ;mainProcess: 新的int9中断例程
    int9:
        push ax
        push bx 
        push es
        push di
        push cx
        push ds
        
        in al, 60h ;键盘扫描码端口寄存器
        mov bl, al;  暂存al键盘扫描码

        ;模拟BIOS的int9例程触发
        ;中断过程：1)获取中断号；2）pushf；3）IF、TF=0；4）push cs、push ip；5）R[IP] <- M[N*4], R[CS] <- M[N*4+2]
        pushf
        call dword ptr cs:[0200h];  (0000:0200h)==BIOS int9 IP

        cmp bl, 1Eh+80h          ;“A”=1eh, 通码+80h=断码
        jne int9_iret            ;不相等
        
        ;松开A，显示满屏的A
        mov ax, 0b800h
        mov es, ax
        mov di, 0
        mov cx, 2000      ;一页屏幕共2000个字符（25*80）
        mov al, 'A'       


        fori:
            mov es:[di], al
            add di,2
            loop fori
        
        int9_iret: 
        pop ds
        pop cx
        pop di
        pop es
        pop bx
        pop ax
        iret
    int9_end: nop
code ends

end _start