//re2c.exe test04.lex -o re2c_gen_code/test04.c 
#include <stdio.h>

void print(const char* str, int size);

int lex(const char *str) 
{
    const char *YYCURSOR = str;
    const char *yytext = NULL;
    int yyleng = 0;
    
    for(;;)
    {
        yytext = YYCURSOR;      // Last YYCURSOR is current token start position.
    /*!re2c
        re2c:define:YYCTYPE = char;
        re2c:yyfill:enable = 0;

        number = [0-9]+;
        chars  = [a-zA-Z]+;
        spaces = [ \t]+;
        
        number { 
                    yyleng = YYCURSOR - yytext;
                    print(yytext, yyleng);
                    continue;
               }
        chars  { 
                    yyleng = YYCURSOR - yytext;
                    print(yytext, yyleng);
                    continue;
               }
        spaces {
                    yyleng = YYCURSOR - yytext;
                    //print(yytext, yyleng);
                    continue;
               }
        [\x00] {
                    printf("parsing stream end ok.\n");
                    return 0;
               }
        *      { 
                    printf("parsing stream end error.\n");
                    return -1; 
               }
    */
    }
    
    return 0;
}

int test_get_tokens_inside_lexer_with_one_shot_buffer()
{
    return lex("1234 567 abc 89 def");
}

int main()
{
    return test_get_tokens_inside_lexer_with_one_shot_buffer();
}

void print(const char* str, int size)
{
    printf("token-size = [%d], ", size);
    printf("token = [");
    for(int i = 0; i < size; i++) printf("%c", *(str+i));
    printf("]\n");
}