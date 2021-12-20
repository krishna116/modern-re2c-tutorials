//re2c.exe test05.lex -o re2c_gen_code/test05.c
#include <stdio.h>

void print(const char* str, int size);

/**
 * This is a simple re-entry lexer.
 *
 * @param[in] curser    Input string for lex.
 * @param[out] next     Current consumed size by lexer.
 * @param[out] yyleng   Current matched token size.
 * @param[out] yytext   Current matched token.
 *
 * @return (int > 0)    A matched token id.
 * @return (int <= 0)   Lexer end or error happened.
 */
int lex(const char *curser, int* next, int* yyleng, const char ** yytext) 
{
    const char *YYCURSOR = curser;
    *next = 0;
    *yyleng = 0;
    *yytext = NULL;
    
    for(;;)
    {
        *yytext = YYCURSOR;     // Last YYCURSOR is current token start position.
    /*!re2c
        re2c:define:YYCTYPE = char;
        re2c:yyfill:enable = 0;

        number = [0-9]+;
        chars  = [a-zA-Z]+;
        spaces = [ \t]+;
        
        number { 
                    *yyleng = YYCURSOR - *yytext;
                    *next += *yyleng;
                    return 1;
               }
        chars  { 
                    *yyleng = YYCURSOR - *yytext;
                    *next += *yyleng;
                    return 2;
               }
        spaces { 
                    *yyleng = YYCURSOR - *yytext;
                    *next += *yyleng;
                    continue;   // skip space token;
               }
        [\x00] {
                    return 0;
               }
        *      { 
                    return -1;
               }
    */
    }
    
    return 0;
}

int get_tokens_outside_lexer_with_one_shot_buffer()
{
    const char buffer[] = "1234 567 abc 89 def";
    const char* curser = buffer;
    int next = 0;                       // current offset size(here is: spaces + token) for next start.
    int yyleng = 0;                     // current matched token size.
    const char* yytext = NULL;          // current matched token.

    int ret;
    while ((ret = lex(curser, &next, &yyleng, &yytext)) > 0)
    {
        print(yytext, yyleng);
        curser += next;
    }

    (ret == 0) ? printf("lexer finished ok.\n") : printf("lexer finished error.\n");
    
    return ret;
}

int main()
{
    return get_tokens_outside_lexer_with_one_shot_buffer();
}

void print(const char* str, int size)
{
    printf("token-size = [%d], ", size);
    printf("token = [");
    for(int i = 0; i < size; i++) printf("%c", *(str + i));
    printf("]\n");
}