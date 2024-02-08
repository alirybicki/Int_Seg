clear all; close all;
[params] = InitializePractice;

hitCount_seg = 0;
hitCount_int = 0;
practAccu_seg = [];
practAccu_int = [];

frameCount = 1;
extraTime = 60;
beepOnError = 1;
practiceFlag = 1;

for block = 1: params.nBlocks
    
    params.blocknr = block;
    
    
    segregation = 1;
    integration = 2;
    
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
    
%     params.cueID = (ones(1,params.nTrials)*5)'; % for testing how neu cues look
    
    params.cueVal = bigCondMat(:,18);
    
    
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
    
    
    for trial = 1:params.nTrials
        
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
        [params, response, correct, FlipStart, whereClick, timing] = getResponse_16_vDSF(params,FlipStart, trial, extraTime, beepOnError, practiceFlag);
        
        timingExit(block, trial) = timing;
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
        
        % practice accu counter
        if params.condition(1) == 1 && correct == 1
            hitCount_seg = hitCount_seg + 1;
        elseif params.condition(1) == 2 && correct == 1
            hitCount_int = hitCount_int + 1;  
        end
        
    end
    
    % calc practice accu
    if params.condition(1) == 1 
       practAccu_seg = floor(hitCount_seg / params.nTrials * 100);
    elseif params.condition(1) == 2 
       practAccu_int = floor(hitCount_int / params.nTrials * 100);
    end
    
end

ShowCursor;
Priority(0)
% ListenChar(0);
Screen ('Close');
Screen('CloseAll');
sca
sca
sca
% plot accu to check they get it 
practAccu_both = [practAccu_seg practAccu_int];
str = {'seg'; 'int'};
figure; bar(practAccu_both)
hold on 
set(gca, 'Xlim', [0 3])
ylabel('accu (%)')
xlabel('task version')
set(gca, 'XTickLabel',str, 'XTick',1:numel(str))
plot([0 3], [30 30],  '--k');
plot([0 3], [56 56],  '--g');  

timingExit




