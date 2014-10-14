// Solution for http://haskell98.blogspot.ru/2014/10/blog-post_10.html

#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>


typedef unsigned long long int bigint;

static int mask(int n, int i, int j) {
    if (i < n && j < n) {
        return 0;
    } else if (i < n && j >= n) {
        return 1;
    } else if (i >= n && j < n) {
        return 2;
    } else {
        return 3;
    }
}

static int shift(int n, int i, int j) {
    int ii, jj;
    if (i < n && j < n) {
        ii = i;
        jj = j;
    } else if (i < n && j >= n) {
        ii = (2*n - j - 1);
        jj = i;
    } else if (i >= n && j < n) {
        ii = j;
        jj = (2*n - i - 1);
    } else {
        ii = (2*n - i - 1);
        jj = (2*n - j - 1);
    }
    return 2 * (ii*n + jj - 1);
}

static bool is_a_hole(int n, int i, int j, bigint x) {
    if ((i == 0 || i == 2*n - 1) && (j == 0 || j == 2*n - 1)) {
        // hole is in the left top corner
        return i == 0 && j == 0;
    } else {
        int check = mask(n, i, j);
        x >>= shift(n, i, j);
        x &= 3;
        return x == check;
    }
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <n>\n", argv[0]);
        return 1;
    }

    int n = atoi(argv[1]) / 2;

    bigint count = 1;
    count <<= 2 * (n*n - 1);

    // printf("Number of variants: %lli\n", count);

    for (bigint x = 0; x < count; x++) {
        for (int i = 0; i < 2*n; ++i) {
            for (int j = 0; j < 2*n; ++j) {
                putchar(is_a_hole(n, i, j, x) ? 'O' : '_');
                putchar(' ');
            }
            putchar('\n');
        }
        putchar('\n');
    }

    return 0;
}
