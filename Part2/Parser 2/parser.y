%nonassoc NO_ELSE
%nonassoc ELSE
%left '<' '>' '=' GE_OP LE_OP EQ_OP NE_OP
%left  '+'  '-'
%left  '*'  '/' '%'
%left  '|'
%left  '&'
%token IDENTIFIER STRING_CONSTANT CHAR_CONSTANT INT_CONSTANT FLOAT_CONSTANT SIZEOF
%token INC_OP DEC_OP LEFT_OP RIGHT_OP LE_OP GE_OP EQ_OP NE_OP
%token AND_OP OR_OP MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN
%token SUB_ASSIGN LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN
%token XOR_ASSIGN OR_ASSIGN TYPE_NAME DEF
%token CHAR SHORT INT LONG SIGNED UNSIGNED FLOAT DOUBLE CONST VOID
%token IF ELSE WHILE CONTINUE BREAK RETURN
%start start_state
%nonassoc UNARY
%glr-parser

%{
#include<string.h>
char type[100];
char temp[100];
extern int yylineno;
extern int err;
int nestingLevel;
%}

%%

start_state
	: global_declaration
	| start_state global_declaration
	;

global_declaration
	: function_definition
	| declaration
	;

function_definition
	: declaration_specifiers declarator compound_statement
	| declarator compound_statement
	;

fundamental_exp
	: IDENTIFIER
	| STRING_CONSTANT		{ ConstantInsert($1, "string"); }
	| CHAR_CONSTANT     { ConstantInsert($1, "char"); }
	| FLOAT_CONSTANT	  { ConstantInsert($1, "float"); }
	| INT_CONSTANT			{ ConstantInsert($1, "int"); }
	| '(' expression ')'
	;


secondary_exp
	: fundamental_exp
	| secondary_exp '[' expression ']'
	| secondary_exp '(' ')'
	| secondary_exp '(' arg_list ')'
	| secondary_exp '.' IDENTIFIER
	| secondary_exp INC_OP
	| secondary_exp DEC_OP
	;

arg_list
	: assignment_expression
	| arg_list ',' assignment_expression
	;

unary_expression
	: secondary_exp
	| INC_OP unary_expression
	| DEC_OP unary_expression
	| unary_operator typecast_exp
	;

unary_operator
	: '&'
	| '*'
	| '+'
	| '-'
	| '~'
	| '!'
	;

typecast_exp
	: unary_expression
	| '(' type_name ')' typecast_exp
	;

multdivmod_exp
	: typecast_exp
	| multdivmod_exp '*' typecast_exp
	| multdivmod_exp '/' typecast_exp
	| multdivmod_exp '%' typecast_exp
	;

addsub_exp
	: multdivmod_exp
	| addsub_exp '+' multdivmod_exp
	| addsub_exp '-' multdivmod_exp
	;

shift_exp
	: addsub_exp
	| shift_exp LEFT_OP addsub_exp
	| shift_exp RIGHT_OP addsub_exp
	;

relational_expression
	: shift_exp
	| relational_expression '<' shift_exp
	| relational_expression '>' shift_exp
	| relational_expression LE_OP shift_exp
	| relational_expression GE_OP shift_exp
	;

equality_expression
	: relational_expression
	| equality_expression EQ_OP relational_expression
	| equality_expression NE_OP relational_expression
	;

and_expression
	: equality_expression
	| and_expression '&' equality_expression
	;

exor_expression
	: and_expression
	| exor_expression '^' and_expression
	;

unary_or_expression
	: exor_expression
	| unary_or_expression '|' exor_expression
	;

logical_and_expression
	: unary_or_expression
	| logical_and_expression AND_OP unary_or_expression
	;

logical_or_expression
	: logical_and_expression
	| logical_or_expression OR_OP logical_and_expression
	;

conditional_expression
	: logical_or_expression
	| logical_or_expression '?' expression ':' conditional_expression
	;

assignment_expression
	: conditional_expression
	| unary_expression assignment_operator assignment_expression
	;

assignment_operator
	: '='
	| MUL_ASSIGN
	| DIV_ASSIGN
	| MOD_ASSIGN
	| ADD_ASSIGN
	| SUB_ASSIGN
	| LEFT_ASSIGN
	| RIGHT_ASSIGN
	| AND_ASSIGN
	| XOR_ASSIGN
	| OR_ASSIGN
	;

expression
	: assignment_expression
	| expression ',' assignment_expression
	;

constant_expression
	: conditional_expression
	;

declaration
	: declaration_specifiers init_declarator_list ';'
	| error
	;

declaration_specifiers
	: type_specifier	{ strcpy(type, $1); }
	| type_specifier declaration_specifiers	{ strcpy(temp, $1); strcat(temp, " "); strcat(temp, type); strcpy(type, temp); }
	;

init_declarator_list
	: init_declarator
	| init_declarator_list ',' init_declarator
	;

init_declarator
	: declarator
	| declarator '=' init
	;

type_specifier
	: VOID			{ $$ = "void"; }
	| CHAR			{ $$ = "char"; }
	| SHORT			{ $$ = "short"; }
	| INT			{ $$ = "int"; }
	| LONG			{ $$ = "long"; }
	| SIGNED		{ $$ = "signed"; }
	| UNSIGNED	{ $$ = "unsigned"; }
	;

type_specifier_list
	: type_specifier type_specifier_list
	| type_specifier
	;

declarator
	: direct_declarator
	;

direct_declarator
	: IDENTIFIER								{  SymbolInsert($1, type); }
	| '(' declarator ')'
	| direct_declarator '[' constant_expression ']'
	| direct_declarator '[' ']'
	| direct_declarator '(' parameter_type_list ')'
	| direct_declarator '(' identifier_list ')'
	| direct_declarator '(' ')'
	;


