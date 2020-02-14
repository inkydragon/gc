using Plots
gr()

plot(Plots.fakedata(50,5),w=3)
savefig("my_plot.pdf")
