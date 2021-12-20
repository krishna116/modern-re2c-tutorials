# Modern re2c tutorials.
[000-introduction.](doc/000-introduction.md)  
[001-a minimal example.](doc/001-a-minimal-example.md)  
[002-handle end of stream with one sentinel.](doc/002-handle-end-of-stream-with-one-sentinel.md)  
[003-handle end of stream if more sentinels exist.](doc/003-handle-end-of-stream-if-more-sentinels.md)  
[004-how to get tokens.](doc/004-how-to-get-tokens.md)  
[005-get tokens in sync mode with one shot buffer.](doc/005-get-tokens-sync-one-shot.md)  
[006-get tokens in async mode with one shot buffer.](doc/006-get-tokens-async-one-shot.md)  
[007-experience re2c api used for multi shot buffer.](doc/007-experience-the-re2c-api-used-for-multi-shot-buffer.md)  
[008-get tokens in sync mode with multi shot buffer.](doc/008-get-tokens-sync-multi-shot.md)  
[009-get tokens in async mode with multi shot buffer.](doc/009-get-tokens-async-multi-shot.md)  
[010-using re2c condition.](doc/010-using-re2c-condition.md)  
[011-using re2c condition v2.](doc/011-using-re2c-condition-v2.md)  
[012-read utf8 text.](doc/012-read-utf8-text.md)  
[013-read ucs2 text.](doc/013-read-ucs2-text.md)  
[014-read utf32 text.](doc/014-read-ucs4-utf32-text.md)  
[015-using re2c stag.](doc/015-using-re2c-stag.md)  
[016-using re2c mtag.](doc/016-using-re2c-mtag.md)  
 
# Build and test.
1, Install [re2c](https://github.com/skvadrik/re2c) tool(used to compile this project).  
2, git clone this repository.  
3, Build and test.
```
cmake -S . -B build
cmake --build build
ctest --test-dir build
## test one item
ctest --test-dir build -V -R <item>
```


