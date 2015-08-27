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

StringHashMap words;

void word_processing(){
	/* Lógica é um tanto simples, inserimos em um HashMap para manter a contagem
		 de quantas palavras são diferentes
	 */
	string str_matched(yytext);

	//cout << "palavra " + str_matched + " encontrada" << endl;

	//Primeira vez, adiciona no hash map
	if( words.find(str_matched) == words.end() ){

		StringPair p( str_matched, str_matched );
		words.insert(p);

	}

	numwords++;
}

void phrase_processing(){
	string str_matched(yytext);

	cout << "frase " + str_matched + " encontrada" << endl;

	numphrases++;
}

%}

PALAVRA 	[^ \t\n\.,]+
NUMERO 		{DIGITO}+[\.]?{DIGITO}+
/*FRASE			[^\t\n\.]+[\.] {FRASE}		{ phrase_processing(); };  Não pode ser utilizado, sempre pega...*/
/* o maior match (que é a frase) daria pra utilizar o REJECT, mas ele rejeita inclusiva a frase pegando */
/* todas as combinações da frase: "Tiago é foda." -> " é foda." -> "é foda." ... */
%%

{PALAVRA} { word_processing(); }
\.				numphrases++;
.
\n
%%

int main(int argc, char *argv[]){
	yyin = fopen(argv[1], "r");
	yylex();
	fclose(yyin);

	ofstream file;
	file.open("stats.txt");

	file << "Número de palavras: " << numwords << endl;
	file << "Número de palavras diferentes: " << words.size() << endl;
	file << "A densidade léxica é: " << (words.size()/(float)numwords)*100 << endl;
	file << "Número de frases: " << numphrases << endl;

	file.close();

	return 0;
}
