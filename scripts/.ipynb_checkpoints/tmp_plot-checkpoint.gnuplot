#!/usr/bin/gnuplot
set terminal png size 800,800
set output "~/project_dipole/pictures/picnumber.png"


set ylabel "Mean Energy"
set xlabel "Iteration"
set title "ddd"
plot "forgnunumber.txt" using 1:2 with lines
