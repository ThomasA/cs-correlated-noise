function saveFileName = test_lloydmax_ord_vs_scale(quantRate)
%TEST_LLOYDMAX_ORD_VS_SCALE simulates recon. from quantized measurements
% It is intended to test whether, and possibly how much, it can improve
% compressed sensing reconstruction from (Lloyd-Max) quantized measurements
% to incorporate a linear gain-plus-additive-noise quantizer model in the
% reconstruction.
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

%% Practical details
tempFileName = [strrep(mfilename,'test','tempdata') sprintf('_r%d',quantRate) '.mat'];
saveFileName = [strrep(mfilename,'test','results') sprintf('_r%d',quantRate) '_' datestr(now,30) '.mat'];
plotFileNameTmpl = [strrep(mfilename,'test','plot') sprintf('_r%d',quantRate) '_%s_' datestr(now,30)];

%% Problem parameters
N = 1000; % Length of signal (number of samples)
deltaPoints = (.2:.1:1)'; % Chosen to give integer M
M = round(deltaPoints*N); % Number of measurements - round to avoid floats when used for indexing
load('polytope.mat'); % You will need Donoho & Tanner's tabulated values: http://ecos.maths.ed.ac.uk/data/polytope.mat
[~,deltaIdx] = min(abs(bsxfun(@minus,rhoW_crosspolytope(:,1),deltaPoints'))); % Find indices of (approximate) delta (M/N) points.
K = floor(kFiniteN(rhoW_crosspolytope(deltaIdx,1),rhoW_crosspolytope(deltaIdx,2),1000,1/100)); % Determine K values from lower bound on finite-N phase transition from [1].
nReps = 1000;
nRepReps = 10;
repSkip = floor(nReps/nRepReps);
load('quant_model_params.mat');
[part,cb] = lloydalg2(1,2^quantRate);
spgopts = spgSetParms('verbosity',0);
alpha = 1-beta_lm(quantRate);
factorsEpsilon = logspace(log10(.5),log10(2),9);
factorsAlpha = 1;

%% Stop-and-resume initialization
stream = RandStream.create('mrg32k3a','NumStreams',nReps);
% Be careful if re-running a previously stopped simulation. It will
% re-start at the point where the stopped simulation left off, based on a
% temporary data file. If you do not want this, delete the corresponding
% 'tempdata...' file.
if exist(tempFileName,'file')
  load(tempFileName)
  M_LOOP_STARTVAL =ii;
  REPREP_LOOP_STARTVAL = jj;
  set(stream,'State',randState);
else
  reset(stream) % Reset random stream for reproducibility
  M_LOOP_STARTVAL = 1;
  REPREP_LOOP_STARTVAL = 1;
  % Initialize result storage vars
  NMSE1 = zeros(length(factorsEpsilon),1,nReps,length(M));
  NMSE2 = zeros(length(factorsEpsilon),length(factorsAlpha),nReps,length(M));
  NMSE3 = zeros(length(factorsEpsilon),length(factorsAlpha),nReps,length(M));
  solDiff = zeros(length(factorsEpsilon),length(factorsAlpha),nReps,length(M));
  NMSE1_avg = zeros(length(factorsEpsilon),1,length(M));
  NMSE2_avg = zeros(length(factorsEpsilon),length(factorsAlpha),length(M));
  NMSE3_avg = zeros(length(factorsEpsilon),length(factorsAlpha),length(M));
  NMSE1_avgci = zeros(length(factorsEpsilon),1,length(M),2);
  NMSE2_avgci = zeros(length(factorsEpsilon),length(factorsAlpha),length(M),2);
  NMSE3_avgci = zeros(length(factorsEpsilon),length(factorsAlpha),length(M),2);
end

for ii = M_LOOP_STARTVAL:length(M)
  for jj = REPREP_LOOP_STARTVAL:nRepReps
    fprintf('ii = %d, jj = %d\t%s\n',ii, jj, datestr(now));
    %% Store stop-and-resume data
    tempData.randState = get(stream,'State');
    tempData.ii = ii;
    tempData.jj = jj;
    tempData.NMSE1 = NMSE1;
    tempData.NMSE2 = NMSE2;
    tempData.NMSE3 = NMSE3;
    tempData.solDiff = solDiff;
    tempData.NMSE1_avg = NMSE1_avg;
    tempData.NMSE2_avg = NMSE2_avg;
    tempData.NMSE3_avg = NMSE3_avg;
    tempData.NMSE1_avgci = NMSE1_avgci;
    tempData.NMSE2_avgci = NMSE2_avgci;
    tempData.NMSE3_avgci = NMSE3_avgci;
    save(tempFileName,'-struct','tempData');
    %% Partition nReps iterations into nRepReps segments
    repStart = (jj-1)*repSkip+1;
    if jj < nRepReps
      repStop = jj*repSkip;
    else
      repStop = nReps;
    end
    %% Loop over repetitions
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
      %% Quantize the signal
      yvar = var(yOrig);
      % Known variance of y
      [~, yQuant] = quantiz(yOrig,sqrt(yvar)*part,sqrt(yvar)*cb);
      yQuant = yQuant';

      % Known variance of y - epsilon set according to (15) in the paper
      epsilon1=sqrt((M(ii) + 2*sqrt(2*M(ii)))*(1-alpha)*yvar);
      epsilon2=sqrt((M(ii) + 2*sqrt(2*M(ii)))*alpha*(1-alpha)*yvar);
      xOrd = zeros(N,length(factorsEpsilon));
      xForScale = zeros(N,length(factorsEpsilon));
      xProp1 = zeros(N,length(factorsEpsilon),length(factorsAlpha));
      xProp2 = zeros(N,length(factorsEpsilon),length(factorsAlpha));
      solDiffTmp = zeros(length(factorsEpsilon),length(factorsAlpha));
      for l = 1:length(factorsEpsilon)
        xOrd(:,l) = spg_bpdn(mMeas, yQuant, factorsEpsilon(l)*epsilon1, spgopts);
        xForScale(:,l) = spg_bpdn(mMeas, yQuant, factorsEpsilon(l)*epsilon2, spgopts);
        for m = 1:length(factorsAlpha)
          xProp1(:,l,m) = spg_bpdn(factorsAlpha(m)*alpha*mMeas, yQuant, factorsEpsilon(l)*epsilon2, spgopts);
          xProp2(:,l,m) = xForScale(:,l)/(factorsAlpha(m)*alpha);
          solDiffTmp(l,m) = norm(xProp1(:,l,m)-xProp2(:,l,m),2);
        end
      end
      % This calculates the variances of the error in the estimates
      % xOrd/xProp w.r.t. x and normalizes the error variances by the
      % variance of x:
      NMSE1(:,1,k,ii) = sum(bsxfun(@minus,x,xOrd).^2,1)/sum(x.^2,1); 
      NMSE2(:,:,k,ii) = sum(bsxfun(@minus,x,xProp1).^2,1)/sum(x.^2,1);
      NMSE3(:,:,k,ii) = sum(bsxfun(@minus,x,xProp2).^2,1)/sum(x.^2,1);
      solDiff(:,:,k,ii) = solDiffTmp;
    end
    REPREP_LOOP_STARTVAL = 1; % REPREP_LOOP_STARTVAL is only (possibly) > 1 for the first iteration ii after a restart
  end
  % 99% Confidence intervals estimated by assuming the mean of the sample
  % to be normal distributed and then estimating the confidence intervals
  % according to [2], Section 7.3.1.
  for l = 1:length(factorsEpsilon)
    NMSE1_avg(l,1,ii) = mean(NMSE1(l,1,:,ii));
    NMSE1_avgci(l,1,ii,:) = mean(NMSE1(l,1,:,ii)) + [-1 1]'*tinv(1-.005,size(NMSE1,3)-1)*std(NMSE1(l,1,:,ii))/sqrt(size(NMSE1,3));
    for m = 1:length(factorsAlpha)
      NMSE2_avg(l,m,ii) = mean(NMSE2(l,m,:,ii));
      NMSE2_avgci(l,m,ii,:) = mean(NMSE2(l,m,:,ii)) + [-1 1]'*tinv(1-.005,size(NMSE2,3)-1)*std(NMSE2(l,m,:,ii))/sqrt(size(NMSE2,3));
      NMSE3_avg(l,m,ii) = mean(NMSE3(l,m,:,ii));
      NMSE3_avgci(l,m,ii,:) = mean(NMSE3(l,m,:,ii)) + [-1 1]'*tinv(1-.005,size(NMSE3,3)-1)*std(NMSE3(l,m,:,ii))/sqrt(size(NMSE3,3));
    end
  end
end

SNR1_avg = db(1./NMSE1_avg,'power');
SNR2_avg = db(1./NMSE2_avg,'power');
SNR3_avg = db(1./NMSE3_avg,'power');

save(saveFileName)
if exist(tempFileName,'file')
  delete(tempFileName);
end

%% Literature
% [1] Donoho, D. & Tanner, J., "Precise Undersampling Theorems,"
%     Proceedings of the IEEE, 2010, 98, 913-924.
% [2] Ross, S. M., "Introduction to Probability and Statistics for
%     Engineers and Scientists," Academic Press, 2000.
