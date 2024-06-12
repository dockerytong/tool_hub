#!/bin/bash
echo "Running:" $1
Multiwfn $1 << EOF > out.txt
5
0
2
-,$2
-,$3
1
3
2
EOF
