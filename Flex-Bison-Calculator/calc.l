%option noyywrap

%{
#include <stdio.h>
#include <string.h>

#include "calc.h"
#include "grammar.tab.h"
#include "errorManager.h"

#define YY_DECL int yylex()


void show_help();
void show_operators();

tree *s;
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
    [oO]                                {show_operators();BEGIN(INITIAL);}
    [fF]                                {show_functions(); BEGIN(INITIAL);  }
    [vV]                                {show_variables(); BEGIN(INITIAL);  }
    [qQ]                                {printf("Good bye!\n"); BEGIN(INITIAL); return EXIT;}
    [rR]                                {printf("Restarting workspace\n");reset_table();BEGIN(INITIAL);}
    [lL].*                              {

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
    .*                                   {showError("Command not supported");BEGIN(INITIAL);}
    <<EOF>>                             {BEGIN(INITIAL);}
}
{VarInitChar}{VarChar}*                 {
                                            s = getsym(yytext);
                                            if(s == 0){
                                                s = putsym(yytext, VAR, 'w', 'n');
                                            }
                                            yylval.tptr = s;
                                            return s->type;
                                        }
[ \t\r]
[0-9]+(\.[0-9]+)? 	                    {yylval.val = atof(yytext); return NUM;}
[0-9]+([\.][0-9]*)?[eE][+-]?[0-9]+      {yylval.val = atof(yytext); return NUM;}
\n		    	                        {return ENDOFLINE;}
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
"|"                                     {return('|');}
"&"                                     {return('&');}
"||"                                     {return('|');}
"&&"                                     {return('&');}
"++"                                    {return(PLUSPLUS);}
"--"                                    {return(MINUSMINUS);}
"=="                                    {return(EQUALEQUAL);}
">="                                    {return(GREATEREQUAL);}
"<="                                    {return(LESSEQUAL);}
"!="                                    {return(NOTEQUAL);}
"+="                                    {return(PLUSEQUAL);}
"-="                                    {return(MINUSEQUAL);}
"*="                                    {return(MULTEQUAL);}
"/="                                    {return(DIVEQUAL);}
.                                       {;}
<<EOF>>                                 {printf("Reached EOF\n");fclose(yyin);yyin=stdin;yyrestart(yyin);return ENDOFLINE;}
%%





void show_help(){
    printf("%s", KBLU);
    printf(" -----------------------------------\n");
    printf("| Supported commands:               |\n");
    printf("|      :h        -> help            |\n");
    printf("|      :o        -> show operators  |\n");
    printf("|      :f        -> show functions  |\n");
    printf("|      :v        -> show variables  |\n");
    printf("|      :l [path] -> load file       |\n");
    printf("|      :r        -> reset           |\n");
    printf("|      :q        -> quit            |\n");
    printf(" -----------------------------------\n");
    printf("|               NOTE                |\n");
    printf("|    1 => TRUE       2 => FALSE     |\n");
    printf("|        Ans  =>  Last output       |\n");
    printf(" -----------------------------------\n");
    printf("%s", RST);
}



void show_operators(){
    printf("The available operators are:\n");
    printf("%s", KBLU);
    printf("\t[EXP]  + [EXP]  -> Sum two expressions\n");
    printf("\t[EXP]  - [EXP]  -> Subtract two expressions\n");
    printf("\t[EXP]  * [EXP]  -> Multiply two expressions\n");
    printf("\t[EXP]  / [EXP]  -> Divide two expressions\n");
    printf("\t[VAR]  = [EXP]  -> Assign expression to variable\n");
    printf("\t[VAR] += [EXP]  -> Assing variable value plus expression given to that variable\n");
    printf("\t[VAR] -= [EXP]  -> Assing variable value minus expression given to that variable\n");
    printf("\t[VAR] *= [EXP]  -> Assing variable value multiplied by expression given to that variable\n");
    printf("\t[VAR] /= [EXP]  -> Assing variable value divided by expression given to that variable\n");
    printf("\t[VAR] ++        -> Variable value plus one\n");
    printf("\t[VAR] --        -> Variable value minus one\n");
    printf("\t[EXP] == [EXP]  -> Check if expressions are the same\n");
    printf("\t[EXP] != [EXP]  -> Check if expressions are not the same\n");
    printf("\t[EXP] >= [EXP]  -> Check if first expression is greater or equal than the second one\n");
    printf("\t[EXP] <= [EXP]  -> Check if first expression is less or equal than the second one\n");
    printf("\t[EXP]  > [EXP]  -> Check if first expression is greater than the second one\n");
    printf("\t[EXP]  < [EXP]  -> Check if first expression is less than the second one\n");
    printf("\t[EXP]  | [EXP]  -> Check if one of the two expressions is true\n");
    printf("\t[EXP] || [EXP]  -> Check if one of the two expressions is true\n");
    printf("\t[EXP]  & [EXP]  -> Check if both expressions are true\n");
    printf("\t[EXP] && [EXP]  -> Check if both expressions are true\n");
    printf("%s", RST);
}