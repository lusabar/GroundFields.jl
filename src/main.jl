include("GroundFields.jl")
using .GroundFields

const outfile = "hexa-acebdf.dat"

const R = 1.3265e-2
const r = R / 2
const n = 12
const altura = 1
# Voltage line-ground peak
const vlgpk = (345e+3 / sqrt(3)) * sqrt(2)

## Pontos onde estão alocadas as cargas
#j = [
#    Point(-12, 19.1 - r);
#    Point(0, 19.1 - r);
#    Point(12, 19.1 - r);
#    Point(-9.5, 23.7 - r);
#    Point(9.5, 23.7 - r)
#    Point(-12, 19.1 + r);
#    Point(0, 19.1 + r);
#    Point(12, 19.1 + r);
#    Point(-9.5, 23.7 + r);
#    Point(9.5, 23.7 + r)
#]
#
#
## Potencial nos pontos de contorno
#ϕ = [288;
#    pol(288, -120);
#    pol(288, 120);
#    0;
#    0;
#    288;
#    pol(288, -120);
#    pol(288, 120);
#    0;
#    0
#]
#
## Pontos de contorno
#i = [
#    Point(-12, 19.1 - R);
#    Point(0, 19.1 - R);
#    Point(12, 19.1 - R);
#    Point(-9.5, 23.7 - R);
#    Point(9.5, 23.7 - R)
#    Point(-12, 19.1 + R);
#    Point(0, 19.1 + R);
#    Point(12, 19.1 + R);
#    Point(-9.5, 23.7 + R);
#    Point(9.5, 23.7 + R)
#]

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

    # Hexafásico - ACEBDF
    # Fase 1: A
    bundle3(Point(-4.3, 33.27), vlgpk);
    # Fase 2: C
    bundle3(Point(-4.3, 29.17), pol(vlgpk, -120));
    # Fase 3: E
    bundle3(Point(-4.3, 25.07), pol(vlgpk, -240));
    # Fase 4: B
    bundle3(Point(4.3, 25.07), pol(vlgpk, -60));
    # Fase 5: D
    bundle3(Point(4.3, 29.17), pol(vlgpk, -180));
    # Fase 6: F
    bundle3(Point(4.3, 33.27), pol(vlgpk, -300));

    # Cabos de Guarda
    Conductor(Point(-4.3, 36.86), 0, 0.771e-2 / 2, 0.771e-2, n);
    Conductor(Point(4.3, 36.86), 0, 0.72e-2 / 2, 0.72e-2, n)
])

P = calculate_coeff_matrix(i, j)
println(P)

Q = (P^-1) * ϕ
println(Q)
# Valor da senoide num tempo t
function value_at_t(q::Complex, t::Number)
    ω = 2 * π * 60
    qt = abs(q) * sin(ω * t + angle(q))
    return qt
end

times = range(0, 16.67e-3, 360)
Q_at_specific_times = value_at_t.(Q, 0)
for i in 2:length(times)
    global Q_at_specific_times = [Q_at_specific_times value_at_t.(Q, times[i])]
end

#Q1 = value_at_t.(Q, 0)
#Q2 = value_at_t.(Q, 5.5566)
#Q3 = value_at_t.(Q, 11.11333)
#Q4 = value_at_t.(Q, 16.67)

pointvector = []
x = range(-60, 60, 200)
for i in x
    global pointvector = [pointvector; Point(i, altura)]
end

println("pointvector:")
println(pointvector)
pointvector = Vector{Point}(pointvector)

E = calculate_electric_field_vector(pointvector, j, Q_at_specific_times[1:end, 1])
for i in 2:size(Q_at_specific_times, 2)
    global E = [E calculate_electric_field_vector(pointvector, j, Q_at_specific_times[1:end, i])]
end

#E1 = calculate_electric_field_vector(pointvector, j, Q1)
#E2 = calculate_electric_field_vector(pointvector, j, Q2)
#E3 = calculate_electric_field_vector(pointvector, j, Q3)
#E4 = calculate_electric_field_vector(pointvector, j, Q4)

#E = E1

Emed = E[1:end, 1]
Emax = E[1:end, 1]
Emin = E[1:end, 1]

using Statistics
for i in 1:size(E, 1)
    global Emed[i, 1] = mean(E[i, 1:end])
end

for i in 1:size(E, 1)
    global Emax[i, 1] = maximum(E[i, 1:end])
end

for i in 1:size(E, 1)
    global Emin[i, 1] = minimum(E[i, 1:end])
end

#println("E: $E")

using DelimitedFiles
open(outfile, "w") do io
    writedlm(io, [x Emax Emed])
end

#using Plots
#plt = plot(x, [Emax, Emed], pallete=:acton, title="Campo elétrico ao nível do solo (1m)", label="Trifásico horizontal")
#display(plt)
