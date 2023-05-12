import os
import numpy as np
os.environ['ASE_ESPRESSO_COMMAND'] = 'mpirun -np 44 /home/public/software/qe-7.0/bin/PACKAGE.x  PARALLEL  -in  PREFIX.PACKAGEi  >  PREFIX.PACKAGEo'
os.environ['ESPRESSO_PSEUDO'] = '/home/public/pseudo/qe/pslib_paw_pbe'

from ase.io import read, write
from xespresso import Espresso

# read structure
at = read('./Li.cif')
print(at)

# 设置磁矩和Hubbard U
at.new_array('species', np.array(at.get_chemical_symbols(), dtype='U20'))
for i in range(4):
    at.arrays['species'][i] = at.arrays['species'][i] + '1'
print(at.arrays['species'])

input_ntyp = dict(
    starting_magnetization = {'Mn': 0.5, 'Mn1': -0.5},
    Hubbard_U = {'Mn': 5.6363, 'Mn1': 5.6363}
)

# 设置计算器
psus = {'Mn1':'Mn.pbe-spn-kjpaw_psl.1.0.0.UPF','Mn':'Mn.pbe-spn-kjpaw_psl.1.0.0.UPF','O':'O.pbe-n-kjpaw_psl.1.0.0.UPF','Li':'Li.pbe-s-kjpaw_psl.1.0.0.UPF'}
paras = dict(
    calculation = 'scf',
    pseudopotentials = psus,
    outdir = './tmp',                                           # tmp directory
    ecutwfc = 60, ecutrho = 300,                                # plane wave cutoff
    nspin = 2, occupations = 'smearing', degauss = 1e-8,        # spin and smearing
    conv_thr = 1e-6, electron_maxstep = 150,                    # scf conv thr
    diagonalization = 'rmm-davidson', diago_david_ndim = 4,     # scf alg
    mixing_beta = 0.3,
#    startingpot = 'file',startingwfc = 'file',                  # scf initial guess
    kpts = (2,2,1),                                             # kpts
    vdw_corr = 'dft-d3',                                        # vdw-corr, choose 'dft-d','dft-d3
    lda_plus_u = True,
    input_ntyp = input_ntyp,
    tqr = True,
    parallel = '-nk 4 -npool 2'
)
calc = Espresso(
    label = 'relax/Li',
    verbosity = 'low',
    debug=True,
    **paras
)
print(calc.parameters)
at.calc = calc

# scf calculate !!
at.get_potential_energy()

# 能带计算
paras.update(kpts=at.cell.bandpath('GMKGALHA',npoints=100), calculation = 'nscf')
calc2 = Espresso(
    label = 'relax/Li',
    verbosity = 'low',
    debug=True,
    **paras
)
# at.calc = calc2
calc2.calculate(atoms=at)

import matplotlib.pyplot as plt 
fig, ax = plt.subplots(1,1,figsize = (4,3))

efermi = calc.get_fermi_level()

bs = calc2.band_structure()

bs.plot(ax = ax, emin = efermi - 5, emax = efermi + 5)
plt.tight_layout()
plt.savefig('Li_band_structure.pdf')

# paras.update(kpts=at.cell.bandpath())
# efermi = at.calc.get_fermi_level()
# from ase.spectrum.band_structure import get_band_structure
# import matplotlib.pyplot as plt
# fig, ax = plt.subplots(1,1,figsize = (5,4))
# bs = get_band_structure(at, path=at.cell.bandpath())
# bs.plot(ax = ax, emin = efermi - 5, emax = efermi + 5)

# plt.savefig('test.png')