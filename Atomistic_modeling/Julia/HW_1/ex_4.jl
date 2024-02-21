function Parity_sort(A)
    X = sort(A[findall(elem -> (rem(elem, 2) == 1), A)])
    Y = sort(A[findall(elem -> (rem(elem, 2) == 0), A)])
    return vcat(X, Y)
end

@show Parity_sort([3, 0, 1, 5, 12, 6])