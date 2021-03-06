%This function produce results for all of settings.
% Written by Nafiseh Sedaghat
% August 6, 2020
clear all
close all
%rng(4)
% parpool('local',2)
global depth splitting weight var_depth All_weight %All_CA

global call_counter hash_cntr redundancy_counter cellSize popularKey cellHash

% var_depth =
% All_weight =

tab = table;
CNF_len = table;
HashTableFreqs = table;
models = {'BIOMD0000000034', 'BIOMD0000000042','BIOMD0000000048','BIOMD0000000089','BIOMD0000000093','BIOMD0000000094',...
    'BIOMD0000000106', 'BIOMD0000000107','BIOMD0000000108','BIOMD0000000110',...
    'BIOMD0000000162', 'BIOMD0000000163', 'BIOMD0000000165', 'BIOMD0000000166',...
    'BIOMD0000000169', 'BIOMD0000000170','BIOMD0000000171','BIOMD0000000173', 'BIOMD0000000228'};%'BIOMD0000000011',
allSettings = GenerateSettings();
splitMethod = {'mostFreq', 'weightedVars'};
n_clause = 1; % initial clauses in the CNF
% cputimes = zeros(numel(models),8);
% thresh = 0;
% nn=7;
for nn=1:numel(models)
    model = models{nn};
    disp(strcat('nn is', num2str(nn), ' out of ', num2str(numel(models))))

    InputName = strcat('/Users/nafiseh/Dropbox/MONET_MetabolicNetworks/Data/RealMetabolicNetworks/',model, '_binEFM.mat');
    mat = [];
    load(InputName)
    mat = 1*(full(sparseEFM)~=0);
    mat=mat'; %
    
    mat = Preprocessing( mat );
    dnf = Irredundant(mat);
    
    disp(strcat('Model: ', model))
    disp(strcat('Number of reactions: ', num2str(size(dnf,2))))
    disp('======================')

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for k=1:2 % for splitMethod
        
        for j=1:size(allSettings,1) % for different settings
            Hashing = allSettings(j,1);
            Canonical = allSettings(j,2);
            Shrinkage = allSettings(j,3);
            Ordering = allSettings(j,4);
            recentHist = allSettings(j,5);
            
            depth = zeros(20000, 1);
            splitting = zeros(20000, 1);
            
            call_counter =0;
            hash_cntr = 0;
            redundancy_counter = 0;
            rng(1)
            [cnf, cput, cnf_len] = FK_Dualization_All( dnf, n_clause, splitMethod{k}, Hashing, Canonical, Shrinkage, Ordering, recentHist);
            [backlen, backcount, seenNodes] = Backtracking_Steps_Analysis(splitting);
            
            t = {model, splitMethod{k}, Hashing, Canonical,	Shrinkage, Ordering, recentHist,...
                call_counter, hash_cntr, backcount, backlen, seenNodes};
            tab = [tab; t];
            
            % Saving track of CNF completion
            lengs = cnf_len(1:find(cnf_len, 1, 'last'))';
            n = numel(lengs);
            t = table(repmat(model,n,1), repmat({splitMethod{k}},n,1), ...
                repmat(Hashing,n,1), repmat(Canonical,n,1), repmat(Shrinkage,n,1),...
                repmat(Ordering,n,1), repmat(recentHist,n,1),lengs);
            CNF_len = [CNF_len;t];
            
            if Hashing
                % Saving hashtables (length of CNF and DNF, and number of
                % fetching)
                hittingHashTable = [cell2mat(cellHash(1:(cellSize-1), 3:4)), zeros(cellSize-1,1)];

                for i=1:hash_cntr
                    hittingHashTable(popularKey(i), 3) = hittingHashTable(popularKey(i), 3) + 1; 
                end

                n = size(hittingHashTable, 1);

                t = table(repmat(model,n,1), repmat({splitMethod{k}},n,1), ...
                    repmat(Hashing,n,1), repmat(Canonical,n,1), repmat(Shrinkage,n,1),...
                    repmat(Ordering,n,1), repmat(recentHist,n,1), ...
                    hittingHashTable(:,1), hittingHashTable(:,2), hittingHashTable(:,3));
                HashTableFreqs = [HashTableFreqs;t];
            end
        end
    end
end

tab.Properties.VariableNames = {'Model', 'SplittingMethod',...
    'Hashing', 'Canonical',	'Shrinkage', 'Ordering', 'recentHist',...
    'FK_calls',	'Successful_Hashtable_Fetch', 'Backtracking_Counts',...
    'Backtracking_Length', 'Seen_Nodes'};

writetable(tab,'/Users/nafiseh/Dropbox/MONET_MetabolicNetworks/Results/allSettings_Measurements_Experiments.csv')

CNF_len.Properties.VariableNames = {'Model', 'SplittingMethod',...
    'Hashing', 'Canonical',	'Shrinkage', 'Ordering', 'recentHist',...
    'CNF_Length'};
writetable(CNF_len,'/Users/nafiseh/Dropbox/MONET_MetabolicNetworks/Results/allSettings_CNF_Completion_Experiments.csv')


HashTableFreqs.Properties.VariableNames = {'Model', 'SplittingMethod',...
    'Hashing', 'Canonical',	'Shrinkage', 'Ordering', 'recentHist',...
    'CNF_Length', 'DNF_Length', 'NumofHits'};

writetable(HashTableFreqs,'/Users/nafiseh/Dropbox/MONET_MetabolicNetworks/Results/allSettings_HashTableHits.csv')


