; 任务——使用push指令将a段中的前8个字型数据，逆序写入到b段中

assume cs:code 

a segment
    dw 1h, 2h, 3h, 4h, 5h, 6h, 7h, 8h, 9h, 0ah, 0bh, 0ch, 0dh, 0eh, 0fh, 0ffh
    ; 共16个字单元
a ends 

b segment
    dw 0,0,0,0,  0,0,0,0
    ; 共8个字单元
b ends 


code segment
    ; 数据段
    start: mov ax, a
    mov ds, ax

    ; 栈段
    mov ax, b
    mov ss, ax 
    mov sp, 0010h


    mov cx, 7
    mov bx, 0
    s: push ds:[bx]
    add bx, 2
    loop s ; 编译时期被替换为汇编地址（修改IP）

    mov ax, 4c00h
    int 21h
code ends 

end start