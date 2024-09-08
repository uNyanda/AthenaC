%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdbool.h>

extern int yylex();
extern int yylineno;
extern char* yytext;

void yyerror(const char* s);
%}

%token TOKEN_IDENTIFIER TOKEN_INTEGER TOKEN_OCTAL TOKEN_HEX TOKEN_FLOAT TOKEN_STRING TOKEN_CHAR
%token TOKEN_PLUS TOKEN_MINUS TOKEN_MULTIPLY TOKEN_DIVIDE TOKEN_MODULO TOKEN_ASSIGN
%token TOKEN_EQUAL TOKEN_NOT_EQUAL TOKEN_GREATER TOKEN_LESS TOKEN_GREATER_EQUAL TOKEN_LESS_EQUAL
%token TOKEN_LOGICAL_AND TOKEN_LOGICAL_OR TOKEN_LOGICAL_NOT TOKEN_BITWISE_AND TOKEN_BITWISE_OR TOKEN_BITWISE_XOR TOKEN_BITWISE_NOT
%token TOKEN_LEFT_SHIFT TOKEN_RIGHT_SHIFT
%token TOKEN_COMPOUND_ASSIGN TOKEN_INCREMENT
%token TOKEN_LEFT_PAREN TOKEN_RIGHT_PAREN TOKEN_LEFT_BRACE TOKEN_RIGHT_BRACE TOKEN_LEFT_BRACKET TOKEN_RIGHT_BRACKET
%token TOKEN_SEMICOLON TOKEN_COMMA TOKEN_DOT TOKEN_ARROW
%token TOKEN_PREPROCESSOR TOKEN_COMMENT TOKEN_NEWLINE
%token TOKEN_COLON TOKEN_QUESTION

%token TOKEN_IF TOKEN_ELSE TOKEN_WHILE TOKEN_FOR TOKEN_RETURN

%token TOKEN_INCLUDE TOKEN_DEFINE TOKEN_IFDEF TOKEN_IFNDEF TOKEN_ENDIF TOKEN_ELIF TOKEN_UNDEF TOKEN_PREPROC_DIRECTIVE

%nonassoc IFX
%nonassoc TOKEN_ELSE // Make else non-associative

%start program

%right TOKEN_ASSIGN TOKEN_COMPOUND_ASSIGN
%left TOKEN_COMMA
%left TOKEN_LOGICAL_OR
%left TOKEN_LOGICAL_AND
%left TOKEN_BITWISE_OR
%left TOKEN_BITWISE_XOR
%left TOKEN_BITWISE_AND
%left TOKEN_EQUAL TOKEN_NOT_EQUAL
%left TOKEN_LESS TOKEN_LESS_EQUAL TOKEN_GREATER TOKEN_GREATER_EQUAL
%left TOKEN_LEFT_SHIFT TOKEN_RIGHT_SHIFT
%left TOKEN_PLUS TOKEN_MINUS
%left TOKEN_MULTIPLY TOKEN_DIVIDE TOKEN_MODULO
%right TOKEN_LOGICAL_NOT TOKEN_BITWISE_NOT TOKEN_INCREMENT
%left TOKEN_DOT TOKEN_ARROW TOKEN_LEFT_BRACKET TOKEN_RIGHT_BRACKET TOKEN_LEFT_PAREN TOKEN_RIGHT_PAREN
%right TOKEN_SEMICOLON

%%

program /* grammar rules */
    : external_declaration
    | program external_declaration
    ;

external_declaration
    : function_definition
    | declaration
    | preprocessor_directive
    ;

preprocessor_directive
    :  TOKEN_INCLUDE TOKEN_NEWLINE
    |  TOKEN_DEFINE TOKEN_IDENTIFIER constant_expression
    |  TOKEN_IFDEF TOKEN_IDENTIFIER
    |  TOKEN_IFNDEF TOKEN_IDENTIFIER
    |  TOKEN_ENDIF
    |  TOKEN_ELSE
    |  TOKEN_ELIF constant_expression
    |  TOKEN_UNDEF TOKEN_IDENTIFIER
    |  TOKEN_PREPROC_DIRECTIVE
    ;

constant_expression
    : TOKEN_INTEGER
    | TOKEN_FLOAT
    | TOKEN_CHAR
    | TOKEN_STRING
    | TOKEN_IDENTIFIER  // Include this if TOKEN_IDENTIFIERs are used in constant expressions
    ;

function_definition
    : type_specifier TOKEN_IDENTIFIER TOKEN_LEFT_PAREN parameter_list TOKEN_RIGHT_PAREN compound_statement
    ;

parameter_list
    : parameter_declaration
    | parameter_list TOKEN_COMMA parameter_declaration
    |
    ;

parameter_declaration
    : type_specifier TOKEN_IDENTIFIER
    ;

compound_statement
    : TOKEN_LEFT_BRACE statement_list TOKEN_RIGHT_BRACE
    ;

statement_list
    : statement
    | statement_list statement
    ;

statement
    : expression_statement
    | compound_statement
    | selection_statement
    | iteration_statement
    | jump_statement
    ;

expression_statement
    : expression TOKEN_SEMICOLON
    | TOKEN_SEMICOLON
    ;

selection_statement
    : if_statement
    ;

