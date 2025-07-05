using Plots, DelimitedFiles

data = readdlm("abcabc.dat")
scatter(data[:, 1], data[:, 2], markersize=0.05)

savefig("test.pdf")

