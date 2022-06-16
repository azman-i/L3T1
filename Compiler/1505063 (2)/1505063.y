
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
#include<algorithm>
#include "1505063_symtable.h"
//#define YYSTYPE double      /* yyparse() stack type */
using namespace std;
SymbolTable* ob=new SymbolTable(7);
extern int line_count;
string sn;
extern FILE *yyin;
ofstream llog, eerrors;
vector<string> param_list;
vector<string> arg_list;
vector<string> ret_list;
string ds_code=".MODEL SMALL\n.STACK 100H\n.DATA\n  retu DW ?\n";
string main_code=" ";
string outdec = "OUTDEC PROC\n\
;INPUT AX\n\
PUSH AX\n\
PUSH BX\n\
PUSH CX\n\
PUSH DX\n\
OR AX,AX\n\
JGE @END_IF1\n\
PUSH AX\n\
MOV DL,'-'\n\
MOV AH,2\n\
INT 21H\n\
POP AX\n\
NEG AX\n\
\n\
@END_IF1:\n\
XOR CX,CX\n\
MOV BX,10D\n\
\n\
@REPEAT1:\n\
XOR DX,DX\n\
DIV BX\n\
PUSH DX\n\
INC CX\n\
OR AX,AX\n\
JNE @REPEAT1\n\
\n\
MOV AH,2\n\
\n\
@PRINT_LOOP:\n\
\n\
POP DX\n\
OR DL,30H\n\
INT 21H\n\
LOOP @PRINT_LOOP\n\
\n\
POP DX\n\
POP CX\n\
POP BX\n\
POP AX\n\
RET\n\
OUTDEC ENDP\n\
";

int param_no=0;
int temp_num=0;
int label_count=0;
int s=0;
int error_count=0;
void yyerror(const char *s){
	printf("%s\n",s);
    //eerrors<<"line count     :   "<<line_count<<"      "<<s<<endl;
    error_count++;
    // eerrors<<"Total error  :  "<<error_count<<endl;
}

int yylex(void);

string newtemp()
{
   string s="";
   string st="t"+to_string(temp_num);
   s=s+"t"+to_string(temp_num)+"   DW ?\n";
   ds_code=ds_code+s;
   temp_num++;
   return st;
}
string getupper(string str)
{
 int i;
  for(i=0;i<str.length();i++)
{
     if(str.at(i)>=97&&str.at(i)<=122)
     str.at(i)=str.at(i)-32;
}
    return str;
}
string getfunctiontype(string str)
{
  hash_Val *t=0;
   hash_Map *c=ob->cur;
while(t==0)
{
   t=ob->cur->search_item(str,1);
   ob->setCurrentParent();
}
  ob->cur=c;
   return t->type;
    
}
bool getisfunction(string str)
{
  hash_Val *t=0;
   hash_Map *c=ob->cur;
while(t==0)
{
   t=ob->cur->search_item(str,1);
   ob->setCurrentParent();
}
  ob->cur=c;
   return t->isfunction;
    
}
int getID(string str)

{
 hash_Val *t;
    hash_Map *c=ob->cur;
   while(ob->getisfu()!=true)
          {
          
           if(ob->look(str,1)!=0)
         {
               llog<<"yes"<<ob->cur->id<<endl;
           hash_Map *ci=ob->cur;
           ob->cur=c;
             return ci->id;
         }
          ob->setCurrentParent();
      }


    
   llog<<"here1"<<endl;


}
string newLabel()
{
   string s="";
   string st="Label"+to_string(label_count);
   label_count++;
   return st;
}

%}
%union{
   hash_Val* info;
}



%token <info> NEWLINE NUMBER PLUS MINUS SLASH ASTERISK LPAREN RPAREN INT FLOAT SEMICOLON VOID COMMA COMMENT STRING IF ELSE FOR WHILE DO BREAK CHAR DOUBLE RETURN SWITCH CASE DEFAULT CONTINUE ADDOP CONST_CHAR LCURL RCURL LTHIRD RTHIRD INCOP DECOP RELOP LOGICOP ASSIGNOP BITOP MULOP NOT CONST_INT CONST_FLOAT PRINTLN
%token <info> ID
%type <info> start program unit func_declaration func_definition parameter_list compound_statement statements statement expression_statement var_declaration declaration_list type_specifier expression variable logic_expression simple_expression rel_expression term unary_expression factor arguments argument_list
%error-verbose
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE
%start start
%%
start : program{$$=$1;main_code=main_code+$$->code;llog<<"start : program"<<endl;};

