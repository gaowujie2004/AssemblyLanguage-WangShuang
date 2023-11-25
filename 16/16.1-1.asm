; 累加nums，放到sum中
assume cs:code 


;第一行机器码IP=0
code segment 
    nums: db 1,2,3,4,5,6,7,8
    sum:  db 0
    ;此时的nums、sum是标号，只能使用offset代表是偏移地址（距离code段开始的地方也就是0）

    start: 
    mov si, offset nums
    mov di, offset sum

    mov ax, 0
    mov cx, 8
    each_add:
        add al, cs:[si]
        inc si
        loop each_add
    mov cs:[di], al


    mov ax, 4c00h
    int 21h
code ends

end start