#ifndef UTILS_H
#define UTILS_H

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>

int is_valid_number(const char *str, double *num);
int is_integer(double num);
double read_ans();
void save_ans(double ans);
void wait_one_char();

#endif
