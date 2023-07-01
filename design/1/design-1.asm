; 任务: 将机器数（二进制）转为十进制字符串
; 名称: dtoc
    ; 功能: 将 dword 型数据转为十进制数的字符串，字符串结尾是0
    ; 参数: ax = dword类型数据的低16位
    ;      dx = dword类型数据的高16位
    ;      ds:si = 字符串首地址
    ; 返回: 无
; 应用举例: 计算 100000/10 -> (0F4240H/0AH)

assume cs:code

data segment
    db 256 dup(0)
data ends

code segment
    start: mov ax, data
    mov ds, ax
    mov si, 0

    mov ax, 12345   ; 双字数据的低16位
    mov dx, 56789   ; 双字数据的高16位
    call dtoc

    ; 显示参数
    mov dh, 8
    mov dl, 0
    mov cl, 00000100B
    call show_str

    mov ax, 4c00h
    int 21h


    dtoc:
        push ax
        push bx
        push dx
        push es
        push di 

        mov es, dx ; 暂存 DX
        
        mov di, 0  ; 位数
        mov dx, 0  ; 被除数高16位
        mov bx, 10 ; 除数
        each_num_l16:  
            ; 取每个位的值，转为ASCII编码值
            div bx ; 商AX、余数DX
            add dx, 30H
            push dx
            mov dx, 0

            mov cx, ax
            inc cx
            inc di
            loop each_num_l16

        mov ax, es
        mov dx, 0
        each_num_h16:
            div bx
            add dx, 30H
            push dx
            mov dx, 0

            mov cx, ax
            inc cx
            inc di
            loop each_num_h16


        mov cx, di
        mov bx, 0
        reversal_enqueue:
            pop ax
            mov ds:[si + bx], al
            inc bx
            loop reversal_enqueue
        ; 字符串结尾
        mov byte ptr ds:[si+bx], 00H

        pop di
        pop es
        pop dx
        pop bx
        pop ax
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