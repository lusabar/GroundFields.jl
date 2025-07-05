using Glob
using DelimitedFiles
using Plots

files = glob("*.dat", ".")

for file in files
    data = readdlm(file)
    plot!(data[:, 1], data[:, 2], label=false)
end
savefig("plot-hexa-720.pdf")
