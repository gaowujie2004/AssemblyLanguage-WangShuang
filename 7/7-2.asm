; 任务1：用di和si实现字符串’welecom to masm‘复制到它后面的数据区中

assume cs:code, ds:data

data segment
    db 'welcome to masm!'  ; 16byte
    db '...............'   ; 16byte
data ends

code segment
    start: mov ax, data
    mov ds, ax 
    ; 相对偏移
    mov di, 0
    mov si, 16

    mov bx, 0
    mov cx, 16
    copy: mov al, [di+bx]
    mov [si+bx], al
    ; mov [si+bx], [di+bx] 不可以
    int bx
    loop copy


    mov cx,16
    copy: mov al, ds:[si]


    
    mov ax, 4c00h
    int 21h
code ends 

end start