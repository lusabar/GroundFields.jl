using Plots
using DelimitedFiles

datTriOriginal = readdlm("tri-original.dat")
datTriAlternativo = readdlm("tri-alternativo.dat")
datHex = readdlm("hexa-abcdef.dat")
datHexAlternativo = readdlm("hexa-acefdb.dat")
datHexwACEBDF = readdlm("hexa-acebdf.dat")

plotMax = plot(datHex[:, 1], [datTriOriginal[:, 3] datTriAlternativo[:, 3] datHex[:, 3] datHexAlternativo[:, 3] datHexwACEBDF[:, 3]],
    label=["Trifásico original (abcabc)" "Trifásico Alternativo (abccba)" "Hexafásico (abcdef)" "Hexafásico alternativo (acefdb)" "Hexafásico alternativo (acebdf)"])

savefig("ouput.svg")
