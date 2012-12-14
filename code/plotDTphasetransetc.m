% This script plots the Donoho-Tanner phase transition for the paper.
% It plots both the theoretical inifite-N transition and the lower bound on
% the N = 1000, 99% transition. It also plots points corresponding to
% chosen values of K.
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

clear all
close all

load('polytope.mat'); % You will need Donoho & Tanner's tabulated values: http://ecos.maths.ed.ac.uk/data/polytope.mat

N = 1000; % Length of signal (number of samples)
deltaPoints = (.2:.1:1)';
M = round(deltaPoints*N); % Number of measurements - round to avoid floats when used for indexing
[~,deltaIdx] = min(abs(bsxfun(@minus,rhoW_crosspolytope(:,1),deltaPoints'))); % Find indices of (approximate) delta (M/N) points.
K = floor(kFiniteN(rhoW_crosspolytope(deltaIdx,1),rhoW_crosspolytope(deltaIdx,2),1000,1/100)); % Determine K values from lower bound on finite-N phase transition from [1].
pointsDelta = M./N;
pointsRho = K./M;

h = figure;
plot(rhoW_crosspolytope(:,1),rhoW_crosspolytope(:,2),'-k');
hold on
plot(rhoW_crosspolytope(:,1),max(rhoFiniteN(rhoW_crosspolytope(:,1),rhoW_crosspolytope(:,2),N,1/100),0),'--k');
plot(pointsDelta,pointsRho,'xk');

xlabel('$\delta$ [--]','Interpreter','none');
ylabel('$\rho$ [--]','Interpreter','none');
grid on;
l = legend('$50\%$ phase transition, $N \rightarrow\infty$','$99\%$ phase transition, $N = 1000$','$(\delta,\rho)$-points of chosen $K$','Location','NorthWest');
set(l,'Interpreter','none');
% Comment out the following line if you do not want to export TiKZ graphics
% using matlab2tikz:
matlab2tikz('DTphasetransetc.tikz','width','\figurewidth','height','\figureheight','ParseStrings',false,'strict',true,'figurehandle',h);
hgsave(h,'DTphasetransetc.fig');
