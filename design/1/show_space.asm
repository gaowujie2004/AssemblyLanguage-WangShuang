assume cs:codesg




codesg segment
    mov dh, 16
    mov dl, 40
    ; call show_space

    mov ax, 1
    mov dh, al
    mov ax, 4c00h
    int 21h
    ; 紧跟着 ds:si 显示指定个数个空格
    ; mov dh, 8  行
    ; mov dl, 0  列
    show_space:
            push es
            push di 
            push ax
            push cx

            ; 写入目标内存起始地址的——段地址
            mov ax, 0B800H
            mov es, ax

            
            ; 写入目标内存起始地址的——偏移地址
            mov al, 2
            mul dl
            mov di, ax

            mov al, 160
            mul dh

            add di, ax  ; R*160 + C*2结果在 AX 中，现在放入 di； R行、C列
        

            ;遍历遍历空格
            mov ah, 01000000B
            mov cx, 7
            each_str: 
                mov al, 20h   ; 空格
                mov es:[di], ax
                add di, 2
                loop each_str
            pop cx
            pop ax
            pop di
            pop es
            ret    
codesg ends 

end