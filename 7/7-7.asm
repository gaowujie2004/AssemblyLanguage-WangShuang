; 任务1：将数据段的每个字母转为大写



assume cs:code, ds:data

data segment
    db 'ibm             ' ;16byte
    db 'gwj             '
    db 'qbl             '
    db 'dos             '
data ends

code segment
    start: mov ax, data
    mov ds, ax 

    mov bx, 0
    mov di, 0
    mov cx, 4
R:  mov dx, cx;  暂存一下 cx
    mov cx, 3
    mov di, 0
        CC:  mov al, [bx+di]
        and al, 11011111B
        mov [bx+di], al
        inc di
        loop CC
    mov cx, dx
    add bx, 0010h
    loop R

    mov ax, 4c00h
    int 21h
code ends 

end start