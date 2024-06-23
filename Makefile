# Compiler
CC = nvcc

# Flags - arch sm_61 for the Pascal architecture on the GTX 1080Ti
CFLAGS = -O3 -arch=sm_61

# Executable
EXEC = main

# Source files
SRC = main.cu

# Output folder
OUT = build

# Makefile
all: $(EXEC)

$(EXEC): $(SRC)
	mkdir -p $(OUT)
	$(CC) $(CFLAGS) -o $(OUT)/$@ $^

run: $(EXEC)
	./$(OUT)/$(EXEC)

clean:
	rm -f $(OUT)/**
	rm -f *.pdb
