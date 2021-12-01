# -*- coding: utf-8 -*-
import turtle as tur

"""
全局变量定义
        
    bezier_STEP 贝塞尔函数的取样次数
    DRAW_SPEED  绘制速度
    WIDTH       界面宽度
    HEIGHT      界面高度
    Xh          记录前一个贝塞尔函数的手柄
"""
bezier_STEP = 15
T_RANGE = map(lambda x: x/bezier_STEP, range(0, bezier_STEP+1))
# T_LIST = list(map(lambda x: x/bezier_STEP, range(0, bezier_STEP+1)))
T_LIST = [x/bezier_STEP for x in range(0, bezier_STEP+1)]
DRAW_SPEED = 5
PEN_SIZE = 4
WIDTH = 600
HEIGHT = 600
Xh = 0
Yh = 0


"""
辅助函数
"""


# 线性插值
# LinearInterp = lambda p1, p2, t: p1*(1-t) + p2*t
def linear_interp(p1, p2, t):
    return p1*(1-t) + p2*t


bezier = linear_interp  # 兼容


# 一阶 bezier 函数 - Tuple
def bezier1(p1, p2, t):
    return (
        linear_interp(p1[0], p2[0], t),
        linear_interp(p1[1], p2[1], t))

# bezier_1 = lambda x1,y1, x2,y2, t : bezier1((x1,y1), (x2,y2), t)
def bezier_1(x1, y1, x2, y2, t):  # 兼容
    return bezier1((x1, y1), (x2, y2), t)

# 二阶 bezier 函数
def bezier2(p1, p2, p3, t):
    return bezier1(
        bezier1(p1, p2, t),
        bezier1(p2, p3, t),
        t
    )

# 三阶 bezier 函数
def bezier3(p1, p2, p3, p4, t):
    return bezier1(
        bezier2(p1, p2, p3, t),
        bezier2(p2, p3, p4, t),
        t
    )

def bezier_3(p1, p2, p3, p4):
    #tur.pendown()
    for t in T_LIST:
        x,y = bezier3(p1, p2, p3, p4, t)
        tur.goto(x, y)
    #tur.penup()

def p(c):  # 将 SVG 坐标 c 转换为 tur 坐标
    return complex(
        + c.real - WIDTH/2,
        - c.imag + HEIGHT/2
    )


def M(c):  # 移动到 SVG 坐标 c
    tur.goto(p(c).real, p(c).imag)


def Line(start, end):
    # tur.penup()
    M(start)
    #tur.pendown()
    M(end)
    #tur.penup()


def CubicBezier(start, control1, control2, end):
    M(start)
    bezier_3(
        (p(start).real, p(start).imag),
        (p(control1).real, p(control1).imag),
        (p(control2).real, p(control2).imag),
        (p(end).real, p(end).imag))

def f(sp=0j, rgb='red'):
    tur.fillcolor(rgb)
    M(sp)
    tur.begin_fill()

nf = tur.end_fill

def pd(sp, rgb="#E4007F", bold=PEN_SIZE):
    tur.color(rgb)
    tur.pensize(bold)
    M(sp)
    tur.pendown()

def pu():
    tur.penup()
    tur.pensize(PEN_SIZE)
    tur.color("black")

"""
绘图代码
"""
screen = tur.Screen()
screen.bgcolor("white")

tur.tracer(100)   # 调整作画时间
tur.pensize(PEN_SIZE)
tur.speed(DRAW_SPEED)
tur.penup()

## 卫衣
tur.fillcolor("#97C9B7")
#M(151.94+332.51j)
tur.begin_fill()
Line(151.94+332.51j, 151.92+332.5j)
Line(151.92+332.5j, 193.06+332.5j)
CubicBezier(193.06+332.5j, 203.33+326.22j, 221.88+314.49j, 233.25+305.88j)
CubicBezier(233.25+305.88j, 245.3+296.75j, 257.39+286.89j, 266.61+278.25j)
CubicBezier(266.61+278.25j, 266.42+277.34j, 262.28+264.81j, 252.33+260.67j)
CubicBezier(252.33+260.67j, 242.58+256.6j, 233.2+261.89j, 232.35+262.41j)
Line(232.35+262.41j, 232.35+262.41j)
CubicBezier(232.35+262.41j, 231.95+262.09j, 231.56+261.73j, 231.17+261.33j)
CubicBezier(231.17+261.33j, 227.93+258.03j, 228.06+255.7j, 225.17+252.9j)
CubicBezier(225.17+252.9j, 222.74+250.56j, 218.42+245.83j, 205.75+244.83j)
Line(205.75+244.83j, 133.83+246.83j)
CubicBezier(133.83+246.83j, 130.47+250.8j, 128.29+253.37j, 127.33+254.5j)
CubicBezier(127.33+254.5j, 123.46+259.07j, 121.48+261.35j, 119.5+261.33j)
CubicBezier(119.5+261.33j, 116.84+261.31j, 116.35+258.49j, 113.33+257.67j)
CubicBezier(113.33+257.67j, 109.02+256.49j, 104.38+260.71j, 101.5+263.33j)
CubicBezier(101.5+263.33j, 98.51+266.05j, 93.23+271.75j, 90+281.75j)
CubicBezier(90+281.75j, 99.53+290.63j, 110.02+299.78j, 121.5+309j)
CubicBezier(121.5+309j, 131.65+317.15j, 143.07+326.3j, 152.63+333j)
tur.end_fill()

