%option noyywrap
%x comment
%x scomment
%x str
%{
#include<iostream>

#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include "1505063_symtable.h"
#include"y.tab.h"
using namespace std;
int line_count=1;
int error=0;
int temline;
string gstring;
string outstring;
char str_buf[80];
char str_log[80];
char str_com[100];
char str_loc[100];
char *strs;
char *strc;
char *strl;
char *strb;
extern SymbolTable* ob;
FILE *logout;
FILE *tokenout;

%}

WHITESPACE [ \t\f\r\v]+ 
LETTER [a-zA-Z]
DIGIT [0-9]
MULOP [*/%]
NEWLINE \n
DOT .
DSLASH \\\\

%%

"/*"        BEGIN(comment);strs=str_loc;*strs++='/';*strs++='*';temline=0;
<comment>[^*\n]*    { 
            char *yf=yytext;
			while(*yf)
			{
				*strs++=*yf++;
			}
        }    /* eat anything that's not a '*' */
<comment>"*"+[^*/\n]*  {
                        char *yf=yytext;
			while(*yf)
			{
				*strs++=*yf++;
			}
                   }  /* eat up '*'s not followed by '/'s */
<comment>\n  {
         *strs++='\n';
	 temline++;
	 //printf("hgsmhbsjskjd\n");
}
<comment>"*"+"/"   {
	  char *yf=yytext;
			while(*yf)
			{
				*strs++=*yf++;
			}
           //fprintf(logout,"Line no %d: TOKEN <COMMENT> Lexeme %s found\n",line_count+temline,str_loc);
		   line_count=line_count+temline;
		   //printf("%d   temline",temline);
		   temline=0;
		   *strs++='\0';
		   while(*strs)
		   {
			   *strs++='\0';
		   }
                 return COMMENT;
	         BEGIN INITIAL;
                }
<comment><<EOF>> {
	             //fprintf(logout,"Line no %d: Unfinished comment %s found\n",line_count,str_loc);
                    //printf("comment error");
					error++;
					BEGIN INITIAL;
                 }
{NEWLINE} {line_count++;}
{WHITESPACE} {
	
}
\"  strb=str_buf;*strb++='"';BEGIN(str);strl=str_log;*strl++='"';temline=0;
<str>\" {
	*strb++='"';
	*strl++='"';
	//printf("%s",str_buf);
	//fprintf(tokenout,"<STRING,%s >",str_buf);
	//fprintf(logout,"Line No:%d  Token <STRING> LEXEME %s FOUND\n",line_count,str_log);
	line_count=line_count+temline;
	temline=0;
      //printf("ac\n");
	  *strb='\0';
		*strl='\0';
		strb=str_buf;
			  strl=str_log;
			  while(*strl)
			  {
				  *strl++='\0';
			  }
			  while(*strb)
			  {
                   *strb++='\0';
			  }
			  strb=str_buf;
			  strl=str_log;
          return STRING;
	BEGIN INITIAL; 
		
      }
<str><<EOF>> {
	 //fprintf(logout,"Error   Line No:%d   Unfinished string %s found\n",line_count,str_log);
	error++;
	BEGIN INITIAL;
}
<str>\n {
	//fprintf(logout,"Error   Line No:%d   Unfinished string %s found\n",line_count,str_log);
             // printf("unterminated\n");
			 // printf("%s\n",str_log);
			  line_count=line_count+temline+1;
			 // printf("%d\n",line_count);
			  *strb='\0';
			  *strl='\0';
			  strb=str_buf;
			  strl=str_log;
			  while(*strl)
			  {
				  *strl++='\0';
			  }
			  while(*strb)
			  {
                   *strb++='\0';
			  }
			  strb=str_buf;
			  strl=str_log;
			  error++;
			  BEGIN INITIAL;
        }
<str>\\n {
	*strl++='\\';
	*strl++='n';
	*strb++='\n';
              // printf("slash n found\n");
			        }
<str>\\t {
	*strb++='\t';
	*strl++='\\';
	*strl++='t';
           //printf("slash t found\n");
}

