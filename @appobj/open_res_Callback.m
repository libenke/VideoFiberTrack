function [ h ] = open_res_Callback( h )
    if isempty(h.vd)
        return
    end
    curr_video=h.curr_video;
    [namestr,pathstr,~]=uigetfile('*.mat');
    disp('start loading result data');
    s=load(fullfile(pathstr,namestr));
    GF_struct=table2struct(s.GF_table);
    h.vd{curr_video}.GF_struct=GF_struct;
    h.vd{curr_video}.update_disp_info;
    disp('complete loading result data');
end