## 外套
f(76.88+333j, "#D0E8EA")
CubicBezier(76.88+333j, 76.86+326.19j, 77.06+315.06j, 80.12+304.38j)
CubicBezier(80.12+304.38j, 82.92+294.64j, 86.68+287.29j, 90+281.75j)
CubicBezier(90+281.75j, 99.53+290.63j, 110.02+299.78j, 121.5+309j)
CubicBezier(121.5+309j, 131.4+316.95j, 142.51+325.85j, 151.92+332.5j)
Line(151.92+332.5j, 151.94+332.5j)
Line(151.94+332.5j, 76+332.5j)

# 2
Line(193.06+332.5j, 285.27+332.5j)
CubicBezier(285.27+332.5j, 285.34+327.97j, 285.42+308.21j, 280.88+294.88j)
CubicBezier(280.88+294.88j, 279.07+289.57j, 277.01+286.33j, 274.5+283.75j)
CubicBezier(274.5+283.75j, 271.37+280.53j, 268.85+279.17j, 266.61+278.25j)
CubicBezier(266.61+278.25j, 257.39+286.89j, 245.3+296.75j, 233.25+305.88j)
CubicBezier(233.25+305.88j, 221.88+314.49j, 203.33+326.22j, 193.06+332.5j)
nf()

## 卫衣-暗部
f(205.75+244.83j, "#619A87")
CubicBezier(205.75+244.83j, 218.42+245.83j, 222.74+250.56j, 225.17+252.9j)
CubicBezier(225.17+252.9j, 226.4+254.09j, 227.08+255.19j, 227.71+256.32j)
CubicBezier(227.71+256.32j, 225.67+258.76j, 191.73+277.65j, 171+277.67j)
CubicBezier(171+277.67j, 157.49+277.68j, 130.41+258.34j, 127.33+254.5j)
CubicBezier(127.33+254.5j, 128.29+253.37j, 130.47+250.8j, 133.83+246.83j)
Line(133.83+246.83j, 205.75+244.83j)
nf()

## 胸-亮部
f(204.13+270.23j, "#FAE8E3")
CubicBezier(204.13+270.23j, 198.93+277.16j, 192.74+286.1j, 188+294.5j)
CubicBezier(188+294.5j, 180.5+307.77j, 174.86+321.91j, 171.31+332.5j)
CubicBezier(171.31+332.5j, 165.92+321.02j, 160.07+306.73j, 155+293j)
CubicBezier(155+293j, 151.85+284.47j, 149.07+276.2j, 146.61+268.24j)
Line(146.61+268.24j, 146.61+268.24j)
CubicBezier(146.61+268.24j, 155.12+273.23j, 164.59+277.58j, 171+277.58j)
CubicBezier(171+277.58j, 180.42+277.57j, 192.56+273.66j, 203.21+269.18j)
Line(203.21+269.18j, 203.21+269.18j)
Line(203.21+269.18j, 204.07+270.18j)
nf()

## 脖子-暗部 #DAA188
f(192.38+240.44j, "#DAA188")
Line(192.38+240.44j, 192.38+256.62j)
Line(192.38+256.62j, 203.21+269.18j)
Line(203.21+269.18j, 203.21+269.18j)
CubicBezier(203.21+269.18j, 192.56+273.66j, 180.42+277.57j, 171+277.58j)
CubicBezier(171+277.58j, 164.59+277.58j, 155.12+273.23j, 146.61+268.24j)
Line(146.61+268.24j, 146.61+268.24j)
CubicBezier(146.61+268.24j, 146.08+266.53j, 145.57+264.83j, 145.07+263.15j)
Line(145.07+263.15j, 145.07+263.14j)
Line(145.07+263.14j, 152.62+256.5j)
CubicBezier(152.62+256.5j, 152.62+256.5j, 152.62+242.67j, 152.62+242.67j)
CubicBezier(152.62+242.67j, 167.22+245.5j, 180.67+243.9j, 192.33+240.29j)
nf()

## 左头饰-丝带_x23_2
pd(73.93+177.19j, "#E4007F", 4)
CubicBezier(73.93+177.19j, 74.17+185.7j, 75.48+206.22j, 77.67+217.33j)
CubicBezier(77.67+217.33j, 79.74+227.84j, 82.52+237j, 85.33+244.67j)
pu()

