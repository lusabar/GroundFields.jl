export calculate_coeff_matrix, calculate_electric_field, calculate_electric_field_vector,
    create_jϕi

function calculate_coeff(p1::Point, p2::Point)
    x = p1.posx
    y = p1.posy
    xj = p2.posx
    yj = p2.posy
    Pj = (1 / (2 * π * ϵ)) * ln((√((y + yj)^2 + (x - xj)^2)) / (√((y - yj)^2 + (x - xj)^2)))

    return Pj
end

function calculate_coeff_matrix(i::Vector{Point}, j::Vector{Point})
    M = zeros(length(i), length(j))
    for x in 1:length(i)
        for y in 1:length(j)
            M[x, y] = calculate_coeff(i[x], j[y])
        end
    end
    return M
end

function calculateEx(point::Point, pointCharge::Point, λ::Number)
    x = point.posx
    y = point.posy
    xj = pointCharge.posx
    yj = pointCharge.posy

    Ex = (λ / (2 * π * ϵ)) * (((x - xj) / ((y - yj)^2 + (x - xj)^2)) - ((x - xj) / ((y + yj)^2 + (x - xj)^2)))
    return Ex
end

function calculateEy(point::Point, pointCharge::Point, λ::Number)
    x = point.posx
    y = point.posy
    xj = pointCharge.posx
    yj = pointCharge.posy

    Ey = (λ / (2 * π * ϵ)) * (((y - yj) / ((y - yj)^2 + (x - xj)^2)) - ((y + yj) / ((y + yj)^2 + (x - xj)^2)))
    return Ey
end

function calculate_electric_field(point::Point, pointcharges::Vector{Point}, charges::Vector{N}) where {N<:Union{Integer,AbstractFloat,Complex}}
    Ex = 0
    Ey = 0
    for j in 1:length(charges)
        Ex = Ex + calculateEx(point, pointcharges[j], charges[j])
        Ey = Ey + calculateEy(point, pointcharges[j], charges[j])
    end

    return √(Ex^2 + Ey^2)
    #return (Ex, Ey)
end

function calculate_electric_field_vector(points::Vector{Point}, pointcharges::Vector{Point}, charges::Vector{N}) where {N<:Union{Integer,AbstractFloat,Complex}}
    E = []
    for i in 1:length(points)
        E = [E; calculate_electric_field(points[i], pointcharges, charges)]
    end
    return E
end

function create_jϕi(cond::Conductor)
    center = cond.position
    n = cond.number_of_charges
    r = cond.radius_charges
    R = cond.radius_boundary
    v = cond.potential

    j = Array{Union{Missing,Point},1}(missing, n)
    ϕ = Array{Number,1}(undef, n)
    fill!(ϕ, v)
    i = Array{Union{Missing,Point},1}(missing, n)

    angles = Array{Number,1}(undef, n)
    for x in 0:(n-1)
        angles[x+1] = 0 + (360 / n) * x
    end
    angles = deg2rad.(angles)

    for x in 1:n
        j[x] = center + Point(r * cos(angles[x]), r * sin(angles[x]))
        i[x] = center + Point(R * cos(angles[x]), R * sin(angles[x]))
    end

    return (j, ϕ, i)
end

# j is the vector of points where the charges are allocated
# ϕ is the vector of the potential on boundary points
# i is the vector of boundary points
function create_jϕi(conductors::Array{Conductor})
    j = []
    ϕ = []
    i = []
    for cond in conductors
        (j_tmp, ϕ_tmp, i_tmp) = create_jϕi(cond)
        j = [j; j_tmp]
        ϕ = [ϕ; ϕ_tmp]
        i = [i; i_tmp]
    end

    j = identity.(j)
    i = identity.(i)
    ϕ = identity.(ϕ)

    return (j, ϕ, i)
end
