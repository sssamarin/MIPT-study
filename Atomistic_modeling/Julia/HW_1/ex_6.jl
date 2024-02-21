function pressurevdw(Vr, Tr)
    A = zeros(Float32, (length(Tr), length(Vr)))
    for i in eachindex(Tr)
        A[i, :] = Tr[i].*8 ./ (Vr.*3 .- 1) .- 3 ./ (Vr.^2)
        # print("Pᵣ grid for Tᵣ = ", Tr[i], " is ", A[i, :], "\n")
    end
    return A
end

@show pressurevdw(range(1, 5),  [0.85, 1., 1.15])