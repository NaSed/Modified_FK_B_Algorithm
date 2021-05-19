clear all
close all
global call_counter splitting depth
models = {'BIOMD0000000034', 'BIOMD0000000042','BIOMD0000000048','BIOMD0000000089','BIOMD0000000093','BIOMD0000000094',...
    'BIOMD0000000106', 'BIOMD0000000107','BIOMD0000000108','BIOMD0000000110',...
    'BIOMD0000000162', 'BIOMD0000000163', 'BIOMD0000000165', 'BIOMD0000000166',...
    'BIOMD0000000169', 'BIOMD0000000170','BIOMD0000000171','BIOMD0000000173', 'BIOMD0000000228'};%'BIOMD0000000011',

nn=3;
calls = zeros(numel(models), 5);
CNF_len = table;
for nn=1:numel(models)
    model = models{nn};
    disp(strcat('nn is', num2str(nn), ' out of ', num2str(numel(models))))
    
    InputName = strcat('/Users/nafiseh/Dropbox/MONET_MetabolicNetworks/Data/RealMetabolicNetworks/',model, '_binEFM.mat');
    mat = [];
    load(InputName)
    
    mat = 1*(full(sparseEFM)~=0);
    mat=mat'; %
    
    mat = Preprocessing( mat );
    mat = Irredundant(mat);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Berge input is mat = [EFM x Reactions]
    [berge_cnf, totaliter, maxiter, berge_cpu]= berge(mat);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    depth = zeros(20000, 1);
    splitting = zeros(20000, 1);
    call_counter = 0;
    rng(6)
    
    [FK_cnf, FK_cpu, FK_len]= FK_Dualization( mat, 1 );
    calls(nn, 1) = call_counter;
    if size(intersect(berge_cnf, FK_cnf, 'rows'),1)~=size(berge_cnf, 1)
        error('FK is wrong!')
    end
    
    % Saving track of CNF completion
    lengs = FK_len(1:find(FK_len, 1, 'last'))';
    n = numel(lengs);
    t = table(repmat(model,n,1), repmat({'FK'},n,1),lengs);
    CNF_len = [CNF_len;t];
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    redundancy_counter = 0;
    depth = zeros(20000, 1);
    splitting = zeros(20000, 1);
    call_counter = 0;
    
    rng(6)
    [M_cnf, M_cpu, M_len]= FK_Dualization_M( mat, 1 );
    calls(nn, 2) = call_counter;
    if size(intersect(berge_cnf, M_cnf, 'rows'),1)~=size(berge_cnf, 1)
        error('FK is wrong!')
    end
    
    % Saving track of CNF completion
    lengs = M_len(1:find(M_len, 1, 'last'))';
    n = numel(lengs);
    t = table(repmat(model,n,1), repmat({'FKM'},n,1),lengs);
    CNF_len = [CNF_len;t];  
end

CNF_len.Properties.VariableNames = {'Model', 'Method', 'CNF_Length'};

writetable(CNF_len,'/Users/nafiseh/Dropbox/MONET_MetabolicNetworks/Results/FK_FKM_CNF_Completion_Experiments.csv')

