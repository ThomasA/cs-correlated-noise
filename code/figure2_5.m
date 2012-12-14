% This script reproduces the plots for Figures 2 and 5 in the paper

fileName = test_noise_ord_vs_scale(1);
plot_ord_vs_scale(fileName);
plot_discrepancies(fileName);
fileName = test_noise_ord_vs_scale(3);
plot_ord_vs_scale(fileName);
plot_discrepancies(fileName);
fileName = test_noise_ord_vs_scale(5);
plot_ord_vs_scale(fileName);
plot_discrepancies(fileName);
