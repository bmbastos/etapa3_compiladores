/*
 * Integrantes do Grupo V
 * - Bruno Marques Bastos (314518)
 * - Gustavo Lopes Noll (322864)
*/
#include "ast.h"

nodo* novoNo(int tipo, valor_lexico* vl){
  nodo* novo =  malloc(sizeof(nodo));
  printf("No: %p\n", novo );
  novo->valor = tipo;
  novo->vl = vl;
  novo->filho = NULL;
  novo->proximo = NULL;
  novo->irmao = NULL;
  return novo;
}

void adicionarFilho(nodo* pai, nodo* filho){
  if(pai->filho == NULL){
    pai->filho = filho;
  } else {
    adicionarIrmao(pai->filho, filho);
  }
}

void adicionarProximo(nodo* atual, nodo* proximo){
  if(atual->proximo == NULL){
    atual->proximo = proximo;
  } else {
    adicionarProximo(atual->proximo, proximo);
  }
}

void adicionarIrmao(nodo* atual, nodo* irmao){
  if(atual->irmao == NULL){
    atual->irmao = irmao;
  } else {
    adicionarIrmao(atual->irmao, irmao);
  }
}

nodo* comandoAtribuicao(nodo* identificador, nodo* valor){
  nodo* noAtribuicao = novoNo(TIPO_ATRIBUICAO, NULL);
  adicionarFilho(noAtribuicao, identificador);
  adicionarFilho(noAtribuicao, valor);
  return noAtribuicao;
}