cmake_minimum_required(VERSION 3.20)

project(re2c-tutorials VERSION 0.1.0 LANGUAGES C CXX)

include(CTest)

add_library(context ${PROJECT_SOURCE_DIR}/src/context.c)
## USING_ASCII USING_UTF8 USING_UCS2 USING_UCS4
target_compile_definitions(context PUBLIC USING_ASCII=1)
target_include_directories(context PUBLIC ${PROJECT_SOURCE_DIR}/src)

add_library(context2 ${PROJECT_SOURCE_DIR}/src/context2.c)
## USING_ASCII USING_UTF8 USING_UCS2 USING_UCS4
target_compile_definitions(context2 PUBLIC USING_ASCII=1)
target_include_directories(context2 PUBLIC ${PROJECT_SOURCE_DIR}/src)

add_subdirectory(tests)
