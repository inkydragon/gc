#include <stdio.h>

int mylen( const char *s );

int main()
{
  char word[80];
  scanf("%s", word);

  printf("%d", mylen(word));

  return 0;

}

/* 请在这里填写答案 */
int mylen( const char *s ) {
    int i = 0;
    for (; *(s+i)!='\0'; i++); 
    return i;
}
