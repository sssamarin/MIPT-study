import numpy as np


def pair_interaction(A, B, alpha, beta, kap, lambd, re):
    def func(r: float):
        return A * np.exp(-alpha * (r / re - 1)) / (1 + (r / re - kap)**20) - B * np.exp(-beta * (r / re - 1)) / (1 + (r / re - lambd)**20)
    return func


def density(fe, beta, lambd, re):
    def func(r:float):
        return fe * np.exp(-beta * (r/re - 1)) / (1 + (r/re - lambd)**20)
    return func


def embedding(Fn0, Fn1, Fn2, Fn3, F0, F1, F2, F3, Fe, eta, rhoe, rhos):
    def func(rho:float):
        rhon = 0.85 * rhoe
        if(rho < rhon):
            return Fn0 + Fn1*(rho/rhon - 1) + Fn2*((rho/rhon - 1)**2) + Fn3*((rho/rhon - 1)**3)
        elif(rho < 1.15 * rhoe):
            return F0 + F1*(rho/rhoe - 1) + F2*((rho/rhoe - 1)**2) + F3*((rho/rhoe - 1)**3)
        else:
            return Fe * (1 - np.log((rho/rhos)**eta)) * ((rho/rhos)**eta)
    return func


def smooth_cutoff(func, rs: float, rf: float):
    cutoff_poly = np.polynomial.Polynomial(smooth_cutoff_polycoefs(func, rs, rf)[::-1])
    def sc(r):
        return cutoff_poly(r)
    return sc


def smooth_cutoff_polycoefs(func, rs: float, rf: float):
    """
    Function to derive G(x) = C1*x**3 + C2*x**2 + C3*x + C4 coefficients
    where G(x) - smooth cutoff function:
    -
    | G(rs) = func(rs)
    | G'(rs) = func'(rs)
    | G(rf) = 0.0
    | G'(rf) = 0.0
    -
    Returns: np.array([C1, C2, C3, C4])
    """
    if(rs < 0 or rf < 0):
        ValueError("rs and rf must be positive")

    # C * X = G
    X = np.array([
        [rs**3, rs**2, rs, 1.0],
        [3*rs**2, 2*rs, 1, 0.0],
        [rf**3, rf**2, rf, 1.0],
        [3*rf**2, 2*rf, 1, 0.0]
    ])
    
    G = np.array([func(rs), derivative(func, rs), 0.0, 0.0]).T
    return np.linalg.solve(X, G)


def derivative(func, x: float) -> float:
    dx = 1e-4
    return (func(x + dx) - func(x-dx)) / (2*dx)


# Embedding function
def bjs(F0, gamma, F1):
    def f(n):
        return F0 * (1 - gamma*np.log(n)) * n**gamma + F1 * n
    return f

# Density function
def csw2(a1, alpha, phi, beta):
    def f(r):
        return (1 + a1 * np.cos(alpha * r + phi)) / r**beta
    return f

# Pair interaction
def morse(De, a, re):
    def f(r):
        return De * ((1 - np.exp(-a(r - re)))**2 - 1)
    return f