%{
    /*
    Integrantes do grupo V:
    - Bruno Marques Bastos (314518)
    - Gustavo Lopes Noll (322864)
    */
    #include <stdio.h>
    #include "functions.h"
    #include "estruturas.h"
    #include "ast.h"

    int yylex(void);
    void yyerror (char const *mensagem);
    void liberaPalavraeNo(valor_lexico *vl);
    extern void *arvore;
%}
%define parse.error verbose
%union{
    valor_lexico* v_lexico;
    struct nodo* ast_no;
}

%token TK_PR_INT
%token TK_PR_FLOAT
%token TK_PR_BOOL
%token TK_PR_IF
%token TK_PR_ELSE
%token TK_PR_WHILE
%token TK_PR_RETURN
%token<v_lexico> TK_OC_LE
%token<v_lexico> TK_OC_GE
%token<v_lexico> TK_OC_EQ
%token<v_lexico> TK_OC_NE
%token<v_lexico> TK_OC_AND
%token<v_lexico> TK_OC_OR
%token<v_lexico> TK_IDENTIFICADOR
%token<v_lexico> TK_LIT_INT
%token<v_lexico> TK_LIT_FLOAT
%token<v_lexico> TK_LIT_FALSE
%token<v_lexico> TK_LIT_TRUE
%token TK_ERRO

%type<ast_no> programa
%type<ast_no> elementos
%type<ast_no> elemento
%type<ast_no> definicao_funcao
%type<ast_no> cabecalho_funcao
%type<ast_no> corpo_funcao
%type<ast_no> comandos
%type<ast_no> comando
%type<ast_no> declaracao_variavel_local
%type<ast_no> atribuicao
%type<ast_no> condicao
%type<ast_no> repeticao
%type<ast_no> retorno
%type<ast_no> bloco_comandos
%type<ast_no> chamada_funcao_init
%type<ast_no> lista_identificadores
%type<ast_no> expressao
%type<ast_no> literais

%%

programa: elementos {
          $$ = $1;
          }
        | /* Vazio */ {
          arvore = $$ = novoNo(TIPO_CABECA_LISTA, NULL);
          }
        ;

elementos: elementos elemento
         | elemento
         ;

elemento: declaracoes_globais
        | definicao_funcao {
          $$ = $1;
        }
        ;

declaracoes_globais: declaracao_variaveis_globais 
                 ;

declaracao_variaveis_globais: tipo lista_identificadores ';'
                        ;

tipo: TK_PR_INT
    | TK_PR_FLOAT
    | TK_PR_BOOL
    ;

lista_identificadores: TK_IDENTIFICADOR {
                    liberaPalavraeNo($1);
                    }
                   | lista_identificadores ',' TK_IDENTIFICADOR {
                    liberaPalavraeNo($3);
                   }
                   | /* Vazio */
                   ;

definicao_funcao: cabecalho_funcao corpo_funcao {
                    $$ = $1;
                    adicionarFilho($1, $2);
               }
               ;

cabecalho_funcao: parametros TK_OC_GE tipo '!' TK_IDENTIFICADOR {
                    $$ = novaFuncao($5);
               }
               | tipo '!' TK_IDENTIFICADOR TK_OC_GE tipo '!' TK_IDENTIFICADOR {
                    $$ = novaFuncao($7);
               }
               ;

parametros: '(' lista_parametros ')'
          ;

lista_parametros: parametro
               | lista_parametros ',' parametro
               | /* Vazio */
               ;

parametro: tipo TK_IDENTIFICADOR {
                    liberaPalavraeNo($2);
}
         ;

corpo_funcao: bloco_comandos
            ;

comandos: comando
        | comandos comando {
               $$ = $1;
               adicionarProximo($$, $2);
        }
        ;

comando: declaracao_variavel_local {$$ = $1;}
       | atribuicao                {$$ = $1;}
       | condicao                  {$$ = $1;}
       | repeticao                 {$$ = $1;}
       | retorno                   {$$ = $1;}
       | bloco_comandos            {$$ = $1;}
       | chamada_funcao_init       {$$ = $1;}
       ;


declaracao_variavel_local: tipo lista_identificadores ';' {
     if($2->valor == TIPO_CABECA_LISTA){
          $$ = $2->proximo;
          free($2);
     }
     else{
          $$ = $2;
     }
}
                       ;

atribuicao: TK_IDENTIFICADOR '=' expressao ';' {
     nodo* identificador = novoNo(TIPO_IDENTIFICADOR, $1);
     $$ = comandoAtribuicao(identificador, $3);
}
         ;

condicao: TK_PR_IF '(' expressao ')' bloco_comandos
        | TK_PR_IF '(' expressao ')' bloco_comandos TK_PR_ELSE bloco_comandos
        ;

repeticao: TK_PR_WHILE '(' expressao ')' bloco_comandos
         ;

retorno: TK_PR_RETURN expressao ';'
       ;

bloco_comandos: '{' comandos '}' {
                    $$ = $2->proximo; 
                    free($2);
               }
              | '{' '}' {
                    $$ = novoNo(TIPO_CABECA_LISTA, NULL);
              }
              ;

chamada_funcao_init: TK_IDENTIFICADOR '(' argumentos ')' ';'
chamada_funcao: TK_IDENTIFICADOR '(' argumentos ')' 
             ;

argumentos: 
          | expressao
          | argumentos ',' expressao
          ;

expressao: prec7;

prec7: prec6 
     | prec7 TK_OC_OR prec6;

prec6: prec5
     | prec6 TK_OC_AND prec5;

prec5: prec4
     | prec5 TK_OC_EQ prec4
     | prec5 TK_OC_NE prec4;

prec4: prec3
     | prec4 TK_OC_LE prec3
     | prec4 TK_OC_GE prec3
     | prec4 '<' prec3
     | prec4 '>' prec3;

prec3: prec2
     | prec3 '+' prec2
     | prec3 '-' prec2;

prec2: prec1
     | prec2 '*' prec1
     | prec2 '/' prec1
     | prec2 '%' prec1;
     
prec1: '-' prec1 
     | '!' prec1
     | primario;
     
primario: '(' expressao ')'
        | TK_IDENTIFICADOR
        | literais
        | chamada_funcao
        ;

literais: TK_LIT_INT   {$$ = novoNo(TIPO_LITERAL, $1);}
        | TK_LIT_FLOAT {$$ = novoNo(TIPO_LITERAL, $1);}
        | TK_LIT_TRUE  {$$ = novoNo(TIPO_LITERAL, $1);}
        | TK_LIT_FALSE {$$ = novoNo(TIPO_LITERAL, $1);}

%%
