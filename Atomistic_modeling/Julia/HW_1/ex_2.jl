N = parse(Int, readline())
A = zeros(Int, N)
A[1] = 1
for i in 2:N
    A[i] += A[i-1]
    if i > 3
        A[i] += A[i-3] 
    end
end
print(A[N])