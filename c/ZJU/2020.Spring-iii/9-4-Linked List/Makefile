CC = gcc
# SRC = src
SRC = .
CFLAG = -I $(SRC)
OBJS = main.o $(SRC)/linkedlist.o

test: $(OBJS)
	$(CC) $(CFLAG) $(OBJS) -o $@

.c.o:
	$(CC) $(CFLAG) -c $< -o $@

clean:
	rm -f $(OBJS) test
