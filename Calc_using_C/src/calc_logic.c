#include "calc_logic.h"

// do calculation
double calculate(double num1, char operator, double num2, int *error) {
    *error = 0;

    // check divide by 0
    if ((operator == '/' || operator == '%') && num2 == 0) {
        printf("MATH ERROR\r");
        *error = 1;
        return 0;
    }

    // check modulo with not int
    if (operator == '%' && (!is_integer(num1) || !is_integer(num2))) {
        printf("MATH ERROR\r");
        *error = 1;
        return 0;
    }

    // check operator
    switch (operator) {
        case '+': return num1 + num2;
        case '-': return num1 - num2;
        case 'x': return num1 * num2;
        case '/': return num1 / num2;
        case '%': return (int)num1 % (int)num2;
        default:
            printf("SYNTAX ERROR\r");
            *error = 1;
            return 0;
    }
}
