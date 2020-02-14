# Implementing a test for the RGB-d dataset
# 148x148 - one layer

# using CUDArt
using CUDAdrv
# device(3)

# CUDNN->CuArrays
using Knet, MAT, ArgParse, CuArrays


function cbf(
		x
		; f = :relu
		, w = Xavier()
		, b = Constant(0)
		, p = 1
		, out = 0
		, oparams…
	)
	v = par(; oparams… , init = w, out=out)
	y = conv(v,x; padding = p, mode = CUDNN_CROSS_CORRELATION)
	z = bias4(y; binit=b, outDim = out, oparams…)
	return f(z; oparams…)
end


function bias4(
		x
		; binit = Constant(0)
		, outDim = 0
		, oparams…
	)
	b = par(; oparams…, init=binit)
	return b+x
end


function cb(
		x
		; w = Xavier()
		, b = Constant(0)
		, p = 0
		, s = 1
		, oparams…
	)
	v = par(; oparams… , init = w)
	y = conv(v,x; padding = p, stride = s, mode = CUDNN_CROSS_CORRELATION)
	return bias4(y; binit =b,oparams…)
end


function cbfp(
		x
		; f=:relu
		, cwindow = 0
		, pwindow = 0
		, oparams…
	)
	y = wconv(x; oparams…, window=cwindow)
	z = bias4(y; oparams…)
	return f(z; oparams…)
end


function vgg_model(x0; weights=0)
	x1 = cbf(x0; w = map(Float32,weights["w1_1"]), b = reshape(map(Float32,weights["b1_1"]) ,1,1,size(weights["b1_1"],1),1), out=64)

	x2 = cbf(x1; w = map(Float32,weights["w1_2"]), b = reshape(map(Float32,weights["b1_2"]) ,1,1,size(weights["b1_2"],1),1), out=64)

	x3 = pool(x2; window = 2)

	x4 = cbf(x3; w = map(Float32,weights["w2_1"]), b = reshape(map(Float32,weights["b2_1"]) ,1,1,size(weights["b2_1"],1),1), out=128)

	x5 = cbf(x4; w = map(Float32,weights["w2_2"]), b = reshape(map(Float32,weights["b2_2"]) ,1,1,size(weights["b2_2"],1),1), out=128)

	x6 = pool(x5; window = 2)

	x7 = cbf(x6; w = map(Float32,weights["w3_1"]), b = reshape(map(Float32,weights["b3_1"]) ,1,1,size(weights["b3_1"],1),1), out=256)

	x8 = cbf(x7; w = map(Float32,weights["w3_2"]), b = reshape(map(Float32,weights["b3_2"]) ,1,1,size(weights["b3_2"],1),1), out=256)

	x9 = cbf(x8; w = map(Float32,weights["w3_3"]), b = reshape(map(Float32,weights["b3_3"]) ,1,1,size(weights["b3_3"],1),1), out=256)

	x10 = pool(x9; window = 2)

	x11 = cbf(x10; w = map(Float32,weights["w4_1"]), b = reshape(map(Float32,weights["b4_1"]) ,1,1,size(weights["b4_1"],1),1), out=512)

	x12 = cbf(x11; w = map(Float32,weights["w4_2"]), b = reshape(map(Float32,weights["b4_2"]) ,1,1,size(weights["b4_2"],1),1), out=512)

	x13 = cbf(x12; w = map(Float32,weights["w4_3"]), b = reshape(map(Float32,weights["b4_3"]) ,1,1,size(weights["b4_3"],1),1), out=512)

	x14 = pool(x13; window = 2)

	x15 = cbf(x14;w = map(Float32,weights["w5_1"]), b = reshape(map(Float32,weights["b5_1"]) ,1,1,size(weights["b5_1"],1),1), out=512)

	x16 = cbf(x15; w = map(Float32,weights["w5_2"]), b = reshape(map(Float32,weights["b5_2"]) ,1,1,size(weights["b5_2"],1),1), out=512)

	x17 = cbf(x16; w = map(Float32,weights["w5_3"]), b = reshape(map(Float32,weights["b5_3"]) ,1,1,size(weights["b5_3"],1),1), out=512)

	x18 = pool(x17; window = 2)

	return cbf(x18;w = map(Float32,weights["w6"]), b = reshape(map(Float32,weights["b6"]) ,1,1,size(weights["b6"],1),1), f=:relu, p=0)

	#x20 = cbf(x19; w= w77, b=b77, f=:relu, out=4096, p=0)
	#return wbf(x20; out = 51, f=:soft)
