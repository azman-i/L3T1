%option noyywrap
%x comment
%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include "1505063_symboltable.h"
int line_count=1;
SymbolTable* ob=new SymbolTable(7);
FILE *logout;
FILE *tokenout;

%}

WHITESPACE [ \t\f\r\v]+ 
LETTER [a-zA-Z]
DIGIT [0-9]
MULOP [*/%]
NEWLINE \n
DOT .

%%
"/*"         BEGIN(comment);
<comment>[^*\n]*        /* eat anything that's not a '*' */
<comment>"*"+[^*/\n]*   /* eat up '*'s not followed by '/'s */
<comment>\n             ++line_count;
<comment>"*"+"/"   {
           fprintf(logout,"Line no %d: TOKEN <COMMENT> Lexeme %s found\n",line_count,yytext);
	         BEGIN INITIAL;
                }
<comment><<EOF>> {
	             fprintf(logout,"Line no %d: Unfinished comment  found\n",line_count);
                    printf("comment error");
					BEGIN INITIAL;
                 }
{NEWLINE} {line_count++;}
{WHITESPACE} {
	
}
\/\/(.)*(\\\n(.)*)+(.)*  {
	                    int i,len=0;
	                    for(i=0;i<strlen(yytext);i++)
	                     {
                         if(yytext[i]=='\\')
		                len++;
	                    }
	fprintf(logout,"Line no %d: TOKEN <COMMENT> Lexeme %s found\n",line_count,yytext);
	line_count=line_count+len;
}
\/\/(.)* {
          fprintf(logout,"Line no %d: TOKEN <COMMENT> Lexeme %s found\n",line_count,yytext);
          }
\/\*((\n)*(.)*(\n)*)*\*\/ {
	int i,len=0;
	                    for(i=0;i<strlen(yytext);i++)
	                     {
                         if(yytext[i]=='\n')
		                len++;
	                    }
	                    fprintf(logout,"Line no %d: TOKEN <COMMENT> Lexeme %s found\n",line_count,yytext);
	                     line_count=line_count+len; 
}

"if"	{
			fprintf(tokenout,"<IF>");
			fprintf(logout,"Line no %d: TOKEN <IF> Lexeme %s found\n",line_count,yytext);
		}
		
"else"	{
			fprintf(tokenout,"<ELSE>");
			fprintf(logout,"Line no %d: TOKEN <ELSE> Lexeme %s found\n",line_count,yytext);
		}
"for"	{
			fprintf(tokenout,"<FOR>");
			fprintf(logout,"Line no %d: TOKEN <FOR> Lexeme %s found\n",line_count,yytext);
		}
"while"	{
			fprintf(tokenout,"<WHILE>");
			fprintf(logout,"Line no %d: TOKEN <WHILE> Lexeme %s found\n",line_count,yytext);
		}	
"do"	{
			fprintf(tokenout,"<DO>");
			fprintf(logout,"Line no %d: TOKEN <DO> Lexeme %s found\n",line_count,yytext);
		}		
"break"	{
			fprintf(tokenout,"<BREAK>");
			fprintf(logout,"Line no %d: TOKEN <BREAK> Lexeme %s found\n",line_count,yytext);
		}
"int"	{
			fprintf(tokenout,"<INT>");
			fprintf(logout,"Line no %d: TOKEN <INT> Lexeme %s found\n",line_count,yytext);
		}	
"char"	{
			fprintf(tokenout,"<CHAR>");
			fprintf(logout,"Line no %d: TOKEN <CHAR> Lexeme %s found\n",line_count,yytext);
		}
"float"	{
			fprintf(tokenout,"<FLOAT>");
			fprintf(logout,"Line no %d: TOKEN <FLOAT> Lexeme %s found\n",line_count,yytext);
		}	
"double" {
			fprintf(tokenout,"<DOUBLE>");
			fprintf(logout,"Line no %d: TOKEN <DOUBLE> Lexeme %s found\n",line_count,yytext);
		}	
"void"	{
			fprintf(tokenout,"<VOID>");
			fprintf(logout,"Line no %d: TOKEN <VOID> Lexeme %s found\n",line_count,yytext);
		}	
"return" {
			fprintf(tokenout,"<RETURN>");
			fprintf(logout,"Line no %d: TOKEN <RETURN> Lexeme %s found\n",line_count,yytext);
		}	
"switch"	{
			fprintf(tokenout,"<SWITCH>");
			fprintf(logout,"Line no %d: TOKEN <SWITCH> Lexeme %s found\n",line_count,yytext);
		}		
