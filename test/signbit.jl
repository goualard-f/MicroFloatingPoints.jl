@testset "signbit" begin
    Float0202 = Floatmu{2,2}
    # ±0.0
    @test !signbit(Float0202(0.0)) 
    @test signbit(Float0202(-0.0))
    # x < 0.0
    @test signbit(-floatmax(Float0202))
    @test signbit(Float0202(-6.0))
    @test signbit(Float0202(-Inf))
    @test signbit(-μ(Float0202))
    # x > 0.0
    @test !signbit(floatmax(Float0202))
    @test !signbit(Float0202(6.0))
    @test !signbit(Float0202(Inf))
    @test !signbit(μ(Float0202))
    # isnan(x)
    @test !signbit(NaNμ(Float0202))
end;
