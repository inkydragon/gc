import taichi as ti

ti.init()

a = ti.var(dt=ti.f32, shape=(42, 63)) # A tensor of 42x63 scalars
b = ti.Vector(3, dt=ti.f32, shape=4)  # A tensor of  4x3D vectors
C = ti.Matrix(2, 2, dt=ti.f32, shape=(3, 5)) # A tensor of 3x5, 2x2 matrices
loss = ti.var(dt=ti.f32, shape=()) # A (0−D) tensor of a single scalar

a[3, 4] = 1
print('a[3,4]=', a[3, 4])
# "a[3,4]= 1.0"

b[2] = [6, 7, 8]
print('b[0]=', b[0][0], b[0][1], b[0][2])
# "b[0]= 0.0 0.0 0.0"
# print(b[0]) is not yet supported.

loss[None] = 3
print(loss[None])
# "3.0"
