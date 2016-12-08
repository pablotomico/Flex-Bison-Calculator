#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include "symbolTable.h"
#include "grammar.tab.h"
#include "errorManager.h"


struct init_fncts {
    char *fname;
    double (*fnct)();
};

struct init_fncts arith_fncts[] = {
        {"sin", sin},
        {"cos", cos},
        {"atan", atan},
        {"ln", log},
        {"exp", exp},
        {"sqrt", sqrt},
        {"asin", asin},
        {"acos", acos},
        {"cosh", cosh},
        {"sinh", sinh},
        {"tanh", tanh},
        {"log10", log10},
        {0, 0}
};

struct init_cts {
    char *name;
    double value;
};

struct init_cts cts[]
        = {
                {"Ans", 0},
                {"pi", M_PI},
                {"e", M_E},
                {0, 0}
        };

/* La tabla de sı́mbolos: una cadena de ‘struct tree’. */
tree *sym_table = (tree *)0;

void init_table () /* pone las funciones aritméticas en una tabla. */
{
    int i;
    tree *ptr;
    for (i = 0; arith_fncts[i].fname != 0; i++)
    {
        ptr = putsym (arith_fncts[i].fname, UFNC, 'r', 'y');
        ptr->value.fnctptr = arith_fncts[i].fnct;
    }
    for (i = 0; cts[i].name != 0; i++)
    {
        ptr = putsym (cts[i].name, VAR, 'r', 'y');
        ptr->value.var = cts[i].value;
    }
}



void delete_table(tree **s){
    if((*s)->left != NULL){
        delete_table(&((*s)->left));
    }
    if((*s)->right != NULL){
        delete_table(&((*s)->right));
    }

    free((*s)->name);
    free(*s);
}

void reset_table(){
    delete_table(&sym_table);
    sym_table = (tree *)0;
    init_table();
}
tree *putsym_r(tree **s, char *sym_name, int sym_type, char sym_priv, char sym_decl) {
    tree *ptr;
    int res;

    if(*s == NULL){
        ptr = (tree *) malloc(sizeof(tree));
        ptr->name = (char *) malloc(strlen(sym_name) + 1);
        strcpy(ptr->name, sym_name);
        ptr->type = sym_type;
        ptr->value.var = 0; /* pone valor a 0 incluso si es fctn.*/
        ptr->priv = sym_priv;
        ptr->decl = sym_decl;
        ptr->left = (struct tree *) NULL;
        ptr->right = (struct tree *) NULL;

        *s = ptr;
    }else{
        res = strcmp(sym_name, (*s)->name);
        if (res < 0){
            ptr = putsym_r(&((*s)->left), sym_name, sym_type, sym_priv, sym_decl);
        }else {
            ptr = putsym_r(&((*s)->right), sym_name, sym_type, sym_priv, sym_decl);
        }
    }

    return ptr;
}

tree *putsym(char *sym_name, int sym_type, char sym_priv, char sym_decl) {
    return putsym_r(&sym_table, sym_name, sym_type, sym_priv, sym_decl);;
}

tree *getsym_r(tree **s, char *sym_name) {

    int res = strcmp(sym_name, (*s)->name);

    if(res == 0){
        return *s;
    }else if (res < 0){
        if((*s)->left != NULL)
            return getsym_r(&((*s)->left), sym_name);
        else
            return 0;
    }else{
        if((*s)->right != NULL)
            return getsym_r(&((*s)->right), sym_name);
        else
            return 0;
    }
}


tree *getsym(char *sym_name) {
    return getsym_r(&sym_table, sym_name);
}



void show_var(tree *s){
    if(s->left != NULL){
        show_var(s->left);
    }

    if(s->name != NULL && s->type == VAR){
        printf("\t [%c] %s = %g\n",s->priv, s->name, s->value.var);
    }

    if(s->right != NULL){
        show_var(s->right);
    }
}

void show_variables(){
    printf("Current variables:\n");
    printf("%s", KBLU);
    show_var(sym_table);
    printf("%s", RST);
}

void show_function(tree *s){
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
    tree *s = sym_table;
    printf("The available functions are:\n");
    printf("%s", KBLU);
    show_function(sym_table);
    printf("%s", RST);
}

