
assume cs:code

stack segment
    db 32 dup(5)
stack ends

code segment 
    start:  mov ax, stack
            mov ss, ax
            mov sp, 0020H
            
            mov al, 01111111B
            add al, 1
            pushf
code ends

end start