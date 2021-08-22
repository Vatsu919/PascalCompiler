

%{
    #include<stdio.h>
    
    
    /* prototypes  */
    
    void yyerror(char *s);
    extern FILE *yyin;
    extern char* yytext;
    extern char* idtext;
    extern int yylineno;
    extern int insert_id(char *sym,int type);
    int errflag=0;
    extern int findt(char *sym);
    extern struct Node *getIdNode(char *sym);
    extern int insertVal(char *sym,int num);
    extern struct Number* getIntVal(char *sym);
    int typ;
    int erval=0;
    
   
    
    struct Node{
    char* name;
    int type;
    };


    
%}

%token PROGRAM 1
%token VAR 2
%token BEGINP 3
%token END 4
%token ENDDOT 5
%token <idtype> INTEGER 6
%token <idtype> REAL 7
%token FOR 8
%token READ 9
%token WRITE 10
%token TO 11
%token DO 12
%token SEMICOLON 13
%token COLON 14
%token COMMA 15 
%token ASSIGN 16
%token ADD 17
%token SUB 18
%token MUL 19
%token DIV 20
%token SPAREN 21
%token EPAREN 22
%token <idname> ID 23
%token <idtype> INT 24
%token <idtype> real 25





%type <idtype> factor
%type <idtype> exp
%type <idtype> term
%type <idtype> id_list
%type <idtype> type

 

%union
{
    
    char *idname;
    int idtype;
   
}



%left ADD SUB
%left MUL
%left DIV


%%

prog: PROGRAM prog_name VAR dec_list BEGINP stmt_list ENDDOT ;

prog_name : ID    ;
dec_list : dec | dec_list dec ;
id_list1 : ID | id_list1 COMMA ID ;
dec: ID id_list {insert_id($1,$2);}  ;
id_list: COMMA ID id_list {insert_id($2,$3);$$=$3;} | COLON type  {$$=$2;};
type: INTEGER | REAL  ;
stmt_list : stmt | stmt_list SEMICOLON stmt | error stmt {YYERROR;yyerrok;}  ;
stmt : assign | read | write | for  ;
assign : ID {if(findt(yylval.idname)==0){yyerror("uvariable");erval=1;yyerrok;}} ASSIGN exp {if(erval==1){erval=0;insert_id($1,$4);}if(getIdNode($1) && getIdNode($1)->type!=$4){yyerror("tmismatch");yyerrok;}}  ;
exp : term  | exp ADD term {if($1!=$3){yyerror("tmismatch");yyerrok;}} | exp SUB term {if($1!=$3){yyerror("tmismatch");yyerrok;}} ;
term : factor | term MUL factor {if($1!=$3){yyerror("tmismatch");yyerrok;}} | term DIV factor {if($1!=$3){yyerror("tmismatch");yyerrok;}} ;
factor : ID {if(getIdNode($1)!=NULL){$$=getIdNode($1)->type;}else{yyerror("uvariable");yyerrok;}}| INT | real | SPAREN exp EPAREN {$$=$2;};
read : READ SPAREN id_list1 EPAREN ;
write : WRITE SPAREN id_list1 EPAREN ;
for : FOR index_exp DO body  ;
index_exp : ID {if(findt(yylval.idname)==0){yyerror("uvariable");yyerrok;}} ASSIGN exp TO exp ;
body : stmt | BEGINP stmt_list END  ;
 
  
%%



void yyerror(char *s)
{
    errflag=1;
    char *st="syntax error";
    char *st1="uvariable";
    char *st2="tmismatch";
    //printf("\033[90;31mError:  \033[m");
    if(strcmp(s,st)==0)
    {
    fprintf(stdout,"Error found before the token '%s' at line number %d\n",yytext,yylineno);
    }
    
    else if(strcmp(s,st1)==0)
    {
    fprintf(stdout,"Undeclared variable '%s' found at line %d\n",yylval.idname,yylineno);
    
    }
    else if(strcmp(s,st2)==0)
    {
    fprintf(stdout,"Type mismatch found at line %d\n",yylineno);
    }
}

int main(void) 
{
    FILE *fp;
    fp=fopen("inp.txt","r");
    yyin=fp;
    yyparse();
   
    if(errflag==0)
    {
    
        printf("Program successfully parsed.\n");
    }
    else
    {
        printf("Errors found while parsing the input file.\n");
    }
    
    return 0;

}


 
