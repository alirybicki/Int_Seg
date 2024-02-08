clear all; close all;

[params] = InitializeExtraBlock;

frameCount = 1;

    
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
        [params, response, correct, FlipStart, whereClick] = getResponse_16(params,FlipStart, trial);
        
        
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
        

    
   
    
    end

 % save things
    data = saveBlock(params, result, clickPos, performance, MET, odd, tmeasure, missing, dispIdenti, cueIdenti, cuePos);
    
ShowCursor;
Priority(0)
% ListenChar(0);
Screen ('Close');
Screen('CloseAll');

