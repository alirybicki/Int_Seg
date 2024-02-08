function [cross] = grab_cross_params(params, cueID)
% grab_cross_params
% check which line making up cross will change colour to cue quadrant,
% grab coords for drawing lines
cueID = 5;

x = params.x0;
y = params.y0;
aboff = ceil(params.fixationSize / 2);
neutips = round(aboff / 2); % if divide by 4 can barely see it

fixcol = params.fixcol;
cuecol = params.cuecol;

% central line one
cross.c1.fromH = x - aboff;
cross.c1.fromV = y - aboff;
cross.c1.toH = x + aboff;
cross.c1.toV = y + aboff;
% central line two
cross.c2.fromH = x - aboff;
cross.c2.fromV = y + aboff;
cross.c2.toH = x + aboff;
cross.c2.toV = y - aboff;
% top left line
cross.tl.fromH = x - (2*aboff);
cross.tl.fromV = y - (2*aboff);
cross.tl.toH = x - aboff;
cross.tl.toV = y - aboff;
% top right line
cross.tr.fromH = x + aboff;
cross.tr.fromV = y - aboff;
cross.tr.toH = x + (2*aboff);
cross.tr.toV = y - (2*aboff);
% bottom left line
cross.bl.fromH = x - (2*aboff);
cross.bl.fromV = y + (2*aboff);
cross.bl.toH = x - aboff;
cross.bl.toV = y + aboff;
% bottom right line
cross.br.fromH = x + aboff;
cross.br.fromV = y + aboff;
cross.br.toH = x + (2*aboff);
cross.br.toV = y + (2*aboff);

% set all arms of cross to fixation colour
cross.c1.col = fixcol;
cross.c2.col = fixcol;
cross.tl.col = fixcol;
cross.tr.col = fixcol;
cross.bl.col = fixcol;
cross.br.col = fixcol;
% change one if cueing now
if cueID == 1
    cross.tl.col = cuecol;
elseif cueID == 2
    cross.bl.col = cuecol;
elseif cueID == 3
    cross.tr.col = cuecol;
elseif cueID == 4
    cross.br.col = cuecol;
    %     else do nothing (for fixation/neutral cue cross)
end

% sizes and colouring both slightly diff for neutral cue - all four smaller tips of arms turn green
if cueID == 5
    % colour
    cross.c1.col = fixcol;
    cross.c2.col = fixcol;
    cross.tl.col = cuecol;
    cross.tr.col = cuecol;
    cross.bl.col = cuecol;
    cross.br.col = cuecol;
    % central line one
    cross.c1.fromH = x - (2*aboff);
    cross.c1.fromV = y - (2*aboff);
    cross.c1.toH = x + (2*aboff);
    cross.c1.toV = y + (2*aboff);
    % central line two
    cross.c2.fromH = x - (2*aboff);
    cross.c2.fromV = y + (2*aboff);
    cross.c2.toH = x + (2*aboff);
    cross.c2.toV = y - (2*aboff);
    % top left line
    cross.tl.fromH = x - (2*aboff);
    cross.tl.fromV = y - (2*aboff);
    cross.tl.toH = x - (2*aboff) + neutips;
    cross.tl.toV = y - (2*aboff) + neutips;
    % top right line
    cross.tr.fromH = x + (2*aboff) - neutips;
    cross.tr.fromV = y - (2*aboff) + neutips;
    cross.tr.toH = x + (2*aboff);
    cross.tr.toV = y - (2*aboff);
    % bottom left line
    cross.bl.fromH = x - (2*aboff);
    cross.bl.fromV = y + (2*aboff);
    cross.bl.toH = x - (2*aboff) + neutips;
    cross.bl.toV = y + (2*aboff) - neutips;
    % bottom right line
    cross.br.fromH = x + (2*aboff) - neutips;
    cross.br.fromV = y + (2*aboff) - neutips;
    cross.br.toH = x + (2*aboff);
    cross.br.toV = y + (2*aboff);
end



end

