# <a id="GetTokensAsyncMulti">Get tokens in async-mode with multi-shot-buffer.</a>
Before read this section, you should have read previous section.  

The changes between previous section and this section are:
 1. Every user-code of the re2c-rule should using a **return**, and **reset** lexer before return.  
    ```
    [0-9]+  { ctx->reset(ctx);    //reset;
              return a_user_id;   //return;
            } 
    ```
 2. The `ctx->reset(ctx)` logic is:

    Copy/backup the last token position so you can get the last goken by `ctx.yytext(&ctx)`.
    ```
    ctx->_yytext = last_token_start_position; 
    ```
    Copy/backup the last token length so you can get the last token-length by call `ctx.yyleng(&ctx)`.
    ```
    ctx->_yyleng = last_token_size;
    ```
    Follow line is used to reset lexer. Don't using it when lexer interrupt(request more input), because the buffer may be inconsecutive when lexer interrupt(you may get half a word).  

    > What does reset mean? It tells re2c lexer to discard internal states and restart working. The YYCURSER is a forward iterator and it never goes back, so when you do reset the YYCURSER will hold at its current position.  
    ```
    ctx->_state = -1;
    ```
 3. That's all.

> The full source file is project/tests/test09.lex