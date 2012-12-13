function [ bound ] = rhoFiniteN(delta, rho, N, epsilon)
%RHOFINITEN This function calculates finite-N phase transition bounds
%   The function returns a finite-N bound on the compressed sensing
%   reconstruction phase transition for Gaussian measurement matrices. The
%   bound is calculated according to [1], Section IV.
%
%   [1] Donoho, D. & Tanner, J. Precise Undersampling Theorems Proceedings
%   of the IEEE, 2010, 98, 913-924.

assert(all(size(delta) == size(rho)));
assert(isvector(delta) && isvector(rho));

R = @(n) 2*sqrt((n.^-1 * log((4 * (N + 2)^6) / epsilon)));
bound = rho .* (1 - R(delta*N));

% Remember to threshold plot at rho = 1 since the bound will go below zero!
