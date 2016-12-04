#include <stdio.h>
#include "errorManager.h"


void unknownComponent() {
    printf("%sERROR: unknown component\n", KRED);
    printf("%s", RST);
}

void showWarning(char *msg) {
    printf("%sWARNING: %s\n", KYEL, msg);
    printf("%s", RST);
}

void showError(char *msg) {
    printf("%sERROR: %s\n", KRED, msg);
    printf("%s", RST);
}

void fatalError(char *msg) {
    printf("%sFATAL ERROR: %s\n", KRED, msg);
    printf("%s", RST);
}

void divisionByZero(){
    printf("%sERROR: Can't divide by zero\n", KRED);
    printf("%s", RST);
}

void yyerror(const char* s) {
    fprintf(stderr, "ERROR: %s\n", s);
}