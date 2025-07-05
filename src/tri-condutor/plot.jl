#using Plots;
using DelimitedFiles
using CairoMakie
using Random

data = readdlm("abcabc-simples.dat")
x = data[:, 1]
y = data[:, 2]
z = data[:, 3]
f, ax, tr = tricontourf(x, y, z)
CairoMakie.scatter!(x, y, color=z, strokewidth=1, strokecolor=:black)
Colorbar(f[1, 2], tr)
f
save("single-abcabc.pdf", f)
