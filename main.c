#include <stdio.h>

extern int yyparse();

int main()
{
    printf("=== DevOps DSL Execution ===\n");
    yyparse();
    return 0;
}

// Commands of runnig the deployment DSL parser:
// make
// ./dsl_runner < build.dsl