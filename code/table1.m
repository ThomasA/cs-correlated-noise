% This script retrieves the parameters shown in Table I in the paper.

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

load quant_model_params

display([1-beta_lm([1 3 5])' 1-beta_u([1 3 5])'])
