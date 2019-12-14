function result = diffusionMaps(K, ep)
    d = zeros(size(K));
    for i = 1:size(K,1)
        for j = 1:size(K,2)
            d(i,j) = sum( (K( :, i) - K(:, j) ).^2);
        end
    end

    W = (exp(-(d .^ 2) / ep));
    q = eye(size(W)) .* (sum(W,1) .^ -1);
    k = q * W * q;

    Q = eye(size(W)) .* (sum(k,1) .^ -0.5);
    result = Q * k * Q;
