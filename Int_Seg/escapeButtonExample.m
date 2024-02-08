function escapeButtonExample

% Create a figure and set its KeyPressFcn
    f = figure('KeyPressFcn', @keyPressed);
    
    % Run a loop until the Escape key is pressed
    while true
        % Do some processing here
        
        % Check if the Escape key was pressed
        if getappdata(f, 'escapePressed')
            disp('Escape key pressed. Exiting the loop.');
            break;
        end
    end
    
    % Delete the figure and clear appdata
    delete(f);
    rmappdata(f, 'escapePressed');
    
    % Function to handle key press event
    function keyPressed(~, event)
        if strcmp(event.Key, 'escape')
            setappdata(f, 'escapePressed', true);
        end
    end
end
