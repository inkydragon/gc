= 02 starting out

== Baby's first functions

**一元函数**

先从单参函数开始

> doubleMe x = x + x

```
ghci> :load "02-starting out.lhs"
[1 of 1] Compiling Main             ( 02-starting out.lhs, interpreted )
Ok, modules loaded: Main.
ghci> doubleMe 2
4
ghci> doubleMe 'a'

<interactive>:24:1: error:
    ? No instance for (Num Char) arising from a use of ‘doubleMe’
    ? In the expression: doubleMe 'a'
      In an equation for ‘it’: it = doubleMe 'a'
ghci> doubleMe 2.99
5.98
```

`+`运算符对整数及浮点数均可用,对字符串/字符不行

**二元函数**

再写一个二元函数

> doubleUs x y = x*2 + y*2

```
ghci> doubleUs 4 9
26
ghci> doubleUs 4 6.5
21.0
ghci> doubleUs 4 6.5 + doubleMe 8.9
38.8
```

**`doubleUs`的改进**

在函数定义中调用其他函数

> doubleUs' x y = doubleMe x + doubleMe y

- haskell 中的函数定义没有顺序

**if**

> doubleSmallNumber x = if x > 100
>                       then x
>                       else  x*2

haskell 中 if语句的else不可省略

> doubleSmallNumber' x = (if x > 100 then x else x*2) + 1

函数名中的单引号`'`没有特殊含义，只是用来区分不同的函数

**常量**

> conanO'Brien = "It's a-me, Conan O'Brien!"

函数名的首字母不可大写，常量(函数)不可修改

```
ghci> rgb = 123
ghci> RGB = "123"

<interactive>:34:1: error: Not in scope: data constructor ‘RGB’
ghci> RGB = 123

<interactive>:35:1: error: Not in scope: data constructor ‘RGB’
```

== An intro to lists
