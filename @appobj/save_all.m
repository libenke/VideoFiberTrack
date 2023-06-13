function [ h ] = save_all( h )
       h.vd{~isvalid(h.vd{:})}=[];
       if isempty(h.vd)
           return
       end
       for i=1:numel(h.vd)
           h.vd{i}.save_result;
           i
       end
       disp(['complete saving ',num2str(i),' results.' ])
       fullfilename=fullfile(h.vd{1}.Path,'video_info.xls');
       video_info=h.video_info;
       writetable(video_info,fullfilename)
end

