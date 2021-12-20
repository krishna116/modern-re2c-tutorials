# <a id="ReadingUcs2">Read ucs2 text.</a>
The ucs2 is fixed-2-byte-size for code-point, when read ucs2 text follow things should be done:
 1. Provide this re2c configuration.
    ```
    re2c:define:YYCTYPE     = uint16_t;
    re2c:flags:wide-chars   = 1;
    ```
 2. You also need change all types of your pointers(which point to your ucs2 text buffer) to the same type as uint16_t.
 3. Your input-text-buffer should be ucs2 encoded(little-endian).
 4. Your regex in the re2c rules should be ucs2 encoded, but some ASCII-chars regex seems do not need adjust such as \[0-9] \[a-zA-Z].
 5. When compile your_file.lex, append this option **--wide-chars** to re2c.exe

> **uint16_t** can be custom 2 byte typedef if you do not have this type.

> The full source file is project/tests/test13.lex