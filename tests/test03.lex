//re2c.exe test03.lex -o re2c_gen_code/test03.c 
#include <stdio.h>

int lex(const char *str, int strlen) 
{
    const char *YYCURSOR = str;
    const char *YYLIMIT = str + strlen;

    const char *yytext = NULL;
    for(;;)
    {
        yytext = YYCURSOR;  // Last YYCURSOR is current token start position.
    /*!re2c
        re2c:define:YYCTYPE = char;
        re2c:yyfill:enable = 0;
        re2c:eof = 0;      //re2c:eof can be any char-value, this value 0 equal string-terminator.

        knownChar = [a-z];

        knownChar   {
                        printf("[%c] -> char\n", *yytext);
                        continue;
                    }

        $           {
                        if((YYCURSOR - str) == strlen)
                        {
                            printf("lexer finished ok.\n");
                            return 0;
                        }
                        else
                        {
                            printf("lexer finished error.\n");
                            return -1;
                        }
                    }

        *           { 
                        if(*yytext == 0)
                        {
                            printf("[\\0] -> ignore this sentinel char\n");
                        }
                        else
                        {
                            printf("[%c] -> unknown char\n", *yytext);
                        }

                        continue;
                    }
    */
    }

    return 0;
}

int test_one_sentinel_char()
{
    printf("test_one_sentinel_char.\n");

    int str_len      =         5                     +3;
    const char str[] = {'h','e','l','l','o',     '1','2','3',     '\0'};
    return lex(str, str_len);
}

int test_more_than_one_sentinel_char()
{
    printf("test_more_than_one_sentinel_char.\n");

    int str_len      =         5                  +1           +3;
    const char str[] = {'h','e','l','l','o',     '\0',     '1','2','3',     '\0'};
    return lex(str, str_len);
}

int main()
{
    if(test_one_sentinel_char() == 0 && test_more_than_one_sentinel_char() == 0)
    {
        return 0;
    }

    return -1;
}