parameter_type_list
	: parameter_list
	;

parameter_list
	: parameter_declaration
	| parameter_list ',' parameter_declaration
	;

parameter_declaration
	: declaration_specifiers declarator
	| declaration_specifiers abstract_declarator
	| declaration_specifiers
	;

identifier_list
	: IDENTIFIER
	| identifier_list ',' IDENTIFIER
	;

type_name
	: type_specifier_list
	| type_specifier_list abstract_declarator
	;

abstract_declarator
	: direct_abstract_declarator
	;

direct_abstract_declarator
	: '(' abstract_declarator ')'
	| '[' ']'
	| '[' constant_expression ']'
	| direct_abstract_declarator '[' ']'
	| direct_abstract_declarator '[' constant_expression ']'
	| '(' ')'
	| '(' parameter_type_list ')'
	| direct_abstract_declarator '(' ')'
	| direct_abstract_declarator '(' parameter_type_list ')'
	;

init
	: assignment_expression
	| '{' init_list '}'
	| '{' init_list ',' '}'
	;

init_list
	: init
	| init_list ',' init
	;

statement
	: compound_statement
	| expression_statement
	| selection_statement
	| iteration_statement
	| jump_statement
	;

compound_statement
	: '{' '}'
	| '{' statement_list '}'
	| '{' declaration_list '}'
	| '{' declaration_list statement_list '}'
	| '{' declaration_list statement_list declaration_list statement_list '}'
	| '{' declaration_list statement_list declaration_list '}'
	| '{' statement_list declaration_list statement_list '}'
	;

declaration_list
	: declaration
	| declaration_list declaration
	;

statement_list
	: statement
	| statement_list statement
	;

expression_statement
	: ';'
	| expression ';'
	;

selection_statement
	: IF '(' expression ')' statement %prec NO_ELSE
	| IF '(' expression ')' statement ELSE statement
	;

iteration_statement
	: WHILE '(' expression ')' statement
	;

jump_statement
	: CONTINUE ';'
	| BREAK ';'
	| RETURN ';'
	| RETURN expression ';'
	;

%%
#include"lex.yy.c"
#include <ctype.h>
#include <stdio.h>
#include <string.h>

struct Symbol
{
	char token[100];	//Name of the identifier
	char tokenType[100];	//Type of identifier
	int boundary_begin;
	int boundary_end;
	int nesting_level;
	int attributeNo;	//Attribute number in list

}SymbolTable[100000]; 

struct Constant
{
	char token[100];	//Name of constant;
	char dataType[100];	//Datatype of constant
	int lineNo;		//Line number in which it is detected
	int attributeNo;	//Attribute number in list

}ConstantTable[100000];


int s=0;	// Number of symbols in the symbol table
int c=0;	// Number of consant in the constant table

// Function to insert value in Constant Table
void ConstantInsert(char* tokenName, char* datatype)
{
	strcpy(ConstantTable[c].token, tokenName);
	strcpy(ConstantTable[c].dataType, datatype);
	ConstantTable[c].lineNo = yylineno;
	ConstantTable[c].attributeNo = c+1;
	c++;
}

// Function to print values in Constant Table
void showConstantTable()
{
	printf("\n\n\n*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* CONSTANT TABLE *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*\n\n");
	printf("Attribute Number\t    Line number\t\tConstant value\t\tDataType\n\n");
	int itr;
	for(itr=0;itr<c;itr++){
		printf("\t%d\t\t\t%d\t\t\t%s\t\t  %s\n",ConstantTable[itr].attributeNo,ConstantTable[itr].lineNo,ConstantTable[itr].token,ConstantTable[itr].dataType);
	}
}

// Function to insert value in Symbol Table
void SymbolInsert(char* tokenName, char* tokenType)
{
	strcpy(SymbolTable[s].token, tokenName);
	strcpy(SymbolTable[s].tokenType, tokenType);
	SymbolTable[s].boundary_begin = yylineno;
	SymbolTable[s].boundary_end = -1;
	SymbolTable[s].nesting_level = nestingLevel;
	SymbolTable[s].attributeNo = c+1;
	s++;
}

// Function to print values in Symbol Table
void showSymbolTable()
{
	printf("\n\n\n*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-* SYMBOL TABLE *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*\n\n");
	printf("Attribute Number\tBoundary lines\t\tName\t\tDataType\n\n");
	int itr;
	for(itr=0;itr<s;itr++){
		printf("\t%d\t\t    %d - %d\t\t%s\t\t  %s\n",SymbolTable[itr].attributeNo,SymbolTable[itr].boundary_begin,SymbolTable[itr].boundary_end,SymbolTable[itr].token,SymbolTable[itr].tokenType);
	}
}

//Function to decide boundary size in Symbol List
void BoundarySymbolTable()
{
	int itr;
	for(itr = 0; itr < s; itr++){
		if(SymbolTable[itr].nesting_level == nestingLevel && SymbolTable[itr].boundary_end==-1 ){
			SymbolTable[itr].boundary_end = yylineno;
		}
	}
	nestingLevel--;
}


int main(int argc, char *argv[])
{
	yyin = fopen(argv[1], "r");
	yyparse();
	if(err==0)
		printf("\nPARSING COMPLETE\n");
	else
		printf("\nPARSING FAILED\n");
	fclose(yyin);

	showSymbolTable();
	showConstantTable();
	return 0;
}
extern char *yytext;
yyerror(char *s)
{
	err=1;
	printf("\nLine %d : %s\n", (yylineno), s);
	printf("Parsing aborted!");
	showSymbolTable();
	showConstantTable();
	exit(0);
}