program :program unit {
                   hash_Val *t=new hash_Val($1->getstr()+$2->getstr());
                   $$=t;
                   $$->code=$1->code+$2->code;
                      llog<<"line no:  "<<line_count<<"           "<<"    program: program  unit"<<endl;
                      llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                      
                      }
        | unit {
               $$=$1;
               
                llog<<"line no:  "<<line_count<<"           "<<"     program : unit"<<endl;
                llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                }
        ;
unit : var_declaration
      {
          $$=$1;
          llog<<"line no:  "<<line_count<<"           "<<"   unit  :  var_declaration"<<endl;
          llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
          }
    |func_definition
    {
        $$=$1;
        
        llog<<"line no:  "<<line_count<<"           "<<"   unit  : func_definition"<<endl;
        llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
        }
    |func_declaration 
    {
        $$=$1;
        llog<<"line no:  "<<line_count<<"           "<<"    unit   : func_declaration"<<endl;
        llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
        }
     ;
func_declaration : type_specifier ID LPAREN parameter_list RPAREN{ob->InsertCurrent($2->getstr(),"ID","func",true,$1->getstr(),false);} SEMICOLON
          {llog<<"line no:  "<<line_count<<"           "<<"   func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON"<<endl;
                   hash_Val *t=new hash_Val($1->getstr()+" "+$2->getstr()+$3->getstr()+$4->getstr()+$5->getstr()+$7->getstr()+"\n");
                   $$=t;
                   llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                   }
		| type_specifier ID LPAREN RPAREN{ob->InsertCurrent($2->getstr(),"ID","func",true,$1->getstr(),false);} SEMICOLON
         {
             llog<<"line no:  "<<line_count<<"           "<<"   func_declaration :  type_specifier ID LPAREN RPAREN SEMICOLON"<<endl;
             hash_Val *t=new hash_Val($1->getstr()+" "+$2->getstr()+$3->getstr()+$4->getstr()+$6->getstr()+"\n");
             $$=t;
             llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
             }
		;


func_definition : type_specifier ID LPAREN  parameter_list RPAREN{ob->InsertCurrent($2->getstr(),"ID",$1->getstr(),true,$1->getstr(),false);cout<<"sssssssss"<<s<<endl;ob->setisfu(true);llog<<ob->getisfu()<<"hhhh"<<endl;} compound_statement 
            {
                llog<<"line no:  "<<line_count<<"           "<<"   func_definition  :  type_specifier ID LPAREN parameter_list RPAREN compound_statement"<<endl;
                hash_Val *t=new hash_Val($1->getstr()+" "+$2->getstr()+$3->getstr()+$4->getstr()+$5->getstr()+$7->getstr());
                  //infor *t=new infor("hello");
                $$=t;
                llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                }
                |type_specifier ID LPAREN RPAREN {ob->InsertCurrent($2->getstr(),"ID",$1->getstr(),true,$1->getstr(),false);ob->setisfu(true);} compound_statement
                 {
                     llog<<"line no:  "<<line_count<<"           "<<"   func_definition  :  type_specifier ID LPAREN RPAREN compound_statement "<<endl;
//llog<<endl<<endl<<endl<<$2->getstr()<<endl;
                     hash_Val *t=new hash_Val($1->getstr()+" "+$2->getstr()+$3->getstr()+$4->getstr()+$6->getstr());
                     $$=t;
                    $$->code=$$->code+getupper($2->getstr())+"  PROC\n";
                              if(getupper($2->getstr())=="MAIN")
                    $$->code=$$->code+"MOV AX, @DATA\n"+"MOV DS, AX\n";
                      $$->code=$$->code+$6->code;
                       if(getupper($2->getstr())!="MAIN")
                       $$->code=$$->code+"RET \n";
                     $$->code=$$->code+getupper($2->getstr())+"  ENDP\n";
                   $$->tempvar=$6->tempvar;
                      llog<<"kkk"<<$$->tempvar<<endl;
                     llog<<$$->code<<endl;
                     ret_list.push_back($2->getstr());
                     llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                     }
                     ;
    
parameter_list  : parameter_list COMMA type_specifier ID
           {
               llog<<"line no:  "<<line_count<<"           "<< "parameter_list  : parameter_list COMMA type_specifier ID"<<endl;
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
             llog<<"line no:  "<<line_count<<"           "<< "parameter_list  : parameter_list COMMA type_specifier"<<endl;
            hash_Val *t=new hash_Val($1->getstr()+$2->getstr()+$3->getstr()+" ");
               $$=t;
               llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
param_no++;
             }
 		| type_specifier ID
          {
              llog<<"line no:  "<<line_count<<"           "<< "parameter_list  : type_specifier ID"<<endl;
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
               llog<<"line no:  "<<line_count<<"           "<< "parameter_list  : type_specifier "<<endl;
               $$=$1;
                param_no++;
                llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
               }
 		;

