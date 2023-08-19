code segment
    _write:
        mov ax, cs
        mov ds, ax ; 数据源      = (   (ds)*16 + (si)   )
        mov si, offset _7ch
    
        mov ax, 0
        mov es, ax
        mov di, 200H ; 数据目的地：0000:0200H

        mov cx, offset _7ch_end - offset _7ch
        cld
        rep movsb
    _set_interrupt_vector_table:
        mov ax, 0
        mov ds, ax
        mov  word ptr ds:[4*7ch], 200h  ; 7ch号中断处理程序第一行代码的IP
        mov  word ptr ds:[4*7ch+2], 0h   ; 7ch号中断处理程序第一行代码的段地址


    mov ax, 0b800h
    mov es, ax
    mov si, 160*12
    mov ah, 10001001B
    mov al, '!'
    mov cx, 80
    mov bx, offset s - offset s_end
    s: 
        mov es:[si], ax
        add si, 2
        int 7ch
    s_end: nop

    mov ax, 4c00h
    int 21h



    _7ch:
        push bp
        mov bp, sp
        dec cx
        jcxz ok
        add [bp + 2], bx
        ok:
            pop bp
            iret
        _7ch_end: 
            nop 
code ends

end

