%{
#include <stdio.h>

extern int yylex(void);
int yyerror(char *msg);
%}

%union {
  long int i;
}

%token <i> NUM;
%type <i> expr;

%start program

%%

program : expr {
  printf("%ld\t0x%lX\t0b%lb\n", $1, $1, $1);
}
        ;

expr : NUM { $$ = $1; }
     ;

%%

int yyerror(char *msg) {
  fprintf(stderr, "%s\n", msg);
  return 1;
}

int main() {
  yyparse();
  printf("Hello, world!\n");
}

int yywrap() {
  printf("YYWRAP\n");
  return 1;
}
