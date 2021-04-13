@testset "float64_to_uint64mu" begin
    fl2uint32 = MicroFloatingPoints.float64_to_uint32mu
    # Positives
    @test fl2uint32(0.0,2,2) == (0,0)
    @test fl2uint32(0.1,2,2) == (0,-1)
    @test fl2uint32(0.125,2,2) == (0,-1)
    @test fl2uint32(0.126,2,2) == (1,1)
    @test fl2uint32(0.75,2,2) == (3,0)
    @test fl2uint32(0.76,2,2) == (3,-1)
    @test fl2uint32(0.874,2,2) == (3,-1)
    @test fl2uint32(0.875,2,2) == (4,1)
    @test fl2uint32(0.876,2,2) == (4,1)
    @test fl2uint32(1.0,2,2) == (4,0)
    @test fl2uint32(2.25,2,2) == (8,-1)
    @test fl2uint32(2.3,2,2) == (9,1)
    @test fl2uint32(3.5,2,2) == (11,0)
    @test fl2uint32(3.74,2,2) == (11,-1)
    @test fl2uint32(3.75,2,2) == (12,1)
    @test fl2uint32(5.5,2,2) == (12,1)
    @test fl2uint32(Inf,2,2) == (12,0)
    @test fl2uint32(NaN,2,2) > (12,0)
    # Negatives
    @test fl2uint32(-0.0,2,2) == (16+0,0)
    @test fl2uint32(-0.1,2,2) == (16+0,1)
    @test fl2uint32(-0.125,2,2) == (16+0,1)
    @test fl2uint32(-0.126,2,2) == (16+1,-1)
    @test fl2uint32(-0.75,2,2) == (16+3,0)
    @test fl2uint32(-0.76,2,2) == (16+3,1)
    @test fl2uint32(-0.874,2,2) == (16+3,1)
    @test fl2uint32(-0.875,2,2) == (16+4,-1)
    @test fl2uint32(-0.876,2,2) == (16+4,-1)
    @test fl2uint32(-1.0,2,2) == (16+4,0)
    @test fl2uint32(-2.25,2,2) == (16+8,1)
    @test fl2uint32(-2.3,2,2) == (16+9,-1)
    @test fl2uint32(-3.5,2,2) == (16+11,0)
    @test fl2uint32(-3.74,2,2) == (16+11,1)
    @test fl2uint32(-3.75,2,2) == (16+12,-1)
    @test fl2uint32(-5.5,2,2) == (16+12,-1)
    @test fl2uint32(-Inf,2,2) == (16+12,0)
    @test fl2uint32(-NaN,2,2) > (12,0)

    x = Float16(0.0)
    intx = 0
    while x < Float16(Inf)
        @test fl2uint32(Float64(x),5,10) == (intx,0)
        intx += 1
        x = nextfloat(x)
    end

    x = Float16(-0.0)
    intx = 1 << 15
    while x > Float16(-Inf)
        @test fl2uint32(Float64(x),5,10) == (intx,0)
        intx += 1
        x = prevfloat(x)
    end
end;


@testset "convert μ to 64" begin
    @test convert(Float64,Floatmu{8,23}(0.1)) == convert(Float64,0.1f0)
    @test convert(Float64,Floatmu{8,23}(Inf)) == convert(Float64,Inf32)
    @test convert(Float64,Floatmu{2,2}(-0.0)) == -0.0
end;

@testset "convert μ to 32" begin
    @test convert(Float32,Floatmu{8,23}(0.1)) == 0.1f0
    @test convert(Float32,Floatmu{8,23}(Inf)) == Inf32
    @test convert(Float32,Floatmu{2,2}(-0.0)) == -0.0f0
end;

@testset "convert μ to 16" begin
    @test convert(Float16,Floatmu{5,10}(-0.1)) == Float16(-0.1f0)
    @test convert(Float16,Floatmu{5,10}(Inf)) == Inf16
    @test convert(Float16,Floatmu{5,10}(-0.0)) == Float16(-0.0f0)
end;

@testset "convert 64 to μ" begin
    @test convert(Floatmu{8,23},0.1) == 0.1f0
    @test convert(Floatmu{8,23},Inf) == Inf32
    @test isnan(convert(Floatmu{8,23},NaN))
    @test convert(Floatmu{2,2},0.24) == 0.25
end;

@testset "convert 32 to μ" begin
    @test convert(Floatmu{8,23},0.1f0) == 0.1f0
    @test convert(Floatmu{8,23},Inf32) == Inf32
    @test isnan(convert(Floatmu{8,23},NaN32))
    @test convert(Floatmu{2,2},0.24f0) == 0.25    
end;

@testset "convert 16 to μ" begin
    @test convert(Floatmu{5,10},Float16(0.1)) == Float16(0.1)
end;
