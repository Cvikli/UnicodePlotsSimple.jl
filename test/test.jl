using RelevanceStacktrace
using Revise

includet("../src/UnicodePlotsSimple.jl")
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

#%%

using InteractiveUtils
densitymap(data, desnitry, 
["first", "s2ec", "323c"], [1,2,2,2,3], [1,2,2,5,3], false, Val(:NUMBER))
@code_warntype densitymap(data, desnitry, 
["first", "s2ec", "323c"], [1,2,2,2,3], [1,2,2,5,3], false, Val(:NUMBER))

#%%
heatmap(data,["first", "s2ec", "323c"], [1,2,2,2,3], [1,2,2,5,3], false)
# @code_warntype heatmap(data,["first", "s2ec", "323c"], [1,2,2,2,3], [1,2,2,5,3], false)

#%%
@code_warntype distribution(Float32[0.3,0.2334,0.1,0.8], 3, Float32[0.3,0.2334,0.1,0.8])

#%%
@code_warntype histogram(randn(1000).+2, 80, 5, "Random num generation histrogram", true, false, "","","")