end


function Knettest(args=ARGS)
	#info(“Testing vgg’s code on RGB-d dataset”)
	s = ArgParseSettings()
	@add_arg_table s begin
		("–seed"; arg_type=Int; default=42)
		("–nbatch"; arg_type=Int; default=100)
		("–lr"; arg_type=Float64; default=0.00001)
		("–epochs"; arg_type=Int; default=5)
		("–gcheck"; arg_type=Int; default=0)
	end
	isa(args, AbstractString) && (args=split(args))
	opts = parse_args(args, s)
	println(opts)
	for (k,v) in opts; @eval ($(symbol(k))=$v); end
	seed > 0 && setseed(seed)

	xtrnFile = matopen("Train3DSplit1Reshaped.mat")
	xtrn = read(xtrnFile,"Train3DSplit1Reshaped")
	xtrn = map(Float32,xtrn)
	println(size(xtrn))

	xtstFile = matopen("Test3DSplit1Reshaped.mat")
	xtst = read(xtstFile,"Test3DSplit1Reshaped")
	xtst = map(Float32,xtst)
	println(size(xtst))

	#xdevFile = matopen("DevRGBSplit1.mat")
	#xdev = read(xdevFile,"DevRGBSplit1")
	#xdev = map(Float32,xdev)
	#println(size(xdev))

	ytrnFile = matopen("Train3DSplit1LabelsMat.mat")
	ytrn = read(ytrnFile,"Train3DSplit1LabelsMat")
	ytrn = map(Float32,ytrn)

	ytstFile = matopen("Test3DSplit1LabelsMat.mat")
	ytst = read(ytstFile,"Test3DSplit1LabelsMat")
	ytst = map(Float32,ytst)

	#ydevFile = matopen("DevRGBSplit1LabelsMat.mat")
	#ydev = read(ydevFile,"DevRGBSplit1LabelsMat")
	#ydev = map(Float32,ydev)


	file = matread("vgg-verydeep-16.mat")


	rxtrn = mean(xtrn[:,:,1,:]);
	gxtrn = mean(xtrn[:,:,2,:]);
	bxtrn = mean(xtrn[:,:,3,:]);

	println(rxtrn);
	println(gxtrn);
	println(bxtrn);


	xtrn[:,:,1,:] = xtrn[:,:,1,:] - rxtrn;
	xtrn[:,:,2,:] = xtrn[:,:,2,:] - gxtrn;
	xtrn[:,:,3,:] = xtrn[:,:,3,:] - bxtrn;

	xtst[:,:,1,:] = xtst[:,:,1,:] - rxtrn;
	xtst[:,:,2,:] = xtst[:,:,2,:] - gxtrn;
	xtst[:,:,3,:] = xtst[:,:,3,:] - bxtrn;


	global dtrn = minibatch(xtrn, ytrn, nbatch)
	global dtst = minibatch(xtst, ytst, nbatch)

	global vgg = compile(:vgg_model; weights=file)
	#tic()
	dim = 1;fmaps = 4096;
	xtrnsize =size(xtrn,4)
	xtrnzerosize = xtrnsize + nbatch - xtrnsize%nbatch;#map(Int64, (xtrnsize/nbatch +1)*nbatch);
	println(xtrnzerosize)
	xtrnZeroPad = zeros(size(xtrn,1),size(xtrn,2),size(xtrn,3),xtrnzerosize)
	for x=1:size(xtrn,4)
		xtrnZeroPad[:,:,:,x] = xtrn[:,:,:,x]
	end
	println(size(xtrn))
	println(size(xtrnZeroPad))
	xtrnZeroPad = map(Float32, xtrnZeroPad)
	xtrnFeatures = zeros(dim,dim,fmaps,xtrnzerosize)
	for item = 1:nbatch:size(xtrn,4)
		ypred = forw(vgg, xtrnZeroPad[:,:,:,item:item+nbatch-1])
		xtrnFeatures[:,:,:,item:item+nbatch-1] = to_host(ypred)
	end

	xtrnFeatures = xtrnFeatures[:,:,:,1:xtrnsize]

	filetrn = matopen("TrainRGBSplit1Features1.mat", "w")
	write(filetrn, "TrainRGBSplit1Features1", xtrnFeatures)
	close(filetrn)

	xtrnFeatures = 0;
	xtrnZeroPad = 0;
	gc();

	xtstsize =size(xtst,4)
	xtstzerosize = xtstsize + nbatch - xtstsize%nbatch;#map(Int64,(xtstsize/nbatch +1)*nbatch);
	println(xtrnzerosize)
	xtstZeroPad = zeros(size(xtst,1),size(xtst,2),size(xtst,3),xtstzerosize)
	for x=1:size(xtst,4)
		xtstZeroPad[:,:,:,x] = xtst[:,:,:,x]
	end

	println(size(xtst))
	println(size(xtstZeroPad))
	xtstZeroPad = map(Float32, xtstZeroPad)
	xtstFeatures = zeros(dim,dim,fmaps,xtstzerosize)
	for item = 1:nbatch:size(xtst,4)
		ypred = forw(vgg, xtstZeroPad[:,:,:,item:item+nbatch-1])
		xtstFeatures[:,:,:,item:item+nbatch-1] = to_host(ypred)
	end

	xtstFeatures = xtstFeatures[:,:,:,1:xtstsize]

	println(size(xtstFeatures))
	println(size(xtrnFeatures))
	filetst = matopen("TestRGBSplit1Features1.mat", "w")
	write(filetst, "TestRGBSplit1Features1", xtstFeatures)
	close(filetst)

	#xdevZeroPad = zeros(size(xdev,1),size(xdev,2),size(xdev,3),7040)
	#for x=1:size(xdev,4)
	#	xdevZeroPad[:,:,:,x] = xdev[:,:,:,x]
	#end

	#xdevFeatures = zeros(dim,dim,fmaps,7040)
	#for item = 1:nbatch:size(xdev,4)
	#	ypred = forw(vgg, xdevZeroPad[:,:,:,item:item+nbatch-1]; trn=false)
	#	xdevFeatures[:,:,:,item:item+nbatch-1] = to_host(ypred)
	#end

	#xdevFeatures = xdevFeatures[:,:,:,1:6982]

	#filedev = matopen("DevRGBSplit1Features1.mat", "w")
	#write(filedev, "DevRGBSplit1Features1", xdevFeatures)
	#close(filedev)
	#println(toc())
	setp(vgg; lr=lr)

	#l=zeros(2); m=zeros(2)
	#for epoch=1:epochs
	#	tic();
	#    train(vgg,dtrn,softloss; losscnt=fill!(l,0), maxnorm=fill!(m,0))
	#    atrn = 1-test(vgg,dtrn,zeroone)
	#    atst = 1-test(vgg,dtst,zeroone)
	#    println((epoch, atrn, atst, l[1]/l[2], m...))
	#     println(toc())
	#    gcheck > 0 && gradcheck(vgg, f->getgrad(f,dtrn,softloss), f->getloss(f,dtrn,softloss); gcheck=gcheck)
	#end
	#return (l[1]/l[2],m...)
