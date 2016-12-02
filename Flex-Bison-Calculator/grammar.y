%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
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

%token  <val> NUM
%token  <tptr> VAR
%token  <tptr> UFNC
%token '+' '*' '/' '(' ')'
%token PLUSPLUS MINUSMINUS EQUALEQUAL GREATEREQUAL LESSEQUAL NOTEQUAL PLUSEQUAL MINUSEQUAL MULTEQUAL GREATER LESS
%token ENTER EXIT ';'


%type<val> exp

%right '='
%left '+' '-' PLUSPLUS MINUSMINUS EQUALEQUAL GREATEREQUAL LESSEQUAL NOTEQUAL PLUSEQUAL MINUSEQUAL MULTEQUAL GREATER LESS
%left '*' '/'
%left NEG
%right '^'


%start calc

%%

calc:
	   | calc line
;

line: ENTER
    | exp ';' ENTER  { ;}
    | exp ENTER { printf("%g\n", $1); }
    | EXIT ENTER { exit(0); }
;

exp:    NUM                 { $$ = $1;      }
      | VAR                 { $$ = $1->value.var;}
      | exp EQUALEQUAL exp  { if($1 == $3) $$ = 1; else $$ = 0;}
      | exp GREATEREQUAL exp{ if($1 >= $3) $$ = 1; else $$ = 0;}
      | exp LESSEQUAL exp   { if($1 <= $3) $$ = 1; else $$ = 0;}
      | exp NOTEQUAL exp    { if($1 != $3) $$ = 1; else $$ = 0;}
      | exp GREATER exp     { if($1 > $3) $$ = 1; else $$ = 0;}
      | exp LESS exp        { if($1 < $3) $$ = 1; else $$ = 0;}
      | UFNC '=' exp        {printf("Reserved word %s\n", $1->name); return 0;}
      | VAR '=' exp         {
                                $$ = $3;
                                if($1->priv == 'w')
                                    $1->value.var = $3;
                                else{
                                    printf("You can't override a constant value!\n");
                                    return 0;
                                }
                            }
      | UFNC '(' exp ')'    { $$ = (*($1->value.fnctptr))($3); }
      | VAR PLUSPLUS        { $$ = $1->value.var + 1; $1->value.var = $1->value.var + 1;}
      | VAR MINUSMINUS      { $$ = $1->value.var - 1; $1->value.var = $1->value.var - 1;}
	  | VAR PLUSEQUAL exp	{ $$ = $1->value.var + $3; $1->value.var = $1->value.var + $3;}
	  | VAR MINUSEQUAL exp	{ $$ = $1->value.var - $3; $1->value.var = $1->value.var - $3;}
	  | VAR MULTEQUAL exp	{ $$ = $1->value.var * $3; $1->value.var = $1->value.var * $3;}
	  | exp '+' exp	        { $$ = $1 + $3; }
	  | exp '-' exp	        { $$ = $1 - $3; }
	  | exp '*' exp         { $$ = $1 * $3; }
	  | exp '/' exp		    { $$ = $1 / (float)$3; }
      | '-' exp %prec NEG   { $$ = -$2;}
      | exp '^' exp         { $$ = pow ($1, $3);}
	  | '(' exp ')'		    { $$ = $2; }
;


%%
