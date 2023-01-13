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

for i=p+1:n
    y_n = flip(y_real(i-p:i-1));
    y_estimado(i-p) = sum(par_ar_yule'.*y_n);
end

erro_aryule = y_real(p+1:end)-y_estimado;
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


par_ar_ols = ols_est(y_real,p);
    for i=p+2:n-p
        y_nt = flip(y_real(i-p:i-2));
        y_est(i-p-1) = sum(par_ar_yule'.*y_n);
    end
        
    erro_ols = y_real(p+j:end)-y_est;
    j = j+1;

    media_erro_ols(p) = mean(erro_ols);
    var_erro_ols(p) = var(erro_ols);
    dp_erro_ols(p) = std(erro_ols);
    
    fac_erro_ols = myfac3(erro_ols,tau_max);
    
    fig = figure; clf
    
    h = histfit(erro_ols,20); hold on
    grid on
    plotlatex(fig, ['Histograma do Resíduo - OLS ordem ',num2str(p),''], ' ', '  ');
    hold off
    fig = figure; clf
    h = bar(fac_erro_ols,'white','LineStyle','-','LineWidth',0.5); hold on
    grid on
    plotlatex(fig, ['Funcao de Autocorrelacao do Residuo - OLS ordem ',num2str(p),''] , 'tau (lag)', 'FAC')
    hold off

    y_est = [];