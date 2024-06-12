#!/bin/bash
#echo "Running:" $1 $2
echo "============================================================================="
echo "Generate cp2k input for" $1 "with input file name" $2
echo "file : ot.inp    ---->  ot with DFT-D3, print level medium, export molden"
echo "file : david.inp ---->  same settings but using david scf with smearing 300 K"
echo "=============================================================================="
Multiwfn $1 << EOF > out.txt
cp 
1  
ot.inp
-1
3
4  
3  
1  
-9 
5  
400,55 
10 
2  
0  
-2 
0  
cp
1
david.inp
4
6
0
q  
EOF

# cp # into cp2k mate function
# 1  # generate input file
# $2
# 4  # use OT
# 3  # set DFTD version
# 1  # set DFTD to DFT-D3
# -9 # into other setting menu
# 5  # set cutoff energy
# 400,55 # set to 400, and 55 Ry
# 10 # set print level
# 2  # set print level to MEDIUM for more information
# 0  # quit to main menu
# -2 # toggle output molden file for Multiwfn
# 0  # generate file now
# 0  # exit to Multiwfn main menu
# q  # exit Multiwfn

