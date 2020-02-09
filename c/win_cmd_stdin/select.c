#include <stdio.h>
#include <winsock2.h>
#pragma comment(lib, "ws2_32")
int main()
{
    char buf[128] = "";
    struct fd_set fds;
    struct timeval timeout = {3, 0}; //select超时等待时间：3秒，要非阻塞就置0
    FD_ZERO(&fds);
    FD_SET(0, &fds); //添加标准输入文件描述符
    switch (select(0, &fds, &fds, NULL /*不关注异常*/, &timeout))
    {
        case -1: // 总是返回 -1，stdin 在 win 上不是 socket
            printf("select error(-1)\n");
            exit(-1);
        case 0:
            printf("select 超时\n");
            exit(-1); //超时
        default:
            if (FD_ISSET(0, &fds)) //测试stdin是否可读
            {
                fread(buf, 32, 1, stdin); // 从输入缓冲区里读取出9个字符
            } // end if break;
    } // end switch
    if (strlen(buf) != 0)
    {
        printf("输入缓冲区里还有数据\n");
        puts(buf);
    }
    return 0;
}