function a = yulewalker(coef_fac,p)
    z = coef_fac(1:p+1);
    r = z(2:end)';
    R = toeplitz(z(1:p));
    a = R\r;
end