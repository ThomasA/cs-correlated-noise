function [thr, lev, std_bin, opt_err] = bpdq_gauss_unif(nbin)
% Provides optimal uniform quantizer levels and thresholds for
% Gaussian vector
% 
% Optimization is done on thresholds
%
%   -Inf = t1, t_2, ..., t_{nbin+1} = Inf
% 
% and levels  w_i \in [t_i, t_{i+1})
%   
% Input:
%  * nbin: number of bins (even number)
%
% Output:
%  * thr: nbbin + 1 threshold between -Inf and Inf
%  * lev: the centroid of each bin 
%
% This function is kindly provided by Prof. Laurent Jacques at UC Louvain,
% Belgium. Please do not re-distribute this function without explicit
% consent from Prof. Laurent Jacques (laurent.jacques@uclouvain.be).

%% Important functions
G = @(x) (2*pi)^(-.5) * exp(- x.^2/2);
Psup = @(x) 0.5*(1-erf(x/2^.5));
I = @(a,b) Psup(min(a,b)) - Psup(max(a,b));
Err = @(a,b,c) G(a).*(max(a,-realmax)-2*c) - G(b).*(min(b,realmax)-2*c) + I(a,b).*(c.^2+1);

% Variance in each bin
Var_bin = @(T,L) Err(T(1:(end-1)),T(2:end),L)./I(T(1:(end-1)),T(2:end));


%% 
thr_f = @(d,B) [-Inf, (-(B/2-1):(B/2-1)), Inf]'*d;
lev_f = @(d,B) [(-(B-1)/2):((B-1)/2)]'*d;

Err_t = @(T,L) sum(Err(T(1:(end-1)),T(2:end),L));
Err_d = @(d,B) Err_t(thr_f(d,B),lev_f(d,B));

dopt = fminbnd(@(d) Err_d(d, nbin), 0, 10);
opt_err = Err_d(dopt, nbin);

thr = thr_f(dopt, nbin);
lev = lev_f(dopt, nbin);
std_bin = Var_bin(thr, lev).^.5;
