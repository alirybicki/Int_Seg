function [params, wPtrDots1, wPtrDots2, wPtrISI, wPtrGray, wPtrGrayFix, cueType] = mtargets(params,trial)


%%

[wPtrDots1]=Screen('MakeTexture', params.w, repmat(params.gray,params.resolution(2),params.resolution(1))); % first array
[wPtrDots2]=Screen('MakeTexture', params.w, repmat(params.gray,params.resolution(2),params.resolution(1))); % second array
[wPtrISI]=Screen('MakeTexture', params.w, repmat(params.gray,params.resolution(2),params.resolution(1))); % grey array for disp for ISI


[wPtrGray]=Screen('MakeTexture', params.w, repmat(params.gray,params.resolution(2),params.resolution(1)));
[wPtrGrayFix]=Screen('MakeTexture', params.w, repmat(params.gray,params.resolution(2),params.resolution(1)));


Screen('DrawLines', wPtrGrayFix, params.fixationcrossplace, 5, params.fixcol);

%%
    params.thisTrlVect = params.stimCond(trial,:);
    thisTrlCoords = params.StimuliCoords(:, params.thisTrlVect);
    
    params.dotRect1 = (thisTrlCoords(:,1:7));
    params.dotRect2 = (thisTrlCoords(:,9:15));
    params.odd = (thisTrlCoords(:,8));
    params.MET = (thisTrlCoords(:,16));

    params.contrast = [params.gray/2 params.gray/2 params.gray/2]; 
   

%%   
  openangle = 45;
  penwidth = 5;
  
  % these angles correspond for arc one and arc two to form a circle
  
  StartAngle1 = [0+openangle/2,0-openangle/2, ...
      45+openangle/2,45-openangle/2, ...
      90+openangle/2,90-openangle/2, ...
      135+openangle/2,135-openangle/2, ... 
      180+openangle/2, 180-openangle/2, ...
      225+openangle/2, 225-openangle/2, ... 
      270+openangle/2, 270-openangle/2, ... 
      315+openangle/2, 315-openangle/2];
  
  StartAngle2 = [180+openangle/2,180-openangle/2, ...
      225+openangle/2,225-openangle/2, ...
      270+openangle/2,270-openangle/2, ...
      315+openangle/2,315-openangle/2, ... 
      0+openangle/2, 0-openangle/2, ...
      45+openangle/2, 45-openangle/2, ... 
      90+openangle/2, 90-openangle/2, ... 
      135+openangle/2, 135-openangle/2];
  
  xodd = randi(8);
  
  x1 = randi(8);
  x2 = randi(8);
  x3 = randi(8);
  x4 = randi(8);
  x5 = randi(8);
  x6 = randi(8);
  x7 = randi(8);
  x8 = randi(8);
  x9 = randi(8);
  x10 = randi(8);
  x11 = randi(8);
  x12 = randi(8);
  x13 = randi(8);
  x14 = randi(8);
  
