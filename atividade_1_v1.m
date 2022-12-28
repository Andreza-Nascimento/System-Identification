%% Item 1

X = load('furnas.dat')

%% Item 2
%i = randi([1,60],5,1);

% create new figure
fig = figure; clf

t = 1:1:12;
for n=1:5
    h = plot(t, X(i(n,1),:)); hold on
    grid on
end
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

%% Item 3
for j=1:12
    media(1,j) = mean(X(:,j));
    desvio(1,j) = std(X(:,j));
end

%% Item 4
% figure;
 plot(t, media(1,:),'-b');
 hold on
 plot(t, media(1,:)+desvio(1,:),'-r');
 plot(t, media(1,:)-desvio(1,:),'-r');
 hold off

% correl1 = corrcoef(X(:,1),X(:,4));
% correl2 = corrcoef(X(:,5),X(:,6));
% correl3 = corrcoef(X(:,7),X(:,9));
% correl4 = corrcoef(X(:,11),X(:,12));

 correl1 = corr(X(:,1),X(:,4));
 correl2 = corr(X(:,5),X(:,6));
 correl3 = corr(X(:,7),X(:,9));
 correl4 = corr(X(:,11),X(:,12));