## 左耳
f(75.45+164.64j, "#FCEBE2")
CubicBezier(75.45+164.64j, 72.5+166.33j, 72.43+166.24j, 71.64+169.25j)
CubicBezier(71.64+169.25j, 70.31+174.33j, 73.78+183.75j, 75.67+186.62j)
CubicBezier(75.67+186.62j, 79.2+191.96j, 81.88+195.12j, 86.72+198.81j)
Line(86.72+198.81j, 75.45+164.64j)
nf()

## 右耳
f(75.45+164.64j, "#FCEBE2")
CubicBezier(253.5+201.49j, 256.99+199.81j, 262.68+196.49j, 266.83+186j)
CubicBezier(266.83+186j, 269.72+178.72j, 269.06+164.53j, 266.16+161.25j)
CubicBezier(266.16+161.25j, 264.41+159.28j, 263.5+158.56j, 260.67+159.33j)
CubicBezier(260.67+159.33j, 259.02+175.85j, 256.15+190.1j, 253.25+201.42j)
nf()

## 脸_1_
f(226.33+164.83j, "#FAE8E3")
CubicBezier(226.33+164.83j, 234.56+158.71j, 237.01+137.88j, 237.77+127.72j)
Line(237.77+127.72j, 237.71+128.56j)
CubicBezier(237.71+128.56j, 237.71+124.25j, 236.73+122.84j, 234.04+116.88j)
CubicBezier(234.04+116.88j, 232.56+113.58j, 231.31+111.13j, 229.74+108.64j)
Line(229.74+108.64j, 229.75+108.51j)
CubicBezier(229.75+108.51j, 229.2+117.6j, 227.11+127.08j, 225.83+134j)
CubicBezier(225.83+134j, 225.37+131.75j, 224.18+127.56j, 220.83+123.5j)
CubicBezier(220.83+123.5j, 218.55+120.73j, 216.08+119.01j, 214.33+118j)
CubicBezier(214.33+118j, 215.05+115.52j, 216.81+108.21j, 213.33+100.5j)
CubicBezier(213.33+100.5j, 211.91+97.35j, 212.01+97.63j, 210.54+95.84j)
Line(210.54+95.84j, 210.49+95.84j)
CubicBezier(210.49+95.84j, 210.38+100.08j, 210.22+104.74j, 210.01+109.75j)
CubicBezier(210.01+109.75j, 209.77+112.39j, 209.64+115.03j, 207.51+117.92j)
CubicBezier(207.51+117.92j, 206.77+118.91j, 205.55+120.07j, 201.84+121.42j)
CubicBezier(201.84+121.42j, 199.13+122.4j, 194.41+123.28j, 188.74+123.29j)
Line(188.74+123.29j, 189.06+123.21j)
CubicBezier(189.06+123.21j, 189.56+119.81j, 189.29+117.62j, 188.83+112.67j)
CubicBezier(188.83+112.67j, 188.53+109.45j, 187.01+102.76j, 186.38+100.33j)
Line(186.38+100.33j, 186.19+100j)
CubicBezier(186.19+100j, 186.11+101.3j, 186.01+102.64j, 185.87+104j)
CubicBezier(185.87+104j, 184.88+114.26j, 182.11+123.27j, 179.81+129.79j)
CubicBezier(179.81+129.79j, 180.18+122.77j, 178.92+109.85j, 178.62+108.12j)
CubicBezier(178.62+108.12j, 177.74+102.91j, 177.56+88.87j, 175.25+82.75j)
CubicBezier(175.25+82.75j, 176.02+85.69j, 177.31+92.27j, 175+100j)
CubicBezier(175+100j, 173.34+105.57j, 169.52+110.64j, 167.66+112.81j)
Line(167.66+112.81j, 167.63+112.54j)
CubicBezier(167.63+112.54j, 168.11+118.39j, 168.9+124.36j, 169.5+127.92j)
CubicBezier(169.5+127.92j, 169.36+127.65j, 167.53+124.87j, 163.17+123.67j)
CubicBezier(163.17+123.67j, 160.84+123.02j, 156.73+123.09j, 155.83+123.67j)
CubicBezier(155.83+123.67j, 155.83+123.67j, 149.87+96.29j, 149.75+96.04j)
CubicBezier(149.75+96.04j, 149.7+100.3j, 149.31+107.84j, 149.73+112.81j)
CubicBezier(149.73+112.81j, 150.2+118.46j, 150.98+122.38j, 151.87+127.04j)
CubicBezier(151.87+127.04j, 146.64+124.16j, 137.28+117.86j, 133.37+108j)
CubicBezier(133.37+108j, 131.12+102.33j, 130.12+94.12j, 129.68+82.31j)
CubicBezier(129.68+82.31j, 129.58+79.38j, 129.46+75.07j, 129.4+70.12j)
Line(129.4+70.12j, 129.35+70.72j)
CubicBezier(129.35+70.72j, 125.9+74.12j, 124.64+75.93j, 121.33+82.75j)
CubicBezier(121.33+82.75j, 117+91.69j, 115.68+112.81j, 117.72+125.25j)
CubicBezier(117.72+125.25j, 112.03+125.25j, 110.84+123.19j, 109.56+121.06j)
CubicBezier(109.56+121.06j, 108.75+119.72j, 104.9+105.9j, 104.9+99.34j)
Line(104.9+99.34j, 104.93+98.83j)
CubicBezier(104.93+98.83j, 104.23+109.93j, 104.52+120.41j, 105.2+129.28j)
CubicBezier(105.2+129.28j, 100.92+127.37j, 97.19+123.43j, 94.72+117.04j)
CubicBezier(94.72+117.04j, 93.21+113.16j, 91.6+106.52j, 91.09+101.18j)
Line(91.09+101.18j, 91.11+100.62j)
CubicBezier(91.11+100.62j, 90.87+109.18j, 91.19+119.18j, 91.71+129.62j)
CubicBezier(91.71+129.62j, 92.54+146.54j, 98.86+161.67j, 103.08+170.38j)
CubicBezier(103.08+170.38j, 100.79+170.04j, 97.4+169.25j, 93.92+167.72j)
Line(93.92+167.72j, 94.06+167.83j)
CubicBezier(94.06+167.83j, 94.06+177.91j, 95.67+188.73j, 97.05+197.85j)
CubicBezier(97.05+197.85j, 97.45+200.48j, 97.82+203.59j, 98.22+206.94j)
CubicBezier(98.22+206.94j, 102.74+213.21j, 120.28+235.69j, 151+242.33j)
CubicBezier(151+242.33j, 198.18+252.52j, 233.89+215.8j, 235.97+213.6j)
Line(235.97+213.6j, 236.14+213.6j)
CubicBezier(236.14+213.6j, 235.99+208.81j, 235.92+204.15j, 236+200.16j)
CubicBezier(236+200.16j, 236.25+186.65j, 237.26+174.2j, 238.66+163j)
Line(238.66+163j, 239.3+163.47j)
CubicBezier(239.3+163.47j, 238.54+163.79j, 237.71+164.08j, 236.83+164.33j)
CubicBezier(236.83+164.33j, 232.29+165.62j, 228.42+165.21j, 226.33+164.83j)
nf()

