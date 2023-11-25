; 任务：累加nums，放到sum中
; 改动：将数据标号放到其他段中
assume cs:code, ds:data ; assume ds:data伪指令是必须的； assume ds:data 的作用是将data内的标号所在段和ds寄存器关联


data segment
    nums db 1,2,3,4,5,6,7,8
    sum  dw 0
data ends 


;第一行机器码IP=0
code segment 
    
    ;此时的nums、sum即是标号，也是内存单元长度（即可作为寻址索引）

    start:
    mov ax, data ;段地址
    mov ds, ax   ;必须设置，和assume ds:data有关
    mov si, 0

    mov ax, 0
    mov cx, 8
    each_add:
        add al, nums[si]  ; 编译时替换add al, ds:0[si]
        inc si
        loop each_add
    mov sum, ax           ;编译时替换成 mov ds:[8], ax， sum是单字数据，长度符号要求



    mov ax, 4c00h
    int 21h
code ends

end start