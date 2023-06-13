function GF_struct= save_result(h,fname)
     if ~exist('fname','var')
         fname=fullfile(h.Path,h.Name);
     end
     [pathstr,video_name,~]=fileparts(fname);
     fname=fullfile(pathstr,strcat(video_name,'.mat'));
%      if exist(fname,'file')
%          video_name=strcat(video_name,'_01');
%          while exist(fullfile(pathstr,strcat(video_name,'.mat')),'file')
%              strlen=strlength(video_name);
%              n=str2num(video_name(strlen-1:strlen))+1;
%              video_name(strlen-1:strlen)=num2str(n,'%02d');
%          end
%      end
%     fname=fullfile(pathstr,strcat(video_name,'.mat'));
     %h=h.update_disp_info;
     %res=GF_table.track_result;
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     GF_struct=h.GF_struct;
     if isempty(GF_struct)
         disp(['warning, the GF_struct is empty']);
         disp(h.Name);
         return
     end
     GF_table=struct2table(GF_struct);
     save(fname,'GF_table');
end

