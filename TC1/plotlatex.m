function plotlatex(fig, titulo, textxlab, textylab)

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
    title(titulo)
    xlabel(textxlab)
    ylabel(textylab)
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
end