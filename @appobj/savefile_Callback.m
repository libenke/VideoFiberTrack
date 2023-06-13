function h = savefile_Callback(h)
     curr_vd=h.vd{h.curr_video};
     [~,video_name,~]=fileparts(curr_vd.Name);
     fname=fullfile(curr_vd.Path,strcat(video_name,'.mat'));
     
     [fname, pname] = uiputfile('*.mat', 'Save result as',fname);
     if ~ischar(fname)
         return
     end
     filename=fullfile(pname,fname);
     save_result(curr_vd,filename);
     disp(strcat('succeed saving:',fname));
end

