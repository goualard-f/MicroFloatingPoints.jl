F22 = Floatmu{2,2}

@testset "isinexact" begin
    @test !isinexact(F22(0.25))
    @test isinexact(F22(0.3))
    @test !isinexact(F22(-0.25))
    @test isinexact(F22(-0.3))
    @test !isinexact(NaNμ(F22))
    @test !isinexact(Infμ(F22))
    @test isinexact(F22(4.5))
    @test isinexact(F22(-4.5))
end;

@testset "errorsign" begin
    @test errorsign(F22(0.5)) == 0
    @test errorsign(F22(0.7)) == 1
    @test errorsign(F22(0.3)) == -1
    @test errorsign(F22(0.0)) == 0
    @test errorsign(F22(-0.0)) == 0
    @test errorsign(F22(1.3)) == -1
    @test errorsign(F22(1.4)) == 1
    @test errorsign(F22(-0.5)) == 0
    @test errorsign(F22(-0.7)) == -1
    @test errorsign(F22(-0.3)) == 1
    @test errorsign(F22(0.0)) == 0
    @test errorsign(F22(-0.0)) == 0
    @test errorsign(F22(-1.3)) == 1
    @test errorsign(F22(-1.4)) == -1
    @test errorsign(NaNμ(F22)) == 0
    @test errorsign(F22(4.5)) == 1
    @test errorsign(F22(-4.5)) == -1
    @test errorsign(F22(Inf)) == 0
    @test errorsign(F22(-Inf)) == 0
end;

@testset "reset_inexact" begin
    F22(0.25)+F22(2.0);
    @test inexact()
    reset_inexact()
    @test !inexact()
end;

@testset "inexact" begin
    reset_inexact()
    F22(0.5)+F22(0.5)
    @test !inexact()
    F22(3.25)-F22(2.0) # Result is representable but 3.25 is not.
    @test inexact()
    reset_inexact()
    F22(0.75)/F22(2.0) # Both operands are representable but the result is not
    @test inexact()
end;
