% This script plots the Donoho-Tanner phase transition for the paper.
% It plots both the theoretical inifite-N transition and the lower bound on
% the N = 1000, 99% transition. It also plots points corresponding to
% chosen values of K.

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
