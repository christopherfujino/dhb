CC = clang
LD_LIBS = -lreadline -ltinfo -lm
LEX = flex
YACC = bison

.PHONY: run
run: a.out
	./$<

a.out: parser.tab.c parser.tab.h scanner.yy.c
	$(CC) -g $(LD_LIBS) scanner.yy.c parser.tab.c -o $@

scanner.yy.c: scanner.lex
	$(LEX) -o $@ $<

# -d means generate header file
parser.tab.c: parser.y
	$(YACC) -d $< -o $@

.PHONY: clean
clean:
	rm -f a.out *.o *.tab.c *.yy.c *.tab.h
