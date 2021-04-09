@testset "smask" begin
    smask=MicroFloatingPoint.smask
    @test smask(Floatmu{2,2}) == 0x10
    @test smask(Floatmu{8,23}) == 0x80000000
end;
