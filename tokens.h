#ifndef TOKENS_H
#define TOKENS_H

// Enum for token types used in the lexer
typedef enum {
    /* Keywords */
    TOKEN_KEYWORD = 258, // Represents any keyword in the source code (e.g., if, else, while)

<<<<<<< HEAD
  /* Identifiers and literals */
  IDENTIFIER,
  INTEGER,
  OCTAL,
  HEX,
  FLOAT,
  STRING,
  CHAR,
=======
	TOKEN_IF,            // Represents the 'if' keyword
	TOKEN_ELSE,          // Represents the 'else' keyword
	TOKEN_WHILE,         // Represents the 'while' keyword
	TOKEN_FOR,           // Represents the 'for' keyword
	TOKEN_RETURN,        // Represents the 'return' keyword
>>>>>>> parser

	/* Identifiers and literals */
	TOKEN_IDENTIFIER,    // Represents variable names and identifiers
    TOKEN_INTEGER,       // Represents integer literals
    TOKEN_OCTAL,         // Represents octal literals
    TOKEN_FLOAT,         // Represents floating-point literals
    TOKEN_STRING,        // Represents string literals
    TOKEN_CHAR,          // Represents character literals
    TOKEN_HEX,           // Represents hexadecimal literals

    /* Operators */
    TOKEN_PLUS,          // Addition operator
    TOKEN_MINUS,         // Subtraction operator
    TOKEN_MULTIPLY,      // Multiplication operator
    TOKEN_DIVIDE,        // Division operator
    TOKEN_MODULO,        // Modulo operator
    TOKEN_ASSIGN,        // Assignment operator
    TOKEN_EQUAL,         // Equality operator
    TOKEN_NOT_EQUAL,     // Inequality operator
    TOKEN_GREATER,       // Greater than operator
    TOKEN_LESS,          // Less than operator
    TOKEN_GREATER_EQUAL, // Greater than or equal to operator
    TOKEN_LESS_EQUAL,    // Less than or equal to operator
    TOKEN_LOGICAL_AND,   // Logical AND operator
    TOKEN_LOGICAL_OR,    // Logical OR operator
    TOKEN_LOGICAL_NOT,   // Logical NOT operator
    TOKEN_BITWISE_AND,   // Bitwise AND operator
    TOKEN_BITWISE_OR,    // Bitwise OR operator
    TOKEN_BITWISE_XOR,   // Bitwise XOR operator
    TOKEN_BITWISE_NOT,   // Bitwise NOT operator
    TOKEN_LEFT_SHIFT,    // Left shift operator
    TOKEN_RIGHT_SHIFT,   // Right shift operator

    /* Compound assignment operators */
    TOKEN_COMPOUND_ASSIGN, // Compound assignment operators (e.g., +=, -=, etc.)

    /* Increment/Decrement */
    TOKEN_INCREMENT,      // Increment operator
    TOKEN_DECREMENT,      // Decrement operator

    /* Punctuation */
    TOKEN_LEFT_PAREN,     // Left parenthesis
    TOKEN_RIGHT_PAREN,    // Right parenthesis
    TOKEN_LEFT_BRACE,     // Left brace
    TOKEN_RIGHT_BRACE,    // Right brace
    TOKEN_LEFT_BRACKET,   // Left bracket
    TOKEN_RIGHT_BRACKET,  // Right bracket
    TOKEN_SEMICOLON,      // Semicolon
    TOKEN_COMMA,          // Comma
    TOKEN_DOT,            // Dot operator
    TOKEN_ARROW,          // Arrow operator (->)
    TOKEN_COLON,          // Colon
    TOKEN_QUESTION,       // Question mark

<<<<<<< HEAD
  /* Other */
  PUNCTUATION,
  COMPARISON,
  LOGICAL,
  PREPROCESSOR,
  COMMENT,
  NEWLINE,
  UNRECOGNIZED
};
=======
    /* Preprocessor Directives */
    TOKEN_PREPROCESSOR,         // Represents preprocessor directives (e.g., #include, #define)
	TOKEN_INCLUDE,              // Represents the 'include' preprocessor directive
	TOKEN_DEFINE,               // Represents the 'define' preprocessor directive
	TOKEN_IFDEF,                // Represents the 'ifdef' preprocessor directive
	TOKEN_IFNDEF,               // Represents the 'ifndef' preprocessor directive
	TOKEN_ENDIF,                // Represents the 'endif' preprocessor directive
	TOKEN_ELIF,                 // Represents the 'elif' preprocessor directive
	TOKEN_UNDEF,                // Represents the 'undef' preprocessor directive
	TOKEN_PREPROC_DIRECTIVE,    // Represents any other preprocessor directive

    /* Comments */
    TOKEN_COMMENT,        // Represents comments in the source code

    /* Newline */
    TOKEN_NEWLINE,        // Represents newline characters

    /* Unrecognized tokens */
    TOKEN_UNRECOGNIZED     // Represents any unrecognized token
} TokenType;

#define TOTAL_TOKENS (TOKEN_UNRECOGNIZED + 1)
>>>>>>> parser

#endif /* TOKENS_H */
