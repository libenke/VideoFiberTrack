function [ h ] = update_disp_info_Callback( h )
    for i=1:numel(h.vd)
         vd=h.vd{i};
         %disp('start updating display info');
         disp(vd.Name);
         vd{i}.update_disp_info;
         %vd.getdata_for_plot;
         disp('complete updating display info');
         disp(vd.Name);
    end
    disp('complete updating display info');
end