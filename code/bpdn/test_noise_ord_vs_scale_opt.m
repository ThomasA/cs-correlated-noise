function saveFileName = test_noise_ord_vs_scale_opt(quantRate)
%TEST_LLOYDMAX_ORD_VS_SCALE_OPT simulates recon. from quant. measurements
% It is intended to test whether, and possibly how much, it can improve
% compressed sensing reconstruction from (Lloyd-Max) quantized measurements
% to incorporate a linear gain-plus-additive-noise quantizer model in the
% reconstruction. This function attempts to find the optimal scaling
% factors and regularization parameters for the simulated methods as
% described in the paper, Section IV-C.
%
% Input:
%   quantRate     Equivalent quantizer bit rate (bits/measurement).
%
% Output:
%   saveFileName  The name of the file the results are saved to.
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

%% Revision control data - remove segment if you are not using SVN
stStr = evalc('system(sprintf(''svn st %s.m'',mfilename))');
svnMod = regexp(stStr,'^M','match');
revStr = '$Revision: 685 $';
svnRevision = regexp(revStr,'-?\d+','match');
svnStatus = [cell2mat(svnRevision) cell2mat(svnMod)];
clear stStr svnMod revStr svnRevision;

%% Practical details
tempFileName = [strrep(mfilename,'test','tempdata') sprintf('_r%d',quantRate) '.mat'];
saveFileName = [strrep(mfilename,'test','results') sprintf('_r%d',quantRate) '_' datestr(now,30) '.mat'];
plotFileNameTmpl = [strrep(mfilename,'test','plot') sprintf('_r%d',quantRate) '_%s_' datestr(now,30)];

