#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define INPUTSIZE 1000
#define STR_LEN 50
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
    printf("TOTAL ROWS READ: %d\n", i);
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
typedef enum { UNKNOWN, ASC, DESC } NumericalSequence;
char *enum_toString(NumericalSequence *s) {
    if (*s == UNKNOWN) {
        return "UNK";
    } else if (*s == ASC) {
        return "ASC";
    } else {
        return "DESC";
    }
}

int validate_move(int curr, int next, NumericalSequence *seq) {
    if (curr == next || abs(curr - next) > 3) {
        return -1;
    }

    if (*seq == UNKNOWN) {

        if (curr < next) {
            *seq = ASC;
        } else {
            *seq = DESC;
        }
        return 0;

    } else if (*seq == ASC && curr < next) {
        return 0;
    } else if (*seq == DESC && curr > next) {
        return 0;
    } else {
        return -1;
    }
}
void extract_numbers(char *row, int *numbers) {
    char str_buf[5];
    int i = 0;
    int j = 0;
    while (1) {
        if (*row == '\0') {
            str_buf[i] = '\0';
            numbers[j] = atoi(str_buf);
            return;
        }
        if (*row != SPACE) {
            str_buf[i++] = *row;
        }
        if (*row == SPACE && str_buf[0] != '\0') {
            str_buf[i] = '\0';
            numbers[j++] = atoi(str_buf);
            i = 0;
            str_buf[i] = '\0';
        }
        row++;
    }
}

int compare_stringrow(char *row) {
    int numbers[8];
    for (int i = 0; i < 8; i++) {
        numbers[i] = -1;
    }
    extract_numbers(row, numbers);
    int i = 0;
    int next;
    NumericalSequence seq = UNKNOWN;
    do {
        int current = numbers[i];
        int next = numbers[++i];

        if (validate_move(current, next, &seq) != 0) {
            return -1;
        }

    } while (i < 8 - 1 && numbers[i + 1] != -1);

    return 0;
}

void evaluate_list(char **list) {
    int valid_combinations = 0;
    for (int i = 0; i < INPUTSIZE; i++) {
        if (list[i] == NULL) {
            break;
        }
        if (compare_stringrow(list[i]) == 0) {
            valid_combinations++;
        }
    }
    printf("Valid Combinations:\n%d\n", valid_combinations);
}

int main() {
    char path[] = "input.txt";
    char **strings_ptr = initialize_mem();
    read_input(path, strings_ptr);
    // print_list(strings_ptr);
    evaluate_list(strings_ptr);
    free_mem(strings_ptr);
    strings_ptr = NULL;
}