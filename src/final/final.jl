include("../GroundFields.jl")
using .GroundFields
using Statistics
using DelimitedFiles
using Combinatorics

struct Permutation
    config::String
    Emax::Number
    Emed::Number
end

const outdir_tri_solo = "tri-solo/"
const outdir_tri_condutor = "tri-condutor/"
const outdir_hexa_solo = "hexa-solo/"
const outdir_hexa_condutor = "hexa-condutor/"
outdirs = [outdir_tri_solo;
    outdir_tri_condutor;
    outdir_hexa_solo;
    outdir_hexa_condutor]
for outdir in outdirs
    mkpath(outdir)
end

const R = 23.55e-3 / 2
const r = 0.5 * R
const n = 6
const altura = 1
# Voltage line-ground peak
const vlgpk = (345e+3 / sqrt(3)) * sqrt(2)

# Constantes linha estudada
const fase1 = Point(-4.3, 33.27)
const fase2 = Point(-4.3, 29.17)
const fase3 = Point(-4.3, 25.07)
const fase4 = Point(4.3, 25.07)
const fase5 = Point(4.3, 29.17)
const fase6 = Point(4.3, 33.27)
fases = [fase1; fase2; fase3; fase4; fase6; fase6]

const va = pol(vlgpk, 0)
const vb = pol(vlgpk, -60)
const vc = pol(vlgpk, -120)
const vd = pol(vlgpk, -180)
const ve = pol(vlgpk, -240)
const vf = pol(vlgpk, -300)

const va_tri = pol(vlgpk, 0)
const vb_tri = pol(vlgpk, -120)
const vc_tri = pol(vlgpk, +120)

# Separação entre condutores
l = 457e-3
# Distância do ponto de fixação aos condutores do feixe
d = l * sqrt(3) / 2

shift_right = Point(d * sqrt(3) / 2, d / 2)
shift_left = Point(-(d * sqrt(3) / 2), d / 2)
shift_bottom = Point(0, -d)
function bundle3(center::Point, voltage::Number)
    return [
        Conductor(center + shift_right, voltage, r, R, n);
        Conductor(center + shift_left, voltage, r, R, n);
        Conductor(center + shift_bottom, voltage, r, R, n)
    ]
end

function rms(values::Array)
    n = length(values)
    squared_sum = 0
    for value in values
        squared_sum = squared_sum + value^2
    end
    return sqrt(squared_sum / n)
end

# Define a medida estatística a ser utilizada na análise dos dados
statmed = rms

function voltage_of_char_tri(char::Char)
    if char == 'a'
        return va
    elseif char == 'b'
        return vb_tri
    elseif char == 'c'
        return vc_tri
    end
end

function voltage_of_char_hex(char::Char)
    if char == 'a'
        return va
    elseif char == 'b'
        return vb
    elseif char == 'c'
        return vc
    elseif char == 'd'
        return vd
    elseif char == 'e'
        return ve
    elseif char == 'f'
        return vf
    end
end

function create_centers(fases::Vector{Point})
    centers = []
    for fase in fases
        centers = [centers;
            fase + shift_right;
            fase + shift_left;
            fase + shift_bottom
        ]
    end
    centers = identity.(centers)
    return centers
end

centers = create_centers(fases)


config_phases_single = String.(collect(Combinatorics.permutations("abc")))
config_phases_double = []
for x in config_phases_single
    for y in config_phases_single
        global config_phases_double = [config_phases_double; x * y]
    end
end
config_phases_double = identity.(config_phases_double)
Threads.@threads for config in config_phases_double
    local outfile_solo = outdir_tri_solo * config * ".dat"
    local outfile_condutor = outdir_tri_condutor * config * ".dat"
    if isfile(outfile_solo) && isfile(outfile_condutor)
        continue
    end
    printstyled("Iniciada configuração $config\n"; color=:yellow)
    bundle_vector = [
        bundle3(fase1, voltage_of_char_tri(config[1]));
        bundle3(fase2, voltage_of_char_tri(config[2]));
        bundle3(fase3, voltage_of_char_tri(config[3]));
        bundle3(fase4, voltage_of_char_tri(config[4]));
        bundle3(fase5, voltage_of_char_tri(config[5]));
        bundle3(fase6, voltage_of_char_tri(config[6]))
    ]
    (j, ϕ, i) = create_jϕi(bundle_vector)

    # Campo elétrico a nível do solo
    (E, x) = calculate_E(j, ϕ, i, 1, 180, 200)

    Emed = E[1:end, 1]
    for i in 1:size(E, 1)
        Emed[i, 1] = statmed(E[i, 1:end])
    end

    open(outfile_solo, "w") do io
        writedlm(io, [x Emed])
    end

    # Campo elétrico no condutor
    (E, pointvector) = calculate_E(j, ϕ, i, centers, 180, 10, R)

    Emed = E[1:end, 1]
    for i in 1:size(E, 1)
        Emed[i, 1] = statmed(E[i, 1:end])
    end

    open(outfile_condutor, "w") do io
        writedlm(io, [getfield.(pointvector, :posx) getfield.(pointvector, :posy) Emed])
    end
    printstyled("Finalizada configuração $config\n"; color=:green)
end





config_phases_hex = String.(collect(Combinatorics.permutations("abcdef")))
config_phases_hex = identity.(config_phases_hex)

Threads.@threads for config in config_phases_hex
    local outfile_solo = outdir_hexa_solo * config * ".dat"
    local outfile_condutor = outdir_hexa_condutor * config * ".dat"
    if isfile(outfile_solo) && isfile(outfile_condutor)
        continue
    end
    printstyled("Iniciada configuração $config\n"; color=:yellow)
    bundle_vector = [
        bundle3(fase1, voltage_of_char_hex(config[1]));
        bundle3(fase2, voltage_of_char_hex(config[2]));
        bundle3(fase3, voltage_of_char_hex(config[3]));
        bundle3(fase4, voltage_of_char_hex(config[4]));
        bundle3(fase5, voltage_of_char_hex(config[5]));
        bundle3(fase6, voltage_of_char_hex(config[6]))
    ]
    (j, ϕ, i) = create_jϕi(bundle_vector)

    # Campo elétrico a nível do solo
    (E, x) = calculate_E(j, ϕ, i, 1, 180, 200)

    Emed = E[1:end, 1]
    for i in 1:size(E, 1)
        Emed[i, 1] = statmed(E[i, 1:end])
    end

    open(outfile_solo, "w") do io
        writedlm(io, [x Emed])
    end

    # Campo elétrico no condutor
    (E, pointvector) = calculate_E(j, ϕ, i, centers, 180, 10, R)

    Emed = E[1:end, 1]
    for i in 1:size(E, 1)
        Emed[i, 1] = statmed(E[i, 1:end])
    end

    open(outfile_condutor, "w") do io
        writedlm(io, [getfield.(pointvector, :posx) getfield.(pointvector, :posy) Emed])
    end
    printstyled("Finalizada configuração $config\n"; color=:green)
end
