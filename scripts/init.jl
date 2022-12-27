using Pkg
Pkg.activate("./")

using Revise
using Profile
using BenchmarkTools

Pkg.instantiate()

using AdventOfCode
const AoC = AdventOfCode