#!/bin/bash
# An example script of feature generation. This heavily depenedent on your installation,
# due to many third-party tools and multiple sequence libraries.
#
# You need to take care of these paths, python environment, and third-party sequence tools.
#. load_alphafold  ## set up proper AlphaFold conda environment.

DATA_DIR=$HOME/scratch/afold/data
export HHLIB=$HOME/data/tools/hh-suite/build
#export HMMER=$HOME/data/tools/hmmer-3.2.1/build
export HMMER=/usr/local/pace-apps/spack/packages/0.13/linux-rhel7-cascadelake/intel-19.0.5/hmmer-3.2.1-sngcwm2qjzzxseh42cryf432role4on5
export KALIGN=$HOME/data/tools/kalign_v2/kalign
af_dir=../src

if [ $# -eq 0 ]
  then
    echo "Usage: $0 <seq_file>"
    exit 1
fi
fasta_path=$1
out_dir=af2c_fea
db_preset='reduced_dbs'

# choices are "monomer, monomer+species, multimer"
# Option "monomer" and "multimer" follows alphafold official datapipeline for monomeric and
# multimeric structure predictions, respectively.
# Option "monomer+species" is a modified monomeric pipeline such as the species information
# is recorded for MSA pairing using only monomeric input features. This option is recommended.
feature_mode='monomer+species'

max_template_date=2020-05-15  # CASP14 starting date


echo "Info: sequence file is $fasta_path"
echo "Info: out_dir is $out_dir"
echo "Info: db_preset is $db_preset"
echo "Info: feature mode is $feature_mode"
echo "Info: max_template_date is $max_template_date"


##########################################################################################


if [ "$feature_mode" = "multimer" ]; then
  python $af_dir/run_af2c_fea.py --fasta_paths=$fasta_path --db_preset=$db_preset \
    --data_dir=$DATA_DIR --output_dir=$out_dir      \
    --uniprot_database_path=$DATA_DIR/uniprot/uniprot.fasta \
    --uniref90_database_path=$DATA_DIR/uniref90/uniref90.fasta \
    --mgnify_database_path=$DATA_DIR/mgnify/mgy_clusters.fa   \
    --pdb_seqres_database_path=$DATA_DIR/pdb_seqres/pdb_seqres.txt \
    --small_bfd_database_path=$DATA_DIR/small_bfd/bfd-first_non_consensus_sequences.fasta \
    --template_mmcif_dir=$DATA_DIR/pdb_mmcif/mmcif_files  \
    --max_template_date=$max_template_date                 \
    --obsolete_pdbs_path=$DATA_DIR/pdb_mmcif/obsolete.dat \
    --hhblits_binary_path=$HHLIB/bin/hhblits   \
    --hhsearch_binary_path=$HHLIB/bin/hhsearch \
    --jackhmmer_binary_path=$HMMER/bin/jackhmmer \
    --hmmsearch_binary_path=$HMMER/bin/hmmsearch \
    --hmmbuild_binary_path=$HMMER/bin/hmmbuild \
    --kalign_binary_path=$KALIGN \
    --feature_mode=$feature_mode
elif [ "$feature_mode" = "monomer+species" ]; then
  python $af_dir/run_af2c_fea.py --fasta_paths=$fasta_path --db_preset=$db_preset \
    --data_dir=$DATA_DIR --output_dir=$out_dir      \
    --uniprot_database_path=$DATA_DIR/uniprot/uniprot.fasta \
    --uniref90_database_path=$DATA_DIR/uniref90/uniref90.fasta \
    --mgnify_database_path=$DATA_DIR/mgnify/mgy_clusters.fa   \
    --small_bfd_database_path=$DATA_DIR/small_bfd/bfd-first_non_consensus_sequences.fasta \
    --pdb70_database_path=$DATA_DIR/pdb70/pdb70           \
    --template_mmcif_dir=$DATA_DIR/pdb_mmcif/mmcif_files  \
    --max_template_date=$max_template_date                \
    --obsolete_pdbs_path=$DATA_DIR/pdb_mmcif/obsolete.dat \
    --hhblits_binary_path=$HHLIB/bin/hhblits   \
    --hhsearch_binary_path=$HHLIB/bin/hhsearch \
    --jackhmmer_binary_path=$HMMER/bin/jackhmmer \
    --hmmsearch_binary_path=$HMMER/bin/hmmsearch \
    --hmmbuild_binary_path=$HMMER/bin/hmmbuild \
    --kalign_binary_path=$KALIGN \
    --feature_mode=$feature_mode \
    --use_precomputed_msas=True
else
  python $af_dir/run_af2c_fea.py --fasta_paths=$fasta_path --db_preset=$db_preset \
    --data_dir=$DATA_DIR --output_dir=$out_dir      \
    --uniref90_database_path=$DATA_DIR/uniref90/uniref90.fasta \
    --mgnify_database_path=$DATA_DIR/mgnify/mgy_clusters.fa   \
    --small_bfd_database_path=$DATA_DIR/small_bfd/bfd-first_non_consensus_sequences.fasta \
    --pdb70_database_path=$DATA_DIR/pdb70/pdb70           \
    --template_mmcif_dir=$DATA_DIR/pdb_mmcif/mmcif_files  \
    --max_template_date=$max_template_date                \
    --obsolete_pdbs_path=$DATA_DIR/pdb_mmcif/obsolete.dat \
    --hhblits_binary_path=$HHLIB/bin/hhblits   \
    --hhsearch_binary_path=$HHLIB/bin/hhsearch \
    --jackhmmer_binary_path=$HMMER/bin/jackhmmer \
    --hmmsearch_binary_path=$HMMER/bin/hmmsearch \
    --hmmbuild_binary_path=$HMMER/bin/hmmbuild \
    --kalign_binary_path=$KALIGN \
    --feature_mode=$feature_mode
fi
