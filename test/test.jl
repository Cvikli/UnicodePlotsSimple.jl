using RelevanceStacktrace
using Revise

includet("../src/UnicodePlotsSimple.jl")
using .UnicodePlotsSimple

randss = randn(1000).+2
histogram(randss, width=64, height=3)
# histogram(randss, width=80, height=5, title="Random num generation histrogram", printstat=true)


distribution([0.3,0.2334,0.1,0.8], height=3, values=[0.3,0.2334,0.1,0.8])


dat = [randn(5,5),randn(5,5),randn(5,5)]
heatmap(dat,title=["first", "s2ec", "323c"], xticks=[1,2,2,2,3], yticks=[1,2,2,5,3])

#%%
desnitry = [rand(1:150,5,5),rand(1:350,5,5),rand(1:10,5,5)]
densitymap(dat, desnitry, format=Val(:DENSITY),
title=["first", "s2ec", "323c"], xticks=[1,2,2,2,3], yticks=[1,2,2,5,3])

#%%

using InteractiveUtils
densitymap(dat, desnitry, 
["first", "s2ec", "323c"], [1,2,2,2,3], [1,2,2,5,3], false, Val(:NUMBER))
@code_warntype densitymap(dat, desnitry, 
["first", "s2ec", "323c"], [1,2,2,2,3], [1,2,2,5,3], false, Val(:NUMBER))

#%%
heatmap(dat,["first", "s2ec", "323c"], [1,2,2,2,3], [1,2,2,5,3], false)
# @code_warntype heatmap(dat,["first", "s2ec", "323c"], [1,2,2,2,3], [1,2,2,5,3], false)

#%%
@code_warntype distribution(Float32[0.3,0.2334,0.1,0.8], 3, Float32[0.3,0.2334,0.1,0.8])

#%%
@code_warntype histogram(randn(1000).+2, 80, 5, "Random num generation histrogram", true, false, "","","")
