function [params response correct FlipStart whereClick timing quit] = getResponse_MEG(params, FlipStart, trial,  extraTime, beepOnError, practiceFlag, LRFlag)

% joystick is a pain in the arse, using button boxes now:
% with button box in left hand, one button for moving vertically, another for moving horizontally
% with button box in right hand, one button to choose that square

buttons = []; % empty buttons
sqChosen = 0; % 1/0 have they pressed button to choose a square

suppressor = 2^0 + 2^1 + 2^2 + 2^3; %build a mask of unused input channels

%% spin up the PPT
sendTrigger = intialiseParallelPort();
% disp('INIT PORT')
sendTrigger(0);

missingArc = 3;
missingEle = 4;
incorrect = 5;

% define CONSTANT rt time limit
RT_TIME_LIMIT = params.resWinLim + extraTime; %DAGHACK

KbName('UnifyKeyNames');
if LRFlag %RIGHT
    % commandwindow
    upKey = KbName('7&');
    downKey = KbName('8*');
    leftKey = KbName('9(');
    rightKey = KbName('0)');
    selectKey = KbName('6^');
else % LEFT
    upKey = KbName('1!');
    downKey = KbName('2@');
    leftKey = KbName('3#');
    rightKey = KbName('4$');
    selectKey = KbName('5%');
end
quitKey = KbName('q');
escapeKey = KbName('ESCAPE');
waitDebounce = 1/120;

% params for drawing placeholder
baseRect = [0 0 params.dotSize params.dotSize];
excoords = [params.StimuliCoords(1,:); params.StimuliCoords(3,:)];
whycoords = [params.StimuliCoords(2,:); params.StimuliCoords(4,:)];
params.plahoCoords.x = mean(excoords,1);
params.plahoCoords.y = mean(whycoords,1);
penWidthPixels = 2;

disp('1')
WaitSecs(0.4)
startTime = GetSecs;

if params.virtRes == true  % virtual responses so don't have to click anything when debugging
    
    FlipStart.arrayonset = GetSecs;
    WaitSecs(params.responseDelay);
    
    for i = 1:16
        allRects(:, i) = CenterRectOnPointd(baseRect, params.plahoCoords.x(i), params.plahoCoords.y(i));
    end
    Screen('FrameRect', params.w, params.black, allRects, penWidthPixels);
    
    
    [FlipStart.Array] = Screen('Flip', params.w);
    %%%%%% to time with rough RT %%%%%%%%%%%%
    %%%%% make shorter if just debugging %%%%%
    WaitSecs(1)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if params.enviro == 2
        %         Datapixx('SetDoutValues', params.trig.click);
        %         Datapixx('RegWrVideoSync'); %send this code with the next screen flip
        %         WaitSecs(params.trigReset);
        %         Datapixx('SetDoutValues', 0);
        %         Datapixx('RegWr');
    end
    
    outcome = randi(5);
    dummy = randi(16);
    
    FlipStart.arrayoffset=GetSecs;
    disp('2')
    
    switch outcome
        case 1
            response = 8;
            whereClick = params.thisTrlVect(1,8);
        case 2
            response = 16;
            whereClick = params.thisTrlVect(1,16);
        case 3
            response = 1;
            whereClick = params.thisTrlVect(1,1);
        case 4
            response = 2;
            whereClick = params.thisTrlVect(1,9);
        case 5
            response = 3;
            whereClick = dummy;
    end
    
    
