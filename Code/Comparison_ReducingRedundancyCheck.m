% Comparing FK with FKR
% Written by Nafiseh Sedaghat
% August 6, 2020
clear all
global redundancy_counter depth splitting comparison_counter

models = {'BIOMD0000000034', 'BIOMD0000000042','BIOMD0000000048','BIOMD0000000089','BIOMD0000000093','BIOMD0000000094',...
    'BIOMD0000000106', 'BIOMD0000000107','BIOMD0000000108','BIOMD0000000110',...
    'BIOMD0000000162', 'BIOMD0000000163', 'BIOMD0000000165', 'BIOMD0000000166',...
    'BIOMD0000000169', 'BIOMD0000000170','BIOMD0000000171','BIOMD0000000173', 'BIOMD0000000228'};%'BIOMD0000000011',
redundancy = zeros(numel(models),2);
comparisons = zeros(numel(models),2);
nn=1;
for nn=1:numel(models)
    model = models{nn};
    disp(strcat('nn is ', num2str(nn), ' out of ', num2str(numel(models))))
    
    InputName = strcat('/Users/nafiseh/Dropbox/MONET_MetabolicNetworks/Data/RealMetabolicNetworks/',model, '_binEFM.mat');
    mat = [];    
    load(InputName)
    
    mat = 1*(full(sparseEFM)~=0);
    mat=mat'; %
    
    mat = Preprocessing( mat );
    mat = Irredundant(mat);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Berge input is mat = [EFM x Reactions]
    %     [berge_cnf, totaliter, maxiter, berge_cpu]= berge(mat);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    redundancy_counter = 0;
    depth = zeros(20000, 1);
    splitting = zeros(20000, 1);
    comparison_counter = 0;
    rng(6)
    [cnf, cput, cnf_len]= FK_Dualization( mat, 1);
    redundancy(nn,1) = redundancy_counter;
    comparisons(nn,1) = comparison_counter;
    %     calls(nn,1) = call_counter;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    redundancy_counter = 0;
    depth = zeros(20000, 1);
    splitting = zeros(20000, 1);
    call_counter = 0;
    comparison_counter = 0;
    rng(6)
    [FKR_cnf, FKR_cpu, FKR_len]= FK_Dualization_R( mat, 1 );
    redundancy(nn,2) = redundancy_counter;
    comparisons(nn,2) = comparison_counter;
    %     calls(nn,2) = call_counter;
    
end
Red_tab = array2table(redundancy);
Comp_tab = array2table(comparisons);

tab = [models', Red_tab, Comp_tab];
tab.Properties.VariableNames = {'Model', 'Redundancy_FK', 'Redundancy_FKR', 'Comparisons_FK', 'Comparisons_FKR'};
writetable(tab,'/Users/nafiseh/Dropbox/MONET_MetabolicNetworks/Results/redundancy_Comp_chk.csv')
