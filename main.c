/*
 * Integrantes do Grupo V
 * - Bruno Marques Bastos (314518)
 * - Gustavo Lopes Noll (322864)
*/

#include <stdio.h>
extern int yyparse(void);
extern int yylex_destroy(void);
void *arvore = NULL;
void exporta (void *arvore);
int main (int argc, char **argv)
{
  int ret = yyparse(); 
  exporta (arvore);
  yylex_destroy();
  return ret;
}