else % get response from user
    disp('3')
    
    FlipStart.arrayonset=GetSecs;
    debounceLatch = 2;
    
    %     % Flush buffers
    %     Datapixx('RegWrRd');    % Synchronize Datapixx registers to local register cache
    %
    %     Datapixx('SetDinDataDirection', hex2dec('1F0000'));
    %     Datapixx('SetDinDataOut', hex2dec('1F0000'));
    %     Datapixx('SetDinDataOutStrength', 1);   % Set brightness of buttons
    %     Datapixx('RegWrRd');
    %
    %     num_Bits = Datapixx('GetDinNumBits');
    %
    %     suppressor = 2^0 + 2^1 + 2^2 + 2^3; %build a mask of unused input channels
    %
    %     % Fire up the logger
    %     Datapixx('EnableDinDebounce');      % Filter out button bounce
    %     Datapixx('SetDinLog');              % Configure logging with default values
    %     Datapixx('StartDinLog');
    %     Datapixx('RegWrRd');
    
    get_answer=GetSecs;
    t_resp=0;
    highRect = randi([1 16]); % a random square is highlighted at first
    disp('4')
    firstLoop = 1;
    while sqChosen == 0 % wait until they press button to chose square
        
        % until they choose square or time runs out, flip squares to screen
        % start with random square highlighted e.g. square 1
        % if they press vert button it moves down one and square two is highlighted
        % if they then hori button moves laterally and square six is highlighted, etc
        % keep flipping response probe to screen (with one highlighted), keep looking
        % for button presses until they select a square
        
        %         % wait until no buttons pressed
        %         buttons = bitand(Datapixx('GetDinValues'),suppressor);
        %         while buttons
        %             %     disp('loop-0');
        %             Datapixx('RegWrRd');
        %             status = Datapixx('GetDinStatus');
        %             if status.newLogFrames>0
        %                 [buttons, logTimetags, underflow] = Datapixx('ReadDinLog',1);
        %                 buttons = bitand(buttons,suppressor);
        %
        %             end
        %         end
        
        
        %         while ~buttons
        
        % prob a neater way of coding this but oh well..
        if  highRect == 1
            arrayBlack = [2:16];
        elseif highRect == 16
            arrayBlack = [1:15];
        else
            arrayBlack = [1:highRect-1 highRect+1:16];
        end
        
        
        % show response probe
        % black squares coords
        for i = arrayBlack % all squares except highlighted
            allRects(:, i) = CenterRectOnPointd(baseRect, params.plahoCoords.x(i), params.plahoCoords.y(i));
        end
        % highlighted square coords
        highRectCoords = CenterRectOnPointd(baseRect, params.plahoCoords.x(highRect), params.plahoCoords.y(highRect));
        disp('5')
        
        Screen('FrameRect', params.w, params.black, allRects, penWidthPixels); % draw the black squares
        Screen('FrameRect', params.w, params.highlight, highRectCoords, penWidthPixels);% draw the highlighted square
        
        
        [FlipStart.Array] = Screen('Flip', params.w); % keep flipping placeholder to the screen while waiting for response
        
        quit = 0
        if t_resp-get_answer < RT_TIME_LIMIT %time limit to answer
            
            %                 [secs, keyCode, deltaSecs] = KbPressWait();
            %                 disp('6!')
            %WaitSecs(waitDebounce*5);
