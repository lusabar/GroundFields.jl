include("GroundFields.jl")
using .GroundFields

const r = 6e-2
const R = 13e-2
const altura = 1

# Pontos onde estão alocadas as cargas
j = [
    Point(-12, 19.1 - r);
    Point(0, 19.1 - r);
    Point(12, 19.1 - r);
    Point(-9.5, 23.7 - r);
    Point(9.5, 23.7 - r)
    Point(-12, 19.1 + r);
    Point(0, 19.1 + r);
    Point(12, 19.1 + r);
    Point(-9.5, 23.7 + r);
    Point(9.5, 23.7 + r)
]


# Potencial nos pontos de contorno
ϕ = [288;
    pol(288, -120);
    pol(288, 120);
    0;
    0;
    288;
    pol(288, -120);
    pol(288, 120);
    0;
    0
]

# Pontos de contorno
i = [
    Point(-12, 19.1 - R);
    Point(0, 19.1 - R);
    Point(12, 19.1 - R);
    Point(-9.5, 23.7 - R);
    Point(9.5, 23.7 - R)
    Point(-12, 19.1 + R);
    Point(0, 19.1 + R);
    Point(12, 19.1 + R);
    Point(-9.5, 23.7 + R);
    Point(9.5, 23.7 + R)
]

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

times = range(0, 16.67, 360)
Q_at_specific_times = value_at_t.(Q, 0)
for i in 2:length(times)
    global Q_at_specific_times = [Q_at_specific_times value_at_t.(Q, times[i])]
end

Q1 = value_at_t.(Q, 0)
Q2 = value_at_t.(Q, 5.5566)
Q3 = value_at_t.(Q, 11.11333)
Q4 = value_at_t.(Q, 16.67)

#pointvector = [
#    Point(-60, 1)
#    Point(-50, 1)
#    Point(-40, 1)
#    Point(-30, 1)
#    Point(-20, 1)
#    Point(-10, 1)
#    Point(0, 1)
#    Point(10, 1)
#    Point(20, 1)
#    Point(30, 1)
#    Point(40, 1)
#    Point(50, 1)
#    Point(60, 1)
#]

pointvector = []
x = range(-60, 60, 100)
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

using Statistics
for i in 1:size(E, 1)
    global Emed[i, 1] = mean(E[i, 1:end])
end

#println("E: $E")

using Plots
plt = plot(x, [Emed])
display(plt)

