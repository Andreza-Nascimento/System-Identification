% DISCIPLINA: TIP7044 - ESTIMAÇÃO E IDENTIFICAÇÃO DE SISTEMAS (2022.2 - T01)
% PROFESSOR: GUILHERME DE ALENCAR BARRETO
% ALUNO(A): ANDREZA COSTA NASCIMENTO
% MATRÍCULA: 544957

% 1º EXERCÍCIO COMPUTACIONAL: MÉDIA, VARIÂNCIA E AUTOCORRELAÇÃO

%% Item 1

X = load('furnas.dat')

%% Item 2
%i = randi([1,60],5,1);

clc; clear;
load('atividade_1');

% create new figure
fig = figure; clf

t = 1:1:12;
for n=1:5
    h = plot(t, X(i(n,1),:)); hold on
end
grid on

% define figure properties
opts.Colors     = get(groot,'defaultAxesColorOrder');
opts.saveFolder = 'img/';
opts.width      = 20;
opts.height     = 10;
opts.fontType   = 'Times';
opts.fontSize   = 24.6;

% add axis labes and legend
axis tight
xlabel('Mês')
ylabel('Vazão média do reservatório (m³)')
legend('1960','1946','1970','1972','1975')

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

%% Item 3 - Método 1

clc; clear;
load('atividade_1');

for j=1:12
    media(1,j) = mean(X(:,j));
    desvio(1,j) = std(X(:,j));
end

%% Item 3 - Método 2

clc; clear;
load('atividade_1');

sz_anos = size(X,1);
for j=1:12
    media_meses(1,j)=sum(X(:,j))/sz_anos;
    var_meses(1,j) = sum((X(:,j)-media_meses(1,j)).^2)/(sz_anos - 1);
    devio_meses(1,j) = sqrt(var_meses(1,j));
end

%% Item 4

%clc; clear;
%load('atividade_1');

% create new figure
fig = figure; clf

t = 1:1:12;
h = plot(t, media(1,:),'-r'); hold on
h = plot(t, media(1,:)+desvio(1,:),'-b');
h = plot(t, media(1,:)-desvio(1,:),'-b');
grid on

% define figure properties
%opts.Colors     = get(groot,'b','r','r');
opts.saveFolder = 'img/';
opts.width      = 20;
opts.height     = 10;
opts.fontType   = 'Times';
opts.fontSize   = 24.6;

% add axis labes and legend
axis tight
title('Curva Média e Curvas de ± 1 Desvio-Padrão');
xlabel('Mês')
%ylabel('')
legend('μ','μ ± σ')

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

%% Item 5 - Método 1

correl1 = corr(X(:,1),X(:,4));
correl2 = corr(X(:,5),X(:,6));
correl3 = corr(X(:,7),X(:,9));
correl4 = corr(X(:,11),X(:,12));

%% Item 5 - Método 2

%clc; clear;
%load('atividade_1');

sz_anos = size(X,1);

desvio_jan_abr = sum((X(:,1)-media(1,1)).*(X(:,4)-media(1,4)))/sz_anos;
desvio_mai_jun = sum((X(:,5)-media(1,5)).*(X(:,6)-media(1,6)))/sz_anos;
desvio_jul_set = sum((X(:,7)-media(1,7)).*(X(:,9)-media(1,9)))/sz_anos;
desvio_nov_dez = sum((X(:,11)-media(1,11)).*(X(:,12)-media(1,12)))/sz_anos;

correl_jan_abr = desvio_jan_abr/(desvio(1,1)*desvio(1,4));
correl_mai_jun = desvio_mai_jun/(desvio(1,5)*desvio(1,6));
correl_jul_set = desvio_jul_set/(desvio(1,7)*desvio(1,9));
correl_nov_dez = desvio_nov_dez/(desvio(1,11)*desvio(1,12));