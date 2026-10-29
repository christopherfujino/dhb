CC = bear --append -- clang
LDFLAGS = -lreadline -ltinfo -lm
LEX = flex
YACC = bison
CFLAGS = -g -O0 -std=gnu23 -Wall -Wextra -Wpedantic

a.out: parser.tab.o scanner.yy.o main.o
	$(CC) $(LDFLAGS) $^ -o $@

.PHONY: run
run: a.out
	./$<

scanner.yy.c: scanner.lex
	$(LEX) -o $@ $<

# -d means generate header file
parser.tab.c: parser.y
	$(YACC) -d $< -o $@

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

.PHONY: clean
clean:
	rm -f a.out *.o *.tab.c *.yy.c *.tab.h compile_commands.json
