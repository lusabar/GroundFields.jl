include("GroundFields.jl")
using .GroundFields
using Statistics
using DelimitedFiles
using Combinatorics

struct Permutation
    config::String
    Emax::Number
    Emed::Number
end

const outdir = "abou-seada/"

const R = 2.235e-2
const r = 0.5 * R
const H = 23.622
const AS = 41.25e-2
const x_cond = (AS / 2) + R
const n = 4
const altura = 1
# Voltage line-ground peak
const voltage = 1 # pu
const vlgpk = (345e+3 / sqrt(3)) * sqrt(2)

# Constantes linha estudada
const fase1 = Point(-x_cond, H)
const fase2 = Point(x_cond, H)

# Separação entre condutores
l = 457e-3
# Distância do ponto de fixação aos condutores do feixe
d = l * sqrt(3) / 2

conductor_vector = [
    Conductor(fase1, voltage, r, R, n);
    Conductor(fase2, voltage, r, R, n)
]
(j, ϕ, i) = create_jϕi(conductor_vector)
#(E, x) = calculate_E(j, ϕ, i, 1, 180, 200)

println("Valors ϕ:")
for x in ϕ
    println(x)
end
println("Valors j:")
for x in j
    println(x)
end
println("Valors i:")
for x in i
    println(x)
end


(E, pointvector) = calculate_E(j, ϕ, i, altura, 180, 10)

exit()
Emed = E[1:end, 1]



for i in 1:size(E, 1)
    Emed[i, 1] = mean(E[i, 1:end])
end

local outfile = outdir * "abou-seada" * ".dat"

open(outfile, "w") do io
    #writedlm(io, [x Emed])
    writedlm(io, [getfield.(pointvector, :posx) getfield.(pointvector, :posy) Emed])
end
