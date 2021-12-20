//re2c.exe test13.lex -o re2c_gen_code/test13.c --wide-chars
#include <stdio.h>

typedef unsigned short uint16_t;

void dump_ucs2_data(const uint16_t *begin, const uint16_t * end)
{
    int i = 0;
    printf("dump ucs2 data = [\n");
    for(const uint16_t* p = begin; p < end; p++)
    {
        printf("0x%04x ", *p);
        if(++i>8)
        {
            i=0;
            printf("\n");
        }
    }
    printf("]\n");
}

void dumpUcs2Number(const uint16_t* begin, const uint16_t *end, const char* prefix)
{
    printf("%s = [", prefix);
    
    // Convert ucs2 number to ascii number and print.
    while(begin < end)
    {
        printf("%c", (char)(*begin));
        ++begin;
    }
    printf("]\n");
}

static int lex_ucs2(const uint16_t *YYCURSOR, const uint16_t * YYLIMIT)
{
    const uint16_t *YYMARKER;
    const uint16_t *token = YYCURSOR;

    dump_ucs2_data(YYCURSOR, YYLIMIT);

    while(1)
    {
    /*!re2c
    re2c:eof = 0;
    re2c:yyfill:enable = 0;
    re2c:define:YYCTYPE     = uint16_t;
    re2c:flags:wide-chars   = 1;

    "\ufeff" { 
        printf("skip ucs2 bom.\n"); continue;}

    "America" { 
        printf("find America.\n"); token=YYCURSOR; continue; }

    // Non ascii chars to ucs2(utf16):
    // https://convertcodes.com/unicode-converter-encode-decode-utf/

    "\u4e2d\u56fd" { 
        printf("find China.\n"); token=YYCURSOR; continue; }

    "\ub300\ud55c\ubbfc\uad6d" { 
        printf("find Korea.\n"); token=YYCURSOR; continue; }

    "\u0e1b\u0e23\u0e30\u0e40\u0e17\u0e28\u0e44\u0e17\u0e22" { 
        printf("find Thailand.\n"); token=YYCURSOR; continue; }

    "\u65e5\u672c" { 
        printf("find Japan.\n"); token=YYCURSOR; continue; }

    [0-9]+     {dumpUcs2Number(token,YYCURSOR, "find ucs2 number");  token=YYCURSOR; continue; }
    
    [ ]+       { token=YYCURSOR; continue; }

    $          { return 0; }

    *          { printf("*YYCURSOR = 0x%04x\n", *YYCURSOR); return -1; }

    */
   }
  return -1;
}

int read_ucs2_text()
{
    // The text is "America 中国 123 대한민국 456 ประเทศไทย 日本 789"
    // The text is 2-byte-for-ucs2-code-point, little-endian.
    unsigned char text[] = {
    0xff, 0xfe, 0x41, 0x00, 0x6d, 0x00, 0x65, 0x00, 0x72, 0x00, 0x69, 0x00,
    0x63, 0x00, 0x61, 0x00, 0x20, 0x00, 0x2d, 0x4e, 0xfd, 0x56, 0x20, 0x00,
    0x31, 0x00, 0x32, 0x00, 0x33, 0x00, 0x20, 0x00, 0x00, 0xb3, 0x5c, 0xd5,
    0xfc, 0xbb, 0x6d, 0xad, 0x20, 0x00, 0x34, 0x00, 0x35, 0x00, 0x36, 0x00,
    0x20, 0x00, 0x1b, 0x0e, 0x23, 0x0e, 0x30, 0x0e, 0x40, 0x0e, 0x17, 0x0e,
    0x28, 0x0e, 0x44, 0x0e, 0x17, 0x0e, 0x22, 0x0e, 0x20, 0x00, 0xe5, 0x65,
    0x2c, 0x67, 0x20, 0x00, 0x37, 0x00, 0x38, 0x00, 0x39, 0x00, 0x20, 0x00, 
    0x00, 0x00
    };

    //Convert little endian ucs2 byte data to uint16_t;
    const uint16_t* ucs2 = (const uint16_t*)text; 

    //Let limit point to last uint16_t(sentinel)
    const uint16_t* limit = ucs2 + sizeof(text)/sizeof(ucs2[0]) - sizeof(ucs2[0]);

    int ret;
    while ((ret = lex_ucs2(ucs2, limit)) > 0){}
    (ret == 0) ? printf("lexer finished ok.\n") : printf("lexer finished error.\n");

    return ret;
}

int main()
{
    return read_ucs2_text();
}