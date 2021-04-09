@testset "Infμ" begin
    @test Infμ(Floatmu{2,2}).v == 0xc
    @test Infμ(Floatmu{8,23}) == Inf32
end;

@testset "NaNμ" begin
    @test NaNμ(Floatmu{2,2}).v == 0xe
    @test NaNμ(Floatmu{8,23}) != NaNμ(Floatmu{8,23})
end;

@testset "eps" begin
    @test eps(Floatmu{2,2}) == 0.25
    @test eps(Floatmu{5,10}) == eps(Float16)
    @test eps(Floatmu{8,23}) == eps(Float32)
end;

@testset "lambda" begin
    @test λ(Floatmu{2,2}) == 1.0
    @test λ(Floatmu{8,23}) == floatmin(Float32)
end;

@testset "mu" begin
    @test μ(Floatmu{2,2}) == 0.25
    @test μ(Floatmu{8,23}) == 2.0^(-126-23)
end;

@testset "floatmax" begin
    @test floatmax(Floatmu{2,2}) == 3.5
    @test floatmax(Floatmu{5,10}) == floatmax(Float16)
    @test floatmax(Floatmu{8,23}) == floatmax(Float32)
end;

@testset "floatmin" begin
    @test floatmin(Floatmu{2,2}) == 1.0
    @test floatmin(Floatmu{5,10}) == floatmin(Float16)
    @test floatmin(Floatmu{8,23}) == floatmin(Float32)
end;

@testset "typemin" begin
    @test typemin(Floatmu{2,2}) == -Infμ(Floatmu{2,2})
    @test typemin(Floatmu{5,10}) == -Inf16
    @test typemin(Floatmu{5,10}) == -Inf32
end;

@testset "typemax" begin
    @test typemax(Floatmu{2,2}) == Infμ(Floatmu{2,2})
    @test typemax(Floatmu{5,10}) == Inf16
    @test typemax(Floatmu{5,10}) == Inf32
end;

@testset "maxintfloat" begin
    @test maxintfloat(Floatmu{2,2}) == Inf
    @test maxintfloat(Floatmu{5,10}) == 2^11
    @test maxintfloat(Floatmu{8,23}) == 2^24
end;
