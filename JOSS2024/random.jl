#!/usr/bin/env julia

using MicroFloatingPoints
using PyPlot

szE = 7 # Size of the exponent part
szf = 16 # Size of the fractional part
sfs = szf+1 # Size of the significand
sz = szE+szf+1 # Size of the format
MuFP = Floatmu{szE,szf}
occurs = zeros(szf)

intdom = 0:(2^sfs-1)
divisor = MuFP(2.0^sfs)
#intdom = 0:(2^(szf+1)-1)
#divisor = MuFP(2.0^(szf+1)-1)
for i in intdom
    v = MuFP(i)/divisor
    rs = bitstring(v)
    for j = 1:szf
        global occurs[j] += Int(rs[j+1+szE] == '1')
    end
end
occurs = map(x -> 100*(x/length(intdom)),occurs)
plt.bar(1:szf,occurs)
plt.yticks(0:10:100,[string(i) for i in 0.0:0.1:1.0])
xticks = range(1,szf,length=szf)
xtickslbl = reverse(map((x)->string(Int(x-1)),xticks))
plt.xticks(xticks,xtickslbl)
plt.savefig("random.7.16.svg")
plt.show()
