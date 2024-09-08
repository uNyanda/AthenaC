%{
#include <stdio.h>
#include <string.h>
<<<<<<< HEAD
#include "tokens.h" /* Header file for token definitions */
=======
#include "tokens.h"
>>>>>>> parser

extern void yyerror(const char *s);
int token_count = 0;
int line_number = 1;

#define STRING_BUFFER_SIZE 1000
char string_buffer[STRING_BUFFER_SIZE];
char *string_buf_ptr;

void process_string(char* str);
%}

%option noyywrap
%option yylineno

%x STRING_STATE
%x COMMENT_STATE

%%
"/*"                    { BEGIN(COMMENT_STATE); }
<COMMENT_STATE>"*/"     { BEGIN(INITIAL); printf("COMMENT\n"); token_count++; return TOKEN_COMMENT; }
<COMMENT_STATE>.|\n     { /* Ignore everything in comments */ }
<COMMENT_STATE><<EOF>>  { yyerror("Unterminated comment"); }

"//".*\n                { printf("COMMENT\n"); token_count++; line_number++; return TOKEN_COMMENT; }

"^[ \t]*#include[ \t]*<[^>]+>[ \t]*\n"  { printf("INCLUDE: %s\n", yytext); return TOKEN_INCLUDE; }
"^[ \t]*#include[ \t]*\"[^\"]*\"[ \t]*\n"  { printf("INCLUDE: %s\n", yytext); return TOKEN_INCLUDE; }
^[ \t]*#define\b              { printf("DEFINE\n"); token_count++; return TOKEN_DEFINE; }
^[ \t]*#if\b                  { printf("IF\n"); token_count++; return TOKEN_IF; }
^[ \t]*#elif\b                { printf("ELIF\n"); token_count++; return TOKEN_ELIF; }
^[ \t]*#else\b                { printf("ELSE\n"); token_count++; return TOKEN_ELSE; }
^[ \t]*#endif\b               { printf("ENDIF\n"); token_count++; return TOKEN_ENDIF; }
^[ \t]*#ifdef\b               { printf("IFDEF\n"); token_count++; return TOKEN_IFDEF; }
^[ \t]*#ifndef\b              { printf("IFNDEF\n"); token_count++; return TOKEN_IFNDEF; }
^[ \t]*#undef\b               { printf("UNDEF\n"); token_count++; return TOKEN_UNDEF; }

^[ \t]*#[a-zA-Z_][a-zA-Z0-9_]*  { printf("PREPROC_DIRECTIVE: %s\n", yytext); token_count++; return TOKEN_PREPROC_DIRECTIVE; }

"auto"|"break"|"case"|"char"|"const"|"continue"|"default"|"do"|"double"|"else"|"enum"|"extern"|"float"|"for"|"goto"|"if"|"int"|"long"|"register"|"return"|"short"|"signed"|"sizeof"|"static"|"struct"|"switch"|"typedef"|"union"|"unsigned"|"void"|"volatile"|"while" {
    printf("KEYWORD: %s\n", yytext);
    token_count++;
    return TOKEN_KEYWORD;
}

[a-zA-Z_][a-zA-Z0-9_]* { printf("IDENTIFIER: %s\n", yytext); token_count++; return TOKEN_IDENTIFIER; }

<<<<<<< HEAD
[1-9][0-9]*            { printf("INTEGER: %s\n", yytext); token_count++; return INTEGER; }
0[0-7]*                { printf("OCTAL: %s\n", yytext); token_count++; return OCTAL; }
0[xX][0-9a-fA-F]+      { printf("HEX: %s\n", yytext); token_count++; return HEX; }
=======
0[0-7]+                { printf("OCTAL: %s\n", yytext); token_count++; return TOKEN_OCTAL; }
[0-9]+                 { printf("INTEGER: %s\n", yytext); token_count++; return TOKEN_INTEGER; }
[0-9]*\.[0-9]+([eE][-+]?[0-9]+)?  { printf("FLOAT: %s\n", yytext); token_count++; return TOKEN_FLOAT; }
0[xX][0-9a-fA-F]+      { printf("HEX: %s\n", yytext); token_count++; return TOKEN_HEX; }
>>>>>>> parser

[0-9]*\.[0-9]+([eE][-+]?[0-9]+)?  { printf("FLOAT: %s\n", yytext); token_count++; return FLOAT; }
[0-9]+\.[0-9]*([eE][-+]?[0-9]+)?  { printf("FLOAT: %s\n", yytext); token_count++; return FLOAT; }

