digit [0-9]
%{
#include <stdio.h>
#include <string.h>
#include "y.tab.h"
int linenum;
%}
%%	


"%rules" {yylval.string=strdup(yytext);return RULESRW;}
"int" {yylval.string=strdup(yytext);return INT;}
"float" {yylval.string=strdup(yytext);return FLOAT;}
"number" {yylval.string=strdup(yytext);return NUMBERTERMINAL;}
[A-Z]+	{yylval.string=strdup(yytext);return NONTERMINAL;}


\->	{yylval.string=strdup(yytext);return ARROW;}
\|	{yylval.string=strdup(yytext);return OR;}

\) {yylval.string=strdup(yytext);return CLOSE;}
\( {yylval.string=strdup(yytext);return OPEN;}
\; {yylval.string=strdup(yytext);return SEMICOLON;}

["*"|"+"|"-"|"/"] {yylval.string=strdup(yytext);return MATHOP;} 
[+|-]?[0-9]+ {yylval.numberint = atoi(yytext);return NUMBER;} //ATOİ? yada sıfır mesela yok olsun mu

\n	linenum++;
. 
[ \t]+
%%
