%{
#include "parser.tab.h"
#include <string.h>
%}

%%

"pipeline"      return PIPELINE;
"stage"         return STAGE;
"steps"         return STEPS;
"run"           return RUN;
"make"          return MAKE;
"test"          return TEST;

\"[^\"]*\" {
    yylval.str = strdup(yytext + 1);
    yylval.str[strlen(yylval.str) - 1] = 0;
    return STRING;
}

[a-zA-Z_][a-zA-Z0-9_]*    return IDENTIFIER;

"{"     return LBRACE;
"}"     return RBRACE;

[ \t\n]+   ;      /* skip whitespace */

.           ;     /* ignore anything else */

%%

int yywrap() { return 1; }