## 鼻子
f(0j, "#F4D7D3")
CubicBezier(195.11+160.5j, 195.11+166.77j, 182.57+171.85j, 167.09+171.85j)
CubicBezier(167.09+171.85j, 151.62+171.85j, 139.08+166.77j, 139.08+160.5j)
CubicBezier(139.08+160.5j, 139.08+156.9j, 148.96+149.15j, 167.09+149.15j)
CubicBezier(167.09+149.15j, 182.57+149.15j, 195.11+154.23j, 195.11+160.5j)
nf()

## 嘴
f(0j, "#DAA188")
CubicBezier(140.67+198.81j, 140.68+197.48j, 154.38+196.95j, 165.5+197j)
CubicBezier(165.5+197j, 180.2+197.06j, 194.73+200.82j, 194.67+202.3j)
CubicBezier(194.67+202.3j, 194.61+203.79j, 177.48+202.69j, 165.33+202.33j)
CubicBezier(165.33+202.33j, 154.09+202j, 140.65+200.22j, 140.67+198.81j)
nf()

## 腮红
f(117.83+167.99j, "#E8D2CA")
CubicBezier(117.83+167.99j, 117.03+171.33j, 116.24+174.68j, 115.45+178.03j)
CubicBezier(115.45+178.03j, 115.16+179.24j, 118.1+178.83j, 118.36+177.72j)
CubicBezier(118.36+177.72j, 119.16+174.38j, 119.95+171.03j, 120.74+167.68j)
CubicBezier(120.74+167.68j, 121.03+166.47j, 118.09+166.88j, 117.83+167.99j)
Line(117.83+167.99j, 117.83+167.99j)

# 2
CubicBezier(112.32+167.99j, 111.19+171.83j, 110.05+175.68j, 108.92+179.53j)
CubicBezier(108.92+179.53j, 108.57+180.69j, 111.51+180.32j, 111.83+179.22j)
CubicBezier(111.83+179.22j, 112.97+175.38j, 114.1+171.53j, 115.23+167.68j)
CubicBezier(115.23+167.68j, 115.58+166.51j, 112.64+166.89j, 112.32+167.99j)
Line(112.32+167.99j, 112.32+167.99j)

# 3
CubicBezier(105.36+169.94j, 104.12+173.29j, 102.87+176.64j, 101.63+179.99j)
CubicBezier(101.63+179.99j, 101.22+181.08j, 104.14+180.75j, 104.54+179.68j)
CubicBezier(104.54+179.68j, 105.79+176.33j, 107.03+172.99j, 108.28+169.64j)
CubicBezier(108.28+169.64j, 108.69+168.54j, 105.76+168.88j, 105.36+169.94j)
Line(105.36+169.94j, 105.36+169.94j)

