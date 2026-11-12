
CC = gcc
CFLAGS = -W -Wall
TARGET = run
OBJECTS = main.o sub.o

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(CC) $(CFLAGS) -o $@ $^

clean:
	rm *.o run

