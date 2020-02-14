# using Pkg
# Pkg.add("DataFrames")

using DataFrames

julia_test = reshape(collect(1:16),4,4)
df = DataFrame(julia_test)
names!(df, [Symbol(i) for i in ["A","B","C","D"]])
julia_test
df
df[1:2, [:A,:B]]

