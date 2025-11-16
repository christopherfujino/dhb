CXX_FLAGS = -g
LD_LIBS = -lreadline -ltinfo
LD_FLAGS = -static -static-libgcc -static-libstdc++
LEX = flex
YACC = bison

.PHONY: run
run: a.out
	./$<

a.out: parser.tab.cpp parser.tab.hpp scanner.yy.cpp
	$(CXX) scanner.yy.cpp parser.tab.cpp -lreadline -o $@
	#$(CXX) $(LD_LIBS) -static scanner.yy.cpp parser.tab.cpp -o $@

#a.out: main.o
#	$(CXX) $(LD_FLAGS) $< $(LD_LIBS) -o $@

main.o: main.cpp
	$(CXX) $(CXX_FLAGS) -c $< -o $@

scanner.yy.cpp: scanner.lex
	$(LEX) -o $@ $<

# -d means generate header file
parser.tab.cpp: parser.y
	$(YACC) -d $< -o $@

.PHONY: clean
clean:
	rm -f a.out *.o *.tab.cpp *.tab.hpp
