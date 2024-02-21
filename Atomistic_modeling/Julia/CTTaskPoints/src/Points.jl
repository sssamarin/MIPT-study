module Points

# export, using, import statements are usually here
using LinearAlgebra

# Следющие имена должны быть публичными:
# Point, neighbors, Circle, Square, center
export Point, neighbors, Circle, Square, center, dist

"""
    Point(x, y)

Точка на декартовой плоскости.
"""
# struct Point{T<:Real}                             # типы полей одного типа
struct Point#{T1, T2}                    # типы полей м.б. разного типа, но ниже мы приводим их при вызове
    x
    y
end

# Point(x::Real, y::Real) = Point(promote(x, y)...)   # приводит типы x и y

# x(p::Point) = p.x
# y(p::Point) = p.y

Base.:+(p1::Point, p2::Point) = Point(p1.x + p2.x, p1.y + p2.y)        # сложение
Base.:*(a::Number, p::Point) = Point(a * p.x, a * p.y)                 # умножения на скаляр
Base.:*(p::Point, a::Number) = Point(a * p.x, a * p.y)
Base.:-(p1::Point) = (-1) * p1
Base.:-(p1::Point, p2::Point) = p1 + (-1) * p2                         # вычитание
Base.:/(p::Point, a::Number) = Point(p.x / a, p.y / a)                 # деление на 0 (деление на 0 не обрабатывается)

# перегрузка операторов из иодуля LinearAlgebra
LinearAlgebra.dot(p1::Point, p2::Point) = p1.x * p2.x + p1.y * p2.y    # скалярное умножение
LinearAlgebra.norm(p::Point) = sqrt(LinearAlgebra.dot(p, p))           # евклидова норма вектора

"""
    center(points) -> Point

Центр "масс" точек.
"""
function center(points)
    return sum(points) / size(points)[1]
    # Statistics.mean(points)
end

# import Statistics
# center(points) = Statistics.mean(points) 

"""
    neighbors(points, origin, k) -> Vector{Point}

Поиск ближайших `k` соседей точки `origin` среди точек `points`.
"""
function dist(p1::Point, p2::Point)
    return LinearAlgebra.norm(p2 - p1)
end

# function neighbors(points::AbstractVector{<:Point}, origin::Point, k::Int)::Vector{<:Point}
function neighbors(points, origin::Point, k::Int)
    if k <= 0 
        return Vector{eltype(points)}(undef, 0)
    end
    points_upd = filter((p) -> p != origin, points)
    sort!(points_upd, by = (p -> dist(origin, p)))
    if size(points_upd)[1] < k
        println("Only ", size(points_upd)[1], " neighbors in given vector \n")
    end
    return points_upd[1:min(k, size(points_upd)[1])]
end

"""
    Circle(o::Point, radius)

Круг с центром `o` и радиусом `radius`.
"""
struct Circle#{T::Real}
    o::Point
    radius#::T
end
            
# o(circ::Circle) = circ.o
# radius(circ::Circle) = circ.radius

"""
    Square(o::Point, side)

Квадрат с центром в `o` и стороной `side`. Стороны квадрата параллельны осям координат.
"""
struct Square#{T::Real}
    o::Point 
    side#::T
end
                
# o(sq::Square) = sq.o
# side(sq::Square) = sq.side

Base.:(in)(p::Point, area::Circle) = (dist(p, area.o) <= area.radius)
Base.:(in)(p::Point, area::Square) = ((abs(p.x - area.o.x) <= (area.side / 2)) && (abs(p.y - area.o.y) <= (area.side / 2)))
                
"""
    center(points, area) -> Point

Центр масс точек `points`, принадлежащих области `area` (`Circle` или `Square`).
"""
# function center(points::AbstractVector{<:Point}, area)::Point
function center(points, area)

    return center(filter((p) -> p in area, points))
end

end # module