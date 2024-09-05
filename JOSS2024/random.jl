#!/usr/bin/env julia

using MicroFloatingPoints
using PyPlot
using MicroFloatingPoints.MFPPlot

E = 7 # Size of the exponent part
f = 16 # Size of the fractional part
p = f+1 # Size of the significand
MuFP = Floatmu{E,f}
T = zeros(f)

for v in 0:(2^p-1)
    d = MuFP(v)/2^p
    fpart = bitstring(d)[2+E:end] # Isolating the fractional part
    for j in 1:f
        global T[j] += Int(fpart[j] == '1')
    end
end
nT = map(x -> x/2^p,T)
plt.bar(1:f,nT)
plt.yticks(0:0.1:1)
plt.xticks(1:f,reverse(map((x)->string(Int(x-1)),1:f)))
#plt.savefig("random.7.8.svg")
#plt.savefig("random.7.16.svg")
plt.show()
