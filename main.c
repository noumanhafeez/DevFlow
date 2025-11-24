#include <stdio.h>

extern int yyparse();

int main()
{
    printf("=== DevOps DSL Execution ===\n");
    yyparse();
    return 0;
}
