function [params] = InitializePractice

% manual input parameters
params.enviro = 2; % 1:beh, 2: MEG, 3: dbg/toy
    % CAREFUL with these if in proper data collection, helpful for debugging
    params.smallScreen = false;
    params.virtRes = false; % responses not recorded if set to T
    params.presCheck = false; % stimuli stay on screen for a few seconds so can check they look as expected
    params.skipSyncCheck = false;



% input parameters, and some idiot proofing against wrong inputs
if params.enviro == 3 % dbg
    params.subjectID = 666; % doesn't matter what
    params.blocknr = 1; 
else
    params.subjectID = 888;
%     params.blocknr = input(' Version? (1: seg. 2: int) ' ); 

end
% params.fileName = 'practice.mat';


    if params.skipSyncCheck == true; % debugging / toy
        Screen('Preference', 'SkipSyncTests', 1); 
    end
    

 commandwindow



%% % Experiment Parameters


    params.nBlocks = 2;
    params.nTrials = 30;



[params] = grab_gen_params(params);   



