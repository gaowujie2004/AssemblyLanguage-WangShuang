#include <stdio.h>

int main() {
    char* str = "GaoWuJie";

    int len = 0;
    int i = 0;
    char curChar = 0;
    while ((curChar = *(str + i)) != 0) {
        
        // printf("%c\n", curChar);
        if (curChar == '%') {
            switch (curChar) {
                case 'd':
                    
                    len++;
                    break;
                case 'c': 
                    len++;
                    break;
                default:
                    printf("不支持当前模式");
            }     
        }
        

        i++;
    }   

    return 0;
}