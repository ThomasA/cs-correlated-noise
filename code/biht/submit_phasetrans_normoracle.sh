#!/bin/bash
# This script is for submitting jobs for SLURM

allDeltas=$(awk 'BEGIN{for(i=0.01;i<=1;i+=0.01)print i}')
for delta in $allDeltas
do
    sbatch --job-name THA_biht_phasetrans_$delta --error THA_biht_phasetrans_$delta.err --output THA_biht_phasetrans_$delta.out test_phasetrans_normoracle.sh $delta
done
