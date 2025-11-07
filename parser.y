%{
#include <math.h>
#include <stdio.h>

extern int yylex(void);
int yyerror(char *msg);

void print(long int i) {
  if (i >= 32 && i <= 126) {
    printf("%ld\t0x%lX\t0b%lb\t'%c'\n> ", i, i, i, (char)i);
  } else {
    printf("%ld\t0x%lX\t0b%lb\n> ", i, i, i);
  }
}
%}

%union {
  long int i;
  int token;
}

%token <i> NUM;
%token NEWLINE;
%token END;
%token PLUS MINUS;
%token LEFT_SHIFT RIGHT_SHIFT;
%token POWER;
%token LPAREN RPAREN;
%type <i> expr;
%type <i> primary;

%left LEFT_SHIFT RIGHT_SHIFT;
%left PLUS MINUS;
%left POWER;

%start program

%%

program : stmts END {}
        ;

stmts : stmts expr NEWLINE { print($2); }
      | expr NEWLINE { print($1); }

expr :
     expr PLUS expr { $$ = $1 + $3; }
     | expr MINUS expr { $$ = $1 - $3; }
     | expr LEFT_SHIFT expr { $$ = $1 << $3; }
     | expr RIGHT_SHIFT expr { $$ = $1 >> $3; }
     | expr POWER expr { $$ = pow($1, $3); }
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
  printf("> ");
  yyparse();
}
