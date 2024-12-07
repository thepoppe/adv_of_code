#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define INPUTSIZE 6
#define STR_LEN 25
#define SPACE 32
#define LF 10
#define CR 12

void read_input(const char *file_path, char **list) {
    FILE *file;
    file = fopen(file_path, "r");
    if (file == NULL) {
        perror("Error opening file");
        exit(EXIT_FAILURE);
    }
    int byte;
    char str_buf[STR_LEN];
    int str_buf_index = 0;
    int i = 0;
    while ((byte = fgetc(file)) != EOF) {
        if (byte == LF) {
            if (i < INPUTSIZE) {
                strncpy(list[i], str_buf, str_buf_index);
                list[i++][str_buf_index] = '\0';
                str_buf_index = 0;
                str_buf[str_buf_index] = '\0';
            } else {
                fprintf(stderr, "Error: Input exceeds maximum allowed size.\n");
                fclose(file);
                exit(EXIT_FAILURE);
            }
        } else if (byte != CR && byte != LF && str_buf_index < STR_LEN - 1) {
            str_buf[str_buf_index++] = byte;
        }
    }
    fclose(file);
}

char **initialize_mem() {
    char **strings_ptr = (char **)malloc(INPUTSIZE * sizeof(char *));
    if (strings_ptr == NULL) {
        perror("Memory allocation failed");
        exit(EXIT_FAILURE);
    }

    for (int i = 0; i < INPUTSIZE; i++) {
        strings_ptr[i] = (char *)malloc(STR_LEN * sizeof(char));
        if (strings_ptr[i] == NULL) {
            perror("Memory allocation failed for a string");
            exit(EXIT_FAILURE);
        }
    }
    return strings_ptr;
}

void free_mem(char **list) {
    for (int i = 0; i < INPUTSIZE; i++) {
        free(list[i]);
        list[i] = NULL;
    }
    free(list);
}

void print_list(char **list) {
    for (int i = 0; i < INPUTSIZE; i++) {
        if (list[i] != NULL && list[i][0] != '\0') {
            printf("%s\n", list[i]);
        } else {
            break;
        }
    }
}

int main() {
    char path[] = "example.txt";
    char **strings_ptr = initialize_mem();
    read_input(path, strings_ptr);
    print_list(strings_ptr);

    free_mem(strings_ptr);
    strings_ptr = NULL;
}