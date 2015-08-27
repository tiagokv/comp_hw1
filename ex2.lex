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

%}

%%

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

		file << "Número de palavras: " << numwords << endl;
		file << "Número de palavras diferentes: " << words.size() << endl;
		file << "A densidade léxica é: " << (words.size()/(float)numwords)*100 << endl;
		file << "Número de frases: " << numphrases << endl;

	}

	file.close();

	return 0;
}
