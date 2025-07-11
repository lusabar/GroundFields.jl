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

#const outfile = "data-usuais/hexa-acebdf.dat"

const R = 23.55e-3 / 2
const r = 0.5 * R
const n = 6
const altura = 1
# Voltage line-ground peak
const vlgpk = (345e+3 / sqrt(3)) * sqrt(2)

# Constantes Radwan
const H1 = 10
const H2 = H1 + 9.2
const H3 = H1 + 19.4
const B1 = 8.55
const B2 = 4.5
const B3 = 8.55
const D = 0.3
const Rc = 0.0135
const rc = 0.05 * Rc
const voltage_lineground = (220e+3 / sqrt(3)) * sqrt(2)

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

(j, ϕ, i) = create_jϕi([

    #######################
    ## Trifásicos Usuais ##
    ####################### 

    ## Trifásico abcabc
    ## Fase 1: A
    #bundle3(fase1, va_tri)
    ## Fase 2: B
    #bundle3(fase2, vb_tri)
    ## Fase 3: C
    #bundle3(fase3, vc_tri)
    ## Fase 4: A
    #bundle3(fase4, va_tri)
    ## Fase 5: B
    #bundle3(fase5, vb_tri)
    ## Fase 6: C
    #bundle3(fase6, vc_tri)

    ## Trifásico abcacb
    ## Fase 1: A
    #bundle3(fase1, va_tri)
    ## Fase 2: B
    #bundle3(fase2, vb_tri)
    ## Fase 3: C
    #bundle3(fase3, vc_tri)
    ## Fase 4: A
    #bundle3(fase4, va_tri)
    ## Fase 5: C
    #bundle3(fase5, vc_tri)
    ## Fase 6: B
    #bundle3(fase6, vb_tri)

    ## Trifásico abcbac
    ## Fase 1: A
    #bundle3(fase1, va_tri)
    ## Fase 2: B
    #bundle3(fase2, vb_tri)
    ## Fase 3: C
    #bundle3(fase3, vc_tri)
    ## Fase 4: B
    #bundle3(fase4, vb_tri)
    ## Fase 5: A
    #bundle3(fase5, va_tri)
    ## Fase 6: C
    #bundle3(fase6, vc_tri)

    ## Trifásico abcbca
    ## Fase 1: A
    #bundle3(fase1, va_tri)
    ## Fase 2: B
    #bundle3(fase2, vb_tri)
    ## Fase 3: C
    #bundle3(fase3, vc_tri)
    ## Fase 4: B
    #bundle3(fase4, vb_tri)
    ## Fase 5: C
    #bundle3(fase5, vc_tri)
    ## Fase 6: A
    #bundle3(fase6, va_tri)

    ## Trifásico abccab
    ## Fase 1: A
    #bundle3(fase1, va_tri)
    ## Fase 2: B
    #bundle3(fase2, vb_tri)
    ## Fase 3: C
    #bundle3(fase3, vc_tri)
    ## Fase 4: C
    #bundle3(fase4, vc_tri)
    ## Fase 5: A
    #bundle3(fase5, va_tri)
    ## Fase 6: B
    #bundle3(fase6, vb_tri)

    ## Trifásico abccba
    ## Fase 1: A
    #bundle3(fase1, va_tri)
    ## Fase 2: B
    #bundle3(fase2, vb_tri)
    ## Fase 3: C
    #bundle3(fase3, vc_tri)
    ## Fase 4: C
    #bundle3(fase4, vc_tri)
    ## Fase 5: B
    #bundle3(fase5, vb_tri)
    ## Fase 6: A
    #bundle3(fase6, va_tri)


    #######################
    ## Hexafásicos Usuais ##
    ####################### 

    # Hexa
    bundle3(fase1, va)
    bundle3(fase2, vc)
    bundle3(fase3, ve)
    bundle3(fase4, vb)
    bundle3(fase5, vd)
    bundle3(fase6, vf)


    ## Trifásico Original
    ## Fase 1: A
    #bundle3(Point(-4.3, 33.27), vlgpk);
    ## Fase 2: B
    #bundle3(Point(-4.3, 29.17), pol(vlgpk, -120));
    ## Fase 3: C
    #bundle3(Point(-4.3, 25.07), pol(vlgpk, +120));
    ## Fase 4: A
    #bundle3(Point(4.3, 25.07), vlgpk);
    ## Fase 5: B
    #bundle3(Point(4.3, 29.17), pol(vlgpk, -120));
    ## Fase 6: C
    #bundle3(Point(4.3, 33.27), pol(vlgpk, +120));

    ## Trifásico Alternativo
    ## Fase 1: A
    #bundle3(Point(-4.3, 33.27), vlgpk);
    ## Fase 2: B
    #bundle3(Point(-4.3, 29.17), pol(vlgpk, -120));
    ## Fase 3: C
    #bundle3(Point(-4.3, 25.07), pol(vlgpk, +120));
    ## Fase 4: C
    #bundle3(Point(4.3, 25.07), pol(vlgpk, +120));
    ## Fase 5: B
    #bundle3(Point(4.3, 29.17), pol(vlgpk, -120));
    ## Fase 6: A
    #bundle3(Point(4.3, 33.27), vlgpk);

    ## Hexafásico - ABCDEF
    ## Fase 1: A
    #bundle3(Point(-4.3, 33.27), vlgpk);
    ## Fase 2: B
    #bundle3(Point(-4.3, 29.17), pol(vlgpk, -60));
    ## Fase 3: C
    #bundle3(Point(-4.3, 25.07), pol(vlgpk, -120));
    ## Fase 4: D
    #bundle3(Point(4.3, 25.07), pol(vlgpk, -180));
    ## Fase 5: E
    #bundle3(Point(4.3, 29.17), pol(vlgpk, -240));
    ## Fase 6: F
    #bundle3(Point(4.3, 33.27), pol(vlgpk, -300));

    ## Hexafásico - ACEFDB
    ## Fase 1: A
    #bundle3(Point(-4.3, 33.27), vlgpk);
    ## Fase 2: C
    #bundle3(Point(-4.3, 29.17), pol(vlgpk, -120));
    ## Fase 3: E
    #bundle3(Point(-4.3, 25.07), pol(vlgpk, -240));
    ## Fase 4: F
    #bundle3(Point(4.3, 25.07), pol(vlgpk, -300));
    ## Fase 5: D
    #bundle3(Point(4.3, 29.17), pol(vlgpk, -180));
    ## Fase 6: B
    #bundle3(Point(4.3, 33.27), pol(vlgpk, -60));

    ## Hexafásico - ACEBDF
    ## Fase 1: A
    #bundle3(Point(-4.3, 33.27), vlgpk);
    ## Fase 2: C
    #bundle3(Point(-4.3, 29.17), pol(vlgpk, -120));
    ## Fase 3: E
    #bundle3(Point(-4.3, 25.07), pol(vlgpk, -240));
    ## Fase 4: B
    #bundle3(Point(4.3, 25.07), pol(vlgpk, -60));
    ## Fase 5: D
    #bundle3(Point(4.3, 29.17), pol(vlgpk, -180));
    ## Fase 6: F
    #bundle3(Point(4.3, 33.27), pol(vlgpk, -300));

    # Cabos de Guarda
    Conductor(Point(-4.3, 36.86), 0, 0.05 * 0.771e-2, 0.771e-2, n);
    Conductor(Point(4.3, 36.86), 0, 0.05 * 0.72e-2, 0.72e-2, n)

    #Teste Camargo
    #Trifásico
    #Fase1: a
    #Conductor(Point(-2.7, 32.4), pol(vlgpk, 0), r, R, n);
    ##Fase2: b
    #Conductor(Point(-2.7, 28.4), pol(vlgpk, -120), r, R, n);
    ##Fase3: c
    #Conductor(Point(-2.7, 24.25), pol(vlgpk, +120), r, R, n);
    ##Fase4: c
    #Conductor(Point(2.7, 24.25), pol(vlgpk, +120), r, R, n);
    ##Fase5: b
    #Conductor(Point(2.7, 28.4), pol(vlgpk, -120), r, R, n);
    ##Fase6: a
    #Conductor(Point(2.7, 32.4), pol(vlgpk, 0), r, R, n);
    #Hexafásico
    #Fase1: a
    #Conductor(Point(-2.7, 32.4), pol(vlgpk, 0), r, R, n);
    ##Fase2: b
    #Conductor(Point(-2.7, 28.4), pol(vlgpk, -60), r, R, n);
    ##Fase3: c
    #Conductor(Point(-2.7, 24.25), pol(vlgpk, -120), r, R, n);
    ##Fase4: d
    #Conductor(Point(2.7, 24.25), pol(vlgpk, -180), r, R, n);
    ##Fase5: e
    #Conductor(Point(2.7, 28.4), pol(vlgpk, -240), r, R, n);
    ##Fase6: f
    #Conductor(Point(2.7, 32.4), pol(vlgpk, -300), r, R, n);
    ## Para-raio Camargo
    #Conductor(Point(0, 37.7), 0, 9.52e-3 / 2, 9.52e-3, n)

    ## Teste Radwan
    ## Fase C
    #Conductor(Point(B1 + D / 2, H1), pol(voltage_lineground, +120), rc, Rc, n);
    #Conductor(Point(B1 - D / 2, H1), pol(voltage_lineground, +120), rc, Rc, n);
    #Conductor(Point(-B1 + D / 2, H1), pol(voltage_lineground, +120), rc, Rc, n);
    #Conductor(Point(-B1 - D / 2, H1), pol(voltage_lineground, +120), rc, Rc, n);
    ## Fase B
    #Conductor(Point(B2 + D / 2, H2), pol(voltage_lineground, -120), rc, Rc, n);
    #Conductor(Point(B2 - D / 2, H2), pol(voltage_lineground, -120), rc, Rc, n);
    #Conductor(Point(-B2 + D / 2, H2), pol(voltage_lineground, -120), rc, Rc, n);
    #Conductor(Point(-B2 - D / 2, H2), pol(voltage_lineground, -120), rc, Rc, n);
    ## Fase A
    #Conductor(Point(B3 + D / 2, H3), pol(voltage_lineground, 0), rc, Rc, n);
    #Conductor(Point(B3 - D / 2, H3), pol(voltage_lineground, 0), rc, Rc, n);
    #Conductor(Point(-B3 + D / 2, H3), pol(voltage_lineground, 0), rc, Rc, n);
    #Conductor(Point(-B3 - D / 2, H3), pol(voltage_lineground, 0), rc, Rc, n)
])

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


