//re2c.exe test01.lex -o re2c_gen_code/test01.c
#include <stdio.h>

int lex(const char *str) 
{
    const char *YYCURSOR = str;

/*!re2c
    re2c:define:YYCTYPE = char;
    re2c:yyfill:enable = 0;

    token = [0-9]+ ;

    token   { printf("It is a number.\n"); return 0;}
    *       { printf("It is not a number.\n"); return -1;}
*/

    return 0;
}

int test_a_minimal_example()
{
    const char str[] = "123456";
    printf("input is: %s\n", str);
    return lex(str);
}

int main()
{
    return test_a_minimal_example();
}