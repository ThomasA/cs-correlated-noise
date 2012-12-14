function plot_ord_vs_scale( filename )
%PLOT_ORD_VS_SCALE plots simulation test results.
% This function plots results of the papers comparisons between the
% proposed methods (12) and (16).
%
% Input:
%   filename  Result file to load
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
