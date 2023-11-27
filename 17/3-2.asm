; 功能：程序能够输入字符，并且字符能够显示，按退格键是删除字符，按Enter则程序结束

;子程序：字符栈的入栈、出栈和显示。
;参数说明：  (ah)=功能号，0表示入栈，1表示出栈，2表示显示；
            ;ds:si指向字符栈空间；
            ;对于0号功能：(al)=入栈字符；
            ;对于1号功能：(al)=返回的字符；
            ;对于2号功能：(dh)、(dl)=字符串在屏幕上显示的行、列位置，从0开始。


assume cs:code 

code segment
    start: 
        mov ah, 0  ;功能号
        int 16h    ;从键盘缓冲区获取按键，并放入al
        cmp al, 20h
        jb nochar    ;ASCII码小于20h是非字符键
        ;是字符键
        mov ah, 0
        call charStack ;字符入栈
        mov dl, 0
        mov dh, 0
        mov ah, 2
        call charStack ;字符显示 
        ;继续等待输入
        jmp start      

    nochar:
        cmp ah, 0Eh   ;backspace扫描码
        je backspace  ;等于则跳转
        cmp ah, 1Ch   ;Enter扫描码
        je enter
        ;都不是
        jmp start     ;继续等待输入

    
    backspace:  
        mov ah, 1       ;字符弹栈
        call charStack  
        mov dl, 0
        mov dh, 0
        mov ah, 2       ;显示字符
        call charStack  
        jmp start       ;继续等待输入
    enter:
        mov ah, 0       ;字符入栈
        mov al, 0
        call charStack
        mov dl, 0
        mov dh, 0
        mov ah, 2       ;显示字符
        call charStack

    exit:
        mov ax, 4c00h
        int 21h

    charStack: 
        jmp charStart
        table    dw pushChar, popChar, showChars
        charTop  dw 0               ;该位置存储偏移量。存储单元地址cs:[offset charTop], 数据长度是1个字单元

        charStart: 
        push bx
        push es
        push ax 
        push di

        ;ah功能号验证
        cmp ah, 0
        jb sret    ;小于则跳转
        cmp ah, 2
        ja sret    ;大于则跳转

        ; 执行具体的子功能 ah=功能号，功能号*2=table的索引
        mov bh, 0
        mov bl, ah
        add bx, bx
        jmp word ptr table[bx]
        
        pushChar:
            mov bx, charTop
            mov ds:[si+bx], al 
            inc charTop
            jmp sret
        popChar:
            cmp charTop, 0
            je sret         ;等于则跳转
            dec charTop
            mov bx, charTop
            mov al, ds:[si+bx]
            jmp sret
        showChars:
            mov bx, 0B800h
            mov es, bx 

            ;计算显存内存偏移量
            mov al, 160
            mul dh

            mov bh, 0
            mov bl, dl
            add bx, bx
            
            add bx, ax  ;160*dh + dl+dl，显存偏移结果
            mov di, bx
            ;di作为显示内存的偏移量
            ;es:[di],     <-      ds:[bx]   bx、di+=2
            
            ;bx字符偏移量，和M[charTop]对比，若相等则说明完成了。
            mov bx, 0
            each_show:
                cmp charTop, bx
                jne hasChar
                mov byte ptr es:[di], ' '
                jmp sret

                hasChar:
                mov al, ds:[si][bx]   ;ds:[si][bx]字符
                mov es:[di], al

                inc bx
                add di, 2
                jmp each_show

        sret: 
        pop di
        pop ax
        pop es
        pop bx
        ret

code ends

end


; mul 8-bitREG,  因数1：al、因数2：8-bitREG、积：AX
; dh*160 + dl+dl