"case"	{
			fprintf(tokenout,"<CASE>");
			fprintf(logout,"Line no %d: TOKEN <CASE> Lexeme %s found\n",line_count,yytext);
		}	
"default"	{
			fprintf(tokenout,"<DEFAULT>");
			fprintf(logout,"Line no %d: TOKEN <DEFAULT> Lexeme %s found\n",line_count,yytext);
		}
"continue"	{
			fprintf(tokenout,"<CONTINUE>");
			fprintf(logout,"Line no %d: TOKEN <CONTINUE> Lexeme %c found\n",line_count,yytext[0]);
		}
[0-9]*\E[+-]?[0-9]*\.(.)* {
                          fprintf(logout,"Error at Line no %d: Ill formed %s found\n",line_count,yytext);
                  }
{DIGIT}+\.{DIGIT}+ |
{DIGIT}+\.{DIGIT}+\E[+-]?{DIGIT}+ |
{DIGIT}+\E{DIGIT}+ |
{DOT}{DIGIT}+  {
	   //ob->InsertCurrent(yytext,"FLOAT");
	   //ob->PrintCurrent();
	        fprintf(tokenout,"<FLOATINGPOINT,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <FLOATINGPOINT,%s> Lexeme %s found\n",line_count,yytext,yytext);
        }

{DIGIT}*\.{DIGIT}*\.{DIGIT}*  {
                          fprintf(logout,"Error at Line no %d: Too many Decimal point %s found\n",line_count,yytext);
                         }
{DIGIT}+({LETTER}|_)+ {
                  fprintf(logout,"Error at Line no %d: Invalid suffix %s found\n",line_count,yytext);
               }

'{LETTER}'|'{DIGIT}' {
            fprintf(tokenout,"<CHARACTER,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <CHARACTER> Lexeme %s found\n",line_count,yytext);
       }

\'({LETTER}|{DIGIT})({LETTER}|{DIGIT})+\' {
                 fprintf(logout,"Error at Line no %d: Multicharacter constant  %s found\n",line_count,yytext);
            }
\'\\n\' {
	char c='\n';
	 fprintf(tokenout,"<CHARACTER,%c>",c);
			fprintf(logout,"Line no %d: TOKEN <CHARACTER> Lexeme %s found\n",line_count,yytext);

       }		
\'\\t\' {
	char c='\t';
	 fprintf(tokenout,"<CHARACTER,%c>",c);
			fprintf(logout,"Line no %d: TOKEN <CHARACTER> Lexeme %s found\n",line_count,yytext);

       } 
\'.|\'\\\'	{
	fprintf(logout,"Error at Line no %d: Unfinished Character %s found\n",line_count,yytext);
}

"("  {
	 fprintf(tokenout,"<LPAREN,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <LPAREN,%s> Lexeme %s found\n",line_count,yytext,yytext);

     }
")"  {
	 fprintf(tokenout,"<RPAREN,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <RPAREN,%s> Lexeme %s found\n",line_count,yytext,yytext);

     }
"{"  {
	 fprintf(tokenout,"<LCURL,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <LCURL,%s> Lexeme %s found\n",line_count,yytext,yytext);

     }
"}"  {
	 fprintf(tokenout,"<RCURL,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <RCURL,%s> Lexeme %s found\n",line_count,yytext,yytext);

     }
"["  {
	 fprintf(tokenout,"<LTHIRD,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <LTHIRD,%s> Lexeme %s found\n",line_count,yytext,yytext);

     }
"]"  {
	 fprintf(tokenout,"<RTHIRD,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <RTHIRD,%s> Lexeme %s found\n",line_count,yytext,yytext);

     }
","  {
	 fprintf(tokenout,"<COMMA,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <COMMA,%s> Lexeme %s found\n",line_count,yytext,yytext);

     }
";"  {
	 fprintf(tokenout,"<SEMICOLON,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <SEMICOLON,%s> Lexeme %s found\n",line_count,yytext,yytext);

     }
"++"  {
	 fprintf(tokenout,"<INC,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <INC,%s> Lexeme %s found\n",line_count,yytext,yytext);

     }
"--"  {
	 fprintf(tokenout,"<DEC,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <DEC,%s> Lexeme %s found\n",line_count,yytext,yytext);

     }
"+"		|

"-"		{
			fprintf(tokenout,"<ADDOP,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <ADDOP> Lexeme %s found\n",line_count,yytext);
			//insert in symbol table and print symbol table content(only non empty buckets)
			// There is a '|' in "+"'s rule, this means match execute the action for following rule
		}
