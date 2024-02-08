function [params] = grab_gen_params(params)   
%grab_gen_params 
% Grab params that are generic to main expt practice, main blocks, and
% extra block provision


params.viewingDistance = 600; %mm. VPixx monitor in beh lab P-317  = 600

%% TRIGGER STUFF
if params.enviro == 999 % MEG
    Datapixx('Open');
    Datapixx('StopAllSchedules');
    Datapixx('RegWrRd');    % Synchronize Datapixx registers to local register cache
    % We'll make sure that all the TTL digital outputs are low before we start
    Datapixx('SetDoutValues', 0);
    Datapixx('RegWrRd');
    % Now the Triggers 2,4,8,16,32,128,256 are the availible triggers!!
    params.fixOnsetTrigger = 99;
    params.stimOnsetTrigger = 1;
    %params.trigger=[2,4,8,16,32,64,128,256];
    % Fire up the logger
    Datapixx('EnableDinDebounce');      % Filter out button bounce
    %Datapixx('DisableDinDebounce');    % Uncomment this line to log gruesome details of button bounce
    Datapixx('SetDinLog');              % Configure logging with default values
    Datapixx('StartDinLog');
    Datapixx('RegWrRd');
    params.initialValues = Datapixx('GetDinValues');
end

%% Display Parameters

AssertOpenGL;
params.screenNum = Screen('Screens');


PsychImaging('PrepareConfiguration');
if params.enviro == 2
    %PsychImaging('AddTask','AllViews','FlipHorizontal');
end



    if params.smallScreen == false
        [params.w, params.rect] = PsychImaging('OpenWindow', params.screenNum,[127.5 127.5 127.5]);
        % params.w = Screen(whichScreen, 'OpenWindow',Params.black); % from TarDis
    else 
        [params.w, params.rect] = PsychImaging('OpenWindow', params.screenNum,[127.5 127.5 127.5], [1 1 500 500]);
    end


params.x0 = params.rect(3) / 2;
params.y0 = params.rect(4) / 2; 
params.white = WhiteIndex(params.w);
params.black = BlackIndex(params.w);
% params.gray = (params.white+params.black) / 2;
 params.gray = 150;


 
params.pixelSize = Screen('PixelSize', params.w);
[params.width, params.height] = Screen('DisplaySize', params.screenNum); %mm

%params.physical = [params.width, params.height];
%params.physical = [375, 300]; % these hardcoded values from Andi's scripts
params.physical = [524, 293]; % VPixx lab 317

params.resolution = [params.rect(3) params.rect(4)];
params.degperpix = 2*((atan(params.physical./(2*params.viewingDistance))).*(180/pi))./params.resolution;
params.pixperdeg = 1./params.degperpix;
params.frame = FrameRate(params.w);
params.ifi = Screen('GetFlipInterval', params.w);

params.fontSize = 28;
params.fontSpacing = 2;

%% ISI for intersect between performance on seg and int
% using a fixed ISI, not individual threshold

params.calculatedthr = 36; %48.3

%% Timing params


params.ISIframes = params.calculatedthr / (1000 / params.frame); 
params.ISI = 1000 * (params.ifi * params.ISIframes);

params.flipISI = params.ifi * (params.ISIframes - 0.5);

n = 4 %2; % try 1 - 4 .. n = 10-11 gives 100%
params.Display1duration =(8.3 *n); %2 / 180 * 1000; %16 %8.3%params.Display1duration = 2 / 180 * 1000; %41.5 + (8.3 *n); 
params.Display2duration =(8.3 *n); %2 / 180 * 1000; %16 %8.3%params.Display2duration = 2 / 180 * 1000; %41.5 + (8.3 *n); 

params.responseDelay = .5; % in secs (delay between second display and response placeholder)
params.resWinLim = 2.5; % in secs (time limit for ps to respond)

params.ITI = 1000; %msecs
%params.waitDuration=500; %msecs

%params.onsetjitter = 500:1 / 180:1500;
params.onsetjitter = 750:1 / 180:1750;

params.cueDuration = 500; % ms

params.Cueframes = params.cueDuration / (1000 / params.frame);
params.flipCue = params.ifi * (params.Cueframes - .5);

params.Display1frames = params.Display1duration / (1000 / params.frame);

params.flipD1 = params.ifi * (params.Display1frames - .5);
% Default value: 0.0622 s!


params.Display2frames = params.Display2duration / (1000 / params.frame);
params.flipD2 = params.ifi * (params.Display2frames - .5);
% Default value: 0.0622 s!


params.ITIframes = params.ITI / (1000 / params.frame);
params.flipITI = params.ifi * (params.ITIframes - .5);

