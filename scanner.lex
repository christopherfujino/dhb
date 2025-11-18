/* Header code */
%{
  #include "parser.tab.h"

  #include <readline/history.h>
  #include <readline/readline.h>

  #define YY_INPUT(buf, result, max_size) result = mygetinput(buf, max_size);

  static int mygetinput(char *buf, int size) {
    char *line;
    if (feof(yyin))  return YY_NULL;
    line = readline("> ");
    if(!line)        return YY_NULL;
    if(strlen(line) > size-2){
       fprintf(stderr,"input line too long\n"); return YY_NULL; }
    sprintf(buf,"%s\n",line);
    free(line);
    return strlen(buf);
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
  printf("Scanned decimal %ld\n", yylval.i);
  return NUM;
}

"$" { return DOLLAR; }
"+" { printf("Scanned +\n"); return PLUS; }
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
