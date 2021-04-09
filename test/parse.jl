@testset "parse" begin
    @test parse(Floatmu{2,2},"0.25") == Floatmu{2,2}(0.25)
    @test parse(Floatmu{8,23},"-0.1") == -0.1f0
    @test isinf(parse(Floatmu{2,2},"4.5"))
    @test isnan(parse(Floatmu{2,2},"NaN"))
    @test isinf(parse(Floatmu{2,2},"Inf"))
    @test_throws ArgumentError parse(Floatmu{2,2},"foo")
end;

@testset "tryparse" begin
    @test tryparse(Floatmu{2,2},"0.25") == Floatmu{2,2}(0.25)
    @test tryparse(Floatmu{8,23},"-0.1") == -0.1f0
    @test isinf(tryparse(Floatmu{2,2},"4.5"))
    @test isnan(tryparse(Floatmu{2,2},"NaN"))
    @test isinf(tryparse(Floatmu{2,2},"Inf"))
    @test tryparse(Floatmu{2,2},"foo") == nothing
end;
