#=
Пример файла для экспериментов.

Запуск
1. Перейдите в директорию с пакетом (где Project.toml и этот файл)
2. Исполните скрипт с указанием окружения
   julia --project=Project.toml draft.jl
=#

using Points
using LinearAlgebra

@show Point(9, 10)
@show Point(9, 10) + Point(8, 4)
@show Point(9, 10) - Point(8, 4)
@show Point(9, 10) * 6
@show 6 * Point(9, 10)
@show Point(9, 10) / 3
@show dot(Point(-1, 2), Point(-2, -3))
@show norm(Point(3, 4))
@show center([Point(3, 4), Point(-2, -3), Point(-1, 2)]) #
@show neighbors([Point(3, 4), Point(-2, -3), Point(-2, -3), Point(-2, -3), Point(-2, -3), Point(-2, -3), Point(-1, 2), Point(6, 7), Point(0, 1), Point(0, 1), Point(0, 1)], Point(-1, 2), 6)
@show Circle(Point(0, 1), 4)
@show Square(Point(0, 1), 4)
@show Point(0, 0) in Circle(Point(0, 0.5), 1)
@show Point(0, 0) in Square(Point(0.6, 0.5), 1)
@show center([Point(0, 0), Point(1, 0)], Circle(Point(0.75, 0), 0.25)) == Point(1, 0)

