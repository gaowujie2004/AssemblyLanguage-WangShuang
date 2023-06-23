assume cs:code

code segment 
    start: mov ax, 0
    jmp short s
    and ax, 10
    s: inc ax
code ends

end start