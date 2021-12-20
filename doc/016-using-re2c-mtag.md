# <a id="ReadingMtag">Using re2c mtag.</a>  
re2c mtags are also place-holders. mtag will be inserted directly in the **regex expression**. In order to use mtags follow things should be done.  
  1. Provide this define before re2c lexer block(you may need adjust the char type).
      ```
      /*!mtags:re2c format = 'const char* @@;'; */
      ```
  2. Provide your mtag holders.
      ```
      const char *YYMARKER;
      const char *a1 = NULL;
      const char *a2 = NULL;
      const char *b1 = NULL;
      const char *b2 = NULL;
      ```
  3. Provide this configuration in re2c lexer block.
      ```
      re2c:flags:tags = 1;
      re2c:define:YYMTAGP = "@@{tag} = YYCURSOR;";
      re2c:define:YYMTAGN = "@@{tag} = NULL;";
      re2c:api:style      = free-form;
      ```
  4. Define regex pattern using **mtag**s .
      ```
      keyAndValue = #a1 [a-zA-z]+ #a2 [ ]* "=" [ ]*  #b1 ([a-zA-Z0-9] | '-' | '_')+ #b2 [ ]* ";" [ \r\n]* ;

      ```
  5. Using the **regex pattern** in your rule and access the **mtag**s in the code. For example:
      ```
      keyAndValue {
      printf("[v]\n");
      print("  key =", a1, a2);
      print("  val =", b1, b2);
      continue;
      }
      ```
  6. When compile your_file.lex, append this option **--tags** to re2c.exe  

> The full source file is project/tests/test16.lex
