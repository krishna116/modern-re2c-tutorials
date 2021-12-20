# <a id="ReadingUcs4">Read utf32 text.</a>
The utf32 is fixed-4-byte-encoding for unicode(ucs4) code-point, when read utf32 text follow things should be done:
 1. Provide this re2c configuration.
    ```
    re2c:define:YYCTYPE     = uint32_t;
    re2c:flags:unicode      = 1;
    ```
 2. You also need change all types of your pointers(which point to your ucs4 text buffer) to the same type as uint32_t.
 3. Your input-text-buffer should be utf32 encoded(little-endian).
 4. Your regex in the re2c rules should be utf32 encoded, but some ASCII-chars regex seems do not need adjust such as \[0-9] \[a-zA-Z].
 5. When compile your_file.lex, append this option **--unicode** to re2c.exe

> **uint32_t** can be custom 4 byte typedef if you do not have this type.

> The full source file is project/tests/test14.lex