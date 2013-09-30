#!/bin/sh
###
### Job name
#SBATCH --job-name=THA_bpdn_lloydmax_q3
### Time limit of total run time of the job
#SBATCH --time=500:00:00
### Number of nodes required for the job
#SBATCH --nodes=1
### Number of processor cores
#SBATCH -n 8
#SBATCH --sockets-per-node=2
#SBATCH --cores-per-socket=4
### Amount of memory per core
#SBATCH --mem=24000
### Output
#SBATCH -o THA_bpdn_lloydmax_q3_out.%J
#SBATCH -e THA_bpdn_lloydmax_q3_err.%J

### The actual job execution export
cd ~/public-repos/corr-cs-code-repo/code/bpdn/
/pack/matlab/bin/matlab -nodisplay -r "addpath('~/matlab_toolboxes/spgl1-1.8/','~/public-repos/corr-cs-code-repo/code/');matlabpool open local 8;test_lloydmax_ord_vs_scale(3)"
