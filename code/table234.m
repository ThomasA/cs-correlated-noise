% This script reprocudes the numbers shown in Table II in the paper.

% Copyright 2012 Thomas Arildsen, Aalborg University, Denmark
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

fileName = test_noise_ord_vs_scale_opt(1);
load(fileName);
display([M K epsilonOptOrd nmseOrd alphaOptScale epsilonOptScale nmseScale])
fileName = test_noise_ord_vs_scale_opt(3);
load(fileName);
display([M K epsilonOptOrd nmseOrd alphaOptScale epsilonOptScale nmseScale])
fileName = test_noise_ord_vs_scale_opt(5);
load(fileName);
display([M K epsilonOptOrd nmseOrd alphaOptScale epsilonOptScale nmseScale])
