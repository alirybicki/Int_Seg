function data = saveBlock(params, result, clickPos, performance, MET, odd, tmeasure, missing, dispIdenti, cueIdenti, cuePos)

EndTime = GetSecs;

if params.blocknr == 0
    data=[];
    % release pressure
    ShowCursor;
    Priority(0)
    %ListenChar(0);
    Screen ('Close');
    Screen('CloseAll');
    
elseif params.blocknr>0
    
    if params.blocknr > 1
        load (params.fileName, 'data')
    end
    
    data(params.blocknr).subID              = params.subjectID;
    data(params.blocknr).blockNr            = params.blocknr;
    
    data(params.blocknr).trials             = 1:params.nTrials;
    data(params.blocknr).blockTime          =(EndTime-params.expStart)/60;
    
    data(params.blocknr).condition          = [params.condition(1:params.nTrials)]; % this refers to task version
    
    data(params.blocknr).stimCond           = dispIdenti;
    data(params.blocknr).segTar             = dispIdenti(:,8);
    data(params.blocknr).intTar             = dispIdenti(:,16);
    data(params.blocknr).cueCond            = cueIdenti; % val/inv/neu
    data(params.blocknr).cueType            = cuePos; % 1,2,3,4 or neu
    
    data(params.blocknr).resId              = result; % whether they clicked on missing arc, missing circle, element from D1, or from D2
    data(params.blocknr).resLoc             = clickPos; % which position on the grid they clicked (1 to 16)
    data(params.blocknr).correct            = performance;
    
    data(params.blocknr).m                  = missing;
    
    
    data(params.blocknr).stimCondCLEAN      = data(params.blocknr).stimCond(data(params.blocknr).m~=2);
    data(params.blocknr).segTarCLEAN        = data(params.blocknr).segTar(data(params.blocknr).m~=2);
    data(params.blocknr).intTarCLEAN        = data(params.blocknr).intTar(data(params.blocknr).m~=2);
    data(params.blocknr).cueCondCLEAN       = data(params.blocknr).cueCond(data(params.blocknr).m~=2);
    data(params.blocknr).cueTypeCLEAN       = data(params.blocknr).cueType(data(params.blocknr).m~=2);
    data(params.blocknr).resIdCLEAN         = data(params.blocknr).resId(data(params.blocknr).m~=2);
    data(params.blocknr).resLocCLEAN        = data(params.blocknr).resLoc(data(params.blocknr).m~=2);
    data(params.blocknr).correctCLEAN       = data(params.blocknr).correct(data(params.blocknr).m~=2);
    
    data(params.blocknr).droppedTrials      = (length(data(params.blocknr).correct)-length(data(params.blocknr).correctCLEAN))/length(data(params.blocknr).correct);
    data(params.blocknr).MET                = MET;
    data(params.blocknr).odd                = odd;
    
    data(params.blocknr).tmeasure           = tmeasure;
    data(params.blocknr).LRFLag           = params.LRFlag;
    %     if params.blocknr == 1
    %         eval(['save ./data/' params.fileName '.mat', ' data']);
    %         eval(['save ./data/params/' params.fileName '_params.mat', ' params']);
    
    %             save (params.fileName, 'data')
    %     else
    %         eval (['load ./data/' params.fileName '.mat']);
    %         load (params.fileName, 'data')
    %
    %     end
    
    %         data(params.blocknr).subID=params.subjectID;
    %         data(params.blocknr).blockNr=params.blocknr;
    %         data(params.blocknr).trials=1:params.nTrials;
    %         data(params.blocknr).blockTime=(EndTime-params.expStart)/60;
    %
    %         data(params.blocknr).condition=[params.condition(1:params.nTrials)];
    %
    %         data(params.blocknr).stimCond = dispIdenti;
    %         data(params.blocknr).segTar = dispIdenti(:,8);
    %         data(params.blocknr).intTar = dispIdenti(:,16);
    %         data(params.blocknr).cueCond = cueIdenti; % val/inv/neu
    %         data(params.blocknr).cueType = cuePos; % 1,2,3,4 or neu
    %
    %
    %         data(params.blocknr).response=result;
    %         data(params.blocknr).correct=performance;
    %
    %         data(params.blocknr).m=missing; % 2 = timing error
    %
    %         data(params.blocknr).responseCLEAN=data(params.blocknr).response(data(params.blocknr).m~=2);
    %         data(params.blocknr).correctCLEAN=data(params.blocknr).correct(data(params.blocknr).m~=2);
    %
    %         data(params.blocknr).droppedTrials=(length(data(params.blocknr).correct)-length(data(params.blocknr).correctCLEAN))/length(data(params.blocknr).correct);
    %         data(params.blocknr).MET=MET;
    %         data(params.blocknr).odd=odd;
    %
    %         data(params.blocknr).tmeasure=tmeasure;
    
    
    %         eval(['save ./data/' params.fileName '.mat', ' data']);
    
    
    
    cd('L:\rybickia\HALO_2\Int_Seg\data')
    save (params.fileName, 'data')
    cd('L:\rybickia\HALO_2\Int_Seg')
    
    
    
end