compound_statement : LCURL{llog<<"hello"<<endl;ob->EnterScope();for(int i=0;i<param_list.size();i=i+2){ob->InsertCurrent(param_list[i],"ID",param_list[i+1],false,"not",false);cout<<param_list[i]<<endl;}param_list.clear(); ob->PrintAll();	llog<<"here"<<endl;} RCURL
             {
                 llog<<"line no:  "<<line_count<<"           "<< "compound_statement : LCURL RCURL"<<endl;
                 hash_Val *t=new hash_Val("\n"+$1->getstr()+$3->getstr()+"\n");
                 $$=t;
                 llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                   ob->PrintAll();
                   ob->ExitScope();
                 }
                   |LCURL{llog<<"hello"<<endl;ob->EnterScope();cout<<s<<endl;for(int i=0;i<s;i=i+2){ob->InsertCurrent(param_list[i],"ID",param_list[i+1],false,"not",false);cout<<param_list[i]<<endl;}param_list.clear();ob->PrintAll();s=0;llog<<"here"<<endl;} statements RCURL
                    {
                        llog<<"line no:  "<<line_count<<"           "<< "compound_statement : LCURL statements RCURL"<<endl;
                        hash_Val *t=new hash_Val("\n"+$1->getstr()+"\n"+$3->getstr()+"\n"+$4->getstr()+"\n");
                 $$=t;
                 $$->code=$3->code;
                $$->tempvar=$3->tempvar;
              llog<<"jjj"<<$3->tempvar<<endl;
                 llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                  ob->PrintAll();
                  ob->ExitScope();
                        }
                    ;
statements : statement
            {
                llog<<"line no:  "<<line_count<<"           "<< "statements : statement"<<endl;
                $$=$1;
                  
                llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
            }
            |statements statement
              {
                  llog<<"line no:  "<<line_count<<"           "<< "statements : statements statement"<<endl;
                  hash_Val *t=new hash_Val($1->getstr()+$2->getstr());
                  $$=t;
                 $$->code=$1->code+$2->code;
                  llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                  }
            ;
statement : compound_statement
          {
              llog<<"line no:  "<<line_count<<"           "<< " statement  :  compound_statement"<<endl;
              $$=$1;
              llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
              }
          | IF LPAREN expression RPAREN statement
           {
               llog<<"line on        :     "<<line_count<<"           "<<" statement : IF LPAREN expression RPAREN statement"<<endl;
               hash_Val *t=new hash_Val($1->getstr()+$2->getstr()+$3->getstr()+$4->getstr()+$5->getstr()); 
               $$=t;
              string s="";
              string l1=newLabel();
              string l2=newLabel();
  
               s=s+$3->code+"\nCMP "+$3->tempvar+",1\n"+"JE   "+l1+"\n"+"JMP  "+l2+"\n"+l1+":\n"+$5->code+"\n"+l2+":"+"\n";
               $$->code=s;
               llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
               } %prec LOWER_THAN_ELSE ;
          | IF LPAREN expression RPAREN  statement ELSE   statement
          {
              llog<<"line on        :     "<<line_count<<"           "<<" statement : IF LPAREN expression RPAREN statement ELSE statement"<<endl;
              hash_Val *t=new hash_Val($1->getstr()+$2->getstr()+$3->getstr()+$4->getstr()+$5->getstr()+$6->getstr()+$7->getstr()); 
              $$=t;
            string s="";
              string l1=newLabel();
              string l2=newLabel();
              string l3=newLabel();
            s=s+$3->code+"\nCMP "+$3->tempvar+",1\n"+"JE  "+l1+"\n"+"JMP "+l2+"\n"+l1+":\n"+$5->code+"\n"+"JMP "+l3+"\n"+l2+":"+"\n"+$7->code+"\n"+l3+":\n";
             $$->code=s;
              llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
              }
          |var_declaration
           {
               llog<<"line on        :     "<<line_count<<"           "<<" statement  :  var_declaration"<<endl;
               $$=$1;
               llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
               }
          | FOR LPAREN expression_statement expression_statement expression RPAREN statement
           {
              llog<<"line on        :     "<<line_count<<"           "<<"  statement  :  FOR LPAREN expression_statement expression_statement expression RPAREN statement"<<endl;
               hash_Val *t=new hash_Val($1->getstr()+$2->getstr()+$3->getstr()+$4->getstr()+$5->getstr()+$6->getstr()+$7->getstr()); 
               $$=t;
            string s="";
           string l1=newLabel();
           string l2=newLabel();
           string l3=newLabel();
           s=s+$3->code+"\n";
            s=s+l1+":\n";
          s=s+$4->code+"\n";
          s=s+"CMP "+$4->tempvar+",1\n";
            s=s+"JE "+l2+"\n";
            s=s+"JMP "+l3+"\n";
            s=s+l2+":\n";
           s=s+$7->code+"\n";
           s=s+$5->code+"\n";
           s=s+"JMP "+l1+"\n";
           s=s+l3+":";
        $$->code=s;
            
               llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
               }
          | WHILE LPAREN expression RPAREN statement
           {
               llog<<"line on        :     "<<line_count<<"           "<<"statement  :  WHILE LPAREN expression RPAREN statement "<<endl;
               hash_Val *t=new hash_Val($1->getstr()+$2->getstr()+$3->getstr()+$4->getstr()+$5->getstr()); 
               $$=t;
               string s="";
                string l1=newLabel();
                 string l2=newLabel();
                 string l3=newLabel();
               s=s+l1+":\n";
              s=s+$3->code+"\n";
             s=s+"CMP "+$3->tempvar+",1\n";
             s=s+"JE  "+l2+"\n";
             s=s+"JMP "+l3+"\n";
            s=s+l2+":\n";
            s=s+$5->code+"\n";
            s=s+"JMP "+l1+"\n";
             s=s+l3+":\n";
               $$->code=s;             
               llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
               }
          | RETURN expression SEMICOLON
           {
               llog<<"line on        :     "<<line_count<<"           "<<"  statement  : RETURN expression SEMICOLON "<<endl;
               hash_Val *t=new hash_Val($1->getstr()+" "+$2->getstr()+$3->getstr()+"\n");
               $$=t;llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
               string s="";
                
               
               s=s+"MOV retu"+","+$2->tempvar+"\n";
                $$->code=s+$2->code+"\n";
                $$->tempvar="retu";
               }
          |  expression_statement
           {
               llog<<"line on        :     "<<line_count<<"           "<<"statement  :  expression_statement"<<endl;
               $$=$1;
               
               llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
               }
           | PRINTLN LPAREN ID RPAREN SEMICOLON{$$->code="MOV AX,"+$3->getstr()+to_string(getID($3->getstr()))+"\ncall outdec\n";}
           ;