# 4
CubicBezier(99.58+171.72j, 98.79+173.88j, 98+176.05j, 97.2+178.22j)
CubicBezier(97.2+178.22j, 96.8+179.32j, 99.73+178.98j, 100.12+177.91j)
CubicBezier(100.12+177.91j, 100.91+175.74j, 101.7+173.58j, 102.49+171.41j)
CubicBezier(102.49+171.41j, 102.89+170.31j, 99.97+170.65j, 99.58+171.72j)
Line(99.58+171.72j, 99.58+171.72j)
nf()

# 5
f(233.06+166.46j, "#F4D7D3")
CubicBezier(233.06+166.46j, 232.08+169.28j, 231.1+172.09j, 230.13+174.9j)
CubicBezier(230.13+174.9j, 229.74+176.02j, 232.67+175.67j, 233.04+174.6j)
CubicBezier(233.04+174.6j, 234.02+171.78j, 234.99+168.97j, 235.97+166.16j)
CubicBezier(235.97+166.16j, 236.36+165.04j, 233.43+165.39j, 233.06+166.46j)
Line(233.06+166.46j, 233.06+166.46j)

# 6
CubicBezier(216.34+162.77j, 214.19+167.48j, 212.04+172.2j, 209.89+176.91j)
CubicBezier(209.89+176.91j, 209.26+178.29j, 212.16+178.08j, 212.61+177.09j)
CubicBezier(212.61+177.09j, 214.76+172.37j, 216.91+167.66j, 219.06+162.94j)
CubicBezier(219.06+162.94j, 219.69+161.57j, 216.79+161.78j, 216.34+162.77j)
Line(216.34+162.77j, 216.34+162.77j)

# 7
CubicBezier(223.05+162.13j, 221.33+165.47j, 219.61+168.82j, 217.89+172.17j)
CubicBezier(217.89+172.17j, 217.2+173.5j, 220.12+173.31j, 220.61+172.34j)
CubicBezier(220.61+172.34j, 222.34+169j, 224.06+165.65j, 225.78+162.3j)
CubicBezier(225.78+162.3j, 226.46+160.97j, 223.55+161.16j, 223.05+162.13j)
Line(223.05+162.13j, 223.05+162.13j)

# 8
CubicBezier(227.61+166.23j, 226.23+168.93j, 224.85+171.63j, 223.47+174.33j)
CubicBezier(223.47+174.33j, 222.79+175.66j, 225.7+175.47j, 226.2+174.5j)
CubicBezier(226.2+174.5j, 227.58+171.8j, 228.96+169.1j, 230.34+166.4j)
CubicBezier(230.34+166.4j, 231.02+165.07j, 228.11+165.26j, 227.61+166.23j)
Line(227.61+166.23j, 227.61+166.23j)
nf()

