workflow subset_genotypes {

	Array[File] genofiles
	File samplefile
	File variant_file
	Int? memory = 5
	Int? disk = 50

	scatter (gf in genofiles) {
		call subset_files {
			input:
				genofile = gf,
				samplefile = samplefile,
				variant_file = variant_file,
				memory = memory,
				disk = disk
		}
	}

	call concatenate {
		input:
			files = subset_files.bgen_subset,
			samplefile = samplefile,
			memory = memory,
			disk = disk
	}
}

task subset_files {

	File genofile
	File samplefile
	File variant_file
	Int memory
	Int disk

	command <<<
		/qctool \
		-g ${genofile} \
		-s ${samplefile} \
		-incl-rsids ${variant_file} \
		-og subset.bgen
	>>>

	runtime {
		docker: "quay.io/large-scale-gxe-methods/subset-genotypes-workflow"
		memory: "${memory} GB"
		disks: "local-disk ${disk} HDD"
	}

	output {
		File bgen_subset = "subset.bgen"	
	}
}

task concatenate {

	Array[File] files
	File samplefile
	Int memory
	Int disk

	command <<<
		cp ${files[0]} base.bgen
		for f in ${sep=" " files}; do
			echo $f;
			/qctool -g base.bgen -merge-in $f ${samplefile} -og concat.bgen;
			#cp concat.bgen base.bgen
		done
		rm base.bgen
	>>>
	
	runtime {
		docker: "quay.io/large-scale-gxe-methods/subset-genotypes-workflow"
		memory: "${memory} GB"
		disks: "local-disk ${disk} HDD"
	}

	output {
		File bgen_concat = "concat.bgen"
	}
}
