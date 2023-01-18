% DISCIPLINA: TIP7044 - ESTIMAÇÃO E IDENTIFICAÇÃO DE SISTEMAS (2022.2 - T01)
% PROFESSOR: GUILHERME DE ALENCAR BARRETO
% ALUNO(A): ANDREZA COSTA NASCIMENTO
% MATRÍCULA: 544957

% 3º TRABALHO COMPUTACIONAL

%%Item 1.1

% Parametros da planta: M=1kg, K=20N/m, F=1N, b=10N.s/m

clc; clear all; close all;

sig2 = 0.01;
N = 2000;
tau_max = 20;

M = 1;
k = 20;
b = 10;
ordem = 2;

w_n = sqrt(k);
amort = b/(2*w_n);
K = 1/k;

Ts=0.001;  % Taxa de amostragem
Tsim=2;   % Tempo de simulacao
t=0:Ts:Tsim;  % Instantes de amostragem
L=length(t);

%------------ DISCRETIZAÇÃO DA PLANTA ------------%
h = 0.01; % discretization step (Euler method)

y=zeros(1,ordem);

aux=1+10*h+20*h*h;

for k=ordem+1:L
    u(k)=sqrt(sig2)*randn;
    y(k) = (2+10*h)*y(k-1) - y(k-2) + h*h*u(k);
    y(k) = y(k)/aux;
end

fig = figure; clf

plot(u); hold on
grid on
plotlatex(fig, 'Sinal de Entrada u(k)', 'k', ' ')
hold off

fig = figure; clf

plot(y); hold on
grid on
plotlatex(fig, 'Sinal de Saída y(k)', 'k', ' ')
hold off

%------------ ESTIMAÇÃO: MÍNIMOS QUADRADOS ------------%

n=2; m=0;  

p=[]; X=[];
N=length(y);
for k=max(n,m)+1:N-100
  p=[p; y(k)];
  %X=[X; y(k-1) u(k-1)]; % ARX(1,1)
  X=[X; y(k-1) y(k-2)]; % ARX(2,1) u(k-1)
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

%------------ ANÁLISE DOS RESÍDUOS ------------%

fcac_residuo_ols = myfac3(residuo_ols,tau_max);
limconf_lms = (2/sqrt(L))*ones(1,tau_max);
    
fig = figure; clf
    
stem(fcac_residuo_ols, '-r','LineWidth',0.5); hold on
plot(limconf_lms,'--b','LineWidth',1);
plot(limconf_lms*(-1),'--b','LineWidth',1);
grid on
plotlatex(fig, 'Funcao de Autocorrelacao', 'tau (lag)', 'FAC');
hold off

fig = figure; clf
 
histfit(residuo_ols,20); hold on
grid on
plotlatex(fig, 'Histograma dos Resíduos - Algoritmo LMS', ' ', '  ');
hold off

%------------------------ CONTROLE PID ------------------------%

%------------ VALORES INICIAIS ------------%

Kp=350;  % Ganho proporcional
Ki=250;   % Ganho integral
Kd=200;    % Ganho derivativo

par = Phihat';
a_0 = 1;
b_0 = 1;

den_est = [par a_0];
num_est = [b_0];

G_est = tf(num_est,den_est);
[Y_est T_est]=myPID(Kp,Ki,Kd,G_est,t);

nump=[1]; denp=[1 10 20];
Gp=tf(nump,denp); % Plant transfer function

[Y1 T1]=myPID(Kp,Ki,Kd,Gp,t);   % Resposta malha fechada

fig = figure; clf
 
plot(T_est, Y_est,'-r', 'LineWidth',1.5); hold on
grid on
plotlatex(fig, 'Resposta em malha fechada', 'tempo (segundos)', 'Amplitude degrau');
hold off

fig = figure; clf
 
plot(T1, Y1,'-r', 'LineWidth',1.5); hold on
grid on
plotlatex(fig, 'Resposta em malha fechada', 'tempo (segundos)', 'Amplitude degrau');
hold off

