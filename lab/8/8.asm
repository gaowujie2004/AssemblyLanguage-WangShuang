assume cs:codesg 

codesg segment
    mov ax,4c00h 
    int 21h

    start: mov ax,0      
    s: nop 
    nop

    mov di, offset s 
    mov si, offset s2 
    mov ax, cs:[si]
    mov cs:[di], ax;  mov cs:[offset s], cs:[offset s2]

    ;若不仔细分析，就会认为一直在这里循环。
    ;标号s处的机器码，被动态修改了，s标号处的代码被修改成了 s2 标号处的代码。
    ;实际执行的是 开头处 的代码。
    s0: jmp short s 

    
    s1: mov ax,0
    int 21h
    mov ax,0 
    
    s2: jmp short s1
    nop 
codesg ends 
end start
