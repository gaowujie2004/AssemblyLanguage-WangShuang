; 任务: 将字型数字数据转为十六进制字符显示
; 名称: htoc
    ; 功能: 将 word 型数据转为十六进制的字符串，字符串结尾是0
    ; 参数: ax = word型数据
    ;      ds:si = 字符串首地址
    ; 返回: 无
; 应用举例: 计算 100000/10 -> (0F4240H/0AH)

assume cs:code

; 存放数字转为字符串的ascii码
data segment
    db 256 dup(0)
data ends

code segment
    start: mov ax, data
    mov ds, ax
    mov si, 0

    mov ax, 01fach
    mov dh, 8
    mov dl, 0
    mov cl, 00000100B

    call htoc
    call show_str

    mov ax, 4c00h
    int 21h


    htoc:
        push bx
        push cx 
        push dx
        push ax
        push di

        mov di, 0    ; 统计位个数
        mov dx, 00H  ; 被除数高位
        mov bx, 16
        each_num:
            div bx; AX商、DX余数

            ; 处理余数，即个位、百位、.....
            ; if dx>=0 && dx<=9, add dx, 30h;  else add dx, 87
            cmp dx, 10
            ; 小于则跳转
            jb jb10
            add dx, 87 ; dx > 9; 变为ascii码，超过9了
            jmp jb10_else
            jb10: add dx, 30h   ; dx <= 9 ; 变为ascii码
            jb10_else: push dx 

            mov cx, ax
            inc cx ; loop指令会-1，所以需要再+1
            inc di
            mov dx, 00H 
            loop each_num

        mov bx, 0
        mov cx, di
        each_en:
            pop ax
            mov ds:[si][bx], al ;mov ds:[si+bx], al
            inc bx
            loop each_en
        ; 字符串结尾0
        mov byte ptr ds:[si + bx], 0

        pop di
        pop ax
        pop dx
        pop cx
        pop bx
        ret
    
    show_str:
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

        add di, ax  ; R*160 + C*2结果在 AX 中，现在放入 di
    

       ; 遍历字符串
        mov ah, cl  ; 颜色
        mov ch, 0
        each_str: 
            mov al, ds:[si]   ; 当前字符
            mov cl, al
            inc cx   ; loop会cx--
            
            jcxz ok

            mov es:[di], ax

            inc si
            add di, 2
            loop each_str
        ok:
            pop cx
            pop ax
            pop di
            pop es
            ret

code ends

end start


; 十进制数：45678
;  45678 / 10 = 4567 ... 8
;  4567  / 10 = 456  ... 7
;  456   / 10 = 45   ... 6
;  45    / 10 = 4    ... 5
;  4     / 10 = 0    ... 4


; div BX,  被除数：AX(L)   DX(H)       结果：AX（商）、DX（余数）
; div BL,  被除数：AX                  结果：AL（商）、AH（余数）