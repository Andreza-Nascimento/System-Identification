% DISCIPLINA: TIP7044 - ESTIMAÇÃO E IDENTIFICAÇÃO DE SISTEMAS (2022.2 - T01)
% PROFESSOR: GUILHERME DE ALENCAR BARRETO
% ALUNO(A): ANDREZA COSTA NASCIMENTO
% MATRÍCULA: 544957

% 1º TRABALHO COMPUTACIONAL

%% Parte 1 - Normalização (Método Artigo)

clc;clear; close all;

serie_vazoes = load('furnas.dat');

fig = figure; clf

h = plot(serie_vazoes'); hold on
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

h = plot(serie_vazoes); hold on
grid on
plotlatex(fig, 'Série de Vazões Furnas de Jan/1930 até Dez/1990 com Sazonalidade', 'Mês', 'Vazão média do reservatório (m³)')
hold off

fig = figure; clf

h = plot(modulo_serie); hold on
grid on
plotlatex(fig, 'Série de Vazões Furnas de Jan/1930 até Dez/1990 sem Sazonalidade', 'Mês', 'Vazão média do reservatório (m³)')
hold off

%----------------------------- HISTOGRAMAS -----------------------------% 

fig = figure; clf

h = histogram(serie_vazoes,24); hold on

grid on
plotlatex(fig, 'Histograma da Série de Vazões Furnas com Sazonalidade', 'Vazão média do reservatório (m³)', 'Frequência (Meses)')
hold off

fig = figure; clf

h = histogram(modulo_serie,20); hold on

grid on
plotlatex(fig, 'Histograma da Série de Vazões Furnas sem Sazonalidade', ' ', 'Frequência (Meses)')
hold off


%------------------------------- FAC e FACP -------------------------------%

tau_max = 25;
n = size(modulo_serie,2);

%--------------------- FAC ---------------------%

fac_serie = myfac(modulo_serie,tau_max);

%-------------- FACP - YULE-WALKER --------------%

z = fac_serie(1:tau_max+1);
r = z(2:end)';
R = toeplitz(z(1:tau_max));
facp_serie = R\r;

%------------ LIMITES PADRÕES DE ERRO ------------%

stand_err_fac(1:tau_max+1) = 1.967/sqrt(n);
stand_err_facp(1:tau_max) = 1.967/sqrt(n);

fig = figure; clf

h = bar(fac_serie,'white','LineStyle','-','LineWidth',0.5); hold on
grid on
h = plot(stand_err_fac,'--b','LineWidth',1);
h = plot(stand_err_fac*(-1),'--b','LineWidth',1);
plotlatex(fig, 'Funcao de Autocorrelacao', 'tau (lag)', 'FAC')
hold off

fig = figure; clf

h = bar(facp_serie,'white','LineStyle','-','LineWidth',0.5); hold on
grid on
h = plot(stand_err_facp,'--b','LineWidth',1);
h = plot(stand_err_facp*(-1),'--b','LineWidth',1);
plotlatex(fig, 'Funcao de Autocorrelacao Parcial', 'tau (lag)', 'FACP')
hold off

%--------------- ESTIMAÇÃO: YULE-WALKER ---------------%

for p=1:3
    y_real = modulo_serie;
    coef_fac = myfac(modulo_serie,p);
    par_ar_yule = yulewalker(coef_fac,p);
    for i=p+1:n
        y_estimado(i) = sum(par_ar_yule'.*y_real(i-p:i-1));
    end
    erro_aryule = y_real(p+1:end)-y_estimado(p+1:end);
    media_erro_aryule(i) = mean(erro_aryule);
    var_erro_aryule(i) = var(erro_aryule);
    dp_erro_aryule(i) = std(erro_aryule);
    
    fig = figure; clf
    
    h = histfit(erro_aryule,20)
    plotlatex(fig, ['Histograma do Resíduo - AR(',num2str(p),')'], ' ', '  ');
end

%------------ ESTIMAÇÃO: MÍNIMOS QUADRADOS ------------%


