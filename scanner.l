%{
    /*
    Integrantes do grupo V
    - Bruno Marques Bastos (314518)
    - Gustavo Lopes Noll (322864)
    */
    #include<stdio.h>
    #include<string.h>
    #include "ast.h"
    #include "parser.tab.h"
    #include "valor_lexico.h"
    #include "functions.h"
    #define YYSTYPE valorLexico
%}

%option noyywrap

identificador [a-z_][a-z_0-9]*

literal_inteiro [0-9]+
literal_float [0-9]*\.[0-9]+

%x comentario


%%

"int" {yylval.v_lexico = define_yyval(yytext, TYPE, NAO_LITERAL, get_line_number()); return TK_PR_INT;}
"float" {yylval.v_lexico = define_yyval(yytext, TYPE, NAO_LITERAL, get_line_number()); return TK_PR_FLOAT;}
"bool" {yylval.v_lexico = define_yyval(yytext, TYPE, NAO_LITERAL, get_line_number()); return TK_PR_BOOL;}
"if" {yylval.v_lexico = define_yyval(yytext, CONTROL, NAO_LITERAL, get_line_number());return TK_PR_IF;}
"else" {yylval.v_lexico = define_yyval(yytext, CONTROL, NAO_LITERAL, get_line_number());return TK_PR_ELSE;}
"while" {yylval.v_lexico = define_yyval(yytext, CONTROL, NAO_LITERAL, get_line_number());return TK_PR_WHILE;}
"return" {yylval.v_lexico = define_yyval(yytext, CONTROL, NAO_LITERAL, get_line_number());return TK_PR_RETURN;}


">=" { yylval.v_lexico = define_yyval(yytext, OPERADOR_LOGICO, NAO_LITERAL, get_line_number()); return TK_OC_GE;}
"<=" { yylval.v_lexico = define_yyval(yytext, OPERADOR_LOGICO, NAO_LITERAL, get_line_number()); return TK_OC_LE;}
"==" { yylval.v_lexico = define_yyval(yytext, OPERADOR_LOGICO, NAO_LITERAL, get_line_number()); return TK_OC_EQ;}
"!=" { yylval.v_lexico = define_yyval(yytext, OPERADOR_LOGICO, NAO_LITERAL, get_line_number()); return TK_OC_NE;}
"&" { yylval.v_lexico = define_yyval(yytext, OPERADOR_LOGICO, NAO_LITERAL, get_line_number()); return TK_OC_AND;}
"|" { yylval.v_lexico = define_yyval(yytext, OPERADOR_LOGICO, NAO_LITERAL, get_line_number()); return TK_OC_OR;}
"<"  { yylval.v_lexico = define_yyval(yytext, OPERADOR_LOGICO, NAO_LITERAL, get_line_number()); return (int) '<'; }
">"  { yylval.v_lexico = define_yyval(yytext, OPERADOR_LOGICO, NAO_LITERAL, get_line_number()); return (int) '>'; }

"-"  { yylval.v_lexico = define_yyval(yytext, OPERADOR_ARITMETICO_UNARIO, NAO_LITERAL, get_line_number()); return (int) '-'; }
"!"  { yylval.v_lexico = define_yyval(yytext, OPERADOR_ARITMETICO_UNARIO, NAO_LITERAL, get_line_number()); return (int) '!'; }
"*" { yylval.v_lexico = define_yyval(yytext, OPERADOR_ARITMETICO_BINARIO, NAO_LITERAL, get_line_number()); return (int) '*'; }
"/"  { yylval.v_lexico = define_yyval(yytext, OPERADOR_ARITMETICO_BINARIO, NAO_LITERAL, get_line_number()); return (int) '/'; }
"%"  { yylval.v_lexico = define_yyval(yytext, OPERADOR_ARITMETICO_BINARIO, NAO_LITERAL, get_line_number()); return (int) '%'; }
"+" { yylval.v_lexico = define_yyval(yytext, OPERADOR_ARITMETICO_BINARIO, NAO_LITERAL, get_line_number()); return (int) '+'; }
"{" { yylval.v_lexico = define_yyval(yytext, CARACTERE_ESPECIAL, NAO_LITERAL, get_line_number()); return (int) '{'; }
"}" { yylval.v_lexico = define_yyval(yytext, CARACTERE_ESPECIAL, NAO_LITERAL, get_line_number()); return (int) '}'; }
"(" { yylval.v_lexico = define_yyval(yytext, CARACTERE_ESPECIAL, NAO_LITERAL, get_line_number()); return (int) '('; }
")" { yylval.v_lexico = define_yyval(yytext, CARACTERE_ESPECIAL, NAO_LITERAL, get_line_number()); return (int) ')'; }
"=" { yylval.v_lexico = define_yyval(yytext, CARACTERE_ESPECIAL, NAO_LITERAL, get_line_number()); return (int) '='; }
","  { yylval.v_lexico = define_yyval(yytext, CARACTERE_ESPECIAL, NAO_LITERAL, get_line_number()); return (int) ','; }
";"  { yylval.v_lexico = define_yyval(yytext, CARACTERE_ESPECIAL, NAO_LITERAL, get_line_number()); return (int) ';'; }


true { yylval.v_lexico = define_yyval(yytext, LITERAL, BOOL, get_line_number()); return TK_LIT_TRUE;}
false { yylval.v_lexico = define_yyval(yytext, LITERAL, BOOL, get_line_number()); return TK_LIT_FALSE;}

{identificador} { yylval.v_lexico = define_yyval(yytext, IDENTIFICADOR, NAO_LITERAL, get_line_number()); return TK_IDENTIFICADOR;}
{literal_float} { yylval.v_lexico = define_yyval(yytext, LITERAL, FLOAT, get_line_number()); return TK_LIT_FLOAT;}
{literal_inteiro} { yylval.v_lexico = define_yyval(yytext, LITERAL, INTEIRO, get_line_number());  return TK_LIT_INT;}

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
