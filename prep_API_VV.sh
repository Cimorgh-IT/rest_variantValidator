#!/bin/bash

# Define the input VCF.gz file
input_file="$1"

# Define the start time
start_time=$(date +%s)


# API link template
API_link_template="http://0.0.0.0:8000/LOVD/lovd/GRCh37/{chr}%3A{Pos}%3A{Ref}%3A{Alt}/all/raw/False/False?content-type=application%2Fjson"

# Check if the input file is provided as a command-line argument
if [ -z "$input_file" ]; then
    echo "Please provide the path to the input VCF.gz file as a command-line argument."
    exit 1
fi

# Extract the base input file name (without path and file extension)
base_name="$(basename "$input_file")"
base_name_no_ext="${base_name%.*.*}"

# Read the VCF file line by line and generate API links
zcat "$input_file" | while IFS= read -r line; do
    if [[ $line == \#* ]]; then
        continue  # Skip header lines
    fi

    # Extract fields from the VCF line
    fields=($line)
    chr_val="${fields[0]}"
    pos_val="${fields[1]}"
    ref_val="${fields[3]}"
    alt_val="${fields[4]}"

    # Handle multiple alternate alleles
    if [[ $alt_val == *,* ]]; then
        alt_val="${alt_val%%,*}"  # Take the first alternate allele
    fi

    # Generate the API link
    API_link="${API_link_template//\{chr\}/$chr_val}"
    API_link="${API_link//\{Pos\}/$pos_val}"
    API_link="${API_link//\{Ref\}/$ref_val}"
    API_link="${API_link//\{Alt\}/$alt_val}"

    echo "${API_link}"
    link=http://0.0.0.0:8000/LOVD/lovd/GRCh37/1%3A865628%3AG%3AA/all/raw/False/False?content-type=application%2Fjson
    echo "${link}"
    curl -X GET   "${API_link}"   -H 'accept: application/json'>> ${base_name_no_ext}.json 
    #sleep 1
    done
#Define the End time
end_time=$(date +%s)
# Calculate the elapsed time
elapsed_time=$((end_time - start_time))

echo "Your JSON file for ${base_name_no_ext} in ready"
# Print the elapsed time in seconds
echo "Elapsed time: $elapsed_time seconds"
