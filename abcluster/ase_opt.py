# This is the script to connect ABCluster with ase, and use mace foundation model.
#
# the script should be used by first make conda environment installing mace model
# Usage: python ase_opt.py $inp$ $out$ $xxx$
#

from ase.io import read, write
from ase.optimize import LBFGS
from mace.calculators import mace_mp

def ase2xyz(fn):
    energy = atoms.get_potential_energy()
    with open(fn,'r') as file:
        lines = file.readlines()
    lines[1] = str(energy)+'\n'
    with open(fn,'w') as file:
        file.writelines(lines)
    return(energy)
# select MACE model type : small, medium, large
calc = mace_mp(model="small", dispersion=False, default_dtype="float64", device='cpu')

if __name__ == "__main__":
    inp_fn = sys.argv[1]
    out_fn = sys.argv[2]
    sys_fn = sys.argv[3]
    
    atoms = read(inp_fn, format='xyz')
    atoms.calc = calc
    
    opt = LBFGS(atoms, logfile = 'ase.log')
    opt.run(fmax=0.01)    
    write(filename=out_fn, images=atoms, format='xyz')
    ase2xyz(fn = out_fn)
