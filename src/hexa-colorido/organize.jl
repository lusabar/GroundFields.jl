using DelimitedFiles
using Combinatorics
using Statistics
using Colors, ColorSchemes
using Plots
#using GMT

#using Regex
liminf = 1.296347569532409e6
limsup = 2.04476152753765e6

struct Permutation
    config::String
    Emax::Number
end

function value_to_color(value, vmin=liminf, vmax=limsup; colormap=:viridis)
    t = (clamp(value, vmin, vmax) - vmin) / (vmax - vmin)  # Normalized to [0,1]
    return get(ColorSchemes.colorschemes[colormap], t)      # Get interpolated color
end

function getlinecontaining(string::String, stringarray::Array{String})
    for line in stringarray
        if occursin(string, line)
            return line
        end
    end
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

organized = readlines(open("../hexa-condutor2/organized.txt"))
for i in organized
    println(i)
end

l = @layout [a{0.95w} b]
cmap = cgrad(:viridis)

for config in config_phases_hex
    line = getlinecontaining(config, organized)
    pattern = r"(?<=, )[^)]*(?=\))"
    gradient = match(pattern, line)
    gradient = gradient.match
    gradient = parse(Float64, gradient)
    println(gradient)
    cor = value_to_color(gradient)

    current = readdlm("../hexa-todos/" * config * ".dat")
    global p1 = plot!(current[:, 1], current[:, 2], color=cor, legend=false)
end
p2 = heatmap(rand(2, 2), clims=(liminf, limsup), framestyle=:none, c=cmap, cbar=true, lims=(-1, 0))
plt = plot(p1, p2, layout=l)

savefig(plt, "hexa-colorido.pdf")
