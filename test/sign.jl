@testset "sign" begin
    Float0202 = Floatmu{2,2}
    # ±0.0
    @test sign(Float0202(0.0)) == 0.0
    @test sign(Float0202(-0.0)) == -0.0
    @test signbit(Float0202(-0.0))
    @test !signbit(Float0202(0.0))
    # x < 0.0
    @test sign(-floatmax(Float0202)) == -1.0
    @test sign(Float0202(-6.0)) == -1.0
    @test sign(Float0202(-Inf)) == -1.0
    @test sign(-μ(Float0202)) == -1.0
    # x > 0.0
    @test sign(floatmax(Float0202)) == 1.0
    @test sign(Float0202(6.0)) == 1.0
    @test sign(Float0202(Inf)) == 1.0
    @test sign(μ(Float0202)) == 1.0
    # isnan(x)
    @test isnan(sign(NaNμ(Float0202)))
end;
