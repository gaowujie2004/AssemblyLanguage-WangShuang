assume cs:code 


; s1.. s4是数组、s、row也是数组，需要偏移量
code segment
    s1:   db 'Good,better,best,','$'
    s2:   db 'Never let it rest,','$'
    s3:   db 'Till good is better,','$'
    s4:   db 'And better,best.','$'
    s :   dw offset s1, offset s2, offset s3, offset s4
    row:  db 2,4,6,8

    start: mov ax, cs
    mov ds, ax
    ; 数组偏移量
    mov bx, offset s
    mov si, offset row

    mov cx, 4
    ok: 
        mov bh, 0        ;页数
        mov dh, ds:[si]  ;行
        mov dl, 0        ;列
        mov ah, 2        ;功能，设置光标
        int 10h          ;执行功能

        mov dx, ds:[bx]  ;ds:dx 字符串首地址
        mov ah, 9        ;功能：在光标处显示字符串，以$结尾。
        int 21h

        add bx, 2
        inc si
        loop ok
    
    mov ax, 4c00h
    int 21h

code ends 

end start