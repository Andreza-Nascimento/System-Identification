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

% define figure properties
opts.Colors     = get(groot,'defaultAxesColorOrder');
opts.saveFolder = 'img/';
opts.width      = 20;
opts.height     = 10;
opts.fontType   = 'Times';
opts.fontSize   = 24.6;

% add axis labes and legend
axis tight
title('Série de Vazões Furnas de Jan/1930 até Dez/1990 com Sazonalidade')
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

ln_serie = log(serie_vazoes);
m_serie = mean(ln_serie);
dp_serie = std(ln_serie);

modulo_serie = reshape(((ln_serie-m_serie)./dp_serie)', 1,[]);
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
title('Série de Vazões Furnas de Jan/1930 até Dez/1990 com Sazonalidade')
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
title('Série de Vazões Furnas de Jan/1930 até Dez/1990 sem Sazonalidade')
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

% HISTOGRAMAS

fig = figure; clf

h = histogram(serie_vazoes,21); hold on

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
title('Histograma da Série de Vazões Furnas com Sazonalidade')
xlabel('Vazão média do reservatório (m³)')
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

fig = figure; clf

h = histogram(modulo_serie,20); hold on

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


%------------------------------- FAC e FACP -------------------------------%

tau_max = 25;
fac_serie = myfac(modulo_serie,tau_max);
z = fac_serie(1:tau_max+1);
r = z(2:end)';
R = toeplitz(z(1:tau_max));
facp_serie = R\r;

for i=1:tau_max+1
    lag(i) = i-1;
end

fig = figure; clf

h = stem(fac_serie,'-r','LineWidth',1.5); hold on

grid on
%h = line(lag,stand_err,'color','blue','LineStyle','--')
%h = line(lag,stand_err*(-1),'color','blue','LineStyle','--')

% define figure properties
opts.Colors     = set(groot,'defaultAxesColorOrder');
opts.saveFolder = 'img/';
opts.width      = 20;
opts.height     = 10;
opts.fontType   = 'Times';
opts.fontSize   = 24.6;

% add axis labes and legend
axis tight
title('Funcao de Autocorrelacao')
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

fig = figure; clf

h = stem(facp_serie,'-r','LineWidth',1.5); hold on

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
title('Funcao de Autocorrelacao Parcial')
xlabel('tau (lag)')
ylabel('FACP')
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