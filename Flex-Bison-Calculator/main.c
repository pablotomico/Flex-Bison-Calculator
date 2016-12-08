#include <stdlib.h>
#include <stdio.h>


#include "grammar.tab.c"

#include "lex.yy.c"

int main() {
    yyin = stdin;
    init_table();

    printf("Welcome! for help type :h or :H\n");

    yyparse();

    return 0;
}
