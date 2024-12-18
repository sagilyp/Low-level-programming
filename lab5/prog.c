#include <stdlib.h>
#include <stdio.h>
#include "prog.h"

unsigned char matrix[5][5] = {{1, 4, 6, 4, 1}, {4, 16, 24, 16, 4}, {6, 24, 36, 24, 6}, {4, 16, 24, 16, 4}, {1, 4, 6, 4, 1}};


void blur(unsigned char* str, int width, int height, int channels, unsigned char* res) {
    for (int i = 0; i < height; ++i) {
        for (int j = 0; j < width; ++j) {
            if (i == 0 || j == 0 || i == height - 1 || j == width - 1) {
                for (int c = 0; c < channels; ++c) {
                    *res = *str;
                    ++str;
                    ++res;
                }
                continue;
            }
            int x = 0;
            for (int c = 0; c < channels; ++c) {
                for (int k = -2; k <= 2; ++k) {
                    for (int l = -2; l <= 2; ++l) {
                        if (i + k >= 0 && i + k < height && j + l >= 0 && j + l < width) {
                            x += *(str + k * width * channels + l * channels) * matrix[k + 2][l + 2];
                        }
                    }
                }
                x /= 256;
                *res = x;
                ++str;
                ++res;
            }
        }
    }
    return;
}




