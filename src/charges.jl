export Point, pdistance, Conductor, pol

function pol(mag::Number, phase::Number)
    return mag * cis(deg2rad(phase))
end

struct Point
    posx::Number
    posy::Number
end

# Defines addition between two Points
Base.:+(a::Point, b::Point) = Point(a.posx + b.posx, a.posy + b.posy)

# Defines distance between two points
function pdistance(p1::Point, p2::Point)
    return (p1.posx - p2.posx)^2 + (p1.posy - p2.posy)^2 |> √
end

struct Conductor
    position::Point
    potential::Number
    radius_charges::Number
    radius_boundary::Number
    number_of_charges::Integer # Is the same as the number of boundary points
end

struct Charge
    posx::Number
    posy::Number
end
