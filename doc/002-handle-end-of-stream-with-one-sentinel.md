# <a id="HandleEofOne">Handle end of stream with one sentinel character.</a>

For C string such as `const char str[] = "hello-world"`, we know that there is a string terminator `\0` at the str buffer last available position. In order to handle the end-of-stream, we just need provide rule like this to handle end-of-stream is ok.
```
[\x00]  {   printf("meet end of rule.\n");
            return 0;
        }
```
The terminator `\0` is a string terminator in C/C++ world, but in re2c world, any char used to be the end-of-stream is called **sentinel** or **sentinel character**.  

This method used to handle end-of-stream has a drawback, because what if there are more sentinels `\0` in the stream? For example if string is `const char str[] = "hello \0 world \0"`, obviously, the lexer will stop and return at the middle of this string.

 > The full source file is project/tests/test02.lex 
