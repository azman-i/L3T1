
%{
#include<iostream>
#include <stdio.h>
#include <cstdlib>
#include <cstring>
#include <cmath>
#include <vector>
#include <string>
#include <limits>
#include<fstream>
#include "1505063_symtable.h"
//#define YYSTYPE double      /* yyparse() stack type */
using namespace std;
SymbolTable* ob=new SymbolTable(7);
extern int line_count;
string sn;
extern FILE *yyin;
ofstream llog, eerrors;
vector<string> param_list;
int param_no=0;
int s=0;
void yyerror(const char *s){
	printf("%s\n",s);
}

int yylex(void);

%}
%union{
   hash_Val* info;
}



%token <info> NEWLINE NUMBER PLUS MINUS SLASH ASTERISK LPAREN RPAREN INT FLOAT SEMICOLON VOID COMMA COMMENT STRING IF ELSE FOR WHILE DO BREAK CHAR DOUBLE RETURN SWITCH CASE DEFAULT CONTINUE ADDOP CONST_CHAR LCURL RCURL LTHIRD RTHIRD INCOP DECOP RELOP LOGICOP ASSIGNOP BITOP MULOP NOT CONST_INT CONST_FLOAT 
%token <info> ID
%type <info> start program unit func_declaration func_definition parameter_list compound_statement statements statement expression_statement var_declaration declaration_list type_specifier expression variable logic_expression simple_expression rel_expression term unary_expression factor arguments argument_list
%error-verbose
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE
%start start
%%
start : program;

program :program unit {
                   hash_Val *t=new hash_Val($1->getstr()+$2->getstr());
                   $$=t;
                      llog<<"line no:  "<<line_count<<"    program: program  unit"<<endl;
                      llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                      }
        | unit {
               $$=$1;
                llog<<"line no:  "<<line_count<<"     program : unit"<<endl;
                llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                }
        ;
unit : var_declaration
      {
          $$=$1;
          llog<<"line no:  "<<line_count<<"   unit  :  var_declaration"<<endl;
          llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
          }
    |func_definition
    {
        $$=$1;
        llog<<"line no:  "<<line_count<<"   unit  : func_definition"<<endl;
        llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
        }
    |func_declaration 
    {
        $$=$1;
        llog<<"line no:  "<<line_count<<"    unit   : func_declaration"<<endl;
        llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
        }
     ;
func_declaration : type_specifier ID LPAREN parameter_list RPAREN{ob->InsertCurrent($2->getstr(),"ID","func",true);} SEMICOLON
          {llog<<"line no:  "<<line_count<<"   func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON"<<endl;
                   hash_Val *t=new hash_Val($1->getstr()+" "+$2->getstr()+$3->getstr()+$4->getstr()+$5->getstr()+$7->getstr()+"\n");
                   $$=t;
                   llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                   }
		| type_specifier ID LPAREN RPAREN{ob->InsertCurrent($2->getstr(),"ID","func",true);} SEMICOLON
         {
             llog<<"line no:  "<<line_count<<"   func_declaration :  type_specifier ID LPAREN RPAREN SEMICOLON"<<endl;
             hash_Val *t=new hash_Val($1->getstr()+" "+$2->getstr()+$3->getstr()+$4->getstr()+$6->getstr()+"\n");
             $$=t;
             llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
             }
		;


func_definition : type_specifier ID LPAREN  parameter_list RPAREN{ob->InsertCurrent($2->getstr(),"ID","func",true);cout<<"sssssssss"<<s<<endl;} compound_statement 
            {
                llog<<"line no:  "<<line_count<<"   func_definition  :  type_specifier ID LPAREN parameter_list RPAREN compound_statement"<<endl;
                hash_Val *t=new hash_Val($1->getstr()+" "+$2->getstr()+$3->getstr()+$4->getstr()+$5->getstr()+$7->getstr());
                  //infor *t=new infor("hello");
                $$=t;
                llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                }
                |type_specifier ID LPAREN RPAREN {ob->InsertCurrent($2->getstr(),"ID","func",true);} compound_statement
                 {
                     llog<<"line no:  "<<line_count<<"   func_definition  :  type_specifier ID LPAREN RPAREN compound_statement "<<endl;llog<<endl<<endl<<endl<<$2->getstr()<<endl;
                     hash_Val *t=new hash_Val($1->getstr()+" "+$2->getstr()+$3->getstr()+$4->getstr()+$6->getstr());
                     $$=t;
                     llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                     }
                     ;
    
