using DelimitedFiles
using Combinatorics
using Statistics

struct Permutation
    config::String
    Emax::Number
end

config_phases_single = String.(collect(Combinatorics.permutations("abc")))
config_phases_double = []
for x in config_phases_single
    for y in config_phases_single
        global config_phases_double = [config_phases_double; x * y]
    end
end
config_phases_double = identity.(config_phases_double)

permut_vec = []
for config in config_phases_double
    current = readdlm(config * ".dat")
    Emax = maximum(current[:, 3])
    global permut_vec = [permut_vec; Permutation(config, Emax)]
end

max_vec = sort(permut_vec, by=p -> p.Emax, rev=true)

for i in max_vec
    println(i)
end