expression_statement : SEMICOLON 
            {
                llog<<"line on        :     "<<line_count<<"           "<<"  expression_statement : SEMICOLON"<<endl;
                $$=$1;
                llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                }
                     |expression SEMICOLON
                      {
                          llog<<"line on        :     "<<line_count<<"           "<<"  expression_statement :expression SEMICOLON"<<endl;
                         hash_Val *t=new hash_Val($1->getstr()+$2->getstr()+"\n");
                          $$=t;
                         $$->code=$1->code;
                       $$->tempvar=$1->tempvar;
                           llog<<$1->code<<"code"<<endl;
                          llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;

                          }
                    ;
 
var_declaration : type_specifier declaration_list SEMICOLON  
                  {
                    llog<<"line on        :     "<<line_count<<"           "<<" var_declaration : type_specifier declaration_list SEMICOLON"<<endl;
                    hash_Val *tt=new hash_Val($1->getstr()+" "+$2->getstr()+$3->getstr()+"\n");
                    $$=tt;
                    
                   for(int i=0;i<param_list.size();i=i+2)
                      {
                      if(param_list[i+1]=="yes")
                      {
               if(ob->look(param_list[i],1)!=0)
               {
               eerrors<<"line no    :  "<<line_count<<"           "<<"multiple declaration of variable"<<endl;
               error_count++;
              }
                 else
                ob->InsertCurrent(param_list[i],"ID",$1->getstr(),false,"not",true);
                  } 
                      else
                      {
                    if(ob->look(param_list[i],1)!=0)
               {
                eerrors<<"line no    :  "<<line_count<<"           "<<"multiple declaration of variable"<<endl;
                 error_count++;
                }
                 else
               
                  ob->InsertCurrent(param_list[i],"ID",$1->getstr(),false,"not",false);
                 }
                    }
                    param_list.clear();
                  llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                    }

                ;
