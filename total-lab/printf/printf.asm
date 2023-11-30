assume cs:code, ds:data, ss:stack


data segment
    in_str  db 'GaoWuJie=, age=', 0
    out_str db 256 dup(0ffh)
data ends



stack segment
    db 512 dup(0ffh)
stack ends

code segment
    init:
        mov ax, data
        mov ds, ax
        mov ax, stack
        mov ss, ax
        mov sp, 512
    start:
        ; printf(offset inStr, 'Q', 24);
        mov ax, 24
        push ax

        mov ax, 'Q'   ; 为什么不用al？因为push指令已经隐含了数据长度是2byte
        push ax

        lea ax, in_str
        push ax

        call _printf

        pop ax
        pop ax
        pop ax

        mov ax, 4c00h
        int 21h
    _printf:
        push bp
        mov bp, sp
        sub sp, 0eh ; 不能让sp覆盖了局部变量，分配了10byte的局部内存。

        ;确定参数个数
            ;word ptr [bp-0ah]  char* str 字符串偏移地址
            mov ax, [bp+04h] 
            mov [bp-0ah], ax 

            ;word ptr [bp-08h]   存放参数个数
            mov word ptr [bp-08h], 0 
            ;word ptr [bp-06h]   存放out_str的偏移字节数
            mov word ptr [bp-06h], 0

            
            mov si, 0                    ;in_str字符内存偏移字节数
            mov word ptr [bp-08h], 0     ;参数个数
            mov word ptr [bp-06h], 0     ;out_str偏移字节数
            each:
                mov ch, ss:[bp-0ah][si] ;currentChar
                cmp ch,  0           ;字符串是否循环完毕
                je each_end 

                cmp ch, '%'
                jne each_continue                 ;不等于则跳转
                ;判断下一个字符
                mov ch, ss:[bp-0ah][si+1]
                cmp ch, 'd'
                jne is_eq_c
                char_eq_d: ;out_str 将printf第n个参数写入到out_str字符区域.
                    mov di, [bp-08h];  参数个数
                    add di, di
                    mov ax, ss:[bp+06h][di] ;定位到不定形参的第n个参数的值 （从0开始）
                    ;-------- AX 目前是形参的值，从左往右

                    push cx
                    mov cx, 0
                    get_num:
                        div 10
                        push ah  ;余数  ----- TODO 要尽快pop
                        mov ah, 0
                        inc cx
                        cmp al, 0
                        jne get_num      ;不等于则跳转
                    ;栈中保存的就是各个位的值，栈顶是最高位。

                    pop_num:
                        ;放到out_str内存中
                        mov di, [bp-06h]     ;out_str偏移字节数
                        pop ax
                        add ax, 30h
                        mov out_str[di], ax     
                        inc word ptr [bp-06h]
                        loop pop_num  
                    pop cx
                    

                    inc word ptr [bp-08h]     ;参数个数
                    jmp each_next

                is_eq_c: cmp ch, 'c'
                jne each_continue
                char_eq_c:
                    inc word ptr [bp-08h]
                    jmp each_next
                
                each_continue:
                    mov di, [bp-06h]        ;out_str偏移字节数  TODO
                    mov ax, ss:[bp-0ah][si]
                    mov out_str[di],  ax
                    inc word ptr [bp-06h]   ;out_str偏移字节数  TODO
                each_next:
                    inc si                  ;in_str 偏移字节数
                    jmp short each
            
            each_end:
                






        


code ends

end init 