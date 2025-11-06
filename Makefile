CXX_FLAGS = -g
LD_LIBS = -lreadline -ltinfo
LD_FLAGS = -static -static-libgcc -static-libstdc++

.PHONY: run
run: a.out
	./$<

a.out: main.o
	$(CXX) $(LD_FLAGS) $< $(LD_LIBS) -o $@

main.o: main.cpp
	$(CXX) $(CXX_FLAGS) -c $< -o $@

.PHONY: clean
clean:
	rm -f a.out *.o
