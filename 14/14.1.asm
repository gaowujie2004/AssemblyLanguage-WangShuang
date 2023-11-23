assume cs:code 


code segment 
    ; 70h CMOS-RAM 地址端口
    ; 71h CMOS-RAM 数据端口


    ; 读取CMOS-RAM的2号单元的数据
    mov al, 2
    out 70h, al
    in al ,71h

    ; 向CMOS-RAM2号单元写入1byte数据（写入0）
    mov al, 2
    out 70h, al
    mov al, 00h
    out 71h, al



     ; 读取CMOS-RAM的2号单元的数据
    mov al, 2
    out 70h, al
    in al ,71h

code ends

end