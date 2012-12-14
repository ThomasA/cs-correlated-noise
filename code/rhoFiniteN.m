function [ bound ] = rhoFiniteN(delta, rho, N, epsilon)
%RHOFINITEN This function calculates finite-N phase transition bounds
%   The function returns a finite-N bound on the compressed sensing
%   reconstruction phase transition for Gaussian measurement matrices. The
%   bound is calculated according to [1], Section IV.
%
%   [1] Donoho, D. & Tanner, J. Precise Undersampling Theorems Proceedings
%   of the IEEE, 2010, 98, 913-924.
%
%   Code implemented by: Thomas Arildsen
%   Contact e−mail: sparsig−toolbox@es.aau.dk
%
%   Version history:
%     1.0   [14−DEC−2012] Paper review version.

%   Copyright 2012 Thomas Arildsen, Aalborg University, Denmark
% 
%   Licensed under the Apache License, Version 2.0 (the "License");
%   you may not use this file except in compliance with the License.
%   You may obtain a copy of the License at
% 
%       http://www.apache.org/licenses/LICENSE-2.0
% 
%   Unless required by applicable law or agreed to in writing, software
%   distributed under the License is distributed on an "AS IS" BASIS,
%   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%   See the License for the specific language governing permissions and
%   limitations under the License.

assert(all(size(delta) == size(rho)));
assert(isvector(delta) && isvector(rho));

R = @(n) 2*sqrt((n.^-1 * log((4 * (N + 2)^6) / epsilon)));
bound = rho .* (1 - R(delta*N));

% Remember to threshold plot at rho = 1 since the bound will go below zero!
