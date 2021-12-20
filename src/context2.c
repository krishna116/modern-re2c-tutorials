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

#include "context2.h"

void context2_init(context2 *self, ctxx_char_t *memory, int msize, ctxx_char_t sentinel)
{
    _ctxx_assert(self != 0);
    _ctxx_assert(memory != 0);
    _ctxx_assert(msize > 0);

    self->get_free_size     = context2_get_free_size;
    self->fill              = context2_fill;
    self->skip              = context2_skip;
    self->reset             = context2_reset;
    
    self->_memory = memory;
    self->_msize = msize;
    self->_sentinel = sentinel;
    self->_init = 1;

    self->_curser = memory;
    self->_token = memory;
    self->_marker = 0;

#if 1
    self->_limit = self->_memory;
    *(self->_limit) = self->_sentinel;
#else
    self->_limit = self->_memory + msize - 1;
#endif

#if USING_YYTEXT
    self->yytext            = context2_yytext;
    self->yyleng            = context2_yyleng;
    self->_yytextBuf[0] = 0;
    self->_yytext = 0;
    self->_yyleng = 0;
#endif //USING_YYTEXT

    self->reset(self);
}

int context2_get_free_size(context2 *self)
{
    _ctxx_assert(self != 0);
    _ctxx_assert(self->_init == 1);

    //
    //                 working memory layout.
    //
    // m--------------t===================l------------------+
    // memory         token               limit              memory[msize-1]
    // 000000000000000t===================l0000000000000000000
    // zero is free spaces, it has two parts.
    //
    int part1 = self->_token - self->_memory;
    int part2 = (self->_memory + self->_msize) - self->_limit; 

    // (space1 + space2 - 1) is free space and reserve a position for the sentinel.
    return (part1 + part2 - 1);
}

int context2_fill(context2 *self, const ctxx_char_t *block, int size)
{
    _ctxx_assert(self != 0);
    _ctxx_assert(self->_init == 1);
    _ctxx_assert(block != 0);
    int free_size = self->get_free_size(self);
    _ctxx_assert(0 <= size);
    _ctxx_assert(0 <= free_size);
    _ctxx_assert(size <= free_size);

    //
    // working memory layout.
    // marker: is at somewhere between token and limit, it is re2c's internal cached position.
    // curser: is at the same position to limit.
    //
    // +--------------t===================l------------------+
    // memory         token               limit              memory[msize-1]
    //                       marker       curser
    //

    //
    // before shift buffer.
    // +--------------t===================l------------------+
    //
    
    int shift = self->_token - self->_memory;
    int shift_data_length = self->_limit - self->_token + 1;
    for(int i = 0; i < shift_data_length; i++)
    {
        // shift buffer.
        *(self->_memory + i) = *(self->_token + i);
    }

    //
    // after shift buffer.
    // t===================l---------------------------------+
    //

    self->_token -= shift;  // shift internal state.
    self->_marker -= shift; // shift internal state.
    self->_curser -= shift; // shift internal state.

    //
    // after shift these pointer: token/marker/curser.
    // t===================l---------------------------------+
    // token  marker       curser
    //

    for (int i = 0; i < size; i++)
    {
        *(self->_curser + i) = *(block + i);
    };

    //
    // after fill new block
    // t===================bbbbbbbbbbbbbbbbbbbbb-------------+
    // token  marker       curser              block[size-1]
    //

    *(self->_curser + size) = self->_sentinel;    // append sentinel.
    self->_limit = self->_curser + size;          // adjust limit.

    //
    // after adjust limit
    // t===================bbbbbbbbbbbbbbbbbbbbb0------------+
    // token  marker       curser               limit
    //

    // next lexer will continue parsing buffer from curser to limit.
    return 0;
}

void context2_skip(context2 *self)
{
    _ctxx_assert(self != 0);
    _ctxx_assert(self->_init == 1);

    self->_token = self->_curser;

#if USING_YYTEXT
    self->_yytext = self->_curser;
#endif //USING_YYTEXT
}

void context2_reset(context2 *self)
{
    _ctxx_assert(self != 0);
    _ctxx_assert(self->_init == 1);

#if USING_YYTEXT
    // Before reset, cache last token infomation,
    // because if user want to call yytext() when the lexer return to outside,
    // it ought to be done here.
    self->_yytext = self->_token;
    self->_yyleng = limit_yyleng(self->_curser - self->_token);
#endif //USING_YYTEXT

    // Reset.
    self->_token = self->_curser;
    self->_state = -1;
}

#if USING_YYTEXT 
const ctxx_char_t* context2_yytext(context2 *self)
{


    _ctxx_assert(self != 0);
    _ctxx_assert(self->_init == 1);

    int size = self->yyleng(self);
    const ctxx_char_t* token = 0;

    if(self->_state == -1 && self->_yytext != 0) // If lexer state has reset.
    {
        // Using cache first.
        token = self->_yytext;
    }
    else
    {
        // Using current token.
        token = self->_token;
    }

    if(token == 0 || size == 0)
    {
        self->_yytextBuf[0] = 0;
        return self->_yytextBuf;
    }

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

    for(int i = 0; i < size; i++)
    {
        self->_yytextBuf[i] = token[i];
    }
    self->_yytextBuf[size] = 0;

    return self->_yytextBuf;
}
#endif //USING_YYTEXT 

#if USING_YYTEXT
int context2_yyleng(context2 *self)
{
    _ctxx_assert(self != 0);
    _ctxx_assert(self->_init == 1);

    int size = 0;

    if(self->_state == -1)  //If lexer state has reset.
    {
        // Using cache first.
        size = self->_yyleng;
    }
    else
    {
        // Using current token.
        size = limit_yyleng(self->_curser - self->_token);
    }

    return size;
}
#endif //USING_YYTEXT 