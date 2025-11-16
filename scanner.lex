/* Header code */
%{
  #include "parser.tab.hpp"

  #include <readline/history.h>
  #include <readline/readline.h>

  const size_t MAX_LENGTH = 128;
  char buffer[MAX_LENGTH];

  #define YY_INPUT(buf, result, max_size) {\
    char *line = readline("> ");\
    if (line != NULL) {\
      size_t len = strlen(line);\
      if ((len) >= max_size) {\
        fprintf(stderr, "TODO: implement length checking!\n");\
        exit(42);\
      }\
      strcpy(buf, line);\
      printf("scanned %ld bytes\n", len);\
      result = len;\
    } else {\
      result = YY_NULL;\
    }\
    free(line);\
  }
%}

%option C++ noyywrap

%%

0x[0-9a-fA-F]+ {
  yylval.i = strtol(yytext, 0x0, 0);
  return NUM;
}

0b[01]+ {
  yylval.i = strtol(yytext, 0x0, 2);
  return NUM;
}

0 {
  yylval.i = 0;
  return NUM;
}

[1-9][0-9]* {
  printf("Scanned decimal %s\n", yytext);
  yylval.i = strtol(yytext, 0x0, 10);
  return NUM;
}

"$" { return DOLLAR; }
"+" { return PLUS; }
"-" { return MINUS; }
"*" { return MULT; }
"/" { return DIVIDE; }
"^" { return POWER; }
"<<" { return LEFT_SHIFT; }
">>" { return RIGHT_SHIFT; }

"(" { return LPAREN; }

")" { return RPAREN; }

"\n" { return NEWLINE; }

[ \t\r]  ;

%%
