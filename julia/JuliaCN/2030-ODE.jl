using LinearAlgebra
using OrdinaryDiffEq
using Interpolations

function ode()

	global A, B, M, R, Pt, xf, uf, Wcfinal
	global T, Tf # ODE paramters
	global αa, αc # GD parameters
	global uDelay, x1Delay, x2Delay, x3Delay, Quu, Qxu
	global x_save, t_save
	global uvec

    n = 3
    m = 1
    A = [-1.01887 0.90506 -0.00215; 0.82225 -1.07741 -0.17555; 0 0 -1] # n x n
    B = reshape([0.0; 0.0; 1.0], (3, 1)) # n x m

    M = Matrix(I, n, n) # n x n
    R = 0.1*Matrix(I, m, m) # m x m
    Pt = 0.5*Matrix(I, n, n) 

    # ODE parameters
    Tf = 45 # finite horizon
    T = 0.05
    N = 900 # T/dt

    αc = 90
    αa = 2.5

    WC0 = [10.0*ones(convert(Int64, (n + m)*(n + m + 1)/2 - m*m), 1); reshape(R, (m*m, 1))] # (n+m)(n+m+1)/2 x 1
	Wc0 = zeros(10,)
	Wc0 = WC0[:]
	Wa0 = 0.5*ones(n,) # n x m
    u0 = 5.0*ones(m,) # m x 1
    uf = 0.001 
    Wcfinal = 12.0*ones(convert(Int64, (n + m)*(n + m + 1)/2),)

    x0 = [1.0; 5.0; 1.0]
    xf = [2.0; 7.0; 3.0]

	Quu = 0
	Qxu = 0

    p0 = x0'*M*x0

    t_save = []
    u_save = [u0; u0]
    x_save = zeros(17, 1)
	x_save[:, 1] = [x0; Wc0; Wa0; p0]
    # println("x_save = $x_save")

    uDelay  = interp2PWC(u_save[:], -1, 1) # return an interpolation function
    x1Delay = interp2PWC(x_save[1, :], -1, 1)
    x2Delay = interp2PWC(x_save[2, :], -1, 1)
    x3Delay = interp2PWC(x_save[3, :], -1, 1)

    # solve ODEs
	for i = 1:3

		t = ((i-1)*T, i*T)
        # p = (A = A, B = B, M = M, R = R, Pt = Pt, Tf = Tf, T = T, αa = αa, αc = αc, Quu = Quu, Qxu = Qxu, xf = xf, uf = uf, Wcfinal = Wcfinal, uDelay = uDelay, x1Delay = x1Delay, x2Delay = x2Delay, x3Delay = x3Delay, x_save = x_save, t_save = t_save)	       
		# p = (xf, uf, Tf, T, A, B, M, R, Pt, αa, αc, Quu, Qxu, Wcfinal, uDelay, x1Delay, x2Delay, x3Delay, x_save, t_save)	       
		# prob = ODEProblem(babyETC, x_save[:, end], t, para)
		p = []
        sol = solve(ODEProblem(f, x_save[:, end], t, p), DP5())

        t_save = vcat(t_save, sol.t[end]) # save time
		# global solu
		solu = sol.u
		solt = sol.t
		println("sol.u = $solu")
		println("sol.t = $solt")
        x_save = hcat(x_save, sol.u[end]) # save state

        uDelay  = interp2PWC(uvec, -1, i*T+.01) # interpolate control input
        x1Delay = interp2PWC(x_save[1, :], -1, i*T+.01)
        x2Delay = interp2PWC(x_save[2, :], -1, i*T+.01)
        x3Delay = interp2PWC(x_save[3, :], -1, i*T+.01)
	end

    # plot(t_save, x_save[1, :])
	# println("t_save = $t_save")
	x_save_1 = x_save[1, :]
	x_save_2 = x_save[2, :]
	x_save_3 = x_save[3, :]
	# println("x1 = $x_save_1")
	# println("x2 = $x_save_2")
	# println("x3 = $x_save_3")
	# plot(t_save, x_save[:, 1])
	# plot!(t_save, x_save[:, 2])
	# plot!(t_save, x_save[:, 3])

