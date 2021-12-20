# <a id="UsingStag">Using re2c stag.</a>
re2c stags are place-holders between **lexer pattens**.  In order to using stags follow things should be done.
  1. Provide this define before re2c lexer block(you may need adjust the char type).
        ```
        /*!stags:re2c format = 'const char* @@;'; */
        ```
  2. Provide your stag holders.
        ```
        const char *YYMARKER;
        const char *keyBeg = NULL;
        const char *keyEnd = NULL;
        const char *valueBeg = NULL;
        const char *valueEnd = NULL;
        ```
  3. Provide this configuration in re2c lexer block.
        ```
        re2c:flags:tags     = 1;
        re2c:define:YYSTAGP = "@@{tag} = YYCURSOR;";
        re2c:define:YYSTAGN = "@@{tag} = NULL;";
        re2c:api:style      = free-form;
        ```
  4. Define some **regex patterns**.
        ```
        key            = [a-zA-z]+ ;
        eq             = "=";
        value          = ([a-zA-Z0-9] | '-' | '_')+ ;
        spaces         = [ \t]+ ;
        keyValEnd      = [;] ;
        ```
  5. Using **stag**s betweeen regex-pattern, and access **stag**s in the code. For example:
        ```
        @keyBeg key @keyEnd { // (keyEnd - keyBeg) is the key size;

                            }
        ```
  6. When compile your_file.lex, append this option **--tags** to re2c.exe  

> The full source file is project/tests/test15.lex