declaration_list : declaration_list COMMA ID
                {
                    llog<<"line on        :     "<<line_count<<"           "<<" declaration_list : declaration_list COMMA ID"<<endl;
                    hash_Val *tt=new hash_Val($1->getstr()+$2->getstr()+$3->getstr());
                    $$=tt;
                    llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                   ds_code=ds_code+$3->getstr()+to_string(ob->cur->id)+"     DW   ?\n";
                  param_list.push_back($3->getstr());
                  param_list.push_back("not");
               //ob->InsertCurrent($3->getstr(),"ID",sn,false);
                  //  ob->PrintAll();
                    //llog<<"hashjsxas"<<endl;
                    }
                 | ID
                 {
                     llog<<"line on        :     "<<line_count<<"           "<<" declaration_list : ID"<<endl;
                     $$=$1;
                      param_list.push_back($1->getstr());
                   ds_code=ds_code+$1->getstr()+to_string(ob->cur->id)+"     DW   ?\n";
                    param_list.push_back("not");
                     llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                     } 
                 |ID LTHIRD CONST_INT RTHIRD
                  {
                       param_list.push_back($1->getstr());
                      llog<<"line on        :     "<<line_count<<"           "<<" declaration_list : ID LTHIRD CONST_INT RTHIRD"<<endl;
                      hash_Val *tt=new hash_Val($1->getstr()+$2->getstr()+$3->getstr()+$4->getstr());
                      $$=tt;
                        ds_code=ds_code+$1->getstr()+to_string(ob->cur->id)+"     DW  "+$3->getstr()+"   DUP(?)\n";
                      llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                      param_list.push_back("yes");
                      }
                 |declaration_list COMMA ID LTHIRD CONST_INT RTHIRD
                  {
                      llog<<"line on        :     "<<line_count<<"           "<<" declaration_list : declaration_list COMMA ID LTHIRD CONST_INT RTHIRD"<<endl;
                      hash_Val *tt=new hash_Val($1->getstr()+$2->getstr()+$3->getstr()+$4->getstr()+$5->getstr()+$6->getstr());
                      $$=tt;
                       ds_code=ds_code+$3->getstr()+to_string(ob->cur->id)+"     DW  "+$5->getstr()+"   DUP(?)\n";
                      llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                        param_list.push_back($3->getstr());
                      param_list.push_back("yes");
                      }
                 ;
type_specifier	: INT 
           {
               $$=$1;
               llog<<"line on        :     "<<line_count<<"           "<<"type_specifier	: INT"<<endl;
               llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
               }
 		| FLOAT
             {
                 $$=$1;
                 llog<<"line on        :     "<<line_count<<"           "<<"type_specifier	: FLOAT"<<endl;
                 llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                 }
 		| VOID
          {
              $$=$1;
              llog<<"line on        :     "<<line_count<<"           "<<"type_specifier	: VOID"<<endl;
              llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
              }
                 ;
expression : logic_expression
                   {
                       llog<<"line on        :     "<<line_count<<"           "<<"expression : logic_expression"<<endl;
                       $$=$1;
                         $$->sval=$1->sval;
                  llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
 //llog<<endl<<endl<<endl<<$$->gettype()<<endl<<endl<<endl;
                       }
           | variable ASSIGNOP logic_expression
            {
                llog<<"line on        :     "<<line_count<<"           "<<"expression :   variable ASSIGNOP logic_expression "<<endl;
                hash_Val *t=new hash_Val($1->getstr()+$2->getstr()+$3->getstr());
                $$=t;
                
                string s_code="MOV  AX,"+$3->tempvar+"\n";
                 s_code=s_code+"MOV  "+$1->getstr()+to_string(getID($1->getstr()))+",  AX\n";
                $$->code=$3->code+s_code;
                llog<<"cdde"<<$3->code<<endl;
                if(($1->gettype()!=$3->gettype())&&$3->gettype()!="not"&&$1->gettype()!="not")
                {
                   eerrors<<"line no     "<<line_count<<"           "<<"type mismatch error"<<endl;error_count++;llog<<"hk"<<$1->gettype()<<$3->gettype()<<endl;}
                llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                   
                }
           ;
