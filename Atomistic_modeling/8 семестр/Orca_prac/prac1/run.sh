#!/bin/bash

# arr=[0.7,0.8,0.9,1.0,1.1,1.2,1.5,2.0,2.5,3.0,4.0,5.0,10.0]
arr=(0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.5 2.0 2.5 3.0 4.0 5.0 10.0 20.0)

for z in "${arr[@]}"
do
# echo "${!z}"
	    cat > h2_$z.inp << EOF
!HF DEF2-SVP
* xyz 0 1
H  0.0  0.0  0.0
H  0.0  0.0  $z
*
EOF

orca h2_$z.inp > h2_$z.out
done

