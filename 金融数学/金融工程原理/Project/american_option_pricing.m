function [option_price, option_values, sample_paths] = american_option_pricing(S, K, r, sigma, T, N, sample_paths)
    % 计算二叉树参数
    dt = T / N;
    u = exp(sigma * sqrt(dt));
    d = 1 / u;
    p = (exp(r * dt) - d) / (u - d);

    % 构建二叉树
    tree = zeros(N+1);
    for i = 1:N+1
        for j = 1:i
            tree(i,j) = S * (u^j) * (d^(i-j));
        end
    end

    % 计算期权价值和样本路径
    option_values = zeros(N+1);
    if sample_paths
        paths = zeros(N+1);
        paths(1,1) = S;
    end

    for j = 1: N + 1
        option_values(N+1,j) = max(K - tree(N+1,j) , 0);
        if sample_paths
            paths(N+1,j) = tree(N+1,j);
        end
    end

    % 逐步回溯计算期权价值和样本路径
    for i = N:-1:1
        for j = 1:i
            exercise_value = max(K - tree(i,j) , 0);
            continuation_value = (p * option_values(i+1,j+1) + (1-p) * option_values(i+1,j)) * exp(-r * dt);
            option_values(i,j) = max(exercise_value, continuation_value);
            if sample_paths
                paths(i,j) = tree(i,j);
            end
        end
    end

    if sample_paths
        option_price = option_values(1,1);
        sample_paths = paths;
    else
        option_price = option_values(1,1);
    end
end
