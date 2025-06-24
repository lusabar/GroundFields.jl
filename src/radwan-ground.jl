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

#pointvector = create_pointvector(bundle_centers)
pointvector = create_groundlevel_pointvector(1, -100, 100, 401)
#for point in pointvector
#    println(point)
#end


E = calculate_E(j, ϕ, i, pointvector, 720)

Emed = E[1:end, 1]

for i in 1:size(E, 1)
    Emed[i, 1] = rms(E[i, 1:end])
end

outpath = outdir * outfile * "-$(H).dat"

open(outpath, "w") do io
    #writedlm(io, [pointvector Emed])
    writedlm(io, [getfield.(pointvector, :posx) getfield.(pointvector, :posy) Emed])
end