variable : ID
    {
    
     
        llog<<"line on        :     "<<line_count<<"           "<<"variable : ID  "<<endl;
  hash_Val *t;
    hash_Map *c=ob->cur;
   while(ob->getisfu()!=true)
          {
          llog<<ob->getisfu()<<endl;
           if(ob->look($1->getstr(),1)!=0)
         {
       if(ob->look($1->getstr(),1)->getarray()==true)
        {
           eerrors<<"line no    :"<<line_count<<"           "<<"array should have index to access item"<<endl;error_count++;
         }
        t=new hash_Val($1->getstr(),ob->look($1->getstr(),1)->gettype(),ob->look($1->getstr(),1)->isfunction);
       }
else if(ob->searchinroot($1->getstr())!=0)
{
   //cout<<"iamnot   "<<ob->searchinroot($1->getstr())->gettype()<<ob->searchinroot($1->getstr())->isfunction;
        t=new hash_Val($1->getstr(),ob->searchinroot($1->getstr())->gettype(),ob->searchinroot($1->getstr())->isfunction);
     
}

    ob->setCurrentParent();
   llog<<"here1"<<endl;
}
    if(ob->cur==0)
     
{
   eerrors<<"line no     "<<line_count<<"           "<<"Variable not declared1"<<$1->getstr()<<endl;error_count++;
        t=new hash_Val($1->getstr(),"not",false);
}
     ob->cur=c;
          t->tempvar=$1->tempvar+to_string(getID($1->getstr()));
        $$=t;       
        llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
//llog<<endl<<endl<<endl<<$$->gettype()<<"buet"<<endl<<endl<<endl;
          
        }
         | ID LTHIRD expression RTHIRD
          {
               if(ob->look($1->getstr(),1)->getarray()==false)
               {eerrors<<"line no    :   "<<line_count<<"           "<<"A id can't be a array"<<endl;error_count++;}
              llog<<"line on        :     "<<line_count<<"           "<<"variable :  ID LTHIRD expression RTHIRD"<<endl;
hash_Val *t;
               if(ob->look($1->getstr(),1)!=0)
               t=new hash_Val($1->getstr()+$2->getstr()+$3->getstr()+$4->getstr(),ob->look($1->getstr(),1)->gettype(),ob->look($1->getstr(),1)->isfunction);
else if(ob->searchinroot($1->getstr())!=0)
{
   //cout<<"iamnot   "<<ob->searchinroot($1->getstr())->gettype()<<ob->searchinroot($1->getstr())->isfunction;
        t=new hash_Val($1->getstr(),ob->searchinroot($1->getstr())->gettype(),ob->searchinroot($1->getstr())->isfunction);
     
}
else
{
   eerrors<<"line no     "<<line_count<<"           "<<"Variable not declared"<<endl;error_count++;
        t=new hash_Val($1->getstr(),"not",false);
}
     if($3->gettype()!="int")
    {eerrors<<"line no     "<<line_count<<"           "<<"array index should be integer"<<endl;error_count++;}
                $$=t;
                llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
               
              }
         ;
logic_expression : rel_expression
               {
                   llog<<"line on        :     "<<line_count<<"           "<<"logic_expression : rel_expression "<<endl;
                   $$=$1;
                     $$->sval=$1->sval;
                   llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                   } 
                 | rel_expression LOGICOP rel_expression
                   {
                       llog<<"line on        :     "<<line_count<<"           "<<"logic_expression :  rel_expression LOGICOP rel_expression "<<endl;
                       hash_Val *t=new hash_Val($1->getstr()+$2->getstr()+$3->getstr(),"int",false);
                $$=t;
                llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                       } 
                ;
rel_expression	:  simple_expression RELOP simple_expression
              {
                  
                  llog<<"line on        :     "<<line_count<<"           "<<"rel_expression	:  simple_expression RELOP simple_expression "<<endl;
                  hash_Val *t=new hash_Val($1->getstr()+$2->getstr()+$3->getstr(),"int",false);
                  $$=t;
                  llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                  string sr="";
                   sr=sr+"MOV AX,"+$1->tempvar+"\n";
                  sr=sr+"MOV BX,"+$3->tempvar+"\n";
                    string tr=newtemp();
                    string l1=newLabel();
                     string l2=newLabel();
                    if($2->getstr()=="<")
                   {
                     sr=sr+"CMP AX,BX\n";
                     sr=sr+"JGE  "+l1+"\n";
                     sr=sr+"MOV "+tr+",1\n";
                     sr=sr+"JMP "+l2+"\n";
                     sr=sr+l1+":\n";
                      sr=sr+"MOV  "+tr+",0\n";
                     sr=sr+l2+":\n";
                    }   
              if($2->getstr()=="<=")
                   {
                     sr=sr+"CMP AX,BX\n";
                     sr=sr+"JG  "+l1+"\n";
                     sr=sr+"MOV "+tr+",1\n";
                     sr=sr+"JMP "+l2+"\n";
                     sr=sr+l1+":\n";
                      sr=sr+"MOV  "+tr+",0\n";
                     sr=sr+l2+":\n";
                    }                   
                    if($2->getstr()==">")
                   {
                     sr=sr+"CMP AX,BX\n";
                     sr=sr+"JLE  "+l1+"\n";
                     sr=sr+"MOV "+tr+",1\n";
                     sr=sr+"JMP "+l2+"\n";
                     sr=sr+l1+":\n";
                      sr=sr+"MOV  "+tr+",0\n";
                     sr=sr+l2+":\n";
                    }  
                    if($2->getstr()==">=")
                   {
                     sr=sr+"CMP AX,BX\n";
                     sr=sr+"JL  "+l1+"\n";
                     sr=sr+"MOV "+tr+",1\n";
                     sr=sr+"JMP "+l2+"\n";
                     sr=sr+l1+":\n";
                      sr=sr+"MOV  "+tr+",0\n";
                     sr=sr+l2+":\n";
                    }    
                 
                $$->code=sr;
                 $$->tempvar=tr;
                  }
                | simple_expression
                  {
                      llog<<"line on        :     "<<line_count<<"           "<<"rel_expression	:  simple_expression "<<endl;
                      $$=$1;
                        $$->sval=$1->sval;
                  llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                      }
                 ;
