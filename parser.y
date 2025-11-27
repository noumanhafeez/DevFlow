%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int failure_flag = 0;          // Set to 1 when any test fails
char* on_fail_script = NULL;   // Stores on_fail block temporarily

void yyerror(const char *s);
int yylex();
%}

%union {
    char* str;
}

/* Tokens */
%token PIPELINE STAGE STEPS RUN MAKE TEST
%token JOB DEPLOY ENV ONFAIL
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
    STAGE STRING LBRACE stage_body RBRACE {
        printf("\n[STAGE] %s\n", $2);

        /* Execute ON_FAIL only if a failure occurred */
        if (failure_flag == 1 && on_fail_script != NULL) {
            printf("[ON_FAIL] executing failure handler...\n");
            system(on_fail_script);
        }

        /* Reset stage state */
        failure_flag = 0;
        if (on_fail_script) {
            free(on_fail_script);
            on_fail_script = NULL;
        }
    }
;

stage_body:
      stage_body steps
    | stage_body env_vars
    | stage_body on_fail_block
    | stage_body job_block
    | steps
    | env_vars
    | on_fail_block
    | job_block
;

/* JOB block */
job_block:
    JOB STRING LBRACE steps RBRACE {
        printf("[JOB] %s\n", $2);
    }
;

/* ENV var */
env_vars:
    ENV STRING {
        printf("[ENV] exporting %s\n", $2);
        putenv(strdup($2));
    }
;

/* Store ON_FAIL SCRIPT but DO NOT run now */
on_fail_block:
    ONFAIL LBRACE run_commands RBRACE {
        printf("[ON_FAIL] handler saved.\n");
    }
;

/* STEPS */
steps:
    STEPS LBRACE run_commands RBRACE
;

/* RUN COMMANDS block */
run_commands:
      run_commands run
    | run
    | run_commands make_cmd
    | make_cmd
    | run_commands test_cmd
    | test_cmd
    | run_commands deploy_cmd
    | deploy_cmd
;

/* run */
run:
    RUN STRING {
        printf("[RUN] %s\n", $2);
        system($2);
    }
;

/* make */
make_cmd:
    MAKE STRING {
        printf("[MAKE] make %s\n", $2);
        char cmd[256];
        sprintf(cmd, "make %s", $2);
        system(cmd);
    }
;

/* test */
test_cmd:
    TEST STRING {
        printf("[TEST] %s\n", $2);
        int status = system($2);
        if (status == 0) {
            printf("[RESULT] PASSED\n");
        } else {
            printf("[RESULT] FAILED (exit code %d)\n", status);
            failure_flag = 1;     // MARK FAILURE
        }
    }
;

/* deploy */
deploy_cmd:
    DEPLOY STRING {
        printf("[DEPLOY] %s\n", $2);
        system($2);
    }
;
%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
