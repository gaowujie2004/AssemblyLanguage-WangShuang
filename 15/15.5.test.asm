assume cs:code, ss:stack


stack segment
    db 128 dup(10100101B)
stack ends

data segment
    db 8 dup(10100101B) ;该魔术数字的含义是:标识是不是我设置的区域
data ends

code segment 
    mov ax, 0b800h
    mov es, ax
    mov di, 0
    mov cx, 2000
    mov al, 20h ;空格
    mov ah, 01000000B
    s:
        mov es:[di], ax
        add di,2
        loop s 
    call delay

    mov di, 1
    mov ah, 00100000B
    s1:
        mov es:[di], ah
        add di,2
        loop s1
    call delay
    

    mov ah, 11110000B
    mov di, 1
    s2:
        mov es:[di], ah
        add di,2
        loop s2 
    call delay


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
code ends

end