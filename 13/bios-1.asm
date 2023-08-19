code segment
    ; 修改光标位置
    mov ah, 2
    mov bh, 0
    mov dh, 12
    mov dl, 40
    int 10h

    ; 在光标处显示字符
    mov ah, 9
    mov al, 'G'
    mov bl,  10001001B
    mov bh, 0
    mov cx, 10
    int 10h

    ; 
    data: db 'GaoWuJie2004', '$'
    mov ax, cs
    mov ds, ax
    mov si, data

    
    mov ax, 4c00h
    int 21h
code ends

end

