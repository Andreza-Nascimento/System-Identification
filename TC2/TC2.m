% DISCIPLINA: TIP7044 - ESTIMAÇÃO E IDENTIFICAÇÃO DE SISTEMAS (2022.2 - T01)
% PROFESSOR: GUILHERME DE ALENCAR BARRETO
% ALUNO(A): ANDREZA COSTA NASCIMENTO
% MATRÍCULA: 544957

% 2º TRABALHO COMPUTACIONAL

%% Parte 1.1

% Modelo ARX(n,m) -- n->saída ; m->entrada

clc; clear all; close all;

m_in = 1;
n_out = 2;
Nu = 500;
sig2=0.01;

u = (sign(randn(2*Nu,1))+1)/2;

y=zeros(1,Nu);

for k=n_out+1:2*Nu
  y(k) = 0.4*y(k-1)-0.6*y(k-2)+2*u(k-1)+sqrt(sig2)*randn;
end

u = u(Nu+1:end);
y = y(Nu+1:end)';

% fig = figure; clf
% 
% plot(u); hold on
% grid on
% plotlatex(fig, 'Sinal de Entrada u(k)', 'k', ' ')
% hold off
% 
% fig = figure; clf
% 
% plot(y); hold on
% grid on
% plotlatex(fig, 'Sinal de Saída y(k)', 'k', ' ')
% hold off

%------------ ESTIMAÇÃO: MÍNIMOS QUADRADOS ------------%

n=2; m=1;  

p=[]; X=[];
N=length(y);
for k=max(n,m)+1:N-100
  p=[p; y(k)];
  %X=[X; y(k-1) u(k-1)]; % ARX(1,1)
  X=[X; y(k-1) y(k-2) u(k-1)]; % ARX(2,1)
  %X=[X; y(k-1) y(k-2) u(k-1) u(k-2)]; % ARX(2,2)
  %X=[X; y(k-1) y(k-2) y(k-3) u(k-1)]; % ARX(3,1)
  %X=[X; y(k-1) y(k-2) y(k-3) u(k-1) u(k-2)]; % ARX(3,2)
end

Phihat = (X'*X)\(X'*p);

y_est = X*Phihat;
residuo_ols = p - y_est;
Ne = size(residuo_ols,1);
var_residuo_ols = sum(residuo_ols.^2/Ne);
        
%------------ CRITÉRIOS DE INFORMAÇÃO ------------%

p_max = max(n,m);

AIC_ols = Ne*log(var_residuo_ols)+2*p_max;
BIC_ols = Ne*log(var_residuo_ols)+p_max*log(Ne);
MDL_ols = Ne*log(var_residuo_ols)+(p_max/2)*log(Ne);


%------------ RMSE E ERRO DE PREDIÇÃO ------------%

%--------------- ERRO PREDIÇÃO ---------------%

p_pred=[]; X_pred=[];
for k=N-100+1:N
  p_pred=[p_pred; y(k)];  
  %X_pred=[X_pred; y(k-1) u(k-1)]; % ARX(1,1)
  X_pred=[X_pred; y(k-1) y(k-2) u(k-1)]; % ARX(2,1)
  %X_pred=[X_pred; y(k-1) y(k-2) u(k-1) u(k-2)]; % ARX(2,2)
  %X_pred=[X_pred; y(k-1) y(k-2) y(k-3) u(k-1)]; % ARX(3,1)
  %X_pred=[X_pred; y(k-1) y(k-2) y(k-3) u(k-1) u(k-2)]; % ARX(3,2)
end

y_pred=X_pred*Phihat; 
erro_pred=p_pred-y_pred;
Ne_pred = size(erro_pred,1);
var_erro_pred = sum(erro_pred.^2/Ne_pred);

%--------------- RMSE ---------------%

RMSE_erro_pred = sqrt(var_erro_pred);
RMSE_residuo_OLS = sqrt(var_residuo_ols);

tau_max = 20;

fcac_residuo_ols = myfac3(residuo_ols,tau_max);
limconf = (2/sqrt(N))*ones(1,tau_max);
    
fig = figure; clf
    
stem(fcac_residuo_ols, '-r','LineWidth',0.5); hold on
plot(limconf,'--b','LineWidth',1);
plot(limconf*(-1),'--b','LineWidth',1);
grid on
plotlatex(fig, 'Funcao de Autocorrelacao', 'tau (lag)', 'FAC');
hold off

fig = figure; clf
 
histfit(residuo_ols,20); hold on
grid on
plotlatex(fig, ['Histograma do Resíduo - ARX (',num2str(n),',',num2str(m),')'], ' ', '  ');
hold off

%------------ ESTIMAÇÃO: MÍNIMOS QUADRADOS - LMS ------------%

w=zeros(n+m,1);
lr=0.1;  
p_lms=[]; X_lms=[];
for k=max(n,m)+1:N-100
    p_lms=[p_lms; y(k)];
    x_lms=[y(k-1); y(k-2); u(k-1)];
    X_lms=[X_lms; x_lms'];
    yhat3=w'*x_lms;
    erro_lms=y(k)-yhat3;
    w=w+lr*erro_lms*x_lms;
end

y_est_lms = X_lms*w;
residuo_lms = p_lms - y_est_lms;

Ne_lms = size(residuo_lms,1);
var_residuo_lms = sum(residuo_lms.^2/Ne_lms);

%------------ RMSE E ERRO DE PREDIÇÃO - LMS ------------%

%--------------- ERRO PREDIÇÃO - LMS ---------------%

p_pred_lms=[]; X_pred_lms=[];
for k=N-100+1:N
  p_pred_lms=[p_pred_lms; y(k)];  
  X_pred_lms=[X_pred_lms; y(k-1) y(k-2) u(k-1)]; % ARX(2,1)
end

y_pred_lms=X_pred_lms*w; 
erro_pred_lms=p_pred_lms-y_pred_lms;
Ne_pred_lms = size(erro_pred_lms,1);
var_erro_pred_lms = sum(erro_pred_lms.^2/Ne_pred_lms);

%--------------- RMSE - LMS ---------------%

RMSE_erro_pred_lms = sqrt(var_erro_pred_lms);
RMSE_residuo_LMS = sqrt(var_residuo_lms);


fcac_residuo_lms = myfac3(residuo_lms,tau_max);
limconf_lms = (2/sqrt(N))*ones(1,tau_max);
    
fig = figure; clf
    
stem(fcac_residuo_lms, '-r','LineWidth',0.5); hold on
plot(limconf_lms,'--b','LineWidth',1);
plot(limconf_lms*(-1),'--b','LineWidth',1);
grid on
plotlatex(fig, 'Funcao de Autocorrelacao', 'tau (lag)', 'FAC');
hold off

fig = figure; clf
 
histfit(residuo_lms); hold on
grid on
plotlatex(fig, ['Histograma dos Resíduos - Algoritmo LMS'], ' ', '  ');
hold off