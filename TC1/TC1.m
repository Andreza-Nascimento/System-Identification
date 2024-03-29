% DISCIPLINA: TIP7044 - ESTIMAÇÃO E IDENTIFICAÇÃO DE SISTEMAS (2022.2 - T01)
% PROFESSOR: GUILHERME DE ALENCAR BARRETO
% ALUNO(A): ANDREZA COSTA NASCIMENTO
% MATRÍCULA: 544957

% 1º TRABALHO COMPUTACIONAL

%% Parte 1 - Normalização (Método Artigo)

clc;clear; close all;

serie_vazoes = load('furnas.dat');

fig = figure; clf

plot(serie_vazoes'); hold on
grid on
plotlatex(fig, 'Série de Vazões Furnas de Jan/1930 até Dez/1990 com Sazonalidade', 'Mês', 'Vazão média do reservatório (m³)')
hold off

%----------------------------- SÉRIES TEMPORAIS -----------------------------%

ln_serie = log(serie_vazoes);
m_serie = mean(ln_serie);
dp_serie = std(ln_serie);

modulo_serie = reshape(((ln_serie-m_serie)./dp_serie)', 1,[]);
serie_vazoes = reshape((serie_vazoes)', 1,[]);

fig = figure; clf

plot(serie_vazoes); hold on
grid on
plotlatex(fig, 'Série de Vazões Furnas de Jan/1930 até Dez/1990 com Sazonalidade', 'Mês', 'Vazão média do reservatório (m³)')
hold off

fig = figure; clf

plot(modulo_serie); hold on
grid on
plotlatex(fig, 'Série de Vazões Furnas de Jan/1930 até Dez/1990 sem Sazonalidade', 'Mês', 'Vazão média do reservatório (m³)')
hold off

%----------------------------- HISTOGRAMAS -----------------------------% 

fig = figure; clf

hist(serie_vazoes,20); hold on

grid on
plotlatex(fig, 'Histograma da Série de Vazões Furnas com Sazonalidade', 'Vazão média do reservatório (m³)', 'Frequência (Meses)')
hold off

fig = figure; clf

hist(modulo_serie,20); hold on

grid on
plotlatex(fig, 'Histograma da Série de Vazões Furnas sem Sazonalidade', ' ', 'Frequência (Meses)')
hold off


%------------------------------- FAC e FACP -------------------------------%

tau_max = 25;
n = size(modulo_serie,2);

%--------------------- FAC ---------------------%

fac_serie = myfac3(modulo_serie,tau_max);

%-------------- FACP - YULE-WALKER --------------%

z = fac_serie(1:tau_max+1);
r = z(2:end)';
R = toeplitz(z(1:tau_max));
facp_serie = R\r;

%------------ LIMITES PADRÕES DE ERRO ------------%

stand_err_fac(1:tau_max+1) = 1.967/sqrt(n);
stand_err_facp(1:tau_max) = 1.967/sqrt(n);

fig = figure; clf

bar(fac_serie,'white','LineStyle','-','LineWidth',0.5); hold on
grid on
plot(stand_err_fac,'--b','LineWidth',1);
plot(stand_err_fac*(-1),'--b','LineWidth',1);
plotlatex(fig, 'Funcao de Autocorrelacao', 'tau (lag)', 'FAC')
hold off

fig = figure; clf

bar(facp_serie,'white','LineStyle','-','LineWidth',0.5); hold on
grid on
plot(stand_err_facp,'--b','LineWidth',1);
plot(stand_err_facp*(-1),'--b','LineWidth',1);
plotlatex(fig, 'Funcao de Autocorrelacao Parcial', 'tau (lag)', 'FACP')
hold off

%--------------- ESTIMAÇÃO: YULE-WALKER ---------------%

ordem_max = 3;

for p=1:ordem_max
    Ne = n-p;
    y_real = modulo_serie;
    coef_fac = myfac3(modulo_serie,p);
    par_ar_yule = yulewalker(coef_fac,p);
    
    for i=p+1:n
        y_n = flip(y_real(i-p:i-1));
        y_estimado(i-p) = sum(par_ar_yule'.*y_n);
    end

    erro_aryule = y_real(p+1:end)-y_estimado;
    
    media_erro_aryule(p) = mean(erro_aryule);
    var_erro_aryule(p) = sum(erro_aryule.^2/Ne);
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
    plot(stand_err_fac,'--b','LineWidth',1);
    plot(stand_err_fac*(-1),'--b','LineWidth',1);
    plotlatex(fig, ['Funcao de Autocorrelacao do Residuo - AR(',num2str(p),')'] , 'tau (lag)', 'FAC')
    hold off

    y_estimado = [];
end

%------------ ESTIMAÇÃO: MÍNIMOS QUADRADOS ------------%

for p=1:ordem_max
    Ne = n-p;
    par_ar_ols = ols_est(y_real,p);

    for i=p+1:n
        y_nt = flip(y_real(i-p:i-1));
        y_est(i-p) = sum(par_ar_ols'.*y_nt);
    end
        
    erro_ols = y_real(p+1:end)-y_est;

    media_erro_ols(p) = mean(erro_ols);
    var_erro_ols(p) = sum(erro_ols.^2/Ne);
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
    plot(stand_err_fac,'--b','LineWidth',1);
    plot(stand_err_fac*(-1),'--b','LineWidth',1);
    plotlatex(fig, ['Funcao de Autocorrelacao do Residuo - OLS ordem ',num2str(p),''] , 'tau (lag)', 'FAC')
    hold off
    
    teste = y_est;

    y_est = [];

end

%------------ CRITÉRIOS DE INFORMAÇÃO ------------%

for p=1:ordem_max

    Ne = n-p;

    %--------------- YULE-WALKER ---------------%

    FPE_yule(p) = Ne*log(var_erro_aryule(p))+Ne*log((Ne+p)/(Ne-p));
    AIC_yule(p) = Ne*log(var_erro_aryule(p))+2*p;
    BIC_yule(p) = Ne*log(var_erro_aryule(p))+p*log(Ne);
    MDL_yule(p) = Ne*log(var_erro_aryule(p))+(p/2)*log(Ne);

    %------------ MÍNIMOS QUADRADOS -------------%

    FPE_ols(p) = Ne*log(var_erro_ols(p))+Ne*log((Ne+p)/(Ne-p));
    AIC_ols(p) = Ne*log(var_erro_ols(p))+2*p;
    BIC_ols(p) = Ne*log(var_erro_ols(p))+p*log(Ne);
    MDL_ols(p) = Ne*log(var_erro_ols(p))+(p/2)*log(Ne);

end

fig = figure; clf

plot(FPE_yule,'--r','LineWidth',2); hold on
plot(AIC_yule,'-y','LineWidth',1);
plot(BIC_yule,'-g','LineWidth',1);
plot(MDL_yule,'-c','LineWidth',1);
grid on
plotlatex2(fig, 'Criterios de Informacao - Yule-Walker', 'Ordem de p', ' ', 'FPE','AIC','BIC','MDL')
hold off

fig = figure; clf

plot(FPE_ols,'--r','LineWidth',2); hold on
plot(AIC_ols,'-y','LineWidth',1);
plot(BIC_ols,'-g','LineWidth',1);
plot(MDL_ols,'-c','LineWidth',1);
grid on
plotlatex2(fig, 'Criterios de Informacao - OLS', 'Ordem de p', ' ', 'FPE','AIC','BIC','MDL')
hold off