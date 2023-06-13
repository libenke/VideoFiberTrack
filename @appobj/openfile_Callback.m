function h= openfile_Callback(h)
     [fname,pname] = uigetfile({'*.avi','avi(*.avi)';'*.mp4','mp4(*.mp4)';'*.*','All Files (*.*)'},'Select the .avi videos');
     if ~ischar(fname)
         return
     end
     fname=fullfile(pname,fname);
     vd_new=videoobj(fname);
     if isempty(h.vd)
         h.vd{1}=vd_new;
     else
         h.vd{numel(h.vd)+1}=vd_new;
     end
     h.vdlist.Value=numel(h.vd);
     h.curr_video=numel(h.vd);
     h.vdlist_Callback;
     disp(vd_new.Name);
    
     [~,videoname,~]=fileparts(fname);
    disp('start loading result data');
    res_file = fullfile(pname,videoname+".mat");
    if exist(res_file)
        s=load(res_file);
        GF_struct=table2struct(s.GF_table);
        h.vd{h.curr_video}.GF_struct=GF_struct;
        h.vd{h.curr_video}.update_disp_info;
        disp('complete loading result data');
    end
end