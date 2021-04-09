F22 = Floatmu{2,2}

@testset "add" begin
    @test F22(0.25)+F22(0.75) == F22(1.0)
    @test isinf(F22(3.0)+F22(1.0))
end;

@testset "sub" begin
    @test F22(0.5) - F22(0.3) == F22(0.25)
end;
