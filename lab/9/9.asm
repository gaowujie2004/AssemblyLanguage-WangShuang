assume ds:data, cs:code

stack segment
    dw 0
    ; 当前段实际占16byte
stack ends

data segment
    db 'welcome to masm!'
    ; 16byte
    ; 低8位，ASCII 值
    ; 高8位，颜色属性。
    ; 7     6 5 4    3    2 1 0
    ; BL    R G B    I    R G B
    ; 闪烁   背景    高亮    文字

    ; 绿色：     0 000 0 010
    ; 绿底红色：  0 010 0 100
    ; 白底蓝色：  0 111 0 001
data ends

code segment
            ;数据段
    start:  mov ax, data
            mov ds, ax
            ;栈段
            mov ax, stack
            mov ss, ax
            mov sp, 10h
            ;80x25彩色字符模式显示缓冲区段地址
            mov ax, 0B800h
            mov es, ax


            ;字符循环开始——绿色
            mov bx, 6e0h
            mov cx, 16
            mov si, 0
            mov di, 0
            eachStr0:   mov al, ds:[si]    ;字符ASCII值
                        mov ah, 00000010B  ;字符颜色 
                        mov es:[bx+64+di], ax
                        ; es:[bx+64+si]
                        inc si
                        add di, 2
                        loop eachStr0
            ;字符循环结束

            ;字符循环开始——绿底红色
            mov bx, 780h
            mov cx, 16
            mov si, 0
            mov di, 0
            eachStr1:   mov al, ds:[si]    ;字符ASCII值
                        mov ah, 00100100B  ;字符颜色 
                        mov es:[bx+64+di], ax
                        inc si
                        add di, 2
                        loop eachStr1
            ;字符循环结束

            ;字符循环开始——白底蓝色
            mov bx, 820h
            mov cx, 16
            mov si, 0
            mov di, 0
            eachStr2:   mov al, ds:[si]    ;字符ASCII值
                        mov ah, 01110001B  ;字符颜色 
                        mov es:[bx+64+di], ax
                        inc si
                        add di, 2
                        loop eachStr2
            ;字符循环结束
            

            mov ax,4c00h 
            int 21h
code ends

end start