# <a id="Experience">Experience the re2c api used for multi-shot-buffer.</a>
The re2c api used for multi-shot-buffer may be convoluted for beginners, so I will give you a small example to show how it works.  
This code logic is just as the same as get tokens in sync-mode with one-shot-buffer, but it has some differences.
 1. Using a custom-context(you can also using the library provided by this project) to wrap the buffer and the pointers to be used by user or/and re2c lexer.
 2. You should provide this define before the re2c lexer start working.
    ```
    /*!getstate:re2c*/
    ```
 3. You should provide these re2c configurations. The `@@` symbol is just a place-holder to re2c dynamic value.
    ```
    re2c:api:style          = free-form;    //this document is always using this style.
    re2c:eof                = 0;            //set sentinel to handle eof.
    re2c:define:YYCTYPE     = "char";       //may be utf8/ucs2/utf32 char type.
    re2c:define:YYCURSOR    = "context->str";   //buffer start.
    re2c:define:YYMARKER    = "context->maker"; //re2c used to backup curser.
    re2c:define:YYLIMIT     = "context->limit"; //set limit to handle eof.
    re2c:define:YYGETSTATE  = "context->state"; //re2c used to backup state.
    re2c:define:YYSETSTATE  = "context->state = @@;";   //re2c used to restore state.
    re2c:yyfill:enable      = 1;                            //must be set.
    re2c:define:YYFILL      = "return LexerNeedMoreInput;"; //must be set.
    ```
 4. Using option **--storable-state** when compile your_file.lex, for example:
    ```
    re2c.exe you_file.lex -o you_file.c --storable-state
    ```
> The full source file is project/tests/test07.lex