## 头发
f(0j, "#E9D2AB")
CubicBezier(64.82+139.47j, 66.37+157.34j, 67.25+181.32j, 66+188.5j)
CubicBezier(66+188.5j, 63.56+202.46j, 63.65+204.11j, 62.5+218.33j)
CubicBezier(62.5+218.33j, 61.14+235.15j, 62.36+238.36j, 61+254.5j)
CubicBezier(61+254.5j, 59.97+266.7j, 57.93+270.63j, 55.5+283j)
CubicBezier(55.5+283j, 53.27+294.33j, 51.09+310.85j, 52+332j)
Line(52+332j, 53.88+332.72j)
Line(53.88+332.72j, 43.8+332.72j)
Line(43.8+332.72j, 45+331.62j)
CubicBezier(45+331.62j, 46.28+299.08j, 43.47+273.28j, 40.58+255.5j)
CubicBezier(40.58+255.5j, 37.32+235.38j, 30.91+209.22j, 31.5+177.5j)
CubicBezier(31.5+177.5j, 32.03+149.18j, 35.14+140.09j, 42.75+114j)
CubicBezier(42.75+114j, 47.75+96.87j, 64.75+72.25j, 73.64+67.08j)
Line(73.64+67.08j, 73.11+68.06j)
CubicBezier(73.11+68.06j, 91.32+33.81j, 126.51+11.81j, 165+11j)
CubicBezier(165+11j, 207.65+10.11j, 247.14+35.4j, 264.75+75j)
CubicBezier(264.75+75j, 267.47+74.8j, 272.13+74.85j, 277+77.17j)
CubicBezier(277+77.17j, 279.46+78.34j, 282.98+80.56j, 287.83+87.33j)
CubicBezier(287.83+87.33j, 289.94+90.28j, 294.56+96.84j, 297.5+106.5j)
CubicBezier(297.5+106.5j, 309.84+147.12j, 309.01+207.33j, 309.01+207.33j)
CubicBezier(309.01+207.33j, 308.64+250.67j, 307.59+259.25j, 305.83+299.25j)
CubicBezier(305.83+299.25j, 304.95+319.23j, 305.66+321.86j, 306.33+332.5j)
Line(306.33+332.5j, 306.7+333.28j)
Line(306.7+333.28j, 302.07+333.28j)
Line(302.07+333.28j, 302+331.5j)
CubicBezier(302+331.5j, 296.17+300.29j, 290.35+269.09j, 284.52+237.88j)
CubicBezier(284.52+237.88j, 283.83+233.67j, 280.78+230.82j, 280.5+226.75j)
Line(280.5+226.75j, 277.12+153.94j)
Line(277.12+153.94j, 267.02+162.21j)
Line(267.02+162.21j, 266.68+161.99j)
CubicBezier(266.68+161.99j, 266.51+161.7j, 266.34+161.46j, 266.16+161.25j)
CubicBezier(266.16+161.25j, 264.42+159.28j, 263.5+158.56j, 260.67+159.33j)
Line(260.67+159.33j, 260.69+159.11j)
CubicBezier(260.69+159.11j, 260.68+159.19j, 260.67+159.26j, 260.67+159.33j)
CubicBezier(260.67+159.33j, 257.05+195.66j, 247.53+221.03j, 244.67+228.33j)
CubicBezier(244.67+228.33j, 243.85+230.42j, 242.02+235.71j, 238.67+242.33j)
CubicBezier(238.67+242.33j, 238.47+242.73j, 238.31+243.35j, 238.19+244.15j)
CubicBezier(238.19+244.15j, 237.32+238.17j, 235.73+214.71j, 236+200.17j)
CubicBezier(236+200.17j, 236.26+186.65j, 237.27+174.2j, 238.67+163j)
Line(238.67+163j, 238.67+163.73j)
CubicBezier(238.67+163.73j, 238.09+163.95j, 237.48+164.15j, 236.83+164.33j)
CubicBezier(236.83+164.33j, 232.29+165.62j, 228.42+165.21j, 226.33+164.83j)
CubicBezier(226.33+164.83j, 234.55+158.72j, 237+137.98j, 237.77+127.79j)
Line(237.77+127.79j, 237.7+127.79j)
CubicBezier(237.7+127.79j, 237.58+124.05j, 236.56+122.46j, 234.04+116.87j)
CubicBezier(234.04+116.87j, 232.56+113.58j, 231.32+111.13j, 229.74+108.64j)
Line(229.74+108.64j, 229.75+108.54j)
CubicBezier(229.75+108.54j, 229.2+117.62j, 227.11+127.08j, 225.83+134j)
CubicBezier(225.83+134j, 225.37+131.75j, 224.18+127.56j, 220.83+123.5j)
CubicBezier(220.83+123.5j, 218.55+120.73j, 216.08+119.01j, 214.33+118j)
CubicBezier(214.33+118j, 215.05+115.52j, 216.81+108.21j, 213.33+100.5j)
CubicBezier(213.33+100.5j, 211.92+97.35j, 212.02+97.63j, 210.54+95.84j)
Line(210.54+95.84j, 210.33+109.66j)
CubicBezier(210.33+109.66j, 210.09+112.31j, 209.97+114.95j, 207.83+117.83j)
CubicBezier(207.83+117.83j, 207.1+118.82j, 205.88+119.98j, 202.17+121.33j)
CubicBezier(202.17+121.33j, 199.46+122.31j, 194.74+123.2j, 189.06+123.21j)
CubicBezier(189.06+123.21j, 189.56+119.81j, 189.3+117.62j, 188.83+112.66j)
CubicBezier(188.83+112.66j, 188.53+109.45j, 187.01+102.76j, 186.38+100.33j)
Line(186.38+100.33j, 186.17+100.32j)
CubicBezier(186.17+100.32j, 186.09+101.52j, 186+102.75j, 185.88+104j)
CubicBezier(185.88+104j, 184.88+114.26j, 182.11+123.27j, 179.81+129.79j)
CubicBezier(179.81+129.79j, 180.18+122.77j, 178.92+109.85j, 178.62+108.12j)
CubicBezier(178.62+108.12j, 177.75+102.91j, 177.56+88.87j, 175.25+82.75j)
CubicBezier(175.25+82.75j, 176.02+85.69j, 177.31+92.27j, 175+100j)
CubicBezier(175+100j, 173.34+105.57j, 169.53+110.64j, 167.66+112.81j)
CubicBezier(167.66+112.81j, 168.14+118.58j, 168.91+124.42j, 169.5+127.91j)
CubicBezier(169.5+127.91j, 169.36+127.65j, 167.53+124.87j, 163.17+123.66j)
CubicBezier(163.17+123.66j, 160.85+123.02j, 156.73+123.09j, 155.83+123.66j)
CubicBezier(155.83+123.66j, 155.83+123.66j, 149.87+96.29j, 149.75+96.04j)
CubicBezier(149.75+96.04j, 149.7+100.3j, 149.31+107.84j, 149.73+112.81j)
CubicBezier(149.73+112.81j, 150.2+118.46j, 150.98+122.38j, 151.87+127.04j)
CubicBezier(151.87+127.04j, 146.64+124.16j, 137.29+117.86j, 133.37+108j)
CubicBezier(133.37+108j, 131.12+102.33j, 130.12+94.12j, 129.69+82.31j)
CubicBezier(129.69+82.31j, 129.58+79.5j, 129.47+75.42j, 129.41+70.72j)
Line(129.41+70.72j, 129.35+70.72j)
CubicBezier(129.35+70.72j, 125.9+74.12j, 124.64+75.93j, 121.33+82.75j)
CubicBezier(121.33+82.75j, 117+91.69j, 115.69+112.81j, 117.72+125.25j)
CubicBezier(117.72+125.25j, 112.03+125.25j, 110.84+123.18j, 109.56+121.06j)
CubicBezier(109.56+121.06j, 108.75+119.72j, 104.91+105.9j, 104.91+99.34j)
Line(104.91+99.34j, 104.93+98.87j)
CubicBezier(104.93+98.87j, 104.23+109.95j, 104.53+120.42j, 105.2+129.28j)
CubicBezier(105.2+129.28j, 100.92+127.37j, 97.2+123.43j, 94.72+117.04j)
CubicBezier(94.72+117.04j, 93.21+113.16j, 91.61+106.52j, 91.09+101.18j)
Line(91.09+101.18j, 91.1+100.9j)
CubicBezier(91.1+100.9j, 90.88+109.4j, 91.2+119.29j, 91.71+129.62j)
CubicBezier(91.71+129.62j, 92.54+146.54j, 98.87+161.66j, 103.08+170.38j)
CubicBezier(103.08+170.38j, 100.77+170.03j, 97.34+169.23j, 93.83+167.68j)
Line(93.83+167.68j, 94.06+167.83j)
CubicBezier(94.06+167.83j, 94.06+177.91j, 95.67+188.73j, 97.06+197.85j)
CubicBezier(97.06+197.85j, 98.75+209.05j, 99.85+228.87j, 105.63+238.6j)
Line(105.63+238.6j, 104.78+236.87j)
CubicBezier(104.78+236.87j, 94.87+221.52j, 81.16+187.02j, 75.44+164.64j)
Line(75.44+164.64j, 75.45+164.64j)
Line(75.45+164.64j, 72.4+166.31j)
Line(72.4+166.31j, 72.5+166.33j)
CubicBezier(72.5+166.33j, 69.37+157.36j, 66.64+149.4j, 64.93+139.46j)
nf()

