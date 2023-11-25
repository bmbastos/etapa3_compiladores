%{ 
    /*
    Integrantes do grupo V
    - Bruno Marques Bastos (314518)
    - Gustavo Lopes Noll (322864)
    */
    #include <stdlib.h>
    #include <stdio.h>
    #include "parser.tab.h"
    #include "functions.h"
    #include "estruturas.h"
    #include "ast.h"
    void preencheValorLexico(int tipo);
%}

%option noyywrap

identificador [a-z_][a-z_0-9]*

literal_inteiro [0-9]+
literal_float [0-9]*\.[0-9]+
 
%x comentario


%%

"int" {return TK_PR_INT;}
"float" {return TK_PR_FLOAT;}
"bool" {return TK_PR_BOOL;}
"if" {return TK_PR_IF;}
"else" {return TK_PR_ELSE;}
"while" {return TK_PR_WHILE;}
"return" {return TK_PR_RETURN;}

"<=" { preencheValorLexico(OPERADOR_CONDICIONAL); return TK_OC_LE; }
">=" { preencheValorLexico(OPERADOR_CONDICIONAL); return TK_OC_GE; }
"==" { preencheValorLexico(OPERADOR_CONDICIONAL); return TK_OC_EQ; }
"!=" { preencheValorLexico(OPERADOR_CONDICIONAL); return TK_OC_NE; }
"&"  { preencheValorLexico(OPERADOR_CONDICIONAL); return TK_OC_AND; }
"|"  { preencheValorLexico(OPERADOR_CONDICIONAL); return TK_OC_OR; }

"-"  { return (int) '-'; }
"!"  { return (int) '!'; }
"*" { return (int) '*'; }
"/"  { return (int) '/'; }
"%"  { return (int) '%'; }
"+" { return (int) '+'; }
"<"  { return (int) '<'; }
">"  { return (int) '>'; }
"{" { return (int) '{'; }
"}" { return (int) '}'; }
"(" { return (int) '('; }
")" { return (int) ')'; }
"=" { return (int) '='; }
","  { return (int) ','; }
";"  { return (int) ';'; }


true { preencheValorLexico(LIT_BOOLEANO); return TK_LIT_TRUE;}
false { preencheValorLexico(LIT_BOOLEANO); return TK_LIT_FALSE;}


{identificador} { preencheValorLexico(IDENTIFICADOR); return TK_IDENTIFICADOR; }
{literal_inteiro} { preencheValorLexico(LIT_INTEIRO); return TK_LIT_INT; }


{literal_float} { preencheValorLexico(LIT_FLUTUANTE); return TK_LIT_FLOAT;}

\n  { increment_line_number(); }

"//".* {
  /* Ignoracomentário de linha */
}

"/*" {
    BEGIN(comentario);
}
<comentario>
{
    "*/" {BEGIN(INITIAL);}
    \n {increment_line_number();}
    . {} /* Ignora comentário de bloco */
}
[ \t\r\n] { } // Ignorar espaços e tabulações
. {return TK_ERRO;}
%%

void preencheValorLexico(int tipo)
{
    yylval.v_lexico = malloc(sizeof(valor_lexico));
    yylval.v_lexico->linha = get_line_number();

    switch(tipo)
    {
        case LIT_INTEIRO:
            yylval.v_lexico->tipo = LIT_INTEIRO;
            yylval.v_lexico->valor.inteiro = atoi(yytext);
            break;
        case LIT_FLUTUANTE:
            yylval.v_lexico->tipo = LIT_FLUTUANTE;
            yylval.v_lexico->valor.flutuante = atof(yytext);
            break;
        case LIT_BOOLEANO:
            yylval.v_lexico->tipo = LIT_BOOLEANO;
            yylval.v_lexico->valor.palavra = strdup(yytext);
            break;
        case IDENTIFICADOR:
            yylval.v_lexico->tipo = IDENTIFICADOR;
            yylval.v_lexico->valor.palavra = strdup(yytext);
            break;
        case OPERADOR_CONDICIONAL:
            yylval.v_lexico->tipo = OPERADOR_CONDICIONAL;
            yylval.v_lexico->valor.palavra = strdup(yytext);
            break;
        default:
            free(yylval.v_lexico);
            break;
    }
}