code segment

    ; 修改光标位置
    mov ah, 2
    mov bh, 0
    mov dh, 22
    mov dl, 40
    int 10h

    jmp go
    ; 在光标位置显示字符串
    data: db 'GaoJie2004HHHHHGaoJie2004HHHHHGaoJie2004HHHHHGaoJie2004HHHHHGaoJie2004HHHHH'
          db 'GaoJie2004HHHHHGaoJie2004HHHHHGaoJie2004HHHHHGaoJie2004HHHHHGaoJie2004HHHHH'
          db 'GaoJie2004HHHHHGaoJie2004HHHHHGaoJie2004HHHHHGaoJie2004HHHHHGaoJie2004HHHHH'
          db 'GaoJie2004HHHHHGaoJie2004HHHHHGaoJie2004HHHHHGaoJie2004HHHHHGaoJie2004HHHHH'
          db 'GaoJie2004HHHHHGaoJie2004HHHHHGaoJie2004HHHHHGaoJie2004HHHHHGaoJie2004HHHHH'
          db 'GaoJie2004HHHHHGaoJie2004HHHHHGaoJie2004HHHHHGaoJie2004HHHHHGaoJie2004HHHHH'
          db 'GaoJie2004HHHHHGaoJie2004HHHHHGaoJie2004HHHHHGaoJie2004HHHHHGaoJie2004HHHHH'
          db 'GaoJie2004HHHHHGaoJie2004HHHHHGaoJie2004HHHHHGaoJie2004HHHHHGaoJie2004HHHHH'
          db 'GaoJie2004HHHHHGaoJie2004HHHHHGaoJie2004HHHHHGaoJie2004HHHHHGaoJie2004HHHHH', '$'
    go: mov ax, cs
    mov ds, ax
    mov dx, data
    mov ah, 9
    int 21h

    
    mov ax, 4c00h
    int 21h
code ends

end

