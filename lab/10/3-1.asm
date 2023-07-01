; 任务: 将机器数（二进制）转为十进制字符串
; 名称: dtoc
    ; 功能: 将 word 型数据转为十进制数的字符串，字符串结尾是0
    ; 参数: ax = word型数据
    ;      ds:si = 字符串首地址
    ; 返回: 无
; 应用举例: 计算 100000/10 -> (0F4240H/0AH)

assume cs:code

data segment
    db 256 dup(0)
data ends

code segment
    mov ax, data
    mov ds, ax
    mov si, 0

    mov ax, 12345

    call dtoc

    mov ax, 4c00h
    int 21h


    dtoc:
        push bx
        push cx 


        mov ch, 00H
        mov bl, 10
        each_num:
            div bl; AH余数、AL商
            mov bh, ah
            mov ah, 00H

            ; 处理除数，即个位、百位、.....
            add ah, 30h
            push ah

            mov cl, al
            jcxz ok 
            inc cl
            loop each_num
        ok: 
            


code ends

end


; 十进制数：45678
;  45678 / 10 = 4567 ... 8
;  4567  / 10 = 456  ... 7
;  456   / 10 = 45   ... 6
;  45    / 10 = 4    ... 5
;  4     / 10 = 0    ... 4
