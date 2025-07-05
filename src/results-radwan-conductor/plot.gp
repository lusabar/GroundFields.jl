set yrange [0:40]
set encoding utf8
set title "Campo elétrico na superfície do condutor (Radwan Fig. 24)"
set xlabel "Ângulo θ [°]"
set ylabel "Campo elétrico [kV/cm]"
plot 'radwan.dat' using 1:2 with linespoints title "Center" lt rgb "#f910f9", \
'radwan.dat' using 1:4 with linespoints title "OuterA" lt rgb "#ff0000", \
'radwan.dat' using 1:3 with linespoints title "Outer" lt rgb "#101084"
