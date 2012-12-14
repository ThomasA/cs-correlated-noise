% This script reprocudes the numbers shown in Table II in the paper.

fileName = test_noise_ord_vs_scale_opt(1);
load(fileName);
display([M K epsilonOptOrd nmseOrd alphaOptScale epsilonOptScale nmseScale])
fileName = test_noise_ord_vs_scale_opt(3);
load(fileName);
display([M K epsilonOptOrd nmseOrd alphaOptScale epsilonOptScale nmseScale])
fileName = test_noise_ord_vs_scale_opt(5);
load(fileName);
display([M K epsilonOptOrd nmseOrd alphaOptScale epsilonOptScale nmseScale])
