function [params] = InitializeExp(practiceFlag)

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
else
    params.subjectID = input('Subject number? ');
    %check subj number is unique
    params.fileName = ['P_' num2str(params.subjectID) '_data.mat'];
    exists = exist(params.fileName,'file');
    if exists
        params.subjectID = input('File already exists. Check and enter participant #:');
        params.fileName = ['P_' num2str(params.subjectID) '_data.mat'];
    end

end

if params.skipSyncCheck == true; % debugging / toy
    Screen('Preference', 'SkipSyncTests', 1);
end

if 0
PsychDebugWindowConfiguration
end

commandwindow


%% % Experiment Parameters

if practiceFlag == 1
    params.nBlocks = 1;
    params.nTrials = 30;
else
    params.nBlocks = 10;%10
    params.nTrials = 60;%60
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[params] = grab_gen_params(params);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




