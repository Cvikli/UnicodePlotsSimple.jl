using Revise

includet("../src/UnicodeHistogram.jl")
using .UnicodeHistogram

# histogram(values, width=64, height=3)
histogram(randn(1000).+2, width=100, height=5, title="Random num generation histrogram", printstat=true)


distribution([0.3,0.2334,0.1,0.8], height=3, values=[0.3,0.2334,0.1,0.8])
