/*
 * Integrantes do Grupo V
 * - Bruno Marques Bastos (314518)
 * - Gustavo Lopes Noll (322864)
*/

#ifndef AST_H
#define AST_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "estruturas.h"

#define TIPO_CABECA_LISTA 0
#define TIPO_LITERAL 1
#define TIPO_IDENTIFICADOR 2
#define TIPO_ATRIBUICAO 3

typedef struct nodo{
  int valor;
  valor_lexico* vl;
  struct nodo* filho;
  struct nodo* proximo;
  struct nodo* irmao;
} nodo;

nodo* novoNo(int tipo, valor_lexico* vl);
void adicionarFilho(nodo* pai, nodo* filho);
void adicionarProximo(nodo* atual, nodo* proximo);
void adicionarIrmao(nodo* atual, nodo* irmao);
nodo* novaFuncao(valor_lexico* vl);
nodo* comandoAtribuicao(nodo* identificador, nodo* valor);

#endif
