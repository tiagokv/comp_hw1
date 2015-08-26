%option noyywrap

%{

#include <stdio.h>
#include <string>
#include <iostream>
#include <unordered_map>

int numwords = 0;
int numnum = 0;
int numtag = 0;

using namespace std;

typedef unordered_map<string,string> StringHashMap;
typedef pair<string,string> StringPair;

StringHashMap words;

void word_processing(){
	/* Lógica é um tanto simples, inserimos em um HashMap para manter a contagem
		 de quantas palavras são diferentes
	 */
	string str_matched(yytext);

	cout << "palavra " + str_matched + " encontrada" << endl;

	//Primeira vez, adiciona no hash map
	if( words.find(str_matched) != words.end() ){

		StringPair p( str_matched, str_matched );
		words.insert(p);

	}

	numwords++;
}

%}

PALAVRA 	[^ \t\n\.,]+
NUMERO 		{DIGITO}+[\.]*{DIGITO}+

%%

{PALAVRA} { word_processing(); }
.

\n
%%

int main(int argc, char *argv[]){
	yyin = fopen(argv[1], "r");
	yylex();
	fclose(yyin);

	printf("Número de palavras: %d\n", numwords);
	printf("Número de palavras diferentes : %d\n", words.size() );

	return 0;
}
