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

#include "context.h"

void context_init(context *self, const ctxx_char_t *memory, int msize, ctxx_char_t sentinel)
{
    _ctxx_assert(self != 0);
    _ctxx_assert(memory != 0);
    _ctxx_assert(msize > 0);

    self->skip              = context_skip;
    self->reset             = context_reset;
    
    self->_memory = memory;
    self->_msize = msize;
    self->_sentinel = sentinel;
    self->_init = 1;

    self->_curser = memory;
    self->_token = memory;
    self->_marker = 0;

#if 0
    self->_limit = self->_memory;
    *(self->_limit) = self->_sentinel;
#else
    self->_limit = self->_memory + msize - 1;
#endif

#if USING_YYTEXT
    self->yytext            = context_yytext;
    self->yyleng            = context_yyleng;
    self->_yytextBuf[0] = 0;
    self->_yytext = 0;
    self->_yyleng = 0;
#endif //USING_YYTEXT

    self->reset(self);
}

void context_skip(context *self)
{
    _ctxx_assert(self != 0);
    _ctxx_assert(self->_init == 1);

    self->_token = self->_curser;

#if USING_YYTEXT
    self->_yytext = self->_curser;
#endif //USING_YYTEXT
}

void context_reset(context *self)
{
    _ctxx_assert(self != 0);
    _ctxx_assert(self->_init == 1);

    self->_token = self->_curser;
    self->_state = -1;
}

#if USING_YYTEXT
const ctxx_char_t* context_yytext(context *self)
{
    _ctxx_assert(self != 0);
    _ctxx_assert(self->_init == 1);

    int size = self->yyleng(self);
    // Using current token.
    const ctxx_char_t* token = self->_token;

    // Just do more check.
#if USING_ASSERT
    _ctxx_assert(self->_limit != 0);
    _ctxx_assert(token < self->_limit);
    _ctxx_assert((token + size) <= self->_limit);
#else
    if(!(self->_limit != 0                  // cannot null.
        && token < self->_limit             // token begin should before limit.
        && (token + size) <= self->_limit)) // token size shouldn't overflow limit or working buffer.
    {
        token = 0;
    }
#endif //USING_ASSERT

    if(token != 0 && size != 0)
    {
        for(int i = 0; i < size; i++)
        {
            self->_yytextBuf[i] = token[i];
        }
        self->_yytextBuf[size] = 0;
    }
    else
    {
        self->_yytextBuf[0] = 0;
    }

    return self->_yytextBuf;
}
#endif //USING_YYTEXT

#if USING_YYTEXT
int context_yyleng(context *self)
{
    _ctxx_assert(self != 0);
    _ctxx_assert(self->_init == 1);

    // Using current token.
    return limit_yyleng(self->_curser - self->_token);;
}
#endif //USING_YYTEXT
