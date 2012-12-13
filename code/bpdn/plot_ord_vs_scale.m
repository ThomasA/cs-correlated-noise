function plot_ord_vs_scale( filename )
%PLOT_ORD_VS_SCALE plots simulation test results.
% This function plots results of the papers comparisons between the
% proposed methods (12) and (16).
%
% Input:
%   filename  Result file to load

close all

%% Load results
load(filename);

%% Plot results
epsIdx = ceil(length(factorsEpsilon)/2);
h = figure;
errorbar(K./M,NMSE1_avg(epsIdx,1,:),NMSE1_avg(epsIdx,1,:)-NMSE1_avgci(epsIdx,1,:,1),NMSE1_avgci(epsIdx,1,:,2)-NMSE1_avg(epsIdx,1,:),'--ko')
hold on
errorbar(K./M,NMSE2_avg(epsIdx,1,:),NMSE2_avg(epsIdx,1,:)-NMSE2_avgci(epsIdx,1,:,1),NMSE2_avgci(epsIdx,1,:,2)-NMSE2_avg(epsIdx,1,:),'--kx')
xlabel('Measurement density $\rho$ $(K/M)$ [--]');
ylabel('NMSE [--]');
grid on;
legend('BPDN','BPDN-scale','Location','SouthEast');
axisTmp = axis;
axisTmp(1) = 0;
axis(axisTmp);
% Comment out the following line if you do not want to export TiKZ graphics
% using matlab2tikz:
matlab2tikz(sprintf([plotFileNameTmpl '.tikz'],'prescale'),'width','\figurewidth','height','\figureheight','parseStrings',false,'strict',true,'figurehandle',h);
hgsave(h,sprintf([plotFileNameTmpl '.fig'],'prescale'));

h = figure;
errorbar(K./M,NMSE1_avg(epsIdx,1,:),NMSE1_avg(epsIdx,1,:)-NMSE1_avgci(epsIdx,1,:,1),NMSE1_avgci(epsIdx,1,:,2)-NMSE1_avg(epsIdx,1,:),'--ko')
hold on
errorbar(K./M,NMSE3_avg(epsIdx,1,:),NMSE3_avg(epsIdx,1,:)-NMSE3_avgci(epsIdx,1,:,1),NMSE3_avgci(epsIdx,1,:,2)-NMSE3_avg(epsIdx,1,:),'--kx')
xlabel('Measurement density $\rho$ $(K/M)$ [--]');
ylabel('NMSE [--]');
grid on;
legend('BPDN','BPDN-scale','Location','SouthEast');
axisTmp = axis;
axisTmp(1) = 0;
axis(axisTmp);
% Comment out the following line if you do not want to export TiKZ graphics
% using matlab2tikz:
matlab2tikz(sprintf([plotFileNameTmpl '.tikz'],'postscale'),'width','\figurewidth','height','\figureheight','parseStrings',false,'strict',true,'figurehandle',h);
hgsave(h,sprintf([plotFileNameTmpl '.fig'],'postscale'));

h = figure;
errorbar(K./M,NMSE2_avg(epsIdx,1,:),NMSE2_avg(epsIdx,1,:)-NMSE2_avgci(epsIdx,1,:,1),NMSE2_avgci(epsIdx,1,:,2)-NMSE2_avg(epsIdx,1,:),'--ko')
hold on
errorbar(K./M,NMSE3_avg(epsIdx,1,:),NMSE3_avg(epsIdx,1,:)-NMSE3_avgci(epsIdx,1,:,1),NMSE3_avgci(epsIdx,1,:,2)-NMSE3_avg(epsIdx,1,:),'--kx')
xlabel('Measurement density $\rho$ $(K/M)$ [--]');
ylabel('NMSE [--]');
grid on;
legend('BPDN (pre-scale)','BPDN (post-scale)','Location','SouthEast');
axisTmp = axis;
axisTmp(1) = 0;
axis(axisTmp);
% Comment out the following line if you do not want to export TiKZ graphics
% using matlab2tikz:
matlab2tikz(sprintf([plotFileNameTmpl '.tikz'],'compare'),'width','\figurewidth','height','\figureheight','parseStrings',false,'strict',true,'figurehandle',h);
hgsave(h,sprintf([plotFileNameTmpl '.fig'],'compare'));
