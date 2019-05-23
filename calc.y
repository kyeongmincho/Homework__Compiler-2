%{
#include <stdio.h>
void yyerror(char *);
int yylex(void);
%}

/* yylval에 double을 담기 위한 union */
%union  {
                double ldouble;
                int lsym;
        }

%token <ldouble> NUMBER
%token IDENTIFIER OTHER

/* 연산자 우선순위의 오름차순 */
%left '+' '-'
%left '*' '/'
%right UMINUS

%type <ldouble> expr

%%

lines : lines stmt
      | lines '\n'
      | /* empty */
      ;

stmt : expr ';'            { printf("%g\n", $1); }
     ;

expr : NUMBER
     | expr '+' expr       { $$ = $1 + $3; }
     | expr '-' expr       { $$ = $1 - $3; }
     | expr '*' expr       { $$ = $1 * $3; }
     | expr '/' expr       { $$ = $1 / $3; }
     | '(' expr ')'        { $$ = $2; }
     | '-' expr %prec UMINUS { $$ = - $2; }
     ;

%%

/* error 내용을 출력 */
void yyerror(char *s)
{
  printf("%s\n", s);
}

/* 에러가 나기 전까지 수식 계산을 반복 */
int main(void)
{
  yyparse();
  return 0;
}