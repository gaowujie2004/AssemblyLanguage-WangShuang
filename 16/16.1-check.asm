; 检测点16.1：累加nums，放到sum中
assume cs:code 


;第一行机器码IP=0
code segment 
    nums dw 1,2,3,4,5,6,7,8
    sum  dd 0
    ;此时的nums、sum即是标号，也是内存单元长度（即可作为寻址索引）
    ;nums看成数组名， si是偏移量。
    ;sum 看成变量、也可看成数组

    start:
    mov si, 0  ;nums数组成员偏移量

    mov ax, 0
    mov cx, 8
    each_add:
        mov ax, nums[si]
        add word ptr sum[0], ax          ;低16位相加 add cs:8[0], ax，---------- 重要这里sum默认是dword ptr，想要控制sum的单字单元需要指明
        adc word ptr sum[2], 0           ;高16位相加 add cs:8[2], ax,----------- sum默认是双字类型，但想操作它的单字节数据需要指明长度
        add si, 2
        loop each_add
    
    mov ax, 4c00h
    int 21h
code ends

end start