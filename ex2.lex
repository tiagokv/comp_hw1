%option noyywrap

%{

#include <stdio.h>
#include <string>
#include <iostream>
#include <fstream>
#include <unordered_map>
#include <vector>

int numwords = 0;
int numnum = 0;
int numphrases = 0;

using namespace std;

typedef unordered_map<string,vector<string>*> ClassSpecs;
typedef pair<string,vector<string>*> ClassSpec;

ClassSpecs classes;
string sCurrentClass;

void class_processing(){

	ClassSpecs::iterator it;
	string str_matched(yytext);
	sCurrentClass = str_matched;

	it = classes.find(sCurrentClass);
	if( it != classes.end() ){
		cout << str_matched << " already exists (it will appear only once)";
		return;
	}

	vector<string>* methods = new vector<string>();
	ClassSpec class_specification(str_matched,methods);
	classes.insert(class_specification);

}

void method_processing(){

	ClassSpecs::iterator it;
	string str_matched(yytext);

	if( sCurrentClass.empty() == false ){

		it = classes.find(sCurrentClass);
		if( it != classes.end() ){
			it->second->push_back( str_matched );
		}else{
			cout << "Class " << sCurrentClass << " not found.";
		}

	}else{
		cout << "Method " << str_matched << " without class.";
	}

}

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

<pub>{TERMINAL} 				{BEGIN(INITIAL);}
<class>{TERMINAL} 			{BEGIN(INITIAL);}
<declaration>{TERMINAL} {BEGIN(INITIAL);}

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
<class>{IDENTIFIER}     {class_processing(); BEGIN(INITIAL);}

    /* se encontra mais um identificador e uma variavel ou metodo */
<pub>{IDENTIFIER}               {BEGIN(declaration);}
    /* se e uma atribuicao ou termina com ; e a declaracao de uma variavel */
<declaration>{IDENTIFIER}[ \t\n]*";"|"="    {BEGIN(INITIAL);}
    /* se e seguido apenas de um identificador entao e um metodo */
<declaration>{IDENTIFIER} {method_processing(); BEGIN(INITIAL);}

.
\n
%%

int main(int argc, char *argv[]){

	for(int i = 0; i < argc; i++){

		yyin = fopen(argv[i], "r");
		yylex();
		fclose(yyin);

	}

	ofstream file;
	file.open("ex2_stats.txt");

	for (ClassSpecs::iterator it=classes.begin(); it!=classes.end(); ++it){
		file << "Classe: " << it->first << endl;
		vector<string>* methods = it->second;

		for (vector<string>::iterator it=methods->begin(); it!=methods->end(); ++it){
			file << "\n "	<< *it << endl;
		}
	}

	file.close();

	return 0;
}
