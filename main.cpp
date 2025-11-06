#include <cstdlib>
#include <cstring>
#include <readline/readline.h>
#include <stdio.h>
#include <readline/history.h>

enum class Type {
  dec,
  hex,
  asc,
};

const size_t MAX_LENGTH = 128;

int parse(char *string) {
  const size_t len = strlen(string);
  if (len == 0) {
    fprintf(stderr, "Invalid input\n");
  } else if (len >= MAX_LENGTH) {
    fprintf(stderr, "Input too long: \"%s\"\n", string);
  } else if (string[0] == '0' && string[1] == 'x') {
    // TODO validate it's all hex
    return strtol(string, nullptr, 0);
  } else if (string[0] == '0' && string[1] == 'b') {
    char sub[MAX_LENGTH - 2];
    strncpy(sub, string, MAX_LENGTH - 2);
    return strtol(string, nullptr, 2);
  } else if (string[0] >= '0' && string[0] <= '9') {
    return atoi(string);
  } else {
    fprintf(stderr, "Unknown input format: \"%s\"\n", string);
  }

  return -1;
}

void print(int i) {
  printf("%d\t0x%X\t0b%b\n", i, i, i);
}

int main() {
  char *line = nullptr;
  int v;

  while (1) {
    line = readline("> ");

    if (line == nullptr) {
      break;
    }

    v = parse(line);
    add_history(line);

    if (v == -1) {
      continue;
    }

    print(v);
  }
  return 0;
}
