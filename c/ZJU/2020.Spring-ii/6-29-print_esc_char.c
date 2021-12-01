#include <stdio.h>

int prt_esc_char(const char *s);

int main()
{
    char *line = "\r\n\t\bhello\tworld\x01\x1f" "\n";
// 	size_t linecap = 0;
// 	getline(&line, &linecap, stdin);
	int len = prt_esc_char(line);
	printf("%d\n", len);
}

/* 请在这里填写答案 */
void init_table(char ASCII2esc[128][3]) {
    // 转义符号
    int esc[4][2] = {
        {8,  'b'},
        {9,  't'},
        {10, 'n'},
        {13, 'r'},
    };

    /// 不可见字符
    char hex[3] = {0};
    for (int i=0; i<32; i++) {
        sprintf(hex, "%02x", i);
        ASCII2esc[i][0] = '\\'; 
        ASCII2esc[i][1] = hex[0];
        ASCII2esc[i][2] = hex[1];
    }
    // 127
    ASCII2esc[127][1] = '7';
    ASCII2esc[127][2] = 'f';

    /// 可见字符
    for (int i=32; i<=126; i++) {
        ASCII2esc[i][0] = i;
    }

    /// 转义符号
    for (int i=0, j=0; i<4; i++) {
        j = esc[i][0];
        ASCII2esc[j][0] = '\\';
        ASCII2esc[j][1] = esc[i][1];
        ASCII2esc[j][2] = '\0';
    }
}

int prt_esc_char(const char *s) {
    int len=0;
    char c, ASCII2esc[128][3] = {0};
    init_table(ASCII2esc);

    for (int i=0; *(s+i)!='\0'; i++) {
        c = *(s+i);
        for (int j=0; j<=2; j++) {
            ASCII2esc[c][j] && putchar(ASCII2esc[c][j]) && len++;
        }
    } // for end
    return len;
}