#config_phases_single = String.(collect(Combinatorics.permutations("abc")))
#config_phases_double = []
#for x in config_phases_single
#    for y in config_phases_single
#        global config_phases_double = [config_phases_double; x * y]
#    end
#end
#config_phases_double = identity.(config_phases_double)
#for config in config_phases_double
#    bundle_vector = [
#        bundle3(fase1, voltage_of_char_tri(config[1]));
#        bundle3(fase2, voltage_of_char_tri(config[2]));
#        bundle3(fase3, voltage_of_char_tri(config[3]));
#        bundle3(fase4, voltage_of_char_tri(config[4]));
#        bundle3(fase5, voltage_of_char_tri(config[5]));
#        bundle3(fase6, voltage_of_char_tri(config[6]))
#    ]
#    (j, ϕ, i) = create_jϕi(bundle_vector)
#    #(E, x) = calculate_E(j, ϕ, i, 1, 180, 200)
#    (E, pointvector) = calculate_E(j, ϕ, i, centers, 180, 10, R)
#
#    Emed = E[1:end, 1]
#
#    for i in 1:size(E, 1)
#        Emed[i, 1] = mean(E[i, 1:end])
#    end
#
#    local outfile = "tri-condutor2/" * config * ".dat"
#
#    open(outfile, "w") do io
#        writedlm(io, [getfield.(pointvector, :posx) getfield.(pointvector, :posy) Emed])
#    end
#end

