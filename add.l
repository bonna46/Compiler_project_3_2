%{
#include "add.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int varindex(char *var);

%}

IDENTIFIER [a-zA-Z][a-zA-Z0-9]*[_]?[a-zA-Z0-9]*
DIGIT [0-9]
CASEVAR [a-z]

%%

"intt"               { return Int; }
"floatt"             { return Float;}
"charr"              {return Character;}

"IF"    {return CF;}
"FI"    {return EF;}
"FR"    {return FR;}

":"             { return Colon; }
"CASE"          { return Case;}
"ESAC"          { return Default;}
"VALUE"		{ return Value;}

[~[]        { return *yytext; }
[]~]        { return *yytext; }
[~{]        { return *yytext; }
[}~]        { return *yytext; }
[``]        { return Ended; }


":o"      {return Equal;}
":)"      {return Add;}
":("      {return Sub;}
":D"      {return Mul; }
":|"      {return Div;}
":v"      {return Power; }
":p"      {return Remain; }


":o:o"    {return Equal_con;}
"<3"      {return Less_con;}
"8>"      {return More_con;}
"<3:o"    {return Lessequal_con;}
"8>:o"    {return Moreequal_con;}
":):)"    {return Increment; }
":(:("    {return Decrement;}


"PF"     {return PF;}    
","      {return CM;}
[ \t\n]*	;


{IDENTIFIER} {
			yylval.IN = *yytext - 'a';
 			return Variable;
 			}

"-"?{DIGIT}+ {
	yylval.poko=atof(yytext);
	return Number;
	}

"-"?{DIGIT}+?"."{DIGIT}+ {
	yylval.poko=atof(yytext);
	return Number;
	}

%%

int yywrap()
{
	return 1;
}

int main()
{
	yyin = freopen("myinput.txt","r",stdin);
	yyout = freopen("output.txt","w",stdout);
	yyparse();

}

