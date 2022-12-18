using Pkg
Pkg.activate("./")

using Revise
using Profile
using BenchmarkTools

Pkg.instantiate();