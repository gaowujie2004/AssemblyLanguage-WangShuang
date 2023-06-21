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
    start: mov ax, a    ; ds=a（段地址）
    mov ds, ax   
 
    mov ax, b           ; es=b（段地址）
    mov es, ax    

    mov ax, c
    mov ss, ax          ; ss=c（段地址）感觉不太好?


    mov bx, 0
    mov cx, 8

    s: mov al 0
    add al, ds:[bx]
    add al, ss:[bx]
    mov ss:[bx], al
    inc bx
    loop s

    mov ax, 4c00h
    int 21h

code ends 


end start