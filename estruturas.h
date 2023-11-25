/*
 * Integrantes do Grupo V
 * - Bruno Marques Bastos (314518)
 * - Gustavo Lopes Noll (322864)
*/

#ifndef ESTRUTURAS_H
#define ESTRUTURAS_H
#define TRUE "true"
#define FALSE "false"

#define CARACTERE_ESPECIAL    0
#define OPERADOR_CONDICIONAL  1
#define IDENTIFICADOR         2
#define LIT_INTEIRO           3
#define LIT_FLUTUANTE         4
#define LIT_CARACTERE         5
#define LIT_BOOLEANO          6
#define LIT_CADEIA_CARACTERES 7

typedef union valor_token {
   int   inteiro;
   float flutuante;
   char  caractere;
   char* palavra;
} valor_token;

typedef struct valor_lexico{
    int linha;
    int tipo;
    valor_token valor;
}valor_lexico;
#endif