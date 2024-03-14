function Cal_Velocity_Field(pathstr)
     if ~exist('pathstr','var')
          [pathstr] = uigetdir();
     end
     if ~ischar(pathstr)
         return
     end
     filenames=dir(pathstr);
     filenames(1:2)=[];
     asplit=cellfun(@(x) strsplit(x,'.'), {filenames(:).name},'UniformOutput',false);
     avimask=~cellfun(@(x) strcmpi(x{end},'avi'),asplit)| cell2mat({filenames(:).isdir});
     avis=filenames(~avimask);
     res_folder={};
     video_info={};
     for i=1:numel(avis)
         vdobj(i)=VideoReader(fullfile(avis(i).folder,avis(i).name));
         [~,s2,~]=fileparts(avis(i).name);
         res_folder{i}=fullfile(avis(i).folder,s2);
         if ~exist(res_folder{i},'dir')
             mkdir(res_folder{i});
         end
         video_info_fname=fullfile(res_folder{i},'video_info.txt');
         if ~exist(video_info_fname,'file')
             msgbox('can not find video_info.txt');
             keyboard;
         else
             t=readtable(video_info_fname,'ReadRowNames',true);
             video_info(i).start_frame=t{'start_frame','Value'};
             video_info(i).end_frame=t{'end_frame','Value'};
             video_info(i).gap=t{'gap','Value'};
             video_info(i).y_upper=t{'y_upper','Value'};
             video_info(i).y_lower=t{'y_lower','Value'};
             video_info(i).skip=t{'skip','Value'};
         end
     end
     for j=1:numel(vdobj)
         framesnum=vdobj(j).NumberOfFrames;
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         %start_frame=video_info(j).start_frame;
         start_frame=1;
         end_frame=video_info(j).end_frame;
         if end_frame>framesnum
             disp('warning,end frame wrong');
             disp(vdobj(j).Name);
             end_frame=framesnum;
         end
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         gap=video_info(j).gap;
         y_upper=video_info(j).y_upper;
         y_lower=video_info(j).y_lower;
         skip=video_info(j).skip;
         height=vdobj(j).Height;
         width=vdobj(j).Width;
         length_per_pixel=gap/(y_lower-y_upper);%unit is ¦Ìm
         time_per_frame=(skip+1)/90;
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         y_max_d=3;% y_max_d=(reference box height-sample box length)/2
         x_max_d=17;%x_max_d=initial (reference box width-sample box length)/2
         box_length_y=24;%box_length_y must be divided by 4
         box_length_x=32;%
         y_box_min=(y_upper+y_max_d:6:y_lower-box_length_y-y_max_d)';
         x_box_min=(21:6:width-box_length_x-21);
         y_box_num=numel(y_box_min);
         x_box_num=numel(x_box_min);
         
         y_box_min=repmat(y_box_min,[1,x_box_num]);
         x_box_min=repmat(x_box_min,[y_box_num,1]);
         
         res_dx=single(zeros(y_box_num*x_box_num,end_frame));
         res_dy=single(zeros(y_box_num*x_box_num,end_frame));
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         vd=vdobj(j);
         videoframes=repmat(uint8(zeros(vd.height,vd.width)),[1,1,vd.NumberOfFrames]);
         tic
         for i=1:vd.NumberOfFrames
             I=read(vd,i);
             videoframes(:,:,i)=I(:,:,1);
         end
         [toc]
         for i=1:numel(y_box_min)
             tic
             [dy,dx]=PTV_correlate(y_box_min(i),x_box_min(i),box_length_x,box_length_y,videoframes,...
                                 start_frame,end_frame,y_max_d,x_max_d);
             [res_i, res_j]=ind2sub([y_box_num,x_box_num],i);
             [res_i, res_j, toc]
             if res_i==2&& res_j==3
                 keyboard;
             end
             res_dx(i,:)=single(dx);
             res_dy(i,:)=single(dy);
         end
         %calculate the velocity, the unit is ¦Ìm 
         res_xv=reshape(res_dx,[y_box_num,x_box_num,end_frame]).*single((length_per_pixel./time_per_frame));
         res_dx=[];
         res_yv=reshape(res_dy,[y_box_num,x_box_num,end_frame]).*single((length_per_pixel./time_per_frame));
         res_dy=[];
         %calculate the velocity for v_y, y should be normalized
         sample_interval=round((end_frame-start_frame)/30);
         average_num=100;
         sample_center_frame=start_frame+10+average_num/2:sample_interval:...
                                           end_frame-10-average_num/2;
         sample_center_time=round((sample_center_frame-start_frame).*time_per_frame);
         for i=1:numel(sample_center_frame)
             temp=mean(res_xv(:,:,sample_center_frame-average_num/2:...
                                              sample_center_frame+average_num/2),3);
             v_y(:,i)=mean(temp,2,'omitnan');
         end
         y_normalized=(y_box_min(:,1)+y_max_d-y_box_min(1,1))...
                               /(y_box_min(end,1)-y_box_min(1,1));
         t=[y_normalized,v_y];
         t=array2table(t,'VariableNames',cellstr(['y',(string('time')+sample_center_time)]));
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         fullfoutput_dx=fullfile(res_folder{j},'xv.mat');
         fullfoutput_dy=fullfile(res_folder{j},'yv.mat');
         fullfoutput_v_y=fullfile(res_folder{j},'v_y.xls');
         save(char(fullfoutput_dx),'res_xv');
         save(char(fullfoutput_dy),'res_yv');
         writetable(t,char(fullfoutput_v_y));
     end
