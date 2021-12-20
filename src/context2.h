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

/**
 * @brief This is context v2 for re2c lexer.
 * 
 * It wraps some conventional functions for working with multi-shot-buffer-blocks.
 * 
 */

#ifndef _CONTEXT2_
#define _CONTEXT2_

#include "config.h"

typedef struct context2_ context2;

//
// Public api.
//
typedef void (*CONTEXT2_INIT)(context2 *self, ctxx_char_t *memory, int msize, ctxx_char_t sentinel);
typedef int (*CONTEXT2_GET_FREE_SIZE)(context2 *self);
typedef int (*CONTEXT2_FILL)(context2 *self, const ctxx_char_t *block, int size);
typedef void (*CONTEXT2_SKIP)(context2 *self);
typedef void (*CONTEXT2_RESET)(context2 *self);

#if USING_YYTEXT
    typedef const ctxx_char_t* (*CONTEXT2_YYTEXT)(context2 *self);
    typedef int (*CONTEXT2_YYLENG)(context2 *self);
#endif //USING_YYTEXT

struct context2_
{
//public:
    CONTEXT2_GET_FREE_SIZE  get_free_size;      ///< get current free space size of working buffer.
    CONTEXT2_FILL           fill;               ///< fill or refill buffer.
    CONTEXT2_SKIP           skip;               ///< skip current token.
    CONTEXT2_RESET          reset;              ///< reset lexer state to initial state.
//private:
    ctxx_char_t *_memory;   ///< working buffer.
    int _msize;             ///< working buffer size.
    int _init;              ///< working buffer has init(1) or not(0).
    ctxx_char_t _sentinel;  ///< lexer sentinel character.
    ctxx_char_t *_curser;   ///< lexer curser snapshot.
    ctxx_char_t *_token;    ///< lexer token snapshot.
    ctxx_char_t *_marker;   ///< lexer used to cache the current input position.
    ctxx_char_t *_limit;    ///< lexer limit snapshot.
    int _state;             ///< lexer state snapshot.

#if USING_YYTEXT
//public:
    CONTEXT2_YYTEXT         yytext;     ///< get current token str from lexer.
    CONTEXT2_YYLENG         yyleng;     ///< get current token str length from lexer.
//private:
    ctxx_char_t _yytextBuf[YYLENG_SIZE_MAX+1];  ///< current token buffer.
    const ctxx_char_t *_yytext;                 ///< cache current token start position.
    int _yyleng;                                ///< cache current token size.
#endif //USING_YYTEXT
};

/**
 * @brief Initialize a multi shot context2.
 * 
 * In this multi shot mode:
 *   1, the memory provided should not contain any user date.
 *   2, the memory is a shift/slide window for internal working.
 *   2, the memory is used to fill inconsecutive user block-data when re2c interrupt/request more input.
 *   3, The memory size could be max of(max-possible-match-str-size, one-fill-block-size, 1).
 * 
 * After context2 initialized, you may fill first block data to it before lexer start, 
 * however, it is not mandatory.
 * 
 * It is user's responsibility to provide the memory.
 * It is user's responsibility to free the memory after lexer work end.
 * The memory's life time should longer than the lexer's life time.
 * The sentinel is re2c sentinel character.
 * 
 * @param[in] self                  A context2 instance.
 * @param[in] memory                Provide this memory for internal work.
 * @param[in] msize                 Memory size, unit in ctx_char_t(not byte).
 * @param[in] sentinel              re2c sentinel character.
 */
void context2_init(context2 *self, ctxx_char_t *memory, int msize, ctxx_char_t sentinel);

/**
 * @brief Get current free space size of the working buffer.
 * 
 * It should be used after self has initialized.
 * The return value is always >= 0.
 * 
 * @param[in] self      A context2 instance.
 * 
 * @return int          Current free space size.
 */
int context2_get_free_size(context2 *self);

/**
 * @brief Fill block(s) to working buffer.
 * 
 * It should be used after self has initialized.
 * It should do refill only when lexer interrupt(need more input) happened.
 * 
 * Block size should satisfiy:
 *   1, (0 <= size && size <= self->get_free_size(self)).
 *   2, do not fill sentinel-character at block[size-1].
 *      (because context2 will append one in the working buffer.)
 * 
 * @param[in] self      A context2 instance.
 * @param[in] block     Block will copy to working buffer.
 * @param[in] size      Block size, unit in ctxx_char_t(not byte).
 * 
 * @return 0            Ok.
 * @return not 0        Error.
 */
int context2_fill(context2 *self, const ctxx_char_t *block, int size);

/**
 * @brief Skip current token(backup next token position).
 * 
 * It should be used after self has initialized.
 * 
 * @param[in] self      A context2 instance.
 */
void context2_skip(context2 *self);

/**
 * @brief Reset lexer state to initial state.
 * 
 * It should be used after self has initialized.
 * 
 * @param[in] self      A context2 instance.
 */
void context2_reset(context2 *self);

/**
 * @brief Get current token c str from lexer.
 * 
 * It should be used after self has initialized.
 * It should be used after lexer has hit a rule.
 * Token length will be: (0 <= length) && (length <= YYLENG_SIZE_MAX).
 * 
 * @param[in] self      A context2 instance.
 * @return ctx_char_t*  Token c str.
 */
const ctxx_char_t* context2_yytext(context2 *self);

/**
 * @brief Get current token str length(without string terminator) from lexer.
 * 
 * It should be used after self has initialized.
 * It should be used after lexer has hit a rule.
 * Return token length is: (0 <= length) && (length <= YYLENG_SIZE_MAX)
 * 
 * @param[in] self  A context2 instance.
 * 
 * @return int      Token str length.
 */
int context2_yyleng(context2 *self);

#endif //_CONTEXT2_
