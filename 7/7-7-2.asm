; 任务1：将数据段的每个字母转为大写
; 任务2：我们将 cx 寄存器的值暂存到了dx，若寄存器都被使用了，该怎么办？ 很显然寄存器是比较少的，但内存空间是很大的，可以把cx的数据暂存到内存空间，比如：


assume cs:code, ds:data

data segment
    db 'ibm             ' ; 实际占用空间是16byte，所以没有占那么多
    db 'gwj             '
    db 'qbl             '
    db 'dos             '
    dw 0                  ; ———————— 暂存cx中的数据, 2byte，但 data 实际占4*16个byte
data ends


code segment
    start: mov ax, data
    mov ds, ax 

    mov bx, 0
    mov di, 0
    mov cx, 4
R:  mov ds:[40h], cx  ; 若偏移地址是立即数，则需要端前缀
    mov cx, 3
    mov di, 0
        CC:  mov al, [bx+di]
        and al, 11011111B
        mov [bx+di], al
        inc di
        loop CC
    mov  cx, [0040h]
    add bx, 0010h
    loop R

    mov ax, 4c00h
    int 21h
code ends 

end start