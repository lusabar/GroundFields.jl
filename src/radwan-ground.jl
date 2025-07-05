include("GroundFields.jl")
using .GroundFields
using Statistics, StatsBase
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

function rms_wrong(values::Array)
    return maximum(values) / sqrt(2)
end

const outdir = "results-radwan-ground/"
const outfile = "radwan"

const R = 0.0153
println("R = $R")
const r = 0.05 * R
const H = parse(Float64, ARGS[1])
const B = 12
const D1 = 0.47
const D2 = 0.45
const D3 = 0.45
const yshift = √(D2^2 - (D1 / 2)^2)
const n = 6
# Voltage line-ground peak
# FIX: Ajustar a tensão para o valor de pico da tensão fase-terra
const vlgpk = (500e+3 / sqrt(3)) * sqrt(2)
const va = pol(vlgpk, 0)
const vb = pol(vlgpk, -120)
const vc = pol(vlgpk, 120)

# Conductors
faseA = Point(-B, H)
faseB = Point(0, H)
faseC = Point(B, H)

function bundle3(center::Point, voltage::Number)
    bundle_points = [
        center + Point(D1 / 2, 0);
        center + Point(-D1 / 2, 0);
        center + Point(0, -yshift)
    ]
    bundle_conductors = []
    for point in bundle_points
        bundle_conductors = [bundle_conductors;
            Conductor(point, voltage, r, R, n)
        ]
    end
    return identity.(bundle_conductors)
end

#bundle_centers = [get_bundle_centers(faseA, rb); get_bundle_centers(faseB, rb); get_bundle_centers(faseC, rb)]

conductor_vector = [bundle3(faseA, va); bundle3(faseB, vb); bundle3(faseC, vc)]
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

function create_groundlevel_pointvector(height::Number, lim_inf::Number, lim_sup::Number, n_point::Number)
    vector = []
    for x in range(lim_inf, lim_sup, n_point)
        vector = [vector; Point(x, height)]
    end
    return identity.(vector)
end

const time_points = 720
const x_points = 41

#pointvector = create_pointvector(bundle_centers)
pointvector = create_groundlevel_pointvector(1, -100, 100, x_points)
#for point in pointvector
#    println(point)
#end
#

E = calculate_E(j, ϕ, i, pointvector, time_points)

Emed = E[:, 1]

for i in 1:size(E, 1)
    Emed[i, 1] = rms(E[i, :])
end

outpath = outdir * outfile * "-$(H).dat"
#outpath = outdir * "radwan_time_rms.dat"

open(outpath, "w") do io
    #writedlm(io, [pointvector Emed])
    #writedlm(io, [getfield.(pointvector, :posx) getfield.(pointvector, :posy) Emed])
    writedlm(io, [getfield.(pointvector, :posx) getfield.(pointvector, :posx) Emed]) # não Campo elétrico em kV/m
end

exit()


# Single Point
E_0_1 = E[20, :]
t = range(0, 16.67, time_points)
x = range(-60, 60, x_points)

# x y z
# x E t
xet = [1 2 3]
for k in 1:length(E[:, 1])
    for i in 1:length(t)
        global xet = [xet; x[k] (E[k, i]/1000) t[i]] # Campo elétrico em kV/m
    end
end

open(outdir * "radwan_time.dat", "w") do io
    #writedlm(io, [t E_0_1])
    writedlm(io, xet[2:end, :])
end
