//re2c.exe test10.lex -o re2c_gen_code/test10.c
#include <assert.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <stdio.h>

typedef enum
{
    LexerError  = -1,
    LexerOk     = 0,
}LexReturnCode;

void PrintNumber(const char* begin, const char* end, const char* suffix)
{
    printf("number = [%.*s], %s\n", end-begin, begin, suffix);
}

int lex(const char* curser)
{
    const char* token = curser;

    //---------------------------------> using "!local:re2c" for local lexer block declaration.
    //---------------------------------> using "!re2c" for global lexer block declaration.
    /*!re2c                       //---> it is a global lexer block declaration.
    re2c:yyfill:enable = 0;
    re2c:api:style = free-form;
    re2c:define:YYCTYPE = char;
    re2c:define:YYCURSOR = curser;
    */
init:
    /*!re2c
    [0-9]+  {PrintNumber(token, curser, "out of brace."); token = curser; goto init;}
    [ ]+    {token = curser; goto init;}
    "{"     {token = curser; goto inbrace;}
    *       {return LexerError;}
    */
inbrace:
    /*!re2c
    [0-9]+  {PrintNumber(token, curser, "in brace."); token = curser; goto inbrace;}
    [ ]+    {token = curser; goto inbrace;}
    "}"     {token = curser; goto finish;}
    *       {return LexerError;}
    */
finish:
    /*!re2c
    [0-9]+  {PrintNumber(token, curser, "out of brace."); token = curser; goto finish;}
    [ ]+    {token = curser; goto finish;}
    [\x00]  {return LexerOk;}
    *       {return LexerError;}
    */

   return LexerError;
}

int test_condition_if_number_is_in_brace_or_not()
{
    int ret = lex( "001 { 002 003 004 } 005");
    (ret == LexerOk) ? printf("lexer finished ok.\n") : printf("lexer end error.\n");
    return ret;
}

int main()
{
    return test_condition_if_number_is_in_brace_or_not();
}