%{
#include "final.tab.h"
#include <string.h>
#include <stdio.h>
%}
letter       [a-z] 
digit		 [0-9] 
%%
\n|[ ]|\t|\r		 { }
0|[1-9]{digit}*|-[1-9]{digit}*	{yylval.ival = atoi(yytext); return(number);}
"#t"|"#f"	{ yylval.str = strdup(yytext);return(bool_val);}
"print-num"	{ yylval.str = strdup(yytext);return(print_num);}
"print-bool" 	{ yylval.str = strdup(yytext);return(print_bool);}
"define"	{return(def);}
"lambda"	{return(lambda);}
"+"|"-"|"*"|"/"|">"|"<"|"="	{return(yytext[0]);}
"mod"	{return(MOD);}
"and"	{return(AND);}
"or"	{return(OR);}
"if"    {return(IF);}
"not"	{return(NOT);}
[\t ]+|[\n]+|][\r]+|" "+	{}
{letter}({letter}|{digit}|[-])*	{yylval.str = strdup(yytext);return(id);}
.	{return(yytext[0]);}
%%