function [FlipStart, trial, params] = showtrial(params, trial)

sendTrigger = intialiseParallelPort();
disp('INIT PORT')
sendTrigger(0);
fix = 0;
cue = 1;
stim =2;

% function runs anew each trial, so all these params defined in mtargets are generated each time
[params, wPtrDots1, wPtrDots2, wPtrISI, wPtrGray, wPtrGrayFix, cueType] = mtargets(params,trial);


%%
sourcerect = [0 0 ...
    params.resolution(1) params.resolution(2)];
destrect = [0 0 ...
    params.resolution(1) params.resolution(2)];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ITI and trial start
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cueID = 0; % fixation cross, no cue yet
[cross ]  = grab_cross_params(params, cueID);
Screen('DrawTexture', params.w, wPtrISI); % grey background
Screen('DrawLine', params.w, cross.c1.col, cross.c1.fromH , cross.c1.fromV, cross.c1.toH, cross.c1.toV, params.lineWidth);
Screen('DrawLine', params.w, cross.c2.col, cross.c2.fromH , cross.c2.fromV, cross.c2.toH, cross.c2.toV, params.lineWidth);
Screen('DrawLine', params.w, cross.tl.col, cross.tl.fromH , cross.tl.fromV, cross.tl.toH, cross.tl.toV, params.lineWidth);
Screen('DrawLine', params.w, cross.bl.col, cross.bl.fromH , cross.bl.fromV, cross.bl.toH, cross.bl.toV, params.lineWidth);
Screen('DrawLine', params.w, cross.tr.col, cross.tr.fromH , cross.tr.fromV, cross.tr.toH, cross.tr.toV, params.lineWidth);
Screen('DrawLine', params.w, cross.br.col, cross.br.fromH , cross.br.fromV, cross.br.toH, cross.br.toV, params.lineWidth);
FlipStart.fixation = Screen('Flip', params.w, params.trialStart + params.flipITI);


if params.enviro == 2 % MEG
    
    sendTrigger(power(2, fix));
%    Datapixx('SetDoutValues', params.fixOnsetTrigger); % Set values to output
%    Datapixx('RegWr');
end

%  Screen('DrawTexture', params.w, wPtrGray,sourcerect,destrect);
%  FlipStart.fixationoffset=Screen('Flip', params.w, FlipStart.fixation+params.flipWait);

if params.enviro == 2 % MEG
%    Datapixx('SetDoutValues', 0); % Set the output
%    Datapixx('RegWrVideoSync');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cue
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cueID = cueType;
[cross ]  = grab_cross_params(params, cueID);
Screen('DrawTexture', params.w, wPtrISI); % grey background
Screen('DrawLine', params.w, cross.c1.col, cross.c1.fromH , cross.c1.fromV, cross.c1.toH, cross.c1.toV, params.lineWidth);
Screen('DrawLine', params.w, cross.c2.col, cross.c2.fromH , cross.c2.fromV, cross.c2.toH, cross.c2.toV, params.lineWidth);
Screen('DrawLine', params.w, cross.tl.col, cross.tl.fromH , cross.tl.fromV, cross.tl.toH, cross.tl.toV, params.lineWidth);
Screen('DrawLine', params.w, cross.bl.col, cross.bl.fromH , cross.bl.fromV, cross.bl.toH, cross.bl.toV, params.lineWidth);
Screen('DrawLine', params.w, cross.tr.col, cross.tr.fromH , cross.tr.fromV, cross.tr.toH, cross.tr.toV, params.lineWidth);
Screen('DrawLine', params.w, cross.br.col, cross.br.fromH , cross.br.fromV, cross.br.toH, cross.br.toV, params.lineWidth);
%FlipStart.cue = Screen('Flip', params.w, FlipStart.fixation+params.flipWait);
FlipStart.cue = Screen('Flip', params.w, FlipStart.fixation + params.flipJitter(randi(numel(params.flipJitter))));


if params.presCheck == true
    WaitSecs(5)
end


if params.enviro == 2 % MEG
    
    sendTrigger(power(2, cue));
    
%    Datapixx('SetDoutValues', params.cueTrigger); % Set values to output
%    Datapixx('RegWr');
end

% after cue shown, cross goes back to all red fixation cross)
cueID = 0; % fixation cross
[cross ]  = grab_cross_params(params, cueID);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Display 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Screen('DrawTexture', params.w, wPtrDots1);
Screen('DrawLine', params.w, cross.c1.col, cross.c1.fromH , cross.c1.fromV, cross.c1.toH, cross.c1.toV, params.lineWidth);
Screen('DrawLine', params.w, cross.c2.col, cross.c2.fromH , cross.c2.fromV, cross.c2.toH, cross.c2.toV, params.lineWidth);
Screen('DrawLine', params.w, cross.tl.col, cross.tl.fromH , cross.tl.fromV, cross.tl.toH, cross.tl.toV, params.lineWidth);
Screen('DrawLine', params.w, cross.bl.col, cross.bl.fromH , cross.bl.fromV, cross.bl.toH, cross.bl.toV, params.lineWidth);
Screen('DrawLine', params.w, cross.tr.col, cross.tr.fromH , cross.tr.fromV, cross.tr.toH, cross.tr.toV, params.lineWidth);
Screen('DrawLine', params.w, cross.br.col, cross.br.fromH , cross.br.fromV, cross.br.toH, cross.br.toV, params.lineWidth);
[FlipStart.dotarray1, dotarray1Onset] = Screen('Flip', params.w, FlipStart.cue + params.flipCue);
%KbWait; KbReleaseWait;

