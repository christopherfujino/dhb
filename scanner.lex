/* Header code */
%{
  #include <unistd.h> // isatty()
  #include "parser.tab.h"

  // include-ing readline.h breaks the parser?!
  extern char *readline(const char *);
  extern void add_history(const char *);

  #define YY_INPUT(buf, result, max_size) result = readInput(buf, max_size);

  static int readInput(char *buf, int size) {
    if (isatty(STDIN_FILENO)) {
      char *line;
      if (feof(yyin)) {
        return YY_NULL;
      }
      line = readline("> ");
      if (line == 0) {
        return YY_NULL;
      }
      size_t len = strlen(line);
      // -2 for newline and NULL
      if (len > (size - 2)) {
        fprintf(stderr,"input line too long\n");
        return YYerror;
      }
      memcpy(buf, line, len);
      buf[len] = '\n';
      buf[len + 1] = 0x0;
      add_history(line);
      free(line);
      return strlen(buf);
    } else {
      // this will include trailing newline
      char *maybeNull = fgets(buf, size - 1, stdin);
      if (maybeNull == 0) {
        return YY_NULL;
      }
      size_t len = strlen(buf);
      // -2 for newline and NULL
      // >= because fgets would truncate too long input
      if (len >= (size - 2)) {
        fprintf(stderr,"input line too long\n");
        return YYerror;
      }
      return len;
    }
  }

%}

%option noyywrap

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
