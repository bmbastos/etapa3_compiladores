/*
 * Integrantes do Grupo V
 * - Bruno Marques Bastos (314518)
 * - Gustavo Lopes Noll (322864)
*/
#include "ast.h"
#include "valor_lexico.h"
#include <stdio.h>
#include <stdlib.h>

Nodo *adiciona_nodo(valorLexico valor_lexico)
{
    Nodo *nodo;
    nodo = malloc(sizeof(Nodo));

    nodo->filho = NULL;
    nodo->irmao = NULL;
    nodo->valor_lexico = valor_lexico;

    return nodo;
}

Nodo *adiciona_nodo_by_label(char *label)
{
    valorLexico valor_lexico;
    valor_lexico.linha = 0;
    valor_lexico.tipo = OUTRO;
    valor_lexico.tipo_literal = NAO_LITERAL;
    valor_lexico.label = strdup(label);

    Nodo *nodo;
    nodo = malloc(sizeof(Nodo));

    nodo->valor_lexico = valor_lexico;
    nodo->filho = NULL;
    nodo->irmao = NULL;

    return nodo;
}

Nodo *adiciona_filho(Nodo *nodo, Nodo *filho) 
{
   if(nodo!= NULL && filho!=NULL)
   {
       if(nodo->filho == NULL)
       {
           nodo->filho = filho;
       }
       else
       {
           _adiciona_ultimo_irmao(nodo->filho, filho);
       }
   }
   return nodo;
}

void imprime_arvore(Nodo *nodo, int profundidade)
{
    int i = 0;

    if (nodo == NULL)
        return;
    
    for(i = 0; i<profundidade-1; i++) 
    {
        printf("    ");
    }

    if (profundidade == 0)
        printf("%s", nodo->valor_lexico.label);
    else 
    {
        printf("+---");
        printf("%s", nodo->valor_lexico.label);
    }
    printf("\n");

    Nodo *nodo_f = nodo->filho;
    while(nodo_f!=NULL)
    {
        imprime_arvore(nodo_f, profundidade+1);
        nodo_f = nodo_f->irmao;
    }
    
    return;
}

void _adiciona_ultimo_irmao(Nodo *nodo_irmao, Nodo *novo_irmao)
{
    Nodo *aux_nodo = nodo_irmao;

    while(aux_nodo->irmao!=NULL)
    {
        aux_nodo = aux_nodo->irmao;
    }
    aux_nodo->irmao = novo_irmao;
    novo_irmao->irmao = NULL;
    return;
}


void libera(void *pai)
{
    if(pai == NULL) return;

    Nodo *pai_arvore = (Nodo*)pai;

    if (pai_arvore->filho != NULL) {
        libera(pai_arvore->filho);
    }

    if (pai_arvore->irmao != NULL) {
        libera(pai_arvore->irmao);
    }

    libera_vl(pai_arvore->valor_lexico);

    free(pai_arvore);
}

void _imprime_nodo(Nodo *nodo)
{
    if (nodo == NULL)
        return;
    printf("%p [label=\"", nodo);
    printf("%s", nodo->valor_lexico.label);
    printf("\"];\n");

    Nodo *nodo_f;
    nodo_f = nodo->filho;
    while(nodo_f!=NULL)
    {
        _imprime_nodo(nodo_f);
        nodo_f = nodo_f->irmao;
    }
    
    return;
}

void _imprime_arestas(Nodo *nodo)
{
    if (nodo == NULL)
        return;

    Nodo *nodo_f;
    nodo_f = nodo->filho;
    while(nodo_f!=NULL)
    {
        printf("%p, %p\n", nodo, nodo_f);
        _imprime_arestas(nodo_f);
        nodo_f = nodo_f->irmao;
    }
    
    return;
}

void exporta(void *arvore)
{
    if(arvore == NULL){
        printf("Árvore vazia\n");
    }
    Nodo *nodo_arvore;
    nodo_arvore = (Nodo*) arvore;
    _imprime_nodo(nodo_arvore);
    _imprime_arestas(nodo_arvore);
    imprime_arvore(nodo_arvore, 0);
    return;
}