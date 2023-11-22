; 将 a段和b段的数据依次相加，结果放在c段

assume cs:code

a segment 
    db 1,2,3,4,5,6,7,8
a ends 

b segment 
    db 1,2,3,4,5,6,7,8
b ends 

tc segment 
    db 0,0,0,0,0,0,0,0
tc ends 


code segment
    start: mov ax, a    ; ds=a（段地址）
    mov ds, ax   
 
    mov ax, b           ; es=b（段地址）
    mov es, ax    

    mov ax, tc
    mov ss, ax          ; ss=c（段地址）感觉不太好?

    mov bx, 0
    mov cx, 8

    s: mov al, 0
    add al, ds:[bx]
    add al, es:[bx]
    mov ss:[bx], al
    inc bx
    loop s

    mov ax, 4c00h
    int 21h

code ends 

code segment
    ;ss、a内存区域的段地址
    mov ax, a
    mov ss, ax 
    ;ds、b内存区域的段地址
    mov ax, b
    mov ds, ax
    ;es目标内存区域的段地址
    mov ax, tc
    mov es,ax 

    mov cx, 7
    mov di, 0
    foreach:
        mov al, ss:[di]
        add al, ds:[di]
        mov es:[di],al
        inc di
        loop foreach
code ends 

end start