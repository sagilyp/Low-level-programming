#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <time.h>
#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"
#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image_write.h"
#include "prog.h"



int main(int argc, char **argv){
    if (argc != 3) {
        printf("Wrong usage.\nRun %s src.bmp dst.bmp\n", argv[0]);
        return 1;
    }
    unsigned char *str;
    if (!(str = strstr(argv[1], ".bmp")) || *(str + 4) != '\0') {
        printf("Wrong format of input image.\nThe format is required .bmp\n");
        return 2;
    }
    if (!(str = strstr(argv[2], ".bmp")) || *(str + 4) != '\0') {
        printf("Wrong format of output image.\nThe format is required .bmp\n");
        return 2;
    }
    if (!strcmp(argv[1], argv[2])) {
        printf("Input file name equal output name.\nUse different name.\n");
        return 2;
    }
    if (access(argv[1], F_OK)) {
        printf("Input file dont exists.\nInput correct name.\n");
        return 3;
    }
    if (access(argv[2], F_OK) == 0) {
        printf("Output file exists.\nInput another name.\n");
        return 3;
    }
    int height = 0, width = 0, channels = 0;
    str = stbi_load(argv[1], &width, &height, &channels, 0);
    if (str == NULL) {
        printf("Error with openning image.\n");
        return 4;
    }
    //printf("Loaded image with a width of %dpx, a height of %dpx and %d channels\n", width, height, channels);
    //stbi_write_bmp("out.bmp", width, height, channels, str);
    struct timespec t, t1, t2;
    unsigned char* n = calloc(width * height * channels, 1);
    if (!n) {
        printf("Error with memory.\n");
        stbi_image_free(str);
        return 5;
    }
    unsigned char* nas = calloc(width * height * channels, 1);
    if (!nas) {
        printf("Error with memory.\n");
        stbi_image_free(str);
        free(n);
        return 5;
    }
    clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &t1);
    blur(str, width, height, channels, n);
    clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &t2);
    t.tv_sec = t2.tv_sec - t1.tv_sec;
    if ((t.tv_nsec = t2.tv_nsec - t1.tv_nsec) < 0) {
        t.tv_sec--;
        t.tv_nsec += 1000000000;
    }
    printf("%ld.%09ld ", t.tv_sec, t.tv_nsec);
    clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &t1);
    blurasm(str, width, height, channels, nas);
    clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &t2);
    if (strcmp(n, nas)) {
        printf("Error - image difference\n");
    } else {
        stbi_write_bmp(argv[2], width, height, channels, nas);
        t.tv_sec = t2.tv_sec - t1.tv_sec;
        if ((t.tv_nsec = t2.tv_nsec - t1.tv_nsec) < 0) {
            t.tv_sec--;
            t.tv_nsec += 1000000000;
        }
        printf("%ld.%09ld\n", t.tv_sec, t.tv_nsec);
    }
    stbi_image_free(str);
    stbi_image_free(n);
    stbi_image_free(nas);
    return 0;
}
