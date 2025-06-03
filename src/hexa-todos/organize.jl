using DelimitedFiles
using Combinatorics
using Statistics

struct Permutation
    config::String
    Emax::Number
    Emed::Number
end

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

permut_vec = []
for config in config_phases_hex
    current = readdlm(config * ".dat")
    Emax = maximum(current[:, 2])
    Emed = mean(current[:, 2])
    global permut_vec = [permut_vec; Permutation(config, Emax, Emed)]
end

max_vec = sort(permut_vec, by=p -> p.Emax, rev=true)
med_vec = sort(permut_vec, by=p -> p.Emed, rev=true)

println("max_vec:")
for i in max_vec
    println(i)
end

println("med_vec:")
for i in med_vec
    println(i)
end
