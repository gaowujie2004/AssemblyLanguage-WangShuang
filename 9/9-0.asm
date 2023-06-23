; offset 伪指令

assume cs:code

code segment 
    s1:  mov ax, offset s1
    s2:  mov ax, offset s2
    
code ends

end