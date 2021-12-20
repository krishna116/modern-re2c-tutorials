//re2c.exe test12.lex -o re2c_gen_code/test12.c --input-encoding utf8
#include <stdio.h>

typedef unsigned char uint8_t;

static int lex_utf8(const uint8_t *YYCURSOR, const uint8_t * YYLIMIT)
{
    const uint8_t *YYMARKER;
    const uint8_t *token = YYCURSOR;

    while(1)
    {
    /*!re2c
    re2c:eof = 0;
    re2c:yyfill:enable = 0;
    re2c:define:YYCTYPE = uint8_t;
    re2c:flags:utf-8 = 1;

    "America"   { printf("find America.\n"); token=YYCURSOR; continue; }
    "中国"      { printf("find China.\n"); token=YYCURSOR; continue; }
    "대한민국"  { printf("find Korea.\n"); token=YYCURSOR; continue; }
    "ประเทศไทย" { printf("find Thailand.\n"); token=YYCURSOR; continue; }
    "日本"      { printf("find Japan.\n"); token=YYCURSOR; continue; }
    [0-9]+     { printf("find number = [%.*s].\n",YYCURSOR-token,token); token=YYCURSOR; continue; }
    [ ]+       { token=YYCURSOR; continue; }
    $          { return 0; }
    *          { return -1; }

    */
   }
  return -1;
}

int read_utf8_text()
{
    static const uint8_t utf8str[] = "America 中国 123 대한민국 456 ประเทศไทย 日本 789";
    
    // Do not using strlen to calculate utf8str length, 
    // because utf8 encoding may contain zero values in the middle of chars.
    const uint8_t * limit = utf8str + sizeof(utf8str)/sizeof(utf8str[0]) - sizeof(utf8str[0]); 

    int ret;
    while ((ret = lex_utf8(utf8str, limit)) > 0){}
    (ret == 0) ? printf("lexer finished ok.\n") : printf("lexer finished error.\n");
    return ret;
}

int main()
{
    return read_utf8_text();
}