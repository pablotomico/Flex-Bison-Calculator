%{
#include <stdio.h>
#include <stdlib.h>
extern int yylex();
extern int yyparse();
extern FILE* yyin;
void yyerror(const char* s);
%}

%union {
	int ival;
	float fval;
}

%token<ival> T_INT
%token<fval> T_FLOAT
%token '+' '*' '/' '(' ')'
%token ENTER EXIT
%left '+' '-'
%left '*' '/'

%type<ival> exp
%type<fval> m_exp

%start calc

%%

calc:
	   | calc line
;

line: ENTER
    | m_exp ENTER { printf("%f\n", $1);}
    | exp ENTER { printf("%i\n", $1); }
    | EXIT ENTER { printf("exiting...\n"); exit(0); }
;

m_exp: T_FLOAT                 		 { $$ = $1; }
	  | m_exp '+' m_exp	 { $$ = $1 + $3; }
	  | m_exp '-' m_exp	 { $$ = $1 - $3; }
	  | m_exp '*' m_exp { $$ = $1 * $3; }
	  | m_exp '/' m_exp	 { $$ = $1 / $3; }
	  | '(' m_exp ')'		 { $$ = $2; }
	  | exp '+' m_exp	 	 { $$ = $1 + $3; }
	  | exp '-' m_exp	 	 { $$ = $1 - $3; }
	  | exp '*' m_exp 	 { $$ = $1 * $3; }
	  | exp '/' m_exp	 { $$ = $1 / $3; }
	  | m_exp '+' exp	 	 { $$ = $1 + $3; }
	  | m_exp '-' exp	 	 { $$ = $1 - $3; }
	  | m_exp '*' exp 	 { $$ = $1 * $3; }
	  | m_exp '/' exp	 { $$ = $1 / $3; }
	  | exp '/' exp		 { $$ = $1 / (float)$3; }
;

exp: T_INT				{ $$ = $1; }
	  | exp '+' exp	{ $$ = $1 + $3; }
	  | exp '-' exp	{ $$ = $1 - $3; }
	  | exp '*' exp	{ $$ = $1 * $3; }
	  | '(' exp ')'		{ $$ = $2; }
;

%%
