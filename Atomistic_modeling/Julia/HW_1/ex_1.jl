inp = readline()
inp_splitted = split(inp)
x = parse(Int, inp_splitted[1])
y = parse(Int, inp_splitted[2])

arg1, arg2 = minmax(x, y)
println(arg1, " ", arg2)