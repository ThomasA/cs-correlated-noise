% This script reproduces the plots for Figure 2 in the paper

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

% The simulations may take considerable time. To avoid this,
% comment out the following lines and un-comment the lines toward
% the bottom plotting results from existing data

addpath('bpdn');
fileName = test_noise_ord_vs_scale(1);
plot_ord_vs_scale(fileName);
fileName = test_noise_ord_vs_scale(3);
plot_ord_vs_scale(fileName);
fileName = test_noise_ord_vs_scale(5);
plot_ord_vs_scale(fileName);

% Plot results from existing data
%plot_ord_vs_scale('results_noise_ord_vs_scale_r1_20120717T085937');
%plot_ord_vs_scale('results_noise_ord_vs_scale_r3_20120717T221730');
%plot_ord_vs_scale('results_noise_ord_vs_scale_r5_20120717T224414');
