function [ kBound ] = kFiniteN(delta, rho, N, epsilon)
%KFINITEN calculates finite-N phase transition bounds.
%   The function returns a bound on the number of non-zero elements
%   corresponding to the finite-N bound on the compressed sensing
%   reconstruction phase transition for Gaussian measurement matrices. The 
%   bound is calculated according to [1], Section IV.
%
%   [1] Donoho, D. & Tanner, J. Precise Undersampling Theorems Proceedings
%   of the IEEE, 2010, 98, 913-924.
% 
%   Inputs:
%   delta     delta values in the phase space. Intended for data available
%             from: http://ecos.maths.ed.ac.uk/polytopes.shtml
%   rho       rho values in the phase space. Intended for data available
%             from: http://ecos.maths.ed.ac.uk/polytopes.shtml
%   N         The finite sparse vector length to calculate phase transition
%             bounds for.
%   epsilon   Reconstruction success fraction.
%
%   Output:
%   kBound    Upper bound on the maximum number k of non-zero elements in
%             successfully reconstructed solutions.
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

R = @(n) 2*(n.^-1 * log((4 * (N + 2)^6) / epsilon)).^(1/2);
kBound = delta*N .* rho .* (1 - R(delta*N));
