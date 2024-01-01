## note
- csl/: 复制 .a 
- libgit2: tar 解压顺序问题，手动无法复现
```sh
/usr/bin/tar -C /d/jl/julia/deps/srccache/libgit2-a2bde63741977ca0f4ef7db2f609df320be67a08/ --strip-components 1 -xf /d/jl/julia/deps/srccache/libgit2-a2bde63741977ca0f4ef7db2f609df320be67a08.tar.gz
/usr/bin/tar: tests/resources/testrepo-worktree/link_to_new.txt: Cannot create symlink to 'new.txt': No such file or directory
```

- llvm: tar 解压问题
```sh
mkdir -p /d/jl/julia/deps/srccache/llvm-julia-15.0.7-10/
/usr/bin/tar -C /d/jl/julia/deps/srccache/llvm-julia-15.0.7-10/ --strip-components 1 -xf /d/jl/julia/deps/srccache/llvm-julia-15.0.7-10.tar.gz
/usr/bin/tar: clang/test/Driver/Inputs/basic_cross_linux_tree/usr/bin/i386-unknown-linux-gnu-ld: Cannot create symlink to 'i386-unknown-linux-gnu-ld.gold': No such file or directory
/usr/bin/tar: clang/test/Driver/Inputs/basic_cross_linux_tree/usr/bin/x86_64-unknown-linux-gnu-ld: Cannot create symlink to 'x86_64-unknown-linux-gnu-ld.gold': No such file or directory
/usr/bin/tar: clang/test/Driver/Inputs/basic_cross_linux_tree/usr/i386-unknown-linux-gnu/bin/ld: Cannot create symlink to 'ld.gold': No such file or directory
/usr/bin/tar: clang/test/Driver/Inputs/basic_cross_linux_tree/usr/x86_64-unknown-linux-gnu/bin/ld: Cannot create symlink to 'ld.gold': No such file or directory
/usr/bin/tar: clang/test/Driver/Inputs/multilib_32bit_linux_tree/usr/bin/as: Cannot create symlink to 'i386-unknown-linux-gnu-as': No such file or directory
/usr/bin/tar: clang/test/Driver/Inputs/multilib_64bit_linux_tree/usr/bin/as: Cannot create symlink to 'x86_64-unknown-linux-gnu-as': No such file or directory
/usr/bin/tar: clang/test/Driver/Inputs/multilib_64bit_linux_tree/usr/bin/ld: Cannot create symlink to 'x86_64-unknown-linux-gnu-ld': No such file or directory
/usr/bin/tar: Exiting with failure status due to previous errors
make: *** [/d/jl/julia/deps/llvm.mk:12: /d/jl/julia/deps/srccache/llvm-julia-15.0.7-10/source-extracted] Error 2
make: Leaving directory '/d/jl/julia/deps'
```




##
```sh
pacman -S cmake diffutils git m4 make patch tar p7zip curl python
pacman -S mingw-w64-ucrt-x86_64-gcc

pacman -S unzip mingw-w64-ucrt-x86_64-gcc-fortran mingw-w64-ucrt-x86_64-nasm
# pacman -S mingw-w64-ucrt-x86_64-cmake

```