end


function train(f, data, loss; losscnt=nothing, maxnorm=nothing)
	for (x,ygold) in data
		ypred = forw(f, x)
		#println(to_host(size(ypred)))
		back(f, ygold, loss)
		update!(f)
		losscnt[1] += loss(ypred, ygold); losscnt[2] += 1
		w=wnorm(f); w > maxnorm[1] && (maxnorm[1]=w)
		g=gnorm(f); g > maxnorm[2] && (maxnorm[2]=g)
	end
end


function test(f, data, loss)
	sumloss = numloss = 0
	for (x,ygold) in data
		ypred = forw(f, x)
		sumloss += loss(ypred, ygold)
		numloss += 1
	end
	sumloss / numloss
end


function minibatch(x, y, batchsize)
	data = Any[]
	for i=1:batchsize:ccount(x)-batchsize+1
		j=i+batchsize-1
		push!(data, (cget(x,i:j), cget(y,i:j)))
	end
	return data
end


function getgrad(f, data, loss)
	(x,ygold) = first(data)
	ypred = forw(f, x)
	back(f, ygold, loss)
	loss(ypred, ygold)
end


function getloss(f, data, loss)
	(x,ygold) = first(data)
	ypred = forw(f, x)
	loss(ypred, ygold)
end


!isinteractive() && !isdefined(:load_only) && Knettest(ARGS)