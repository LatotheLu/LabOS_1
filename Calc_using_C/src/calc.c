#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "calc_logic.h"
#include "utils.h"

int main() {
	double num1 = 0, num2 = 0, result = 0;
	char operator = 'a';
	int error = 0;

	// get ANS
	double ANS = read_ans();

	while (1) {
		// input
		printf(">> ");
		char input[100];
		fgets(input, sizeof(input), stdin);

		// EXIT
		if (strncmp(input, "EXIT", 4) == 0) break;

		// check input and split
		char num1_str[50], num2_str[50];
		if (sscanf(input, "%s %c %s", num1_str, &operator, num2_str) != 3) {
			printf("SYNTAX ERROR\r");
			wait_one_char();
        		system("clear");
			continue;
		}

		// check ANS
		if (strcmp(num1_str, "ANS") == 0) num1 = ANS;
		else if (!is_valid_number(num1_str, &num1)) {
			printf("SYNTAX ERROR\r");
			wait_one_char();
        		system("clear");
			continue;
		}
		if (strcmp(num2_str, "ANS") == 0) num2 = ANS;
		else if (!is_valid_number(num2_str, &num2)) {
			printf("SYNTAX ERROR\r");
			wait_one_char();
        		system("clear");
			continue;
		}

		result = calculate(num1, operator, num2, &error);
		
		// print result, save ANS if not error
		if (!error) {
			ANS = result;  
			save_ans(ANS); 

			// check int
			if (is_integer(result))
				printf("= %.0f\r", result);
			else
				printf("= %.2f\r", result);
		}

		// pause and wait for input
		wait_one_char();
		system("clear"); // clear display
	}

	return 0;
}
