import numpy as np
from copy import deepcopy

def check_input(init_params: np.array, borders: np.array) -> None:
    if(len(init_params) != len(borders)):
        ValueError("Borders and params are not the same length!!!")

    for iter in range(len(init_params)):
        if((init_params[iter] < borders[iter][0]) or (init_params[iter] > borders[iter][1])):
            ValueError(f"Parameter number {iter} is out of its borders")


def check_borders(params: np.array, borders: np.array):
    flag = True
    for iter in range(len(params)):
        if((params[iter] < borders[iter][0]) or (params[iter] > borders[iter][1])):
            flag = False
    return flag


def pseudo_gradient(loss_func, init_params: np.array, borders: np.array,
                    n_iter: int=100, step_size: float=0.01) -> np.array:
    """
    Input values:
    init.params - [p1, p2, ...] array of initial values for parameters
    borders: [[p1_down, p1_up], [p2_down, p2_up], ...]

    returns optimised values [p1, p2, ...]
    """
    check_input(init_params, borders)

    params=deepcopy(init_params)
    loss = loss_func(init_params)

    params_arr = [params]

    for step in range(n_iter):
        # Perform test steps
        step = np.ones_like(params) * step_size
        for p_id in range(len(params)):
            new_params = np.array([params[i] if(p_id != i) else params[i]+step_size for i in range(len(params))])
            
            new_loss = loss_func(new_params)
            if(new_loss > loss):
                step[p_id] *= -1

        params = params + step
        loss = loss_func(params)
        params_arr.append(params)
    
    return np.array(params_arr) 


def simulated_annealing(loss_func, init_params: np.array, borders: np.array,
                        n_iter: int=1000, Tinit: float=100.0, step_size: float=0.02) -> tuple:
    """
    Returns - params: array, accepted: array
    params[i] - parameter value at step i
    accepted[i] - number of accepted steps until step i
    """
    
    check_input(init_params, borders)
    
    params = deepcopy(init_params)
    loss = loss_func(init_params)
    Temp = Tinit
    acc_count = 0

    params_arr = [params]
    acc_arr = [acc_count]

    for step in range(n_iter):
        # if(not check_borders(params, borders)):
        #     print("Warning out of range!!!")

        # MC move
        new_params = params + (2 * np.random.rand(len(params)) - 1) * step_size
        # Calc loss
        new_loss = loss_func(new_params)

        delta_loss = new_loss - loss
        a = min([1, np.exp(-(delta_loss) / Temp)])

        if(np.random.rand() <= a):
            params = deepcopy(new_params)
            loss = new_loss
            acc_count += 1
        
        params_arr.append(params)
        acc_arr.append(acc_count)
        # Decrese temp
        Temp = Tinit * (1 - step/n_iter)
        # Temp = Tinit / (step + 1.0) 

    return params_arr, acc_arr


def diff_evo(loss_func, bounds: np.array, mut: float=0.8,
             crossp: float=0.7, popsize: int=20, n_iter: int=1000) -> tuple:
    
    # Init population
    dimensions = len(bounds)
    pop = np.random.rand(popsize, dimensions)
    min_b, max_b = np.asarray(bounds).T
    diff = np.fabs(min_b - max_b)
    pop_denorm = min_b + pop * diff

    # Calc loss_function for the first pop
    fitness = np.asarray([loss_func(ind) for ind in pop_denorm])

    # Seek for the best item
    best_idx = np.argmin(fitness)
    best = pop_denorm[best_idx]

    for step in range(n_iter):
        for item_id in range(popsize):
            
            # Chose three items excluding item_id
            idxs = [idx for idx in range(popsize) if idx != item_id]
            a, b, c = pop[np.random.choice(idxs, 3, replace = False)] # pop item values are in [0, 1)

            # Create normalized mutant
            mutant = np.clip(a + mut * (b - c), 0, 1)

            cross_points = np.random.rand(dimensions) < crossp
            if not np.any(cross_points):
                cross_points[np.random.randint(0, dimensions)] = True # Select at least one

            # Create trial item
            trial = np.where(cross_points, mutant, pop[item_id])
            trial_denorm = min_b + trial * diff

            # Check if it's better than old one
            f = loss_func(trial_denorm)
            if f < fitness[item_id]:
                fitness[item_id] = f
                pop[item_id] = trial

                # Check if it's the best one
                if f < fitness[best_idx]:
                    best_idx = item_id
                    best = trial_denorm

        yield best, fitness[best_idx]