@testset "Emask" begin
    Emask=MicroFloatingPoints.Emask
    @test Emask(Floatmu{2,2}) == 0xc
    @test Emask(Floatmu{8,23}) == 0x7f800000
end;
