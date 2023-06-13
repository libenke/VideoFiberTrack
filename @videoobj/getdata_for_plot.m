function [res_for_plot] = getdata_for_plot( h )
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %remove the untracked GF;
      n=numel(h.GF_struct);
      to_be_delete=false(n,1);
      for i=1:n
          to_be_delete=numel(h.GF_struct(i).track_result)==1;
      end
      h.GF_struct(to_be_delete)=[];
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %skip the new added GF;
      GF_struct=h.GF_struct;
      n=numel(GF_struct);
      gf_tracked=true(n,1);
      for i=1:n
          gf_tracked(i)=numel(GF_struct(i).track_result)>1;
      end
     GF_struct_tracked=GF_struct(gf_tracked);
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %matrix including:
     %FrameNum_angle  FrameNum_ x  FrameNum_y 
     n=numel(GF_struct_tracked);
     Frame_angle=(nan(h.NumberOfFrames,n));
     Frame_x=nan(h.NumberOfFrames,n);
     Frame_y=nan(h.NumberOfFrames,n);
     fiberind_length=zeros(n,1);
     for i=1:n
          track_res=(struct2table(GF_struct_tracked(i).track_result(1:end)));
          frame_num=track_res.FrameNum;
          centerpoint=int16(track_res.centerpoint_in_image);
          angle=int16(track_res.angle);
          Frame_angle(frame_num,i)=angle;
          Frame_x(frame_num,i)=int16(centerpoint(:,1));
          Frame_y(frame_num,i)=int16(centerpoint(:,2));
          fiberind_length(i)=int16(norm(GF_struct_tracked(i).start_endpoint1-GF_struct_tracked(i).start_endpoint2));
     end
     %reduce the Frame Number
     Frame_angle=Frame_angle(1:4:end,:);
     Frame_x=Frame_x(1:4:end,:);
     Frame_y=Frame_y(1:4:end,:);
     %adjust the angle 
     Frame_angle=mod(Frame_angle,180);
     res_for_plot.Frame_angle=Frame_angle;
     res_for_plot.Frame_x=Frame_x;
     res_for_plot.Frame_y=Frame_y;
     res_for_plot.fiberind_length=fiberind_length;
     h.res_for_plot=res_for_plot;
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