## 左-长发刘海
f(0j, "#E9D2AB")
Line(106.75+332.72j, 93.49+332.72j)
Line(93.49+332.72j, 93.49+332.5j)
CubicBezier(93.49+332.5j, 93.86+320.9j, 95.46+309.52j, 97+303.67j)
CubicBezier(97+303.67j, 99.35+294.72j, 102.35+289.45j, 105+277.33j)
CubicBezier(105+277.33j, 106.36+271.11j, 109.03+255.24j, 109.36+251.96j)
CubicBezier(109.36+251.96j, 109.54+253.87j, 109.67+256.06j, 109.75+258.67j)
CubicBezier(109.75+258.67j, 108.79+282.99j, 107.83+307.31j, 106.88+331.62j)
nf()

## 右-长发刘海
f(238.19+244.15j, "#E9D2AB")
CubicBezier(238.19+244.15j, 237.59+248.38j, 238.19+257.72j, 239.81+267.08j)
CubicBezier(239.81+267.08j, 242.22+280.98j, 243.87+289.09j, 244.63+293.25j)
CubicBezier(244.63+293.25j, 246.24+302.14j, 247.76+316.38j, 247+332.5j)
Line(247+332.5j, 247+332.72j)
Line(247+332.72j, 260.83+332.72j)
Line(260.83+332.72j, 260.83+332.5j)
CubicBezier(260.83+332.5j, 262.63+318.83j, 256+304.06j, 254.25+296.82j)
CubicBezier(254.25+296.82j, 252.42+289.25j, 248.11+281.99j, 246.17+273.33j)
CubicBezier(246.17+273.33j, 243.42+261.08j, 241.69+242.93j, 241.84+236.08j)
nf()

## 高光
f(55.87+87.36j, "#EFEFE7")
CubicBezier(55.87+87.36j, 70.54+83j, 121.31+83.34j, 121.33+83.83j)
CubicBezier(121.33+83.83j, 121.36+84.43j, 101.22+87.1j, 72.5+90.21j)
CubicBezier(72.5+90.21j, 60.17+91.54j, 54.77+93.86j, 49.57+97.99j)
Line(49.57+97.99j, 55.87+87.36j)
nf()
# 2
f(293.13+95.84j, "#EFEFE7")
CubicBezier(293.13+95.84j, 285.05+88.86j, 263.83+84.72j, 250.29+84.75j)
CubicBezier(250.29+84.75j, 229.09+84.79j, 204.3+86.01j, 204.33+87.33j)
CubicBezier(204.33+87.33j, 204.37+88.82j, 233.82+88.66j, 255.33+93j)
CubicBezier(255.33+93j, 273.92+96.75j, 293+104.08j, 299.59+114.02j)
Line(299.59+114.02j, 293.13+95.84j)
nf()

