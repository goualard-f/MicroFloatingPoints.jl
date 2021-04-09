@testset "Emax" begin
    Emax = MicroFloatingPoints.Emax
    @test Emax(Floatmu{2,2}) == 1
    @test Emax(Floatmu{8,23}) == 127
    @test typeof(Emax(Floatmu{8,23})) == Int64
end;
