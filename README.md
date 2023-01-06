## Compiler Design course project

Compile using the Makefile:

```
make
```

or manually on Linux, follow this steps:

```
bison -d -y bison.y
flex flex.l
gcc y.tab.c lex.yy.c
./a.out
```

Sample inputs are in `inputs` folder.
