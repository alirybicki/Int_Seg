function KeyPressFcnTest
      close all;
      h = figure;
      set(h,'WindowKeyPressFcn',@KeyPressFcn);
      function KeyPressFcn(~,evnt)
          fprintf('key event is: %s\n',evnt.Key);
      end
end