<str>\\(.|\n) {
	*strl++='\\';
	*strl++='\n';
	if(yytext[1]=='\n')
	{
		//printf("here1   %d\n",temline);
		temline++;
	}
	
	
}
<str>[^\\\n\"] {
	
     char *yt=yytext;
	 char *ytt=yytext;
	 //printf("%s     this is\n",yytext);
	 while(*yt)
	 {
		 *strb++=*yt++;
		 *strl++=*ytt++;
		 //printf("%s gtttttt",str_log);
	 }
}
"//"  strc=str_com;BEGIN(scomment);
<scomment>\n {
	
	line_count++;
	//printf("co\n");
	//printf("%s\n",str_com);
	//fprintf(logout,"Line No:%d  TOKEN <COMMENT> %s FOUND\n",line_count,str_com);
	*strc='\0';
	strc=str_com;
	while(*strc)
	{
		*strc++='\0';
	}
        return COMMENT;
	BEGIN INITIAL;
}
<scomment>\\(.|\n) {
	*strc++='\\';
	*strc++='\n';
	//printf("here7\n");
}
<scomment>[^\\\n] {
     char *yt=yytext;
	 while(*yt)
	 {
		 *strc++=*yt++;
	
	 }
}

"if"	{
	hash_Val *t=new hash_Val(yytext);
	yylval.info=t;
                        return IF;
			//fprintf(tokenout,"<IF>");
			//fprintf(logout,"Line no %d: TOKEN <IF> Lexeme %s found\n",line_count,yytext);
		}
		
"else"	{
	hash_Val *t=new hash_Val(yytext);
	yylval.info=t;
                        return ELSE;
			//fprintf(tokenout,"<ELSE>");
			//fprintf(logout,"Line no %d: TOKEN <ELSE> Lexeme %s found\n",line_count,yytext);
		}
"for"	{
	hash_Val *t=new hash_Val(yytext);
	yylval.info=t;
                        return FOR;
			//fprintf(tokenout,"<FOR>");
			//fprintf(logout,"Line no %d: TOKEN <FOR> Lexeme %s found\n",line_count,yytext);
		}
"while"	{
	hash_Val *t=new hash_Val(yytext);
	yylval.info=t;
                        return WHILE;
			//fprintf(tokenout,"<WHILE>");
			//fprintf(logout,"Line no %d: TOKEN <WHILE> Lexeme %s found\n",line_count,yytext);
		}	
"do"	{
                        return DO;
			//fprintf(tokenout,"<DO>");
			//fprintf(logout,"Line no %d: TOKEN <DO> Lexeme %s found\n",line_count,yytext);
		}		
"break"	{
                        return BREAK;
			//fprintf(tokenout,"<BREAK>");
			//fprintf(logout,"Line no %d: TOKEN <BREAK> Lexeme %s found\n",line_count,yytext);
		}
"int"	{
	  hash_Val *t=new hash_Val(yytext);
	  yylval.info=t;
                         return INT;
			//fprintf(tokenout,"<INT>");
			//fprintf(logout,"Line no %d: TOKEN <INT> Lexeme %s found\n",line_count,yytext);
		}	
"char"	{
                        return CHAR;
			//fprintf(tokenout,"<CHAR>");
			//fprintf(logout,"Line no %d: TOKEN <CHAR> Lexeme %s found\n",line_count,yytext);
		}
"float"	{
	         hash_Val *t=new hash_Val(yytext);
			 yylval.info=t;
                        return FLOAT;
			//fprintf(tokenout,"<FLOAT>");
			//fprintf(logout,"Line no %d: TOKEN <FLOAT> Lexeme %s found\n",line_count,yytext);
		}	
"double" {
                        return DOUBLE;
			//fprintf(tokenout,"<DOUBLE>");
			//fprintf(logout,"Line no %d: TOKEN <DOUBLE> Lexeme %s found\n",line_count,yytext);
		}	
"void"	{
	hash_Val *t=new hash_Val(yytext);
	yylval.info=t;
                        return VOID;
			//fprintf(tokenout,"<VOID>");
			//fprintf(logout,"Line no %d: TOKEN <VOID> Lexeme %s found\n",line_count,yytext);
		}	
