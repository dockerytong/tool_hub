#moncp: Monitoring CP2K convergence of optimization task
#Written by Tian Lu (sobereva@sina.com, Beijing Kein Research Center for Natural Sciences)
#!/bin/bash
nstep=$(grep -c 'Informations at step' $1)
echo "Number of steps already run: $nstep"
echo
grep "Total Energy" $1|cut -d= -f 2 > Total_E.txt
echo > delta_E.txt
grep "Real energy change" $1|cut -d= -f 2 >> delta_E.txt
echo > MAX_D.txt
grep "Max. step size" $1|cut -d= -f 2 >> MAX_D.txt
echo > RMS_D.txt
grep "RMS step size" $1|cut -d= -f 2 >> RMS_D.txt
echo > MAX_F.txt
grep "Max. gradient" $1|cut -d= -f 2 >> MAX_F.txt
echo > RMS_F.txt
grep "RMS gradient               =" $1|cut -d= -f 2 >> RMS_F.txt

NPRES=$(grep -c 'Pressure Deviation' $1)
if [ $NPRES -gt 0 ];then
	echo " Step     E(Hartree)      delta E     MAX D     RMS D     MAX F     RMS F    Pres. Dev."
	echo > PresDev.txt
	grep "Pressure Deviation" $1|cut -d= -f 2 >> PresDev.txt
	paste Total_E.txt delta_E.txt MAX_D.txt RMS_D.txt MAX_F.txt RMS_F.txt PresDev.txt> mon_all.txt
	awk '{printf ("%4d %16.8f %12.8f %9.6f %9.6f %9.6f %9.6f %10.1f\n",NR-1,$1,$2,$3,$4,$5,$6,$7)}' mon_all.txt
	rm -f Total_E.txt delta_E.txt MAX_D.txt RMS_D.txt MAX_F.txt RMS_F.txt mon_all.txt PresDev.txt
else
	echo " Step     E(Hartree)      delta E     MAX D     RMS D     MAX F     RMS F"
	paste Total_E.txt delta_E.txt MAX_D.txt RMS_D.txt MAX_F.txt RMS_F.txt > mon_all.txt
	awk '{printf ("%4d %16.8f %12.8f %9.6f %9.6f %9.6f %9.6f\n",NR-1,$1,$2,$3,$4,$5,$6)}' mon_all.txt
	rm -f Total_E.txt delta_E.txt MAX_D.txt RMS_D.txt MAX_F.txt RMS_F.txt mon_all.txt
fi