## 阴影
f(63.08+125.56j, "#C88D7A")
CubicBezier(63.08+125.56j, 58.36+140.74j, 57.72+151.69j, 55.5+171.17j)
CubicBezier(55.5+171.17j, 51.5+206.25j, 52.55+255.42j, 56.63+277.67j)
CubicBezier(56.63+277.67j, 58.55+269.17j, 60.13+264.75j, 61+254.5j)
CubicBezier(61+254.5j, 62.36+238.36j, 61.14+235.14j, 62.5+218.33j)
CubicBezier(62.5+218.33j, 63.65+204.11j, 63.56+202.46j, 66+188.5j)
CubicBezier(66+188.5j, 67.59+179.36j, 65.73+143.03j, 63.44+126.69j)
nf()
# 2
f(276.46+154.34j, "#C88D7A")
Line(276.46+154.34j, 290+146.33j)
CubicBezier(290+146.33j, 288.18+166.36j, 287.58+197.58j, 289.33+214j)
CubicBezier(289.33+214j, 290.36+223.66j, 291.35+231.53j, 291.83+244.83j)
CubicBezier(291.83+244.83j, 292.44+261.54j, 292.08+267.67j, 291.85+277.14j)
CubicBezier(291.85+277.14j, 289.41+264.05j, 286.96+250.96j, 284.52+237.88j)
CubicBezier(284.52+237.88j, 283.83+233.67j, 280.77+230.82j, 280.5+226.75j)
Line(280.5+226.75j, 277.12+153.94j)
nf()

## 右头饰
pd(268.67+231.67j, "#E4007F", 4)
CubicBezier(268.67+231.67j, 268.51+216.77j, 268.21+202.51j, 269.33+185.67j)
CubicBezier(269.33+185.67j, 270.21+172.46j, 270.98+157.39j, 272.5+145.5j)
pu()

# 2
pd(278+231.83j, "#E4007F", 3)
CubicBezier(278+231.83j, 276.76+219.55j, 275.78+206.58j, 275.17+193j)
CubicBezier(275.17+193j, 274.55+179.33j, 274.32+160.5j, 274.46+148.08j)
pu()
# 3
f(0j, "#E4007F")
CubicBezier(265.51+86.26j, 274.69+105.44j, 281.17+125.74j, 284.92+146.66j)
CubicBezier(284.92+146.66j, 285.31+145.72j, 285.69+144.78j, 286.07+143.84j)
CubicBezier(286.07+143.84j, 282.79+145.73j, 279.52+147.62j, 276.24+149.51j)
CubicBezier(276.24+149.51j, 277.46+150.01j, 278.69+150.5j, 279.91+151j)
CubicBezier(279.91+151j, 278.52+147.34j, 277.13+143.67j, 275.75+140j)
CubicBezier(275.75+140j, 274.62+137.02j, 269.78+138.31j, 270.92+141.33j)
CubicBezier(270.92+141.33j, 272.31+145j, 273.7+148.66j, 275.09+152.33j)
CubicBezier(275.09+152.33j, 275.66+153.83j, 277.26+154.69j, 278.76+153.83j)
CubicBezier(278.76+153.83j, 282.04+151.94j, 285.32+150.05j, 288.6+148.16j)
CubicBezier(288.6+148.16j, 289.63+147.57j, 289.94+146.44j, 289.75+145.34j)
CubicBezier(289.75+145.34j, 285.92+123.97j, 279.2+103.31j, 269.83+83.74j)
CubicBezier(269.83+83.74j, 268.44+80.84j, 264.12+83.37j, 265.51+86.26j)
Line(265.51+86.26j, 265.51+86.26j)
nf()

## 左头饰
pd(66.6+138.33j, "#E4007F", 3)
CubicBezier(66.6+138.33j, 66.39+150.19j, 66.71+180.68j, 67.67+194.33j)
CubicBezier(67.67+194.33j, 68.84+211.06j, 70.88+226.45j, 73.33+240.33j)
pu()
# 2
f(0j, "#E4007F")
CubicBezier(64.17+86.41j, 48.79+111.28j, 42.7+140.71j, 46.59+169.67j)
CubicBezier(46.59+169.67j, 46.73+170.73j, 48.01+171.5j, 49+171.5j)
CubicBezier(49+171.5j, 54.96+171.5j, 60.93+171.5j, 66.89+171.5j)
CubicBezier(66.89+171.5j, 70.11+171.5j, 70.11+166.5j, 66.89+166.5j)
CubicBezier(66.89+166.5j, 60.93+166.5j, 54.96+166.5j, 49+166.5j)
CubicBezier(49+166.5j, 49.8+167.11j, 50.61+167.72j, 51.41+168.34j)
CubicBezier(51.41+168.34j, 47.7+140.75j, 53.87+112.57j, 68.49+88.93j)
CubicBezier(68.49+88.93j, 70.19+86.18j, 65.87+83.67j, 64.17+86.41j)
Line(64.17+86.41j, 64.17+86.41j)
nf()


tur.hideturtle()  # 隐藏乌龟图标
tur.update()