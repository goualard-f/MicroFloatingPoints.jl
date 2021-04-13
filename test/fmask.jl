@testset "fmask" begin
    fmask=MicroFloatingPoints.significand_mask
    @test fmask(Floatmu{2,2}) == 3
    @test fmask(Floatmu{2,23}) == 0x00000000007fffff
end;
