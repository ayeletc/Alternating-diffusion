function result = affinityMatrix(s, ep)
% Calculate the affinity matrix of samples vector: s[Nx3], using epislon ep
    szx = size(s,1);
    szy = 3; % x, y, z
    
    b = s(:);
    
    bRep = repmat(b,[1 szy*szx]);
    bSubt =  bRep-bRep';
    
    x = bSubt(1:szx, 1:szx);
    y = bSubt((1:szx)+szx, (1:szx)+szx);
    z = bSubt((1:szx)+szx*2, (1:szx)+szx*2);
    
    vNorm = vecnorm([x(:) y(:) z(:)],2,2);
    matNorm = reshape(vNorm, [szx szx]);
    result = exp(-(matNorm .^ 2) / ep);

if 0
%% Test:
    a = [10,20, 30, 40; 1, 2, 3, 4; 100, 200, 300, 400]';
    a = a ./ 100;
    affinityMatrix(a, ep)
end
