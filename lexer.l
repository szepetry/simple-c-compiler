%{
#include <stdlib.h>
#include <stdio.h>
#include <limits.h>
#include "y.tab.h"
int cmnt_strt = 0;
%}

    //For global line numbers
%option yylineno

letter [a-zA-Z]
digit [0-9]
ws  [ \t\r\f\v]+
id [a-zA-Z][a-zA-Z]*
identifier (_|{letter})({letter}|{digit}|_){0,31}

%x CMNT

%%

    /* Keywords*/
"int"                             {return INT;}
"char"                            {return CHAR;}
"float"                           {return FLOAT;}
"void"                            {return VOID;}
"long"                            {return LONG;}
"long long"                       {return LONG_LONG;}
"short"                           {return SHORT;}
"signed"                          {return SIGNED;}
"unsigned"                        {return UNSIGNED;}
"for"                             {return FOR;}
"while"                           {return WHILE;}
"break"                           {return BREAK;}
"continue"                        {return CONTINUE;}
"if"                              {return IF;}
"else"                            {return ELSE;}
"return"                          {return RETURN;}
"printf"                          {return WRITE;}
"scanf"                          {return READ;}

  /* Headers */
"#include <stdlib.h>"             {}
"#include <stdio.h>"              {}

  /* Constants */
'({letter}|{digit})'              {return CHAR_CONSTANT;}
[+\-]?{digit}+[lLuU]?             {return  DEC_CONSTANT;}
[+\-]?{digit}*\.{digit}+          {return FLOAT_CONSTANT;}

{identifier}                      {return IDENTIFIER;}
{ws}                              ;
{id}                              {return ID;}

  /* Comments */
"/*"                              {cmnt_strt = yylineno; BEGIN CMNT;}
<CMNT>.|{ws}                      ;
<CMNT>\n                          {}
<CMNT>"*/"                        {BEGIN INITIAL;}
<CMNT>"/*"                        {printf("Line %3d: Nested comments are not valid!\n",yylineno);}
<CMNT><<EOF>>                     {printf("Line %3d: Unterminated comment\n", cmnt_strt); yyterminate();}
"//".*                            ;

  /* String stmt */
\"[^\"\n]*\"                        {
                                      return STRING;
                                    }

  /* Unexpected characters */
\"[^\"\n]*$                     {printf("Line %3d: Unterminated string %s\n",yylineno,yytext);}
{digit}+({letter}|_)+	          {printf("Line %3d: Illegal identifier name %s\n",yylineno,yytext);}
\n                              {}

  /* Assignment operators */
"--"			                {return DECREMENT;}
"++"			                {return INCREMENT;}
"+="                      {return ADD_ASSIGN;}
"-="                      {return SUB_ASSIGN;}
"*="                      {return MUL_ASSIGN;}
"/="                      {return DIV_ASSIGN;}
"%="                      {return MOD_ASSIGN;}
"&&"			                {return LOGICAL_AND;}
"||"			                {return LOGICAL_OR;}
"<="			                {return LS_EQ;}
">="			                {return GR_EQ;}
"=="			                {return EQ;}
"!="		                  {return NOT_EQ;}

.                         {return yytext[0];}

%%

int yywrap() { 
    return 1;
} 