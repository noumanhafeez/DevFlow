%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
int yylex();
%}

%union {
    char* str;
}

%token PIPELINE STAGE STEPS RUN MAKE TEST
%token <str> STRING IDENTIFIER
%token LBRACE RBRACE

%%

program:
    PIPELINE LBRACE stages RBRACE
;

stages:
      stages stage
    | stage
;

stage:
    STAGE STRING LBRACE steps RBRACE
;

steps:
    STEPS LBRACE run_commands RBRACE
;

run_commands:
      run_commands run
    | run
    | run_commands make_cmd
    | make_cmd
    | run_commands test_cmd
    | test_cmd
;

/* ---------- run command ---------- */
run:
    RUN STRING {
        printf("[RUN] %s\n", $2);
        system($2);
    }
;

/* ---------- make command ---------- */
make_cmd:
    MAKE STRING {
        printf("[MAKE] make %s\n", $2);
        char cmd[256];
        sprintf(cmd, "make %s", $2);
        system(cmd);
    }
;

/* ---------- test command ---------- */
test_cmd:
    TEST STRING {
        printf("[TEST] %s\n", $2);
        int status = system($2);
        if (status == 0)
            printf("[RESULT] PASSED\n");
        else
            printf("[RESULT] FAILED (exit code %d)\n", status);
    }
;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