\"                     { string_buf_ptr = string_buffer; BEGIN(STRING_STATE); }
<STRING_STATE>\"       {
    BEGIN(INITIAL);
    *string_buf_ptr = '\0';
    printf("STRING: %s\n", string_buffer);
    process_string(string_buffer);
    token_count++;
    return TOKEN_STRING;
}
<STRING_STATE>\n       { yyerror("Unterminated string literal"); }
<STRING_STATE>\\[0-7]{1,3} {
    int result;
    sscanf(yytext + 1, "%o", &result);
    if (result > 0xff) {
        yyerror("Constant is out-of-bounds");
    } else if (string_buf_ptr - string_buffer < STRING_BUFFER_SIZE - 1) {
        *string_buf_ptr++ = result;
    } else {
        yyerror("String buffer overflow");
    }
}
<STRING_STATE>\\[0-9]+ { yyerror("Bad escape sequence"); }
<STRING_STATE>\\n      { *string_buf_ptr++ = '\n'; }
<STRING_STATE>\\t      { *string_buf_ptr++ = '\t'; }
<STRING_STATE>\\r      { *string_buf_ptr++ = '\r'; }
<STRING_STATE>\\b      { *string_buf_ptr++ = '\b'; }
<STRING_STATE>\\f      { *string_buf_ptr++ = '\f'; }
<STRING_STATE>\\(.)    { *string_buf_ptr++ = yytext[1]; } // Handle any other escape sequences
<STRING_STATE>[^\\\n\"]+  {
    char *yptr = yytext;
    while (*yptr && string_buf_ptr - string_buffer < STRING_BUFFER_SIZE - 1) {
        *string_buf_ptr++ = *yptr++;
    }
}

\'([^\\\'\n]|\\.)\'   { printf("CHAR: %s\n", yytext); token_count++; return TOKEN_CHAR; }

<<<<<<< HEAD
"+="|"-="|"*="|"/="|"%="|"<<="|">>="|"&="|"^="|"|=" { printf("COMPOUND_ASSIGN: %s\n", yytext); token_count++; return COMPOUND_ASSIGN; }
"++"|"--"             { printf("INCREMENT: %s\n", yytext); token_count++; return INCREMENT; }
"&&"|"||"             { printf("LOGICAL: %s\n", yytext); token_count++; return LOGICAL; }
"=="|"!="|"<"|">"|"<="|">=" { printf("COMPARISON: %s\n", yytext); token_count++; return COMPARISON; }
"<<"                  { printf("LEFT_SHIFT: %s\n", yytext); token_count++; return LEFT_SHIFT; }
">>"                  { printf("RIGHT_SHIFT: %s\n", yytext); token_count++; return RIGHT_SHIFT; }
"="                   { printf("ASSIGN: %s\n", yytext); token_count++; return ASSIGN; }
[+\-*/%&|^~]          { printf("OPERATOR: %s\n", yytext); token_count++; return OPERATOR; }

