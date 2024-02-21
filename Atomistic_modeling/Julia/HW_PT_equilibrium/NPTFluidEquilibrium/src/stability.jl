struct StabilityResult{V,T}
    isconverged::Bool
    molfrac::V  # мольные доли тестовой фазы (фазы-зародыша)
    tpd::T      # значение TPD функции в решении системы (в molfrac)
end

stability_success(molfrac, tpd) = StabilityResult(true, molfrac, tpd)
stability_failed(ncomps::Int) = StabilityResult(false, fill(NaN, ncomps), NaN)

"TPD (PT-стабильность, ур. 3)"
function tangentplanedistance(mixture, P, RT, testmolfrac, testphase, basemolfrac, basephase)
    test_logφ = logfugacitycoef(mixture, testmolfrac, P, RT, testphase)
    base_logφ = logfugacitycoef(mixture, basemolfrac, P, RT, basephase)
    Δμ = RT * (log.(testmolfrac) - log.(basemolfrac) + test_logφ - base_logφ)
    return dot(testmolfrac, Δμ)
end

function stability(mixture, nmol, P, RT, Xinit, basephase::Symbol, testphase::Symbol)
    @assert basephase in (:gas, :liquid)
    @assert testphase in (:gas, :liquid)

    molfrac = nmol / sum(nmol)

    # hᵢ = ln zᵢ + ln φᵢ(z) = constᵢ
    h = log.(molfrac) + logfugacitycoef(mixture, molfrac, P, RT, basephase)

    # Связь мол. долей тестовой фазы и переменных X
    # xᵢ = Xᵢ / sum(Xᵢ)

    # Грубое решение задачи методом простой итерации
    # Система для неподвижной точки на вектор ln Xᵢ
    # ln Xᵢ = hᵢ - ln φᵢ( x(ln Xᵢ) ) = g( ln Xᵢ )
    function fixpointtarget(logX)
        X = exp.(logX)
        testmolfrac = X / sum(X)
        return h - logfugacitycoef(mixture, testmolfrac, P, RT, testphase)
    end

    rudesol = fixedpoint(fixpointtarget, log.(Xinit); xtol=1e-5, maxiter=25)

    #----------------------------------#

    # Уточнение решения методом Ньютона
    # ln Xᵢ + ln φᵢ( x(Xᵢ) ) - hᵢ = 0
    function system(logX)
        X = exp.(logX)
        testmolfrac = X / sum(X)
        return -h + logfugacitycoef(mixture, testmolfrac, P, RT, testphase) + logX
    end

    J(x) = ForwardDiff.jacobian(system, x)

    if rudesol.isconverged
        X = exp.(rudesol.x)
    else
        X = Xinit
    end
    
    exactsol = newtonsys(system, log.(X), J)

    #-----------------------------------#
    # подсчитали точное реш-е

    if exactsol.isconverged
        X = exp.(rudesol.x)
        testmolfrac = X / sum(X)
        tpd = tangentplanedistance(mixture, P, RT, testmolfrac, testphase, molfrac, basephase)
        return stability_success(testmolfrac, tpd)
    else
        return stability_failed(size(molfrac, 1))
    end

end
