; 累加nums，放到sum中
assume cs:code 


;第一行机器码IP=0
code segment 
    nums db 1,2,3,4,5,6,7,8
    sum  dw 0
    ;此时的nums、sum即是标号，也是内存单元长度（即可作为寻址索引）

    start:
    mov si, 0

    mov ax, 0
    mov cx, 8
    each_add:
        add al, nums[si]  ;add byte ptr al, cs:0[si] 
        inc si
        loop each_add
    mov sum, ax 


    mov ax, 4c00h
    int 21h
code ends

end start