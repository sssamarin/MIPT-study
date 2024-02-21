function Pr(x, d)
    return sum(x.*d)/(sum(d.*d)^0.5)
end

@show Pr([1, 1, 0], [1, -1.5, 1])