

#ifndef FLEX_BISON_CALCULATOR_CALC_H
#define FLEX_BISON_CALCULATOR_CALC_H


/* Tipo de datos para enlaces en la cadena de sı́mbolos. */
struct tree
{
    char *name; /* nombre del sı́mbolo */
    int type;   /* tipo del sı́mbolo: bien VAR o FNCT */
    char priv;
    char decl;
    union {
        double var; /* valor de una VAR */
        double (*fnctptr)(); /* valor de una FNCT */
    } value;

    struct tree *left; /* campo de enlace */
    struct tree *right;
};

typedef struct tree tree;

/* La tabla de sı́mbolos: una cadena de ‘struct tree’. */
extern tree *sym_table;

void init_table ();

void reset_table();

tree *putsym(char *sym_name, int sym_type, char sym_priv, char sym_decl);

tree * getsym (char *sym_name);

void show_variables();

void show_functions();

#endif