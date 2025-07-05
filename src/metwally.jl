include("GroundFields.jl")
using .GroundFields
using Statistics
using DelimitedFiles
using Combinatorics

function rms(values::Array)
    n = length(values)
    squared_sum = 0
    for value in values
        squared_sum = squared_sum + value^2
    end
    return sqrt(squared_sum / n)
end

const outdir = "results-metwally/"

const R = sqrt(642 / π) * 1e-3
println("R = $R")
const r = 0.5 * R
const H = 39
const X = 15.8
const rb = 0.32
const n = 30
# Voltage line-ground peak
const vlgpk = (800e+3 / sqrt(3)) * sqrt(2)
const va = pol(vlgpk, 0)
const vb = pol(vlgpk, -120)
const vc = pol(vlgpk, 120)

# Conductors
faseA = Point(-X, H)
faseB = Point(0, H)
faseC = Point(X, H)

function bundle6(center::Point, voltage::Number, rb::Number)
    bundle = []
    for i in 0:5
        ϕ = deg2rad(i * 60)
        bundle = [bundle;
            Conductor(center + Point(rb * cos(ϕ), rb * sin(ϕ)), voltage, r, R, n)
        ]
    end
    return identity.(bundle)
end

function get_bundle_centers(center::Point, rb::Number)
    bundle_centers = []
    for i in 0:5
        ϕ = deg2rad(i * 60)
        bundle_centers = [bundle_centers;
            center + Point(rb * cos(ϕ), rb * sin(ϕ))
        ]
    end
    return identity.(bundle_centers)
end


bundle_centers = [get_bundle_centers(faseA, rb); get_bundle_centers(faseB, rb); get_bundle_centers(faseC, rb)]

conductor_vector = [bundle6(faseA, va, rb); bundle6(faseB, vb, rb); bundle6(faseC, vc, rb)]
(j, ϕ, i) = create_jϕi(conductor_vector)
#(E, x) = calculate_E(j, ϕ, i, 1, 180, 200)

#println("Valors ϕ:")
#for x in ϕ
#    println(x)
#end
#println("Valors j:")
#for x in j
#    println(x)
#end
#println("Valors i:")
#for x in i
#    println(x)
#end

function create_pointvector(bundle_centers::Vector{Point})
    vector = []
    for center in bundle_centers
        vector = [vector;
            center + Point(R, 0);
            center + Point(0, R);
            center + Point(-R, 0);
            center + Point(0, -R)
        ]
    end
    return identity.(vector)
end

pointvector = create_pointvector(bundle_centers)
for point in pointvector
    println(point)
end


E = calculate_E(j, ϕ, i, pointvector, 180)

Emed = E[1:end, 1]

for i in 1:size(E, 1)
    Emed[i, 1] = rms(E[i, 1:end])
end

outfile = outdir * "metwally" * ".dat"

open(outfile, "w") do io
    #writedlm(io, [pointvector Emed])
    writedlm(io, [getfield.(pointvector, :posx) getfield.(pointvector, :posy) Emed / 1e5]) # Resultado em kV/cm
end

#open(outfile, "w") do io
#    #writedlm(io, [x Emed])
#    writedlm(io, [getfield.(pointvector, :posx) getfield.(pointvector, :posy) Emed])
#end
