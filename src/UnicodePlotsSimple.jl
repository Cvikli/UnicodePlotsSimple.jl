module UnicodePlotsSimple

using Crayons

export histogram
export distribution
export heatmap
export densitymap

cpad(s, n::Integer, p=" ") = rpad(lpad(s,div(n+length(s),2),p),n,p)

marker(format::Val{:NUMBER}, cases, x,y,c) = lpad(string(max(cases[c][x, y],0) > 99 ? "…" : cases[c][x, y]),2) 
marker(format::Val{:DENSITY}, cases, x,y,c) = ["░░", "▒▒", "▓▓", "██"][cases[c][x, y]]
marker(format::Val{:HEATMAP}, cases, x,y,c) = "  " 

markercolor(format::Val{:NUMBER}, c) = Crayon(;background=c,foreground=(0,0,0) )
markercolor(format::Val{:DENSITY}, c) = Crayon(;foreground=c)
markercolor(format::Val{:HEATMAP}, c) = Crayon(;background=c)

heatmap(xy::Matrix; title=[], xticks=[], yticks=[], reversey=false) = heatmap([xy], title=title, xticks=xticks, yticks=yticks, reversey=reversey) 
heatmap(xy::Vector; title=[], xticks=[], yticks=[], reversey=false) = heatmap(xy,title,xticks,yticks,reversey)
function heatmap(xy::Vector, title, xticks, yticks, reversey) 
	densitymap(xy, nothing, title, xticks, yticks, reversey, Val(:HEATMAP))
end


densitymap(xy::Matrix, case::Matrix; title=[], xticks=[], yticks=[], format=Val(:HEATMAP)) = densitymap([xy], [case], title=title, xticks=xticks, yticks=yticks) 
densitymap(xy::Vector, cases; title=[], xticks=[], yticks=[], reversey=false, format=Val(:HEATMAP)) = 
densitymap(xy,cases,title,xticks,yticks,reversey,format)
function densitymap(xy::Vector{Matrix{T}}, cases, title, xticks, yticks, reversey, format) where T
	ϵ = 1e-11
	scale = 0:5:255
	charts_num = length(xy)
	width, height = size(xy[1])
	# freq_matrix = Array{Int,3}(undef, width, height, charts_num)	
	unicode_matrix = Array{UInt8,3}(undef, width, height, charts_num)	
	extremas = Tuple{T,T}[]
	for c in 1:charts_num
		minstrength, maxstrength = extrema(xy[c])
		push!(extremas, (minstrength, maxstrength))
		for xi in 1:size(xy[c],1)
			for yi in 1:size(xy[c],2)
				strength = (xy[c][xi,yi]-minstrength) / (maxstrength-minstrength + ϵ) * length(scale)
				unicode_matrix[xi,yi,c] = convert(UInt, scale[floor(Int, strength)+1])
			end
		end
	end

	length(title)!= 0 && (print(" ");for c in 1:charts_num
		print(cpad(title[c],2*length(xticks)))
		print(" ")
	end;
	print(" " ^ (width-1),"min   …    max ");
	println())

	if isa(format, Val{:DENSITY})
		maxcase = maximum.(cases)
		scaled_cases = [floor.(Int, case_m ./ (maxcase[c] + ϵ) * 4) .+ 1 for (c,case_m) in enumerate(cases)]
	else
		scaled_cases = cases
	end

	for h in 1:height 	
		length(yticks) != 0 && print(yticks[reversey ? height+1-h : h])
		for c in 1:charts_num
			for w in 1:width 	
				# @show h,c,w, height
				m = marker(format, scaled_cases, w,reversey ? height+1-h : h,c, )
				rgb=(255, unicode_matrix[w,reversey ? height+1-h : h,c], 0)
				cray_col = markercolor(format, rgb)
				print(cray_col, m, Crayon(reset=true))
			end
			print(" ")
		end
		length(extremas) >= h && print(" ",lpad(round(extremas[h][1]; digits=6), 8)," … ",lpad(round(extremas[h][2]; digits=8), 6))
		println()
	end
	length(xticks) != 0 && (print("");
	for c in 1:charts_num 
		for w in 1:width print(lpad(xticks[w],2)) end ; print(" ")
	end)
	println()
end

distribution(probs; height=3, values=[]) = distribution(probs, height, values) 
function distribution(probs, height, values)
	ϵ = 1e-11
	histbars_blocks = [' ', '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█']
	blocknum = length(histbars_blocks)
	histbin_codes = fill('█',(blocknum-1)*height, height)
	for h in 1:height
		histbin_codes[(h-1)*(blocknum-1)+1:h*(blocknum-1),height-h+1] .= histbars_blocks[2:end]
	end
	histbin_codes[map(ci -> cld(ci[1],blocknum-1)+ci[2]<=height,CartesianIndices(histbin_codes))].= ' '


	maxheight = maximum(probs)


	unicode_matrix = Matrix{Char}(undef, length(probs), height)
	for (i,bin) in enumerate(probs)
		strength = bin / (maxheight + ϵ) * size(histbin_codes,1)
		unicode_matrix[i, :] .= histbin_codes[floor(Int, strength)+1,:]
	end
	v_mean = sum(probs) / length(probs)
	v_σ = sqrt(sum((probs .- v_mean).^2) / (length(probs) - 1))
	v_min = minimum(probs)
	v_max = maximum(probs)
	for h in 1:height 	
		print(join(unicode_matrix[:,h],""))
		if h==height-2 && length(values)>0
			print("  values:    ") 
			printstyled(join(values,", "); color=:green, bold=true)
		elseif h==height-1
			print("  mean ± σ:  ") 
			printstyled(lpad(round(v_mean; digits=6), 6); color=:green, bold=true)
			print(" ± ")
			printstyled(lpad(round(v_σ; digits=6), 6); color=:green, bold=true)
		elseif h==height
			print("  min … max: ") 
			printstyled(lpad(round(v_min; digits=6), 7); color=:green, bold=true)
			print(" … ")
			printstyled(rpad(round(v_max; digits=6), 6); color=:green, bold=true)
		end
		println()
	end
