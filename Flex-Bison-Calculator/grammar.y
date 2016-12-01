%{
#include <stdio.h>
#include <stdlib.h>
extern int yylex();
extern int yyparse();
extern FILE* yyin;
void yyerror(const char* s);
%}

%union {
	float val;
}


%token<val> NUM
%token '+' '*' '/' '(' ')'
%token ENTER EXIT
%left '+' '-'
%left '*' '/'

%type<val> exp

%start calc

%%

calc:
	   | calc line
;

line: ENTER
    | exp ENTER { printf("%g\n", $1); }
    | EXIT ENTER { printf("exiting...\n"); exit(0); }
;

exp: NUM                    { $$ = $1; }
	  | exp '+' exp	        { $$ = $1 + $3; }fval
	  | exp '-' exp	        { $$ = $1 - $3; }
	  | exp '*' exp         { $$ = $1 * $3; }
	  | exp '/' exp		    { $$ = $1 / (float)$3; }
	  | '(' exp ')'		    { $$ = $2; }
;


%%
