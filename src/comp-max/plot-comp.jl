using Glob
using DelimitedFiles
using Plots

file = ["edcbaf.dat"; "bfdace.dat"; "baccab.dat"; "bacbac.dat"]

#for file in files
#    data = readdlm(file)
#    plot!(data[:, 1], data[:, 2], label=false)
#end


data = readdlm(file[1])
plot!(data[:, 1], data[:, 2], label=file[1], color=:orange, marker=:circle)
data = readdlm(file[2])
plot!(data[:, 1], data[:, 2], label=file[2], color=:orange)
data = readdlm(file[3])
plot!(data[:, 1], data[:, 2], label=file[3], color=:blue)
data = readdlm(file[4])
plot!(data[:, 1], data[:, 2], label=file[4], color=:blue)

savefig("plot-comp.pdf")
