using Revise

includet("../src/UnicodeHistogram.jl")
using .UnicodeHistogram

values = randn(10000)
histogram(values, width=64, height=3)

