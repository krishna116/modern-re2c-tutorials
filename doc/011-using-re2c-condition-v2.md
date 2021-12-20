# <a id="UsingCondition2">Using condition v2</a>
In this tutorial, I will show you how to use **re2c condition api** to check string `001 { 002 003 004 } 005` and print which numbers are in the brace and which are out of the brace.  

Follow things should be done when using condition-rules:
 1. Before re2c-lexer-block, provide this line to generate condition typedef.
    ```
    /*!types:re2c*/
    ```
 2. The lexer first line should initialize first condition you will use.  
    Each condition variable is yyc\[\<condition\>] for backup and restore.  
    Each condition label is yyc_\[\<condition\>] for jump.  
    ```
    int lexer()
    {
        int c = yycinit; //specify you first condition.
        //...
    }
    ``` 
 3. You should provide this re2c api configuration in the lex function. The `@@` symbol is just a place-holder to re2c dynamic value.
    ```
    re2c:define:YYGETCONDITION = "c";
    re2c:define:YYSETCONDITION = "c = @@;";
    ```
 4. When compile you_file.lex append this option **--conditions**, for example:
    ```
    re2c.exe your_file.lex -o your_file.c --conditions
    ```

> The full source file is project/tests/test11.lex
