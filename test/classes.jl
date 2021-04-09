@testset "isnan" begin
    @test isnan(Floatmu{2,2}(NaN))
    @test isnan(NaNμ(Floatmu{2,2}))
    @test !isnan(Floatmu{2,2}(0.0))
    @test !isnan(Floatmu{2,2}(-1.0))
    @test !isnan(Floatmu{2,2}(Inf))
end;

@testset "isinf" begin
    @test isinf(Floatmu{2,2}(Inf))
    @test isinf(Floatmu{2,2}(-Inf))
    @test isinf(Infμ(Floatmu{2,2}))
    @test isinf(-Infμ(Floatmu{2,2}))
    @test !isinf(Floatmu{2,2}(NaN))
    @test !isinf(Floatmu{2,2}(-1.0))
    @test !isinf(floatmax(Floatmu{2,2}))
end;

@testset "isfinite" begin
    @test isfinite(Floatmu{2,2}(0.0))
    @test isfinite(Floatmu{2,2}(-1.0))
    @test isfinite(Floatmu{2,2}(1.0))
    @test !isfinite(Floatmu{2,2}(5.0))
    @test !isfinite(Floatmu{2,2}(Inf))
    @test !isfinite(Floatmu{2,2}(NaN))
end;

@testset "issubnormal" begin
    F22 = Floatmu{2}{2}
    @test issubnormal(μ(Floatmu{2,2}))
    @test issubnormal(Floatmu{2,2}(0.5))
    @test !issubnormal(Floatmu{2,2,}(0.0))
    @test !issubnormal(Floatmu{2,2,}(-0.0))
    @test !issubnormal(Floatmu{2,2,}(NaN))
    @test !issubnormal(Floatmu{2,2,}(Inf))
end;
