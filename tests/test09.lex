//re2c.exe test09.lex -o re2c_gen_code/test09.c --storable-state

#define USING_ASCII 1   // context v2 char type
#include "context2.h"   // using context v2

#include <stdio.h>      // using printf
#include <string.h>     // using strlen

typedef enum
{
    LexerError          = -2,
    LexerNeedMoreInput  = -1,
    LexerOk             = 0,
    LexerTokenNumber    = 1,
    LexerTokenChars     = 2,
    LexerTokenSpaces    = 3
} LexerReturnCode;

int lex(context2* ctx)
{
    char yych;

    /*!getstate:re2c*/
    for (;;)
    {
        ctx->skip(ctx);
        /*!re2c
        re2c:eof                = 0;
        re2c:api:style          = free-form;
        re2c:define:YYCTYPE     = "char";
        re2c:define:YYCURSOR    = "ctx->_curser";
        re2c:define:YYMARKER    = "ctx->_marker";
        re2c:define:YYLIMIT     = "ctx->_limit";
        re2c:define:YYGETSTATE  = "ctx->_state";
        re2c:define:YYSETSTATE  = "ctx->_state = @@;";
        re2c:define:YYFILL      = "return LexerNeedMoreInput;";

        number = [0-9]+;
        chars  = [a-zA-Z]+;
        spaces = [ \t]+;
        
        number  {
                    ctx->reset(ctx);
                    return LexerTokenNumber;
                }
        chars   {
                    ctx->reset(ctx);
                    return LexerTokenChars;
                }
        spaces  {
                    ctx->reset(ctx);
                    return LexerTokenSpaces;
                }
        $       {
                    return LexerOk;
                }
        *       { 
                    return LexerError; 
                }
    */
    }

    return LexerOk;
}

int get_tokens_outside_lexer_with_multi_shot_buffer_blocks()
{
    // Init lexer working memory.
    char workingMemoryForLexer[64];
    int workingMemoryForLexerSize = 64;
    context2 ctx; // context2 is used to do all the arduous work for you.
    context2_init(&ctx, workingMemoryForLexer, workingMemoryForLexerSize, 0);

    //
    // After context2 object init, the available member fuctions are:
    //  ctx.get_free_size(...);
    //  ctx.fill(...);
    //  ctx.skip(...);
    //  ctx.reset(...);
    //  ctx.yytext(...);
    //  ctx.yyleng(...);
    //

    // Input for lexer will be these multi-shot-buffer-blocks, they are inconsecutive blocks.
    const char*blocks[]=
    {
        "Hello wor",
        "ld is o",
        "k",
    };
    int blockCount = sizeof(blocks)/sizeof(blocks[0]);
    int blockIndex = 0;

    // You can fill or not fill first block, either is ok.
#if fill_first_block
    ctx.fill(&ctx, blocks[blockIndex], strlen(blocks[blockIndex]));
    blockIndex++;
#endif//

    int ret = 0;
    for (;;)
    {
        ret = lex(&ctx);
        if(ret == LexerTokenNumber)
        {
            printf("token-id = [%d], token = [%s]\n", ret, ctx.yytext(&ctx));
        }
        else if(ret == LexerTokenChars)
        {
            printf("token-id = [%d], token = [%s]\n", ret, ctx.yytext(&ctx));
        }
        else if(ret == LexerTokenSpaces)
        {
            printf("token-id = [%d], token = [%s]\n", ret, ctx.yytext(&ctx));
        }
        else if (ret == LexerOk)
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
            if(blockIndex < blockCount)
            {
                int blockSize = strlen(blocks[blockIndex]);

                if(ctx.get_free_size(&ctx) < blockSize)
                {
                    printf("it seems lexer need a more big working buffer to match the longest string.\n");
                    break;
                }

                ctx.fill(&ctx, blocks[blockIndex], strlen(blocks[blockIndex]));
                blockIndex++;
            }

            // nothing to do if no more blocks, re2c lexer will double check it and goto EOF.
        }
        else
        {
            printf("cannot go to here.\n");
            ret = LexerError;
            break;
        }
    }

    return ret;
}

int main()
{
    return get_tokens_outside_lexer_with_multi_shot_buffer_blocks();
}
