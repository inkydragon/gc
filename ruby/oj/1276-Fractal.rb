# 1276 : Fractal
#　时间限制: 1 Sec  内存限制: 128 MB
#　提交: 16  解决: 0

# 递归


def fractal(level=1)
  if level < 0
    nil
  elsif level == 1
    "X"
  elsif level == 2
    level -= 1
    a[0][0]=fractal(level)
    a[0][1]=fractalspace(level)
    a[0][2]=fractal(level)
    a[1][0]=fractalspace(level)
    a[1][1]=fractal(level)
    a[1][2]=fractalspace(level)
    a[2][0]=fractal(level)
    a[2][1]=fractalspace(level)
    a[2][2]=fractal(level)
    return a
  else
    level -= 1
  end
end

def fractalspace(level=1)
  if level < 0
    nil
  elsif level == 1
    " "
  elsif level == 2
    level -= 1
    a[0][0]=fractalspace(level)
    a[0][1]=fractalspace(level)
    a[0][2]=fractalspace(level)
    a[1][0]=fractalspace(level)
    a[1][1]=fractalspace(level)
    a[1][2]=fractalspace(level)
    a[2][0]=fractalspace(level)
    a[2][1]=fractalspace(level)
    a[2][2]=fractalspace(level)
    return a
  else
    level -= 1
  end
end
fractal(2)

