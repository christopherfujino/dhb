/* Header code */
%{
  #include "parser.tab.hpp"

  const size_t MAX_LENGTH = 128;
  char buffer[MAX_LENGTH];
%}

%option noyywrap

%%

0x[0-9a-f]+ {
  yylval.i = strtol(yytext, 0x0, 0);
  return NUM;
}

0b[01]+ {
  yylval.i = strtol(yytext, 0x0, 2);
  return NUM;
}

[1-9][0-9]* {
  yylval.i = strtol(yytext, 0x0, 10);
  return NUM;
}

"+" {
  return PLUS;
}

[ \t\r\n]  ;

%%