% params.waitframes=params.waitDuration/(1000/params.frame);
% params.flipWait=params.ifi*(params.waitframes - .5);  

params.Jitterframes = params.onsetjitter / (1000 / params.frame);
params.flipJitter = params.ifi * (params.Jitterframes - .5);

%% stimuli params


% params.dotSize = 2 .* round((params.pixperdeg(1)*(2/3))/2);
params.dotSize = 3.5 .* round((params.pixperdeg(1)*(2/3))/2);

params.stimulusVisualAngle = params.degperpix(1)*params.dotSize;
params.patternSizeVA = params.stimulusVisualAngle*7; %4 circles and 3 spaces
params.fixationSize = params.pixperdeg(1) / 9; %  / 20;% in pixels 
params.fixationVisualAngle = params.degperpix*params.fixationSize;
params.fixationdotplace = [params.x0-(params.fixationSize/2) params.y0-(params.fixationSize/2) params.x0+(params.fixationSize/2) params.y0+(params.fixationSize/2)];
params.fixationcrossplace = [params.x0-(params.fixationSize/2) params.x0+(params.fixationSize/2) params.x0 params.x0; params.y0  params.y0 params.y0-(params.fixationSize/2) params.y0+(params.fixationSize/2)];
params.lineWidth = 3;


params.fixcol = [200 50 50]; 
params.cuecol = [43 129 24]; % physi equilum to red in lab 317 on VPixx monitor, with uplighter at red line
params.stopcol = [0 128 255]; % blue cross for catch trials
params.highlight = params.stopcol; % colour of highlighted square when selecting a square from response probe grid


Screen('BlendFunction', params.w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
KbName('UnifyKeyNames');
if params.enviro == 1 || params.enviro == 2
    HideCursor;
end

% ListenChar(2); 
Priority(MaxPriority(params.w)); %Priority(1);

%% stimuli locations 

% array locations

x0 = params.x0; 
y0 = params.y0;
dotSize = params.dotSize;

% all locations of array
midleft_upR       = [x0-1.5*dotSize y0-3.5*dotSize x0-0.5*dotSize y0-2.5*dotSize];
midleft_midupR    = [x0-1.5*dotSize y0-1.5*dotSize x0-0.5*dotSize y0-0.5*dotSize];
midleft_middownR  = [x0-1.5*dotSize y0+0.5*dotSize x0-0.5*dotSize y0+1.5*dotSize];
midleft_downR     = [x0-1.5*dotSize y0+2.5*dotSize x0-0.5*dotSize y0+3.5*dotSize];

midright_upR      = [x0+0.5*dotSize y0-3.5*dotSize x0+1.5*dotSize y0-2.5*dotSize];
midright_midupR   = [x0+0.5*dotSize y0-1.5*dotSize x0+1.5*dotSize y0-0.5*dotSize];
midright_middownR = [x0+0.5*dotSize y0+0.5*dotSize x0+1.5*dotSize y0+1.5*dotSize];
midright_downR    = [x0+0.5*dotSize y0+2.5*dotSize x0+1.5*dotSize y0+3.5*dotSize];

left_upR          = [x0-3.5*dotSize y0-3.5*dotSize x0-2.5*dotSize y0-2.5*dotSize];
left_midupR       = [x0-3.5*dotSize y0-1.5*dotSize x0-2.5*dotSize y0-0.5*dotSize];
left_middownR     = [x0-3.5*dotSize y0+0.5*dotSize x0-2.5*dotSize y0+1.5*dotSize];
left_downR        = [x0-3.5*dotSize y0+2.5*dotSize x0-2.5*dotSize y0+3.5*dotSize];

right_upR         = [x0+2.5*dotSize y0-3.5*dotSize x0+3.5*dotSize y0-2.5*dotSize];
right_midupR      = [x0+2.5*dotSize y0-1.5*dotSize x0+3.5*dotSize y0-0.5*dotSize];
right_middownR    = [x0+2.5*dotSize y0+0.5*dotSize x0+3.5*dotSize y0+1.5*dotSize];
right_downR       = [x0+2.5*dotSize y0+2.5*dotSize x0+3.5*dotSize y0+3.5*dotSize];

% gathering up locations to form the array

params.StimuliCoords = [left_upR; left_midupR; left_middownR; left_downR; ... 
                        midleft_upR; midleft_midupR; midleft_middownR; midleft_downR; ...
                        midright_upR; midright_midupR; midright_middownR; midright_downR; ...
                        right_upR; right_midupR; right_middownR;right_downR]';




end

