%option noyywrap

%{
#include <stdio.h>

#include "calc.h"

#define YY_DECL int yylex()

symrec *s;

%}

    /*===== DEFINITIONS =====*/

VarChar                         [_[:alpha:][:digit:]]
VarInitChar                     [_[:alpha:]]

%%
"exit"	    	                        {return EXIT;}
{VarInitChar}{VarChar}*                 {
                                            s = getsym(yytext);
                                            if(s == 0){
                                             s = putsym(yytext, VAR);
                                            }
                                            yylval.tptr = s;
                                            return s->type;
                                        }
[ \t]	;
[0-9]+(\.[0-9]+)? 	                    {yylval.val = atof(yytext); return NUM;}
[0-9]+([\.][0-9]*)?[eE][+-]?[0-9]+      {yylval.val = atof(yytext); return NUM;}
\n		    	                        {return ENTER;}
"+"		    	                        {return '+';}
"-"		    	                        {return '-';}
"*"		    	                        {return '*';}
"/"		    	                        {return '/';}
"("		    	                        {return '(';}
")"		    	                        {return ')';}
"="                                     {return '=';}


%%