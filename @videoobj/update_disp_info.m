function h = update_disp_info(h)
      %update the h.GF_struct
      if isempty(h.GF_struct)
          return
      end
      
      %
      %update the h.disp_line_info
      n=numel(h.GF_struct);
      to_be_delete=false(n,1);
      for i=1:n
          to_be_delete(i)=numel(h.GF_struct(i).track_result)==1;
      end
      h.GF_struct(to_be_delete)=[];
      
      gf_struct=h.GF_struct;
      n=numel(gf_struct);
      gf_tracked=true(n,1);
      for i=1:n
          gf_tracked(i)=numel(gf_struct(i).track_result)>1;
      end
      gf_struct=gf_struct(gf_tracked);
      n=numel(gf_struct);
      if n==0
          msgbox('no GF has been tracked');
          return
      end
      h.disp_line_info=int16(zeros(h.NumberOfFrames,n,4));
      for i=1:n
          track_res=(struct2table(gf_struct(i).track_result(1:end)));
          frame_num=track_res.FrameNum;
          endpoint1=track_res.endpoint1;
          endpoint2=track_res.endpoint2;
          h.disp_line_info(frame_num,i,1)=endpoint1(:,1);
          h.disp_line_info(frame_num,i,2)=endpoint1(:,2);
          h.disp_line_info(frame_num,i,3)=endpoint2(:,1);
          h.disp_line_info(frame_num,i,4)=endpoint2(:,2);
      end
end