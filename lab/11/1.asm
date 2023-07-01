; 名称: letterc
; 功能: 将以 0 结尾的字符串中的小写字母转为大写字母
; 参数：ds:si 指向首字符串
; 提示：字符串中可能有其他非字母字符


assume cs:code

data segment
    db 'GaoWuJie @ QinBeiLei !!!', 0
data ends

code segment 
    start:
        mov ax, data
        mov ds, ax
        mov si, 0
        
    letterc:
        push bx
        push ax
        mov ah, 0


        mov bx, 0
        each_str:
            mov al, ds:[si + bx]
            ; if (al>=
            cmp al, 0
            je ok

            cmp al, 'a'
            jb next         ; al < 'a'

            cmp al, 'z'
            ja next         ; al > 'z'
        transform:
            and al, 11011111B
            mov ds:[si + bx], al
        next: 
            inc bx
            jmp short each_str
        ok:
            pop ax
            pop bx
            ret
code ends

end start


; df=0, si、di ++
; cld ，set df=0