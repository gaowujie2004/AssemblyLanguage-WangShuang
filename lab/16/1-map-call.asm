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
    _install:
    ;es:[di]目标 0000:0200h
    mov ax, 0
    mov es, ax
    mov di, 0200h
    ;ds:[si]数据源 cs:offset int7ch
    mov ax, cs
    mov ds, ax
    mov si, offset int7ch
    ;长度
    mov cx, offset int7ch_end - offset int7ch
    ;传送开始
    cld
    rep movsb

    _set_interrupt_vector_table:
    ;M[ 7ch*4 ] <- 0200h;    中断例程入口程序地址的IP
    ;M[ 7ch*4+2 ] <- 0000h;  中断例程入口程序地址的CS
    ;7ch*4=01f0h
    mov ax, 0
    mov ds, ax
    mov word ptr ds:[1f0h], 0200h
    mov word ptr ds:[1f0h+2], 0

    start:
    mov ah, 2
    mov al, 1
    int 7ch

    mov ax, 4c00h
    int 21h

    ;25行80列，一共2000个字符；
    ;每个字符两字节；
    ;高位存储字符属性，低位存储字符ASCII码值

    
    ;聚合这些零散的函数
    ;参数：ah=功能号（0-3）、al=颜色值
    ;在中断例程中，int7ch处是开始，IP=0200、CS=0
    int7ch: 
        ;al参数校验 0-7
        cmp al, 0
        jb int7ch_ret      ;低于则跳转即al<0
        cmp al, 7
        ja int7ch_ret      ;高于则跳转即al>7

        ;ah参数校验 0-3
        cmp ah, 0
        jb int7ch_ret
        cmp ah, 3
        ja int7ch_ret

        jmp short impl
        table: dw offset main1-offset int7ch + 200h 
               dw offset main2-offset int7ch + 200h
               dw offset main3-offset int7ch + 200h 
               dw offset main4-offset int7ch + 200h
        ;---------------------------------------------------------------- 上面要注意 -------------------------------------------------
        impl:
        push bx

        TABLE_OFFSET EQU 200h+offset table-offset int7ch ;定义常量, 编译时被硬替换掉，所以相关的操作数都要在编译时已知。
        mov bh, 0
        mov bl, ah
        add bx, bx
        ; call word ptr table[bx]   ;cs:[offset table][bx] 也是错的，不能用这种方法了。
        call word ptr cs:[TABLE_OFFSET + bx]
        ;---------------------------------------------------------------- 上面要注意 -------------------------------------------------

        pop bx
        int7ch_ret: iret


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
        int7ch_end: nop
code ends

end _install