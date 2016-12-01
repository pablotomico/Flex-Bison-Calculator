%{
#include <stdio.h>
#include <stdlib.h>
#include "calc.h"
extern int yylex();
extern int yyparse();
extern FILE* yyin;
void yyerror(const char* s);
%}

%union {
	float val;
	symrec *tptr;
}

%token<val> NUM
%token <tptr> VAR
%token '+' '*' '/' '(' ')'
%token ENTER EXIT

%type<val> exp

%right '='
%left '+' '-'
%left '*' '/'
%left NEG
%right '^'


%start calc

%%

calc:
	   | calc line
;

line: ENTER
    | exp ENTER { printf("%g\n", $1); }
    | EXIT ENTER { printf("exiting...\n"); exit(0); }
;

exp: NUM                    { $$ = $1;      }
      | VAR                 { $$ = $1->value.var}
      | VAR '=' exp         { $$ = $3; $1->value.var = $3   }
	  | exp '+' exp	        { $$ = $1 + $3; }
	  | exp '-' exp	        { $$ = $1 - $3; }
	  | exp '*' exp         { $$ = $1 * $3; }
	  | exp '/' exp		    { $$ = $1 / (float)$3; }
      | '-' exp %prec NEG   { $$ = -$2;}
      | exp '^' exp         { $$ = pow ($1, $3);}
	  | '(' exp ')'		    { $$ = $2; }
;


%%
