function [discrep, nmseBaseline, nmsePrescale, nmsePostscale, indices] = plot_discrepancies( varargin )
%PLOT_DISCREPANCIES plots occurrences of discrepancies.
% Discrepancies are instances of signal realizations where Proposition 1 in
% the paper does not hold to within a 2-norm difference in estimates of
% 10^-6.
%
% Input:
%   filename  Result file to load. You can specify multiple file names.

close all
discrepThres = 1e-6;
commonAxis = zeros(1,4);
histBins = 20;

for fileIdx = 1:nargin
  %% Load results
  load(varargin{fileIdx});

  i = find(factorsEpsilon==1);
  j = find(factorsAlpha==1);
  solDiffReduced{fileIdx} = squeeze(solDiff(i,j,:,:)); % Only examine the part correpsonding to the default choices of alpha and epsilon from
  NMSE1Reduced{fileIdx} = squeeze(NMSE1(i,j,:,:));
  NMSE2Reduced{fileIdx} = squeeze(NMSE2(i,j,:,:));
  NMSE3Reduced{fileIdx} = squeeze(NMSE3(i,j,:,:));
  [k, l] = find(solDiffReduced{fileIdx}(solDiffReduced{fileIdx} > discrepThres));
  indices{fileIdx} = [repmat(i, size(k)) repmat(j, size(k)) k l];
  discrep{fileIdx} = solDiffReduced{fileIdx}(solDiffReduced{fileIdx} > discrepThres);
  nmseBaseline{fileIdx} = NMSE1Reduced{fileIdx}(solDiffReduced{fileIdx} > discrepThres);
  nmsePrescale{fileIdx} = NMSE2Reduced{fileIdx}(solDiffReduced{fileIdx} > discrepThres);
  nmsePostscale{fileIdx} = NMSE3Reduced{fileIdx}(solDiffReduced{fileIdx} > discrepThres);
  plotFileNameTmplAll{fileIdx} = plotFileNameTmpl;
end
maxDiscrep = ndmax(cell2mat(solDiffReduced));
for fileIdx = 1:nargin
  %% Plot results
  h(fileIdx) = figure;
  hist(solDiffReduced{fileIdx}(solDiffReduced{fileIdx}>1e-6),linspace(0+maxDiscrep/(2*histBins-1),maxDiscrep,histBins));
  hHist = findobj(get(h(fileIdx),'CurrentAxes'),'Type','patch');
  set(hHist,'FaceColor',[.5 .5 .5])
  xlabel('2-norm of error $e$ [--]');
  ylabel('Occurrences [--]');
  set(gca,'YGrid','on');
  commonAxis = rectbb([commonAxis;axis(get(h(fileIdx),'CurrentAxes'))]);
end

for fileIdx = 1:nargin
  axis(get(h(fileIdx),'CurrentAxes'),commonAxis);
  % Comment out the following line if you do not want to export TiKZ
  % graphics using matlab2tikz:
  matlab2tikz([strrep(plotFileNameTmplAll{fileIdx},'%s_','') '_discrep.tikz'],'width','\figurewidth','height','\figureheight','parseStrings',false,'strict',true,'figurehandle',h(fileIdx));
  hgsave(h(fileIdx),[strrep(plotFileNameTmplAll{fileIdx},'%s_','') '_discrep.fig']);
end
