#include <stdlib.h>
#include <stdio.h>


#include "grammar.tab.c"

#include "lex.yy.c"

int main() {
    yyin = stdin;
    init_table();

    symrec *s = getsym("sin");


    do {
        yyparse();
    } while(!feof(yyin));

    return 0;
}
void yyerror(const char* s) {
    fprintf(stderr, "Parse error: %s\n", s);
    exit(1);
}