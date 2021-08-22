%option yylineno

%{
#include<stdio.h>
#include <string.h>
#include "y.tab.h"



    
   
void inserttok(char *sym,int type);
int insert_num(char *sym);
int insert_id(char *sym,int type);
int isN=0;
int isId=0;
char* idtext;
FILE *yyin;
%}

letter    [A-Za-z]
digit     [0-9]
id        {letter}({letter}|{digit})*
number    {digit}+
decinumber    {digit}+(.){digit}+

%%

([ \t\n])+	;
"PROGRAM"	return PROGRAM;
"VAR"		return VAR;
"BEGIN"	return BEGINP;
"END."		return ENDDOT;
"END"		return END;
"INTEGER"	{yylval.idtype=INTEGER;return INTEGER;}
"REAL"		{yylval.idtype=REAL;return REAL;}
"FOR"		return FOR;
"READ"		return READ;
"WRITE"	return WRITE;
"TO"		return TO;
"DO"		return DO;
";"		return SEMICOLON;
":"		return COLON;
","		return COMMA;
":="		return ASSIGN;
"+"		return ADD;
"-"		return SUB;
"*"		return MUL;
"DIV" 		return DIV;
"("		return SPAREN;
")"		return EPAREN;
{id}		{yylval.idname=strdup(yytext);return ID;}
{number}	{yylval.idtype=INTEGER;return INT;}
[0-9]+"."[0-9]+  {yylval.idtype=REAL;return real;}
.              {printf("Invalid token '%s' found at line number %d\n",yytext,yylineno);}
	
	
%%

int yywrap(void)
{
	return 1;
}

struct Node{
    char* name;
    int type;

};

struct Node* symtab[1000];




int hash(char *sym)
{
    char *t;
    int hashval=0;
    int i=1;
    for(t=sym;*t!='\0';t++)
    {
         int y=*t;
         hashval=hashval+i*y;
         i++;
    }
    
    return hashval%1000;

}

void inserttok(char *sym,int type)
{
    int hval=hash(sym);
    struct Node *p=(struct Node*)malloc(sizeof(struct Node));
    p->name=strdup(sym);
    p->type=type;

    
   
    if(symtab[hval]==NULL){
        symtab[hval]=p;
        
    }
   else {
    	
        
        return ;
    }
    
}


int findt(char *sym)
{
    int hval=hash(sym);
    char *val=strdup(sym);
    if(symtab[hval]!=NULL)
    {
       
        return 1;
        
    }
    return 0;
}





int insert_id(char *sym,int type)
{
    char *id=strdup(sym);
    if(findt(id)==0)
    {
        inserttok(id,type);
      
    }
    return hash(id);
    

}



struct Node *getIdNode(char *sym)
{
    int hval=hash(sym);
    char *val=strdup(sym);
    if(symtab[hval]!=NULL)
    {
        
        return symtab[hval];
        
    }
    return NULL;
}




