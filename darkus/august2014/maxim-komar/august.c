#include <stdio.h>
#include <string.h>
#include <malloc.h>

// gcc -O2 august.c -o august
// ./august filename height width

#define DH 5
#define DW 3

char digit[10][DH][DW] = {
    {
        {'1', '1', '1'},
        {'1', '0', '1'},
        {'1', '0', '1'},
        {'1', '0', '1'},
        {'1', '1', '1'}
    },
    {
        {'1', '1', '0'},
        {'0', '1', '0'},
        {'0', '1', '0'},
        {'0', '1', '0'},
        {'1', '1', '1'}
    },
    {
        {'1', '1', '1'},
        {'0', '0', '1'},
        {'1', '1', '1'},
        {'1', '0', '0'},
        {'1', '1', '1'}
    },
    {
        {'1', '1', '1'},
        {'0', '0', '1'},
        {'1', '1', '1'},
        {'0', '0', '1'},
        {'1', '1', '1'}
    },
    {
        {'1', '0', '1'},
        {'1', '0', '1'},
        {'1', '1', '1'},
        {'0', '0', '1'},
        {'0', '0', '1'}
    },
    {
        {'1', '1', '1'},
        {'1', '0', '0'},
        {'1', '1', '1'},
        {'0', '0', '1'},
        {'1', '1', '1'}
    },
    {
        {'1', '1', '1'},
        {'1', '0', '0'},
        {'1', '1', '1'},
        {'1', '0', '1'},
        {'1', '1', '1'}
    },
    {
        {'1', '1', '1'},
        {'0', '0', '1'},
        {'0', '1', '1'},
        {'0', '1', '0'},
        {'0', '1', '0'},
    },
    {
        {'1', '1', '1'},
        {'1', '0', '1'},
        {'1', '1', '1'},
        {'1', '0', '1'},
        {'1', '1', '1'}
    },
    {
        {'1', '1', '1'},
        {'1', '0', '1'},
        {'1', '1', '1'},
        {'0', '0', '1'},
        {'1', '1', '1'}
    }
};

int main(int argc, char *argv[]){
    size_t i, j, m, n, count;

    char *filename = argv[1];
    size_t height = atoi(argv[2]);
    size_t width = atoi(argv[3]);

    // memory allocation
    char *line = malloc((width + 2) * sizeof(char));
    char **data = malloc(height * sizeof(char *));
    for(i = 0; i < height; i++){
        data[i] = malloc(width * sizeof(char));
        memset(data[i], '-', width * sizeof(char));
    }

    // read data from file
    FILE *fh = fopen(filename, "r");
    for(i = 0; i < height; i++){
        getline(&line, &count, fh);
        for(j = 0; j < width; j++){
            data[i][j] = line[j];
        }
    }
    fclose(fh);

    char cur[DH][DW];
    for(i = 0; i < height - DH + 1; i++){
        for(j = 0; j < width - DW + 1; j++){
            // copy
            for(m = 0; m < DH; m++){
                for(n = 0; n < DW; n++){
                    cur[m][n] = data[i+m][j+n];
                }
            }
            
            for(m = 0; m < 10; m++){
                if(compare(cur, digit[m]) == 0){
                    printf("Digit %zu on (%zu, %zu)\n", m, i, j);
                }
            }
        }
    }

    return 0;    
}

int compare(char a[DH][DW], char b[DH][DW]){
    size_t i, j;
    for(i = 0; i < DH; i++){
        for(j = 0; j < DW; j++){
            if(a[i][j] != b[i][j]){
                return 1;
            }
        }
    }
    return 0;
}
