using Plots
pyplot()

y = rand(10)
plot(
    y, 
    leg=false
)

# annotate!(
#     [
#         (5,  y[5],  text("this is #5", 16, :red, :center)), 
#         (10, y[10], text("this is #10", :right, 20, "courier"))
#     ]
# )
annotate!(
    "5200", 
    xy=(5, y[5]), 
    rotation = 90, 
    ha = "center",
    arrowprops = Dict("width"=>1.0,"headwidth"=>5.0,"shrink"=>0.1,"color"=>"r")
)
