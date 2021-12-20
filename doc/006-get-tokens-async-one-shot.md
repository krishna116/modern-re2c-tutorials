# <a id="GetTokensAsyncOne">Get tokens in async-mode with one-shot-buffer.</a>
To get the tokens.
 - All you need to do is take care YYCURSER. Before lexer next start, using a pointer like `const char* yytext` to get a copy of current YYCURSER position. After lexer next meet a rule(before run the user-code), the `yytext` is the **token-string-start** and the `YYCURSER - yytext` is the **token-string-length**. 

To send token outside of lexer-function.
 1. Using pointers to send **token-string-start** and **token-string-length** to outside.
 2. Each **user-code** of **re2c-rule** should using a **return** \<an-user-id>.

> The full source file is project/tests/test05.lex

> The full source file(version2) is project/tests/test06.lex
