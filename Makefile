CXX_FLAGS = -g

.PHONY: run
run: a.out
	./$<

a.out: main.cpp
	$(CXX) $(CXX_FLAGS) $< -lreadline -o $@
