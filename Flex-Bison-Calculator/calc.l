%option noyywrap

%{
#include <stdio.h>

#define YY_DECL int yylex()



%}

%%

[ \t]	; // ignore all whitespace
[0-9]+\.[0-9]+ 	{yylval.fval = atof(yytext); return T_FLOAT;}
[0-9]+		    {yylval.ival = atoi(yytext); return T_INT;}
\n		    	{return ENTER;}
"+"		    	{return '+';}
"-"		    	{return '-';}
"*"		    	{return '*';}
"/"		    	{return '/';}
"("		    	{return '(';}
")"		    	{return ')';}
"exit"	    	{return EXIT;}

%%