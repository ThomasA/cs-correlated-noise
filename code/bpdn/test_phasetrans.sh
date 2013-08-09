#!/bin/bash

# Copyright 2013 Thomas Arildsen, Aalborg University, Denmark
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

### Job name
#SBATCH --job-name=THA_bpdn_phasetrans
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

### The actual job execution export - please note that you will need
### to edit the below paths in order to execute the script on your
### system
cd /user/tha/matlab/quant_corr_idea/bpdn/1bit_phase_trans
/pack/matlab/bin/matlab -nodisplay -r "addpath('~/matlab_toolboxes/spgl1-1.8/','~/matlab/quantization/','~/matlab/donoho_tanner_polytopes/');matlabpool open local 8;test_phasetrans(1000,$1,.01)"