simple_expression : simple_expression ADDOP term
               {
                   llog<<"line on        :     "<<line_count<<"           "<<"simple_expression : simple_expression ADDOP term"<<endl;
                    hash_Val *t;
                     if($1->gettype()=="float"||$3->gettype()=="float")
                   t=new hash_Val($1->getstr()+$2->getstr()+$3->getstr(),"float",false);
                   else
                   t=new hash_Val($1->getstr()+$2->getstr()+$3->getstr(),"int",false);
                   $$=t;
                   string sc="  ";
                   llog<<"getstr"<<$1->getstr()<<$3->getstr()<<endl;
                 
                
                
                   sc=sc+$1->code; 
                    
                    sc=sc+"MOV AX,"+$1->tempvar+"\n";
              
                   sc=sc+$3->code;
                    sc=sc+"MOV BX,"+$3->tempvar+"\n";
                    if($2->getstr()=="+")
                    sc=sc+"ADD AX,BX\n";
                     if($2->getstr()=="-")
                    sc=sc+"SUB AX,BX\n";
                   string sct=newtemp();
                    sc=sc+"MOV "+sct+",AX\n";
                  
                     $$->tempvar=sct;
                      $$->code=sc;
                   $$->sval=$1->sval+$3->sval;
                   
                   llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
               }
                   | term
                     {
                         llog<<"line on        :     "<<line_count<<"           "<<"simple_expression : term"<<endl;
                         $$=$1;
                        llog<<"coc"<<$$->code<<endl;
                         $$->sval=$1->sval;
                         llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                         }
                   ;
term : term MULOP unary_expression
	{
        llog<<"line on        :     "<<line_count<<"           "<<"term : term MULOP unary_expression"<<endl;
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
          {eerrors<<"line no    "<<line_count<<"           "<<"Both operand of modulus operator should be integer."<<endl<<endl;error_count++;}}
     $$=t;
    string sc="  ";
           sc=sc+$1->code; 
                    
                    sc=sc+"MOV AL,"+$1->tempvar+"\n";
              
                   sc=sc+$3->code;
                    sc=sc+"MOV BL,"+$3->tempvar+"\n";
              if($2->getstr()=="*")
                    sc=sc+"MUL BL\n";
                 string sct=newtemp();
                    sc=sc+"MOV "+sct+",AX\n";
                  
                     $$->tempvar=sct;
                      $$->code=sc;
               llog<<"mulop"<<$$->code<<endl;
        
    //llog<<"type type type"<<$1->gettype()<<$1->getstr()<<$3->gettype()<<$3->getstr()<<$$->gettype()<<endl;
        llog<<endl<<endl<<endl<<$$->gettype()<<endl<<endl<<endl;
        }
     |unary_expression
       {
           llog<<"line on        :     "<<line_count<<"           "<<"term : unary_expression"<<endl;
           $$=$1;
             $$->sval=$1->sval;
              llog<<"cte"<<$$->code<<endl;
           llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
           }
      ; 
unary_expression :ADDOP unary_expression
            {
                llog<<"line on        :     "<<line_count<<"           "<<"unary_expression :ADDOP unary_expression"<<endl;
                hash_Val *t=new hash_Val($1->getstr()+$2->getstr());
                $$=t;
                llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                }
                 |NOT unary_expression
                   {
                       llog<<"line on        :     "<<line_count<<"           "<<"unary_expression : NOT unary_expression"<<endl;
                       hash_Val *t=new hash_Val($1->getstr()+$2->getstr());
                       $$=t;
                       llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                       }
                 |factor
                  {
                      
                      llog<<"line on        :     "<<line_count<<"           "<<"unary_expression : factor"<<endl;
                      $$=$1;
                      $$->sval=$1->sval;
                      llog<<"coc"<<$$->code<<endl;
                      llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                      }
                 ;
