# CTTaskPoints

Задание для курса вычислительной термодинамики.

## Как пользоваться кодом?

### Скачивание

**Если вы не пользуетесь git**

Нажмите на кнопку Code, затем Download ZIP. Работайте со скачанным кодом как обычно.

**Если вы пользуетесь git**

Сделайте Fork репозитория (кнопка Fork справа сверху, рядом со Star). Затем склонируйте ваш Fork и работайте, как обычно.

### Установка библиотек

1. Перейдите в директорию со скачанным кодом.
2. Запустите julia и перейдите в режим `pkg>` (нажав `]`).
3. Выполните команду `activate .`, prompt должен смениться на (Points).
4. Выполните команду `instantiate`. Julia должна сообщить, что библиотеки скачаны.

```console
$ pwd
/bla/bla/bla/CTTaskPoints
$ julia
               _
   _       _ _(_)_     |  Documentation: https://docs.julialang.org
  (_)     | (_) (_)    |
   _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 1.6.2 (2021-07-14)
 _/ |\__'_|_|_|\__'_|  |  Official https://julialang.org/ release
|__/                   |

julia> ]

(@v1.6) pkg> activate .
  Activating environment at `/bla/bla/bla/CTTaskPoints/Project.toml`

(Points) pkg> instantiate
Precompiling project...
  1 dependency successfully precompiled in 2 seconds (1 already precompiled)

(Points) pkg> 
```

### Самопроверка

#### Самопроверка вручную

В корне пакета есть пример файла для экспериментов `draft.jl` с использованием модуля `Points`.
Чтобы его запустить, необходимо при запуске julia указать окружение `Project.toml`

```console
$ cd /path/to/CTTaskPoints.jl
$ julia --project=Project.toml draft.jl
```

Можете изменять файл `draft.jl` (и создавать новые) по своему усмотрению.

#### Система тестов

В задании есть система тестов для самопроверки.

Её можно запустить из терминала или REPL.

**Запуск из терминала**

```console
$ cd /path/to/CTTaskPoints.jl
$ julia --project=Project.toml test/runtests.jl 
Results
Реализация модуля Points

Конструкторы struct Point
No.   Result  Score  [Name]  [Error]
   1       E      0  Point(::Int, ::Int)  Error occured: UndefVarError(:Point)
   2       E      0  Point(::Float64, ::Float64)  Error occured: UndefVarError(:Point)
   3       E      0  Point(::Int, ::Float64)  Error occured: UndefVarError(:Point)
...
```

**Запуск из REPL**

```console
$ cd /path/to/CTTaskPoints.jl
$ julia
               _
   _       _ _(_)_     |  Documentation: https://docs.julialang.org
  (_)     | (_) (_)    |
   _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 1.6.2 (2021-07-14)
 _/ |\__'_|_|_|\__'_|  |  Official https://julialang.org/ release
|__/                   |

julia> ]

(@v1.6) pkg> activate .
  Activating environment at `/bla/bla/bla/CTTaskPoints/Project.toml`
 
(Points) pkg> test
...
Results
Реализация модуля Points

Конструкторы struct Point
No.   Result  Score  [Name]  [Error]
   1       E      0  Point(::Int, ::Int)  Error occured: UndefVarError(:Point)
   2       E      0  Point(::Float64, ::Float64)  Error occured: UndefVarError(:Point)
...
```

При тестировании из REPL можно вносить изменения в коде `src/` и вызывать тестирование *без перезапуска* REPL.
