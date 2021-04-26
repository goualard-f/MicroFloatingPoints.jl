@testset "vertical_popcount" begin
    @test vertical_popcount(Floatmu{2,2}[3.5]) == [1,1,0,1,0]
    @test join(string.(reverse(vertical_popcount(Floatmu{8,23}[13.1])))) == bitstring(Float32(13.1))
    @test vertical_popcount(Floatmu{2,2}[0.25,0.5,2.0]) == [1,1,0,1,0]
end;
