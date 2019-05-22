%{
#include "calc.tab.h"
#include <stdlib.h>
#include <math.h>
void yyerror(char *);
%}

/* regexp definitions */
delim [ \t]
ws {delim}+
digit [0-9]
letter [A-Za-z]
id {letter}({letter}|{digit})*
integer (0|([1-9]{digit}*))
number {integer}(\.{digit}+)?((E|e)[+\-]?{digit}+)?
operator [-+()=/*\n]
semicolon [;]

%%

{number} { yylval.dval = atof(yytext); return NUMBER; }
{id} { return IDENTIFIER; }
{operator} { return *yytext; }
{ws} ;
{semicolon} { return *yytext; }
. { return OTHER; }

%%

int yywrap(void)
{
  return 1;
}