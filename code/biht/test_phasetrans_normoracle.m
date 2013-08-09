function saveFileName = test_phasetrans(N,delta,stride)
%TEST_PHASETRANS simulates recon. from 1-bit quantized measurements
% It is intended to simulate how accurately BPDN with our proposed scaling
% reconstructs from 1-bit quantized measurements over the phase space. This
% function simulates one vertical "slice" of the phase space and continues
% until the norm of the reconstruction error becomes larger than the norm
% of the true solution.
%
% Input:
%   N        Size of the sparse solution vector to estimate.
%   delta    Parameter in [0,1] determining the undersampling fraction
%            (identifies a vertical slice in the phase space).
%   stride   Step size to move along the vertical direction of the phase
%            space at.
%
% Output:
%   saveFileName  The name of the file the results are saved to.
%
%   Code implemented by: Thomas Arildsen
%   Contact e−mail: sparsig−toolbox@es.aau.dk
%
%   Version history:
%     1.0   [31−MAY−2012] Paper review version.

%   Copyright 2013 Thomas Arildsen, Aalborg University, Denmark
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

%% Practical details
tempFileName = [strrep(mfilename,'test','tempdata') sprintf('_N%d_delta%.3f',N,delta) '.mat'];
saveFileName = [strrep(mfilename,'test','results') sprintf('_N%d_delta%.3f',N,delta) '_' datestr(now,30) '.mat'];
plotFileNameTmpl = [strrep(mfilename,'test','plot') sprintf('_N%d_delta%.3f',N,delta) '_' datestr(now,30)];

%% Problem parameters
M = round(delta*N); % Determine number of measurements corresp. to delta
K = round((stride:stride:1).*M);
nReps = 1000;
nRepReps = 10;
repSkip = floor(nReps/nRepReps);
load('quant_model_params.mat');
[part,cb] = bpdq_gauss_unif(2); % 1-bit quantizer
part = part(2:end-1)';
cb = cb';
alpha = 1-beta_u(1);

%% Stop-and-resume initialization
stream = RandStream.create('mrg32k3a','NumStreams',nReps);
% Be careful if re-running a previously stopped simulation. It will
% re-start at the point where the stopped simulation left off, based on a
% temporary data file. If you do not want this, delete the corresponding
% 'tempdata...' file.
if exist(tempFileName,'file')
  load(tempFileName)
  K_LOOP_STARTVAL =ii;
  REPREP_LOOP_STARTVAL = jj;
  set(stream,'State',randState);
else
  reset(stream) % Reset random stream for reproducibility
  K_LOOP_STARTVAL = 1;
  REPREP_LOOP_STARTVAL = 1;
  % Initialize result storage vars
  NMSE = zeros(length(K),nReps);
  NMSE_avg = zeros(length(K),1);
  NMSE_avgci = zeros(length(K),2);
end

for ii = K_LOOP_STARTVAL:length(K)
  for jj = REPREP_LOOP_STARTVAL:nRepReps
    fprintf('ii = %d, jj = %d\t%s\n',ii, jj, datestr(now));
    %% Store stop-and-resume data
    tempData.randState = get(stream,'State');
    tempData.ii = ii;
    tempData.jj = jj;
    tempData.NMSE = NMSE;
    tempData.NMSE_avg = NMSE_avg;
    tempData.NMSE_avgci = NMSE_avgci;
    save(tempFileName,'-struct','tempData');
    %% Partition nReps iterations into nRepReps segments
    repStart = (jj-1)*repSkip+1;
    if jj < nRepReps
      repStop = jj*repSkip;
    else
      repStop = nReps;
    end
    %% Loop over repetitions
    for k = repStart:repStop % FOR DEBUGGING
    %parfor k = repStart:repStop
      set(stream,'Substream',k);
      %% Create the signal
      x = zeros(N,1);
      x(1:K(ii)) = randn(stream,K(ii),1);
      x = x(randperm(stream,N));
      x = x/norm(x); % Unit-norm x
      %% Sampling Settings
      mMeas = (1/sqrt(M))*randn(stream,M,N);
      %% Sample the signal
      yOrig = mMeas*x;
      %% Quantize the signal
      yvar = var(yOrig);
      ynorm = norm(yOrig,2);
      % Known variance of y
      [~, yQuant] = quantiz(yOrig,sqrt(yvar)*part,sqrt(yvar)*cb);
      yQuant = yQuant';
      % Known variance of y - epsilon set according to (15) in the paper
      xEst = biht2(mMeas, yQuant, K(ii), sqrt(yvar)*cb(end), false);
      xEst = xEst / norm(xEst); % Enforce unit norm
      % This calculates the variances of the error in the estimates
      % xOrd/xProp w.r.t. x and normalizes the error variances by the
      % variance of x:
      NMSE(ii,k) = var(xEst-x,1)/var(x); 
    end
    REPREP_LOOP_STARTVAL = 1; % REPREP_LOOP_STARTVAL is only (possibly) > 1 for the first iteration ii after a restart
  end
  % 99% Confidence intervals estimated by assuming the mean of the sample
  % to be normal distributed and then estimating the confidence intervals
  % according to [2], Section 7.3.1.
  NMSE_avg(ii) = mean(NMSE(ii,:));
  NMSE_avgci(ii,:) = NMSE_avg(ii) + [-1 1]'*tinv(1-.005,nReps-1)*std(NMSE(ii,:))/sqrt(nReps);
  % Stop if problems are getting infeasible (large reconstruction error)
  if (mean(NMSE(ii,:)) > 1)
    warning('Reaching infeasible region - stopping now...');
    break;
  end
end

save(saveFileName)
if exist(tempFileName,'file')
  delete(tempFileName);
end

%% Literature
% [1] Donoho, D. & Tanner, J., "Precise Undersampling Theorems,"
%     Proceedings of the IEEE, 2010, 98, 913-924.
% [2] Ross, S. M., "Introduction to Probability and Statistics for
%     Engineers and Scientists," Academic Press, 2000.
