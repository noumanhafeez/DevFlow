all: dsl_runner

dsl_runner: lexer.l parser.y main.c
	bison -d parser.y
	flex lexer.l
	gcc -o dsl_runner lex.yy.c parser.tab.c main.c

clean:
	rm -f dsl_runner lex.yy.c parser.tab.c parser.tab.h

bundle:
	echo "Bundling..."
