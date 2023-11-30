; 验证：在16位实模式下，lea 获取的是段内偏移地址


assume cs:code, ds:data, ss:stack


data segment
    cursor   db  0f1h, 0f2h, 0f3h, 0f4h
    outStr   db  1, 2, 3, 4
data ends

stack segment
    db 512 dup(0ffh)
stack ends

code segment
    start:
        div 10
        


code ends

end start 