parameter_list  : parameter_list COMMA type_specifier ID
           {
               llog<<"line no:  "<<line_count<< "parameter_list  : parameter_list COMMA type_specifier ID"<<endl;
               hash_Val *t=new hash_Val($1->getstr()+$2->getstr()+$3->getstr()+" "+$4->getstr());
                // llog<<"$4"<<$4->getstr()<<$3->getstr()<<endl;
                param_list.push_back($4->getstr());
                param_list.push_back($3->getstr());
                s=s+2;
               $$=t;
               llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
         
param_no++;
               }
		| parameter_list COMMA type_specifier
         {
             llog<<"line no:  "<<line_count<< "parameter_list  : parameter_list COMMA type_specifier"<<endl;
            hash_Val *t=new hash_Val($1->getstr()+$2->getstr()+$3->getstr()+" ");
               $$=t;
               llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
param_no++;
             }
 		| type_specifier ID
          {
              llog<<"line no:  "<<line_count<< "parameter_list  : type_specifier ID"<<endl;
              hash_Val *t=new hash_Val($1->getstr()+" "+$2->getstr());
               $$=t;
            param_no++;
                 param_list.push_back($2->getstr());
 param_list.push_back($1->getstr());
     s=s+2;
               llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
              }
		| type_specifier
           {
               llog<<"line no:  "<<line_count<< "parameter_list  : type_specifier "<<endl;
               $$=$1;
                param_no++;
                llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
               }
 		;

compound_statement : LCURL{cout<<"hello"<<endl;ob->EnterScope();for(int i=0;i<param_list.size();i=i+2){ob->InsertCurrent(param_list[i],"ID",param_list[i+1],false);cout<<param_list[i]<<endl;}param_list.clear();	ob->PrintAll();cout<<"here"<<endl;} RCURL
             {
                 llog<<"line no:  "<<line_count<< "compound_statement : LCURL RCURL"<<endl;
                 hash_Val *t=new hash_Val("\n"+$1->getstr()+$3->getstr()+"\n");
                 $$=t;
                 llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                   ob->PrintAll();
                   ob->ExitScope();
                 }
                   |LCURL{ob->EnterScope();cout<<s<<endl;for(int i=0;i<s;i=i+2){ob->InsertCurrent(param_list[i],"ID",param_list[i+1],false);cout<<param_list[i]<<endl;}param_list.clear();ob->PrintAll();s=0;cout<<"here"<<endl;} statements RCURL
                    {
                        llog<<"line no:  "<<line_count<< "compound_statement : LCURL statements RCURL"<<endl;
                        hash_Val *t=new hash_Val("\n"+$1->getstr()+"\n"+$3->getstr()+"\n"+$4->getstr()+"\n");
                 $$=t;
                 
                 llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                  ob->PrintAll();
                  ob->ExitScope();
                        }
                    ;
statements : statement
            {
                llog<<"line no:  "<<line_count<< "statements : statement"<<endl;
                $$=$1;
                llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
            }
            |statements statement
              {
                  llog<<"line no:  "<<line_count<< "statements : statements statement"<<endl;
                  hash_Val *t=new hash_Val($1->getstr()+$2->getstr());
                  $$=t;
                  llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                  }
            ;
