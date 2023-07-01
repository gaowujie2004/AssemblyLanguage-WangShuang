; 任务：显示字符串，无换行
; 子程序描述：
; 名称：show_str
    ; 功能：在指定的位置，用指定的颜色，显示一个用0结束的字符，先不考虑换行。
    ; 参数：dh=行号（取值范围0~24)
    ;      dl=列号（0~79）
    ;      cl=颜色
    ;      ds:si指向字符串首地址
    ; 返回：无
; 提示：
    ; 1）子程序内部使用的寄存器应该保存，而不影响外部
    ; 2）不能使用 movsb movsw 因为这章还没学到

; 应用举例：在屏幕8行，3列，用绿色显示 data 段中的字符

assume cs:code

data segment
    db 'GaoWuJie', 0 ; 9-byte
data ends 


code segment
    start:
        mov dh, 8
        mov dl, 0
        mov cl, 00000100B

        mov ax, data
        mov ds, ax
        mov si, 0
        call show_str

        mov ax, 4c00h
        int 21h


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
            inc cx   ; loop会cx--
            
            jcxz ok

            mov es:[di], ax

            inc si
            add di, 2
            loop each_str
        ok:
            pop cx
            pop ax
            pop di
            pop es
            ret
code ends

end start


; 第一行：B800:00 ~ B800:9F（80个字符占160-byte）
; 第二行：B800:A0 ~ B800:13F
; .........
; 第N行：160*(N-1) ~ 160*(N-1) + 159   N从1开始，若是从0开始，则不需要-1
; 第25行：B800:f00 ~ B800:f9f


;第R行，第C列，对应的地址=160*R + 2*C