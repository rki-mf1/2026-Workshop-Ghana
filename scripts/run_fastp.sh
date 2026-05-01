# usage: bash scripts/run_fastp.sh data/raw_data/iav_h3n2 analyses/day_02/fastp_batch

source $(conda info --base)/etc/profile.d/conda.sh

input="$1"
output="$2"

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
