function [params] = InitializeExtraBlock

% manual input parameters
params.enviro = 1; % 1:beh, 2: MEG, 3: dbg/toy 
    % CAREFUL with these if in proper data collection, helpful for debugging
    params.smallScreen = false;
    params.virtRes = false; % responses not recorded if set to T
    params.presCheck = false; % stimuli stay on screen for a few seconds so can check they look as expected
    params.skipSyncCheck = false;



% input parameters, and some idiot proofing against wrong inputs
if params.enviro == 3 % dbg
    params.subjectID = 888; % doesn't matter what
    params.blocknr = 1;
else
    params.subjectID = input('Subject number? ');
    params.fileName = ['P_' num2str(params.subjectID) '_data.mat'];
    params.blocknr = input('Blocknumber? (seg = odd, int = even)' ); 
        if params.blocknr < 9
            params.blocknr = input('Check and reenter blocknumber (seg = odd, int = even):' ); 
        end

end


    if params.skipSyncCheck == true; % debugging / toy
        Screen('Preference', 'SkipSyncTests', 1); 
    end
    
     
    

%% % Experiment Parameters

if params.enviro == 3
%     params.nBlocks = 1;
    params.nTrials = 10;
else
%     params.nBlocks = 8;
    params.nTrials = 60;
end

    segregation = [1 3 5 7 9 11 13];
    integration = [2 4 6 8 10 12 14];
    
    if ismember(params.blocknr, segregation)
        condition = (ones(1,params.nTrials)*1)';
    elseif ismember(params.blocknr, integration)
        condition = (ones(1,params.nTrials)*2)';
    end
    
    params.condition = condition';
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[params] = grab_gen_params(params);   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Conditions/ randomisation


    % stimuli locations
    vector = 1:16;
    for tr = 1:params.nTrials
        stimCond_ord(tr, :) = Shuffle(vector);
    end
    
    
    % cue types
    nTrials = params.nTrials;
    nCuedTrls = ceil(nTrials*.75);
    nNeuCueTrls = nTrials - nCuedTrls;
    
    nValCueTrls = ceil(nCuedTrls*.7);
    nInvCueTrls = nCuedTrls - nValCueTrls;
    
    quad1 = [1 2 5 6];
    quad2 = [3 4 7 8];
    quad3 = [9 10 13 14];
    quad4 = [11 12 15 16];
    
    whichTaskVer = params.condition(1);
    
    segTargets = stimCond_ord(:,8);
    intTargets = stimCond_ord(:,16);
    
    
    cueCond_ord = [];
    cueValidity_ord = [];
    
    for tr = 1:nCuedTrls
        if whichTaskVer == 1 % segregation
            target = segTargets(tr);
        elseif whichTaskVer == 2 % integration. Shouldn't be another possibility...
            target = intTargets(tr);
        end
        if tr <= nValCueTrls % make some valid cues
            cueValidity_ord(tr) = 1;
            if ismember(target, quad1) % if target is in this quadrant, cue that quadrant
                cueCond_ord(tr) = 1;
            elseif ismember(target, quad2)
                cueCond_ord(tr) = 2;
            elseif ismember(target, quad3)
                cueCond_ord(tr) = 3;
            elseif ismember(target, quad4)
                cueCond_ord(tr) = 4;
            end
        else % once have made enough valid cues, make some invalid ones
            cueValidity_ord(tr) = 0;
            if ismember(target, quad1) % if target is in this quadrant, cue any other quadrant
                cueCond_ord(tr) = randi([2 4]);
            elseif ismember(target, quad2)
                shuffledTypes = Shuffle([1 3 4]);
                cueCond_ord(tr) = shuffledTypes(1);
            elseif ismember(target, quad3)
                shuffledTypes = Shuffle([1 2 4]);
                cueCond_ord(tr) = shuffledTypes(1);
            elseif ismember(target, quad4)
                cueCond_ord(tr) = randi([1 3]);
            end
        end
    end
    % once have made some valid and invalid cues, make some neutral ones
    addNeuCue = (ones(1,nNeuCueTrls)*5)'; % code 5 for neu cue
    cueCond_ord = [cueCond_ord'; addNeuCue];
    cueValidity_ord = [cueValidity_ord'; addNeuCue];
    
    
    % put stim cond and cue cond together in same matrix, shuffle it, then take apart
    bigCondMat_ord = [stimCond_ord cueCond_ord cueValidity_ord]; % now nTrials by 18 matrix: rows 1 to 16 is stim locations, row 17 is cue type(1,2,3,4 or 5), row 18 is cue validity (1=val, 0=inv, 5=neu)
    bigCondMat = bigCondMat_ord(randperm(size(bigCondMat_ord,1)),:);
    params.stimCond = bigCondMat(:,1:16);
    params.cueID = bigCondMat(:,17);
    params.cueVal = bigCondMat(:,18);   


%% show instructions


    Screen('TextSize',params.w,params.fontSize);
    
    if params.condition(1) == 1;
        intro_text = 'In quale posizione c''è un mezzo cerchio? \n Premi un tasto qualsiasi per cominciare \n \n In which location is there a half circle? \n Press a key to begin ';
    elseif params.condition(1) == 2;
        intro_text = 'In quale posizione manca un cerchio? \n Premi un tasto qualsiasi per cominciare \n \n Which location is missing a circle? \n Press a key to begin ';
    end
    
    DrawFormattedText(params.w, intro_text, 'center', 'center', params.black, 60, 0, 0, params.fontSpacing);
    params.expStart = Screen('Flip',params.w);
    WaitSecs(.5)
    KbWait; %KbReleaseWait;
    Screen('FillRect', params.w, params.gray);
    params.trialStart = Screen('Flip',params.w);