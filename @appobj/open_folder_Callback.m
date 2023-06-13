function [ h ] = open_folder_Callback( h )
     [pathstr] = uigetdir();
     if ~ischar(pathstr)
         return
     end
     video_info_fname=fullfile(pathstr,'video_info.xls');
     if ~exist(video_info_fname,'file')
         disp('warning: can not find video_info.xls');
         h.video_info=table;
     else
         h.video_info=readtable(video_info_fname);
     end
     a=dir(pathstr);
     a(1:2)=[];
     asplit=cellfun(@(x) strsplit(x,'.'), {a(:).name},'UniformOutput',false);
     avimask=~cellfun(@(x) strcmpi(x{end},'avi'),asplit)| cell2mat({a(:).isdir});
     a(avimask)=[];
     n_fail=0;
     n_cucess=0;
     fname_fail={};
     for i=1:numel(a)
%          try
             %loading avi video
             vd_new=videoobj(fullfile(a(i).folder,a(i).name));
             %loading result
             [~,videoname,~]=fileparts(a(i).name);
             res_fullname=fullfile(a(i).folder,strcat(videoname,'.mat'));
             if ~exist(res_fullname,'file')
                 disp('warning:can not find results to load:');
                 disp(a(i).name);
             else
                 try
                     s=load(res_fullname,'GF_table');
                     GF_struct=table2struct(s.GF_table);
                     vd_new.GF_struct=GF_struct;
                 catch
                     disp('warning:can not find GF_table in the file:');
                     disp(a(i).name);
                 end
             end
             % add new video to the app 
             if isempty(h.vd)
                 h.vd=vd_new;
             else
                 h.vd{end+1}=vd_new;
             end
             h.vdlist.Value=numel(h.vd);
             h.curr_video=h.vdlist.Value;
             n_cucess=n_cucess+1;
%          catch
%              n_fail=n_fail+1;
%              fname_fail{end+1}=a(i).name;
%          end
         h.vdlist_Callback;
         [i]
     end
     %
     disp(['complete loading  ',num2str(n_cucess),'  avi video']);
     disp(['fail loading  ',num2str(n_fail),'  avi video']);
     cellfun(@(x) disp(x),fname_fail);
end

