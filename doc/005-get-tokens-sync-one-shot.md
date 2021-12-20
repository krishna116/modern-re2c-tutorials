# <a id="GetTokensSyncOne">Get tokens in sync-mode with one-shot-buffer.</a>
 1. Using this re2c configuration.
    ```
    YYCURSOR            = your_buffer_start
    re2c:define:YYCTYPE = a_char_type;
    re2c:yyfill:enable  = 0;
    ```
 2. Every user-rule(non eof rule) should use a **continue**.
    ```
    [0-9]+  { //user rule, do something.
                continue;
            }
    ```
 3. You can either use **re2c-eof-rule** or **user-eof-rule**, and eof rules should using a **return** in order to end/finish work.  
    - If use user-eof-rule, assume the sentinel is \[\x00\] here.
    ```
    //this is user-eof-rule.
    [\x00]  { //do something. 
                return an_user_id;
            }
    ```
    - If using re2c-eof-rule.
    ```
    //re2c additional configuration.
    YYLIMIT     = user_stream_last_sentinel_position;
    re2c:eof    = the_sentinel_value;

    //this is re2c-eof-rule.
    $       { //do something. 
                return an_user_id;
            }
    ```
 4. To get the tokens, you just need take care YYCURSER. 
      1. Before lexer next start, using a pointer like `const char* yytext` to get a copy of current YYCURSER position. 
      2. After lexer next hit/meet a rule(before run the user-code), the `yytext` is the **token-string-start** and the `YYCURSER - yytext` is the **token-string-length**.

> The full source file is project/tests/test04.lex
