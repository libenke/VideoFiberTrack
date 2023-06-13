function h= vdlist_Callback(h)
    h.vdlist.String='';
    if isempty(h.vd)
        h.vdlist.Value=0;
        return
    end
    for i=1:numel(h.vd)
        if ~isvalid(h.vd{i})
            h.vd(i)=[];
        end
    end
    if isempty(h.vd)
        h.vdlist.Value=0;
        return
    end
    for i=1:numel(h.vd)
          h.vd{i}.stop_play;
    end
    if h.vdlist.Value>numel(h.vd)
        h.vdlist.Value=numel(h.vd);
    end
    
    h.curr_video=h.vdlist.Value;
    for i=1:numel(h.vd)
        h.vdlist.String{i}=h.vd{i}.Name;
    end
    ax=h.b_axes;
    h_video=h.vd{h.curr_video};
    h_video.disp_lines(ax);
end

