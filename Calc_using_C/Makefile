CC := gcc
CFLAGS := -Wall -Wextra -std=c11 -Iinclude

SRC := $(wildcard src/*.c)
OBJ := $(SRC:.c=.o)

# need ./bin/calc to run, not just ./calc
BIN := bin/calc

# automatic target
all: $(BIN) 

# recompile if any changes
$(BIN): $(OBJ)
	mkdir -p bin
	$(CC) $(CFLAGS) $(OBJ) -o $(BIN)

# convert .c to .o
src/%.o: src/%.c
	$(CC) $(CFLAGS) -c $< -o $@

# clean
clean:
	rm -f $(BIN) $(OBJ) ANS.txt
