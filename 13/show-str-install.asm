assume cs:code

stack segment
    db 0 dup(256)
stack ends

code segment
    start: 
        ; 1、安装 7ch，中断例程
        ; 安装 -> 0000:0200h 处，
        mov ax, cs
        mov ds ,ax     ; 数据源 ds:si
        mov si, offset show_str

        mov ax, 0 
        mov es, ax                ; 数据目的 es:di
        mov di, 200H

        mov cx, offset show_str_end - offset show_str
        cld 
        rep movsb

        mov ax, stack
        mov ss, ax
        mov sp, 00FFh


        ; 2、将中断处理程序入口地址，写入中断向量表
        ;  (0*16) + (7ch * 4) =  中断处理程序的IP
        ;  (0*16) + (7ch * 4 + 2) = 中断处理程序的CS
        mov ax, 0
        mov ds, ax
        mov word ptr ds:[0], 200h 
        mov word ptr ds:[2], 0000h 

         mov ax, 1000H
    mov bh, 1     ; 被除数（16-bit）/ 除数（8-bit）= 商（AL）、余数（AH）
    div bh        ; 内中断——0号中断

        mov ax, 4c00h
        int 21h

    ; 内部参数：dh=行号（取值范围0~24)
    ;         dl=列号（0~79）
    ;         cl=颜色
    ;         ds:si指向字符串首地址
    show_str:
        mov dh, 12
        mov dl, 30
        mov cl, 10011000B

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

        jmp short code_str
        data: db 'GaoWuJie !!!', 0

        code_str:
        mov ax, cs
        mov ds, ax
        ; TODO 重点
        mov si, 0200h + (offset data - offset show_str)


        ; 遍历字符串
        mov ah, cl  ; 颜色
        mov ch, 0
        each_str: 
            mov al, ds:[si]   ; 当前字符
            mov cl, al
            
            jcxz ok

            mov es:[di], ax

            inc si
            add di, 2
            loop each_str   
        ok:         
            ; pop ax
            ; add ax,2
            ; push ax
        
            iret 

        show_str_end: nop
    
code ends


end  start