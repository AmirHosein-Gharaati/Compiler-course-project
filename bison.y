%{
#define YYSTYPE char*
#define YYSTYPE_IS_DECLARED 1
#define LABEL_SIZE 5

#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>

int yylex();
int yyerror(char*);
char* generateLabel();
char* printAddressCode(char *labelId, char *expr1, char op, char *expr2);

int labelNumber = 1;
%}

%token NUMBER ID
%token T_PLUS T_MINUS T_MULTIPLY T_DIVIDE T_EQUAL T_PARANTHESES_OPEN T_PARANTHESES_CLOSE

%right T_PLUS T_MINUS
%right T_MULTIPLY T_DIVIDE

%start statement

%%

statement: ID T_EQUAL expr T_PLUS expr                               { $$ = $1; printAddressCode($$, $5, '+', $3); }
         | ID T_EQUAL expr T_MINUS expr                              { $$ = $1; printAddressCode($$, $5, '-', $3); }
         | ID T_EQUAL expr T_MULTIPLY expr                           { $$ = $1; printAddressCode($$, $5, '*', $3); }
         | ID T_EQUAL expr T_DIVIDE expr                             { $$ = $1; printAddressCode($$, $5, '/', $3); }
         | ID T_EQUAL T_PARANTHESES_OPEN expr T_PARANTHESES_CLOSE    { $$ = $4; }
         | ID T_EQUAL ID
         | ID T_EQUAL NUMBER
;

expr: expr T_PLUS expr                                 { $$ = generateLabel(); printAddressCode($$, $3, '+', $1); }
    | expr T_MINUS expr                                { $$ = generateLabel(); printAddressCode($$, $3, '-', $1); }
    | expr T_MULTIPLY expr                             { $$ = generateLabel(); printAddressCode($$, $3, '*', $1); }
    | expr T_DIVIDE expr                               { $$ = generateLabel(); printAddressCode($$, $3, '/', $1); }
    | T_PARANTHESES_OPEN expr T_PARANTHESES_CLOSE      { $$ = $2; }
    | ID
    | NUMBER 
;

%%

int main() {
    if (yyparse() != 0) fprintf(stderr, "Abnormal exit\n");
    return 0;
}

int yyerror(char *error) {
    fprintf(stderr, "Error: %s\n", error);
}

char* generateLabel() {
    char *labelId = malloc(LABEL_SIZE);
    sprintf(labelId, "t%d", labelNumber++);
    return labelId;
}

char* printAddressCode(char *labelId, char *expr1, char op, char *expr2) {
    printf("%s = %s%c%s;\n", labelId, expr1, op, expr2);
}