% DISCIPLINA: TIP7044 - ESTIMAÇÃO E IDENTIFICAÇÃO DE SISTEMAS (2022.2 - T01)
% PROFESSOR: GUILHERME DE ALENCAR BARRETO
% ALUNO(A): ANDREZA COSTA NASCIMENTO
% MATRÍCULA: 544957

% 1º TRABALHO COMPUTACIONAL

%% Parte 1  - Método Alternativo

clc;clear;

serie_vazoes = load('furnas.dat');
m_serie = mean(serie_vazoes);
dp_serie = std(serie_vazoes);
modulo_serie = reshape((serie_vazoes./m_serie)', 1,[]);
serie_vazoes = reshape((serie_vazoes)', 1,[]);

fig = figure; clf

h = plot(serie_vazoes); hold on

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
title('Série de vazões Furnas de Jan/1930 até Dez/1990 com Sazonalidade')
xlabel('Mês')
ylabel('Vazão média do reservatório (m³)')
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

fig = figure; clf

h = plot(modulo_serie); hold on

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
title('Série de vazões Furnas de Jan/1930 até Dez/1990 sem Sazonalidade')
xlabel('Mês')
ylabel('Vazão média do reservatório (m³)')
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

%HISTOGRAMA

fig = figure; clf

h = histogram(modulo_serie); hold on

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
title('Histograma da Série de Vazões Furnas sem Sazonalidade')
%xlabel('Vazão média do reservatório (m³)')
ylabel('Frequência (Meses)')
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
