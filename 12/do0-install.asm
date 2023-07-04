; 安装 0 号中断处理程序，到内存空间0000:0200H处

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

        mov cx, do0_ok - offset do0
        cld
        rep movsb

        ; do0安装完成
        mov ax, 4c00h
        int 21h


    do0:
        jmp start
    data:
        db 'GWJ: div overflow!!!', 0
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
        mov si, data
        mov dh, 12
        mov dl, 30
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

            mov es:[di], ax

            inc si
            add di, 2
            loop each_str   
    ; 参数：dh=行号（取值范围0~24)
    ;      dl=列号（0~79）
    ;      cl=颜色
    ;      ds:si指向字符串首地址
    

    ok: 
        pop dx
        pop cx
        pop bx
        pop ax
        pop si 
        pop di 
        pop ds
        pop es

            
        mov ax, 4c00h
        int 21h
    do0_ok: 
        nop   ; do0_ok-do0 得到的是不包含 do0_ok 处的指令

code ends

end _install