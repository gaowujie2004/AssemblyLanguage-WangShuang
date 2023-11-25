;任务：编写子程序，以十六进制的形式在屏幕中间显示给定的字节型数据
;参数al=字节型数据
assume cs:code


code segment 
    start:
    mov al, 01fh
    call show_num_16
    
    mov ax, 4c00h
    int 21h


    ;以十六进制在屏幕中间显示给定的字节型数据
    ;参数: al=字节数据
    show_num_16:
        jmp impl

        table db '0123456789ABCDEF'

    impl:
        push ax
        push es
        push cx
        push bx  

       
        
        mov ah, al
        ;ah、al是偏移量索引
        mov cl, 4
        shr ah, cl
        and al, 00001111B
        
        ;8086CPU ah、al不能作为索引寄存器。bx、bp、si、di才可作为索引寄存器
        mov bl, ah
        mov bh, 0
        mov ah, table[bx]

        mov bx, 0b800h
        mov es, bx 
        mov es:[160*12+40*2], ah     ;低地址，显示高位数字
        mov es:[160*12+40*2+1], 01000000B     ;低地址，显示高位数字

        
        mov bl, al
        mov bh, 0
        mov al, table[bx]
        mov es:[160*12+40*2+2], al
        mov es:[160*12+40*2+3], 01000000B     ;低地址，显示高位数字

         
        pop bx 
        pop cx
        pop es
        pop ax
        ret

code ends

end start