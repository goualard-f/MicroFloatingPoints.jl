@testset "bias" begin
    bias = MicroFloatingPoint.bias
    
    @test bias(Floatmu{2,2}) == 1
    @test bias(Floatmu{8,23}) == 127
end;
