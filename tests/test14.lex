//re2c.exe test14.lex -o re2c_gen_code/test14.c --unicode
#include <stdio.h>
#include <stdint.h>

void dumpUcs4Number(const uint32_t* begin, const uint32_t *end, const char* prefix)
{
    printf("%s = [", prefix);
    
    // Convert number to ascii number and print.
    while(begin < end)
    {
        printf("%c", (char)(*begin));
        ++begin;
    }
    printf("]\n");
}

static int lex_utf32(const uint32_t *YYCURSOR, const uint32_t * YYLIMIT)
{
    const uint32_t *YYMARKER;
    const uint32_t *token = YYCURSOR;

    while(1)
    {
    /*!re2c
    re2c:eof = 0;
    re2c:yyfill:enable = 0;
    re2c:define:YYCTYPE     = uint32_t;
    re2c:flags:unicode      = 1;

    "America" { 
        printf("find America.\n"); token=YYCURSOR; continue; }

    "\U00004e2d\U000056fd" { 
        printf("find China.\n"); token=YYCURSOR; continue; }

    "\U0000b300\U0000d55c\U0000bbfc\U0000ad6d" { 
        printf("find Korea.\n"); token=YYCURSOR; continue; }

    "\U00000e1b\U00000e23\U00000e30\U00000e40\U00000e17\U00000e28\U00000e44\U00000e17\U00000e22" { 
        printf("find Thailand.\n"); token=YYCURSOR; continue; }

    "\U000065e5\U0000672c" { 
        printf("find Japan.\n"); token=YYCURSOR; continue; }

    [0-9]+     {dumpUcs4Number(token,YYCURSOR, "find ucs4 number");  token=YYCURSOR; continue; }
    
    [ ]+       { token=YYCURSOR; continue; }

    $          { return 0; }

    *          { printf("*YYCURSOR = 0x%08x\n", *YYCURSOR); return -1; }

    */
   }
  return -1;
}

int read_utf32_text()
{
    // The text is "America 中国 123 대한민국 456 ประเทศไทย 日本 789"
    // The text is 4-byte-for-ucs4-code-point, little-endian.
    unsigned char text[] = {
    0x41,0x00,0x00,0x00 ,0x6d,0x00,0x00,0x00 ,0x65,0x00,0x00,0x00 ,0x72,0x00,0x00,0x00, 
    0x69,0x00,0x00,0x00 ,0x63,0x00,0x00,0x00 ,0x61,0x00,0x00,0x00 ,0x20,0x00,0x00,0x00,
    0x2d,0x4e,0x00,0x00 ,0xfd,0x56,0x00,0x00 ,0x20,0x00,0x00,0x00 ,0x31,0x00,0x00,0x00,
    0x32,0x00,0x00,0x00 ,0x33,0x00,0x00,0x00 ,0x20,0x00,0x00,0x00 ,0x00,0xb3,0x00,0x00, 
    0x5c,0xd5,0x00,0x00 ,0xfc,0xbb,0x00,0x00 ,0x6d,0xad,0x00,0x00 ,0x20,0x00,0x00,0x00, 
    0x34,0x00,0x00,0x00 ,0x35,0x00,0x00,0x00 ,0x36,0x00,0x00,0x00 ,0x20,0x00,0x00,0x00, 
    0x1b,0x0e,0x00,0x00 ,0x23,0x0e,0x00,0x00 ,0x30,0x0e,0x00,0x00 ,0x40,0x0e,0x00,0x00, 
    0x17,0x0e,0x00,0x00 ,0x28,0x0e,0x00,0x00 ,0x44,0x0e,0x00,0x00 ,0x17,0x0e,0x00,0x00, 
    0x22,0x0e,0x00,0x00 ,0x20,0x00,0x00,0x00 ,0xe5,0x65,0x00,0x00 ,0x2c,0x67,0x00,0x00, 
    0x20,0x00,0x00,0x00 ,0x37,0x00,0x00,0x00 ,0x38,0x00,0x00,0x00 ,0x39,0x00,0x00,0x00,
    0x00,0x00,0x00,0x00
    };

    //Convert little-endian byte text to uint32_t;
    const uint32_t* utf32 = (const uint32_t*)text; 

    //Let limit point to last uint32_t(sentinel)
    const uint32_t* limit = utf32 + sizeof(text)/sizeof(utf32[0]) - sizeof(utf32[0]);

    int ret;
    while ((ret = lex_utf32(utf32, limit)) > 0){}
    (ret == 0) ? printf("lexer finished ok.\n") : printf("lexer finished error.\n");

    return ret;
}

int main()
{
    return read_utf32_text();
}


/*
中国
\00004e2d\000056fd

대한민국
\U0000b300\U0000d55c\U0000bbfc\U0000ad6d

ประเทศไทย
\U00000e1b\U00000e23\U00000e30\U00000e40\U00000e17\U00000e28\U00000e44\U00000e17\U00000e22

日本
\U000065e5\U0000672c
*/