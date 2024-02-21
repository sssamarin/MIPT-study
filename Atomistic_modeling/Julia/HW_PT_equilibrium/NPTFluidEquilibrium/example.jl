using NPTFluidEquilibrium

# Параметры a и b урс вдВ из https://en.wikipedia.org/wiki/Van_der_Waals_constants_(data_page)
# Крит. точка из https://webbook.nist.gov/chemistry/ (Search - ... - Phase change data), например, https://webbook.nist.gov/cgi/cbook.cgi?ID=C74828&Units=SI&Mask=4#Thermo-Phase
c1 = VanderWaalsComponent("methane", 2.283 / 10, 0.04278 / 1000, 46.1e5, 190.6)
c2 = VanderWaalsComponent("ethane", 5.562 / 10, 0.0638 / 1000, 48.8e5, 305.0)
c3 = VanderWaalsComponent("propane", 8.779 / 10, 0.08445 / 1000, 42.6e5, 370.0)
c4 = VanderWaalsComponent("butane", 14.66 / 10, 0.1226 / 1000, 38e5, 425.0)
c5 = VanderWaalsComponent("pentane", 19.26 / 10, 0.146 / 1000, 33.6e5, 469.8)
c6 = VanderWaalsComponent("hexane", 24.71 / 10, 0.1735 / 1000, 30.3e5, 508.0)
N2 = VanderWaalsComponent("nitrogen", 1.370 / 10, 0.0387 / 1000, 33.9e5, 126.0)

mixture = VanderWaalsMixture([c1, c2, c3, c4, c5, c6, N2])
molfrac = [0.9430, 0.0270, 0.0074, 0.0049, 0.0027, 0.0010, 0.0140]
Trange = range(25, 225; step=1)    
Prange = range(1e5, 100e5; step=1e5)  # 1 - 100 бар

println(join(["Давление (Па),", "Температура (К),", "Сошлось?,", "Min TPD (Дж/моль)"], '\t'))
for T in Trange, P in Prange
    RT = T * NPTFluidEquilibrium.GAS_CONSTANT_SI
    K = NPTFluidEquilibrium.wilson_correlation.(mixture.comps, P, T)

    result = [
        stability(mixture, molfrac, P, RT, K .* molfrac, :liquid, :gas),
        stability(mixture, molfrac, P, RT, K .* molfrac, :liquid, :liquid),
        stability(mixture, molfrac, P, RT, molfrac ./ K, :gas, :liquid),
        stability(mixture, molfrac, P, RT, molfrac ./ K, :gas, :gas),
    ]

    isconverged = any(r -> r.isconverged, result)
    mintpd = isconverged ? minimum(r -> r.tpd, filter(r -> r.isconverged, result)) : NaN
    println(P, '\t', T, '\t', Int(isconverged), '\t', mintpd)
    # println(P, ',', T, ',', Int(isconverged), ',', mintpd) # использовать маску для построения картинки (красный сини йбелый)
    # использовать логическое и 
end
