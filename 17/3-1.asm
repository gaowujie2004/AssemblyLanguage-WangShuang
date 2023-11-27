;子程序：字符栈的入栈、出栈和显示。
;参数说明：  (ah)=功能号，0表示入栈，1表示出栈，2表示显示；
            ;ds:si指向字符栈空间；
            ;对于0号功能：(al)=入栈字符；
            ;对于1号功能：(al)=返回的字符；
            ;对于2号功能：(dh)、(dl)=字符串在屏幕上显示的行、列位置，从0开始。


assume cs:code 

code segment 
    charStack: jmp charStart
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
        div dh

        mov bh, 0
        mov bl, dl
        add bl, bl
        
        add bx, ax  ;160*dh + bl+bl，显存偏移结果
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
            mov bx, charTop
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