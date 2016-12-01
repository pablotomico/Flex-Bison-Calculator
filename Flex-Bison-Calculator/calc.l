%option noyywrap

%{
#include <stdio.h>

#define YY_DECL int yylex()



%}

%%

[ \t]	; // ignore all whitespace
[0-9]+(\.[0-9]+)? 	{yylval.val = atof(yytext); return NUM;}
\n		    	{return ENTER;}
"+"		    	{return '+';}
"-"		    	{return '-';}
"*"		    	{return '*';}
"/"		    	{return '/';}
"("		    	{return '(';}
")"		    	{return ')';}
"exit"	    	{return EXIT;}

%%