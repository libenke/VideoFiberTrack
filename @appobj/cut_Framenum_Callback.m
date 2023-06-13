function [ h ] = cut_Framenum_Callback( h )
     a=str2num(h.Frame_num_tobe_cut.String);
     gf_n=str2num(h.Plot_gf_res.String);
     if isempty(gf_n)
         return
     end
     if numel(a)~=2 || a(1)>a(2) 
         msgbox('wrong Frame number');
         return;
     end
    vd=h.vd{h.curr_video};
    GF_struct=vd.GF_struct;
    if gf_n>numel(GF_struct) || gf_n<1
        disp('GF number wrong');
        return
    end
     frame_nums=cell2mat({GF_struct(gf_n).track_result(:).FrameNum});
     k=find(frame_nums>a(2)|frame_nums<a(1));
     if isempty(k)
         msgbox('no record is cut');
     else
         vd.GF_struct(gf_n).track_result(k)=[];
         vd.disp_line_info(1:a(1),gf_n,:)=nan;
         vd.disp_line_info(a(2):end,gf_n,:)=nan;
         %vd.disp_line_info(k',gf_n,:)=nan;
         vd.disp_lines(h.b_axes);
         h.Plot_gf_result_Callback;
         h.Frame_num_tobe_cut.String='';
     end

     
end

