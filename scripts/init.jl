using Pkg
Pkg.activate("./")

using Revise
using Profile
using BenchmarkTools
using TimerOutputs

Pkg.instantiate()

using AdventOfCode
const AoC = AdventOfCode