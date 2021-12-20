//re2c.exe test02.lex -o re2c_gen_code/test02.c 
#include <stdio.h>

int lex(const char *str) 
{
    const char *YYCURSOR = str;
    const char *yytext = NULL;
    for(;;)
    {
        yytext = YYCURSOR;  //Last YYCURSER is current token start.
    /*!re2c
        re2c:define:YYCTYPE = char;
        re2c:yyfill:enable = 0;

        knownChar = [a-z];

        knownChar   {   printf("[%c] -> char\n", *yytext);
                        continue;
                    }
        [\x00]      {   printf("meet end of rule, it should end work.\n");
                        return 0;
                    }
        *           {   printf("[%c] -> unknown char\n", *yytext);
                        continue;
                    }
    */
    }
    return 0;
}

int test_one_sentinel_char()
{
    const char str[] = {'h','e','l','l','o','1','2','3','\0'};
    
    int ret = lex(str);
    (ret == 0) ? printf("lexer finished ok.\n") : printf("lexer finished error.\n");

    return ret;
}

int main()
{
    return test_one_sentinel_char();
}