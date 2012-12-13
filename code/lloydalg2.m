function [partition, codebook] = lloydalg2(variance, levels)
%LLOYDALG2 Calculates a Lloyd-Max quantizer for Gaussian input
% This function calculates the optimal quantizer for a Gaussian
% distribution with zero mean and a specified variance. The function uses
% the Lloyd II algorithm.
%
% [partition, codebook] = lloydalg2(variance, levels)
%
% Input:
% variance  Variance of the zero-mean Gaussian distribution for
%            which to calculate the quantizer.
% levels    The number of quantization levels.
%
% Output:
% partition A 1-by-(levels - 1) vector containing the partitions of
%            the calculated quantizer.
% codebook  A 1-by-levels vector containing the codebook of the
%            calculated quantizer.
    
if ~isscalar(variance)
  error('variance must be a scalar!');
end
if (levels<2)
  error('levels must be greater than or equal to 2');
end

codebook = linspace(-log(levels),log(levels),levels);
partition = (codebook(1:end-1)-codebook(2:end))/2;
codebook = sqrt(variance) * codebook;
partition = sqrt(variance) * partition;
alpha = .1;

while 1
  for k = 1:(levels-1)
    if (k==1)
      codebook(k) = -sqrt(variance/(2*pi))*exp(-partition(k)^2/(2*variance))/(1-qfunc(partition(k)/sqrt(variance)));
    else
      codebook(k) = sqrt(variance/(2*pi))*(exp(-partition(k-1)^2/(2*variance))-exp(-partition(k)^2/(2*variance)))/(qfunc(partition(k-1)/sqrt(variance))-qfunc(partition(k)/sqrt(variance)));
    end
    partition(k)=(codebook(k)+codebook(k+1))/2;
  end
  c = sqrt(variance/(2*pi))*exp(-partition(end)^2/(2*variance))/qfunc(partition(end)/sqrt(variance));
  err = codebook(end)-c;
  if (abs(err)<eps('single'))
    break;
  end
  codebook(end) = codebook(end)-alpha*err;
end
