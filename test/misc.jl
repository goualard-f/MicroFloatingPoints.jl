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