statement : compound_statement
          {
              llog<<"line no:  "<<line_count<< " statement  :  compound_statement"<<endl;
              $$=$1;
              llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
              }
          | IF LPAREN expression RPAREN statement
           {
               llog<<"line no"<<line_count<<" statement : IF LPAREN expression RPAREN statement"<<endl;
               hash_Val *t=new hash_Val($1->getstr()+$2->getstr()+$3->getstr()+$4->getstr()+$5->getstr()); 
               $$=t;
               llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
               } %prec LOWER_THAN_ELSE ;
          | IF LPAREN expression RPAREN statement ELSE statement
          {
              llog<<"line no"<<line_count<<" statement : IF LPAREN expression RPAREN statement ELSE statement"<<endl;
              hash_Val *t=new hash_Val($1->getstr()+$2->getstr()+$3->getstr()+$4->getstr()+$5->getstr()+$6->getstr()+$7->getstr()); 
              $$=t;
              llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
              }
          |var_declaration
           {
               llog<<"line no"<<line_count<<" statement  :  var_declaration"<<endl;
               $$=$1;
               llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
               }
          | FOR LPAREN expression_statement expression_statement expression RPAREN statement
           {
               llog<<"line no"<<line_count<<"  statement  :  FOR LPAREN expression_statement expression_statement expression RPAREN statement"<<endl;
               hash_Val *t=new hash_Val($1->getstr()+$2->getstr()+$3->getstr()+$4->getstr()+$5->getstr()+$6->getstr()+$7->getstr()); 
               $$=t;
               llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
               }
          | WHILE LPAREN expression RPAREN statement
           {
               llog<<"line no"<<line_count<<"statement  :  WHILE LPAREN expression RPAREN statement "<<endl;
               hash_Val *t=new hash_Val($1->getstr()+$2->getstr()+$3->getstr()+$4->getstr()+$5->getstr()); 
               $$=t;
               llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
               }
          | RETURN expression SEMICOLON
           {
               llog<<"line no"<<line_count<<"  statement  : RETURN expression SEMICOLON "<<endl;
               hash_Val *t=new hash_Val($1->getstr()+" "+$2->getstr()+$3->getstr()+"\n");
               $$=t;llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
               }
          |  expression_statement
           {
               llog<<"line no"<<line_count<<"statement  :  expression_statement"<<endl;
               $$=$1;
               llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
               }
           ;
expression_statement : SEMICOLON 
            {
                llog<<"line no"<<line_count<<"  expression_statement : SEMICOLON"<<endl;
                $$=$1;
                llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                }
                     |expression SEMICOLON
                      {
                          llog<<"line no"<<line_count<<"  expression_statement :expression SEMICOLON"<<endl;
                         hash_Val *t=new hash_Val($1->getstr()+$2->getstr()+"\n");
                          $$=t;
                          llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;

                          }
                    ;
 
var_declaration : type_specifier declaration_list SEMICOLON  
                  {
                    llog<<"line no"<<line_count<<" var_declaration : type_specifier declaration_list SEMICOLON"<<endl;
                    hash_Val *tt=new hash_Val($1->getstr()+" "+$2->getstr()+$3->getstr()+"\n");
                    $$=tt;
                    
                   for(int i=0;i<param_list.size();i++)
                      {
                      ob->InsertCurrent(param_list[i],"ID",$1->getstr(),false);
                    }
param_list.clear();
                  llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                    }

                ;
declaration_list : declaration_list COMMA ID
                {
                    llog<<"line no"<<line_count<<" declaration_list : declaration_list COMMA ID"<<endl;llog<<endl<<endl<<endl<<$3->getstr()<<endl;
                    hash_Val *tt=new hash_Val($1->getstr()+$2->getstr()+$3->getstr());
                    $$=tt;
                    llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                 
                  param_list.push_back($3->getstr());
                 
               //ob->InsertCurrent($3->getstr(),"ID",sn,false);
                  //  ob->PrintAll();
                    //llog<<"hashjsxas"<<endl;
                    }
                 | ID
                 {
                     llog<<"line no"<<line_count<<" declaration_list : ID"<<endl;
                     $$=$1;
                      param_list.push_back($1->getstr());
                     llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                     } 
                 |ID LTHIRD CONST_INT RTHIRD
                  {
                       param_list.push_back($1->getstr());
                      llog<<"line no"<<line_count<<" declaration_list : ID LTHIRD CONST_INT RTHIRD"<<endl;
                      hash_Val *tt=new hash_Val($1->getstr()+$2->getstr()+$3->getstr()+$4->getstr());
                      $$=tt;
                      llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                      }
                 |declaration_list COMMA ID LTHIRD CONST_INT RTHIRD
                  {
                      llog<<"line no"<<line_count<<" declaration_list : declaration_list COMMA ID LTHIRD CONST_INT RTHIRD"<<endl;
                      hash_Val *tt=new hash_Val($1->getstr()+$2->getstr()+$3->getstr()+$4->getstr()+$5->getstr()+$6->getstr());
                      $$=tt;
                      llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                        param_list.push_back($3->getstr());
                      }
                 ;