"return" {
	hash_Val *t=new hash_Val(yytext);
	yylval.info=t;
			return RETURN;
                        //fprintf(tokenout,"<RETURN>");
			//fprintf(logout,"Line no %d: TOKEN <RETURN> Lexeme %s found\n",line_count,yytext);
		}	
"switch"	{
                        return SWITCH;
			//fprintf(tokenout,"<SWITCH>");
			//fprintf(logout,"Line no %d: TOKEN <SWITCH> Lexeme %s found\n",line_count,yytext);
		}		
"case"	{
                         return CASE;
			//fprintf(tokenout,"<CASE>");
			//fprintf(logout,"Line no %d: TOKEN <CASE> Lexeme %s found\n",line_count,yytext);
		}	
"default"	{
                          return DEFAULT;
			//fprintf(tokenout,"<DEFAULT>");
			//fprintf(logout,"Line no %d: TOKEN <DEFAULT> Lexeme %s found\n",line_count,yytext);
		}
"continue"	{
                         return CONTINUE;
			//fprintf(tokenout,"<CONTINUE>");
			//fprintf(logout,"Line no %d: TOKEN <CONTINUE> Lexeme %c found\n",line_count,yytext[0]);
		}
[0-9]*\E[+-]?[0-9]*\.(.)* {
                          //fprintf(logout,"Error at Line no %d: Ill formed %s found\n",line_count,yytext);
						  //error++;
                  }
"+"		|

"-"		{
	hash_Val *t=new hash_Val(yytext);
	yylval.info=t;
                         return ADDOP;
			//fprintf(tokenout,"<ADDOP,%s>",yytext);
			//fprintf(logout,"Line no %d: TOKEN <ADDOP> Lexeme %s found\n",line_count,yytext);
			//insert in symbol table and print symbol table content(only non empty buckets)
			// There is a '|' in "+"'s rule, this means match execute the action for following rule
		}
{DIGIT}+\.{DIGIT}+ |
{DIGIT}+\.{DIGIT}+\E[+-]?{DIGIT}+ |
{DIGIT}+\E{DIGIT}+ |
\.{DIGIT}+  {
	//string str3=string(yytext);
	  // ob->InsertCurrent(str3,"FLOAT");
	   
	      //  fprintf(tokenout,"<FLOATINGPOINT,%s>",yytext);
		//	fprintf(logout,"Line no %d: TOKEN <FLOATINGPOINT,%s> Lexeme %s found\n",line_count,yytext,yytext);
		//	ob->PrintCurrent(logout);
                hash_Val *t=new hash_Val(yytext,"float",false);
	yylval.info=t;
				return CONST_FLOAT;
        }

{DIGIT}*\.{DIGIT}*\.{DIGIT}*  {
                          //fprintf(logout,"Error at Line no %d: Too many Decimal point %s found\n",line_count,yytext);
                         //error++;
						 }
{DIGIT}+({LETTER}|_)+ {
                  //fprintf(logout,"Error at Line no %d: Invalid suffix %s found\n",line_count,yytext);
                 //error++;
			   }

'{LETTER}'|'{DIGIT}' {
	//string str3=string(yytext);
	  // ob->InsertCurrent(str3,"CONST_CHAR");
            //fprintf(tokenout,"<CONST_CHAR,%s>",yytext);
		//	fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found\n",line_count,yytext);
            //ob->PrintCurrent(logout);
               return CONST_CHAR;
	   }

\'({LETTER}|{DIGIT}|{WHITESPACE})({LETTER}|{DIGIT}|{WHITESPACE})+\' {
                 //fprintf(logout,"Error at Line no %d: Multicharacter constant  %s found\n",line_count,yytext);
            //error++;
			}
\'\\n\' {
	//char c='\n';
	//string str3=string(yytext);
	  // ob->InsertCurrent(str3,"CONST_CHAR");
	 //fprintf(tokenout,"<CONST_CHAR,%c>",c);
	                		//fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found\n",line_count,yytext);
           //ob->PrintCurrent(logout);
          return CONST_CHAR;
       }		
