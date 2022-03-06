# UnicodePlotsSimple
- Very simple vertical unicode histogram
- Very simple unicode heatmap
- Very simple unicode distribution 


# WHY
Plotting helps you to understand the underlying data. For me I needed to plot relative differences of values, distribution of values in a vector{Float32}, relative differences of matrix values and finally I had to 3-5 times multiple matrix relative differences in the appropriate matrix (Dict{...,Vector{Matrix{Float32}}}). 

Fork it an use it as you prefer

# Example
Code:
```
include("../src/UnicodePlotsSimple.jl")
using .UnicodePlotsSimple

randss = randn(1000).+2
histogram(randss, width=64, height=3)
histogram(randss, width=100, height=5, title="Random num generation histrogram", printstat=true)


distribution([0.3,0.2334,0.1,0.8], height=3, values=[0.3,0.2334,0.1,0.8])
dat = [randn(5,5),randn(5,5),randn(5,5)]
heatmap(dat,title=["first", "s2ec", "323c"], xticks=[1,2,2,2,3], yticks=[1,2,2,5,3])
```
![test.jl example](/assets/images/test.jl.example.png)

Use it as you prefer. :)

# TODO
Searching for a finer detailed building block than: " ▁▂▃▄▅▆▇█"


Inspired by: https://github.com/JuliaCI/BenchmarkTools.jl#quick-start
