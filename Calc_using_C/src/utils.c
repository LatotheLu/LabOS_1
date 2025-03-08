#include "utils.h"

// to store ANS
#define ANS_FILE "ANS.txt"

// check valid number
int is_valid_number(const char *str, double *num) {
	char *endptr;
	*num = strtod(str, &endptr);
	return *endptr == '\0';
}

// check if is integer
int is_integer(double num) {
	if ((int)num == num)
	{
		return 1;
	}
	return 0;
}

// read ANS from file
double read_ans() {
	double ANS = 0;

	// open, if has file, read ANS, else ANS is 0
	FILE *file = fopen(ANS_FILE, "r");
	if (file) {
	    fscanf(file, "%lf", &ANS);
	    fclose(file);
	}
	return ANS;
}
    
// save ANS to file
void save_ans(double ans) {
	FILE *file = fopen(ANS_FILE, "w");
	if (file) {
		fprintf(file, "%.2f", ans);  
		fclose(file);
	}
}

void wait_one_char() {
	// ensure result on terminal
	fflush(stdout);

	// change to raw, no need to enter to finish input
	system("stty raw -echo");

	// rean random button pressed
	system("bash -c 'read -n 1 -s -r'");

	// clear input buffer (no unexpected input error)
	system("bash -c \"read -r -d $'\\0' -t 0.1\"");

	// switch back to normal
	system("stty -raw echo");
}