/*
 * Integrantes do Grupo V
 * - Bruno Marques Bastos (314518)
 * - Gustavo Lopes Noll (322864)
*/
#pragma once
typedef enum tipo
{
    CARACTERE_ESPECIAL,
    OPERADOR_LOGICO,
    OPERADOR_ARITMETICO_UNARIO,
    OPERADOR_ARITMETICO_BINARIO,
    IDENTIFICADOR,
    LITERAL,
    FUNCAO,
    OUTRO
} Tipo;

typedef enum tipoLiteral
{
    INTEIRO,
    FLOAT,
    BOOL,
    NAO_LITERAL
} TipoLiteral;

typedef struct valorLexico
{
    int linha;
    Tipo tipo;
    TipoLiteral tipo_literal;
    char *label;
    union valor {
        int valor_int;
        float valor_float;
        int valor_bool;
    } valor;
} valorLexico;

valorLexico define_yyval(char* yytext, Tipo tipo, TipoLiteral tipo_literal, int num_lines);
void libera_vl(valorLexico valor_lexico);
