To compile the files run the following command:
    make
    
This will generate an ./output file which can be run using the following command:
    ./output
    
    
    
#########################################################


****About the input file****

The following syntax errors have been incorporated in the input file:
    1)A missing semicolon at line number 7.    
    2)An invalid token '%' is used at line number 15.
    
The following semantic errors have been incorporated in the input file:
    1)The variable MEAN is not declared.
    2)The variable SUM which is of integer type is assigned a real value which causes a type mismatch.
    
    
    
##########################################################


****In case the makefile does not work****
Run the following commands on the command prompt:
    yacc -d 180101088.y 
    lex 180101088.l
    gcc y.tab.c lex.yy.c -o output
