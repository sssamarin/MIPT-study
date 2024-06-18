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
    positions: np.ndarray
    forces: np.ndarray
    energy: float
    atom_types: list[str]


def reader(filename: str) -> list[Structure]:
    """
    Reads .force potfit files

    Just for one atom type

    TODO do not read last structure !!!
    """
    
    with open(filename) as file:
        Structure_arr = []
        flag = False

        for line in file:
            if((line[:2] == "#N") and flag):
                cell = Cell(0.0, xhi, 0.0, yhi, 0.0, zhi)
                Structure_arr.append(
                    Structure(cell,
                        np.array(positions),
                        np.array(forces),
                        energy,
                        atom_types
                    )
                )

            # Reading Header
            if line[0] == "#":
                
                if line[1] == "N":
                    natoms = int(line.split()[1])
                    positions = []
                    forces = []
                    flag = True
                
                if line[1] == "C":
                    atom_types = line[2:].split()
                
                if line[1] == "X":
                    xhi = float(line.split()[1])
                
                if line[1] == "Y":
                    yhi = float(line.split()[2])
                
                if line[1] == "Z":
                    zhi = float(line.split()[3])
                
                if line[1] == "N":
                    energy = float(line.split()[1]) * natoms

            else:
                position = np.array(list(map(float, line.split()[1:4])))
                force = np.array(list(map(float, line.split()[4:])))

                positions.append(position)
                forces.append(force)
    
    return Structure_arr