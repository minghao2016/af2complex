#!/bin/bash
#
# An example script of minimizing un-relaxed structural models generated by run_af_mod.py
#
# You need to take care of these two items, which are dependent on your installation.
#. load_alphafold  ## set up proper AlphaFold conda environment.

### input targets
target_lst_file=test.lst
fea_dir=af_fea
out_dir=af2c_mod

echo "Info: input feature directory is $fea_dir"
echo "Info: result output directory is $out_dir"

af_dir=../src

python -u $af_dir/run_af2c_min.py \
  --target_lst_path=$target_lst_file \
  --output_dir=$out_dir \
  --feature_dir=$fea_dir
