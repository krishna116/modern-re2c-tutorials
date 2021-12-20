//re2c.exe test15.lex -o re2c_gen_code/test15.c --tags
#include <stdio.h>

void print(const char* prefix, const char* begin, const char* end)
{
    printf("%s [%.*s]\n", prefix, end - begin, begin);
}

int lex(const char *YYCURSOR) 
{
    const char *YYMARKER;
    const char *a1 = NULL;
    const char *a2 = NULL;
    const char *b1 = NULL;
    const char *b2 = NULL;

    /*!mtags:re2c format = 'const char* @@;'; */
    for(;;)
    {
    /*!re2c
        re2c:flags:tags = 1;
        re2c:define:YYMTAGP = "@@{tag} = YYCURSOR;";
        re2c:define:YYMTAGN = "@@{tag} = NULL;";
        re2c:api:style      = free-form;
        re2c:define:YYCTYPE = char;
        re2c:yyfill:enable = 0;

        keyAndValue = #a1 [a-zA-z]+ #a2 [ ]* "=" [ ]*  #b1 ([a-zA-Z0-9] | '-' | '_')+ #b2 [ ]* ";" [ \r\n]* ;

        keyAndValue {
            printf("[v]\n");
            print("  key =", a1, a2);
            print("  val =", b1, b2);
            continue;
        }

        [\x00] { return 0; }
        *      { return *YYCURSOR; }
    */
    }

    return 0;
}

int parsing_KeyValues_using_mtag()
{
    const char KeyValues[] = "name = jack; country = America; hobby = read-books;";

    int ret = lex(KeyValues);
    (ret == 0) ? printf("lexer finished ok.\n") : printf("lexer finished error[0x%02x].\n", ret);

    return ret;
}

int main()
{
    return parsing_KeyValues_using_mtag();
}