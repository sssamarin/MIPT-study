struct NLSolveSolution{V}
    isconverged::Bool
    x::V
    niter::Int
end


"""
Ищет неподвижную точку функции `g`, начиная с `x₁`. Выполняет итерации до тех пор,
пока подшаг к ответу ≥ `xtol`, но не более `maxiter` раз.
"""
function fixedpoint(g, x0; xtol=eps(), maxiter=25)
    x = float.(x0)
    for i in 1:maxiter
        try
            xprev = x
            x = g(xprev)
            norm(x - xprev) < xtol && return NLSolveSolution(true, x, i)
        catch e
            e isa DomainError && return NLSolveSolution(false, x, i)
            throw(e)
        end
    end
    return NLSolveSolution(false, x, maxiter)
end


"""
    newtonsys(f, x, J[; maxiter=50, xtol=1e-6, ftol=1e-6])

Решает нелинейную систему `f`(x) = 0 методом Ньютона-Рафсона, начиная с приближения `x`.
Функция `J`(x) должна возвращать матрицу Якоби системы. Работа метода ограничена
числом итераций `maxiter`, досрочное завершение происходит при достижении
`norm(x) < xtol` или `norm(f(x)) < ftol`. При превышении числа итераций вызывает
ошибку. Возвращает найденный корень.
"""
function newtonsys(f, x, J; maxiter=50, xtol=1e-6, ftol=1e-6)
    x = float(copy(x))
    δx, y = similar.((x, x))
    for i in 1:maxiter
        try
            y .= f(x)
            δx .= .- (J(x) \ y)
            x .+= δx

            norm(δx) < xtol && return NLSolveSolution(true, x, i)
            norm(y) < ftol && return NLSolveSolution(true, x, i)
        catch e
            e isa DomainError && return NLSolveSolution(false, x, i)
            throw(e)
        end
    end
    return NLSolveSolution(false, x, maxiter)
end