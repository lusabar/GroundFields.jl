using Plots
using DelimitedFiles

data_tri = readdlm("tri-camargo.dat")
data_hexa = readdlm("hexa-camargo.dat")

plotMax = plot(data_hexa[:, 1], [data_tri[:, 2] data_hexa[:, 2]],
    label=["Trifásico Camargo (abccba)" "Hexa Camargo (abcdef)"]
)

savefig("ouput.svg")
