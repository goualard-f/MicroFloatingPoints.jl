# runtests.jl --
#
# Copyright 2019--2024 University of Nantes, France.
#
# This file is part of the MicroFloatingPoints library.
#
# The MicroFloatingPoints library is free software; you can redistribute
# it and/or modify it under the terms of the GNU Lesser General Public License
# as published by the Free Software Foundation; either version 3 of the
# License, or (at your option) any later version.
#
# The MicroFloatingPoints library is distributed in the hope that it will be
# useful, but	WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.
#	
# You should have received copies of the GNU General Public License and the
# GNU Lesser General Public License along with the MicroFloatingPoints Library.
# If not, see https://www.gnu.org/licenses/.

using Test
using TestSetExtensions

using MicroFloatingPoints
using MicroFloatingPoints.MFPUtils
using MicroFloatingPoints.MFPRandom
using MicroFloatingPoints.MFPPlot

# Test loading MFPPythonPlot
using PythonPlot

# Calling "julia runtests.jl" launches all tests in the directory.
@testset ExtendedTestSet "All the tests" begin
    @testset "Arithmetic tests" begin
        include("arithmetic.jl")
    end
    @testset "Constructor tests" begin
        include("constructors.jl")
    end
    @testset "Emask tests" begin
        include("Emask.jl")
    end
    @testset "fmask tests" begin
        include("fmask.jl")
    end
    @testset "prevnext tests" begin
        include("prevnext.jl")
    end
    @testset "smask tests" begin
        include("smask.jl")
    end
    @testset "bias tests" begin
        include("bias.jl")
    end
    @testset "convert tests" begin
        include("convert.jl")
    end
    @testset "Emax tests" begin
        include("Emax.jl")
    end
    @testset "iterator tests" begin
        include("iterator.jl")
    end
    @testset "utils tests" begin
        include("utils.jl")
    end
    @testset "classes tests" begin
        include("classes.jl")
    end
    @testset "decompose tests" begin
        include("decompose.jl")
    end
    @testset "Emin tests" begin
        include("Emin.jl")
    end
    @testset "misc tests" begin
        include("misc.jl")
    end
    @testset "signbit tests" begin
        include("signbit.jl")
    end
    @testset "constants tests" begin
        include("constants.jl")
    end
    @testset "display tests" begin
        include("display.jl")
    end
    @testset "error tests" begin
        include("error.jl")
    end
    @testset "parse tests" begin
        include("parse.jl")
    end
    @testset "sign tests" begin
        include("sign.jl")
    end
end;