type_specifier	: INT 
           {
               $$=$1;
               llog<<"line no"<<line_count<<"type_specifier	: INT"<<endl;
               llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
               }
 		| FLOAT
             {
                 $$=$1;
                 llog<<"line no"<<line_count<<"type_specifier	: FLOAT"<<endl;
                 llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                 }
 		| VOID
          {
              $$=$1;
              llog<<"line no"<<line_count<<"type_specifier	: VOID"<<endl;
              llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
              }
                 ;
expression : logic_expression
                   {
                       llog<<"line no"<<line_count<<"expression : logic_expression"<<endl;
                       $$=$1;
                       llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
 llog<<endl<<endl<<endl<<$$->gettype()<<endl<<endl<<endl;
                       }
           | variable ASSIGNOP logic_expression
            {
                llog<<"line no"<<line_count<<"expression :   variable ASSIGNOP logic_expression "<<endl;
                hash_Val *t=new hash_Val($1->getstr()+$2->getstr()+$3->getstr());
                $$=t;
                llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                }
           ;
variable : ID
    {
        llog<<"line no"<<line_count<<"variable : ID  "<<endl;
  hash_Val *t;
    if(ob->look($1->getstr(),1)!=0)
      { // cout<<"iamnot   "<<ob->look($1->getstr(),1)->gettype()<<ob->look($1->getstr(),1)->isfunction;
        t=new hash_Val($1->getstr(),ob->look($1->getstr(),1)->gettype(),ob->look($1->getstr(),1)->isfunction);}
else if(ob->searchinroot($1->getstr())!=0)
{
   //cout<<"iamnot   "<<ob->searchinroot($1->getstr())->gettype()<<ob->searchinroot($1->getstr())->isfunction;
        t=new hash_Val($1->getstr(),ob->searchinroot($1->getstr())->gettype(),ob->searchinroot($1->getstr())->isfunction);
     
}
else
{
   eerrors<<"line no     "<<line_count<<"Variable not declared"<<endl;
        t=new hash_Val($1->getstr(),"not",false);
}
        $$=t;       
        llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
//llog<<endl<<endl<<endl<<$$->gettype()<<"buet"<<endl<<endl<<endl;
        }
         | ID LTHIRD expression RTHIRD
          {
              llog<<"line no"<<line_count<<"variable :  ID LTHIRD expression RTHIRD"<<endl;
                hash_Val *t=new hash_Val($1->getstr()+$2->getstr()+$3->getstr()+$4->getstr());
                $$=t;
                llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
               
              }
         ;
logic_expression : rel_expression
               {
                   llog<<"line no"<<line_count<<"logic_expression : rel_expression "<<endl;
                   $$=$1;
                   llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                   } 
                 | rel_expression LOGICOP rel_expression
                   {
                       llog<<"line no"<<line_count<<"logic_expression :  rel_expression LOGICOP rel_expression "<<endl;
                       hash_Val *t=new hash_Val($1->getstr()+$2->getstr()+$3->getstr(),"int",false);
                $$=t;
                llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                       } 
                ;
rel_expression	:  simple_expression RELOP simple_expression
              {
                  llog<<"line no"<<line_count<<"rel_expression	:  simple_expression RELOP simple_expression "<<endl;
                  hash_Val *t=new hash_Val($1->getstr()+$2->getstr()+$3->getstr());
                  $$=t;
                  llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                  }
                | simple_expression
                  {
                      llog<<"line no"<<line_count<<"rel_expression	:  simple_expression "<<endl;
                      $$=$1;
                      llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                      }
                 ;
simple_expression : simple_expression ADDOP term
               {
                   llog<<"line no"<<line_count<<"simple_expression : simple_expression ADDOP term"<<endl;
                   hash_Val *t=new hash_Val($1->getstr()+$2->getstr()+$3->getstr());
                   $$=t;
                   llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
               }
                   | term
                     {
                         llog<<"line no"<<line_count<<"simple_expression : term"<<endl;
                         $$=$1;
                         llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                         }
                   ;
