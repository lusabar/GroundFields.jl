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

const outdir = "results-radwan-conductor/"
const outfile = "radwan"

const R = 0.0153
println("R = $R")
const r = 0.05 * R
const H = 10
const B = 12
const D1 = 0.47
const D2 = 0.45
const D3 = 0.45
const yshift = √(D2^2 - (D1 / 2)^2)

const Hsh = 15
const Rsh = 0.0039
const rsh = 0.05 * Rsh
const S = 5
const n = 6
# Voltage line-ground peak
const vlgpk = (500e+3 / sqrt(3)) * sqrt(2)
const va = pol(vlgpk, 0)
const vb = pol(vlgpk, -120)
const vc = pol(vlgpk, 120)

# Conductors
const faseA = Point(-B, H)
const faseB = Point(0, H)
const faseC = Point(B, H)
const shield1 = Point(-B, Hsh)
const shield2 = Point(0, Hsh)
const shield3 = Point(B, Hsh)

function bundle3(center::Point, voltage::Number)
    bundle_points = [
        center + Point(-D1 / 2, 0);
        center + Point(0, -yshift);
        center + Point(D1 / 2, 0)
    ]
    bundle_conductors = []
    for point in bundle_points
        bundle_conductors = [bundle_conductors;
            Conductor(point, voltage, r, R, n)
        ]
    end
    return identity.(bundle_conductors)
end

function bundle3_shield(center::Point, voltage::Number)
    bundle_points = [
        center + Point(-S, 0);
        center;
        center + Point(S, 0)
    ]
    bundle_shields = []
    for point in bundle_points
        bundle_shields = [bundle_shields;
            Conductor(point, voltage, rsh, Rsh, n)
        ]
    end
    return identity.(bundle_shields)
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
shield_vector = [bundle3_shield(shield1, 0); bundle3_shield(shield2, 0); bundle3_shield(shield3, 0)]

conductor_vector = [conductor_vector; shield_vector]

(j, ϕ, i) = create_jϕi(conductor_vector)
#(E, x) = calculate_E(j, ϕ, i, 1, 180, 200)

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

function create_pointvector_around_conductor(center::Point, n_points::Integer, raio::Number)
    vector = []
    global θ = range(0, π, n_points)
    println("θ:")
    for ang in θ
        println(rad2deg(ang))
    end
    ϕ = θ .- π / 2
    println("ϕ:")
    for ang in ϕ
        println(rad2deg(ang))
        vector = [vector;
            center + Point(raio * cos(ang), raio * sin(ang))
        ]
    end

    return identity.(vector)
end

function create_pointvector_around_conductorA(center::Point, n_points::Integer, raio::Number)
    vector = []
    θ = range(0, π, n_points)
    println("θ:")
    for ang in θ
        println(rad2deg(ang))
    end
    ϕ = range(deg2rad(-90), deg2rad(-270), n_points)
    println("ϕ:")
    for ang in ϕ
        println(rad2deg(ang))
        vector = [vector;
            center + Point(raio * cos(ang), raio * sin(ang))
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
pointvector_center = create_pointvector_around_conductor(faseB + Point(0, -yshift), 7, Rsh)
pointvector_outer = create_pointvector_around_conductor(faseC + Point(0, -yshift), 7, Rsh)
pointvector_outerA = create_pointvector_around_conductor(faseA + Point(0, -yshift), 7, Rsh)
pointvector = [pointvector_center; pointvector_outer; pointvector_outerA]
#for point in pointvector
#    println(point)
#end

E = calculate_E(j, ϕ, i, pointvector, 720)

Emed = E[1:end, 1]

for i in 1:size(E, 1)
    Emed[i, 1] = rms(E[i, 1:end]) / 1e5 # Para resultado em kv/cm
end

outpath = outdir * outfile * ".dat"

open(outpath, "w") do io
    #writedlm(io, [pointvector Emed])
    writedlm(io, [rad2deg.(θ) 0.5 * Emed[1:7] 0.5 * Emed[8:14] 0.5 * Emed[15:21]])
end
