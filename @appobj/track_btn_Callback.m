function track_btn_Callback(h)
    if ~h.ifparallel.Value
         for i=1:numel(h.vd)
             h.vd{i}.track_all;
             h.vd{i}.update_disp_info;
         end
    else
        for i=1:numel(h.vd)
             h.vd{i}.track_all_par;
             h.vd{i}.update_disp_info;
         end
    end
end
