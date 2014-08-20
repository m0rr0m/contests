/*
 * made by Silent
 * silentfl@mail.ru
 * 2014.08.20
 */
#include <stdio.h>
#include <string.h>
#include <malloc.h>

int T[10] = {
  0b111101101101111,
  0b110010010010111,
  0b111001111100111,
  0b111001111001111,
  0b101101111001001,
  0b111100111001111,
  0b111100111101111,
  0b111001011010010,
  0b111101111101111,
  0b111101111001111
};

char c = 0;
int hash = 0;
int *line;
char *data;
int i, j, k, count;

int main(int argc, char * argv[]) {

  char *filename = argv[1];
  size_t height = atoi(argv[2]);
  size_t width = atoi(argv[3]);

  line = malloc(width * sizeof(int));
  data = malloc((width + 2) * sizeof(int));

  FILE * f = fopen(filename, "r");
  for (i = 0; i < height; i++) {
    hash = 0;
    getline(&data, &count, f);
    for (j = 0; j < width; j++) {
      hash = ((hash << 1) | (data[j] - '0')) & 0b111;
      line[j] = ((line[j] << 3) | hash) & 0b111111111111111;
      for (k = 0; k < 10; k++) 
        if (line[j] == T[k])
          printf("Digit %zu on (%zu, %zu)\n", k, i-4, j-2);
    }
  }
  fclose(f);
  return 0;
}
