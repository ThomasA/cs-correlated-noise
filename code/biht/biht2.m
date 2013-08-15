function [ x ] = biht2( Phi, y, K, scale, doProjection )
%BIHT Reconstructs sparse vectors from 1-bit quantized, compressed meas.
%   This function is adapted from a demo script by: J. Laska, L. Jacques,
%   P. Boufounos, R. Baraniuk
%   (http://dsp.rice.edu/software/binary-iterative-hard-thresholding-biht-demo).
%
%   Input:
%     Phi  Sensing matrix.
%     y    1-bit quantized, compressed measurements.
%     K    Desired sparsity of solution.
%   Output:
%     x    K-sparse (unit-norm) estimate of the vector x producing
%          y = sign(A*x).
%
%   Function adapted from original demo script by Thomas Arildsen,
%   Department of Electronic Systems, Aalborg University, Denmark.

maxiter = 3000;
htol = 0;

N = size(Phi,2);
x = zeros(N,1);
hd = Inf;

if ~exist('scale','var')
  scale = 1;
end
if ~exist('doProjection','var')
  doProjection = true;
end

A = @(in) scale*sign(Phi*in);

ii=0;
while (htol < hd) && (ii < maxiter)
	% Get gradient
	g = Phi'*(A(x) - y);
	
	% Step
	a = x - g;
	
	% Best K-term (threshold)
	[~, aidx] = sort(abs(a), 'descend');
	a(aidx(K+1:end)) = 0;
	
    % Update x
	x = a;

	% Measure hammning distance to original 1bit measurements
	hd = nnz(y - A(x));
	ii = ii+1;
end

% Now project to sphere
if doProjection
  x = x/norm(x);
end

end