\'\\t\' {
	//char c='\t';
	//string str3=string(yytext);
	  // ob->InsertCurrent(str3,"CONST_CHAR");
	 //fprintf(tokenout,"<CONST_CHAR,%c>",c);
			//fprintf(logout,"Line no %d: TOKEN <CONST_CHAR> Lexeme %s found\n",line_count,yytext);
          //ob->PrintCurrent(logout);
          return CONST_CHAR;
       } 
\'\' {
	//fprintf(logout,"Error at Line no %d: Empty Character %s found\n",line_count,yytext);
    //error++;
}
\'\\\' {
	//fprintf(logout,"Error at Line no %d: Unfinished Character %s found\n",line_count,yytext);
    //error++;
}
\'.	{
	//fprintf(logout,"Error at Line no %d: Unfinished Character %s found\n",line_count,yytext);
    //error++;
}

"("  {
	// fprintf(tokenout,"<LPAREN,%s>",yytext);
	//		fprintf(logout,"Line no %d: TOKEN <LPAREN> Lexeme %s found\n",line_count,yytext);
	  hash_Val *t=new hash_Val(yytext);
	  yylval.info=t;
           return LPAREN;
     }
")"  {
	 //fprintf(tokenout,"<RPAREN,%s>",yytext);
//			fprintf(logout,"Line no %d: TOKEN <RPAREN> Lexeme %s found\n",line_count,yytext);
hash_Val *t=new hash_Val(yytext);
	  yylval.info=t;
            return RPAREN;
     }
"{"  {
	 //fprintf(tokenout,"<LCURL,%s>",yytext);
	//		fprintf(logout,"Line no %d: TOKEN <LCURL> Lexeme %s found\n",line_count,yytext);
	 hash_Val *t=new hash_Val(yytext);
	  yylval.info=t;
           return LCURL;
     }
"}"  {
	 //fprintf(tokenout,"<RCURL,%s>",yytext);
	//		fprintf(logout,"Line no %d: TOKEN <RCURL,%s> Lexeme %s found\n",line_count,yytext,yytext);
	hash_Val *t=new hash_Val(yytext);
	  yylval.info=t;
           return RCURL;
     }
"["  {
	 //fprintf(tokenout,"<LTHIRD,%s>",yytext);
	//		fprintf(logout,"Line no %d: TOKEN <LTHIRD,%s> Lexeme %s found\n",line_count,yytext,yytext);
          hash_Val *t=new hash_Val(yytext);
	yylval.info=t;
		  return LTHIRD;
     }
"]"  {
	 //fprintf(tokenout,"<RTHIRD,%s>",yytext);
	//		fprintf(logout,"Line no %d: TOKEN <RTHIRD,%s> Lexeme %s found\n",line_count,yytext,yytext);
         hash_Val *t=new hash_Val(yytext);
	yylval.info=t;
		  return RTHIRD;
     }
","  {
	 //fprintf(tokenout,"<COMMA,%s>",yytext);
	//		fprintf(logout,"Line no %d: TOKEN <COMMA> Lexeme %s found\n",line_count,yytext);
	hash_Val *t=new hash_Val(yytext);
	yylval.info=t;
           return COMMA;
     }
";"  {
	 //fprintf(tokenout,"<SEMICOLON,%s>",yytext);
	//		fprintf(logout,"Line no %d: TOKEN <SEMICOLON> Lexeme %s found\n",line_count,yytext);
	  hash_Val *t=new hash_Val(yytext);
	  yylval.info=t;
          return SEMICOLON;
     }
"++"  {
	// fprintf(tokenout,"<INC,%s>",yytext);
	//		fprintf(logout,"Line no %d: TOKEN <INC,%s> Lexeme %s found\n",line_count,yytext,yytext);
       hash_Val *t=new hash_Val(yytext);
	yylval.info=t;
	   return INCOP;
     }
"--"  {
	 //fprintf(tokenout,"<DEC,%s>",yytext);
	//		fprintf(logout,"Line no %d: TOKEN <DEC,%s> Lexeme %s found\n",line_count,yytext,yytext);
             hash_Val *t=new hash_Val(yytext);
	yylval.info=t;
			 return DECOP;
     }
