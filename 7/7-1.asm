; 任务1：将数据段第一个字符串转为大写；第二个字符串转为小写

;| 字符 | ASCII码 | 二进制（小写）   | 十六进制（小写）    | 二进制（大写）    | 十六进制（大写） |
;|------|--------|----------------|------------------|----------------|----------------|
;| a    | 97     | 01100001       | 0x61             | 01000001       | 0x41           |
;| b    | 98     | 01100010       | 0x62             | 01000010       | 0x42           |
;| c    | 99     | 01100011       | 0x63             | 01000011       | 0x43           |


assume cs:code, ds:data

data segment
    db 'GaoWuJie'  ; 8byte
    db 'QinBeiLei' ; 9byte
data ends

code segment
    start: mov ax, data
    mov ds, ax 

    ; 转换第一个字符串：to 大写
    mov bx, 0
    mov cx, 8
    toBig: mov al, ds:[bx]
    and al, 11011111B
    mov ds:[bx], al
    int bx
    loop toBig

    ; 转换第二个字符串：to 小写，第6位bit变为1，其余位不变
    int bx
    mov cx, 9
    toX: mov al, ds:[bx]
    or al, 00100000B
    mov ds:[bx], al
    int bx 
    loop toX 

    mov ax, 4c00h
    int 21h
code ends 

end start