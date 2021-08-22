rm=/bin/rm -f


all: output 

output: y.tab.c y.tab.h lex.yy.c 
	gcc lex.yy.c y.tab.c -w -o output
	

lex.yy.c: 180101088.l 180101088.y
	$(LEX) 180101088.l
	
	
y.tab.c: 180101088.l 180101088.y
	$(YACC) -d 180101088.y
