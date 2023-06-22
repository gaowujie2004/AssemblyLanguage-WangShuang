; 任务1：将数据段的前4个字母转为大写


assume cs:code, ds:data

stack segment 
    dw 0,0,0,0,  0,0,0,0
stack ends 

data segment
    db '1.txt ' ; 实际占用空间是16byte，所以没有占那么多
    db 'gwj             '
    db 'qbl             '
    db 'dos             '
data ends


code segment
    start: mov ax, stack
    mov ss, ax
    mov sp, 0010h

    mov ax, data
    mov ds, ax 

    mov bx, 0
    mov di, 0
    mov cx, 4
R:  push cx
    mov cx, 4
    mov di, 3
        CC:  mov al, [bx+di]
        and al, 11011111B
        mov [bx+di], al
        inc di
        loop CC
    pop cx
    add bx, 0010h
    loop R

    mov ax, 4c00h
    int 21h
code ends 

end start