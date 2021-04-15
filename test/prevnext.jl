F22 = Floatmu{2,2}

@testset "prevfloat" begin
    @test prevfloat(F22(Inf)) == floatmax(F22)
    @test isnan(prevfloat(F22(NaN)))
    @test prevfloat(F22(3.5)) == 3.0
    @test prevfloat(F22(2.0)) == 1.75
    @test prevfloat(F22(1.0)) == 0.75
    @test prevfloat(F22(0.25)) == 0.0
    @test prevfloat(F22(-3.5)) == -Infμ(F22)
    @test prevfloat(Floatmu{8,23}(0.1)) == prevfloat(0.1f0)
    @test prevfloat(F22(1.25),7) == F22(-0.5)
    @test prevfloat(F22(0.75),30) == -Infμ(F22)
    @test prevfloat(F22(-0.25),0) == F22(-0.25)
    @test prevfloat(F22(-0.25),2) == F22(-0.75)
end;

@testset "nextfloat" begin
    @test nextfloat(-Infμ(F22)) == -floatmax(F22)
    @test nextfloat(F22(-0.25)) == 0.0
    @test nextfloat(F22(-0.0)) == 0.25
    @test nextfloat(F22(0.75)) == 1.0
    @test nextfloat(F22(3.0)) == 3.5
    @test nextfloat(F22(0.75)) == 1.0
    @test nextfloat(F22(3.5)) == Infμ(F22)
    @test isnan(nextfloat(NaNμ(F22)))
    @test nextfloat(F22(0.25),7) == F22(2.0)
    @test nextfloat(F22(-0.25),20) == Infμ(F22)
end;
