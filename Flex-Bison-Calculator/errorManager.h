#ifndef DCOMPILER_ERRORMANAGER_H
#define DCOMPILER_ERRORMANAGER_H

#define KRED  "\x1B[31m"
#define KGRE  "\x1B[32m"
#define KYEL  "\x1B[33m"
#define KBLU  "\x1B[34m"
#define KMAG  "\x1B[35m"
#define KCYN  "\x1B[36m"
#define KWHT  "\x1B[37m"
#define RST   "\x1B[0m"

void unknownComponent();

void showWarning(char* msg);

void fatalError(char* msg);

void divisionByZero();


#endif //DCOMPILER_ERRORMANAGER_H