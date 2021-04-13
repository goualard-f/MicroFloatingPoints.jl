@testset "decompose" begin
    decompose = Base.decompose
    T = [ 0.0, 0.5, 1.0, 10.5, NaN, Inf, 100000.1 ]
    for x in [Floatmu{8,23}(v) for v in T]
        @test decompose(x) == decompose(Float32(x))
    end
    for x in [Floatmu{8,23}(-v) for v in T]
        @test decompose(x) == decompose(Float32(x))
    end
    for x in [Floatmu{5,10}(v) for v in T]
        @test decompose(x) == decompose(Float16(x))
    end
    for x in [Floatmu{5,10}(-v) for v in T]
        @test decompose(x) == decompose(Float16(x))
    end
end;
