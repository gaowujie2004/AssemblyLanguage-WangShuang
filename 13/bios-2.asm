code segment
    mov ah, 2
    mov bh, 0
    mov dh, 12
    mov dl, 40
    int 10h
    
    mov ax, 4c00h
    int 21h
code ends

end

