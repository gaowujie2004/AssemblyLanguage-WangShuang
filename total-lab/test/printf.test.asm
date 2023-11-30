assume cs:code, ds:data, ss:stack


data segment
    cursor   db  0fh, 0fh, 0fh, 0fh
data ends

stack segment
    db 512 dup(0ffh)
stack ends

code segment
    start:
        mov ax, data 
        mov ds, ax

        

        mov ah, 02h ; 设置光标位置的功能号
        mov bh, 00h ; 显示页号为 0
        mov dh, 00h ; 光标所在的行号为 0
        mov dl, 00h ; 光标所在的列号为 0
        int 10h ; 调用 BIOS 中断


        ; call delay

        mov ax, 4c00h
        
        int 21h
        
    delay:
        push ax
        push dx

        mov dx, 00aah
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

code ends

end start 