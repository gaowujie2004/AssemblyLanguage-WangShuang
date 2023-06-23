assume cs:code, ds:data

data segment
    dd 100001 ; 1_86a1H，  4byte
    dw 100    ; 0064H，    2byte
    dw 0
data ends

code segment
    start: mov ax, data
    mov ds, ax
    ;mov ax, 861ah ; 低16位放入AX
    ;mov dx, 0001h ; 高16位放入DX
    mov ax, ds:[0]
    mov dx, ds:[2]
    div word ptr ds:[4] ; 被除数是32位，除数必须是16位，商放在ax，余数放在dx
    ; 商: 1000 03e8H，余数1
    
    mov ds:[6], ax

    mov ax, 4c00h
    int 21h
code ends 

end start