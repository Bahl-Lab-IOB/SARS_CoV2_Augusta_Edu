mkdir -p results/

augur index \
  --sequences Updated_Data/final_sequences_23000.fasta \
  --output results/sequence_index.tsv

augur filter \
  --sequences Updated_Data/final_sequences_23000.fasta \
  --sequence-index results/sequence_index.tsv \
  --metadata Updated_Data/metadata_final.tsv \
  --output results/filtered.fasta
  
  
augur align \
  --sequences results/filtered.fasta \
  --reference-sequence config/SARS-CoV-2.gb \
  --output results/aligned.fasta \
  --fill-gaps  
  
 
augur tree \
  --alignment results/aligned.fasta \
  --output results/tree_raw.nwk  


augur refine \
  --tree results/tree_raw.nwk \
  --alignment results/aligned.fasta \
  --metadata Updated_Data/metadata_final.tsv \
  --output-tree results/tree.nwk \
  --output-node-data results/branch_lengths.json \
  --timetree \
  --coalescent skyline \
  --clock-rate .0007 \
  --clock-std-dev .0002 \
  --date-confidence \
  --date-inference marginal \
  --clock-filter-iqd 4

augur traits \
  --tree results/tree.nwk \
  --metadata Updated_Data/metadata_final.tsv \
  --output results/traits.json \
  --columns county \
  --confidence  
 

augur ancestral \
  --tree results/tree.nwk \
  --alignment results/aligned.fasta \
  --output-node-data results/nt_muts.json \
  --inference joint  
  
  
augur translate \
  --tree results/tree.nwk \
  --ancestral-sequences results/nt_muts.json \
  --reference-sequence config/SARS-CoV-2.gb \
  --output results/aa_muts.json  
  
  
 augur export v2 \
  --tree results/tree.nwk \
  --metadata Updated_Data/metadata_final.tsv \
  --node-data results/branch_lengths.json \
              results/traits.json \
              results/nt_muts.json \
              results/aa_muts.json \
  --colors config/colors.tsv \
  --lat-longs config/lat_longs.tsv \
  --auspice-config config/auspice_config.json \
  --output auspice/Augusta.json
  
  
