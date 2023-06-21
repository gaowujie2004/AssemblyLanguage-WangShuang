assume cs:code, ss:stack, ds:data 

data segment
    dw 0567h, 0890h
data ends 

stack segment
    dw 5555,5555
stack ends

code segment
    start: mov ax, stack
    mov ss, ax
    mov sp, 0010h
    
    mov ax, data
    mov ds, ax

    push ds:[0]
    push ds:[2]
    pop  ds:[2]
    pop  ds:[0]

    mov ax, 4c00h
    int 21h
code ends 


end start