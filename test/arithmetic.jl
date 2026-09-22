F22 = Floatmu{2,2}

@testset "add" begin
    @test F22(0.25)+F22(0.75) == F22(1.0)
    @test isinf(F22(3.0)+F22(1.0))
end;

@testset "sub" begin
    @test F22(0.5) - F22(0.3) == F22(0.25)
end;

FP8 = Floatmu{4,3}

@testset "rem" begin
    @test rem(FP8(5.5), FP8(3.0)) == FP8(2.5)
end;

@testset "mod" begin
    @test mod(FP8(5.5), FP8(3.0)) == FP8(2.5)
end;

@testset "^" begin
    @test FP8(1.5)^FP8(2.5) == FP8(2.7556759606310752)
end;

@testset "fma" begin
    @test fma(FP8(1.5), FP8(2.5), FP8(0.5)) == FP8(4.25)
end;
