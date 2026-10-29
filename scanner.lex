/* Header code */
%{
  #include <unistd.h> // isatty()
  #include "main.h"
  #include "value.h" // this must be before parser.tab.h
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
      if ((signed int)len > (size - 2)) {
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
      if ((signed int)len >= (size - 2)) {
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
  do {
    // will parse the leading 0x
    constexpr int base = 0;
    switch (mode) {
    case modeInt:
      yylval.v = valueOfInt(strtol(yytext, nullptr, base));
      return NUM;
    case modeFloat:
      fprintf(
        stderr,
        "Can't directly parse hex -> double (try parsing as decimal)\n"
      );
      abort();
    }
  } while(0);
}

0[bB][01]+ {
  switch (mode) {
  case modeInt:
    // strtol doesn't understand "0b" prefixes
    yylval.v = valueOfInt(strtol(yytext + 2, 0x0, 2));
    return NUM;
  case modeFloat:
      fprintf(
        stderr,
        "Can't directly parse binary -> double (try parsing as decimal)\n"
      );
      abort();
  }
}

0 {
  switch (mode) {
  case modeInt:
    yylval.v = valueOfInt(0);
    return NUM;
  case modeFloat:
    yylval.v = valueOfFloat(0.0);
    return NUM;
  }
}

[1-9][0-9]* {
  switch (mode) {
  case modeInt:
    yylval.v = valueOfInt(strtol(yytext, 0x0, 10));
    return NUM;
  case modeFloat:
    yylval.v = valueOfFloat(strtold(yytext, nullptr));
    return NUM;
  }
}

[0-9]+\.[0-9]+? {
  switch (mode) {
  case modeInt:
    fprintf(stderr, "Can't parse this in int mode\n");
    abort();
  case modeFloat:
    yylval.v = valueOfFloat(strtold(yytext, nullptr));
    return NUM;
  }
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