%            [secs, keyCode, deltaSecs] = KbWait([], 1,  waitDebounce*24);
             [secs, keyCode, deltaSecs] = KbWait([], 2,  waitDebounce*24);
             if firstLoop
                 firstLoop = 0;
             else
             WaitSecs(waitDebounce*12)
            %WaitSecs(waitDebounce*5)
             end
            
            if keyCode(27)
                Screen('Flip', params.w);
                abort_text = ['Do you really want to quit? Press q to quit or any other key to continue'];
                DrawFormattedText(params.w, abort_text, 'center', 'center', WhiteIndex(max(Screen('Screens'))));
                Screen('Flip', params.w);
                [~, abrtPrsd] = KbStrokeWait;
                if abrtPrsd(quitKey)
                    % save data til now
                    warning('Experiment aborted by operator')
                    quit = 1;
                    break
                end
                %KbQueueFlush;
            end
            
            %                 if status.newLogFrames>0
            %                     [buttons, logTimetags, underflow] = Datapixx('ReadDinLog',1);
            %                     buttons = bitand(buttons,suppressor); % 1 2 4 8
            %                 end
            t_resp=GetSecs;
            if keyCode(selectKey)

                
                sqChosen = 1; % to break loop
                whereClick = highRect;
                % response for whether segtarget, inttarget, D1 etc
                if highRect == params.thisTrlVect(1,8)
                    response = 8; % segTar
                elseif highRect == params.thisTrlVect(1,16)
                    response = 16; % intTar
                elseif sum(ismember(params.thisTrlVect(1,1:7), highRect)) > 0
                    response = 1;
                elseif sum(ismember(params.thisTrlVect(1,9:15), highRect)) > 0
                    response = 2;
                end
                break
                
            elseif (keyCode(upKey) || keyCode(downKey))
                
                % highRect goes one down
                if sum(ismember([1 2 3 5 6 7 9 10 11 13 14 15], highRect)) > 0
                    highRect = highRect + 1; % go down one
                else % bottom of grid, go round and start from top again
                    highRect = highRect - 3;
                end
            elseif (keyCode(leftKey) || keyCode(rightKey))
                % highRect goes one right
                if highRect < 13
                    highRect = highRect + 4; % go across one
                else % far right of grid, go back round and start from far left
                    highRect = highRect - 12;
                end
            else
            end
            
            keyCode = zeros(size(keyCode));
        else % they're too slow
            response = 99;
            whereClick = 99;
            break
        end
        
        %         end % while buttons
        
    end % while sqChosen
    
    %stop the logger
    %     Datapixx('StopDinLog');
    %     Datapixx('RegWrRd');
    
    FlipStart.arrayoffset = GetSecs;
    % send trigger for when clicked
    if params.enviro == 2
        %         Datapixx('SetDoutValues', params.trig.click);
        %         Datapixx('RegWr'); % send this code now
        %         WaitSecs(params.trigReset);
        %         Datapixx('SetDoutValues', 0);
        %         Datapixx('RegWr');
    end
    
    
end % end if real or virtual responses

if ~quit
    
    if params.condition(trial)==1 && response == 8
        correct = 1;
        if params.enviro == 2 % MEG
            %         Datapixx('SetDoutValues', 108); % Set values to output
            %         Datapixx('RegWr');
            sendTrigger(power(2, missingArc));
            WaitSecs(0.005);
            sendTrigger(0);
            %         Datapixx('SetDoutValues', 0); % Set the output
            %         Datapixx('RegWr'); % Send it whenever (not on a flip just basically straight away.
        end
    elseif params.condition(trial)==2 && response == 16
        correct = 1;
        if params.enviro == 2 % MEG
            %         Datapixx('SetDoutValues', 116); % Set values to output
            %         Datapixx('RegWr');
            sendTrigger(power(2, missingEle));
            WaitSecs(0.005);
            
            sendTrigger(0);
            %         Datapixx('SetDoutValues', 0); % Set the output
            %         Datapixx('RegWr'); % Send it whenever (not on a flip just basically straight away.
        end
    else
        correct = 0;
        if params.enviro == 2 % MEG
            %         Datapixx('SetDoutValues', 100); % Set values to output
            %         Datapixx('RegWr');
            sendTrigger(power(2, incorrect));
            if beepOnError
                beep
            end
            WaitSecs(0.005);
            sendTrigger(0);%         Datapixx('SetDoutValues', 0); % Set the output
            %         Datapixx('RegWr'); % Send it whenever (not on a flip just basically straight away.
        end
    end
    
    if params.enviro == 2
        %    code_perf = params.trig.mark + correct; % code for if correct or incorrect
        %     Datapixx('SetDoutValues', code_perf);
        %     Datapixx('RegWr'); %send this code now
        %     WaitSecs(params.trigReset);
        %     Datapixx('SetDoutValues', 0);
        %     Datapixx('RegWr');
    end
    
    
    
    Screen('FillRect', params.w, params.gray);
    params.trialStart=Screen('Flip',params.w);
    timing = secs-startTime;
else
    response = -1;
    correct = 0;
    
    whereClick = -1;
    timing = -1;
    quit =1;
end




end