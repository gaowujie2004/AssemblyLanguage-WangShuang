# 实验8  分析一个奇怪的程序
对「第九章」内容的巩固
这个程序很牛逼。


要注意：jmp short s1 对应的汇编是 EB F6
F6即偏移长度，由于是补码编码则对应的真值是：-10

 |汇编地址|	 机器码  |        对应汇编代码   |	 
 0000				 codesg segment 
 0000     B8 4C00	          mov ax,4c00h  
 0003     CD 21		          int 21h 
				 
 0005     B8 0000	   start: mov ax,0  
 0008     90		   s:     nop  
 0009     90			      nop 
				 
 000A     BF 0008 R		      mov di, offset s  
 000D     BE 0020 R		      mov si, offset s2  
 0010     2E: 8B 04		      mov ax, cs:[si] 
 0013     2E: 89 05		      mov cs:[di], ax 
				 
 0016     EB F0			 s0: jmp short s  
				     
 0018     B8 0000	     s1: mov ax,0 
 001B     CD 21			     int 21h 
 001D     B8 0000			 mov ax,0  
				     
 0020     EB F6			s2: jmp short s1 
 0022     90			    nop  
 0023				 codesg ends  