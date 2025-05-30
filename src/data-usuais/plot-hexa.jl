using Plots
using DelimitedFiles

hex_acebdf = readdlm("hexa-acebdf.dat")
hex_facebd = readdlm("hexa-facebd.dat")
hex_dfaceb = readdlm("hexa-dfaceb.dat")
hex_bdface = readdlm("hexa-bdface.dat")
hex_ebdfac = readdlm("hexa-ebdfac.dat")
hex_cebdfa = readdlm("hexa-cebdfa.dat")

plotMax = plot(hex_acebdf[:, 1], [hex_acebdf[:, 2] hex_facebd[:, 2] hex_dfaceb[:, 2] hex_bdface[:, 2] hex_ebdfac[:, 2] hex_cebdfa[:, 2]],
    label=["hexa-acebdf" "hexa-facebd" "hexa-dfaceb" "hexa-bdface" "hexa-ebdfac" "hexa-cebdfa"]
)

savefig("configuracoes-hexa.pdf")