end

function [dy,dx]=PTV_correlate(y_box_min,x_box_min,box_length_x,box_length_y,videoframes,...
                                 start_frame,end_frame,y_max_d,x_max_d)
        %parameters
        res_n=0;
        x_gap_after_stable=4;%the x gap after stable
        stable_res_number=30;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Allocate memory space first;
        sample=zeros(box_length_y,box_length_x);
        dx=zeros(end_frame,1);
        dy=zeros(end_frame,1);
        % at bigginning, use this:
        res_num1=(2*x_max_d+1)*(2*y_max_d+1);
        ref_num1=(box_length_y+2*y_max_d)*(box_length_x+2*x_max_d);
        bb_cell_1_mask=repmat({false(ref_num1,1)},[1,res_num1]);
        for i=1:res_num1
            [bi,bj]=ind2sub([2*y_max_d+1,2*x_max_d+1],i);
            I_ref_mask_1=false(box_length_y+2*y_max_d,box_length_x+2*x_max_d);
            I_ref_mask_1(bi:bi+box_length_y-1,bj:bj+box_length_x-1)=true;
            bb_cell_1_mask{:,i}=I_ref_mask_1(:);
        end
        
        %when the data is stable,use this:
        res_num2=(2*x_gap_after_stable+1)*(2*y_max_d+1);
        ref_num2=(box_length_y+2*y_max_d)*(box_length_x+2*x_gap_after_stable);
        bb_cell_2_mask=repmat({false(ref_num2,1)},[1,res_num2]);
        for i=1:res_num2
            [bi,bj]=ind2sub([2*y_max_d+1,2*x_gap_after_stable+1],i);
            I_ref_mask_2=false(box_length_y+2*y_max_d,box_length_x+2*x_gap_after_stable);
            I_ref_mask_2(bi:bi+box_length_y-1,bj:bj+box_length_x-1)=true;
            bb_cell_2_mask{:,i}=I_ref_mask_2(:);
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        for i=start_frame+1:end_frame
            I=videoframes(:,:,i-1);
            I=double(I(:,:,1));
            I_ref=videoframes(:,:,i);
            I_ref=double(I_ref(:,:,1));
            sample=I(y_box_min:y_box_min+box_length_y-1,x_box_min:x_box_min+box_length_x-1);
            %calculate ref box;
            if res_n<stable_res_number
                dx_mean=0;
                d=x_max_d;
            else
                dx_mean=round(mean(dx(res_n-10:res_n)));
                d=x_gap_after_stable;
            end
            xminRef=x_box_min+dx_mean-d;
            xmaxRef=x_box_min+box_length_x-1+dx_mean+d;
            yminRef=y_box_min-y_max_d;
            ymaxRef=y_box_min+box_length_y-1+y_max_d;
            if yminRef>0&&ymaxRef<size(I_ref,1)&&xminRef>0&&xmaxRef<size(I_ref,2)
                f=double(I_ref(yminRef:ymaxRef,xminRef:xmaxRef));
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                if res_n<stable_res_number
                    bb_res=cellfun(@(x1) sum(sum(corrcoef(f(x1),sample(:))))/2-1,bb_cell_1_mask);
                else
                    bb_res=cellfun(@(x1) sum(sum(corrcoef(f(x1),sample(:))))/2-1,bb_cell_2_mask);
                end
                 
                b=reshape(bb_res,[2*y_max_d+1,2*d+1]);
                [~,imax]=max(b(:));
                [ypeak,xpeak]=ind2sub(size(b),imax(1));

                dy(i)=ypeak-(y_max_d+1); %y_max_d+box_length_y is the centerpoint of cc
                dx(i)=xpeak-(d+1)+dx_mean; % movement per frame (in pixel)
                res_n=res_n+1;
            else
                dx=nan;
                dy=nan;
                return
            end
        end
    %     plot(dx(:,j));figure;plot(displacement(:,j));
    end