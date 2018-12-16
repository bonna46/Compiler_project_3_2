
%{
#include<stdio.h>
#include <math.h>
#include<stdlib.h>
#include<string.h>
#define var 180
#define pi  3.1416


    char we[1000][1000];
    int last_point = 1,f=1;
    int store[1000];
    int casedefault=0,casevar=0;

    int isdeclared(char s[])
    {
        int i;
        for(i=1; i<last_point; i++)
        {
            if(strcmp(we[i],s) == 0)
                return 1;
        }
        return 0;
    }

    int save(char s[])
    {
        if(isdeclared(s)==1)
            return 0;
        strcpy(we[last_point],s);
        store[last_point]=0;
        last_point++;
        return 1;
    }

    int setval(char s[],int val)
    {
        if(isdeclared(s) == 0)
            return 0;
        int p=0;
        int i;
        for( i=1; i<last_point; i++)
        {
            if(strcmp(we[i],s) == 0)
            {
                p=i;
                break;
            }
        }
        store[p]=val;
        return 1;
    }

    int getval(char s[])
    {

        int p=-1;
        int i;
        for( i=1; i<last_point; i++)
        {
            if(strcmp(we[i],s) == 0)
            {
                p=i;
                break;
            }
        }
        return store[p];
    }



%}

%union
{
    char ch[1000];
    int poko;
    int IN;
}

%token <poko>  Number
%token <ch>  Variable
%type  <IN>  expression
%type  <poko>  after
%type  <poko> afterall
%type  <poko> Ended

%token Int Float Character CF EF FR Equal Add Sub Mul Div Power Remain Equal_con Less_con More_con Moreequal_con Lessequal_con Increment Decrement CM PF Ended Colon Case Default Value

%nonassoc IFX
%nonassoc ELSE
%left Less_con More_con Equal_con Moreequal_con Lessequal_con
%left Add Sub
%left Mul Div
%left Power

%%

line	: /* empty */

	| line afterall

	| declare
	;


declare	:
	type id Ended      /* 		{ printf("\nValid declaration\n"); } */
	;


type	:
	Int

	| Float

	| Character
	;


id	:
	id CM Variable
		{
   		 if(isdeclared($3)==1)
      			  printf("\nDouble Declaration!\n");
   		 else
    			    save($3);
		}

	| Variable
		{
		   if(isdeclared($1)==1)
      			  printf("\nDouble Declaration!\n");
   		 else
      				  save($1);
		}
	;


afterall :
	afterall after

	| after
	;


after	:
	Ended

	| declare

	| expression Ended
		{
 		   $$=$1;
 		/*   printf("\nValue of expression: %d\n",$1); */
		}

	| Value '[' Variable ']' Ended
		{
 		   printf("\nValue of the variable: %d\t\n",getval($3));
		}

	| Variable Equal expression Ended
		{
 		   if(setval($1,$3)==0)
  		 	 {
  		    	  $$=0;
  	   	   	printf("\nNot declared\n");
   			 }
    			else
    			{
      			  $$=$3;
   			 }
		}

	| CF '[' expression ']' '{' afterall '}' %prec IFX
		{
   			 printf("\nCondition is true in IF: %d\n",$6);
		}

	| CF '[' expression ']' '{' afterall '}' EF '{' afterall '}' %prec IFX
		{
 		   f=f+1;
  		  int p=0;
  		  if($3)
   			 {
      			  printf("\nCondition is true in IF: %d\n",$6);
        			p=1;
    			}
    		if(p==0)
      		  printf("\nCondition is false in IF: %d\n",$10);
		}

	| FR '[' Variable Equal Number Colon Variable Less_con Number Colon Variable Increment ']' '{' afterall '}'
		{
 		  int i;
			for(i= $5 ; i< $9 ; i= i+1)
				{
			 printf("\nExpression in for loop : %d\n",$15);
				}  			    
		}

	| Case '[' Exp_case ']' '{' Innercode '}'
	;



Exp_case :
	expression
		{
    		casedefault = 0;
    		casevar = $1;
		}
	;


Innercode: /* empty */

	| Innercode expression Colon '{' afterall '}'
		{
    		if($2 == casevar)
    			{
        			printf("\nExecuted %d\n",$2);
        			casedefault = 1;
   			 }
		}

	| Innercode Default Colon '{' afterall '}'
		{
  		  if(casedefault == 0)
   			 {
    			    casedefault = 1;
     			   printf("\nDefault Block executed\n");
    			}
		}
	;



expression:
	Number		   		  { $$ = $1;}

	| Variable
		{
  		  if( isdeclared($1) == 0)
   			 {
    			    $$=0;
     			   printf("\nNot declaredd!\n");
   			 }
    		else
       			 $$=getval($1);
		}
	
	| expression Add expression	  	
		 { 	
			$$ = $1 + $3; printf("\nAddition value %d\n",$$);
		 }

	| expression Sub expression	 	  
		{
  			$$ = $1 - $3; printf("\nSubtraction value %d\n",$$);
		}

	| expression Mul expression
		{
 			   $$ = $1 * $3;
 			   printf("\nMultiplication value %d\n",$$);
		}

	| expression Div expression	 	  
		{ 	if($3)
 			   {
  			      $$ = $1 / $3;
     				   printf("\nDivision value %d\n",$$);
  			  }
   			 else
    			{
      				  $$ = 0;
       				 printf("\nDivision by zero\t");
    			}
		}

	| expression Power expression 		
		{ 	$$=pow($1,$3); printf("\nPower value %d\n",$$);}

	| expression Remain expression 		
		{	 $$=$1 % $3; printf("\nRemainder value %d\n",$$);}

	| '~''[' expression ']''~'		  
    		 { $$ = $3 ;}
	| expression Less_con expression	
		{ $$ = $1 < $3; }

	| expression More_con expression	
		{ $$ = $1 > $3; }

	| expression Lessequal_con expression  
		{ $$ = $1 <= $3; }

	| expression Moreequal_con expression   
 		 { $$ = $1 >= $3; }

	;


%%



int yyerror(char *s)
{
    printf( "%s\n", s);
}









