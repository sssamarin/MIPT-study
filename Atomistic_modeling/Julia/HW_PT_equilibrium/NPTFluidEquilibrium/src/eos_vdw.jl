struct VanderWaalsComponent{S,T}
    name::S
    a::T
    b::T
    P_c::T
    T_c::T
end

struct VanderWaalsMixture{C,M}
    comps::C
    aij::M
end

"Коэффициент B для смеси."
covolume(mixture::VanderWaalsMixture, nmol) = dot(nmol, [c.b for c in mixture.comps])

"Коэффициент A для смеси."
energy_coeff(mixture::VanderWaalsMixture, nmol) = dot(nmol, mixture.aij, nmol)

function VanderWaalsMixture(comps)
    a = [c.a for c in comps]  # getfield.(comps, :a)
    aij = sqrt.(a * a')
    return VanderWaalsMixture(comps, aij)
end

function pressure(mixture::VanderWaalsMixture, nmol, V, RT)
    # Практикум PT-стабильность, уравнение 9
    A = energy_coeff(mixture, nmol)
    B = covolume(mixture, nmol)
    return sum(nmol) * RT / (V - B) - A / V^2
end

function zfactors(mixture::VanderWaalsMixture, nmol, P, RT)
    molfrac = nmol / sum(nmol)

    A = energy_coeff(mixture, molfrac) * P / RT^2
    B = covolume(mixture, molfrac) * P / RT

    zwithnans = solve_cubic(1, -B-1, A, -A * B)
    return filter(!isnan, zwithnans)
end

"Логарифмы коэф. летучести (PT-стабильность, ур. 12)."
function logfugacitycoef(mixture::VanderWaalsMixture, nmol, P, RT, z)
    molfrac = nmol / sum(nmol)
    B = covolume(mixture, molfrac) * P / RT
    Aderiv = 2 * mixture.aij * molfrac

    b = [c.b for c in mixture.comps]  # DRY
    return @. - log(z - B) + b * P / (RT * (z - B)) - P * Aderiv / (z * RT^2)
end

"Логарифмы коэф. летучести для фазы `phase`."
function logfugacitycoef(mixture::VanderWaalsMixture, nmol, P, RT, phase::Symbol)
    zs = zfactors(mixture, nmol, P, RT)
    # >(0) <===> x -> x > 0
    z = phase == :gas ? maximum(filter(>(0), zs)) : minimum(filter(>(0), zs))
    return logfugacitycoef(mixture, nmol, P, RT, z)
end

function wilson_correlation(component::VanderWaalsComponent, P, T)
    K = component.P_c / P * exp(5.42*(1 - component.T_c / T))
    return K
end



