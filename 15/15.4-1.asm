; 从a-z，在屏幕中间显示（能看的清楚）
assume cs:code 

code segment 
    mov ax, 0b800h
    mov es, ax
    mov di, 160*12+40*2

    mov ah, 01000000B
    mov al, 'a'

    a_to_z:
        mov es:[di], ax

        call delay
        
        inc al
        cmp al, 'z'
        jna a_to_z ;al <= 'z'

    mov ax, 4c00h
    int 21h


    ;重要的代码。
    delay:
        push ax
        push dx

        mov dx, 0005h
        mov ax, 0
        each_sub:
            sub ax,1
            sbb dx,0
            cmp ax,0
            jne each_sub
            cmp dx,0
            jne each_sub

        pop dx
        pop ax
        ret

code ends

end