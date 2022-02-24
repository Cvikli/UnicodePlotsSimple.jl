module UnicodeHistogram

export histogram
export distribution

function distribution(probs; height=3, values=[])
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


function histogram(values; width=64, height=3, title="", printstat=true)
	length(values) == 0 && (println("Empty histogram"); return)
	ϵ = 1e-11
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
	endbin = maximum(values) + ϵ
	binsize = (endbin - firstbin) / width 
	histogram_bins = zeros(Int, width)
	for v in values
		histogram_bins[floor(Int,(v-firstbin) / binsize) + 1] += 1 
	end
	maxbin = maximum(histogram_bins) 
	unicode_matrix = Matrix{Char}(undef, width, height)
	for (i,bin) in enumerate(histogram_bins)
		strength = bin / (maxbin + ϵ)* size(histbin_codes,1)
		unicode_matrix[i, :] .= histbin_codes[floor(Int, strength)+1,:]
	end

	title !=="" && printstyled(" " ^ max(0,cld((width-length(title)),2)),title,"\n"; bold=true)
	for h in 1:height 	
		println(join(unicode_matrix[:,h],""))
	end
	printstyled(round(firstbin; digits=6), bold=true)
	sign_width = (sign(firstbin) < 0 ? 1 : 0) + (sign(endbin) < 0 ? 1 : 0)
	print(" "^(width-14-Int(ceil(log10(abs(firstbin)))+ceil(log10(abs(endbin))))- sign_width))
	printstyled(round(endbin; digits=6), bold=true)
	println()
	v_mean = sum(values) / length(values)
	v_σ = sqrt(sum((values .- v_mean).^2) / (length(values) - 1))
	if printstat
		print("Values (mean ± σ): ") 
		printstyled(lpad(round(v_mean; digits=6), 6); color=:green, bold=true)
		print(" ± ")
		printstyled(lpad(round(v_σ; digits=6), 6); color=:green, bold=true)
		println()
		# print("Range (min … max): ") 
		# printstyled(lpad(round(firstbin; digits=6), 6); color=:green, bold=true)
		# print(" … ")
		# printstyled(lpad(round(endbin; digits=6), 6); color=:green, bold=true)
		println()
	end
	v_mean, v_σ, firstbin, endbin
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
