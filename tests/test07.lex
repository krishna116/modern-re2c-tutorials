//re2c.exe test07.lex -o re2c_gen_code/test07.c --storable-state
#include <stdio.h>
#include <string.h>

void print(const char *str, int size);

typedef enum
{
    LexerError          = -2,
    LexerNeedMoreInput  = -1,
    LexerOk             = 0,
    LexerTokenNumber    = 1,
    LexerTokenChars     = 2,
    LexerTokenSpaces    = 3
} LexerReturnCode;

/// A custom context.
typedef struct
{
    const char *str;        ///< Input str.
    const char *limit;      ///< Pointer to the sentinel.
    const char *maker;      ///< Used by re2c to backup/restore state.
    const char *tok;        ///< Current token start position.
    int state;
} BufferContext;

int lex(BufferContext *context)
{
    char yych;

    /*!getstate:re2c*/
    for (;;)
    {
        context->tok = context->str;
        /*!re2c
        re2c:api:style          = free-form;
        re2c:eof                = 0;
        re2c:define:YYCTYPE     = "char";
        re2c:define:YYCURSOR    = "context->str";
        re2c:define:YYMARKER    = "context->maker";
        re2c:define:YYLIMIT     = "context->limit";
        re2c:define:YYGETSTATE  = "context->state";
        re2c:define:YYSETSTATE  = "context->state = @@;";
        re2c:yyfill:enable      = 1;
        re2c:define:YYFILL      = "return LexerNeedMoreInput;";

        number = [0-9]+;
        chars  = [a-zA-Z]+;
        spaces = [ \t]+;
        
        number  {
                    printf("token id = %d, ", LexerTokenNumber);
                    print(context->tok, context->str - context->tok);
                    continue;
                }
        chars   { 
                    printf("token id = %d, ", LexerTokenChars);
                    print(context->tok, context->str - context->tok);
                    continue;
                }
        spaces  {
                    printf("token id = %d, ", LexerTokenSpaces);
                    print(context->tok, context->str - context->tok);
                    continue;
                }
        $       {
                    printf("using re2c eof.\n");
                    return LexerOk;
                }
        [\x00]  {
                    printf("using user eof.\n");
                    return LexerOk;
                }
        *       { 
                    return LexerError; 
                }
    */
    }

    return LexerOk;
}

int experience_the_re2c_api_used_for_multi_shot_buffer()
{
    const char buffer[] = "1234 567 abc 89 def";
    
    // using custom context.
    BufferContext context;
    context.str = buffer;
    context.tok = buffer;
    context.limit = buffer + strlen(buffer);
    context.state = -1;

    int ret = 0;
    for (;;)
    {
        ret = lex(&context);
        if (ret == LexerOk)
        {
            printf("Lexer finished Ok.\n");
            break;
        }
        else if (ret == LexerError)
        {
            printf("LexerError.\n");
            break;
        }
        else if (ret == LexerNeedMoreInput)
        {
            printf("LexerNeedMoreInput, ignore it.\n");
        }
        else
        {
            printf("cannot go to here.\n");
            break;
        }
    }

    return ret;
}

int main()
{
    return experience_the_re2c_api_used_for_multi_shot_buffer();
}

void print(const char* str, int size)
{
    printf("token-size = [%d], ", size);
    printf("token = [");
    for(int i = 0; i < size; i++) printf("%c", *(str + i));
    printf("]\n");
}