function remove_reversed_duplicates(words::Vector{String})
    seen = Set{String}()
    result = String[]

    for word in words
        reversed = reverse(word)
        if word ∉ seen && reversed ∉ seen
            push!(seen, word)
            push!(seen, reversed)
            push!(result, word)
        end
    end

    return result
end

config_phases_hex = String.(collect(Combinatorics.permutations("abcdef")))
config_phases_hex = identity.(config_phases_hex)
config_phases_hex = remove_reversed_duplicates(config_phases_hex)

for config in config_phases_hex
    #if isfile("hexa-condutor/" * config * ".dat")
    #    continue
    #end
    bundle_vector = [
        bundle3(fase1, voltage_of_char_hex(config[1]));
        bundle3(fase2, voltage_of_char_hex(config[2]));
        bundle3(fase3, voltage_of_char_hex(config[3]));
        bundle3(fase4, voltage_of_char_hex(config[4]));
        bundle3(fase5, voltage_of_char_hex(config[5]));
        bundle3(fase6, voltage_of_char_hex(config[6]))
    ]
    (j, ϕ, i) = create_jϕi(bundle_vector)
    #(E, x) = calculate_E(j, ϕ, i, 1, 180, 200)
    (E, pointvector) = calculate_E(j, ϕ, i, centers, 180, 10, R)

    Emed = E[1:end, 1]

    for i in 1:size(E, 1)
        Emed[i, 1] = mean(E[i, 1:end])
    end

    local outfile = "hexa-condutor2/" * config * ".dat"

    open(outfile, "w") do io
        #writedlm(io, [x Emed])
        writedlm(io, [getfield.(pointvector, :posx) getfield.(pointvector, :posy) Emed])
    end
end


exit()




(E, x) = calculate_E(j, ϕ, i, 1, 180, 200)

Emed = E[1:end, 1]
#Emax = E[1:end, 1]
#Emin = E[1:end, 1]

for i in 1:size(E, 1)
    global Emed[i, 1] = mean(E[i, 1:end])
end

#for i in 1:size(E, 1)
#    global Emax[i, 1] = maximum(E[i, 1:end])
#end
#
#for i in 1:size(E, 1)
#    global Emin[i, 1] = minimum(E[i, 1:end])
#end

#println("E: $E")

#open(outfile, "w") do io
#    writedlm(io, [x Emed])
#end

#using Plots
#plt = plot(x, [Emax, Emed], pallete=:acton, title="Campo elétrico ao nível do solo (1m)", label=["Radwan (máximo)" "Radwan (médio)"])
#display(plt)
#savefig(plt, "radwan.svg")
