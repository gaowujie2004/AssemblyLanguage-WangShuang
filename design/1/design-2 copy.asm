assume cs:codesg


data segment
    db '1975','1976','1977','1978', '1979','1980','1981','1982' ; ds:00h
    db '1983','1984','1985','1986', '1987','1988','1989','1990' ; ds:20h
    db '1991','1992','1993','1994', '1995'                      ; ds:40h
    ; 年份 —— 以上是表示21年的21个字符串，每个字符串4byte

    dd 16,22,382,1356
    dd 2390,8000,16000,24486
    dd 3365,3465,3865,7514 
    dd 9800,9900,9950,10000
    dd 20000,30000,40000,50000
    dd 60000 
    ; 年公司收入 —— 以上是表示21年公司总收入的21个dword型数据（4byte）

    dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226 
    dw 11542, 14430, 15257, 17800
    ; 年员工数 —— 以上是表示21年公司雇员人数的21个word型数据（2byte）
data ends 

table segment
    db 21 dup ('year',0, 'summ',0,  'ne',0, '??',0) ; 年-收入-员工数-人均收入
    ; 21个16byte数据空间
table ends

codesg segment
    ; ds，源数据段地址
    start: mov ax, data
    mov ds, ax
    ; es，目标数据段地址
    mov ax, table
    mov es, ax 

    ;年字段——00h、年收入——05h、员工人数——0Ah、人均工资收入——0Dh

    ; 源数据
    ; ds:00h —— 年份数组开头
    ; ds:54h —— 收入数组开头
    ; ds:a8h —— 员工人数数组开头
    mov cx, 21
    mov bx, 0
    mov bp, 0
    mov di, 0
    fori: 
        ; 年字段——低16位
        mov ax, ds:[0 + bx]
        mov es:[di].00h, ax 
        ; 年字段——高16位
        mov ax, ds:[0 + bx + 2]
        mov es:[di].02h, ax

        ; 年收入字段——低16位
        mov ax, ds:[54h + bx]
        mov es:[di].05h, ax
        ; 年收入字段——高16位
        mov ax, ds:[54h + bx + 2h]
        mov es:[di].07h, ax 

        ; 员工数量字段
        mov ax, ds:[0a8h + bp]         ; ds:0a8h[bp]
        mov es:[di].0ah, ax

        ; 计算人均收入，年收入(32bit)【AX低16位、DX高16位】 / 员工人数(16bit)  -》 商【AX】- 余数【DX】
        mov ax, ds:[54h + bx]
        mov dx, ds:[54h + bx + 2h]
        div word ptr ds:[0a8h + bp]

        ; 员工人均收入
        mov es:[di + 0dh], ax 


        add bx, 04h
        add bp, 02h   ; 员工数量偏移
        add di, 10h
    loop fori

    call show_table
    

    mov ax, 4c00h
    int 21h

    
    ; 将双字数字转为字符串，字符串首地址在 ds:si
    ; mov ax, 12345   ; 双字数据的低16位
    ; mov dx, 56789   ; 双字数据的高16位
    ; call dtoc

    ; 显示字符串，字符串首地址在 ds:si
    ; mov dh, 8 行
    ; mov dl, 0 列
    ; mov cl, 00000100B
    ; call show_str
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
            
            jcxz ok

            mov es:[di], ax

            inc si
            add di, 2
            jmp each_str
        ok:
            pop cx
            pop ax
            pop di
            pop es
            ret    

    show_table:
        push ax
        push bx
        push ds
        push dx
        push di
        push si

        mov cx, 21
        mov ax, es
        mov ds, ax
        mov bx, 0   ;偏移量
        mov di, 0   ;第几行
        mov si, 0
        for_table_record:
            ;field: 年份
            push cx 
            mov si, bx
            mov ax, di
            mov dh, al
            mov dl, 05h
            mov cl, 01000111B
            call show_str
                ;8个空格
                ; call show_space

            ; ; field：年收:入
            ; mov ax, bx
            ; add ax, 13 
            ; mov si, ax
            ; mov ax, di
            ; mov dh, al
            ; mov dl, 13+4
            ; call show_str
            ;     ;8个空格
            ;     call show_space


            ; ; field：员工
            ; mov ax, bx
            ; add ax, 26
            ; mov si, ax
            ; mov ax, di
            ; mov dh, al
            ; mov dl, 26+4
            ; call show_str
            ;     ;8个空格
            ;     call show_space


            ; ; field：人均收入
            ; mov ax, bx
            ; add ax, 34
            ; mov si, ax
            ; mov ax, di
            ; mov dh, al
            ; mov dl, 34+4
            ; call show_str
            ;     ;8个空格
            ;     call show_space



            add bx, 10h
            inc di
            pop cx
            loop for_table_record

        pop si
        pop di
        pop dx
        pop ds
        pop bx
        pop ax
        ret






        ; 紧跟着 ds:si 显示指定个数个空格
        ; mov dh, 8  行
        ; mov dl, 0  列
        show_space:
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

            add di, ax  ; R*160 + C*2结果在 AX 中，现在放入 di； R行、C列
        

            ;遍历遍历空格
            mov ah, 01000000B
            mov cx, 7
            each_str22: 
                mov al, 20h   ; 空格
                mov es:[di], ax
                add di, 2
                loop each_str22
            pop cx
            pop ax
            pop di
            pop es
            ret    

codesg ends 

end start

; mul 8bitREG   因数1：AL、因数2：8bit寄存器、结果：AX
; mul 16bitREG  因数1：AX、因数2：16bit寄存器、结果：DX（H)、AX（L）