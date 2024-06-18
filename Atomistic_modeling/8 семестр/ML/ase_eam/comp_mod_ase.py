import numpy as np
from scipy.interpolate import InterpolatedUnivariateSpline as Spline

from ase.build import bulk
from ase.calculators.eam import EAM
from ase import Atoms

import potfit_reader as pr


def init_eam(F_rho: np.array, Rho_r: np.array, Phi_r: np.array,
        rcut: float, elements: list[str], masses: list[float]
    ) -> EAM:
    
    if(len(Rho_r) != len(Phi_r)):
        ValueError("rho and phi have different length!!!")

    if(np.isnan(F_rho).any() or np.isnan(Rho_r).any() or np.isnan(Phi_r).any()):
        ValueError("Input arrays contain nan value")
    
    r = np.linspace(0.0, rcut, len(Phi_r))
    rho = np.linspace(0.0, rcut, len(Phi_r))

    d_F_rho = np.gradient(F_rho, rho)
    d_Phi_r = np.gradient(Phi_r, r)
    d_Rho_r = np.gradient(Rho_r, r)

    s_F_rho = Spline(rho, F_rho)
    s_d_F_rho = Spline(rho, d_F_rho)
    s_Rho_r = Spline(r, Rho_r)
    s_d_Rho_r = Spline(r, d_Rho_r)
    s_Phi_r = Spline(r, Phi_r)
    s_d_Phi_r = Spline(r, d_Phi_r)

    pot = EAM(elements=elements,
            embedded_energy=np.array([s_F_rho]),
            d_embedded_energy=np.array([s_d_F_rho]),
            electron_density=np.array([s_Rho_r]),
            d_electron_density=np.array([s_d_Rho_r]),
            phi=np.array([[s_Phi_r]]),
            d_phi = np.array([[s_d_Phi_r]]),
            cutoff=rcut,
            form='alloy',
            mass=masses
        )

    return pot

def comp_fe_ase(pot: EAM, structure: pr.Structure) -> pr.Structure:
    xhi = structure.cell.xhi
    yhi = structure.cell.yhi
    zhi = structure.cell.zhi
    natoms = len(structure.positions)

    atoms = Atoms(
            structure.atom_types*natoms,
            positions=structure.positions,
            cell=[xhi, yhi, zhi],
            pbc="True"            
        )
    
    atoms.calc = pot

    forces = atoms.get_forces()
    energy = atoms.get_potential_energy()

    calc_structure = pr.Structure(
            structure.cell, 
            structure.positions,
            forces,
            energy,
            structure.atom_types
        )
    
    return calc_structure


if __name__ == "__main__":
    pot = EAM(potential='Lead.eam.alloy')
    F_rho = pot.embedded_data[0]
    Rho_r = pot.density_data[0]
    Phi_r = pot.phi[0][0](np.linspace(0, 6.0, 1000))

    test_pot  = init_eam(F_rho, Rho_r, Phi_r, 6.0, ['Pb'], 207.2)

    structure = pr.reader("train.force")[0]
    print(comp_fe_ase(pot, structure).energy)
    print(comp_fe_ase(test_pot, structure).energy)