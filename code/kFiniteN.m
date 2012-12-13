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

assert(all(size(delta) == size(rho)));
assert(isvector(delta) && isvector(rho));

R = @(n) 2*(n.^-1 * log((4 * (N + 2)^6) / epsilon)).^(1/2);
kBound = delta*N .* rho .* (1 - R(delta*N));