"<" |
"<=" |
 ">" |
 ">=" {
		fprintf(tokenout,"<RELOP,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <RELOP> Lexeme %s found\n",line_count,yytext);
        }
"==" {
         fprintf(tokenout,"<RELOP,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <RELOP> Lexeme %s found\n",line_count,yytext);
     }
"!=" {
      fprintf(tokenout,"<RELOP,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <RELOP> Lexeme %s found\n",line_count,yytext);
    }
"&&" {
      fprintf(tokenout,"<LOGICOP,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <LOGICOP> Lexeme %s found\n",line_count,yytext);
    }
"||" {
      fprintf(tokenout,"<LOGICOP,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <LOGICOP> Lexeme %s found\n",line_count,yytext);
    }
"=" {
      fprintf(tokenout,"<ASSIGNOP,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <ASSIGNOP> Lexeme %s found\n",line_count,yytext);
    }
"&" |
"<<" |
">>" |
"|"  {
        fprintf(tokenout,"<BITOP,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <BITOP> Lexeme %s found\n",line_count,yytext);
     }
{MULOP} {
	    fprintf(tokenout,"<MULOP,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <MULOP> Lexeme %s found\n",line_count,yytext);

        }
"!"  {
	 fprintf(tokenout,"<NOT,%s>",yytext);
			fprintf(logout,"Line no %d: TOKEN <NOT,%s> Lexeme %s found\n",line_count,yytext,yytext);

     }		
{DIGIT}+ 	{
				fprintf(tokenout,"<CONST_INT,%s>",yytext);
				fprintf(logout,"Line no %d: TOKEN <CONST_INT> Lexeme %s found\n",line_count,yytext);
				//insert in symbol table and print symbol table content(only non empty buckets)
			}

\"[^""\\\n]*\" {
          fprintf(tokenout,"<STRING,%s>",yytext);
				fprintf(logout,"Line1 no %d: TOKEN <STRING> Lexeme %s found\n",line_count,yytext);
       }	
\"[^\"\\]*\\[^""]+\" {
	                 printf("hello");
	                  char str[100];
					  char fstr[1000];
					  fstr[0]='\0';
					  int i=0;
					  int l=1;
					  int j=0;
					  for(i=0;l<strlen(yytext)-1;i++)
					  {
						 if((yytext[l]=='\\')&&(yytext[l+1]=='t'))
						 {
							 str[i]='\t';
							 
							 //printf("%c %c",yytext[l],str[i-1]);
							 l=l+2;
						 }
						  else if(yytext[l]=='\\')
						  {
							  str[i]='\0';
							  line_count++;
							l++;
							 // printf("%sdd",str);
							  strcat(fstr,str);
						   for(j=0;j<i;j++)
						   str[j]='\0';
						   i=-1;
						  }
						
						  else if(yytext[l]!='\n')
                          {str[i]=yytext[l];

                          // printf("%cf",str[i]);
						
                          			l++;			 
						   }
						   if(yytext[l]=='\n')
						   l++;
						  
						  
					  }
					  // printf("%s",str);
					   strcat(fstr,str);
					  printf("%s",fstr);
					   fprintf(tokenout,"<STRING,%s>",fstr);
				fprintf(logout,"Line no %d: TOKEN <STRING,%s> Lexeme %s found\n",line_count,fstr,fstr);
	                  }	


\"((.)*\\\n)+[^\\]*\n |    
\"((.)[^\"])*[^\\]\n {
	fprintf(logout,"Error at Line no %d: Unfinished string %s found\n",line_count,yytext);
}	
{LETTER}+({LETTER}|{DIGIT}|_)* |
\_({LETTER}|{DIGIT}|_)+ {
                 fprintf(tokenout,"<ID,%s>",yytext);
				fprintf(logout,"Line no %d: TOKEN <ID> Lexeme %s found\n",line_count,yytext);
   }
. {
	fprintf(logout,"Line no %d: Unrecognized chracter\n",line_count);
}

%%

int main(int argc,char *argv[]){
	
	if(argc!=2){
		printf("Please provide input file name and try again\n");
		return 0;
	}
	
	FILE *fin=fopen(argv[1],"r");
	if(fin==NULL){
		printf("Cannot open specified file\n");
		return 0;
	}
	
	logout= fopen("1505063_log.txt","w");
	tokenout= fopen("1505063_token.txt","w");

	yyin= fin;
	yylex();
	fclose(yyin);
	fclose(tokenout);
	fclose(logout);
	return 0;
}
