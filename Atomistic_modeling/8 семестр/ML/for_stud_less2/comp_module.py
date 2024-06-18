import os
import numpy as np
from dataclasses import dataclass


@dataclass
class Cell:
    xlo: float
    xhi: float
    ylo: float
    yhi: float
    zlo: float
    zhi: float


@dataclass
class Structure:
    cell: Cell
    positions: np.array
    forces: np.array


    def read_from_dump(filename: str):
        """
        Read cell, positions, forces from dump custion file

        dump    f_dump all custom n_every Lead_liquid_data/dump.Lead.* x y z fx fy fz
        """
        with open(filename, 'r') as file:
            for line in file:
                if "ITEM: BOX BOUNDS" in line:
                    xlo, xhi = map(float, file.readline().split(' '))
                    ylo, yhi = map(float, file.readline().split(' '))
                    zlo, zhi = map(float, file.readline().split(' '))
                    cell = Cell(xlo, xhi, ylo, yhi, zlo, zhi)
        
        data = np.loadtxt(filename, skiprows=9)
        # x y z fx fy fz
        positions = np.array([[item[0], item[1], item[2]] for item in data])
        forces = np.array([[item[3], item[4], item[5]] for item in data])

        return Structure(cell, positions, forces)
    

    def write_lmp_datafile(self, filename: str) -> None:
        with open(filename, 'w') as file:
            file.write("LAMMPS data file from comp_module\n\n")
            
            file.write(f"{len(self.forces)} atoms\n")
            file.write("1 atom types\n\n")

            file.write(f"{self.cell.xlo} {self.cell.xhi} xlo xhi\n")
            file.write(f"{self.cell.ylo} {self.cell.yhi} ylo yhi\n")
            file.write(f"{self.cell.zlo} {self.cell.zhi} zlo zhi\n")
            file.write("\n")

            file.write("Masses\n\n")
            file.write("1 207.2\n\n")

            file.write("Atoms # atomic\n\n")
            index=0
            for position in self.positions:
                index += 1
                file.write(f"{index} 1 {position[0]} {position[1]} {position[2]}\n")  


def compute_forces_lmp(structure: Structure, eps: float, sigma: float,
                       rcut: float=6.0, lmp_exe: str="/home/sslinux/miniconda3/envs/lmp_env/bin/lmp") -> Structure:
    
    # Write lammps data file
    structure.write_lmp_datafile("lmp_forces_calc/input.data")

    # Run LAMMPS calculation with the params
    os.chdir("/home/sslinux/ML in material science/for_stud_less2/lmp_forces_calc")
    os.system(f"{lmp_exe} -in forces_calc.lammps -screen none -var EPS {eps} -var SIGMA {sigma} -var RCUT {rcut} 2> /dev/null")
    os.chdir("..")

    calc_structure = Structure.read_from_dump("lmp_forces_calc/final.dump.custom")

    return calc_structure


def forces_rmse(structure: Structure, eps: float, sigma: float, rcut: float=6.0) -> float:

    calc_structure = compute_forces_lmp(structure, eps, sigma, rcut)
    diff_forces = structure.forces - calc_structure.forces

    return np.mean(list(map(np.linalg.norm, diff_forces)))

def pseudo_gradient(loss_func, init_params: np.array, n_iter: int=100, step_size: float=0.01) -> np.array:
    params = init_params
    for _ in range(n_iter):
        for i in range(len(params)):
            old_loss = loss_func(params)
            params[i] += step_size
            if loss_func(params) < old_loss:
                params[i] -= 2*step_size
    return params
