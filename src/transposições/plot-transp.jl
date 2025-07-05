using Glob
using DelimitedFiles
using Plots

file = ["bfdace.dat"; "ebfdac.dat"; "cebfda.dat"; "acebfd.dat"; "dacebf.dat"; "fdaceb.dat"; "bacbac.dat"; "cbacba.dat"; "acbacb.dat"]

#for file in files
#    data = readdlm(file)
#    plot!(data[:, 1], data[:, 2], label=false)
#end

@recipe function f(::Type{Val{:samplemarkers}}, x, y, z; step=10)
    n = length(y)
    sx, sy = x[1:step:n], y[1:step:n]
    # add an empty series with the correct type for legend markers
    @series begin
        seriestype := :path
        markershape --> :auto
        x := []
        y := []
    end
    # add a series for the line
    @series begin
        primary := false # no legend entry
        markershape := :none # ensure no markers
        seriestype := :path
        seriescolor := get(plotattributes, :seriescolor, :auto)
        x := x
        y := y
    end
    # return  a series for the sampled markers
    primary := false
    seriestype := :scatter
    markershape --> :auto
    x := sx
    y := sy
end


data = readdlm(file[1])
plot!(data[:, 1], data[:, 2], label=file[1], color=:orange, marker=:circle, seriestype=:samplemarkers)
data = readdlm(file[2])
plot!(data[:, 1], data[:, 2], label=file[2], color=:orange, marker=:rect, seriestype=:samplemarkers)
data = readdlm(file[3])
plot!(data[:, 1], data[:, 2], label=file[3], color=:orange, marker=:star5, seriestype=:samplemarkers)
data = readdlm(file[4])
plot!(data[:, 1], data[:, 2], label=file[4], color=:orange, marker=:diamond, seriestype=:samplemarkers)
data = readdlm(file[5])
plot!(data[:, 1], data[:, 2], label=file[5], color=:orange, marker=:utriangle, seriestype=:samplemarkers)
data = readdlm(file[6])
plot!(data[:, 1], data[:, 2], label=file[6], color=:orange, marker=:pentagon, seriestype=:samplemarkers)
data = readdlm(file[7])
plot!(data[:, 1], data[:, 2], label=file[7], color=:blue, marker=:circle, seriestype=:samplemarkers)
data = readdlm(file[8])
plot!(data[:, 1], data[:, 2], label=file[8], color=:blue, marker=:rect, seriestype=:samplemarkers)
data = readdlm(file[9])
plot!(data[:, 1], data[:, 2], label=file[9], color=:blue, marker=:star5, seriestype=:samplemarkers)

savefig("plot-transp.pdf")
