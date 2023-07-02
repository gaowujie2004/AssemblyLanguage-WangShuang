assume cs:code

; 任务1：将 1122h, 3344h, 5566h, 7788h,    99aah, 0bbcch, 0ddffh, 0ff00h  这些数据相加放入 ax 寄存器
; 任务2：在代码段中使用数据
; 提示：把这些数据放在地址连续的内存单元中，然后使用bx做索引

code segment
    mov cx, s2 - offset s0   ; (cx)=6   
    s0: mov ax, 44h
    s1: mov bx, 55h
    s2: nop
code ends

end 