if_statement
    : TOKEN_IF TOKEN_LEFT_PAREN expression TOKEN_RIGHT_PAREN statement %prec IFX
    | TOKEN_IF TOKEN_LEFT_PAREN expression TOKEN_RIGHT_PAREN statement TOKEN_ELSE statement
    ;

iteration_statement
    : TOKEN_WHILE TOKEN_LEFT_PAREN expression TOKEN_RIGHT_PAREN statement
    | TOKEN_FOR TOKEN_LEFT_PAREN expression_statement expression_statement expression TOKEN_RIGHT_PAREN statement
    ;

jump_statement
    : TOKEN_RETURN TOKEN_SEMICOLON
    | TOKEN_RETURN expression TOKEN_SEMICOLON
    ;

declaration
    : type_specifier init_declarator_list TOKEN_SEMICOLON
    ;

init_declarator_list
    : init_declarator
    | init_declarator_list TOKEN_COMMA init_declarator
    ;

init_declarator
    : TOKEN_IDENTIFIER
    | TOKEN_IDENTIFIER TOKEN_ASSIGN expression
    ;

type_specifier
    : TOKEN_IDENTIFIER TOKEN_NEWLINE
    ;

expression
    : assignment_expression
    | expression TOKEN_COMMA assignment_expression
    ;

assignment_expression
    : conditional_expression
    | unary_expression assignment_operator assignment_expression
    ;

assignment_operator
    : TOKEN_ASSIGN
    | TOKEN_COMPOUND_ASSIGN
    ;

conditional_expression
    : logical_or_expression
    | logical_or_expression TOKEN_QUESTION expression TOKEN_COLON conditional_expression
    ;

logical_or_expression
    : logical_and_expression
    | logical_or_expression TOKEN_LOGICAL_OR logical_and_expression
    ;

logical_and_expression
    : inclusive_or_expression
    | logical_and_expression TOKEN_LOGICAL_AND inclusive_or_expression
    ;

inclusive_or_expression
    : exclusive_or_expression
    | inclusive_or_expression TOKEN_BITWISE_OR exclusive_or_expression
    ;

exclusive_or_expression
    : and_expression
    | exclusive_or_expression TOKEN_BITWISE_XOR and_expression
    ;

and_expression
    : equality_expression
    | and_expression TOKEN_BITWISE_AND equality_expression
    ;

equality_expression
    : relational_expression
    | equality_expression TOKEN_EQUAL relational_expression
    | equality_expression TOKEN_NOT_EQUAL relational_expression
    ;

relational_expression
    : shift_expression
    | relational_expression TOKEN_LESS shift_expression
    | relational_expression TOKEN_GREATER shift_expression
    | relational_expression TOKEN_LESS_EQUAL shift_expression
    | relational_expression TOKEN_GREATER_EQUAL shift_expression
    ;

shift_expression
    : additive_expression
    | shift_expression TOKEN_LEFT_SHIFT additive_expression
    | shift_expression TOKEN_RIGHT_SHIFT additive_expression
    ;

additive_expression
    : multiplicative_expression
    | additive_expression TOKEN_PLUS multiplicative_expression
    | additive_expression TOKEN_MINUS multiplicative_expression
    ;

multiplicative_expression
    : unary_expression
    | multiplicative_expression TOKEN_MULTIPLY unary_expression
    | multiplicative_expression TOKEN_DIVIDE unary_expression
    | multiplicative_expression TOKEN_MODULO unary_expression
    ;

unary_expression
    : postfix_expression
    | TOKEN_INCREMENT unary_expression
    | unary_operator unary_expression
    ;

unary_operator
    : TOKEN_BITWISE_AND
    | TOKEN_MULTIPLY
    | TOKEN_PLUS
    | TOKEN_MINUS
    | TOKEN_BITWISE_NOT
    | TOKEN_LOGICAL_NOT
    ;

postfix_expression
    : primary_expression
    | postfix_expression TOKEN_LEFT_BRACKET expression TOKEN_RIGHT_BRACKET
    | postfix_expression TOKEN_LEFT_PAREN TOKEN_RIGHT_PAREN
    | postfix_expression TOKEN_LEFT_PAREN argument_expression_list TOKEN_RIGHT_PAREN
    | postfix_expression TOKEN_DOT TOKEN_IDENTIFIER
    | postfix_expression TOKEN_ARROW TOKEN_IDENTIFIER
    | postfix_expression TOKEN_INCREMENT
    ;

primary_expression
    : TOKEN_IDENTIFIER
    | constant
    | TOKEN_STRING
    | TOKEN_LEFT_PAREN expression TOKEN_RIGHT_PAREN
    ;

constant
    : TOKEN_INTEGER
    | TOKEN_OCTAL
    | TOKEN_HEX
    | TOKEN_FLOAT
    | TOKEN_CHAR
    ;

argument_expression_list
    : assignment_expression
    | argument_expression_list TOKEN_COMMA assignment_expression
    ;

%%

// Error handling function
void yyerror(const char* s) {
    fprintf(stderr, "Parse error at line %d: %s. Offending token: '%s'\n", yylineno, s, yytext);
}

int main() {
    printf("Starting parsing...\n");
    int result = yyparse();
    if (result == 0) {
        printf("Parsing completed successfully.\n");
    } else {
        printf("Parsing failed.\n");
    }
    return result;
}
