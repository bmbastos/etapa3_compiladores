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

typedef struct nodo{
  int valor_gramatical;
  valor_lexico* vl;
  struct nodo* filho;
  struct nodo* proximo;
  struct nodo* irmao;
} nodo;


#endif
