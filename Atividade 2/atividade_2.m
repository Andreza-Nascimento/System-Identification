% DISCIPLINA: TIP7044 - ESTIMAÇÃO E IDENTIFICAÇÃO DE SISTEMAS (2022.2 - T01)
% PROFESSOR: GUILHERME DE ALENCAR BARRETO
% ALUNO(A): ANDREZA COSTA NASCIMENTO
% MATRÍCULA: 544957

% 2º EXERCÍCIO COMPUTACIONAL: ESTACIONARIEDADE E ERGODICIDADE

%% Item 1
clc;clear;

N = 5000;
pot_awgn = 0.1;
x = sqrt(pot_awgn)*randn(N,1);
m_x = mean(x);
var_x = var(x);

tau_max = 50;
[R_ruido lag] = xcorr(x-m_x,tau_max,'unbiased');

% create new figure
fig = figure; clf

h = stem(lag,R_ruido,'-r','LineWidth',1.5); hold on

% define figure properties
opts.Colors     = set(groot,'defaultAxesColorOrder');
opts.saveFolder = 'img/';
opts.width      = 20;
opts.height     = 10;
opts.fontType   = 'Times';
opts.fontSize   = 24.6;

% add axis labes and legend
axis tight
title('Funcao de Autocorrelacao: Processo AWGN')
xlabel('tau (lag)')
ylabel('FAC')
%legend('1960','1946','1970','1972','1975')

% scaling
fig.Units               = 'centimeters';
fig.Position(3)         = opts.width;
fig.Position(4)         = opts.height;

% set text properties
set(fig.Children, ...
    'FontName',     'Times', ...
    'FontSize',     23);

% remove unnecessary white space
set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))
hold off

%% Item 2

clc; clear;

N = 5000;
pot_awgn = 0.1;
a_0 = 2;
a_1 = 0.85;
tau_max = 20;

m_x_teo = a_0/(1-a_1);
var_x_teo = pot_awgn/(1-a_1^2);
SNR_teo = var_x_teo/pot_awgn;
SNR_dB_teo = 10*log10(SNR_teo);

for t=1:1:tau_max+1
    lag(1,t) = t-1; 
    R_x_teo(t) = var_x_teo*a_1^(abs(t));
end
R_x_teo=R_x_teo(:);

% create new figure
fig = figure; clf

h = stem(lag,R_x_teo,'-r','LineWidth',1.5); hold on

% define figure properties
opts.Colors     = set(groot,'defaultAxesColorOrder');
opts.saveFolder = 'img/';
opts.width      = 20;
opts.height     = 10;
opts.fontType   = 'Times';
opts.fontSize   = 24.6;

% add axis labes and legend
axis tight
title('Funcao de Autocorrelacao: Processo AR(1) - Teórico')
xlabel('tau (lag)')
ylabel('FAC')
%legend('1960','1946','1970','1972','1975')

% scaling
fig.Units               = 'centimeters';
fig.Position(3)         = opts.width;
fig.Position(4)         = opts.height;

% set text properties
set(fig.Children, ...
    'FontName',     'Times', ...
    'FontSize',     23);

% remove unnecessary white space
set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))
hold off

x(1)=sqrt(pot_awgn)*randn;

for t=2:N   %2*N
    x(t)=a_0+a_1*x(t-1)+sqrt(pot_awgn)*randn;
end
x=x(:);
%x=x(N+1:end);

m_x = mean(x);
var_x = var(x);
SNR = var_x/pot_awgn;
SNR_dB = 10*log10(SNR_dB_teo);

[R_x lag] = xcorr(x-m_x,tau_max,'unbiased');
I=find(lag==0);
lag=lag(I:end);

% create new figure
fig = figure; clf

h = stem(lag,R_x(I:end),'-r','LineWidth',1.5); hold on

% define figure properties
opts.Colors     = set(groot,'defaultAxesColorOrder');
opts.saveFolder = 'img/';
opts.width      = 20;
opts.height     = 10;
opts.fontType   = 'Times';
opts.fontSize   = 24.6;

% add axis labes and legend
axis tight
title('Funcao de Autocorrelacao: Processo AR(1)')
xlabel('tau (lag)')
ylabel('FAC')
%legend('1960','1946','1970','1972','1975')

% scaling
fig.Units               = 'centimeters';
fig.Position(3)         = opts.width;
fig.Position(4)         = opts.height;

% set text properties
set(fig.Children, ...
    'FontName',     'Times', ...
    'FontSize',     23);

% remove unnecessary white space
set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))
hold off

%% Item 3 - Meu método

clc;clear;

N = 5000;
pot_awgn = 0.1;
a_0 = 2;
a_1 = 0.85;
tau_max = 20;

x(1)=sqrt(pot_awgn)*randn;

for t=2:2*N   %para eliminar o efeito da condição inicial
    x(t)=a_0+a_1*x(t-1)+sqrt(pot_awgn)*randn;
end
x=x(:);
x=x(N+1:end);   %para eliminar o efeito da condição inicial

K = 4;
N_sub = 1250;
N_atual = 0;

for i=1:K
    sub_x(:,i) = x(N_atual+1:N_atual+N_sub);
    N_atual = N_atual + N_sub;
end

Media_barra = 0;
Var_barra = 0;

for i=1:K
    m_sub(i) = sum(sub_x(:,i))/N_sub;
    var_sub(i) = sum((sub_x(:,i)-m_sub(i)).^2)/N_sub;
    Media_barra = Media_barra+m_sub(i);
    Var_barra = Var_barra+var_sub(i);
end

Media_barra = Media_barra/K;
Var_barra = Var_barra/K;

X_barra = sum(x)/(N_sub*K);
VAR_barra = sum((x-X_barra).^2)/(N_sub*K);