factor	: variable
       {
           llog<<"line on        :     "<<line_count<<"           "<<" factor  :  variable"<<endl<<endl<<endl;
                     $$=$1;
                     llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                     
                     }
        | ID LPAREN argument_list RPAREN
         {
             llog<<"line on        :     "<<line_count<<"           "<<" factor : ID LPAREN argument_list RPAREN"<<endl;
              //llog<<"hello"<<$1->getstr()<<endl;
              //llog<<ob->LookUp($1->getstr(),1)->isfunction<<endl;
              //llog<<"hel"<<endl;
          if(ob->LookUp($1->getstr(),1)!=0)
            {
             if(ob->LookUp($1->getstr(),1)->isfunction==false)
              {
               eerrors<<"line no    :   "<<line_count<<"           "<<"Function does not exists"<<endl;
                error_count++;
              }
             else
               {
      //llog<<"hello       "<<ob->LookUp($1->getstr(),1)->getparamno()<<"   "<<arg_list.size()<<endl;
       if(ob->LookUp($1->getstr(),1)->getparamno()==arg_list.size())
                    {
            
           vector<string> ttt=ob->LookUp($1->getstr(),1)->ret_param_list();
             //llog<<"hello1   "<<ttt.size()<<endl;
          for(int i=1;i<=ttt.size();i=i+2)
                 {
             //llog<<"hello1   "<<ttt.size()<<endl;
        // llog<<ttt[i]<<endl;
         if(ttt[i]!=arg_list[i/2])
             {eerrors<<"line  no     :   "<<line_count<<"           "<<"parametr type does not match"<<endl;error_count++;break;}
                  }
                }
else
              {
      eerrors<<"line no   :   "<<line_count<<"           "<<"Number of parameter does not match"<<endl;error_count++;
            }
}
}
else
             eerrors<<"line no   :   "<<line_count<<"           "<<"function does not exist"<<endl;error_count++;  
             hash_Val *t=new hash_Val($1->getstr()+$2->getstr()+$3->getstr()+$4->getstr());
            string s="call    "+$1->getstr()+"\n";
         
             $$=t;
              $$->tempvar="retu";
             $$->type=getfunctiontype($1->getstr());
             $$->code=$$->code+s;
               llog<<"kkkkk"<<$$->code<<endl;
      arg_list.clear();
             llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
             }
        | variable INCOP
          {
              llog<<"line on        :     "<<line_count<<"           "<<" factor  :  variable INCOP"<<endl;
               hash_Val *t=new hash_Val($1->getstr()+$2->getstr(),$1->gettype(),false);
              $$=t;
              llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
              }
	 | variable DECOP
       {
           llog<<"line on        :     "<<line_count<<"           "<<" factor  :  variable DECOP"<<endl;
        hash_Val *t=new hash_Val($1->getstr()+$2->getstr(),$1->gettype(),false);
              $$=t;
              llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
           }
         | LPAREN expression RPAREN
          {
              llog<<"line on        :     "<<line_count<<"           "<<" factor  :  LPAREN expression RPAREN"<<endl;
              hash_Val *t=new hash_Val($1->getstr()+$2->getstr()+$3->getstr(),$2->gettype(),false);
              $$=t;
              llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
              }
         | CONST_FLOAT
          {
              llog<<"line on        :     "<<line_count<<"           "<<" factor  :  CONST_FLOAT"<<endl;
             
              $$=$1;
              llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
         //llog<<endl<<"iamherefloat"<<endl<<$$->gettype()<<endl<<endl<<endl;
              }
        |CONST_INT
         {
             llog<<"line on        :     "<<line_count<<"           "<<" factor  :  CONST_INT"<<endl;
             $$=$1;
              $$->sval=stoi($1->getstr());
             llog<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
             }
        ; 
argument_list : arguments
              {
                  llog<<"line on        :     "<<line_count<<"           "<<" argument_list : arguments"<<endl;
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
                  llog<<"line on        :     "<<line_count<<"           "<<" arguments : logic_expression"<<endl;
                  $$=$1;
                 arg_list.push_back($1->gettype());
                  llog<<endl<<endl<<endl<<$$->getstr()<<endl<<endl<<endl;
                  }
	      | arguments COMMA logic_expression 
          {
              llog<<"line on        :     "<<line_count<<"           "<<" factor  : arguments COMMA logic_expression"<<endl;
              hash_Val *t=new hash_Val($1->getstr()+$2->getstr()+$3->getstr());
               arg_list.push_back($3->gettype());
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
       ds_code=ds_code+".CODE\n"+outdec;
       main_code=main_code+"\n"+"MOV AH, 4CH\nINT 21H\nEND MAIN";
eerrors<<ds_code<<endl<<main_code<<endl;
      llog.close();
	eerrors.close();

    exit(0);
}
