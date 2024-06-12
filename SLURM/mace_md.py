
from ase.io import read, write
from ase import units
from ase.md.velocitydistribution import MaxwellBoltzmannDistribution
from ase.md.nvtberendsen import NVTBerendsen
from mace.calculators import mace_mp
import os

filename = './mol3.xsd'

# load mace-mp float 32 model
calc = mace_mp(model="medium", dispersion=False, default_dtype="float32", device='cpu')

# read initial structure and set calc
atoms = read(filename)
print(atoms.cell)
atoms.center(10, axis=2)
write(os.path.basename(filename) + '_out.pdb', atoms)
print(atoms.cell)


atoms.calc = calc 

# optimize
from ase.optimize import QuasiNewton
opt = QuasiNewton(atoms, logfile=os.path.basename(filename) + '_opt.log', trajectory=os.path.basename(filename) + '_opt.traj')
opt.run(fmax = 0.8)

# Set the momenta corresponding to T=300K
MaxwellBoltzmannDistribution(atoms, temperature_K=300)
# dyn = Langevin(atoms, 2*units.fs, temperature_K=310, friction = 0.01)
# dyn = VelocityVerlet(atoms, 2*units.fs)
dyn = NVTBerendsen(atoms, timestep=1 * units.fs, temperature_K=300, taut=0.5*1000*units.fs, logfile=os.path.basename(filename) + '_md.log')

def printenergy(a):
    """Function to print the potential, kinetic and total energy"""
    epot = a.get_potential_energy() / len(a)
    ekin = a.get_kinetic_energy() / len(a)
    print('Energy per atom: Epot = %.3feV  Ekin = %.3feV (T=%3.0fK)  '
          'Etot = %.3feV' % (epot, ekin, ekin / (1.5 * units.kB), epot + ekin))

def write_frame():
        dyn.atoms.write(os.path.basename(filename) + '_md_traj.pdb', append=True)
        printenergy(atoms)
dyn.attach(write_frame, interval=2)
dyn.run(5000)

print(os.path.basename(filename) + " MD finished!")
