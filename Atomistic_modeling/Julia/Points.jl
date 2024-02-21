module Points

# Следющие имена должны быть публичными:
# Point, neighbors, Circle, Square, center


using LinearAlgebra

export dist, Point, neighbors, Circle, Square, center


"""
    Point(x, y)

Точка на декартовой плоскости.
"""
struct Point{T<:Real}
   x::T
   y::T
end

Point(x::Real, y::Real) = Point(promote(x,y)...)

dist(p1::Point, p2::Point) = LinearAlgebra.norm(p2 - p1)

LinearAlgebra.dot(p1::Point, p2::Point) = p1.x * p2.x + p1.y * p2.y
LinearAlgebra.norm(p::Point) = sqrt(LinearAlgebra.dot(p, p))

# Линейные операции с точками:

# Сложение;
# `+` коммутативно
Base.:+(p1::Point, p2::Point) = Point(p1.x + p2.x, p1.y + p2.y)
# Умножение на скаляр;
Base.:*(α::Number, p::Point) = Point(α * p.x, α * p.y)
Base.:*(p::Point, α::Number) = α * p
# Вычитание;
Base.:-(p::Point) = p * (-1)
Base.:-(p1::Point, p2::Point) = p1 + (-p2)
# Деление на скаляр. Деление на ноль при этом особым образом не обрабатывается;
Base.:/(p::Point, α::Number) = Point(p.x / α, p.y / α)

Base.:(==)(p1::Point, p2::Point) = (p1.x == p2.x) && (p1.y == p2.y)
Base.:(!=)(p1::Point, p2::Point) = !(p1 == p2)

"""

    center(points) -> Point

Центр "масс" точек.
"""

function center(points)
    return sum(points) / length(points)
end

"""
    neighbors(points, origin, k) -> Vector{Point}

Поиск ближайших `k` соседей точки `origin` среди точек `points`.
"""

function neighbors(points, origin::Point, k::Int)
    if k < 1 
        println("No neighbors found.")
        return Vector{eltype(points)}(undef, 0)
    end
    
    points_filtered = filter((x) -> x != origin, points)
    return sort(points_filtered, by = x -> dist(x, origin))[1:min(k, length(points_filtered))]
end
        
"""
    Circle(o::Point, radius)

Круг с центром `o` и радиусом `radius`.
"""
struct Circle{A, B}
    o::Point{A}
    radius::B
end

"""
    Square(o::Point, side)

Квадрат с центром в `o` и стороной `side`. Стороны квадрата параллельны осям координат.
"""
struct Square{A, B}
    o::Point{A}
    side::B
end

Base.:(in)(p::Point, area::Circle) = (dist(p, area.o) ≤ area.radius)
Base.:(in)(p::Point, area::Square) = ((abs(p.x - area.o.x) ≤ area.side / 2) && (abs(p.y - area.o.y) ≤ area.side / 2))

"""
    center(points, area) -> Point

Центр масс точек `points`, принадлежащих области `area` (`Circle` или `Square`).
"""
#!       center(points,                  area)
function center(points, area)
    return center(filter((x) -> x in(area), points))
end

end # module
