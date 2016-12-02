

#ifndef FLEX_BISON_CALCULATOR_CALC_H
#define FLEX_BISON_CALCULATOR_CALC_H


/* Tipo de datos para enlaces en la cadena de sı́mbolos. */
struct symrec
{
    char *name; /* nombre del sı́mbolo */
    int type;   /* tipo del sı́mbolo: bien VAR o FNCT */
    char priv;
    union {
        double var; /* valor de una VAR */
        double (*fnctptr)(); /* valor de una FNCT */
    } value;

    struct symrec *left; /* campo de enlace */
    struct symrec *right;
};

typedef struct symrec symrec;

/* La tabla de sı́mbolos: una cadena de ‘struct symrec’. */
extern symrec *sym_table;

void init_table ();

void remove_table();

symrec *putsym(char *sym_name, int sym_type, char sym_priv);

symrec * getsym (char *sym_name);

void show_variables();

void show_functions();

#endif