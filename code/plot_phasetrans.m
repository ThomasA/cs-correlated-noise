function plot_phasetrans( filename_tmpl, stride, otherFile )
%PLOT_PHASETRANS This script plots results from test results.
%
% Input:
%   filename_tmpl  File name template for loading files

close all

%% Load results
if (~isempty(regexp(filename_tmpl,'(.mat)$')) && exist(filename_tmpl,'file'))
  load(filename_tmpl,'NMSEmat','plotFileNameTmpl');
else % Assume that filename_tmpl is a wildcard template filename matching ALL and ONLY the simulation output data files that should be included
  maskVal = Inf; % Value used to mark un-tested phase space points
  NMSEmat = maskVal*ones(round(1/stride));
  filenames = dir(filename_tmpl);
  % Assemble matrix of NMSE over phase space
  for ii = 1:length(filenames)
    data = load(filenames(ii).name);
    NMSEmat(1:length(data.NMSE_avg(data.NMSE_avg>0)),round(data.delta*1/stride)) = data.NMSE_avg(data.NMSE_avg>0);
  end
  plotFileNameTmpl = regexprep(data.plotFileNameTmpl,'_delta[01]\.[0-9]+','');
  % Store assembled results
  save(regexprep(data.saveFileName,'delta[01]\.[0-9_T]+','NMSE'),'NMSEmat');
end

%% Plot results
h = figure;
map = colormap('jet');
map(end+1,:) = ones(1,3); % Add a white color for maximum value to the color map
colormap(map);
imagesc(stride:stride:1,stride:stride:1,NMSEmat); % Now the un-tested phase space points will be marked white due to Inf mask value and the above color map
axis xy
hold on
contour(stride:stride:1,stride:stride:1,NMSEmat,.1:.1:1,'ShowText','on','LineColor','k');
if exist('otherFile','var')
  if exist(otherFile,'file')
    otherNMSEmat = load(otherFile,'NMSEmat');
    contour(.01:.01:1,.01:.01:1,NMSEmat-otherNMSEmat.NMSEmat,[0 0],'LineColor','k','LineWidth',3);
  end
end
ylabel('Measurement density $\rho$ $(K/M)$ [--]');
xlabel('Oversampling ratio $\rho$ $(M/N)$ [--]');
grid on;
matlab2tikz(sprintf([plotFileNameTmpl '.tikz']),'width','\figurewidth','height','\figureheight','parseStrings',false,'strict',true,'figurehandle',h);
hgsave(h,sprintf([plotFileNameTmpl '.fig'],'prescale'));
map = colormap('gray');
map(end+1,:) = ones(1,3); % Add a white color for maximum value to the color map
colormap(map);
matlab2tikz(sprintf([plotFileNameTmpl '_gray.tikz']),'width','\figurewidth','height','\figureheight','parseStrings',false,'strict',true,'figurehandle',h);
hgsave(h,sprintf([plotFileNameTmpl '_gray.fig'],'prescale'));
