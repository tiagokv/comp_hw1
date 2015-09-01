%option noyywrap

%{

#include <stdio.h>
#include <string>
#include <iostream>
#include <fstream>
#include <unordered_map>

int numwords = 0;
int numnum = 0;
int numphrases = 0;

using namespace std;

typedef unordered_map<string,string> StringHashMap;
typedef pair<string,string> StringPair;

StringHashMap clases;
StringHashMap methods;

%}

/*http://docs.oracle.com/javase/specs/jls/se7/html/jls-3.html#jls-3.8*/
JAVALETTER  [a-zA-Z_]
JAVADIGIT   [0-9]
IDENTIFIER  {JAVALETTER}+[{JAVALETTER}{JAVADIGIT}]*

PALAVRA 	[^ \t\n\.,]+
CLASS   "public"[ \t\n]*"class"[ \t\n]*{IDENTIFIER}[ \t\n]*"{"
METHOD  "public"[ \t\n]+{IDENTIFIER}[ \t\n]+{IDENTIFIER}[ \t\n]*"("
COMMENT "//"
COMMENT_BEGIN "/*"
COMMENT_END "*/"

%s comment1 comment2
%%

<INITIAL>{COMMENT}   {BEGIN(comment1);}
<comment1>.
<comment1>[\n]+ {BEGIN(INITIAL);}

<INITIAL>{COMMENT_BEGIN}   {BEGIN(comment2);}
<comment2>[^{COMMENT_END}]
<comment2>{COMMENT_END} {BEGIN(INITIAL);}


{CLASS}     {printf("classe encontrada %s\n", yytext);}
{METHOD}    {printf("metodo encontrada %s\n", yytext);}

.
\n
%%

int main(int argc, char *argv[]){

	ofstream file;
	file.open("stats_ex2.txt");

	for(int i = 0; i < argc; i++){

		yyin = fopen(argv[i], "r");
		yylex();
		fclose(yyin);

		//file << "Número de palavras: " << numwords << endl;
		//file << "Número de palavras diferentes: " << words.size() << endl;
		//file << "A densidade léxica é: " << (words.size()/(float)numwords)*100 << endl;
		//file << "Número de frases: " << numphrases << endl;

	}

	file.close();

	return 0;
}
