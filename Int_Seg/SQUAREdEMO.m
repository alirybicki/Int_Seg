

% Unify the keyboard names for mac and pc
KbName('UnifyKeyNames');
commandwindow
% The avaliable keys to press
upKey = KbName('UpArrow');
downKey = KbName('DownArrow');
leftKey = KbName('LeftArrow');
rightKey = KbName('RightArrow');
selectKey = KbName('Space')

% Set the amount we want our square to move on each button press
pixelsPerPress = 10;
screenXpixels = 1920;
screenYpixels = 1080;

% Loop the animation until the escape key is pressed
while 1

    % Check the keyboard to see if a button has been pressed
    [keyIsDown,secs, keyCode] = KbCheck;

    if keyCode(leftKey)
        mouse_x = mouse_x - pixelsPerPress;
    elseif keyCode(rightKey)
        mouse_x = mouse_x + pixelsPerPress;
    elseif keyCode(upKey)
        mouse_y = mouse_y - pixelsPerPress;
    elseif keyCode(downKey)
        mouse_y = mouse_y + pixelsPerPress;
    end

    % We set bounds to make sure our square doesn't go completely off of
    % the screen
    if mouse_x < 0
        mouse_x = 0;
    elseif mouse_x > screenXpixels
        mouse_x = screenXpixels;
    end

    if mouse_y < 0
        mouse_y = 0;
    elseif mouse_y > screenYpixels
        mouse_y = screenYpixels;
    end


end


