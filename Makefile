all: project

y.tab.c y.tab.h: bison.y
	bison -d -y bison.y

lex.yy.c: flex.l y.tab.h
	flex flex.l

project: lex.yy.c y.tab.c y.tab.h
	gcc y.tab.c lex.yy.c

clean:
	rm a.out y.tab.c lex.yy.c y.tab.h