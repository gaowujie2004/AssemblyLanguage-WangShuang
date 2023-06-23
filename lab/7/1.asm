assume cs:codesg


data segment
    db '1975','1976','1977','1978', '1979','1980','1981','1982' ; ds:00h
    db '1983','1984','1985','1986', '1987','1988','1989','1990' ; ds:20h
    db '1991','1992','1993','1994', '1995'                      ; ds:40h
    ; 年份 —— 以上是表示21年的21个字符串

    dd 16,22,382,1356
    dd 2390,8000,16000,24486
    dd 50065,97479,140417,197514 
    dd 345980,590827,803530,1183000
    dd 1843000,275900,375300,464900
    dd 593700 
    ; 年公司收入 —— 以上是表示21年公司总收入的21个dword型数据

    dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226 
    dw 11542, 14430, 15257, 17800
    ; 年员工数 —— 以上是表示21年公司雇员人数的21个word型数据
data ends 

table segment
    db 21 dup ('year summ ne ?? ') ; 年-收入-员工数-人均收入
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

    mov ax, 4c00h
    int 21h
codesg ends 

end start