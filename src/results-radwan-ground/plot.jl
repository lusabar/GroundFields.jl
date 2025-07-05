using Glob
using DelimitedFiles
using Plots
using GMT

data = readdlm("radwan-10.0.dat")
Plots.plot!(data[:, 1], data[:, 3], label="H=10", color="#841084")
println("Max(H=10): $(maximum(data[:,3]))")
max1 = maximum(data[:, 3])
real = 10300
real1 = real
println("Erro: $(abs(maximum(data[:,3]) - real)*100/real)%\n")

data = readdlm("radwan-12.0.dat")
Plots.plot!(data[:, 1], data[:, 3], label="H=12", color="#1010f9")
println("Max(H=12): $(maximum(data[:,3]))")
max2 = maximum(data[:, 3])
real = 8016
real2 = real
println("Erro: $(abs(maximum(data[:,3]) - real)*100/real)%\n")

data = readdlm("radwan-15.0.dat")
Plots.plot!(data[:, 1], data[:, 3], label="H=15", color="#ac5e50")
println("Max(H=15): $(maximum(data[:,3]))")
max3 = maximum(data[:, 3])
real = 5729
real3 = real
println("Erro: $(abs(maximum(data[:,3]) - real)*100/real)%\n")

data = readdlm("radwan-19.1.dat")
Plots.plot!(data[:, 1], data[:, 3], label="H=19.1", color="#f910f9")
println("Max(H=19.1): $(maximum(data[:,3]))")
max4 = maximum(data[:, 3])
real = 3856
real4 = real
println("Erro: $(abs(maximum(data[:,3]) - real)*100/real)%\n")

data = readdlm("radwan-25.0.dat")
Plots.plot!(data[:, 1], data[:, 3], label="H=25", color="#101084")
println("Max(H=25): $(maximum(data[:,3]))")
max5 = maximum(data[:, 3])
real = 2389
real5 = real
println("Erro: $(abs(maximum(data[:,3]) - real)*100/real)%\n")

println("Relação Obtida: $(max1/max5):$(max2/max5):$(max3/max5):$(max4/max5):$(max5/max5)")
println("Relação Radwan: $(real1/real5):$(real2/real5):$(real3/real5):$(real4/real5):$(real5/real5)")

title!("Campo elétrico a 1m do solo: Radwan Fig.12")
xlabel!("Distância horizontal da torre [m]")
ylabel!("Campo elétrico [V/m]")

savefig("plot-radwan-fig12.pdf")
