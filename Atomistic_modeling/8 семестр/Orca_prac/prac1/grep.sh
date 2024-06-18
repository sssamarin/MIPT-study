#!/bin/bash

text="FINAL SINGLE POINT ENERGY"
arr=(0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.5 2.0 2.5 3.0 4.0 5.0 10.0 20.0)

for z in "${arr[@]}"
do
    found_line=$(grep "$text" h2_$z.out)
    energy_value=$(echo "$found_line" | awk '{print $NF}')
    echo "$energy_value" >> energy_values.txt
    echo "$z" >> x_values.txt
done

# Строим график с помощью gnuplot
gnuplot << EOF
set term png
set output "energy_plot.png"
set title "Energy Values"
set xlabel "Iteration"
set ylabel "Energy Value"
plot "x_values.txt" using 1:"energy_values.txt" with linespoints title "Energy"
set output
EOF