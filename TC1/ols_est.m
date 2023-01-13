function ahat = ols_est(sinal,p,n)
    x = sinal';
    v = x(p+1:n);
    u = p+1;
    for k=p:1
        X(:,u-k) = x(n+(u-k):k);
    end
    ahat = (X'*X)\(X'*v);
end
