@testset "Emin" begin
    Emin = MicroFloatingPoint.Emin
    @test Emin(Floatmu{2,2}) == 0
    @test Emin(Floatmu{8,23}) == -126
    @test typeof(Emin(Floatmu{8,23})) == Int64
end;
