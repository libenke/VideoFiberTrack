function h=play_btn_Callback(h)
    for i=1:max(size(h.vd))
          h.vd{i}.stop_play;
    end
    ax=h.b_axes;
    drawline=h.b_disp_line.Value;
    fps=str2double(h.fps.String);
    if fps==0
        fps=10;
    end
    h.vd{h.curr_video}.play_movie(ax,drawline,1/fps)
end
