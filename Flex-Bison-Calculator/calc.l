%option noyywrap

%{
#include <stdio.h>

#include "calc.h"
#include "grammar.tab.h"

#define YY_DECL int yylex()

void show_functions();
void show_help();
void show_variables();
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
    [lL]" "[:alpha:]+                   {
                                            int i = 0;
                                            while (*(yytext + i) != '\0') {
                                                i++;
                                            }
                                            char *path = (char *) malloc((i - 1) * sizeof(char));
                                            strcpy(path, yytext);
                                            path[i] = '\0';
                                            printf("i=%i, Loading file \"%s\"\n",i, path);

                                            BEGIN(INITIAL);
                                        }
}
{VarInitChar}{VarChar}*                 {
                                            s = getsym(yytext);
                                            if(s == 0){
                                             s = putsym(yytext, VAR);
                                            }
                                            yylval.tptr = s;
                                            return s->type;
                                        }
[ \t\r]	;
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
<<EOF>>                                 {yyin=stdin;}
%%

void show_functions(){
    symrec *s = sym_table;
    printf("The available functions are:\n");
    while(s->next){
        if(s->type == UFNC){
            printf("\t %s()\n", s->name);
        }
        s = s->next;
    }
}

void show_variables(){
    symrec *s = sym_table;
    int check = 0;
    while(s->next){
        if(s->type == VAR){
            if(check == 0){
                check = 1;
                printf("Current variables:\n");
            }
            printf("\t %s = %g\n", s->name, s->value.var);
        }
        s = s->next;
    }
    if(check == 0){
        printf("You haven't declared any variable yet!\n");
    }

}

void show_help(){
    printf(" ---------------------------------\n");
    printf("| Supported commands:             |\n");
    printf("|      :h      -> help            |\n");
    printf("|      :f      -> show functions  |\n");
    printf("|      :v      -> show variables  |\n");
    printf("|      :q      -> quit            |\n");
    printf(" ---------------------------------\n");
}