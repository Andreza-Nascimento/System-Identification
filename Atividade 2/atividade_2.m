

%% Item 1

N = 5000;
variancia_awgn = 0.1;
sinal_awgn = sqrt(variancia_awgn)*randn(N,1);
media_ruido = mean(sinal_awgn);
variancia_ruido = var(sinal_awgn);

tau_max = 50;
[R_ruido lag] = xcorr(sinal_awgn-media_ruido,tau_max,'unbiased');
figure; stem(lag,R_ruido,'r-','linewidth',3);
xlabel('tau (lag)'); ylabel('FAC');
title('Funcao de Autocorrelacao: Processo AWGN');
h=get(gcf, "currentaxes");
set(h, "fontsize", 12, "linewidth", 2);
print -color -depsc fac-ar1.eps

