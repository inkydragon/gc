using Plots

# p00=[0,0,0]
# p10=[6,1,1]
# p01=[1,5,7]
# p11=[7,7,4]
# Px=[0 1
#    6 7]
# Py=[0 5
#    1 7]
# Pz=[0 7
#    1 4]
# 
# k=32
# u=range(0,stop=1,length=k)
# v=range(0,stop=1,length=k)
# 
# t1 = range(0, stop=π, length=50)
# t2 = range(0, stop=2π, length=50)
# 
# X = Px * hcat(1 .- u, u)' * hcat(1 .- v, v)
# # 2×2 Array{Float64,2}:
# #    5.16129   10.8387
# #    101.161    106.839
# 
# x(u,v)=(Px*[1 .- u,u])'*[1 .-v,v]
# y(u,v)=(Py*[1-u,u])'*[1-v,v]
# z(u,v)=(Pz*[1-u,u])'*[1-v,v]
# S(u,v)=[x(u,v),y(u,v),z(u,v)]
# 
# plot(Px,Py,Pz,xlabel="x",ylabel="y",zlabel="z",legend=false)
# plot!(Px',Py',Pz')

x(u, v) = cos(u)
y(u, v) = sin(u) * cos(v)
z(u, v) = sin(u) * sin(v)

U = 0:0.1:2π
V = 0:0.1:π
XX = x.(U, V')
YY = y.(U, V')
ZZ = z.(U, V')

pyplot()
surface(XX, YY, ZZ)
