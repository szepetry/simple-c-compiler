# simple-c-compiler
A simple C compiler made using Lex and Yacc for a subset of the C language

### Installation and running
 1. Please make sure you have Lex/Flex and Yacc/Bison installed
 2. `$ yacc -d parser.y`
 3. `$ lex lexer.l`
 4. `$ gcc -w -g y.tab.c -ly -ll`
 5. To run the parser `$./a.out testcase_1.c`
