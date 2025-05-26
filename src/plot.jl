using Plots
using DelimitedFiles

datTriOriginal = readdlm("tri-original.dat")
datTriAlternativo = readdlm("tri-alternativo.dat")
datHex = readdlm("hexa-abcdef.dat")
datHexAlternativo = readdlm("hexa-acefdb.dat")
datHexwACEBDF = readdlm("hexa-acebdf.dat")

plotMax = plot(datHex[:, 1], [datTriOriginal[:, 2] datTriAlternativo[:, 2] datHex[:, 2] datHexAlternativo[:, 2] datHexwACEBDF[:, 2]],
    label=["Trifásico original (abcabc)" "Trifásico Alternativo (abccba)" "Hexafásico (abcdef)" "Hexafásico alternativo (acefdb)" "Hexafásico alternativo (acebdf)"])
