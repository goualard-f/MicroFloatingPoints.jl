@testset "constructor" begin
    Float22 = Floatmu{2,2}
    @test Float22(0.5) == 0.5
    @test Float22(-0.0) == -0.0
    @test Float22(-Inf) == -Inf
    @test Float22(Inf) == Inf
end;

@testset "convert from Rational{BigInt} to Floatmu{}" begin
    @test Floatmu{5,5}(Rational{BigInt}(3.1))==Floatmu{5,5}(3.1)
end;
