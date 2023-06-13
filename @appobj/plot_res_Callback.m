function [ h ] = plot_res_Callback( h )
     curr_video=h.curr_video;
     vd=h.vd{curr_video};
     if isempty(vd.res_for_plot)
         vd.getdata_for_plot;
     end
     res_for_plot=vd.res_for_plot;
     fieldn=fieldnames(res_for_plot);
     res_for_plot=struct2cell(res_for_plot);
     for i=1:numel(fieldn)
         figure;plot(res_for_plot{i},'.');
     end
end