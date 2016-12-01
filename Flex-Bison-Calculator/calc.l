%option noyywrap

%{
#include <stdio.h>

#define YY_DECL int yylex()



%}

    /*===== DEFINITIONS =====*/

VarChar                         [_[:alpha:][:digit:]]
VarInitChar                     [_[:alpha:]]

%%
{VarInitChar}{VarChar}          {yylval.val= yytext; return VAR;}
[ \t]	;
[0-9]+(\.[0-9]+)? 	            {yylval.val = atof(yytext); return NUM;}
\n		    	                {return ENTER;}
"+"		    	                {return '+';}
"-"		    	                {return '-';}
"*"		    	                {return '*';}
"/"		    	                {return '/';}
"("		    	                {return '(';}
")"		    	                {return ')';}
"="                             {return '=';}
"exit"	    	                {return EXIT;}

%%