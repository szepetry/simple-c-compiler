%{
	#include <stdlib.h>
	#include <stdio.h>
	int yyerror(char *msg);
	#include "lex.yy.c"
%}

%token READ WRITE

%token IDENTIFIER
%token ID

%token DEC_CONSTANT CHAR_CONSTANT FLOAT_CONSTANT
%token STRING

%token LOGICAL_AND LOGICAL_OR LS_EQ GR_EQ EQ NOT_EQ

%token MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN SUB_ASSIGN
%token INCREMENT DECREMENT

%token SHORT INT LONG LONG_LONG SIGNED UNSIGNED CONST VOID CHAR FLOAT

%token IF FOR WHILE CONTINUE BREAK RETURN

%left ','
%right '='
%left LOGICAL_OR
%left LOGICAL_AND
%left EQ NOT_EQ
%left '<' '>' LS_EQ GR_EQ
%left '+' '-'
%left '*' '/' '%'
%right '!'


%nonassoc UMINUS
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE


%%

starter: starter builder
	   | builder
	   ;

builder: function
	   | declaration
	   ;

function: type IDENTIFIER '(' argument_list ')' compound_stmt
        ;

type: data_type pointer
    | data_type
    ;

pointer: '*' pointer
       | '*'
       ;

data_type: sign_specifier type_specifier
    	  | type_specifier
    	  ;

sign_specifier: SIGNED
    		  | UNSIGNED
    		  ;

type_specifier: INT
              | SHORT INT
              | SHORT
              | LONG
	          | LONG INT
              | LONG_LONG
              | LONG_LONG INT
	          | CHAR
	          | FLOAT
	          | VOID
              ;

argument_list: arguments
    		 |
    		 ;

arguments: arguments ',' arg
    	 | arg
    	 ;

arg: type identifier
   ;

stmt: compound_stmt
    | single_stmt
    ;

compound_stmt: '{' statements '}'
             ;

statements: statements stmt
    	  |
    	  ;

print: WRITE '(' STRING ')' ';'
	 | WRITE '(' STRING ',' IDENTIFIER ')' ';'
	 ;

scan: READ '(' STRING ',' '&' IDENTIFIER ')' ';'
	;

single_stmt: if_block
           | for_block
           | while_block
           | declaration
	       | scan
		   | print
           | function_call ';'
		   | RETURN ';'
		   | CONTINUE ';'
		   | BREAK ';'
		   | RETURN sub_expr ';'
    	   ;

for_block: FOR '(' expression_stmt  expression_stmt ')' stmt
    	 | FOR '(' expression_stmt expression_stmt expression ')' stmt
    	 ;

if_block: IF '(' expression ')' stmt 								%prec LOWER_THAN_ELSE
		| IF '(' expression ')' stmt ELSE stmt
        ;

while_block: WHILE '(' expression ')' stmt
		   ;

declaration: type declaration_list ';'
		   | declaration_list ';'
		   | unary_expr ';'
		   ;

declaration_list: declaration_list ',' sub_decl
				| sub_decl
				;

sub_decl: assignment_expr
    	| identifier
    	| array_access
		;

expression_stmt: expression ';'
    		   | ';'
    		   ;

expression: expression ',' sub_expr
    	  | sub_expr
		  ;

sub_expr: sub_expr '>' sub_expr
    	| sub_expr '<' sub_expr
    	| sub_expr EQ sub_expr
    	| sub_expr NOT_EQ sub_expr
    	| sub_expr LS_EQ sub_expr
    	| sub_expr GR_EQ sub_expr
		| sub_expr LOGICAL_AND sub_expr
		| sub_expr LOGICAL_OR sub_expr
		| '!' sub_expr
		| arithmetic_expr
    	| assignment_expr
		| unary_expr
    	;


assignment_expr: lhs assign_op  arithmetic_expr
    		   | lhs assign_op  array_access
    		   | lhs assign_op  function_call
			   | lhs assign_op  unary_expr
			   | unary_expr assign_op  unary_expr
    		   ;

unary_expr:	identifier INCREMENT
		  | identifier DECREMENT
		  | DECREMENT identifier
		  | INCREMENT identifier
		  ;

lhs: identifier
   | array_access
   ;

identifier: IDENTIFIER
    	  ;

assign_op: '='
         | ADD_ASSIGN
         | SUB_ASSIGN
         | MUL_ASSIGN
         | DIV_ASSIGN
         | MOD_ASSIGN
         ;

arithmetic_expr: arithmetic_expr '+' arithmetic_expr
               | arithmetic_expr '-' arithmetic_expr
               | arithmetic_expr '*' arithmetic_expr
               | arithmetic_expr '/' arithmetic_expr
		       | arithmetic_expr '%' arithmetic_expr
		       | '(' arithmetic_expr ')'
               | '-' arithmetic_expr %prec UMINUS
               | identifier
               | constant
               ; 

constant: DEC_CONSTANT
		| CHAR_CONSTANT
		| FLOAT_CONSTANT
    	;

array_access: identifier '[' array_index ']'
			| identifier '[' array_index ']' '[' array_index ']'
			;

array_index: constant
		   | identifier
		   ;

function_call: identifier '(' parameter_list ')'
             | identifier '(' ')'
             ;

parameter_list: parameter_list ',' parameter
              | parameter
              ;

parameter: sub_expr
		 | STRING
		 ;
%%

int main(int argc, char *argv[])
{
	yyin = fopen(argv[1], "r");

	if(!yyparse())
	{
		printf("Parsing Complete\n");
	}
	else
	{
			printf("Parsing Complete!\n");
	}

	fclose(yyin);
	return 0;
}

int yyerror(char *msg)
{
	printf("Line no: %d Error message: %s Token: %s\n", yylineno, msg, yytext);
	printf("PARSING Failed");
	exit(0);
}
