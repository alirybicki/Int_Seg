clear all; close all;

prompt = 'LEFT OR RIGHT?  0 for left, 1 for right - ';
practice_prompt = 'Practice?  1 for yes, 0 for main task - ';
LRFlag = input(prompt);
%LRFlag = 0; % 0 left, 1 right

practiceFlag = input(practice_prompt);

%PsychDebugWindowConfiguration
quit = 0;
[params] = InitializeExp(practiceFlag);

frameCount = 1;
if practiceFlag
    
    extraTime = 7.5;
else
    extraTime = 1;
end

    
beepOnError = 0;
%practiceFlag = 0; % 

for block = 1: params.nBlocks
    
    params.blocknr = block;
    
    segregation = [1, 3, 5, 7, 9]; 
    integration = [2, 4, 6, 8, 10]; 
    
    if ismember(params.blocknr, segregation)
        condition = (ones(1,params.nTrials)*1)';
    elseif ismember(params.blocknr, integration)
        condition = (ones(1,params.nTrials)*2)';
    end
    
    params.condition = condition';
    
    % Conditions/randomization
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
    
    %
    if ~quit
        
        Screen('TextSize',params.w, params.fontSize);
        
        if params.condition(1) == 1;
            intro_text = 'In which location is there a half circle? \n Press a key to begin ';
        elseif params.condition(1) == 2;
            intro_text = 'Which location is missing a circle? \n Press a key to begin ';
        end
        
        DrawFormattedText(params.w, intro_text, 'center', 'center', params.black, 60, 0, 0, params.fontSpacing);
        params.expStart = Screen('Flip',params.w);
        WaitSecs(.5)
        KbWait; %KbReleaseWait;
        Screen('FillRect', params.w, params.gray);
        params.trialStart = Screen('Flip',params.w);
        
%% spin up the PPT
sendTrigger = intialiseParallelPort();
disp('INIT PORT')
sendTrigger(0);

        for trial = 1:params.nTrials
            
            if ~quit
                % show stimuli
                [FlipStart, trial, params] = showtrial(params, trial);
                
                % check timings were ok, no missed flips etc
                tmeasure.ITI(frameCount) = FlipStart.fixation - params.trialStart; % fixed
                tmeasure.fixation(frameCount) = FlipStart.cue - FlipStart.fixation; % jittered
                
                tmeasure.cue(frameCount) = FlipStart.cue - FlipStart.fixation; % fixed
                
                tmeasure.cueInterval(frameCount) = FlipStart.dotarray1 - FlipStart.cue;
                tmeasure.Display1(frameCount)= FlipStart.ISI - FlipStart.dotarray1;
                tmeasure.ISI(frameCount) = FlipStart.dotarray2 - FlipStart.ISI;
                tmeasure.Display2(frameCount) = FlipStart.End - FlipStart.dotarray2;
                
                % grab some details about the trial for eventual saving
                dispIdenti(trial,:) = params.thisTrlVect;
                cueIdenti(trial,:) = params.cueVal(trial); % valid/invalid/neutral
                cuePos(trial,:) = params.thisTrlCuePos;  % cueing quad 1,2,3 or 4, or neutral
                
                % Andi's way of saving them
                MET(trial,:)= params.MET; % location of missing element for that trial
                odd(trial,:)= params.odd; % location of missing arc for that trial
                
                
                % get response
               % [params, response, correct, FlipStart, whereClick, ~,quit] = getResponse_16_vAJR(params,FlipStart, trial, extraTime, beepOnError, practiceFlag);
                                % get response NEW
                [params, response, correct, FlipStart, whereClick, ~,quit] = getResponse_MEG_vDSF(params,FlipStart, trial, extraTime, beepOnError, practiceFlag, LRFlag);
                
                
                % more timings
                tmeasure.Wait(frameCount) = FlipStart.arrayonset-FlipStart.End;
                tmeasure.ChoiceTime(frameCount) = FlipStart.arrayoffset-FlipStart.arrayonset;
                
                tmeasure.ClosingLoop(frameCount) = params.trialStart-FlipStart.arrayoffset;
                
                result(trial) = response;
                clickPos(trial) = whereClick;
                performance(trial) = correct;
                
                if params.Display1duration ~= round(tmeasure.Display1(frameCount)*1000) | ...
                        params.Display2duration ~= round(tmeasure.Display2(frameCount)*1000) | ...
                        params.ISI ~= round(tmeasure.ISI(frameCount)*1000)
                    
                    missing(trial) = 2;
                else
                    
                    missing(trial) = 1;
                end
                
                frameCount = frameCount + 1;
                
                
                
            else
                
            end
        end
        
        % save things
        params.LRFlag = LRFlag;
        data = saveBlock(params, result, clickPos, performance, MET, odd, tmeasure, missing, dispIdenti, cueIdenti, cuePos);
        
        if ~quit
            
            Screen('TextSize',params.w, params.fontSize);
            blockEnd_text = ' Great, you''ve finished another block! ';
            
            DrawFormattedText(params.w, blockEnd_text, 'center', 'center', params.black, 60, 0, 0, params.fontSpacing);
            params.expStart = Screen('Flip',params.w);
            WaitSecs(3)
            %     KbWait; %KbReleaseWait;
            Screen('FillRect', params.w, params.gray);
            params.trialStart = Screen('Flip',params.w);
        else
            
        end
    else
        
    end
    
end

if ~quit
    
    Screen('TextSize',params.w, params.fontSize);
    exptEnd_text = ' End of experiment. Thanks ';
    
    DrawFormattedText(params.w, exptEnd_text, 'center', 'center', params.black, 60);
    params.expStart = Screen('Flip',params.w);
    WaitSecs(2)
    %     KbWait; %KbReleaseWait;
    Screen('FillRect', params.w, params.gray);
    params.trialStart = Screen('Flip',params.w);
    
    ShowCursor;
    Priority(0)
    ListenChar(0);
    Screen ('Close');
    Screen('CloseAll');

else
    Screen('TextSize',params.w, params.fontSize);
    exptEnd_text = 'End of experiment.';
    
    DrawFormattedText(params.w, exptEnd_text, 'center', 'center', params.black, 60);
    params.expStart = Screen('Flip',params.w);
    WaitSecs(2)
    
    %     Screen('FillRect', params.w, params.gray);
    %     params.trialStart = Screen('Flip',params.w);
    %
    %     ShowCursor;
    %     Priority(0)
    %     ListenChar(0);
    ShowCursor;
    commandwindow
    sca
    
    
    
end

Block1 = data(1).correct;
Acc_Block1 = (sum(Block1)/length(Block1))*100

% Block2 = data(2).correct;
% Acc_Block2 = (sum(Block2)/length(Block2))*100


