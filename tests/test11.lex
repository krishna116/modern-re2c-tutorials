//re2c.exe test11.lex -o re2c_gen_code/test11.c --conditions
#include <assert.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <stdio.h>

typedef enum
{
    LexerError  = -1,
    LexerOk     = 0
}LexReturnCode;

void PrintNumber(const char* begin, const char* end, const char* suffix)
{
    printf("number = [%.*s], %s\n", end-begin, begin, suffix);
}

/*!types:re2c*/    // This line should be done to generate the condition-variable/condition-types define.
int lex(const char* curser)
{
    // Each condition variable is yyc[<condition>]
    int c = yycinit;    // specify the first condition-variable for execute.

    const char* token = curser;
    /*!re2c
    re2c:yyfill:enable = 0;
    re2c:define:YYGETCONDITION = "c";
    re2c:define:YYSETCONDITION = "c = @@;";
    re2c:api:style = free-form;
    re2c:define:YYCTYPE = char;
    re2c:define:YYCURSOR = curser;

    number = [0-9]+ ;
    spaces = [ ]+ ;

    <*>             *       { return LexerError; }
    <init, inbrace> [\x00]  { return LexerError; }

                            //Each condition label is yyc_[<condition>]
    <init>      number      { PrintNumber(token, curser, "out-of-brace."); goto yyc_init;} 
    <init>      spaces      { token = curser; goto yyc_init;}
    <init>      "{"         { token = curser; goto yyc_inbrace;}

    <inbrace>   number      { PrintNumber(token, curser, "in-brace."); goto yyc_inbrace;}
    <inbrace>   spaces      { token = curser; goto yyc_inbrace;}
    <inbrace>   "}"         { token = curser; goto yyc_finish;}

    <finish>    number      { PrintNumber(token, curser, "out-of-brace."); goto yyc_finish;}
    <finish>    spaces      { token = curser; goto yyc_finish;}
    <finish>    [\x00]      { return LexerOk;}
    */

   return LexerError;
}

int test_condition_if_number_is_in_brace_or_not_version2()
{
    int ret = lex( "001 { 002 003 004 } 005 006");
    (ret == 0) ? printf("lexer finished ok.\n") : printf("lexer end error.\n");
    return ret;
}

int main()
{
    return test_condition_if_number_is_in_brace_or_not_version2();
}