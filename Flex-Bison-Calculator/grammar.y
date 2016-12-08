%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "errorManager.h"
#include "symbolTable.h"


extern int yylex();
extern int yyparse();
extern FILE* yyin;
void yyerror(const char* s);
void updateAns(double val);
void showInitializationWarning(char* name);


%}
%error-verbose

%union {
	double val;
	tree *tptr;
}

%token  <val> NUM
%token  <tptr> VAR
%token  <tptr> UFNC
%token '+' '*' '/' '(' ')'
%token PLUSPLUS MINUSMINUS EQUALEQUAL GREATEREQUAL LESSEQUAL NOTEQUAL PLUSEQUAL MINUSEQUAL MULTEQUAL DIVEQUAL GREATER LESS '|' '&'
%token ENDOFLINE EXIT ';'


%type<val> exp

%right '='
%left '|' '&'
%left '+' '-' PLUSPLUS MINUSMINUS EQUALEQUAL GREATEREQUAL LESSEQUAL NOTEQUAL PLUSEQUAL MINUSEQUAL MULTEQUAL DIVEQUAL GREATER LESS
%left '*' '/'
%left NEG
%right '^'


%start calc

%%

calc:
	   | calc line
;

line: ENDOFLINE
    | exp ';' ENDOFLINE  { updateAns($1);}
    | exp ENDOFLINE { updateAns($1);printf("%s  %g\n", KBLU, $1); printf("%s", RST);}
    | EXIT ENDOFLINE { exit(0); }
;

exp:    NUM                 { $$ = $1;      }
      | VAR                 {
                                if($1->decl == 'n'){
                                    showInitializationWarning($1->name);
                                    $1->decl = 'y';
                                }
                                $$ = $1->value.var;
                            }
      | exp '|' exp         { if(($1 == 1) || ($3 == 1)) $$ = 1; else $$ = 0;}
      | exp '&' exp         { if(($1 == 1) && ($3 == 1)) $$ = 1; else $$ = 0;}
      | exp EQUALEQUAL exp  { if($1 == $3) $$ = 1; else $$ = 0;}
      | exp GREATEREQUAL exp{ if($1 >= $3) $$ = 1; else $$ = 0;}
      | exp LESSEQUAL exp   { if($1 <= $3) $$ = 1; else $$ = 0;}
      | exp NOTEQUAL exp    { if($1 != $3) $$ = 1; else $$ = 0;}
      | exp GREATER exp     { if($1 > $3) $$ = 1; else $$ = 0;}
      | exp LESS exp        { if($1 < $3) $$ = 1; else $$ = 0;}
      | UFNC '=' exp        {printf("Reserved word %s\n", $1->name); return 0;}
      | VAR '=' exp         {
                                $$ = $3;

                                if($1->priv == 'w'){
                                    $1->decl = 'y';
                                    $1->value.var = $3;
                                }else{
                                    printf("You can't override a constant value!\n");
                                    return 0;
                                }

                            }
      | UFNC '(' exp ')'    { $$ = (*($1->value.fnctptr))($3); }
      | VAR PLUSPLUS        {
                                if($1->decl == 'n'){
                                    showInitializationWarning($1->name);
                                    $1->decl = 'y';
                                }
                                $$ = $1->value.var + 1;
                                $1->value.var = $1->value.var + 1;
                            }
      | VAR MINUSMINUS      {
                                if($1->decl == 'n'){
                                    showInitializationWarning($1->name);
                                    $1->decl = 'y';
                                }
                                $$ = $1->value.var - 1;
                                $1->value.var = $1->value.var - 1;
                            }
	  | VAR PLUSEQUAL exp	{
	                            if($1->decl == 'n'){
                                    showInitializationWarning($1->name);
                                    $1->decl = 'y';
                                }
	                            $$ = $1->value.var + $3;
	                            $1->value.var = $1->value.var + $3;
	                        }
	  | VAR MINUSEQUAL exp	{
	                            if($1->decl == 'n'){
                                    showInitializationWarning($1->name);
                                    $1->decl = 'y';
                               }
	                            $$ = $1->value.var - $3;
	                            $1->value.var = $1->value.var - $3;
	                        }
	  | VAR MULTEQUAL exp	{
	                            if($1->decl == 'n'){
                                    showInitializationWarning($1->name);
                                    $1->decl = 'y';
                                }
	                            $$ = $1->value.var * $3;
	                            $1->value.var = $1->value.var * $3;
	                        }
	  | VAR DIVEQUAL exp	{
	                            if($1->decl == 'n'){
                                    showInitializationWarning($1->name);
                                    $1->decl = 'y';
                                }
	                            if($3 == 0){
	                                divisionByZero();
	                                return 0;
	                            }
	                            $$ = $1->value.var / $3;
	                            $1->value.var = $1->value.var / $3;
	                        }
	  | exp '+' exp	        { $$ = $1 + $3; }
	  | exp '-' exp	        { $$ = $1 - $3; }
	  | exp '*' exp         { $$ = $1 * $3; }
	  | exp '/' exp		    {
	                            if($3 == 0){
                                    divisionByZero();
                                    return 0;
	                            }
	                            $$ = $1 / (double)$3;
	                        }
      | '-' exp %prec NEG   { $$ = -$2;}
      | exp '^' exp         { $$ = pow ($1, $3);}
	  | '(' exp ')'		    { $$ = $2; }
;


%%

void updateAns(double val){
    tree* s = getsym("Ans");
    s->value.var = val;
}

void showInitializationWarning(char* name){
    char msg[60];
    sprintf(msg, "No previous declaration of var '%s', assigned to 0", name);
    showWarning(msg);
}