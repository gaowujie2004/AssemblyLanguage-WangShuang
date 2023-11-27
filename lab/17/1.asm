; 安装一个新的7ch中断例程，实现通过逻辑扇区号对软盘进行读写。
; 参数说明:
; 1）ax=功能号，0=读、1=写
; 2）dx=逻辑扇区号
; 3）es:bx指向读出数据或者写入数据的内存区

; 逻辑扇区号与物理编号是有公示可以求的。


assume cs:code

SHOW_START EQU 0b800h
TOTAL_CHAR EQU 2000

code segment 
    _install: ;中断例程指令放入0:0200h处
        ;es:[di] 目标
        mov ax, 0
        mov es, ax
        mov di, 0200h
        ;ds[si] 源
        mov ax, cs
        mov ds, ax
        mov si, offset int7ch
        ;长度
        mov cx, offset int7ch_end - offset int7ch
        ;串传输start
        cld
        rep movsb

    _set_interrupt_vector_table: ;将7ch中断例程的CS:IP值写入中断向量表
        ; M[7ch*4]   <- 中断例程入口地址的IP   (0:1f0)
        ; M[7ch*4+2] <- 中断例程入口地址的CS   (0:1f0+2)
        ; 7ch*4=0x1f0
        mov ax, 0
        mov ds, ax
        mov ds:[1f0h], 0200h
        mov ds:[1f0h+2h], 0h

    _test:
        


        mov ax, 4c00h
        int 21h

    int7ch: ;使用逻辑扇区号对物理磁盘进行读写操作
        iret

    
    
        int7ch_end: nop




code ends


end _install



; 面号=int(逻辑扇区号/1440)
; 磁道号=int( rem(逻辑扇区号/1440)/18 )
; 扇区号=rem(rem(逻辑扇区号/1440)/18)+1

; div 8-bit
; 1）被除数：AX
; 2）除数：8bitREG|address
; 3）结果：AL=商、AH=余数

; div 16-bit
; 1）被除数：DX（H）、AX（L）
; 2) 除数:  16-bit
; 3）结果：  AX=商、DX=余数