end

histogram(values; width=64, height=3, title="", printstat=true, reversescale=false, line1="", line2="", line3="") = histogram(values, width, height, title, printstat, reversescale, line1, line2, line3)
function histogram(values, width, height, title, printstat, reversescale, line1, line2, line3)
	ϵ = eps(eltype(values))
	length(values) == 0 && (println("$title  $line1  $line2 ---Empty histogram--- "); return)
	histbars_blocks = [' ', '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█']
	blocknum = length(histbars_blocks)
	histbin_codes = fill('█',(blocknum-1)*height, height)
	for h in 1:height
		histbin_codes[(h-1)*(blocknum-1)+1:h*(blocknum-1),height-h+1] .= histbars_blocks[2:end]
	end
	histbin_codes[map(ci -> cld(ci[1],blocknum-1)+ci[2]<=height,CartesianIndices(histbin_codes))].= ' '
	# for h in 1:height 	
	# 	println(join(histbin_codes[:,h],"")," █")
	# end
	firstbin = minimum(values)
	endbin = maximum(values) 
	binsize = (endbin - firstbin) / width + ϵ
	histogram_bins = zeros(Int, width)
	for v in values
		histogram_bins[floor(Int,(v-firstbin) / binsize)+1] += 1 
	end
	maxbin = maximum(histogram_bins) 
	unicode_matrix = Matrix{Char}(undef, width, height)
	for (i,bin) in enumerate(histogram_bins)
		strength = floor(Int, bin / (maxbin * (1 + ϵ))* size(histbin_codes,1))  
		unicode_matrix[i, :] .= histbin_codes[strength+1,:]
	end

	title !=="" && printstyled(" " ^ max(0,cld((width-length(title)),2)),title,"\n"; bold=true)
	for h in 1:height 	
		if reversescale == false
			print(join(unicode_matrix[:,h],""))
		else
			print(join(unicode_matrix[end:-1:1,h],""))
		end
		if h==1
      print(" ",line1)
		elseif h==2
      print(" ",line2)
		elseif h==3
      print(" ",line3)
		end
		println()
	end
	if reversescale 
		firstbin, endbin = endbin, firstbin
	end
	printstyled(lpad(round(firstbin; digits=6),12), bold=true)
	# sign_width = (sign(firstbin) < 0 ? 1 : 0) + (sign(endbin) < 0 ? 1 : 0)
	# print(" "^(width-14-Int(ceil(log10(abs(firstbin)))+ceil(log10(abs(endbin))))- sign_width))
	print(" "^(width-24))
	printstyled(rpad(round(endbin; digits=6),12), bold=true)
	# println()
	v_mean = sum(values) / length(values)
	v_σ = sqrt(sum((values .- v_mean).^2) / length(values))
	if printstat
		print(" ")
		print("Mean ± σ: ") 
		printstyled(lpad(round(v_mean; digits=5), 6); color=:green, bold=true)
		print(" ± ")
		printstyled(round(v_σ; digits=4); color=:green, bold=true)
		println()
		# print("Range (min … max): ") 
		# printstyled(lpad(round(firstbin; digits=6), 6); color=:green, bold=true)
		# print(" … ")
		# printstyled(lpad(round(endbin; digits=6), 6); color=:green, bold=true)
		println()
	end
	# v_mean, v_σ, firstbin, endbin
	return
end

function histogramdetailed(values, width=64, height=3)
	# TODO implement fined detailed histogram print...
	@assert false "Unimplemented fine grained sparseprint..."
	# 30×30 SparseMatrixCSC{Bool, Int64} with 445 stored entries:
	# ⡙⠅⡥⠹⢗⢊⢣⣽⠜⢬⣛⠇⡦⡮⣑
	# ⢦⣷⡏⣸⢐⠺⣲⢣⣵⣀⡞⢹⢏⣃⣁
	# ⡟⣻⢹⣅⡻⣌⠄⠳⣱⣴⠖⠰⣢⠣⠵
	# ⡸⡑⠜⢰⢠⣢⢤⢎⡷⠽⡩⣒⡢⡊⢋
	# ⡀⠀⠇⢟⢓⣊⣊⢱⠙⡯⡅⢇⠀⣁⠍
	# ⡢⡡⡦⠦⠇⣢⡉⣻⣣⣽⢥⠽⢯⣌⢵
	# ⠞⡸⣡⠲⠪⢟⠹⡀⢍⡢⡍⢼⢛⡅⢃
	# ⠉⠀⠙⠊⠛⠓⠚⠂⠈⠂⠁⠓⠙⠈⠁
end

end # module
