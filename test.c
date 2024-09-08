#include <stdio.h>
#include "tokens.h"

extern int yylex(void);
extern int yylineno;
extern char* yytext;
extern void yy_scan_string(const char *str);
extern void yy_delete_buffer(void *buffer);

void test_lexer(const char* input) {
    printf("Testing input: %s\n", input);
    yylineno = 1; // Reset line number for each test
    yy_scan_string(input);
    int token;
    while ((token = yylex()) != 0) {
        printf("Token: %s (Type: %d)\n", yytext, token);
    }
    // Note: We're not calling yy_delete_buffer here as we don't have the buffer pointer
}

int main() {
    // Test cases
    test_lexer("int main() { return 0; }");   // Valid input
    test_lexer("if (x > 0) { y = 1; }");      // Valid input
    test_lexer("123 0x1A 0755");              // Test literals
    test_lexer("/* This is a comment */");    // Test comments
    test_lexer("// Another comment\n");       // Test single-line comment
    test_lexer("int x = 10;");                // Test variable declaration
    test_lexer("invalid_token!");             // Test invalid token
    return 0;
}
