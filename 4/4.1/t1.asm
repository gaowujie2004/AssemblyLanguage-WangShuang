assume cs:codesg 
codesg segment
           mov ax, 0
           mov ds, ax
           mov ds:[26h], ax

           mov ax,4c00H
           int 21H
           
codesg ends

end