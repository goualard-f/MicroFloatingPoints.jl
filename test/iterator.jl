@testset "FloatmuIterator Floatmu Floatmu Floatmu" begin
    @test collect(FloatmuIterator(Floatmu{2,2}(-0.5),Floatmu{2,2}(0.75),Floatmu{2,2}(0.3))) == [-0.5, -0.25, -0.0, 0.25, 0.5, 0.75]
end;

@testset "FloatmuIterator Floatmu Floatmu Float64" begin
    @test collect(FloatmuIterator(Floatmu{2,2}(0.0),Floatmu{2,2}(1.75),0.7)) == [0.0, 0.75, 1.5]
    @test_throws ArgumentError collect(FloatmuIterator(Floatmu{2,2}(1.0),Floatmu{2,2}(3.5),0.1))
end;

@testset "FloatmuIterator Floatmu Floatmu [Int]" begin
    @test collect(FloatmuIterator(Floatmu{2,2}(0.0),Floatmu{2,2}(1.75),4)) == [0.0, 1.0]
end;

@testset "FloatmuIterator Type Float64 Float64 [Int]" begin
    @test collect(FloatmuIterator(Floatmu{2,2},0.0,1.0)) == [0.0, 0.25, 0.5, 0.75, 1.0]
    @test collect(FloatmuIterator(Floatmu{2,2},1.0,Inf)) == [1.0, 1.25, 1.5, 1.75, 2.0, 2.5, 3, 3.5, Infμ(Floatmu{2,2})]
    @test collect(FloatmuIterator(Floatmu{2,2},-Inf,-1.0)) == [-Infμ(Floatmu{2,2}), -3.5, -3, -2.5, -2.0, -1.75, -1.5, -1.25, -1.0]
    @test collect(FloatmuIterator(Floatmu{2,2},-Inf,Inf,5)) == [-Infμ(Floatmu{2,2}), -1.75, -0.5, 0.75, 2.0, Infμ(Floatmu{2,2})]
end;

@testset "FloatmuIterator Type Float64 Float64 Float64" begin
    @test_throws ArgumentError collect(FloatmuIterator(Floatmu{2,2},1.25,3.0,0.25))
end;

@testset "length" begin
    @test length(FloatmuIterator(Floatmu{2,2},-0.25,2.5)) == 11
    @test length(FloatmuIterator(Floatmu{2,2},-3.0,-0.5)) == 9
    @test length(FloatmuIterator(Floatmu{2,2},-Inf,-1.5)) == 7
    @test length(FloatmuIterator(Floatmu{2,2},-Inf,Inf)) == 25
    @test length(FloatmuIterator(Floatmu{2,2},-Inf,Inf,3)) == 9
    @test length(FloatmuIterator(Floatmu{2,2},-3.5,3.5,1.0)) == 8
    @test length(FloatmuIterator(Floatmu{2,2},-1.0,1.5,0.25)) == 11
    @test length(FloatmuIterator(Floatmu{2,2},-1.0,1.5,0.5)) == 6
    @test length(FloatmuIterator(Floatmu{2,2}(0.0),Floatmu{2,2}(1.75),0.7)) == 3
    @test length(FloatmuIterator(Floatmu{2,2}(0.0),Floatmu{2,2}(1.75),4)) == 2
end;

@testset "eligible_step" begin
    @test eligible_step(Floatmu{2,2}(0.25),Floatmu{2,2}(2.0)) == 0.25
    @test eligible_step(Floatmu{2,2}(0.25),Floatmu{2,2}(2.5)) == 0.5
    @test eligible_step(Floatmu{8,23}(0.0),Floatmu{8,23}(1.0)) == 2.0^-24
    @test eligible_step(Floatmu{8,23}(-1.0),Floatmu{8,23}(0.0)) == 2.0^-24
    @test eligible_step(Floatmu{8,23}(-1.0),Floatmu{8,23}(0.5)) == 2.0^-24
    @test eligible_step(Floatmu{8,23}(-0.5),Floatmu{8,23}(1.0)) == 2.0^-24
end;
