using DelimitedFiles
using Combinatorics
using Statistics

struct Transposition
    config::String
    Emax::Number
end

function get_transpositions(permutations::Vector{String})
    representatives = String[]
    seen = Set{String}()

    for s in permutations
        if !(s in seen)
            # Generate all right shifts and find the lexicographically smallest
            n = length(s)
            all_shifts = [s[(n-i+1):n] * s[1:(n-i)] for i in 0:n-1]
            lexmin = minimum(all_shifts)
            push!(representatives, lexmin)
            union!(seen, all_shifts)  # Mark all shifts as seen
        end
    end

    return unique(representatives)  # Ensure no duplicates
end

config_phases_hex = String.(collect(Combinatorics.permutations("abcdef")))
config_phases_hex = identity.(config_phases_hex)

unique_transps = get_transpositions(config_phases_hex)

permut_vec = []
for config in unique_transps
    n = length(config)
    all_shifts = [config[(n-i+1):n] * config[1:(n-i)] for i in 0:n-1]
    global Emax = 0
    for shift in all_shifts
        data = readdlm(shift * ".dat")
        currentmax = maximum(data[:, 2])
        if currentmax > Emax
            global Emax = currentmax
        end
    end

    #current = readdlm(config * ".dat")
    #Emax = maximum(current[:, 2])
    #Emed = mean(current[:, 2])
    global permut_vec = [permut_vec; Transposition(config, Emax)]
end

#for i in permut_vec
#    println(i)
#end

max_vec = sort(permut_vec, by=p -> p.Emax, rev=true)
#med_vec = sort(permut_vec, by=p -> p.Emed, rev=true)

println("max_vec:")
for i in max_vec
    println(i)
end

#println("med_vec:")
#for i in med_vec
#    println(i)
#end
