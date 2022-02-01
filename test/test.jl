using Revise

includet("../src/UnicodeHistogram.jl")
using .UnicodeHistogram

values = randn(10000).+100
# histogram(values, width=64, height=3)
histogram(values, width=100, height=5, title="Random num generation histrogram", printstat=true)

