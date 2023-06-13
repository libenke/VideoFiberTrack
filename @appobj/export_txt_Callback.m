function [ h ] = export_txt_Callback( h )
    if isempty(h.vd)
        return
    end
    curr_video=h.curr_video;
    pathstr=uigetdir();
    if ~ischar(pathstr)
        return
    end
    h.vd{curr_video}.export_txt(pathstr);
    disp('export txt succeed');
end