end

function f(dotx, x, p, t)

	# global A, B, M, R, Pt, xf, uf, Wcfinal, uvec
	# global T, Tf
	# global αa, αc
	# global uDelay, x1Delay, x2Delay, x3Delay, Quu, Qxu
	global uvec
    n = 3
    m = 1
	println("$x")
	Wc = x[(n+1) : convert(Int64, (n+(n+m)*(n+m+1)/2))]
    Wa = x[convert(Int64, (n+(n+m)*(n+m+1)/2+1)) : convert(Int64, (n+(n+m)*(n+m+1)/2+n))]
    P = x[end]
    uvec = []

	UkUfinal = vcat(xf[1]^2, xf[1]*xf[2], xf[1]*xf[3], xf[1]*uf,
				xf[2]^2, xf[2]*xf[3], xf[2]*uf,
				xf[3]^2, xf[3]*uf,
				uf^2)
    Pfinal = 0.5*xf'*Pt*xf
	
    ud = zeros(m,)
	ud[1] = Wa'*(x[1:n] - xf)

    uddelay = zeros(m,)
	uddelay[1] = uDelay(t - T)
    xdelay = zeros(n,)
	xdelay[1] = x1Delay(t - T)
    xdelay[2] = x2Delay(t - T)
    xdelay[3] = x3Delay(t - T)

	U = vcat(x[1:n] - xf, ud) # augmented state
    UkU = vcat(U[1]^2, U[1]*U[2], U[1]*U[3], U[1]*ud,
               U[2]^2, U[2]*U[3], U[2]*ud,
               U[3]^2, U[3]*ud,
               ud[1]^2)
    UkUdelay = vcat(xdelay[1]^2, xdelay[1]*xdelay[2], xdelay[1]*xdelay[3], xdelay[1]*uddelay,
                    xdelay[2]^2, xdelay[2]*xdelay[3], xdelay[2]*uddelay,
                    xdelay[3]^2, xdelay[3]*uddelay,
                    uddelay[1]^2)

    Quu = R # m x m
    Quu_inv = inv(Quu)
    Qxu = reshape(Wc[convert(Int64, (n+m)*(n+m+1)/2-m^2-m*n+1):convert(Int64, (n+m)*(n+m+1)/2-m^2)], (n, m)) # n x m
    Qux = Qxu' # m x n
	
    σ = UkU - UkUdelay

	dP = 0.5*((x[1:n] - xf)'*M*(x[1:n] - xf) - xdelay'*M*xdelay + ud'*R*ud - uddelay'*R*uddelay)

    ec = P + Wc'*UkU - Wc'*UkUdelay 
	ecfinal = Pfinal - Wcfinal'*UkUfinal 
    ea = Wa'*U[1:n] + [Quu_inv*Qux[:,1]; Quu_inv*Qux[:,2]; Quu_inv*Qux[:,3]]'*U[1:n] 

	dWc = -αc*((σ./((σ'*σ+1).^2))*ec + (UkUfinal./((UkUfinal'*UkUfinal+1).^2))*ecfinal)

    dWa = -αa*U[1:n]*ea'

	dx = A*U[1:n] + B*ud

	# augmented state
    dotx = vcat(dx, dWc, dWa, dP)
	# println("$dotx")

	uvec = [ud]
	# println("$uvec")

	# println("$t")

end

function interp2PWC(y, xi, xf)

    row = size(y, 1)
	if row == 1
	    xdata = range(-1.0, stop = xf, length = row + 1) # linspace in MATLAB
		itp = interpolate([y[1];y[end]], BSpline(Cubic(Line(OnGrid()))))
	else
		xdata = range(xi, stop = xf, length = row)
		itp = interpolate(y, BSpline(Cubic(Line(OnGrid()))))
	end
	scale(itp, xdata)

end

ode()
