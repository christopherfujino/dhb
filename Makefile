CC = clang
CXX_FLAGS = -g
LD_LIBS = -lreadline -ltinfo
LD_FLAGS = -static -static-libgcc -static-libstdc++
LEX = flex
YACC = bison

.PHONY: run
run: a.out
	./$<

a.out: parser.tab.c parser.tab.h scanner.yy.c
	$(CC) scanner.yy.c parser.tab.c -lreadline -lm -o $@
	#$(CXX) $(LD_LIBS) -static scanner.yy.cpp parser.tab.cpp -o $@

#a.out: main.o
#	$(CXX) $(LD_FLAGS) $< $(LD_LIBS) -o $@

main.o: main.cpp
	$(CC) $(CXX_FLAGS) -c $< -o $@

scanner.yy.c: scanner.lex
	$(LEX) -o $@ $<

# -d means generate header file
parser.tab.c: parser.y
	$(YACC) -d $< -o $@

.PHONY: clean
clean:
	rm -f a.out *.o *.tab.c *.yy.c *.tab.h
