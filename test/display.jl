@testset "show" begin
    io = IOBuffer();
    show(io,Floatmu{2,2}(0.24))
    @test String(take!(io)) == string(0.25)
    show(io,Floatmu{2,2}(NaN))
    @test String(take!(io)) == "NaNμ{2, 2}"
    show(io,Floatmu{2,2}(Inf))
    @test String(take!(io)) == "Infμ{2, 2}"
    show(io,Floatmu{2,2}(-0.0))
    @test String(take!(io)) == "-0.0"
    @test string(Floatmu{8,23}(0.1)) == string(Float32(0.1))
    @test string(Floatmu{8,23}(0.3)) == string(Float32(0.3))
    @test string(Floatmu{8,23}(3.2)) == string(Float32(3.2))
    @test string(Floatmu{8,23}(-3.2)) == string(Float32(-3.2))
end;

@testset "roundtrip" begin
    for x in (3.22,-3.22,0.1,-0.1,14.89) 
        @test parse(Floatmu{6,10},string(Floatmu{6,10}(x))) == Floatmu{6,10}(x)
    end
end;

@testset "bitstring" begin
    @test bitstring(Floatmu{2,2}(0.0)) == "00000"
    @test bitstring(Floatmu{2,2}(-0.0)) == "10000"
    @test bitstring(Floatmu{2,2}(0.75)) == "00011"
    @test bitstring(Floatmu{2,2}(-1.0)) == "10100"
    @test bitstring(Floatmu{2,2}(NaN)) == "01110"
    @test bitstring(Floatmu{2,2}(-Inf)) == "11100"
    @test bitstring(Floatmu{2,2}(Inf)) == "01100"
    @test bitstring(Floatmu{8,23}(0.1)) == bitstring(0.1f0)
end;
