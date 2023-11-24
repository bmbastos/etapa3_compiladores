%{
    /*
    Integrantes do grupo V:
    - Bruno Marques Bastos (314518)
    - Gustavo Lopes Noll (322864)
    */
    #include <stdio.h>
    #include "estruturas.h"

    int yylex(void);
    void yyerror (char const *mensagem);
%}
%define parse.error verbose
%union{
    valor_lexico *vl;
    struct nodo* ast_no;
}

%token TK_PR_INT
%token TK_PR_FLOAT
%token TK_PR_BOOL
%token TK_PR_IF
%token TK_PR_ELSE
%token TK_PR_WHILE
%token TK_PR_RETURN
%token TK_OC_LE
%token TK_OC_GE
%token TK_OC_EQ
%token TK_OC_NE
%token TK_OC_AND
%token TK_OC_OR
%token TK_IDENTIFICADOR
%token TK_LIT_INT
%token TK_LIT_FLOAT
%token TK_LIT_FALSE
%token TK_LIT_TRUE
%token TK_ERRO


%%

programa: elementos
        | /* Vazio */
        ;

elementos: elementos elemento
         | elemento
         ;

elemento: declaracoes_globais
        | definicao_funcao
        ;

declaracoes_globais: declaracao_variaveis_globais
                 ;

declaracao_variaveis_globais: tipo lista_identificadores ';'
                        ;

tipo: TK_PR_INT
    | TK_PR_FLOAT
    | TK_PR_BOOL
    ;

lista_identificadores: TK_IDENTIFICADOR
                   | lista_identificadores ',' TK_IDENTIFICADOR
                   | /* Vazio */
                   ;

definicao_funcao: cabecalho_funcao corpo_funcao
               ;

cabecalho_funcao: parametros TK_OC_GE tipo '!' TK_IDENTIFICADOR
               | tipo '!' TK_IDENTIFICADOR TK_OC_GE tipo '!' TK_IDENTIFICADOR
               ;

parametros: '(' lista_parametros ')'
          ;

lista_parametros: parametro
               | lista_parametros ',' parametro
               | /* Vazio */
               ;

parametro: tipo TK_IDENTIFICADOR
         ;

corpo_funcao: bloco_comandos
            ;

comandos: comando
        | comandos comando
        ;

comando: declaracao_variavel_local
       | atribuicao
       | condicao
       | repeticao
       | retorno
       | bloco_comandos
       | chamada_funcao_init
       ;


declaracao_variavel_local: tipo lista_identificadores ';'
                       ;

atribuicao: TK_IDENTIFICADOR '=' expressao ';'
         ;

condicao: TK_PR_IF '(' expressao ')' bloco_comandos
        | TK_PR_IF '(' expressao ')' bloco_comandos TK_PR_ELSE bloco_comandos
        ;

repeticao: TK_PR_WHILE '(' expressao ')' bloco_comandos
         ;

retorno: TK_PR_RETURN expressao ';'
       ;

bloco_comandos: '{' comandos '}'
              | '{' '}'
              ;

chamada_funcao_init: TK_IDENTIFICADOR '(' argumentos ')' ';'
chamada_funcao: TK_IDENTIFICADOR '(' argumentos ')' 
             ;

argumentos: 
          | expressao
          | argumentos ',' expressao
          ;

expressao: expressao '<' termo
         | expressao '>' termo
         | expressao TK_OC_LE termo
         | expressao TK_OC_GE termo
         | expressao TK_OC_EQ termo
         | expressao TK_OC_NE termo
         | expressao TK_OC_AND termo
         | expressao TK_OC_OR termo
         | expressao '+' termo
         | expressao '-' termo
         | termo
         ;

termo: termo '*' fator
     | termo '/' fator
     | termo '%' fator
     | fator
     ;

fator: '-' fator %prec '-'
     | '!' fator %prec '!'
     | primario
     ;

primario: '(' expressao ')'
        | TK_IDENTIFICADOR
        | literais
        | chamada_funcao
        ;

literais: TK_LIT_INT
        | TK_LIT_FLOAT
        | TK_LIT_TRUE
        | TK_LIT_FALSE

%%
