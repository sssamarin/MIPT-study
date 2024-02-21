# Считывание массива в строку
# A = parse.(split(readline()))
# A = [parse(Int, elem) for elem in split(readline())]

function Arr_to_positive_arr(A)
    A = deleteat!(A, findall(x -> (x <= 0), A))
    return A
end

@show Arr_to_positive_arr([1, 0, 3, -5, 12])