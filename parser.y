%{
#include <math.h>
#include <stdio.h>
#define YYDEBUG 1

// From main.c
extern int main(void);
extern void print(long int i);
extern int yylex(void);
extern long int prev;

int yyerror(char *msg);
%}

%union {
  long int i;
  int token;
}

%token <i> NUM;
%token NEWLINE;
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

program : stmts {}
        | %empty {}
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
  fprintf(stderr, "yyerror: %s\n\n%c\n", msg, yychar);
  return 0;
}
