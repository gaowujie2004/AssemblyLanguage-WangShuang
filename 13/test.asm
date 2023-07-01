
assume cs:code

data segment
    db 'GaoWuJie @ Qinbeilei !!!', '$'
data ends

code segment 
    start:
        ; mov ah, 2   ; 10号中断程序的2号子程序
        ; mov bh, 0   ; 页
        ; mov dh, 5   ; 行号
        ; mov dl, 12  ; 列号
        ; int 10h


        ; mov ax, 4c00h
        ; int 21

        ; mov ah, 2
        ; mov bh, 0
        ; mov dh, 5
        ; mov dl, 12
        ; int 10h

        mov ax, data
        mov ds, ax
        mov dx, 0
        mov ah, 9
        int 21h

        mov ax, 4c00h
        int 21        
code ends

end start