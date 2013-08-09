#!/bin/bash
# This script is for submitting jobs for SLURM

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

allDeltas=$(awk 'BEGIN{for(i=0.01;i<=1;i+=0.01)print i}')
for delta in $allDeltas
do
    sbatch --job-name THA_bpdn_phasetrans_$delta --error THA_bpdn_phasetrans_$delta.err --output THA_bpdn_phasetrans_$delta.out test_phasetrans.sh $delta
done
