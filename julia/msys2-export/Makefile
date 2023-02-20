# xref: https://github.com/JuliaLang/julia/pull/46140

## Main issue
MSYS2 will perform path conversion when args looks like a PATH string (`:` Separated string)
We don't want this.

- original arg: `../bin/libgcc_s_seh-1.dll:../bin/libopenlibm.dll:@../bin/libjulia-internal.dll:@../bin/libjulia-codegen.dll:`
	```
	$ make -C julia-mingw64/cli/ print-LOADER_BUILD_DEP_LIBS
	make: 进入目录“/v/julia/julia-mingw64/cli”
	LOADER_BUILD_DEP_LIBS=$("/usr/bin/python" /v/julia/contrib/relative_path.py /v/julia/julia-mingw64/usr/lib /v/julia/julia-mingw64/usr/bin/libgcc_s_seh-1.dll):$("/usr/bin/python" /v/julia/contrib/relative_path.py /v/julia/julia-mingw64/usr/lib /v/julia/julia-mingw64/usr/bin/libopenlibm.dll):@$("/usr/bin/python" /v/julia/contrib/relative_path.py /v/julia/julia-mingw64/usr/lib /v/julia/julia-mingw64/usr/bin/libjulia-internal.dll):@$("/usr/bin/python" /v/julia/contrib/relative_path.py /v/julia/julia-mingw64/usr/lib /v/julia/julia-mingw64/usr/bin/libjulia-codegen.dll):
	make: 离开目录“/v/julia/julia-mingw64/cli”

	$ echo  LOADER_BUILD_DEP_LIBS=$("/usr/bin/python" /v/julia/contrib/relative_path.py /v/julia/julia-mingw64/usr/lib /v/julia/julia-mingw64/usr/bin/libgcc_s_seh-1.dll):$("/usr/bin/python" /v/julia/contrib/relative_path.py /v/julia/julia-mingw64/usr/lib /v/julia/julia-mingw64/usr/bin/libopenlibm.dll):@$("/usr/bin/python" /v/julia/contrib/relative_path.py /v/julia/julia-mingw64/usr/lib /v/julia/julia-mingw64/usr/bin/libjulia-internal.dll):@$("/usr/bin/python" /v/julia/contrib/relative_path.py /v/julia/julia-mingw64/usr/lib /v/julia/julia-mingw64/usr/bin/libjulia-codegen.dll):
	LOADER_BUILD_DEP_LIBS=../bin/libgcc_s_seh-1.dll:../bin/libopenlibm.dll:@../bin/libjulia-internal.dll:@../bin/libjulia-codegen.dll:
	```
- after path conversion: `..\bin\libgcc_s_seh-1.dll;..\bin\libopenlibm.dll;@..\bin\libjulia-internal.dll;@..\bin\libjulia-codegen.dll;`

### solve
We need to pass `MSYS2_ARG_CONV_EXCL="-DDEP_LIBS="` to **MSYS2**, not `gcc` or others.


## Methods

I added a new target to test if the parameters are passed correctly.

```diff
diff --git a/cli/Makefile b/cli/Makefile
index ad681f5afb..42b71cbd77 100644
--- a/cli/Makefile
+++ b/cli/Makefile
@@ -51,6 +51,9 @@ default: release
 all: release debug
 release debug :  % : julia-% libjulia-%

+msys2-arg-test:
+       @$(call PRINT_CC, echo 'DEP_LIBS' |  $(CC_WITH_ENV) -E $(SHIPFLAGS) $(LOADER_CFLAGS) -)
+       @$(call PRINT_CC, echo 'MSYS2_ARG_CONV_EXCL=$(MSYS2_ARG_CONV_EXCL)')
+
 $(BUILDDIR)/loader_lib.o : $(SRCDIR)/loader_lib.c $(HEADERS) $(JULIAHOME)/VERSION
        @$(call PRINT_CC, $(CC_WITH_ENV) -DLIBRARY_EXPORTS $(SHIPFLAGS) $(LOADER_CFLAGS) -c $< -o $@)
 $(BUILDDIR)/loader_lib.dbg.obj : $(SRCDIR)/loader_lib.c $(HEADERS) $(JULIAHOME)/VERSION
```
In this target, I pass `'DEP_LIBS'` to gcc via stdin, and specify the `-E` argument for gcc to expand the macro.
We only need to observe the output to determine if the problem has been solved


### 0. baseline: `$(CC_WITH_ENV)`
output:
```sh
$ make -C julia-mingw64/cli/ msys2-arg-test
make: 进入目录“/v/julia/julia-mingw64/cli”
    CC julia-mingw64/cli/msys2-arg-test
# 0 "<stdin>"
# 1 "V:\\julia\\julia-mingw64\\cli//"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "<stdin>"
"../bin/libgcc_s_seh-1.dll:../bin/libopenlibm.dll:@../bin/libjulia-internal.dll:@../bin/libjulia-codegen.dll:"
make: 离开目录“/v/julia/julia-mingw64/cli”
```

works well.


### 1. export env at top-level

patch:
```diff
diff --git a/cli/Makefile b/cli/Makefile
index 23f53a0cc6..823d4628ae 100644
--- a/cli/Makefile
+++ b/cli/Makefile
@@ -31,7 +31,8 @@ DEBUGFLAGS += -DDEP_LIBS="\"$(LOADER_DEBUG_BUILD_DEP_LIBS)\""
 ifneq (,$(findstring MINGW,$(shell uname)))
 # In MSYS2, do not perform path conversion for `DEP_LIBS`.
 # https://www.msys2.org/wiki/Porting/#filesystem-namespaces
-CC_WITH_ENV := MSYS2_ARG_CONV_EXCL="-DDEP_LIBS=" $(CC)
+CC_WITH_ENV := $(CC)
+export MSYS2_ARG_CONV_EXCL := "-DDEP_LIBS="
 else
 CC_WITH_ENV := $(CC)
 endif # in MSYS2?
```

output:
```sh
$ make -C julia-mingw64/cli/ msys2-arg-test
make: 进入目录“/v/julia/julia-mingw64/cli”
    CC julia-mingw64/cli/msys2-arg-test
# 0 "<stdin>"
# 1 "V:\\julia\\julia-mingw64\\cli//"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "<stdin>"
"..\bin\libgcc_s_seh-1.dll;..\bin\libopenlibm.dll;@..\bin\libjulia-internal.dll;@..\bin\libjulia-codegen.dll;"
make: 离开目录“/v/julia/julia-mingw64/cli”
```
not work
