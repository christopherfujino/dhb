/* Header code */
%{
  #include "parser.tab.hpp"
%}

%%

0x[0-9a-f]+ {
  yylval.i = strtol(yytext, 0x0, 0);
  return NUM;
}

%%
