# HistogramUnicode
Very simple vertical unicode histogram print in console. 

# Example
Code:
```
using UnicodeHistogram

values = randn(10000)
histogram(values, width=64, height=3)
```
Result:
```
                        ▁▁▄▄▇▆▆█▆▇▆▅▄▅▂                         
                   ▁▂▃▆▅████████████████▅▄▃▁                    
▁▁▁▁▁▁▁▁▁▁▁▁▂▂▃▄▄▆▇██████████████████████████▆▆▅▃▃▂▂▂▁▁▁▁▁▁▁▁▁▁▁
mean ± σ:  0.004896 ± 0.994497
min … max: -3.841103 … 3.888435
(0.00489639274142397, 0.9944966803826039, -3.8411032325852648, 3.8884348308574825)
```

# TODO
Searching for a finer detailed building block than: " ▁▂▃▄▅▆▇█"


Inspired by: https://github.com/JuliaCI/BenchmarkTools.jl#quick-start