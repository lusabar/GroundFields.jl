export calculate_E

function calculate_E(j::Vector{Point}, ϕ::Vector{Nums}, i::Vector{Point}, altura::Number, n_times::Integer, n_points::Integer) where {Nums<:Union{Complex,Number}}

    P = calculate_coeff_matrix(i, j)
    #println(P)

    Q = (P^-1) * ϕ
    #println(Q)
    # Valor da senoide num tempo t
    function value_at_t(q::Complex, t::Number)
        ω = 2 * π * 60
        qt = abs(q) * sin(ω * t + angle(q))
        return qt
    end

    times = range(0, 16.67e-3, n_times)
    Q_at_specific_times = value_at_t.(Q, 0)
    for i in 2:length(times)
        Q_at_specific_times = [Q_at_specific_times value_at_t.(Q, times[i])]
    end

    #Q1 = value_at_t.(Q, 0)
    #Q2 = value_at_t.(Q, 5.5566)
    #Q3 = value_at_t.(Q, 11.11333)
    #Q4 = value_at_t.(Q, 16.67)

    pointvector = []
    x = range(-100, 100, n_points)
    for i in x
        pointvector = [pointvector; Point(i, altura)]
    end

    #println("pointvector:")
    #println(pointvector)
    pointvector = Vector{Point}(pointvector)

    E = calculate_electric_field_vector(pointvector, j, Q_at_specific_times[1:end, 1])
    for i in 2:size(Q_at_specific_times, 2)
        E = [E calculate_electric_field_vector(pointvector, j, Q_at_specific_times[1:end, i])]
    end

    return (E, x)
end
