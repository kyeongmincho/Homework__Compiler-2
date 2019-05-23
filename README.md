# Program Assignment #2

## 과제 개요

- 본 프로젝트는 2019학년도 1학기 컴파일러 실습 과제입니다.
- 주제: Infix representation 사칙연산을 계산합니다.

## 개발 환경

- OS: Mac OS X 10.12.6 (Darwin Kernel Version 16.7.0)
- Language:
	- Lex
	- Yacc
	- C
- Compiler:
	- flex 2.6.4
	- bison (GNU Bison) 3.4
	- gcc-7 (Homebrew GCC 7.3.0_1) 7.3.0

## 빌드

`flex`와 `bison`을 이용하여 렉서와 파서의 C 소스코드를 생성하고 이를 빌드합니다.
```
$ flex calc.l
$ bison -d calc.y
$ gcc -o calc calc.tab.c lex.yy.c
```

## 실행

만들어진 `calc` 실행파일은 표준 입력으로 입력을 받고 표준 출력으로 수식의 계산값을 출력하기를 반복합니다.

### 예시
```
$ ./calc
2-(3+5);
-6
2 + (6 * 3);
20
(3 + 2)*2 + 5;
15
2.0E-2+0.5;
0.52
5+10
syntax error
```

## 프로그램 순서도

![플로우 차트](https://firebasestorage.googleapis.com/v0/b/cin-fail-v2.appspot.com/o/flowchart2.png?alt=media&token=4fe6ba39-723a-4a35-982a-df0bb3224492)

## calc.y의 rule

이 프로그램은 `calc.y`에 기재된 파싱 규칙들에 의해 동작합니다. 이 규칙들은 크게 `lines`, `stmt`, `expr`로 구성되어 있습니다.

### lines

```
lines : /* empty */
      | lines '\n'
      | lines stmt
      ;
```

lines는 한 줄이 어떻게 구성되어 있는지를 나타냅니다. basis case는 아무 것도 없는 빈 줄입니다. 그리고 재귀적으로 lines와 개행으로 이루어진 줄이거나 lines와 stmt로 이루어진 줄입니다. stmt 룰은 아래에 기술합니다.

### stmt

```
stmt : expr ';'            { printf("%g\n", $1); }
     ;
```

stmt는 수식이 세미콜론을 통해 구분된다는 것을 나타내는 규칙입니다. 즉 세미콜론을 수식의 구분기호로 삼아 세미콜론을 기준으로 수식들이 구분되어 계산됩니다. 이렇게 계산된 계산값은 표준 출력으로 출력됩니다. 세미콜론으로 구분한다는 특성을 이용하여 아래와 같이 한줄에 여러 수식을 계산하는 것도 가능합니다:

```
$ ./calc
3+5;2 + (6 * 3);
8
20
```

### expr

```
expr : NUMBER
     | expr '+' expr       { $$ = $1 + $3; }
     | expr '-' expr       { $$ = $1 - $3; }
     | expr '*' expr       { $$ = $1 * $3; }
     | expr '/' expr       { $$ = $1 / $3; }
     | '(' expr ')'        { $$ = $2; }
     | '-' expr %prec UMINUS { $$ = - $2; }
     ;
```

`expr`은 실제 infix 수식이 이루어진 형태를 나타내는 규칙입니다. 과제에서 심볼 처리는 요구사항이 아니므로 터미널은 오직 `NUMBER` 토큰 뿐입니다. 기본적인 사칙연산과 마이너스 기호에서 발생할 수 있는 연산자 우선순위의 애매성은 코드 상단에

```
%left '+' '-'  
%left '*' '/'  
%right UMINUS
```

를 기술함으로써 명확히 할 수 있습니다.
