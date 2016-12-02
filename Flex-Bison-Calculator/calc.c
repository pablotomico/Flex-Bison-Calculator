#include <string.h>
#include <stdlib.h>
#include <math.h>
#include "calc.h"
#include "grammar.tab.h"


struct init_fncts {
    char *fname;
    double (*fnct)();
};

struct init_fncts arith_fncts[]
        = {
                "sin", sin,
                "cos", cos,
                "atan", atan,
                "ln", log,
                "exp", exp,
                "sqrt", sqrt,
                0, 0
        };

struct init_cts {
    char *name;
    double value;
};

struct init_cts cts[]
        = {
                "pi", M_PI,
                "e", M_E,
                0, 0
        };

/* La tabla de sı́mbolos: una cadena de ‘struct symrec’. */
symrec *sym_table = (symrec *)0;

void init_table () /* pone las funciones aritméticas en una tabla. */
{
    int i;
    symrec *ptr;
    for (i = 0; arith_fncts[i].fname != 0; i++)
    {
        ptr = putsym (arith_fncts[i].fname, UFNC, 'r');
        ptr->value.fnctptr = arith_fncts[i].fnct;
    }
    for (i = 0; cts[i].name != 0; i++)
    {
        ptr = putsym (cts[i].name, VAR, 'r');
        ptr->value.var = cts[i].value;
    }
}
void remove_element(symrec *s){
    if(s->next){
        remove_element(s->next);
    }else{
        free(s);
    }

}

void remove_table(){
    remove_element(sym_table);
}


symrec *putsym(char *sym_name, int sym_type, char sym_priv) {
    symrec *ptr;
    ptr = (symrec *) malloc(sizeof(symrec));
    ptr->name = (char *) malloc(strlen(sym_name) + 1);
    strcpy(ptr->name, sym_name);
    ptr->type = sym_type;
    ptr->value.var = 0; /* pone valor a 0 incluso si es fctn.*/
    ptr->priv = sym_priv;
    ptr->next = (struct symrec *) sym_table;
    sym_table = ptr;
    return ptr;
}

symrec *getsym(char *sym_name) {
    symrec *ptr;
    for (ptr = sym_table; ptr != (symrec *) 0; ptr = (symrec *) ptr->next)
        if (strcmp(ptr->name, sym_name) == 0)
            return ptr;
    return 0;
}