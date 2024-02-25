from numba import njit
from numba.openmp import openmp_context as openmp
@njit
def piFunc(NumSteps):
    step = 1.0/NumSteps
    sum = 0.0

    with openmp ("parallel for private(x) reduction(+:sum)"):
        for i in range(NumSteps):
            x = (i+0.5)*step
            sum += 4.0/(1.0 + x*x)
    pi = step*sum
    return pi
pi = piFunc(100000000)
