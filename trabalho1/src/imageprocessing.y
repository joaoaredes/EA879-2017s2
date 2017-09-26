%{
#include <stdio.h>
#include "imageprocessing.h"
#include <FreeImage.h>
void yyerror(char *c);
int yylex(void);
%}
%union {
  char    strval[50];
  float     ival;
}
%token <strval> STRING 
%token <ival> VAR IGUAL EOL ASPA NUM OPE ABRECOL FECHACOL
%left SOMA

%%

PROGRAMA:
        PROGRAMA EXPRESSAO EOL
        |
        ;

EXPRESSAO:
    | STRING IGUAL STRING {
        printf("Copiando %s para %s\n", $3, $1);
        imagem I = abrir_imagem($3);
        printf("Li imagem %d por %d\n", I.width, I.height);
        salvar_imagem($1, &I);
        liberar_imagem(&I);
                          }
    | STRING IGUAL STRING OPE NUM {
	printf("Copiando %s para %s\n", $3, $1);
	imagem I = abrir_imagem ($3);
	printf("Li imagem %d por %d\n", I.width, I.height);
	printf("Multiplicando o brilho por %f\n", $5);
	alterar_brilho(&I, $3, $5);
	printf("Salvando imagem %s\n", $1);
	salvar_imagem($1, &I);
	liberar_imagem(&I);
			  }

    | ABRECOL STRING FECHACOL {
	imagem I = abrir_imagem ($2);
	intensidade_max(&I, $2);
	liberar_imagem(&I);
	}
  ;
%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main() {
  FreeImage_Initialise(0);
  yyparse();
  return 0;

}
