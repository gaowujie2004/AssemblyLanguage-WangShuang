;实现一个子程序setscreen，为显示输出提供以下功能：
; 1）清屏；
; 2）设置前景色；显存字符颜色的0、1、2位
; 3）设置背景色；显存字符颜色的4、5、6位
; 4）向上滚动一行。
; 参数：ah=功能号（0-3）；对于2-3，al=颜色值（0-7）

assume cs:code

SHOW_START EQU 0b800h
TOTAL_CHAR EQU 2000

code segment 
    start:

    ; call main1

    ; mov al, 3
    ; call main2

    ; mov al, 1
    ; call main3

    ; call main4

    mov ah, 4
    mov al, 1
    call setscreen

    mov ax, 4c00h
    int 21h

    ;25行80列，一共2000个字符；
    ;每个字符两字节；
    ;高位存储字符属性，低位存储字符ASCII码值

    ;1号清屏功能，不管颜色只管字符。
    main1:
        push bx
        push es
        push cx 
        
        mov bx, SHOW_START
        mov es, bx
        mov bx, 0
        mov cx, TOTAL_CHAR
        each_clear:
            mov byte ptr es:[bx], ' '
            add bx, 2
            loop each_clear

        pop cx
        pop es
        pop bx 
        ret
    
    ;2号设置前景色，只考虑字符颜色。
    ;参数：al=颜色值（0-7）
    main2:
        ;al参数校验 0-7
        cmp al, 0
        jb main2_ret      ;低于则跳转即al<0
        cmp al, 7
        ja main2_ret      ;高于则跳转即al>7

        push bx
        push cx
        push es
        
        mov bx, SHOW_START
        mov es, bx
        mov bx, 1
        mov cx, TOTAL_CHAR
        
        each_set_color:
            and byte ptr es:[bx], 11111000B ;前景色是低3位，重置掉，使用al
            or  es:[bx], al 
            add bx, 2
            loop each_set_color
        
        pop es
        pop cx
        pop bx
        main2_ret: ret
    
    ;3号设置背景色，只考虑颜色属性
    ;参数: al=颜色值（0-7）
    main3:
        ;al参数校验 0-7
        cmp al, 0
        jb main3_ret      ;低于则跳转即al<0
        cmp al, 7
        ja main3_ret      ;高于则跳转即al>7

        push ax
        push bx
        push cx
        push es
        
        mov bx, SHOW_START
        mov es, bx
        mov bx, 1

        mov cl, 4
        shl al, cl

        mov cx, TOTAL_CHAR
        
        each_set_text_color:
            and byte ptr es:[bx], 10001111B ;背景色是5、6、7位，重置掉，使用al
            or  es:[bx], al 
            add bx, 2
            loop each_set_text_color
        
        pop es
        pop cx
        pop bx
        pop ax 
        main3_ret: ret

    ;4号向上滚动一行
    main4:
        push bx
        push cx 
        push es
        push dx
        push di
        push si
        
        mov bx, SHOW_START
        mov es, bx
        mov cx, 24
            ; ds:[si] 数据源
            mov ds, bx
            mov si, 160  ;N+1行起始offset
            ; es:[di] 目标
            mov es, bx
            mov di, 0    ;N行起始offset
            cld

        set_row:
            push cx
            ;处理一行的byte数据
            mov cx, 160 
            rep movsb
            pop cx
            loop set_row

        mov cx, 80
        mov si, 0
        set_last_row:
            mov byte ptr es:[160*24 + si], 20h
            add si, 2
            loop set_last_row

        pop si
        pop di
        pop dx
        pop es
        pop cx
        pop bx
        ret

    ;聚合这些零散的函数
    ;参数：ah=功能号（0-3）、al=颜色值
    setscreen:
        ;al参数校验 0-7
        cmp al, 0
        jb setscreen_ret      ;低于则跳转即al<0
        cmp al, 7
        ja setscreen_ret      ;高于则跳转即al>7

        ;ah参数校验 0-3
        cmp ah, 0
        jb setscreen_ret
        cmp ah, 3
        ja setscreen_ret

        jmp impl
        table dw offset main1,  offset main2,  offset main3,  offset main4

    impl:
        push bx

        mov bh, 0
        mov bl, ah
        add bx, bx
        call word ptr table[bx]

        pop bx
        setscreen_ret: ret

code ends

end start