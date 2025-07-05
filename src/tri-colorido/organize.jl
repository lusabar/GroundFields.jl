using DelimitedFiles
using Combinatorics
using Statistics
using Colors, ColorSchemes
using Plots
#using GMT

#using Regex
#liminf = 1.296347569532409e6
#limsup = 2.04476152753765e6
liminf = 1.8139885937494484e6
limsup = 1.848980848593527e6

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


config_phases_single = String.(collect(Combinatorics.permutations("abc")))
config_phases_double = []
for x in config_phases_single
    for y in config_phases_single
        global config_phases_double = [config_phases_double; x * y]
    end
end
config_phases_double = identity.(config_phases_double)

organized = readlines(open("../tri-condutor2/organized.txt"))
for i in organized
    println(i)
end

l = @layout [a{0.95w} b]
cmap = cgrad(:viridis)

for config in config_phases_double
    line = getlinecontaining(config, organized)
    pattern = r"(?<=, )[^)]*(?=\))"
    gradient = match(pattern, line)
    gradient = gradient.match
    gradient = parse(Float64, gradient)
    println(gradient)
    cor = value_to_color(gradient)

    current = readdlm("../tri-todos/" * config * ".dat")
    global p1 = plot!(current[:, 1], current[:, 2], color=cor, legend=false)
end
p2 = heatmap(rand(2, 2), clims=(liminf, limsup), framestyle=:none, c=cmap, cbar=true, lims=(-1, 0))
plt = plot(p1, p2, layout=l)

savefig(plt, "tri-colorido-relativo.pdf")
