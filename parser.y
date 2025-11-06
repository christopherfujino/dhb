%{
#include <stdio.h>

extern int yylex(void);
int yyerror(char *msg);
%}

%union {
  long int i;
  int token;
}

%token <i> NUM;
%token PLUS;
%type <i> expr;
%type <i> primary;

%start program

%%

program : expr {
  printf("%ld\t0x%lX\t0b%lb\n", $1, $1, $1);
}
        ;

expr :
     primary PLUS primary { $$ = $1 + $3; }
     | primary { $$ = $1; }
     ;

primary : NUM { $$ = $1; }
        ;

%%

int yyerror(char *msg) {
  fprintf(stderr, "yyerror: %s\n", msg);
  return 0;
}

int main() {
  yyparse();
  printf("End.\n");
}

int yywrap() {
  printf("YYWRAP\n");
  return 1;
}