%   Screen('FillRect', wPtrDots1, params.black, [200 20 300 120])
%   Screen('FillRect', wPtrDots2, params.black, [200 20 300 120])
%   Screen('FillRect', wPtrISI, params.white, [200 20 300 120])
  

  % Arcs for the odd cases (missing arcs, missing circles)  

  Screen('FrameArc',wPtrDots1,params.contrast, params.odd(:,1), StartAngle1(xodd),180-openangle, penwidth)
  Screen('FrameArc',wPtrDots2,params.contrast, params.odd(:,1),StartAngle2(xodd),180-openangle, penwidth)
  
  Screen('FrameArc',wPtrDots1,params.contrast, params.dotRect1(:,1), StartAngle1(x1),180-openangle, penwidth)
  Screen('FrameArc',wPtrDots1,params.contrast, params.dotRect1(:,1),StartAngle2(x1),180-openangle, penwidth)
  
  % all the others
  
  Screen('FrameArc',wPtrDots1,params.contrast, params.dotRect1(:,2), StartAngle1(x2),180-openangle, penwidth)
  Screen('FrameArc',wPtrDots1,params.contrast, params.dotRect1(:,2),StartAngle2(x2),180-openangle, penwidth)
  Screen('FrameArc',wPtrDots1,params.contrast, params.dotRect1(:,3), StartAngle1(x3),180-openangle, penwidth)
  Screen('FrameArc',wPtrDots1,params.contrast, params.dotRect1(:,3),StartAngle2(x3),180-openangle, penwidth)
  Screen('FrameArc',wPtrDots1,params.contrast, params.dotRect1(:,4), StartAngle1(x4),180-openangle, penwidth)
  Screen('FrameArc',wPtrDots1,params.contrast, params.dotRect1(:,4),StartAngle2(x4),180-openangle, penwidth)
  Screen('FrameArc',wPtrDots1,params.contrast, params.dotRect1(:,5), StartAngle1(x5),180-openangle, penwidth)
  Screen('FrameArc',wPtrDots1,params.contrast, params.dotRect1(:,5),StartAngle2(x5),180-openangle, penwidth)
  Screen('FrameArc',wPtrDots1,params.contrast, params.dotRect1(:,6), StartAngle1(x6),180-openangle, penwidth)
  Screen('FrameArc',wPtrDots1,params.contrast, params.dotRect1(:,6),StartAngle2(x6),180-openangle, penwidth)
  Screen('FrameArc',wPtrDots1,params.contrast, params.dotRect1(:,7), StartAngle1(x7),180-openangle, penwidth)
  Screen('FrameArc',wPtrDots1,params.contrast, params.dotRect1(:,7),StartAngle2(x7),180-openangle, penwidth)
  
  Screen('FrameArc',wPtrDots2,params.contrast, params.dotRect2(:,1), StartAngle1(x8),180-openangle, penwidth)
  Screen('FrameArc',wPtrDots2,params.contrast, params.dotRect2(:,1),StartAngle2(x8),180-openangle, penwidth)
  Screen('FrameArc',wPtrDots2,params.contrast, params.dotRect2(:,2), StartAngle1(x9),180-openangle, penwidth)
  Screen('FrameArc',wPtrDots2,params.contrast, params.dotRect2(:,2),StartAngle2(x9),180-openangle, penwidth)
  Screen('FrameArc',wPtrDots2,params.contrast, params.dotRect2(:,3), StartAngle1(x10),180-openangle, penwidth)
  Screen('FrameArc',wPtrDots2,params.contrast, params.dotRect2(:,3),StartAngle2(x10),180-openangle, penwidth)
  Screen('FrameArc',wPtrDots2,params.contrast, params.dotRect2(:,4), StartAngle1(x11),180-openangle, penwidth)
  Screen('FrameArc',wPtrDots2,params.contrast, params.dotRect2(:,4),StartAngle2(x11),180-openangle, penwidth)
  Screen('FrameArc',wPtrDots2,params.contrast, params.dotRect2(:,5), StartAngle1(x12),180-openangle, penwidth)
  Screen('FrameArc',wPtrDots2,params.contrast, params.dotRect2(:,5),StartAngle2(x12),180-openangle, penwidth)
  Screen('FrameArc',wPtrDots2,params.contrast, params.dotRect2(:,6), StartAngle1(x13),180-openangle, penwidth)
  Screen('FrameArc',wPtrDots2,params.contrast, params.dotRect2(:,6),StartAngle2(x13),180-openangle, penwidth)
  Screen('FrameArc',wPtrDots2,params.contrast, params.dotRect2(:,7), StartAngle1(x14),180-openangle, penwidth)
  Screen('FrameArc',wPtrDots2,params.contrast, params.dotRect2(:,7),StartAngle2(x14),180-openangle, penwidth) 
  
  %% cue

cueType = params.cueID(trial);

params.thisTrlCuePos = cueType;
