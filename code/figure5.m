% This script reproduces the plots for Figure 5 in the paper
%
% Please note that the scripts involved in this computation were
% originally run on a computing cluster using SLURM [1]. You can
% reproduce the results through a SLURM scheduler by running the
% scritps bpdn/submit_jobs.sh and
% biht/submit_phasetrans_normoracle.sh, respectively. Otherwise,
% the Matlab scripts performing the actual computations can be run
% by executing the current script in Matlab.
% ======================================================================
% 1. http://en.wikipedia.org/wiki/Simple_Linux_Utility_for_Resource_Management

% Copyright 2013 Thomas Arildsen, Aalborg University, Denmark
% 
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
% 
%     http://www.apache.org/licenses/LICENSE-2.0
% 
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.

% Do the computations - takes a LONG time this way. Un-comment the
% following four lines if you want to run the simulations:

%for delta=0.01:0.01:1
%    test_phasetrans(1000,delta,.01);
%    test_phasetrans_normoracle(1000,delta,.01);
%end

% Assemble and plot the data
% This will load the pre-assembled data filed provided in the
% repository. Comment out the following line if you want to
% assemble data from simulation output files.

addpath(pwd);
cd('biht')
plot_phasetrans('results_phasetrans_normoracle_N1000_NMSE.mat', ...
                .01);
cd('../bpdn')
plot_phasetrans('results_phasetrans_N1000_NMSE.mat',.01);
cd('..')

% Uncomment the following lines if you want to assemble data from
% simulation output files.

%cd('biht')
%plot_phasetrans('results_phasetrans_normoracle_N1000_delta*',.01);
%cd('../bpdn')
%plot_phasetrans('results_phasetrans_N1000_delta*',.01);
%cd('..')
