clear all
close all
% modelname = extractfield(models, 'name')';
% sizeMat = zeros(numel(models), 2);
%home = '/home/nsedagha/Dropbox/';
home = '/Users/nafiseh/Dropbox/';

models = {'BIOMD0000000034', 'BIOMD0000000042','BIOMD0000000048','BIOMD0000000089','BIOMD0000000093','BIOMD0000000094',...
    'BIOMD0000000106', 'BIOMD0000000107','BIOMD0000000108','BIOMD0000000110',...
    'BIOMD0000000162', 'BIOMD0000000163', 'BIOMD0000000165', 'BIOMD0000000166',...
    'BIOMD0000000169', 'BIOMD0000000170','BIOMD0000000171','BIOMD0000000173', 'BIOMD0000000228'};%'BIOMD0000000011',



for nn=1:14%numel(models)
    
    model = models{nn};
    name = strrep(models(nn), '_', '-');
    
    disp(strcat('nn is ', num2str(nn), ' out of ', num2str(numel(models))))
    
    
    EFM_file = strcat(home, 'MONET_MetabolicNetworks/Data/RealMetabolicNetworks/',model,'_binEFM.mat');
    StoichFile = strcat(home, 'MONET_MetabolicNetworks/Data/RealMetabolicNetworks/', model, '.mat');
    
    load(StoichFile)
    n_metab = size(Stoich, 1);
    
    % EFM
    load(EFM_file)
    
    mat = full(sparseEFM);
    mat = mat'; %
    sizeMat(nn,:) = size(mat);
    n_efm = size(mat,1);
    n_reactions_b4Preprocessing = size(mat, 2);
    disp(strcat('number of EFMs is ', num2str(n_efm)));
    %         if (n_efm > 5 && n_efm < 30)
    [MCS_x_Reactions, totaliter, maxiter, berge_cpu]= berge(mat);
    MCS_afterPostprocessing = size(MCS_x_Reactions, 1);
    disp(strcat('number of MCS after post-procesing for model', model, ' is ', num2str(MCS_afterPostprocessing)));
    
    p_mat = Preprocessing( mat );
    EFM_x_Reactions = Irredundant(p_mat);
    % Berge input is mat = [EFM x Reactions]
    [MCS_x_Reactions, totaliter, maxiter, berge_cpu]= berge(EFM_x_Reactions);
    % Berge output is mat = [MCSs x Reactions]
    
%     sum(EFM_x_Reactions,1)
    
    x = 1:size(p_mat,2);
    EFMs = sum(EFM_x_Reactions,1);
    MCSs = sum(MCS_x_Reactions,1);
    figure;
    plot(x, EFMs,'-o', 'LineWidth', 1.3);
    title(model)
    xlabel('Reactions', 'FontSize',14); ylabel('Frequency', 'FontSize',14);
    hold on;
    plot(x, MCSs,'-o', 'LineWidth', 1.3);
    ylim([min([EFMs, MCSs])-1, max([EFMs, MCSs])+1])
    legend('EFMs', 'MCSs', 'FontSize',14);
    
    print(strcat(home, 'MONET_MetabolicNetworks/Figures/', model, '_ReactionsFreq.pdf'),'-dpdf')
    hold off;
    
end


