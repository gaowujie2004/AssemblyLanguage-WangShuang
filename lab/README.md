# lab
《汇编语言 第四版》中的实验

# 5 多个段之间的关系


# 10 编写子程序

# 11 编写子程序
将以 0 结尾的字符串中的小写字母转为大写字母

# 12 编写0号中断处理程序
这个实验任务已经在 12 章完成了。filename: do0-ok-stage.asm
除0错误会触发0号中断，但是中断例程iret后，程序并没有返回到除法指令的下一条指令，而是一直在循环（pc一直指向除法指令）
这种中断又叫：异常中断，中断例程iret后，不改变pc

# 13 编写中断例程
- 13.1 编写并安装 int 7ch 中断例程，功能为显示一个用0结束的字符串，中断例程安装在0:200处。
- 参数：dh=行号、dl=列号、cl=颜色，ds:si 指向字符串首地址

目标：使用单步中断观察 int、iret 指令指向前后 CS、IP和栈的状态。

# 14 访问CMOS-RAM，显示日期+时间


# 17 逻辑扇区号转物理扇区
用汇编做乘、除运算真的好麻烦。