"{"|"}"               { printf("BRACE: %s\n", yytext); token_count++; return yytext[0] == '{' ? LEFT_BRACE : RIGHT_BRACE; }
"("|")"               { printf("PAREN: %s\n", yytext); token_count++; return yytext[0] == '(' ? LEFT_PAREN : RIGHT_PAREN; }
"["|"]"               { printf("BRACKET: %s\n", yytext); token_count++; return yytext[0] == '[' ? LEFT_BRACKET : RIGHT_BRACKET; }
";"|","|"."           { printf("PUNCTUATION: %s\n", yytext); token_count++; return PUNCTUATION; }
"->"                  { printf("ARROW: %s\n", yytext); token_count++; return ARROW; }
=======
"="                    { printf("ASSIGN: %s\n", yytext); token_count++; return TOKEN_ASSIGN; }
"+="|"-="|"*="|"/="|"%="|"<<="|">>="|"&="|"^="|"|=" { printf("COMPOUND_ASSIGN: %s\n", yytext); token_count++; return TOKEN_COMPOUND_ASSIGN; }
"++"                   { printf("INCREMENT: %s\n", yytext); token_count++; return TOKEN_INCREMENT; }
"--"                   { printf("DECREMENT: %s\n", yytext); token_count++; return TOKEN_DECREMENT; }
"&&"                   { printf("LOGICAL_AND: %s\n", yytext); token_count++; return TOKEN_LOGICAL_AND; }
"||"                   { printf("LOGICAL_OR: %s\n", yytext); token_count++; return TOKEN_LOGICAL_OR; }
"!"                    { printf("LOGICAL_NOT: %s\n", yytext); token_count++; return TOKEN_LOGICAL_NOT; }
"=="                   { printf("EQUAL: %s\n", yytext); token_count++; return TOKEN_EQUAL; }
"!="                   { printf("NOT_EQUAL: %s\n", yytext); token_count++; return TOKEN_NOT_EQUAL; }
"<"                    { printf("LESS: %s\n", yytext); token_count++; return TOKEN_LESS; }
">"                    { printf("GREATER: %s\n", yytext); token_count++; return TOKEN_GREATER; }
"<="                   { printf("LESS_EQUAL: %s\n", yytext); token_count++; return TOKEN_LESS_EQUAL; }
">="                   { printf("GREATER_EQUAL: %s\n", yytext); token_count++; return TOKEN_GREATER_EQUAL; }
"<<"                   { printf("LEFT_SHIFT: %s\n", yytext); token_count++; return TOKEN_LEFT_SHIFT; }
">>"                   { printf("RIGHT_SHIFT: %s\n", yytext); token_count++; return TOKEN_RIGHT_SHIFT; }
"&"                    { printf("BITWISE_AND: %s\n", yytext); token_count++; return TOKEN_BITWISE_AND; }
"|"                    { printf("BITWISE_OR: %s\n", yytext); token_count++; return TOKEN_BITWISE_OR; }
"^"                    { printf("BITWISE_XOR: %s\n", yytext); token_count++; return TOKEN_BITWISE_XOR; }
"~"                    { printf("BITWISE_NOT: %s\n", yytext); token_count++; return TOKEN_BITWISE_NOT; }
"+"                    { printf("PLUS: %s\n", yytext); token_count++; return TOKEN_PLUS; }
"-"                    { printf("MINUS: %s\n", yytext); token_count++; return TOKEN_MINUS; }
"*"                    { printf("MULTIPLY: %s\n", yytext); token_count++; return TOKEN_MULTIPLY; }
"/"                    { printf("DIVIDE: %s\n", yytext); token_count++; return TOKEN_DIVIDE; }
"%"                    { printf("MODULO: %s\n", yytext); token_count++; return TOKEN_MODULO; }

"{"                    { printf("LEFT_BRACE: %s\n", yytext); token_count++; return TOKEN_LEFT_BRACE; }
"}"                    { printf("RIGHT_BRACE: %s\n", yytext); token_count++; return TOKEN_RIGHT_BRACE; }
"("                    { printf("LEFT_PAREN: %s\n", yytext); token_count++; return TOKEN_LEFT_PAREN; }
")"                    { printf("RIGHT_PAREN: %s\n", yytext); token_count++; return TOKEN_RIGHT_PAREN; }
"["                    { printf("LEFT_BRACKET: %s\n", yytext); token_count++; return TOKEN_LEFT_BRACKET; }
"]"                    { printf("RIGHT_BRACKET: %s\n", yytext); token_count++; return TOKEN_RIGHT_BRACKET; }
";"                    { printf("SEMICOLON: %s\n", yytext); token_count++; return TOKEN_SEMICOLON; }
","                    { printf("COMMA: %s\n", yytext); token_count++; return TOKEN_COMMA; }
"."                    { printf("DOT: %s\n", yytext); token_count++; return TOKEN_DOT; }
"->"                   { printf("ARROW: %s\n", yytext); token_count++; return TOKEN_ARROW; }
":"                    { printf("COLON: %s\n", yytext); token_count++; return TOKEN_COLON; }
"?"                    { printf("QUESTION: %s\n", yytext); token_count++; return TOKEN_QUESTION; }
>>>>>>> parser

\n                    { line_number++; return TOKEN_NEWLINE; }
[ \t\r\f]+            { /* Ignore whitespace */ }

.                     {
    printf("UNRECOGNIZED: %s\n", yytext);
    token_count++;
    if (token_count >= TOTAL_TOKENS) {
        yyerror("Token type out of range");
    }
    return TOKEN_UNRECOGNIZED;
}

%%

void process_string(char* str) {
    printf("Processed string: ");
    char* ptr = str;
    while (*ptr) {
        if (*ptr == '\n') printf("\\n");
        else if (*ptr == '\t') printf("\\t");
        else if (*ptr == '\r') printf("\\r");
        else if (*ptr == '\b') printf("\\b");
        else if (*ptr == '\f') printf("\\f");
        else putchar(*ptr);
        ptr++;
    }
    printf("\n");
}
