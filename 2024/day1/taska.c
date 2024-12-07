#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#define INPUTSIZE 1000
#define SPACE 32
#define LF 10
#define CR 12

typedef struct {
    int left_list[INPUTSIZE];
    int right_list[INPUTSIZE];
} ParsedList;
int listsize = 0;
typedef enum { left, right } ListTurn;

// Read input file and parse to lists
void read_input(ParsedList *list, const char *file_path) {
    FILE *file;
    file = fopen(file_path, "r");
    if (file == NULL) {
        perror("Error opening file");
        exit(EXIT_FAILURE);
    }
    ListTurn turn = left;
    int byte;
    char str_buf[20];
    int str_buf_index = 0;
    while ((byte = fgetc(file)) != EOF) {
        if (byte != SPACE && byte != LF && byte != CR) {
            str_buf[str_buf_index++] = byte;

        } else if ((byte == SPACE || byte == LF || byte == CR) &&
                   str_buf[0] != '\0') {
            str_buf[str_buf_index] = '\0';
            if (turn == left) {
                list->left_list[listsize] = atoi(str_buf);
                turn = right;
            } else {
                list->right_list[listsize++] = atoi(str_buf);
                turn = left;
            }
            str_buf[0] = '\0';
            str_buf_index = 0;
        }
    }
    fclose(file);
}

// Simple linear sort
void sort(int *list_ptr) {
    for (int i = 0; i < listsize - 1; i++) {
        for (int j = i + 1; j < listsize; j++)
            if (list_ptr[i] > list_ptr[j]) {
                int temp = list_ptr[i];
                list_ptr[i] = list_ptr[j];
                list_ptr[j] = temp;
            }
    }
}

// sort both left and right list
void sort_lists(ParsedList *list) {
    sort(list->left_list);
    sort(list->right_list);
}

int count_pairs_a(ParsedList *list) {
    int total_dist = 0;
    for (int i = 0; i < listsize; i++) {
        total_dist += abs(list->left_list[i] - list->right_list[i]);
    }
    return total_dist;
}

int count_occurences(int val, int *list) {
    int i = 0;
    while (val < list[i]) {
        i++;
    }
    while (val > list[i]) {
        i++;
    }
    int count = 0;
    while (list[i] == val) {
        count++;
        i++;
    }
    return count;
}

int count_pairs_b(ParsedList *list) {
    int total_dist = 0;
    for (int i = 0; i < listsize; i++) {
        int left_val = list->left_list[i];
        int count = count_occurences(left_val, list->right_list);
        total_dist += (left_val * count);
    }
    return total_dist;
}

// helper function to print arrays
void print_list(ParsedList *list) {
    for (int i = 0; i < listsize; i++) {
        printf("left:%-10dright:%d\n", list->left_list[i], list->right_list[i]);
    }
}
int main() {
    char filepath[] = "input.txt";
    ParsedList list;
    read_input(&list, filepath);
    sort_lists(&list);
    // print_list(&list);
    int total = count_pairs_b(&list);
    printf("Total:\n%d\n", total);
    return 0;
}