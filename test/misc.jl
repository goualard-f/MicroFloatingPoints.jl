@testset "double_fields" begin
    dfields = MicroFloatingPoints.double_fields
    @test dfields(0.0) == (0,0,0)
    @test dfields(-1.0) == (1, 1023, 0)
    @test dfields(Inf) == (0, 2047, 0)
end;

@testset "nb_fp_numbers" begin
    nbfp = MicroFloatingPoints.nb_fp_numbers
    F22 = Floatmu{2,2}
    F823 = Floatmu{8,23}
    @test nbfp(F823(-0.0),F823(0.0)) == 1
    @test nbfp(F22(0.0),nextfloat(F22(0.0))) == 2
    @test nbfp(floatmax(F823),Infμ(F823)) == 2
    @test nbfp(floatmax(F22),Infμ(F22)) == 2
    @test nbfp(F22(-0.0),floatmax(F22)) == 12
    @test nbfp(-floatmax(F22),floatmax(F22)) == 23
    @test_throws ArgumentError nbfp(F22(1.5),F22(0.25))
    @test nbfp(F22(-3.5),F22(-3.0)) == 2
    @test nbfp(F22(-0.5),F22(-0.0)) == 3
    @test nbfp(F22(-0.5),F22(0.0)) == 3
    @test nbfp(F22(-1.0),F22(0.75)) == 8
end;


@testset "precision" begin
    @test precision(Floatmu{5,10}) == precision(Float16)
    @test precision(Floatmu{8,23}) == precision(Float32)
end;

@testset "exponent" begin
    F823 = Floatmu{8,23}
    @test exponent(F823(134.26)) == exponent(134.26f0)
    @test exponent(F823(-12345.78)) == exponent(-12345.78f0)
    @test exponent(nextfloat(F823(0.0))) == exponent(nextfloat(0.0f0))
    @test_throws DomainError exponent(F823(Inf))
    @test_throws DomainError exponent(F823(NaN))
    @test_throws DomainError exponent(F823(0.0))
    @test_throws DomainError exponent(F823(-0.0))
end;

@testset "significand" begin
    F823 = Floatmu{8,23}
    @test significand(F823(134.26)) == significand(134.26f0)
    @test significand(F823(-12345.78)) == significand(-12345.78f0)
    @test significand(nextfloat(F823(0.0))) == significand(nextfloat(0.0f0))
    @test significand(F823(Inf)) == significand(Inf32)
    @test isnan(significand(F823(NaN)))
    @test significand(F823(0.0)) == significand(0.0f0)
    @test significand(F823(-0.0)) == significand(-0.0f0)
    @test significand(Floatmu{4,4}(1.5)) == 1.5
end;

@testset "fractional_even" begin
    F823 = Floatmu{8,23}
    @test fractional_even(F823(1.0))
    @test !fractional_even(nextfloat(F823(1.0)))
end;
