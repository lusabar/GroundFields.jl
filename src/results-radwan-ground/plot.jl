using Glob
using DelimitedFiles
using Plots
using GMT


data = readdlm("radwan-10.0.dat")
Plots.plot!(data[:, 1], data[:, 3], label="H=10", color="#841084")
println("Max(H=10): $(maximum(data[:,3]))")
real = 10300
println("Erro: $(abs(maximum(data[:,3]) - real)*100/real)%\n")

data = readdlm("radwan-12.0.dat")
Plots.plot!(data[:, 1], data[:, 3], label="H=12", color="#1010f9")
println("Max(H=12): $(maximum(data[:,3]))")
real = 8016
println("Erro: $(abs(maximum(data[:,3]) - real)*100/real)%\n")

data = readdlm("radwan-15.0.dat")
Plots.plot!(data[:, 1], data[:, 3], label="H=15", color="#ac5e50")
println("Max(H=15): $(maximum(data[:,3]))")
real = 5729
println("Erro: $(abs(maximum(data[:,3]) - real)*100/real)%\n")

data = readdlm("radwan-19.1.dat")
Plots.plot!(data[:, 1], data[:, 3], label="H=19.1", color="#f910f9")
println("Max(H=19.1): $(maximum(data[:,3]))")
real = 3856
println("Erro: $(abs(maximum(data[:,3]) - real)*100/real)%\n")

data = readdlm("radwan-25.0.dat")
Plots.plot!(data[:, 1], data[:, 3], label="H=25", color="#101084")
println("Max(H=25): $(maximum(data[:,3]))")
real = 2389
println("Erro: $(abs(maximum(data[:,3]) - real)*100/real)%\n")

savefig("plot-radwan-fig12.pdf")
