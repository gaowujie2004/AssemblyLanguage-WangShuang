assume cs:code, ds:data


; 确定一点：应该放到 show_str 中断处理程序的代码段中
data segment
    db 'GaoWuJie @ Qinbeilei !!!', 0
data ends



code segment
    start: 
        ; 1、安装 7ch，中断例程
        ; 安装 -> 0000:0200h 处，
        mov ax, cs
        mov ds ,ax     ; 数据源 ds:si
        mov si, offset show_str

        mov ax, 0 
        mov es, ax                ; 数据目的 es:di
        mov di, 200H

        mov cx, offset show_str_end - offset show_str
        cld 
        rep movsb


        ; 2、将中断处理程序入口地址，写入中断向量表
        ;  (0*16) + (7ch * 4) =  中断处理程序的IP
        ;  (0*16) + (7ch * 4 + 2) = 中断处理程序的CS
        mov ax, 0
        mov ds, ax
        mov word ptr ds:[7ch * 4], 200h 
        mov word ptr ds:[7ch * 4 + 2], 0000h 

        ; 调用前的数据准备
        mov ax, data
        mov ds, ax
        mov si, 0
        mov dh, 12
        mov dl, 30
        mov cl, 10011000B

        ; 3、触发软中断
        int 7ch

        ; 4、退出程序回到DOS中
        mov ax, 4c00h
        int 21h

    show_str:
        push ax
        push bx
        push cx
        push dx
        push es
        push di
        push si


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
        ; 参数：dh=行号（取值范围0~24)
        ;      dl=列号（0~79）
        ;      cl=颜色
        ;      ds:si指向字符串首地址

        ok: 
            pop si
            pop di
            pop es
            pop dx
            pop cx
            pop bx
            pop ax
            iret    ; 中断例程退出

            show_str_end: 
                nop
    
code ends


end  start