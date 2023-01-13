function ahat = ols_est(sinal,p)
    x = sinal';
    v = x(p+1:end);
    u = p+1;
    X = [];
    for k=1:p
        x_n = x(p-k+1:end-k);
        X = [X x_n];
    end
    ahat = (X'*X)\(X'*v);
end
