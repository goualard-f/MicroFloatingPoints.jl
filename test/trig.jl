FP8 = Floatmu{4,3}

@testset "atan" begin
    @test atan(FP8(1.5), FP8(2.5)) == FP8(0.5404195002705842)
end;
