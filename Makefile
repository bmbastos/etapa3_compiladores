# Makefile para compilar o analisador léxico

# Integrantes do grupo V:
# - Bruno Marques Bastos (314518)
# - Gustavo Lopes Noll (322864)

# Compilador a ser usado
CC = gcc

# Opções de compilação
CFLAGS = -Wall -Wextra

# Nome do executável
EXECUTABLE = etapa3

# Listagem de arquivos fonte
SOURCES = parser.y functions.c ast.c main.c

# Objetos gerados
OBJECTS = parser.tab.c lex.yy.c functions.o ast.o main.o

# Dependências para construção do executável
$(EXECUTABLE): $(OBJECTS)
	$(CC) $(CFLAGS) -o $@ $^

# Regra para construir o analisador sintático
parser.tab.c: parser.y
	bison -v -d $<

# Regra para construir o analisador léxico
lex.yy.c: scanner.l
	flex $<

# Regra genérica para compilar arquivos .c
%.o: %.c functions.h
	$(CC) $(CFLAGS) -c $<

# Alvo padrão
all: $(EXECUTABLE)

# Alvo para execução do programa
run: $(EXECUTABLE)
	./$(EXECUTABLE)

# Alvo para limpar arquivos gerados
clean:
	rm -f $(OBJECTS) $(EXECUTABLE) parser.tab.* parser.output
