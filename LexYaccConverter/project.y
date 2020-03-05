%{
#include <stdio.h>
#include <string.h>
	extern FILE *yyin;
 	void yyerror(char *);
    	int yylex(void);
    	extern int linenum;
	int check_rulecounter[100] =  { 0 };
	int rule_nonterminal_counter[100] =  { 0 };

	char *rule_nonterminal_name[100] = { "?" }; 
	char *grammer_nonterminal_name[100] = { "?" }; 
	char *rightside_nonterminal_name[100] = { "?" };
	
	int grammer_counter=0;
	int rightside_nonterminal_counter=0;
	
	int rule_counter=1;//orları saydıgından bı or varsa aslında ıkı rule ı var denemektır
	int nonterminal_counter=0;

	int x;
	int y;

	int analysis2flag=0;
	int analysis2flag2=0;
	int analysis3flag=0;
	int analysis3nogrammer=1;
	int analysis4useless=1;
	int thecounter=1;
	int thecounter2=0;
	int thecounter3=0;
	FILE *outputFile;
	
	
	
%}

%union
{
char *string;
int numberint;
}

%token <string> OR
%token <string> NONTERMINAL
%token <string> ARROW
%token <string> RULESRW
%token <string> INT
%token <string> FLOAT
%token <string> CLOSE
%token <string> OPEN
%token <string> SEMICOLON
%token <string> MATHOP
%token <string> NUMBERTERMINAL

						
%token <numberint> NUMBER
%type <string> ending
%type <string> endings
%type <string> subrules
%type <string> program
%type <string> line
%type <string> rule
%type <string> or


%%
rules:
	RULESRW rule SEMICOLON program {			

					for(x=0; x<nonterminal_counter ; x++)			//analysis 2
					{
						analysis2flag=0;		//defined in rule definition but does not have a grammer rule
						for(y=0; y<grammer_counter; y++)			
						{

							if( strcmp(grammer_nonterminal_name[y],rule_nonterminal_name[x])==0 )
							{
								analysis2flag=1;
							break;
							}

						}
						if(analysis2flag==0)
						{
							printf("%s does not have grammer rule\n",rule_nonterminal_name[x]);
							exit(0);
						}


					

					}
					//printf("analysis check2 doesnt have a grammer is passed\n");

///-------------------------------------------------------------------------------------------------------------------------------------------

					for(x=0; x< grammer_counter; x++)			//analysis 2.1
					{
						analysis2flag2=0;		//defined in rule definition but does not have a grammer rule
						for(y=0; y<nonterminal_counter; y++)			
						{

							if( strcmp(grammer_nonterminal_name[x],rule_nonterminal_name[y])==0 )
							{
								analysis2flag2=1;
								
							}

						}
						if(analysis2flag2==0)
						{
						printf(" There is grammar rule for non-terminal %s but it is not defined in the rule definition line \n",grammer_nonterminal_name[x]);
						exit(0);
						}

					}
					//printf("grammer rule var ama rule defınıtıonda yok ıs passed\n");
///-------------------------------------------------------------------------------------------------------------------------------------------
				
				for(y=0; y<grammer_counter; y++)			
				{
					for(x=0; x<nonterminal_counter; x++)			//analysis 1
					{
		
						if(strcmp(grammer_nonterminal_name[y],rule_nonterminal_name[x])==0)
						{
							
							if(rule_nonterminal_counter[x] != check_rulecounter[x])
							{
								printf("The number of rules for %s non-terminal is %d but in the rule definition line it is %d \n",grammer_nonterminal_name[y],check_rulecounter[x],rule_nonterminal_counter[x]);
								exit(0);
							}
						
						break;	
						}


					}

					
				}
				//printf("analays1 passed rule sayıları tutuyor\n");

///-------------------------------------------------------------------------------------------------------------------------------------------	
					
				for(y=0; y < rightside_nonterminal_counter; y ++)	//analysis3
				{	
					analysis3nogrammer=1;
					
					for(x=0; x< grammer_counter; x++)
					{
						if(strcmp(grammer_nonterminal_name[x],rightside_nonterminal_name[y])==0)	//eger ? degil ise bi onun grammer rule u yok
						{
							
							analysis3nogrammer=0;
							
						}
					}
					
					if(analysis3nogrammer==1)
					{
						printf("%s does not have any dedicated grammar rule\n",rightside_nonterminal_name[y]);
						exit(0);
					}
		
				}

///----------------------------------------------------------------------------------------------------------------------------------------------------------------

				for(x=0; x< grammer_counter; x++)	//analysis4
				{	
					analysis4useless=1;
					

					for(y=0; y < rightside_nonterminal_counter; y ++)
					{
						if(strcmp(grammer_nonterminal_name[x],rightside_nonterminal_name[y])==0)	//useless
						{
							analysis4useless=0;
							
						}
					}
					if(analysis4useless==1)
					{
						printf("%s never referenced in the right-hand side of any grammar rule, thus useless rule\n",grammer_nonterminal_name[x]);
						exit(0);
					}
		
				}


///---------------------------------------------------------------------------------------------------------------------------------------------------------------
					//output.c
			

			fprintf(outputFile,"#include<stdio.h>\ntypedef enum {INT, FLOAT, NUMBER, MATHOP, OPEN, CLOSE, END} TOKEN;\nTOKEN input[50] = \nTOKEN *next = input;\n");
			fprintf(outputFile,"\n");
			
			for(x=0; x<nonterminal_counter ; x++)			//output fifth line
			{
				fprintf(outputFile,"int %s(); ",rule_nonterminal_name[x]);

				for(y=1; y<=rule_nonterminal_counter[x] ; y++)
				{
					fprintf(outputFile,"int %s%d(); ",rule_nonterminal_name[x],y);
				}
						
			}
			

		fprintf(outputFile,"\n\n");


		fprintf(outputFile,"int term(TOKEN tok) {return *next++ == tok;}\n\n");
		fprintf(outputFile,"%s \n",$4);
		fprintf(outputFile,"\n");
		fprintf(outputFile,"int main(void)\n{\n\tif (%s() && term(END))\n\tprintf (\"Accept!\\n\");\n\telse\n\tprintf (\"Reject!\\n\");\n\treturn 0;\n}\n",rule_nonterminal_name[0]);
				

	}
	;

