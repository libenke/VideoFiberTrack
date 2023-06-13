function [ h ] = Plot_gf_result_Callback( h )
    gf_n=str2double(h.Plot_gf_res.String);
    if isempty(gf_n)
        return
    end
    vd=h.vd{h.curr_video};
    GF_struct=vd.GF_struct;
    ax=h.p_axes;
    if gf_n>numel(GF_struct) || gf_n<1
        disp('GF number wrong');
        return;
    else
        frame_nums=cell2mat({GF_struct(gf_n).track_result(:).FrameNum});
        angle=cell2mat({GF_struct(gf_n).track_result(:).angle});
        hold(ax,'off');
        plot(ax,frame_nums,angle,'o');
        h.b_curr_frame.String=frame_nums(1);
        h.curr_Frame_Callback;
        hold(h.b_axes,'on');
        centerpoint=GF_struct(gf_n).track_result(1).centerpoint_in_image;
        plot(h.b_axes,centerpoint(1),centerpoint(2),'o','LineWidth',4);
        hold(h.b_axes,'off');
    end
    
    

end

