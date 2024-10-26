clear;clc;
%% Parameters
S = 2.31;  
K = 2.31;  
r = 0.02677;  % rist-free
sigma = sqrt(0.000063) * sqrt(252);  % year volatility
T = 1/12;  % year
N = 20;  % step

%% Calculate
[option_price, option_values, sample_paths] = american_option_pricing(S, K, r, sigma, T, N, true);
disp("美式看跌期权价格: " + num2str(option_price));
disp("样本路径:");
disp(sample_paths);

%% Delta-Hedge
delta = zeros(N, N); 

for i = 1: N
    for j = 1: i
        delta(i,j) = (option_values(i+1, j+1) - option_values(i+1, j)) / (sample_paths(i+1, j+1) - sample_paths(i+1, j));
    end
end
delta