if params.enviro == 2 % MEG
    
    sendTrigger(power(2, stim));
%     Datapixx('SetDoutValues', params.stimOnsetTrigger); % Set values to output
%     Datapixx('RegWr');
end

% if params.presCheck == true
%     WaitSecs(5)
% end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ISI 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Screen('DrawTexture', params.w, wPtrISI);
Screen('DrawLine', params.w, cross.c1.col, cross.c1.fromH , cross.c1.fromV, cross.c1.toH, cross.c1.toV, params.lineWidth);
Screen('DrawLine', params.w, cross.c2.col, cross.c2.fromH , cross.c2.fromV, cross.c2.toH, cross.c2.toV, params.lineWidth);
Screen('DrawLine', params.w, cross.tl.col, cross.tl.fromH , cross.tl.fromV, cross.tl.toH, cross.tl.toV, params.lineWidth);
Screen('DrawLine', params.w, cross.bl.col, cross.bl.fromH , cross.bl.fromV, cross.bl.toH, cross.bl.toV, params.lineWidth);
Screen('DrawLine', params.w, cross.tr.col, cross.tr.fromH , cross.tr.fromV, cross.tr.toH, cross.tr.toV, params.lineWidth);
Screen('DrawLine', params.w, cross.br.col, cross.br.fromH , cross.br.fromV, cross.br.toH, cross.br.toV, params.lineWidth);
[FlipStart.ISI, whitewonset] = Screen('Flip', params.w, FlipStart.dotarray1+params.flipD1);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Display 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Screen('DrawTexture', params.w, wPtrDots2);
Screen('DrawLine', params.w, cross.c1.col, cross.c1.fromH , cross.c1.fromV, cross.c1.toH, cross.c1.toV, params.lineWidth);
Screen('DrawLine', params.w, cross.c2.col, cross.c2.fromH , cross.c2.fromV, cross.c2.toH, cross.c2.toV, params.lineWidth);
Screen('DrawLine', params.w, cross.tl.col, cross.tl.fromH , cross.tl.fromV, cross.tl.toH, cross.tl.toV, params.lineWidth);
Screen('DrawLine', params.w, cross.bl.col, cross.bl.fromH , cross.bl.fromV, cross.bl.toH, cross.bl.toV, params.lineWidth);
Screen('DrawLine', params.w, cross.tr.col, cross.tr.fromH , cross.tr.fromV, cross.tr.toH, cross.tr.toV, params.lineWidth);
Screen('DrawLine', params.w, cross.br.col, cross.br.fromH , cross.br.fromV, cross.br.toH, cross.br.toV, params.lineWidth);
[FlipStart.dotarray2, dotarray2Onset] = Screen('Flip', params.w, FlipStart.ISI+params.flipISI);

%KbWait; KbReleaseWait;
if params.enviro == 2 % MEG
    
    sendTrigger(0);
%     Datapixx('SetDoutValues', 0); % Set the output
%     Datapixx('RegWr');
end

% if params.presCheck == true
%     WaitSecs(5)
% end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clear screen ready for response delay
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Screen('DrawTexture', params.w, wPtrISI);
Screen('DrawLine', params.w, cross.c1.col, cross.c1.fromH , cross.c1.fromV, cross.c1.toH, cross.c1.toV, params.lineWidth);
Screen('DrawLine', params.w, cross.c2.col, cross.c2.fromH , cross.c2.fromV, cross.c2.toH, cross.c2.toV, params.lineWidth);
Screen('DrawLine', params.w, cross.tl.col, cross.tl.fromH , cross.tl.fromV, cross.tl.toH, cross.tl.toV, params.lineWidth);
Screen('DrawLine', params.w, cross.bl.col, cross.bl.fromH , cross.bl.fromV, cross.bl.toH, cross.bl.toV, params.lineWidth);
Screen('DrawLine', params.w, cross.tr.col, cross.tr.fromH , cross.tr.fromV, cross.tr.toH, cross.tr.toV, params.lineWidth);
Screen('DrawLine', params.w, cross.br.col, cross.br.fromH , cross.br.fromV, cross.br.toH, cross.br.toV, params.lineWidth);
[FlipStart.End, whitewonset] = Screen('Flip', params.w, FlipStart.dotarray2+params.flipD2);



Screen ('Close',[wPtrDots1 wPtrDots2 wPtrISI wPtrGray wPtrGrayFix]);