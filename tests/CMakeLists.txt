include(${CMAKE_SOURCE_DIR}/script/test_helper.cmake)

## add_test_target(LEX <re2c-lex-file> 
##                 DESC <test-description> 
##                 RE2C_OTHER_ARGS [<re2c-other-arguments>]
##                 LIBS [<Libraries>]
##                 INCLUDES [<library-include-dirs>]
## )
add_test_target(LEX test01.lex DESC "a minimal example")
add_test_target(LEX test02.lex DESC "handle end of stream using one sentinel character")
add_test_target(LEX test03.lex DESC "handle end of stream if more than one sentinel character exist")
add_test_target(LEX test04.lex DESC "get tokens inside lexer with one-shot-buffer")
add_test_target(LEX test05.lex DESC "get tokens outside lexer with one-shot-buffer")
add_test_target(LEX test06.lex DESC "get tokens outside lexer with one-shot-buffer v2")
add_test_target(LEX test07.lex DESC "experience the re2c api used for multi-shot-buffer" RE2C_OTHER_ARGS "--storable-state" )
add_test_target(LEX test08.lex DESC "get tokens inside lexer with multi-shot-buffer-blocks" RE2C_OTHER_ARGS "--storable-state" LIBS context2)
add_test_target(LEX test09.lex DESC "get tokens outside lexer with multi-shot-buffer-blocks" RE2C_OTHER_ARGS "--storable-state" LIBS context2)
add_test_target(LEX test10.lex DESC "using simple condition")
add_test_target(LEX test11.lex DESC "using simple condition v2" RE2C_OTHER_ARGS "--conditions")
add_test_target(LEX test12.lex DESC "read utf8 text" RE2C_OTHER_ARGS "--input-encoding" "utf8")
add_test_target(LEX test13.lex DESC "read ucs2 text" RE2C_OTHER_ARGS "--wide-chars")
add_test_target(LEX test14.lex DESC "read utf32 text" RE2C_OTHER_ARGS "--unicode")
add_test_target(LEX test15.lex DESC "using stag example" RE2C_OTHER_ARGS "--tags")
add_test_target(LEX test16.lex DESC "using mtag example" RE2C_OTHER_ARGS "--tags")
