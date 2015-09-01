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

/*comentarios*/
COMMENT "//"
COMMENT_BEGIN "/*"
COMMENT_END "*/"

/*Terminais. Quando encontra um reseta o estado*/
TERMINAL ["("|")"|"{"|"}"|";"|"="]

%s comment1 comment2 pub class declaration method
%%

{TERMINAL} {BEGIN(INITIAL);}

    /*Tratamento de comentarios de uma linha */
<INITIAL>{COMMENT}   {BEGIN(comment1);}
<comment1>.
<comment1>[\n]+ {BEGIN(INITIAL);}

    /*Tratamento de comentarios de varias linhas */
<INITIAL>{COMMENT_BEGIN}   {BEGIN(comment2);}
<comment2>[^{COMMENT_END}]
<comment2>{COMMENT_END} {BEGIN(INITIAL);}

    /* Quando encontra public existe a declaracao de um objeto publico */
<INITIAL>"public" {BEGIN(pub);}

    /* Ao encontrar class o proximo identificador e o nome da classe */
<pub>"class" {BEGIN(class);}
<class>{IDENTIFIER}     {printf("classe: %s\n", yytext); BEGIN(INITIAL);}

    /* se encontra mais um identificador e uma variavel ou metodo */
<pub>{IDENTIFIER}               {BEGIN(declaration);}
    /* se e uma atribuicao ou termina com ; e a declaracao de uma variavel */
<declaration>{IDENTIFIER}[ \t\n]*";"|"="    {BEGIN(INITIAL);}
    /* se e seguido apenas de um identificador entao e um metodo */
<declaration>{IDENTIFIER} {printf("metodo: %s\n", yytext); BEGIN(INITIAL);}

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
