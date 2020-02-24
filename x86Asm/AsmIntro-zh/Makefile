# 编译器、连接器配置
ASM=nasm
ASM_FLAGS= -f elf64
CC=gcc
CFLAGS= -m64

# 匹配所有以 `.asm` 结尾的文件
ASM_SRC := $(wildcard *.asm)
ASM_EXE := $(patsubst %.asm,%.exe, $(ASM_SRC))

# 后缀匹配规则
%.o : %.asm
	@$(ASM) $(ASM_FLAGS) $< -o $@

%.exe : %.o
	@$(CC) $(CFLAGS) $< -o $@
# make -r tst.exe 编译并执行
ifneq (,$(findstring r, $(MAKEFLAGS)))
	./$@ ; echo $$?
endif

# 默认编译所有的 exe
all: clean $(ASM_EXE)

# 保留所有中间文件 .o
.SECONDARY:
.PHONY: clean
clean:
	-rm -f *.o
	-rm -f *.exe
