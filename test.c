#include <stdio.h>

/**
 * add - function adds two integers
 * @a: the first integer
 * @b: the second integer
 *
 * Return: The result.
 */
int add(int a, int b) {
  int result;

  result = a + b;

  return (result);
}

/**
 * main - Entry point
 *
 * Return - Always EXIT SUCCESS.
 */
int main(void) {
  int a = 5;
  int b = 5;

  printf("Hello!\n");
  printf("The sum is %d\n", add(a, b));
  return (0);
}
