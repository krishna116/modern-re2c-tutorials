# <a id="ReadingUtf8">Read utf8 text.</a>
When read utf8 text follow things should be done:
 1. Provide this re2c configuration.     
    ```
    re2c:define:YYCTYPE = uint8_t;
    re2c:flags:utf-8 = 1;
    ```
 2. You also need change all types of your pointers(which point to your utf8 text buffer) to the same type as uint8_t.
 3. Your input-text-buffer should be utf8-encoded. 
 4. Your regex in the re2c rules should be utf8-encoded, however, you do not need adjust it if you know the source file is already utf8-encoded.
 5. When compile your_file.lex, append this option **--input-encoding utf8** to re2c.exe

> **uint8_t** can be custom 1 byte typedef if you do not have this type. 

> The full source file is project/tests/test12.lex