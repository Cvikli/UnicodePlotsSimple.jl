# UnicodePlotsSimple
- Very simple unicode distribution 
- Very simple vertical unicode histogram
- Very simple unicode heatmap
- Very simple unicode densitymap 

I love the simple "flat" programming style in Julia. (I believe it was way overstated in C++ and this is much easier to understand.)

# WHY
Plotting helps you to understand the underlying data. For me I needed to plot relative differences of values, distribution of values in a vector{Float32}, relative differences of matrix values and finally I had to 3-5 times multiple matrix relative differences in the appropriate matrix (Dict{...,Vector{Matrix{Float32}}}). 

Fork it an use it as you prefer

# Example
Code:
```
include("../src/UnicodePlotsSimple.jl")
using .UnicodePlotsSimple

distribution([0.3,0.2334,0.1,0.8], height=3, values=[0.3,0.2334,0.1,0.8])

rnds = randn(1000).+2
histogram(rnds, width=70, height=5, title="Random num generation histrogram", printstat=true)


xticks = ["a","b","c","h","p"]
yticks = ["a","b","c","h","p"]

data = [randn(5,5),randn(5,5),randn(5,5)]
desnitry = [rand(1:150,5,5),rand(1:350,5,5),rand(1:6,5,5)]

heatmap(data,title=["first", "sec", "3rd"], xticks=xticks, yticks=yticks, reversey=true)
densitymap(data, desnitry, format=Val(:NUMBER), title=["first", "sec", "3rd"], xticks=xticks, yticks=yticks, reversey=true)
densitymap(data, desnitry, format=Val(:DENSITY), title=["first", "sec", "3rd"], xticks=xticks, yticks=yticks, reversey=true)
```
![test.jl example](/assets/test.jl.example.2022.03.07.png)

Use it as you prefer. :)

# TODO
Searching for a finer detailed building block: 
 - " ▁▂▃▄▅▆▇█"
 - "  ░░▒▒▓▓██"


Inspired by: https://github.com/JuliaCI/BenchmarkTools.jl#quick-start
