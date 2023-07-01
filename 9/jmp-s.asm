assume cs:code

code segment 
    start: jmp start
    jmp short start
    jmp near ptr start
    jmp far ptr start
code ends

end start