
#include <stdio.h>
#include <stdlib.h>

#define ascii_m 109
#define ascii_u 117
#define ascii_l 108
#define ascii_leftpar 40
#define ascii_rightpar 41
#define ascii_comma 44
#define ascii_0 48
#define ascii_1 49
#define ascii_2 50
#define ascii_3 51
#define ascii_4 52
#define ascii_5 53
#define ascii_6 54
#define ascii_7 55
#define ascii_8 56
#define ascii_9 57

typedef struct {
    int first_digit;
    int second_digit;
} MulDigits;
int verify_digit(char c) {
    if (c >= '0' && c <= '9') {
        return 0;
    } else {
        return -1;
    }
}

// regex.h not availbe on mingw. Manually checking the string
int check_buf_for_pattern(char *str, int size, MulDigits *digits) {
    // printf("str: %s\n", str);
    if (str[0] == ascii_m && str[1] == ascii_u && str[2] == ascii_l &&
        str[3] == ascii_leftpar) {
        //  printf("First 4 chars ok\n");
        int index = 4;
        while (str[index] != ascii_comma) {
            if (index > 7) {
                return -1;
            }
            index++;
        }
        for (int i = 4; i < index; i++) {
            if (verify_digit(str[i]) != 0) {
                return -1;
            }
        }
        int second_dig_start = ++index;
        while (str[index] != ascii_rightpar) {
            if (index > size) {
                return -1;
            }
            index++;
        }
        for (int i = second_dig_start; i < index; i++) {
            if (verify_digit(str[i]) != 0) {
                return -1;
            }
        }
        if (str[index] == ascii_rightpar) {
            char *ptr = &str[4];
            digits->first_digit = strtol(ptr, &ptr, 10);
            if (*ptr == ascii_comma) {
                ptr++;
                digits->second_digit = strtol(ptr, &ptr, 10);
            }
        }
        return 0;
    } else
        return -1;
}
int main() {
    int count = 0;
    int sum = 0;
    int size = 12;
    char buf[size + 1];
    buf[0] = '\0';
    int index_ptr = 0;

    FILE *file = fopen("input.txt", "r");
    char byte;
    MulDigits digits;
    size_t bytes_read;
    while ((bytes_read = fread(buf, 1, size, file)) > 0) {
        buf[bytes_read] = '\0';

        if (check_buf_for_pattern(buf, bytes_read, &digits) == 0) {
            count++;
            sum += (digits.first_digit * digits.second_digit);
            digits.first_digit = 0;
            digits.second_digit = 0;
        }

        if (bytes_read < size)
            break;

        if (fseek(file, -(size - 1), SEEK_CUR) != 0)
            break;
    }

    fclose(file);
    printf("Valid patterns found: %d\n", count);
    printf("Sum: %d\n", sum);

    return 0;
}