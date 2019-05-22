%{
#include <stdio.h>
void yyerror(char *);
int yylex(void);
%}

%union  {
                double dval;
                int vblno;
        }
%token <dval> NUMBER
%token IDENTIFIER OPERATOR WHITESPACE END OTHER
%left '+' '-'
%left '*' '/'
%right UMINUS
%type <dval> expr

%%

lines:
    lines stmt '\n'
    | lines '\n'
    | /* empty */
    ;

stmt:
    expr ';'              { printf("%lf\n", $1); }
    ;

expr: NUMBER
    | expr '+' expr       { $$ = $1 + $3; }
    | expr '-' expr       { $$ = $1 - $3; }
    | expr '*' expr       { $$ = $1 * $3; }
    | expr '/' expr       {
                            if($3 == 0.0)
                                yyerror("divide by zero");
                            else
                                $$ = $1 /$3;
                          }
    | '(' expr ')'        { $$ = $2; }
    | '-' expr %prec UMINUS { $$ = - $2; }
    ;

%%

void yyerror(char *s)
{
  printf("%s\n", s);
}

int main(void)
{
  yyparse();
  return 0;
}