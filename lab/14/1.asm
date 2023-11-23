;任务：编程，以 “年/月/日 时:分:秒” 的格式在屏幕中间显示当前时间

assume cs:code

data segment
    ; db '??\??\?? ??:??:??', 0
    year:  db '??\'
    month: db '??\'
    day:   db '?? '
    hour:  db '??:'
    min:   db '??:'
    sss:   db '??',0
    date_offset:  dw offset year, offset month, offset day, offset hour, offset min, offset sss
    cmos_address: db 9, 8, 7, 4, 2, 0
data ends 

code segment 
    start:
    mov ax, data
    mov ds, ax
    mov si, offset cmos_address
    mov di, offset date_offset
    ;获取时间
    ;70h CMOS-RAM的地址端口、71h CMOS-RAM的数据端口
    mov cx, 6
    each_get_time:
        mov al, ds:[si]   
        out 70h, al
        in  al, 71h ;指定单元的数据是  0000_0000 BCD格式的数字
        ;转为ASCII码值
        push cx
        mov ah, al
        mov cl, 4
        shr ah, cl                ;十位
        and al, 00001111B         ;个位
            ;转为ascc码
        add ah, 30h
        add al, 30h   

        ;放入M [M[ds:[di]]] 前两个字节
        mov bx, ds:[di]
        mov byte ptr ds:[bx],   ah   ;要重点注意 TODO
        mov byte ptr ds:[bx+1], al   ;要重点注意 TODO

        pop cx
        inc si
        add di, 2
        loop each_get_time

    mov ax, data
    mov ds, ax
    mov si, 0
    mov dh, 10
    mov dl, 32
    mov cl, 01000000B
    call show_str

    mov ax, 4c00h
    int 21h

    

    ;参数：(dh)行、(dl)列、ds:si 字符串首地址 
    show_str: 
        push ax
        push bx 
        push bp
        push di 
        push es 
        push cx
        push si

        ;根据行(dh)、列(dl)计算偏移量 -> bp
            ;160*dh；160*25=4000，使用8bit乘法不溢出
        mov al, dh
        mov ah, 160
        mul ah
        mov di, ax ;暂存160*dh
            ;2*dl；  2*80=160，使用8bit乘法不溢出
        mov al, dl
        mov ah, 2
        mul ah

        add di, ax ;di <- 160*R(dh)+2*C(dl)
        
        mov ax, 0b800h
        mov es, ax 
        mov ah, cl ;字符颜色
        mov bp, 0  ;显存位置偏移量
        each_char:
            mov al, ds:[si]

            mov ch, 0
            mov cl, al
            jcxz each_char_ok        ; cx==0,跳转标号处；否则接着向下指向 

            mov es:[di + bp], ax ;向显存写入字符
            add bp, 2
            inc si
            jmp each_char

        each_char_ok:  
        pop si
        pop cx 
        pop es 
        pop di
        pop bp
        pop bx
        pop ax
        ret
code ends

end start