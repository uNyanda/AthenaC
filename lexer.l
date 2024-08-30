%{
#include <stdio.h>
#include <string.h>
#include "tokens.h" /* Header file for token definitions */

void yyerror(const char *s);
int token_count = 0;
int line_number = 1;

void process_string(char* str);
char string_buffer[1000];
char *string_buf_ptr;
%}

%option noyywrap
%option yylineno

%x STRING_STATE
%x COMMENT_STATE

%%
"/*"                    { BEGIN(COMMENT_STATE); }
<COMMENT_STATE>"*/"     { BEGIN(INITIAL); printf("COMMENT\n"); token_count++; return COMMENT; }
<COMMENT_STATE>.|\n     { /* Ignore everything in comments */ }
<COMMENT_STATE><<EOF>>  { yyerror("Unterminated comment"); }

"//".*\n                { printf("COMMENT\n"); token_count++; line_number++; return COMMENT; }
^#.*\n                  { printf("PREPROCESSOR: %s", yytext); token_count++; line_number++; return PREPROCESSOR; }

"auto"|"break"|"case"|"char"|"const"|"continue"|"default"|"do"|"double"|"else"|"enum"|"extern"|"float"|"for"|"goto"|"if"|"int"|"long"|"register"|"return"|"short"|"signed"|"sizeof"|"static"|"struct"|"switch"|"typedef"|"union"|"unsigned"|"void"|"volatile"|"while" {
    printf("KEYWORD: %s\n", yytext);
    token_count++;
    return KEYWORD;
}

[a-zA-Z_][a-zA-Z0-9_]* { printf("IDENTIFIER: %s\n", yytext); token_count++; return IDENTIFIER; }

[1-9][0-9]*            { printf("INTEGER: %s\n", yytext); token_count++; return INTEGER; }
0[0-7]*                { printf("OCTAL: %s\n", yytext); token_count++; return OCTAL; }
0[xX][0-9a-fA-F]+      { printf("HEX: %s\n", yytext); token_count++; return HEX; }

[0-9]*\.[0-9]+([eE][-+]?[0-9]+)?  { printf("FLOAT: %s\n", yytext); token_count++; return FLOAT; }
[0-9]+\.[0-9]*([eE][-+]?[0-9]+)?  { printf("FLOAT: %s\n", yytext); token_count++; return FLOAT; }

\"                     { string_buf_ptr = string_buffer; BEGIN(STRING_STATE); }
<STRING_STATE>\"       { 
    BEGIN(INITIAL);
    *string_buf_ptr = '\0';
    printf("STRING: %s\n", string_buffer);
    process_string(string_buffer);
    token_count++;
    return STRING;
}
<STRING_STATE>\n       { yyerror("Unterminated string literal"); }
<STRING_STATE>\\[0-7]{1,3} {
    int result;
    sscanf(yytext + 1, "%o", &result);
    if (result > 0xff)
        yyerror("Constant is out-of-bounds");
    *string_buf_ptr++ = result;
}
<STRING_STATE>\\[0-9]+ { yyerror("Bad escape sequence"); }
<STRING_STATE>\\n  *string_buf_ptr++ = '\n';
<STRING_STATE>\\t  *string_buf_ptr++ = '\t';
<STRING_STATE>\\r  *string_buf_ptr++ = '\r';
<STRING_STATE>\\b  *string_buf_ptr++ = '\b';
<STRING_STATE>\\f  *string_buf_ptr++ = '\f';
<STRING_STATE>\\(.|\n)  *string_buf_ptr++ = yytext[1];
<STRING_STATE>[^\\\n\"]+  {
    char *yptr = yytext;
    while (*yptr)
        *string_buf_ptr++ = *yptr++;
}

\'([^\\\'\n]|\\.)\'   { printf("CHAR: %s\n", yytext); token_count++; return CHAR; }

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

\n                    { line_number++; return NEWLINE; }
[ \t\r\f]+            { /* Ignore whitespace */ }

.                     { printf("UNRECOGNIZED: %s\n", yytext); token_count++; return UNRECOGNIZED; }

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

void yyerror(const char *s) {
    fprintf(stderr, "Error at line %d: %s\n", yylineno, s);
}

int main(int argc, char **argv) {
    printf("Starting lexical analysis...\n");
    int token;
    while ((token = yylex()) != 0) {
        printf("Token type: %d (Line: %d)\n", token, yylineno);
    }
    printf("\nLexical analysis complete.\n");
    printf("Total tokens processed: %d\n", token_count);
    printf("Total lines: %d\n", yylineno);
    return 0;
}
