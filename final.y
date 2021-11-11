%{
#include <stdio.h>
#include <string.h>
void yyerror(const char *message);
int yylex();
struct var{
	int i[10];
	char* s[10];
}v;
int pos=0;
int tempt = 0;
%}
%union {
	int ival;
	char* str;
	struct n{
		int i;
		char* s;
	}node;
}
%token <str>print_num print_bool NOT MOD AND OR IF 
%token <ival> number
%token <str> bool_val mod and or not id def fun ift lambda
%type <node> PROGRAM PRINT_STMT STMT STMTS EXP NUM_OP LOGICAL_OP
%type <node> DEF_STMT VARIABLE FUN_EXP AND_OP NOT_OP OR_OP
%type <node> EXP_PLUS EXP_MUL EXP_EQL EXP_AND EXP_OR NUM_OPC
%type <node> IF_EXP TEST_EXP THEN_EXP ELSE_EXP
%type <node> FUN_IDS FUN_BODY FUN_CALL PARAM LAST_EXP FUN_NAME
%type <node> SMALLER GREATER EQUAL MODULUS DIVIDE MULTIPLY MINUS PLUS
%%
PROGRAM 	: STMTS	{}
		;
STMTS		: STMT STMTS	{}
		| STMT		{}
		;
STMT 		: EXP		{}
		| DEF_STMT	{}
		| PRINT_STMT	{}
		;
PRINT_STMT	: '(' print_num EXP ')'	{printf("%d \n",$3.i);}
		| '(' print_bool EXP ')'	{printf("%s \n",$3.s);}
		;
EXP		: bool_val	{$$.s = $1;}
		| number	{$$.i = $1;}
		| VARIABLE	{tempt = $1.i;$$.s = v.s[tempt]; $$.i = v.i[tempt];}
		| NUM_OP	{$$ = $1;}
		| NUM_OPC	{$$ = $1;}
		| LOGICAL_OP	{$$ = $1;}
		| IF_EXP	{$$ = $1;}
		;
EXP_PLUS	: EXP EXP_PLUS	{$$.i = $1.i + $2.i;}
		| EXP			{$$ = $1;}
		;
EXP_MUL	: EXP EXP_MUL	{$$.i = $1.i * $2.i;}
		| EXP			{$$ = $1;}
		;
EXP_EQL	: EXP EXP_EQL 	{if($1.i==$2.i)
						{$$.s = 	"#t";}
					 else
						{$$.s = "#f";}
					}
		| EXP			{$$ = $1;}
		;
EXP_AND	: EXP EXP_AND	{if(strcmp($1.s,"#t")&&strcmp($2.s,"#t"))
						{$$.s = "#t";}
					 else
						{$$.s = "#f";}
					}
		| EXP			{$$ = $1;}
		;
EXP_OR	: EXP EXP_OR		{if(strcmp($1.s,"#t")||strcmp($2.s,"#t"))
						{$$.s = "#t";}
					 else
						{$$.s = "#f";}
					}
		| EXP			{$$ = $1;}
		;
NUM_OP	: PLUS		{$$ = $1;}
		| MINUS	{$$ = $1;}
		| MULTIPLY	{$$ = $1;}
		| DIVIDE	{$$ = $1;}
		| MODULUS	{$$ = $1;}
		;
NUM_OPC	: GREATER	{$$ = $1;}
		| SMALLER	{$$ = $1;}
		| EQUAL	{$$ = $1;}
		;
PLUS		: '(' '+' EXP EXP_PLUS ')'	{$$.i = $3.i + $4.i;}
		;
MINUS		: '(' '-' EXP EXP ')'		{$$.i = $3.i - $4.i;}
		;
MULTIPLY	: '(' '*' EXP EXP_MUL ')'	{$$.i = $3.i * $4.i;}
		;
DIVIDE		: '(' '/' EXP EXP ')'		{$$.i = $3.i / $4.i;}
		;
MODULUS	: '(' MOD EXP EXP ')'		{$$.i = $3.i % $4.i;}
		;
GREATER	: '(' '>' EXP EXP ')'		{if($3.i>$4.i)
							{$$.s = "#t";}
						 else
							{$$.s = "#f";}
						}
		; 
SMALLER	: '(' '<' EXP EXP ')'		{if($3.i<$4.i)
							{$$.s = "#t";}
						 else
							{$$.s = "#f";}
						}
		;
EQUAL		: '(' '=' EXP EXP_EQL ')'		{if($3.i==$4.i)
							{$$.s = "#t";}
						 else
							{$$.s = "#f";}
						}
		;
LOGICAL_OP	: AND_OP	{$$ = $1;}
		| OR_OP	{$$ = $1;}
		| NOT_OP	{$$ = $1;}
		;
AND_OP	: '(' AND EXP EXP_AND ')'	{
					if(strcmp($3.s,"#t")==0&&strcmp($4.s,"#t")==0)
						{$$.s = "#t";}
					 else
						{$$.s = "#f";}
						}
		;
OR_OP		: '(' OR EXP EXP_OR ')'	{
					if(strcmp($3.s,"#t")==0||strcmp($4.s,"#t")==0)
						{$$.s = "#t";}
					 else
						{$$.s = "#f";}
					}
		;
NOT_OP	: '(' NOT  EXP ')'		{
					if(strcmp($3.s,"#t")==0)
						{$$.s = "#f";}
					else
						{$$.s = "#t";}
					}
		;
DEF_STMT	: '(' def VARIABLE EXP ')'		{v.i[$3.i]=$4.i;v.s[$3.i]=$3.s;}
		;
VARIABLE	: id	{int in = 0;
			 int remember = 0;
			for(int a=0;a<pos;a++){
				if(strcmp($1,v.s[a])==0){
					remember = a;
					in = 1;
					}
				}
			if (in==1){$$.i=remember;}
			else{$$.s=$1;$$.i=pos;pos++;}
			}			
		;
IF_EXP		: '(' IF TEST_EXP THEN_EXP ELSE_EXP ')'	{if(strcmp("#t",$3.s)==0){
								 $$=$4;}
								 else{
								 $$=$5;}
								}
		;
TEST_EXP	: EXP	{$$=$1;}
		;
THEN_EXP	: EXP	{$$=$1;}
		;
ELSE_EXP	: EXP	{$$=$1;}
		;
%%
void yyerror (const char *message)
{	
	fprintf(stderr,"%s/n",message);
}

int main(int argc, char *argv[]) {
        yyparse();
        return(0);
}
