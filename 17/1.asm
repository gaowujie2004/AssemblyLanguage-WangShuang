; 功能：按下一个键时，显示它。
assume cs:code 

code segment 
    

    mov ah, 0
    int 16h

    mov bx, ax

    mov ax, 0B800h
    mov es, ax
    mov ah, 01000000B
    mov al, bl
    mov es:[160*12+80], ax

    mov ax, 4c00h
    int 21h


code ends

end