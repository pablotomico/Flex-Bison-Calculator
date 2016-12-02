#include <string.h>
#include <stdlib.h>
#include <stdio.h>
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


}

void remove_table(){
    remove_element(sym_table);
}

symrec *putsym_r(symrec **s, char *sym_name, int sym_type, char sym_priv) {
    symrec *ptr;
    int res;

    if(*s == NULL){
        ptr = (symrec *) malloc(sizeof(symrec));
        ptr->name = (char *) malloc(strlen(sym_name) + 1);
        strcpy(ptr->name, sym_name);
        ptr->type = sym_type;
        ptr->value.var = 0; /* pone valor a 0 incluso si es fctn.*/
        ptr->priv = sym_priv;
        ptr->left = (struct symrec *) NULL;
        ptr->right = (struct symrec *) NULL;

        *s = ptr;
    }else{
        res = strcmp(sym_name, (*s)->name);
        if (res < 0){
            ptr = putsym_r(&((*s)->left), sym_name, sym_type, sym_priv);
        }else {
            ptr = putsym_r(&((*s)->right), sym_name, sym_type, sym_priv);
        }
    }

    return ptr;
}

symrec *putsym(char *sym_name, int sym_type, char sym_priv) {
    return putsym_r(&sym_table, sym_name, sym_type, sym_priv);;
}

symrec *getsym(char *sym_name) {
    symrec *ptr;
    for (ptr = sym_table; ptr != (symrec *) 0; ptr = (symrec *) ptr->left)
        if (strcmp(ptr->name, sym_name) == 0)
            return ptr;
    return 0;
}



void show_var(symrec *s){
    if(s->left != NULL){
        show_var(s->left);
    }

    if(s->name != NULL && s->type == VAR){
        printf("\t %s = %g\n", s->name, s->value.var);
    }

    if(s->right != NULL){
        show_var(s->right);
    }
}

void show_variables(){
    printf("Current variables:\n");
    show_var(sym_table);
}

void show_function(symrec *s){
    if(s->left != NULL){
        show_function(s->left);
    }

    if(s->name != NULL && s->type == UFNC){
        printf("\t %s()\n", s->name);
    }

    if(s->right != NULL){
        show_function(s->right);
    }
}

void show_functions(){
    symrec *s = sym_table;
    printf("The available functions are:\n");
    show_function(sym_table);
}