term : term MULOP unary_expression
	{
        llog<<"line no"<<line_count<<"term : term MULOP unary_expression"<<endl;
 //llog<<"type type type"<<$1->gettype()<<$1->getstr()<<$3->gettype()<<$3->getstr()<<endl;
     hash_Val *t;
      if($1->gettype()=="float"||$3->gettype()=="float")
        t=new hash_Val($1->getstr()+$2->getstr()+$3->getstr(),"float",false);
      else
        t=new hash_Val($1->getstr()+$2->getstr()+$3->getstr(),"int",false);
      //  llog<<"type type type"<<$1->gettype()<<$1->getstr()<<$3->gettype()<<$3->getstr()<<endl;
         if($2->getstr()=="%")
        {
       if($1->gettype()!="int"||$3->gettype()!="int")
          eerrors<<"line no    "<<line_count<<"Both operand of modulus operator should be integer."<<endl<<$1->gettype()<<$3->gettype()<<endl;}
        $$=t;
    //llog<<"type type type"<<$1->gettype()<<$1->getstr()<<$3->gettype()<<$3->getstr()<<$$->gettype()<<endl;
        llog<<endl<<endl<<endl<<$$->gettype()<<endl<<endl<<endl;
        }
     |unary_expression
       {
           llog<<"line no"<<line_count<<"term : unary_expression"<<endl;
           $$=$1;
           llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
           }
      ; 
unary_expression :ADDOP unary_expression
            {
                llog<<"line no"<<line_count<<"unary_expression :ADDOP unary_expression"<<endl;
                hash_Val *t=new hash_Val($1->getstr()+$2->getstr());
                $$=t;
                llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                }
                 |NOT unary_expression
                   {
                       llog<<"line no"<<line_count<<"unary_expression : NOT unary_expression"<<endl;
                       hash_Val *t=new hash_Val($1->getstr()+$2->getstr());
                       $$=t;
                       llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                       }
                 |factor
                  {
                      
                      llog<<"line no"<<line_count<<"unary_expression : factor"<<endl;
                      $$=$1;
                      llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                      }
                 ;
factor	: variable
       {
           llog<<"line no"<<line_count<<" factor  :  variable"<<endl<<endl<<endl;
                     $$=$1;
                     llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                     
                     }
        | ID LPAREN argument_list RPAREN
         {
             llog<<"line no"<<line_count<<" factor : ID LPAREN argument_list RPAREN"<<endl;
             hash_Val *t=new hash_Val($1->getstr()+$2->getstr()+$3->getstr()+$4->getstr());
             $$=t;
             llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
             }
        | variable INCOP
          {
              llog<<"line no"<<line_count<<" factor  :  variable INCOP"<<endl;
               hash_Val *t=new hash_Val($1->getstr()+$2->getstr());
              $$=t;
              llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
              }
	 | variable DECOP
       {
           llog<<"line no"<<line_count<<" factor  :  variable DECOP"<<endl;
        hash_Val *t=new hash_Val($1->getstr()+$2->getstr());
              $$=t;
              llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
           }
         | LPAREN expression RPAREN
          {
              llog<<"line no"<<line_count<<" factor  :  LPAREN expression RPAREN"<<endl;
              hash_Val *t=new hash_Val($1->getstr()+$2->getstr()+$3->getstr(),$2->gettype(),false);
              $$=t;
              llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
              }
         | CONST_FLOAT
          {
              llog<<"line no"<<line_count<<" factor  :  CONST_FLOAT"<<endl;
             
              $$=$1;
              llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
         //llog<<endl<<"iamherefloat"<<endl<<$$->gettype()<<endl<<endl<<endl;
              }
        |CONST_INT
         {
             llog<<"line no"<<line_count<<" factor  :  CONST_INT"<<endl;
             $$=$1;
             llog<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
             }
        ; 
argument_list : arguments
              {
                  llog<<"line no"<<line_count<<" argument_list : arguments"<<endl;
                  $$=$1;
                  llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                  }
			  |
              {
                  hash_Val *t=new hash_Val("");
                  $$=t;
                  llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                  }
			  ;
arguments :  logic_expression
              {
                  llog<<"line no"<<line_count<<" arguments : logic_expression"<<endl;
                  $$=$1;
                  llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                  }
	      | arguments COMMA logic_expression 
          {
              llog<<"line no"<<line_count<<" factor  : arguments COMMA logic_expression"<<endl;
              hash_Val *t=new hash_Val($1->getstr()+$2->getstr()+$3->getstr());
              $$=t;
              llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
              }
          ;


%%

int main(int argc,char *argv[])
{
    if((yyin=fopen(argv[1],"r"))==NULL)
	{
		printf("Cannot Open Input File.\n");
		exit(1);
	}

	llog.open("log.txt");
	eerrors.open("errors.txt");
	
	
      yyparse();
      llog.close();
	eerrors.close();

    exit(0);
}
