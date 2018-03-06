% Copyright (c) 2017-2018, Jakob Nikolas Kather. 
% 
% Please cite our publication:
% "Large-scale database mining reveals hidden trends and future directions
% for cancer immunotherapy", DOI 10.1080/2162402X.2018.1444412
% 
% License: please refer to the license file in the root directory
%
% -------------------------------------------------------------
%
% define experiments to run (groups of keywords)

function [FILTparent2,filter_bank] = getExperimentMetadata(currentExperiment,myKeywTable)

switch char(currentExperiment)
    case 'dummy'   
    error('not yet implemented');
    
    case 'TREATMENTS_NOOTHER'
        FILTparent2 = 'TREATMENTS';
        filter_bank = {'chemotherapy','checkpoint','vaccination','adoptive','radiation','antibodies','inhibitors',...
            'oncolytic virus'};
    
    
    case 'TREATMENT_TOP6'
        FILTparent2 = 'TREATMENTS';
        filter_bank = {'chemotherapy','checkpoint','vaccination','adoptive','radiation','antibodies'};

    case 'CANCER_TYPES_TOP5'
        FILTparent2 = 'CANCER_TYPES';
        filter_bank = {'skin','gastrointestinal','respiratory-thoracic','hematological','urinary tract'};

    case 'CHECK_ONLY'
        FILTparent2 = 'TREATMENTS';
        filter_bank = {'checkpoint'};
 
    case 'ANGSTROAPOSIG'
        FILTparent2 = 'TRANSLATIONAL';
        filter_bank = {'angiogenesis','stroma','apoptosis','signaling'};

   case 'SELECT_TRANSLATIONAL'
        FILTparent2 = 'TRANSLATIONAL';
        filter_bank = {'stem cell','angiogenesis','stroma','antigens','apoptosis','signaling'};
        
    otherwise
        FILTparent2 = currentExperiment;
        parentmask = strcmp(myKeywTable.level_2_parent,FILTparent2);
        filter_bank = unique(myKeywTable.level_1_parent(parentmask))';
        
end
end