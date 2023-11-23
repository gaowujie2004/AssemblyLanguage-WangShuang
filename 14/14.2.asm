; 用加法和逻辑位移计算 ax=ax*10
;  ax*10 = ax*2 + ax*8

assume cs:code 

code segment 
    ; ax=2
    mov ax,2


    ; 因数1
    mov bx, ax
    shl bx, 1

    ; 因数2
    mov dx, ax
    mov cl, 3
    shl dx, cl

    add bx, dx
    mov ax, bx 
code ends

end