; 任务：解决除法溢出问题， 商要跟被除数位数一样多，考虑到 除数可能是1
; 子程序描述：
; 名称：div_dw
    ; 功能：进行不会溢出的除法运算，被除数为 dword 型，除数为 word 型，结果为 dword 型。
    ; 参数：ax = dword型的低16位
    ;      dx = dword型的高16位
    ;      cx = 除数，word
    ; 返回：dx = 商的高16位，ax = 商的低16位
    ;      cx = 余数
; 提示：
    ; 1）子程序内部使用的寄存器应该保存，而不影响外部
    ; 2）不能使用 movsb movsw 因为这章还没学到

; 应用举例：计算 100000/10 -> (0F4240H/0AH)

assume cs:code

code segment
    mov ax, 4240H
    mov dx, 000Fh
    mov cx, 000Ah

    ; mov dx, 0
    ; mov ax, 000Fh
    ; div cx 

    call div_dw



    mov ax, 4c00h
    int 21h


    div_dw:
        push ax            
        
        mov ax, dx         
        mov dx, 0     
        div cx              ; 执行完后, AX(商)=0x0001    DX(余数)=0x0005

        mov bx, ax          ; 将H/N结果的商先保存在bx中

       
        pop ax              ; 被除数低16位
        div cx              ; 此时（dx）=0005H，（ax）=4240H,组合成5_x4240H
        mov cx, dx          ; 返回值（cx）等于最终结果的余数

        mov dx, bx          ; 最终结果高16位值=（bx）

        ret

code ends

end

; X(32-bit) / N(16-bit) 
; int(H/N)*65536 + [ rem(H/N)*65536 + L ]/N
; int(H/N) 高16位
; [ rem(H/N)*65536 + L ]/N  商是低16位，余数是最终的余数

; div BX,  被除数：AX(L)   DX(H)       结果：AX（商）、DX（余数）
; div BL,  被除数：AX                  结果：AL（商）、AH（余数）


; mul BX , 被乘数 AX   结果：AX(L)、DX（H)
; mul BL , 被乘数 AL   结果：AX