%{
#include <stdio.h>
#include "main.h"
#include "value.h"

#define YYDEBUG 1

int yyerror(char *msg);
%}

%union {
  Value v;
  int token;
}

%token <v> NUM;
%token NEWLINE;
%token PLUS MINUS LEFT_SHIFT RIGHT_SHIFT MULT DIVIDE;
%token POWER;
%token LPAREN RPAREN;
%token DOLLAR;
%type <v> expr;
%type <v> primary;

%left LEFT_SHIFT RIGHT_SHIFT;
%left PLUS MINUS;
%left MULT DIVIDE;
%left POWER;

%start program

%%

program : stmts {}
        | %empty {}
        ;

stmts : stmts expr NEWLINE { prev = $2; print(prev); }
      | expr NEWLINE { prev = $1; print(prev); }
      ;

expr : expr PLUS expr { $$ = valueAdd($1, $3); }
     | expr MINUS expr { $$ = valueSubtract($1, $3); }
     | expr MULT expr { $$ = valueMultiply($1, $3); }
     | expr DIVIDE expr { $$ = valueDivide($1, $3); }
     | expr LEFT_SHIFT expr { $$ = valueLeftShift($1, $3); }
     | expr RIGHT_SHIFT expr { $$ = valueRightShift($1, $3); }
     | expr POWER expr { $$ = valuePower($1, $3); }
     | primary { $$ = $1; }
     ;

primary : NUM { $$ = $1; }
        | DOLLAR { $$ = prev; }
        | LPAREN expr RPAREN { $$ = $2; }
        ;

%%

int yyerror(char *msg) {
  fprintf(stderr, "yyerror: %s\n\n%c\n", msg, yychar);
  return 0;
}
