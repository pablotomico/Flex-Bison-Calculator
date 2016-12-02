%option noyywrap

%{
#include <stdio.h>
#include <string.h>

#include "calc.h"
#include "grammar.tab.h"

#define YY_DECL int yylex()


void show_help();
void restart();
void clear(symrec *s);
symrec *s;

%}

    /*===== DEFINITIONS =====*/

VarChar                         [_[:alpha:][:digit:]]
VarInitChar                     [_[:alpha:]]

    /*START CONDITIONS*/
%x HELP
%%
":"	    	                            {BEGIN(HELP);}
<HELP>{
    [hH]                                {show_help(); BEGIN(INITIAL);}
    [fF]                                {show_functions(); BEGIN(INITIAL);  }
    [vV]                                {show_variables(); BEGIN(INITIAL);  }
    [qQ]                                {printf("Good bye!\n"); BEGIN(INITIAL); return EXIT;}
    [rR]                                {restart();BEGIN(INITIAL);}
    [lL]" "[[:alpha:]/\-_]+[.?[[:alpha:]]+]?    {

                                            FILE* fp = fopen(yytext+2, "r+");
                                            if(!fp){
                                                printf("Error loading file\n");
                                                yyin=stdin;
                                            }else{
                                                yyin = fp;
                                                printf("Loading file %s\n", yytext+2);
                                            }
                                            BEGIN(INITIAL);
                                        }
}
{VarInitChar}{VarChar}*                 {
                                            s = getsym(yytext);
                                            if(s == 0){
                                                s = putsym(yytext, VAR, 'w');
                                            }
                                            yylval.tptr = s;
                                            return s->type;
                                        }
[ \t\r]
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
"^"                                     {return '^';}
";"                                     {return ';';}
">"                                     {return(GREATER);}
"<"                                     {return(LESS);}
"++"                                    {return(PLUSPLUS);}
"--"                                    {return(MINUSMINUS);}
"=="                                    {return(EQUALEQUAL);}
">="                                    {return(GREATEREQUAL);}
"<="                                    {return(LESSEQUAL);}
"!="                                    {return(NOTEQUAL);}
"+="                                    {return(PLUSEQUAL);}
"-="                                    {return(MINUSEQUAL);}
"*="                                    {return(MULTEQUAL);}
<<EOF>>                                 {printf("End of File\n");fclose(yyin);yyin=stdin;yyrestart(yyin);BEGIN(INITIAL);return ENTER;}
%%





void show_help(){
    printf(" -----------------------------------\n");
    printf("| Supported commands:               |\n");
    printf("|      :h        -> help            |\n");
    printf("|      :l [path] -> load file       |\n");
    printf("|      :f        -> show functions  |\n");
    printf("|      :v        -> show variables  |\n");
    printf("|      :r        -> restart         |\n");
    printf("|      :q        -> quit            |\n");
    printf(" -----------------------------------\n");
    printf("| Operators:                        |\n");
    printf("|  +  -  *  /  =    += -= *= ++ --  |\n");
    printf("|     ==    >=    <=    >    <      |\n");
    printf("|     True => 0     False => 1      |\n");
    printf(" -----------------------------------\n");
}

void restart(){
    symrec s = *sym_table;
    remove_table();

    //init_table();
}