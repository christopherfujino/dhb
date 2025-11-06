%{
#include <stdio.h>

extern int yylex(void);
int yyerror(char *msg);

void print(long int i) {
  if (i >= 32 && i <= 126) {
    printf("%ld\t0x%lX\t0b%lb\t'%c'\n", i, i, i, (char)i);
  } else {
    printf("%ld\t0x%lX\t0b%lb\n", i, i, i);
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
%token LPAREN RPAREN;
%type <i> expr;
%type <i> primary;

%start program

%%

program : stmts END {}
        ;

stmts : stmts expr NEWLINE { print($2); }
      | expr NEWLINE { print($1); }

expr :
     primary PLUS primary { $$ = $1 + $3; }
     | primary MINUS primary { $$ = $1 - $3; }
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
}
