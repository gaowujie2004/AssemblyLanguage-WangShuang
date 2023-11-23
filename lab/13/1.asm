;编写并安装 int 7ch 中断例程，功能为显示一个用0结束的字符串，中断例程安装在0:200处。
;参数：dh=行号、dl=列号、cl=颜色，ds:si 指向字符串首地址
assume cs:code

data segment
    db 'GWJ@QBL', 0
data ends

stack segment
    db 80 dup(0)  ; 5x16=80
stack ends

code segment 
    _install: ;将do7ch中断例程安装到0000:0200h处。
        ;es:[di] <- ds:[si]

        ;es:[di]
        mov ax, 0
        mov es, ax
        mov di, 0200h
        ;ds:[si]
        mov ax, cs
        mov ds, ax
        mov si, offset do7ch ;隐藏含义：从do7ch到_install的长度
        ;循环次数
        mov cx, offset do7ch_end - offset do7ch
        ;开始传输
        cld
        rep movsb
    _set_table: ;设置中断向量表，将7ch中断例程的入口地址写入中断向量表
        ;M[7ch*4] <- 中断例程入口程序的偏移地址(ip=200h)；  M[7ch*4+2] <- 中断例程入口程序地址的段地址（cs=0）
        ;7ch*4 = 01f0h
        mov ax, 0
        mov ds,ax
        mov word ptr ds:[1f0h], 0200h   ;低2字节是目标的ip
        mov word ptr ds:[1f2h], 0000h   ;高2字节是目标的cs
    _main:
        ;栈段
        mov ax, stack 
        mov ss, ax
        mov sp, 80
        ;字符串数据段
        mov ax, data
        mov es, ax
        ;传入参数
        mov ds, ax
        mov si, 0
        mov dh, 10
        mov dl, 40
        mov cl, 01000000B
        int 7ch
        ; 返回到操作系统
        mov ax, 4c00h
        int 21h
    ;参数：dh=行号、dl=列号、cl=颜色，ds:si 指向字符串首地址
    ;做了什么？ 将字符串送入显卡内存区域，字符串遇到0则结束。最重要的显存区域的偏移
    do7ch: 
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
        iret
        do7ch_end: nop
code ends

end _install


; 0B800:0000 开始。  25*80个字符，一个字符两字节。
; B800 + 160*R + 2*C;  一个字符两个字节
; 2byte中，高字节存储字符颜色、低字节存储ASCII码

; mul [寄存器][地址]
; mul 8bit；        因数1：AL、因数2：8bit、 积：AX
; mul 16bit；       因数1：AX、因数2：16bit、积：DX(H) AX(L)