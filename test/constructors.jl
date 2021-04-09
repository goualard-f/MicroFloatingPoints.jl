@testset "constructor" begin
    Float22 = Floatmu{2,2}
    @test Float22(0.5) == 0.5
    @test Float22(-0.0) == -0.0
    @test Float22(-Inf) == -Inf
    @test Float22(Inf) == Inf
end;
