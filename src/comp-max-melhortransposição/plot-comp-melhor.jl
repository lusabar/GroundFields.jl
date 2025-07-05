using Glob
using DelimitedFiles
using Plots

hexa_config = "acfdbe"
n = length(hexa_config)
all_shifts = [hexa_config[(n-i+1):n] * hexa_config[1:(n-i)] for i in 0:n-1]

fileshexa = "../hexa-todos/" .* all_shifts .* ".dat"

for file in fileshexa
    data = readdlm(file)
    plot!(data[:, 1], data[:, 2], label=file, color=:orange)
end

filestri = ["bacbac.dat"; "cbacba.dat"; "acbacb.dat"]
filestri = "../tri-todos/" .* filestri


for file in filestri
    data = readdlm(file)
    plot!(data[:, 1], data[:, 2], label=file, color=:blue)
end

savefig("plot-comp-melhortransposição.pdf")
