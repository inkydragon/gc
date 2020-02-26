CC = gcc
SRC = src
CFLAG = -I $(SRC) -DBLOCK_SIZE=128 -Wall
OBJS = main.o $(SRC)/array.o

test: $(OBJS)
	$(CC) $(CFLAG) $(OBJS) -o $@

.c.o:
	$(CC) $(CFLAG) -c $< -o $@

clean:
	rm $(OBJS) test
