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

long int prev = 0;
%}

%union {
  long int i;
  int token;
}

%token <i> NUM;
%token NEWLINE;
%token END;
%token PLUS MINUS LEFT_SHIFT RIGHT_SHIFT MULT DIVIDE;
%token POWER;
%token LPAREN RPAREN;
%token DOLLAR;
%type <i> expr;
%type <i> primary;

%left LEFT_SHIFT RIGHT_SHIFT;
%left PLUS MINUS;
%left MULT DIVIDE;
%left POWER;

%start program

%%

program : stmts END {}
        ;

stmts : stmts expr NEWLINE { prev = $2; print(prev); }
      | expr NEWLINE { prev = $1; print(prev); }

expr :
     expr PLUS expr { $$ = $1 + $3; }
     | expr MINUS expr { $$ = $1 - $3; }
     | expr MULT expr { $$ = $1 * $3; }
     | expr DIVIDE expr { /* TODO: error handling */ $$ = $1 / $3; }
     | expr LEFT_SHIFT expr { $$ = $1 << $3; }
     | expr RIGHT_SHIFT expr { $$ = $1 >> $3; }
     | expr POWER expr { $$ = pow($1, $3); }
     | primary { $$ = $1; }
     ;

primary : NUM { $$ = $1; }
        | DOLLAR { $$ = prev; }
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
