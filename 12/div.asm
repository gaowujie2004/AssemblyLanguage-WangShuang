assume cs:code

code segment
    mov ax, 1000H
    mov bh, 1     ; 被除数（16-bit）/ 除数（8-bit）= 商（AL）、余数（AH）
    div bh        ; 内中断——0号中断
code ends

end 