"<" |
"<=" |
 ">" |
 ">=" {
		//fprintf(tokenout,"<RELOP,%s>",yytext);
		
           //	fprintf(logout,"Line no %d: TOKEN <RELOP> Lexeme %s found\n",line_count,yytext);
          hash_Val *t=new hash_Val(yytext);
	yylval.info=t;
		  return RELOP;
        }
"==" {
         //fprintf(tokenout,"<RELOP,%s>",yytext);
	//		fprintf(logout,"Line no %d: TOKEN <RELOP> Lexeme %s found\n",line_count,yytext);
       hash_Val *t=new hash_Val(yytext);
	yylval.info=t;
	    return RELOP;
     }
"!=" {
      //fprintf(tokenout,"<RELOP,%s>",yytext);
	//		fprintf(logout,"Line no %d: TOKEN <RELOP> Lexeme %s found\n",line_count,yytext);
     hash_Val *t=new hash_Val(yytext);
	yylval.info=t;
	 return RELOP;
    }
"&&" {
     // fprintf(tokenout,"<LOGICOP,%s>",yytext);
			//fprintf(logout,"Line no %d: TOKEN <LOGICOP> Lexeme %s found\n",line_count,yytext);
       hash_Val *t=new hash_Val(yytext);
	yylval.info=t;
	   return LOGICOP;
    }
"||" {
     // fprintf(tokenout,"<LOGICOP,%s>",yytext);
			//fprintf(logout,"Line no %d: TOKEN <LOGICOP> Lexeme %s found\n",line_count,yytext);
           return LOGICOP;
    }
"=" {
      //fprintf(tokenout,"<ASSIGNOP,%s>",yytext);
			//fprintf(logout,"Line no %d: TOKEN <ASSIGNOP> Lexeme %s found\n",line_count,yytext);
          hash_Val *t=new hash_Val(yytext);
	yylval.info=t;
		  return ASSIGNOP;
    }
"&" |
"<<" |
">>" |
"|"  {
       // fprintf(tokenout,"<BITOP,%s>",yytext);
		//fprintf(logout,"Line no %d: TOKEN <BITOP> Lexeme %s found\n",line_count,yytext);
         return BITOP;
     }
{MULOP} {
	hash_Val *t=new hash_Val(yytext);
	yylval.info=t;
	    //fprintf(tokenout,"<MULOP,%s>",yytext);
			//fprintf(logout,"Line no %d: TOKEN <MULOP> Lexeme %s found\n",line_count,yytext);
               return MULOP;

        }
"!"  {
	 //fprintf(tokenout,"<NOT,%s>",yytext);
			//fprintf(logout,"Line no %d: TOKEN <NOT,%s> Lexeme %s found\n",line_count,yytext,yytext);
          hash_Val *t=new hash_Val(yytext);
	yylval.info=t;
		  return NOT;

     }		
{DIGIT}+ 	{
	           //string str3=string(yytext);
			    //ob->InsertCurrent(str3,"CONST_INT");
				//fprintf(tokenout,"<CONST_INT,%s>",yytext);
				//fprintf(logout,"Line no %d: TOKEN <CONST_INT> Lexeme %s found\n",line_count,yytext);
				//insert in symbol table and print symbol table content(only non empty buckets)
				//ob->PrintCurrent(logout);
				hash_Val *t=new hash_Val(yytext,"int",false);
	yylval.info=t;
                          return CONST_INT;
			}



{LETTER}+({LETTER}|{DIGIT}|_)* |
\_({LETTER}|{DIGIT}|_)+ {
	//string str3=string(yytext);
	               //ob->InsertCurrent(str3,"ID");
	  
                 //fprintf(tokenout,"<ID,%s>",yytext);
				//fprintf(logout,"Line no %d: TOKEN <ID> Lexeme %s found\n",line_count,yytext);
				 //ob->PrintCurrent(logout);
                         hash_Val *t=new hash_Val(yytext,"ID");
                        yylval.info=t;
                        return ID;
   }
. {
	fprintf(logout,"Error at Line no %d: Unrecognized chracter\n",line_count);
	error++;
}
<<EOF>>	{
	//ob->PrintCurrent(logout);
	//fprintf(logout,"\nTotal Lines: %d\n",line_count+1); 
	//fprintf(logout,"\nTotal Error: %d\n",error); 
	return 0;}