%% Problem parameters
N = 1000; % Length of signal (number of samples)
deltaPoints = (.2:.1:1)'; % Chosen to give integer M
M = round(deltaPoints*N); % Number of measurements - round to avoid floats when used for indexing
polytopeStruct = load('polytope.mat','rhoW_crosspolytope');
[~,deltaIdx] = min(abs(bsxfun(@minus,polytopeStruct.rhoW_crosspolytope(:,1),deltaPoints'))); % Find indices of (approximate) delta (M/N) points.
K = floor(kFiniteN(polytopeStruct.rhoW_crosspolytope(deltaIdx,1),polytopeStruct.rhoW_crosspolytope(deltaIdx,2),1000,1/100)); % Determine K values from lower bound on finite-N phase transition from [1].
nReps = 1000;
nRepReps = 10;
repSkip = floor(nReps/nRepReps);
quantParamStruct = load('quant_model_params.mat','beta_lm');
spgopts = spgSetParms('verbosity',0);
alpha = 1-quantParamStruct.beta_lm(quantRate);
optimopts = optimset('fminsearch');

%% Variable initialization
stream = RandStream.create('mrg32k3a','NumStreams',nReps);
reset(stream) % Reset random stream for reproducibility
% Initialize result storage vars
nmseOrd = zeros(length(M),1);
epsilonOptOrd = zeros(length(M),1);
nmseScale = zeros(length(M),1);
epsilonOptScale = zeros(length(M),1);
alphaOptScale = zeros(length(M),1);
outFlagOrd = zeros(length(M),1);
outFlagScale = zeros(length(M),1);

for ii = 1:length(M)
  fprintf('ii = %d\t%s\n',ii, datestr(now));
  optimopts = optimset(optimopts,'MaxFunEvals',1000); % 1000 times number of variables
  optimopts = optimset(optimopts,'MaxIter',1000); % 1000 times number of variables
  [epsilonOptOrd(ii), nmseOrd(ii), outFlagOrd(ii)] = fminsearch(@simCoreOrd,1,optimopts);
  optimopts = optimset(optimopts,'MaxFunEvals',2000); % 1000 times number of variables
  optimopts = optimset(optimopts,'MaxIter',2000); % 1000 times number of variables
  [tmp, nmseScale(ii), outFlagScale(ii)] = fminsearch(@simCoreScale,[1;1],optimopts);
  epsilonOptScale(ii) = tmp(1);
  alphaOptScale(ii) = tmp(2);
end

save(saveFileName)
if exist(tempFileName,'file')
  delete(tempFileName);
end

%% Literature
% [1] Donoho, D. & Tanner, J., "Precise Undersampling Theorems,"
%     Proceedings of the IEEE, 2010, 98, 913-924.

function nmseVal = simCoreOrd(factor)
  for jj = 1:nRepReps
    %% Partition nReps iterations into nRepReps segments
    repStart = (jj-1)*repSkip+1;
    if jj < nRepReps
      repStop = jj*repSkip;
    else
      repStop = nReps;
    end
    %% Loop over repetitions
    nmseValTmp = zeros(nReps,1);
    %for k = repStart:repStop % FOR DEBUGGING
    parfor k = repStart:repStop
      set(stream,'Substream',k);
      %% Create the signal
      x = zeros(N,1);
      x(1:K(ii)) = randn(stream,K(ii),1);
      x = x(randperm(stream,N));
      %% Sampling Settings
      mMeas = (1/sqrt(M(ii)))*randn(stream,M(ii),N);
      %% Sample the signal
      yOrig = mMeas*x;
      %% Add noise to signal
      yvar = var(yOrig);
      % Correlated
      noiseC = (alpha-1)*yOrig + (sqrt(alpha*(1-alpha)*yvar))*randn(M(ii),1);
      yCorr = yOrig + noiseC;
      varCN = var(yCorr-yOrig);
      
      % Known variance of y - epsilon set according to (15) in the paper
      epsilon1=sqrt((M(ii) + 2*sqrt(2*M(ii)))*(1-alpha)*yvar);
      xOrd = spg_bpdn(mMeas, yCorr, factor*epsilon1, spgopts);
      % This calculates the variances of the error in the estimates
      % xOrd/xProp w.r.t. x and normalizes the error variances by the
      % variance of x:
      nmseValTmp(k) = var(xOrd-x)/var(x); 
    end
  end
  nmseVal = mean(nmseValTmp);
end

function nmseVal = simCoreScale(factors)
  for jj = 1:nRepReps
    %% Partition nReps iterations into nRepReps segments
    repStart = (jj-1)*repSkip+1;
    if jj < nRepReps
      repStop = jj*repSkip;
    else
      repStop = nReps;
    end
    %% Loop over repetitions
    nmseValTmp = zeros(nReps,1);
    %for k = repStart:repStop % FOR DEBUGGING
    parfor k = repStart:repStop
      set(stream,'Substream',k);
      %% Create the signal
      x = zeros(N,1);
      x(1:K(ii)) = randn(stream,K(ii),1);
      x = x(randperm(stream,N));
      %% Sampling Settings
      mMeas = (1/sqrt(M(ii)))*randn(stream,M(ii),N);
      %% Sample the signal
      yOrig = mMeas*x;
      %% Add noise to signal
      yvar = var(yOrig);
      % Correlated
      noiseC = (alpha-1)*yOrig + (sqrt(alpha*(1-alpha)*yvar))*randn(M(ii),1);
      yCorr = yOrig + noiseC;
      varCN = var(yCorr-yOrig);
      
      % Known variance of y - epsilon set according to (15) in the paper
      epsilon2=sqrt((M(ii) + 2*sqrt(2*M(ii)))*alpha*(1-alpha)*yvar);
      xForScale = spg_bpdn(mMeas, yCorr, factors(1)*epsilon2, spgopts);
      xProp = xForScale/(factors(2)*alpha);
      % This calculates the variances of the error in the estimates
      % xOrd/xProp w.r.t. x and normalizes the error variances by the
      % variance of x:
      nmseValTmp(k) = var(xProp-x)/var(x);
    end
  end
  nmseVal = mean(nmseValTmp);
end

end
