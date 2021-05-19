
clear all
clc
for nn = 52:75
    
    model = strcat('BIOMD00000001', num2str(nn));
    home = '/home/nsedagha/Dropbox/';
    % home = '/Users/nafiseh/Dropbox/';
    
    % home = 'C:/Users/sedaghat/Dropbox (Personal)/';
    % m1 = sbmlimport(strcat('C:/Users/sedaghat/Dropbox (Personal)/MONET_MetabolicNetworks/Data/RealMetabolicNetworks/', model,'.xml'));
    m1 = sbmlimport(strcat(home,'MONET_MetabolicNetworks/Data/RealMetabolicNetworks/', model,'.xml'));
    
    % model = 'CA_breast_cancer';
    % % HT_breast_glandular_cells
    % m1 = sbmlimport(strcat(home,'ContextSpecfic_MetabolicNetworks/Softwares/corda_library_sbml/', model,'.xml'));
    
    
    [M,objSpecies,objReactions] = getstoichmatrix(m1);
    Stoich = full(M);
    reversibility = 1*cell2mat(get(get (m1, 'Reactions'),'Reversible'));
    
    save(strcat(home, 'MONET_MetabolicNetworks/Data/RealMetabolicNetworks/', model, '.mat'), 'Stoich', 'reversibility')
    
    load(strcat(home, 'MONET_MetabolicNetworks/Data/RealMetabolicNetworks/', model, '.mat'))
    stoich = Stoich; reversibilities = reversibility;
    
    addpath('~/Dropbox/MONET_MetabolicNetworks/Code/Other_codes/FluxModeCalculator');
    load(strcat(home, 'MONET_MetabolicNetworks/Data/RealMetabolicNetworks/', model, '.mat'))
    stoich = Stoich; reversibilities = reversibility;
    % calculate binary EFMs
    [efm_bin,S_unc,id_unc,T,stats]= calculate_flux_modes(stoich, reversibilities);
    sparseEFM=sparse(double(efm_bin));
    data_path= strcat(home, 'MONET_MetabolicNetworks/Data/RealMetabolicNetworks/');
    save(strcat(data_path, model, '_binEFM.mat'), 'sparseEFM', 'S_unc', 'id_unc', 'T', 'stats');
    
end
error('finished!!')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('C:\Users\sedaghat\Dropbox (Personal)\MONET_MetabolicNetworks\Code\Other codes\efmtool');

% calculate binary EFMs

%This path is required for EFMTool

rand('seed', 14);
shuffledstoich = stoich(randperm(size(stoich,1)),:);

mnet = CalculateFluxModes(shuffledstoich, reversibilities);
efm_bin = sparse(getfield(mnet.efms, 'efms'));
sparseEFM=efm_bin;
data_path= 'C:/Users/sedaghat/Dropbox/MONET_MetabolicNetworks/Data/RealMetabolicNetworks/';
save(strcat(data_path, model, '_binEFM.mat'), 'sparseEFM');




