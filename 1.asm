assume cs:code

; 任务1：将 1122h, 3344h, 5566h, 7788h,    99aah, 0bbcch, 0ddffh, 0ff00h  这些数据相加放入 ax 寄存器
; 任务2：在代码段中使用数据
; 提示：把这些数据放在地址连续的内存单元中，然后使用bx做索引

code segment
    dw  0000, 0011h, 0022h, 0033h,    1100h, 2200h, 3300h, 4400h    
    ; 当程序被加载入内存时，上面的16byte数据将会放在哪里呢？ 由于在代码段中程序的开头，但其数据的内存单元地址不能作为CS：IP指向的内容，因为上面的是数据，不是指令（操作）
    
    ; 从这里开始才是指令
    ; 从DS+10h，是程序开头的地址，但CS:IP~CS:(IP+16)是dw定义的数据区域，从CS:(ip+10h)才是程序的第一条指令的内存区域
    ; start: 指明了 编译、链接后的可执行文件中，描述程序第一条指令的地址，即告诉 IP 下面的地址处，才是程序的第一条指令所在地址。
    start: mov ax, 0h ;ax指明了长度
    mov bx, 0h



    mov cx, 8    
    forsum: add ax, cs:[bx]
    add bx, 2
    loop forsum

    mov ax, 4c00h
    int 21h
code ends

end start