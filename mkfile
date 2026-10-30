CC = bear --append -- clang
LDFLAGS = -lreadline -ltinfo -lm
LEX = flex
YACC = bison
CSTD = -std=gnu23
CFLAGS = -g -O0 $CSTD -Wall -Wextra -Wpedantic
DEPFILES = `{/bin/sh -c 'find . -name "*.d"'}

a.out: parser.tab.o scanner.yy.o main.o
	$CC $LDFLAGS $prereq -o $target

<|cat $DEPFILES /dev/null

run:V: a.out
	./a.out

scanner.yy.c: scanner.lex
	$LEX -o $target $prereq

# -d means generate header file
parser.tab.c: parser.y
	$YACC -d $prereq -o $target

%.o: %.c
	$CC $CFLAGS \
		-MT $target -MMD -MP -MF $stem.d \
		-c $stem.c -o $target

# Disable certain flags
scanner.yy.o: scanner.yy.c
	$CC $CSTD \
		-MT $target -MMD -MP -MF scanner.yy.d \
		-c scanner.yy.c -o $target

clean:V:
	rm -f a.out *.d *.exe *.o *.tab.c *.yy.c *.tab.h compile_commands.json
