clc;clear; close all;

serie_vazoes = load('furnas.dat');

ln_serie = log(serie_vazoes);
m_serie = mean(ln_serie);
dp_serie = std(ln_serie);

modulo_serie = reshape(((ln_serie-m_serie)./dp_serie)', 1,[]);

n = size(modulo_serie,2);
p = 2;
tau_max = 25;

y_real = modulo_serie;
coef_fac = myfac3(modulo_serie,p);
par_ar_yule = yulewalker(coef_fac,p);

for i=1:n-p
    y_estimado(i) = sum(par_ar_yule'*y_real(i:i+p-1));
end

erro_aryule = y_real(1:end-p)-y_estimado(1:end);
media_erro_aryule(p) = mean(erro_aryule);
vteste(p) = sum(erro_aryule.^2/(n-p));
var_erro_aryule(p) = var(erro_aryule);
dp_erro_aryule(p) = std(erro_aryule);
fac_erro_aryule = myfac3(erro_aryule,tau_max);

fig = figure; clf

h = histfit(erro_aryule,20); hold on
grid on
plotlatex(fig, ['Histograma do Resíduo - AR(',num2str(p),')'], ' ', '  ');
hold off
fig = figure; clf
h = bar(fac_erro_aryule,'white','LineStyle','-','LineWidth',0.5); hold on
grid on
plotlatex(fig, ['Funcao de Autocorrelacao do Residuo - AR(',num2str(p),')'] , 'tau (lag)', 'FAC')
hold off