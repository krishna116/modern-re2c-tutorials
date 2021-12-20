//re2c.exe test06.lex -o re2c_gen_code/test06.c

#include <stdio.h>
#include <string.h>

void print(const char* str, int size);

typedef enum
{
    LexerError          = -1,
    LexerOk             = 0,
    LexerTokenNumber    = 1,
    LexerTokenChars     = 2,
    LexerTokenSpaces    = 3
}LexerReturnCode;

typedef struct
{
    const char* curser; ///< Custom YYCURSOR.
    const char* limit;  ///< Limit should point to the string terminator.
}context;

int lex(context* ctx, int* yyleng, const char** yytext) 
{
    char yych;

    for(;;)
    {
        *yytext = ctx->curser;
    /*!re2c
        re2c:define:YYCTYPE     = "char";
        re2c:yyfill:enable      = 0;
        re2c:define:YYCURSOR    = "ctx->curser";
        re2c:eof                = 0;
        re2c:define:YYLIMIT     = "ctx->limit";

        number = [0-9]+;
        chars  = [a-zA-Z]+;
        spaces = [ \t]+;
        
        number {
                    *yyleng = ctx->curser - *yytext;
                    return LexerTokenNumber;
               }
        chars  {
                    *yyleng = ctx->curser - *yytext;
                    return LexerTokenChars;
               }
        spaces {
                    *yyleng = ctx->curser - *yytext;
                    return LexerTokenSpaces;
               }
        $      {
                    return LexerOk;
               }
        *      { 
                    return LexerError; 
               }
    */
    }
    
    return LexerOk;
}

int get_tokens_outside_lexer_with_one_shot_bufferVersion2()
{
    const char buffer[] = "1234 567 abc 89 def";
    context ctx;
    ctx.curser = buffer;
    ctx.limit = buffer + strlen(buffer); //limit should point to the sentinel(string terminator).

    int ret = 0;
    const char* yytext = NULL;
    int yyleng = 0;
    while((ret = lex(&ctx, &yyleng, &yytext)) > 0)
    {
        printf("token-id = %d, ", ret);
        print(yytext, yyleng);
    }

    (ret == 0) ? printf("final return ok.\n"): printf("final return error.\n");

    return ret;
}

int main()
{
    return get_tokens_outside_lexer_with_one_shot_bufferVersion2();
}

void print(const char* str, int size)
{
    if(str == NULL) return;

    printf("token = [");
    for(int i = 0; i < size; i++) printf("%c", *(str+i));
    printf("]\n");
}