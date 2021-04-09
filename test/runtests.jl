# MicroFloatingPoint --
#
#	Copyright 2019--2021 University of Nantes, France.
#
#	This file is part of the MicroFloatingPoint library.
#
#	The MicroFloatingPoint library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation; either version 3 of the License, or (at your
#	option) any later version.
#	
#	The MicroFloatingPoint library is distributed in the hope that it will be useful,
# but	WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
#	or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
#	for more details.
#	
#	You should have received copies of the GNU General Public License and the
#	GNU Lesser General Public License along with the MicroFloatingPoint Library.
# If not,	see https://www.gnu.org/licenses/.

using Test
using TestSetExtensions

push!(LOAD_PATH,pwd()*"/../src/")
using MicroFloatingPoint

# Call "julia runtests.jl [tests1] [tests2] ..."
# to launch only the tests in `test1.jl`, `test2.jl`, ...
# Calling "julia runtests.jl" launches all tests in the directory.
@testset ExtendedTestSet "All the tests" begin
    @testset "All tests" begin
        @includetests ARGS
    end
end;






