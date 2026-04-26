source $(conda info --base)/etc/profile.d/conda.sh

input='/home/mf1/nambi24/testdata'
output='/home/mf1/nambi24/testdata/out'

conda activate fastp

for file in "$input"/*.gz; do
	filename=$(basename "$file" .fastq.gz)
	echo -e "\nProcessing $filename"
	fastp \
		-i "$input/$filename.fastq.gz" \
		-o "$output/$filename.fastp.fastq" \
		-h "$output/$filename.report.html"
	echo -e "Done with $filename \n"
done

conda deactivate
