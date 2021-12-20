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
 * @brief This is a context used for re2c lexer.
 * 
 * It wraps some conventional functions for working with one-shot-buffer.
 * 
 */

#ifndef _CONTEXT_
#define _CONTEXT_

#include "config.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef struct context_ context;

//
// Public api.
//
typedef void (*CONTEXT_INIT)(context *self, ctxx_char_t *memory, int msize, ctxx_char_t sentinel);
typedef void (*CONTEXT_SKIP)(context *self);
typedef void (*CONTEXT_RESET)(context *self);

#if USING_YYTEXT
    typedef const ctxx_char_t* (*CONTEXT_YYTEXT)(context *self);
    typedef int (*CONTEXT_YYLENG)(context *self);
#endif //USING_YYTEXT

struct context_
{
//public:
    CONTEXT_SKIP    skip;    ///< skip current token.
    CONTEXT_RESET   reset;   ///< reset lexer state to initial state.
//private:
    const ctxx_char_t *_memory; ///< working buffer.
    int _msize;                 ///< working buffer size.
    int _init;                  ///< working buffer has init(1) or not(0).
    ctxx_char_t _sentinel;      ///< lexer sentinel character.
    const ctxx_char_t *_curser; ///< lexer curser snapshot.
    const ctxx_char_t *_token;  ///< lexer token snapshot.
    const ctxx_char_t *_marker; ///< lexer used to cache the current input position.
    const ctxx_char_t *_limit;  ///< lexer limit snapshot.
    int _state;                 ///< lexer state snapshot.

#if USING_YYTEXT
//public:
    CONTEXT_YYTEXT  yytext;  ///< get current token str from lexer.
    CONTEXT_YYLENG  yyleng;  ///< get current token str length from lexer.
//private:
    ctxx_char_t _yytextBuf[YYLENG_SIZE_MAX+1];  ///< current token buffer.
    const ctxx_char_t *_yytext;                 ///< cache current token start position.
    int _yyleng;                                ///< cache current token size.
#endif //USING_YYTEXT
};

/**
 * @brief Initialize a one shot context.
 * 
 * In this one shot mode:
 *   1, the memory provided should be full of user date.
 *   2, the memory[msize - 1] should be the sentinel.
 * 
 * It is user's responsibility to provide the memory.
 * It is user's responsibility to free the memory after lexer work end.
 * The memory's life time should longer than the lexer's life time.
 * The sentinel is re2c sentinel character.
 * 
 * @param[in] self                  A context instance.
 * @param[in] memory                Provide this memory for internal work.
 * @param[in] msize                 Memory size, unit in ctxx_char_t(not byte).
 * @param[in] sentinel              re2c sentinel character.
 */
void context_init(context *self, const ctxx_char_t *memory, int msize, ctxx_char_t sentinel);

/**
 * @brief Skip current token(backup next token position).
 * 
 * It should be used after self has initialized.
 * 
 * @param[in] self      A context instance.
 */
void context_skip(context *self);

/**
 * @brief Reset lexer state to initial state.
 * 
 * It should be used after self has initialized.
 * 
 * @param[in] self      A context instance.
 */
void context_reset(context *self);

/**
 * @brief Get current token c str from lexer.
 * 
 * It should be used after self has initialized.
 * It should be used after lexer has hit a rule.
 * Token length will be: (0 <= length) && (length <= YYLENG_SIZE_MAX).
 * 
 * @param[in] self      A context instance.
 * @return context_char_t*  Token c str.
 */
const ctxx_char_t* context_yytext(context *self);

/**
 * @brief Get current token str length(without string terminator) from lexer.
 * 
 * It should be used after self has initialized.
 * It should be used after lexer has hit a rule.
 * Return token length is: (0 <= length) && (length <= YYLENG_SIZE_MAX)
 * 
 * @param[in] self  A context instance.
 * 
 * @return int      Token str length.
 */
int context_yyleng(context *self);

#ifdef __cplusplus
}
#endif

#endif //_CONTEXT_
