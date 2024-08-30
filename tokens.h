#ifndef TOKENS_H
#define TOKENS_H

enum {
  /* Keywords */
  KEYWORD = 258, /* Generic keyword token */

  /* Identifiers and literals */
  IDENTIFIER,
  INTEGER,
  OCTAL,
  HEX,
  FLOAT,
  STRING,
  CHAR,

  /* Operators */
  PLUS,
  MINUS,
  MULTIPLY,
  DIVIDE,
  MODULO,
  ASSIGN,
  EQUAL,
  NOT_EQUAL,
  GREATER,
  LESS,
  GREATER_EQUAL,
  LESS_EQUAL,
  LOGICAL_AND,
  LOGICAL_OR,
  BITWISE_AND,
  BITWISE_OR,
  BITWISE_XOR,
  BITWISE_NOT,
  LEFT_SHIFT,
  RIGHT_SHIFT,

  /* Compound assignment operators */
  COMPOUND_ASSIGN,

  /* Increment/Decrement */
  INCREMENT,

  /* Other operators */
  OPERATOR,

  /* Punctuation */
  LEFT_PAREN,
  RIGHT_PAREN,
  LEFT_BRACE,
  RIGHT_BRACE,
  LEFT_BRACKET,
  RIGHT_BRACKET,
  SEMICOLON,
  COMMA,
  DOT,
  ARROW,

  /* Other */
  PUNCTUATION,
  COMPARISON,
  LOGICAL,
  PREPROCESSOR,
  COMMENT,
  NEWLINE,
  UNRECOGNIZED
};

#endif /* TOKENS_H */
