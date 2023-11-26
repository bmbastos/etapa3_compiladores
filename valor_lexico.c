#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include "valor_lexico.h"

valorLexico define_yyval(char* yytext, Tipo tipo, TipoLiteral tipo_literal, int num_lines) 
{  
      valorLexico valor_lexico;
      valor_lexico.linha=num_lines;
      valor_lexico.tipo=tipo;
      valor_lexico.tipo_literal=tipo_literal;
      valor_lexico.label = strdup(yytext);

      switch(tipo_literal) {
         case BOOL:
            valor_lexico.valor.valor_bool = (strncmp (yytext,"true",4) == 0);
            break;
         case FLOAT:
            valor_lexico.valor.valor_float=atof(yytext);
            break;
         case INTEIRO:
            valor_lexico.valor.valor_int=atoi(yytext);
            break;
         case NAO_LITERAL:
            break;
      }

      return valor_lexico;
}

void libera_vl(valorLexico valor_lexico)
{
    if(valor_lexico.label != NULL)
        free(valor_lexico.label);
    return;
}