///-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
rule:
	rule NONTERMINAL NUMBER {
					$$=$2;

					for(y=0; y<nonterminal_counter ; y++)
					{
						if(strcmp($2,rule_nonterminal_name[y])==0)
						{
							printf("%s redefinition error in rules definition\n",$2);
							exit(0);
						}


					}
					if($3 < 1)
					{
						printf("Rule number cannot be smaller than 1\n");
						exit(0);
					}
					else
					{
						rule_nonterminal_name[nonterminal_counter]=strdup($2);
						rule_nonterminal_counter[nonterminal_counter]=$3;

						nonterminal_counter++;
						
					}	
				}
	|
	NONTERMINAL NUMBER{
					$$=$1;

					for(y=0; y<nonterminal_counter ; y++)
					{
						if(strcmp($1,rule_nonterminal_name[y])==0)
						{
							printf("%s redefinition error in rules definition\n",$1);
							exit(0);
						}


					}

					if($2 < 1)
					{
						printf("Rule number cannot be smaller than 1\n");
						exit(0);
					}
					else
					{
						
						rule_nonterminal_name[nonterminal_counter]=strdup($1);
						rule_nonterminal_counter[nonterminal_counter]=$2;
						
						nonterminal_counter++;
						
					}

					
			

				}
	
	;
	
program:

	line  SEMICOLON program{rule_counter=1;sprintf($$, "%s%s",strdup($1),strdup($3));}
	|
	line SEMICOLON{ rule_counter=1;sprintf($$, "%s",strdup($1));}
	;

line:
	NONTERMINAL ARROW subrules{
				
				
				for(y=0; y<grammer_counter ; y++)
				{		
						if(strcmp($1,grammer_nonterminal_name[y])==0)
						{
							printf("%s redefinition of grammer rule error \n",$1);
							exit(0);
						}


				}

				grammer_nonterminal_name[grammer_counter]=strdup($1);	//analysis 2
				grammer_counter++;


				for(x=0; x<nonterminal_counter; x++)			//analysis 1
				{
					
					if(strcmp($1,rule_nonterminal_name[x])==0)
					{
						check_rulecounter[x]=rule_counter;
						
						rule_counter=1;	
						break;	
					}


				}

				$$=malloc(1000);
				sprintf($$, "%s;}",$3);
				
				thecounter=1;
				thecounter2++;


				
					sprintf($$,"%s\nint %s() {TOKEN *save=next; ",strdup($$),rule_nonterminal_name[x]);
					
					for(y=1; y<=rule_nonterminal_counter[x] ; y++)
					{
						if(y==1)
						{
							sprintf($$,"%sreturn %s%d() || ",strdup($$),rule_nonterminal_name[thecounter3],y);
						
						}

						else if(y!=1 && y!=rule_nonterminal_counter[x])
						{
							sprintf($$,"%s(next=save, %s%d()) || ",strdup($$),rule_nonterminal_name[thecounter3],y);
							
						}

						else
						{
							sprintf($$,"%s(next=save, %s%d())",strdup($$),rule_nonterminal_name[thecounter3],y);
							
						}
					}
					
					thecounter3++;					
					sprintf($$,"%s;}\n\n",strdup($$));		

				}
				;

subrules: 
	endings	{sprintf($$, "%s",strdup($1));}
	|
	endings or subrules{ 
				rule_counter++;
				sprintf($$, "%s%s%s",strdup($1),strdup($2),strdup($3));
		
				}
	
	
	;

or:
	OR {sprintf($$, ";}\n");}
	;

endings:
	endings ending	{sprintf($$, "%s && %s",strdup($1),strdup($2));}			
	|
	ending{sprintf($$, "int %s%d() {return %s",rule_nonterminal_name[thecounter2],thecounter,strdup($1));thecounter++;}	

	;
ending: 
	NONTERMINAL{
			
			$$=malloc(1000);
			sprintf($$, "%s()",strdup($1));
			for(y=0; y < rightside_nonterminal_counter || y==0 ; y ++)
			{
					
				if(strcmp($1,rightside_nonterminal_name[y])==0)
				{

					analysis3flag=1;
					break;
				}
			}
			if(analysis3flag==0)
			{
				
				rightside_nonterminal_name[rightside_nonterminal_counter]=strdup($1);	//analysis4
				rightside_nonterminal_counter++;
			}
			analysis3flag=0;
			
			


		}	
	|	
	MATHOP {sprintf($$, "term(MATHOP)");}
	|
	INT	{sprintf($$, "term(INT)");}
	|
	FLOAT	{sprintf($$, "term(FLOAT)");}
	|
	CLOSE	{sprintf($$, "term(CLOSE)");}
	|
	OPEN	{sprintf($$, "term(OPEN)");}
	|
	NUMBERTERMINAL {sprintf($$, "term(NUMBER)");}
	
	;




%%
void yyerror(char *s){
	
	fprintf(stderr, "error: %s\n ++++ %d\n", s,linenum);
}
int yywrap(){
	return 1;
}
int main(int argc, char *argv[])
{
    /* Call the lexer, then quit. */
    yyin=fopen(argv[1],"r");
    outputFile=fopen("output.c","w");
    yyparse();
    fclose(yyin);
    fclose(outputFile);
    return 0;
}

