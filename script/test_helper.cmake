
function(Print msg)
set(color "green")
execute_process(COMMAND ${CMAKE_COMMAND} -E cmake_echo_color --${color} "${msg}")
endfunction()

function(PrintAndAssert msg)
set(color "red")
execute_process(COMMAND ${CMAKE_COMMAND} -E cmake_echo_color --${color} "${msg}")
message(FATAL_ERROR "")
endfunction()

## add_test_target(LEX <re2c-lex-file> 
##                 DESC <test-description> 
##                 RE2C_OTHER_ARGS [<re2c-other-arguments>] 
##                 LIBS [<Libraries>]
##                 INCLUDES [<library-include-dirs>]
## )
function(add_test_target)
    set(options OPTIONAL)
    set(oneValueArgs LEX  DESC)
    set(multiValueArgs RE2C_OTHER_ARGS INCLUDES LIBS)
    cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )

    ## input arguments check.
    if(NOT ARG_LEX OR NOT EXISTS "${CMAKE_CURRENT_LIST_DIR}/${ARG_LEX}")
        PrintAndAssert("re2c.exe input file is missing")
    endif()

    if(NOT ARG_DESC)
        PrintAndAssert("need a test decription.")
    endif()

    get_filename_component(fileBaseName  ${ARG_LEX} NAME_WE)

    ## print infomation.
    set(OUTPUT "-o")
    string(REPLACE ";" " " TEMP_STRING "${ARG_RE2C_OTHER_ARGS}")
    Print("> re2c.exe ${ARG_LEX} ${OUTPUT} re2c_gen_code/${fileBaseName}.c ${TEMP_STRING}")

    ## re2c.exe <file.lex> -o <file.c> <re2c-optional-args>
    set(generatedSourceFile "${CMAKE_CURRENT_LIST_DIR}/re2c_gen_code/${fileBaseName}.c")
    add_custom_command(
        OUTPUT ${generatedSourceFile}
        COMMAND re2c ${ARG_LEX} ${OUTPUT} ${generatedSourceFile} ${ARG_RE2C_OTHER_ARGS}
        DEPENDS ${ARG_LEX}
        WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
    )
    set_source_files_properties(${generatedSourceFile}
        PROPERTIES
            GENERATED TRUE
    )

    ## add cmake target.
    add_executable(${fileBaseName} 
        ${generatedSourceFile}
    )
    if(ARG_LIBS)
        target_link_libraries(${fileBaseName}
            PUBLIC
                ${ARG_LIBS}
        )
    endif()

    if(ARG_INCLUDES)
        target_include_directories(${fileBaseName}
            PUBLIC
                ${ARG_INCLUDES}
        )
    endif()

    ## tell where is the executable after build.
    add_custom_command(TARGET ${fileBaseName}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E echo "$<TARGET_FILE:${fileBaseName}>"
    )

    ## ctest
    add_test(NAME ${ARG_DESC} COMMAND ${fileBaseName})
endfunction()

## AddTarget(TARGETS aa bb DESTINATION ccc USING_DEBUG)
