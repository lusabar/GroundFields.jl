using Plots
using DelimitedFiles

tri_abcabc = readdlm("tri-abcabc.dat")
tri_abcabc_sempr = readdlm("tri-abcabc-sempr.dat")
tri_abcacb = readdlm("tri-abcacb.dat")
tri_abcbac = readdlm("tri-abcbac.dat")
tri_abcbca = readdlm("tri-abcbca.dat")
tri_abccab = readdlm("tri-abccab.dat")
tri_abccba = readdlm("tri-abccba.dat")

plotMax = plot(tri_abcabc[:, 1], [tri_abcabc[:, 2] tri_abcacb[:, 2] tri_abcbac[:, 2] tri_abcbca[:, 2] tri_abccab[:, 2] tri_abccba[:, 2] tri_abcabc_sempr[:, 2]],
    label=["tri_abcabc" "tri_abcacb" "tri_abcbac" "tri_abcbca" "tri_abccab" "tri_abccba" "tri_abcabc_sem_pr"]
)

savefig("configuracoes.pdf")
