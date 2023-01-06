%{
// we should write defines first to have a successfull compile
#define YYSTYPE char*
#define YYSTYPE_IS_DECLARED 1

#include <string.h>
#include "y.tab.h"

char* generateId();
%}

char [a-zA-Z]
digit [0-9]
id {char}({char}|{digit})*
number {digit}+(\.{digit}+)?(E[+\-]?{digit}+)?

%%

[\n\t ] ;   // ignore all whitespace
"="     { return T_EQUAL; }
"("     { return T_PARANTHESES_OPEN; }
")"     { return T_PARANTHESES_CLOSE; }
":A:"   { return T_PLUS; }
":S:"   { return T_MINUS; }
":M:"   { return T_MULTIPLY; }
":D:"   { return T_DIVIDE; }

{id}        { yylval = generateId(); return ID; }
{number}    { yylval = generateId(); return NUMBER; }

%%

int yywrap() {}

char* generateId() {
    char *id = malloc(yyleng + 1);
    strcpy(id, yytext);
    return id;
}
