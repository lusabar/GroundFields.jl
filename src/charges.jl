export Point, pol

function pol(mag::Number, phase::Number)
    return mag * cis(deg2rad(phase))
end

struct Point
    posx::Number
    posy::Number
end

struct Charge
    posx::Number
    posy::Number
end
