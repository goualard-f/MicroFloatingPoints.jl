@testset "Emin" begin
    Emin = MicroFloatingPoints.Emin
    @test Emin(Floatmu{2,2}) == 0
    @test Emin(Floatmu{8,23}) == -126
    @test typeof(Emin(Floatmu{8,23})) == Int32
end;


