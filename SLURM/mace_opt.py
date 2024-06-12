
from ase.io import read, write
from ase import units
from ase.md.velocitydistribution import MaxwellBoltzmannDistribution
from ase.md.nvtberendsen import NVTBerendsen
from mace.calculators import mace_mp
import os

filename = './glu_md_last.pdb'

# load mace-mp float 32 model
calc = mace_mp(model="medium", dispersion=False, default_dtype="float64", device='cpu')

# read initial structure and set calc
atoms = read(filename)
#print(atoms.cell)
#atoms.center(10, axis=2)
#write(os.path.basename(filename) + '_out.pdb', atoms)
#print(atoms.cell)

atoms.calc = calc 

# optimize
from ase.optimize import QuasiNewton, FIRE, MDMin
#opt = FIRE(atoms, logfile=os.path.basename(filename) + '_opt.log', trajectory=os.path.basename(filename) + '_opt.traj')
#opt.run(fmax = 0.005)

def coarse_opt(atoms):
    at = atoms.copy()
    at.calc = calc
    opt = FIRE(at, logfile = 'opt1.log', trajectory= 'opt1.traj')
    opt.run(fmax = 0.2)
    return at

def fine_opt(atoms):
    at = atoms.copy()
    at.calc = calc
    opt = QuasiNewton(at, logfile = 'opt2.log', trajectory= 'opt2.traj')
    opt.run(fmax = 0.05)
    return at

atoms = coarse_opt(atoms)
atoms = fine_opt(atoms)
write(filename + '_opt.cif', atoms)


#from ase.vibrations import Vibrations
#vib = Vibrations(atoms)
#vib.run()
#vib.summary()

