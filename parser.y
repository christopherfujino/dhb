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
%token NEWLINE;
%token END;
%token PLUS;
%token LEFT_SHIFT RIGHT_SHIFT;
%token LPAREN RPAREN;
%type <i> expr;
%type <i> primary;

%start program

%%

program : stmts END {printf("program\n");}
        ;

stmts : stmts expr NEWLINE {
  printf("%ld\t0x%lX\t0b%lb\n", $2, $2, $2);
      }
      | expr NEWLINE {
  printf("%ld\t0x%lX\t0b%lb\n", $1, $1, $1);
}

expr :
     primary PLUS primary { $$ = $1 + $3; }
     | primary LEFT_SHIFT primary { $$ = $1 << $3; }
     | primary RIGHT_SHIFT primary { $$ = $1 >> $3; }
     | primary { $$ = $1; }
     ;

primary : NUM { $$ = $1; }
        | LPAREN expr RPAREN { $$ = $2; }
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
