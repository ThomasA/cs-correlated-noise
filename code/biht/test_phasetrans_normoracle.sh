#!/bin/sh
###
### Job name
#SBATCH --job-name=THA_biht_phasetrans
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
##SBATCH -o job_bpdn_phasetrans_out.%J
##SBATCH -e job_bpdn_phasetrans_err.%J

### The actual job execution export
cd ~/public-repos/corr-cs-code-repo/code/biht/
/pack/matlab/bin/matlab -nodisplay -r "addpath('~/public-repos/corr-cs-code-repo/code/');matlabpool open local 8;test_phasetrans_normoracle(1000,$1,.01)"
