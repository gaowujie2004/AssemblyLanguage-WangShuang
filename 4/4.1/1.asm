assume cs:codesgm

codesgm segment

            mov ax, 0123h
            mov bx, 0456h
            add ax, bx
            add ax, bx

            mov ax, 4c00h
            int 21h

codesgm ends


end