//re2c.exe test14.lex -o re2c_gen_code/test14.c --tags
#include <stdio.h>

void print(const char* prefix, const char* begin, const char* end)
{
    printf("%s [%.*s]\n", prefix, end - begin, begin);
}

int lex(const char *YYCURSOR) 
{
    const char *YYMARKER;
    const char *keyBeg = NULL;
    const char *keyEnd = NULL;
    const char *valueBeg = NULL;
    const char *valueEnd = NULL;

    /*!stags:re2c format = 'const char* @@;'; */
    for(;;)
    {
    /*!re2c
        re2c:flags:tags     = 1;
        re2c:define:YYSTAGP = "@@{tag} = YYCURSOR;";
        re2c:define:YYSTAGN = "@@{tag} = NULL;";
        re2c:api:style      = free-form;
        re2c:define:YYCTYPE = char;
        re2c:yyfill:enable = 0;

        key            = [a-zA-z]+ ;
        eq             = "=";
        value          = ([a-zA-Z0-9] | '-' | '_')+ ;
        spaces         = [ \t]+ ;
        keyValEnd      = [;] ;

        @keyBeg key @keyEnd (spaces)? eq (spaces)?  @valueBeg value @valueEnd (spaces)?  keyValEnd {
            printf("[+]\n");
            print("  key =", keyBeg, keyEnd);
            print("  val =", valueBeg, valueEnd);
            continue;
        }

        spaces { continue; }
        [\x00] { return 0; }
        *      { return *YYCURSOR; }
    */
    }

    return 0;
}

int parsing_KeyValues_using_stag()
{
    const char KeyValues[] = "name = jack; country = America; hobby = read-books;";

    int ret = lex(KeyValues);
    (ret == 0) ? printf("lexer finished ok.\n") : printf("lexer finished error[0x%02x].\n", ret);

    return ret;
}

int main()
{
    return parsing_KeyValues_using_stag();
}