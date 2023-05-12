import os
import numpy as np
os.environ['ASE_ESPRESSO_COMMAND'] = 'mpirun -np 44 /home/public/software/qe-7.0/bin/PACKAGE.x  PARALLEL  -in  PREFIX.PACKAGEi  >  PREFIX.PACKAGEo'
os.environ['ESPRESSO_PSEUDO'] = '/home/public/pseudo/qe/pslib_paw_pbe'

from ase.io import read, write
from xespresso import Espresso

# read structure
at = read('./Li.cif')
print(at,'\n')

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
    calculation = 'relax',
    pseudopotentials = psus,
    outdir = './tmp',                                           # tmp directory
    ecutwfc = 70, ecutrho = 420,                                # plane wave cutoff
    nspin = 2, occupations = 'smearing', degauss = 1e-8,        # spin and smearing
    conv_thr = 1e-6, electron_maxstep = 150,                    # scf conv thr
    diagonalization = 'rmm-davidson', diago_david_ndim = 4,     # scf alg
    mixing_beta = 0.3,
#    startingpot = 'file',startingwfc = 'file',                  # scf initial guess
    kpts = (4,4,2),                                             # kpts
    vdw_corr = 'dft-d3',                                        # vdw-corr, choose 'dft-d','dft-d3
    lda_plus_u = True,
    input_ntyp = input_ntyp,
    tqr = True,
    parallel = '-nk 4 -npool 2'
)
calc = Espresso(
    label = 'relax/Li',
    verbosity = 'low',
    disk_io = 'low',
    debug=True,
    **paras
)
print(calc.parameters,'\n')

at.calc = calc

# scf calculate !!
at.get_potential_energy()

# write relaxed
write('Li_relaxed.vasp',calc.results['atoms'])