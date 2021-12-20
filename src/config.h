/*
The MIT License

Copyright 2021 Krishna sssky307@163.com

Permission is hereby granted, free of charge, to any person obtaining a copy 
of this software and associated documentation files (the "Software"), to deal 
in the Software without restriction, including without limitation the rights 
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
copies of the Software, and to permit persons to whom the Software is 
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in 
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE 
USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#ifndef _CONFIG_H_
#define _CONFIG_H_

//
// Define context or context2 char type.
//
#if USING_ASCII
    typedef char ctxx_char_t;
#elif USING_UTF8
    typedef unsigned char ctxx_char_t;
#elif USING_UCS2
    typedef unsigned short ctxx_char_t;
#elif USING_UCS4
    typedef unsigned int ctxx_char_t;
#else
    typedef char ctxx_char_t;
#endif //ctxx_char_t.

//
// Turn on/off assert.
//
#define USING_ASSERT 1

//
// Turn on/off yytext and yyleng api.
//
#define USING_YYTEXT 1

///
///
///
#if USING_ASSERT
    #include <assert.h>
    #define _ctxx_assert(x) assert(x)
#else 
    #define _ctxx_assert(x)
#endif //USING_RE2_CTX_ASSERT

#if USING_YYTEXT
    #define YYLENG_SIZE_MAX 256
    #define _max(a,b)  (a) > (b) ? (a) : (b)
    #define _min(a,b)  (a) < (b) ? (a) : (b)
    #define _limit_value_between(min, value, max) _min(_max(value, min), max)
    #define limit_yyleng(value) _limit_value_between(0, value, YYLENG_SIZE_MAX)
#endif //USING_YYTEXT

#endif //_CONFIG_H_
