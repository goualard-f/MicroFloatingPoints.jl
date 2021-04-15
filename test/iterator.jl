@testset "FloatmuIterator" begin
    @test [x for x in FloatmuIterator(Floatmu{2,2},0.0,1.0)] == [0.0, 0.25, 0.5, 0.75, 1.0]
end;
