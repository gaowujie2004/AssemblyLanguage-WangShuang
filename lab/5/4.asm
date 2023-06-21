; 将 a段和b段的数据依次相加，结果放在c段

assume cs:code

a segment 
    db 1,2,3,4,5,6,7,8
a ends 

b segment 
    db 1,2,3,4,5,6,7,8
b ends 

c segment 
    db 0,0,0,0, 0,0,0,0
c ends 


code segment
    start: 

    mov bx, 0
    mov cx, 8
    s: mov al, 0    ; ---------------- 注意，al
    ; ---------------- 可以这样写吗？  ax, a:[bx] ，我理解不可以，段地址必须是寄存器（目前已知的是）
    add al, a:[bx]
    add al, b:[bx]
    mov c:[bx], al
    inc bx
    loop s

    mov ax, 4c00h
    int 21h

code ends 


end start