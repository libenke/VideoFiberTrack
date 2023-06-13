function  h=export_txt( h,pathstr )
     res_for_plot=h.getdata_for_plot;
     fieldn=fieldnames(res_for_plot);
     res_for_plot=struct2cell(res_for_plot);
     for i=1:numel(fieldn)
         n=res_for_plot{i};
         varname=cellstr(strcat('GF',split(int2str(1:size(n,2)))));
         if isempty(res_for_plot{i})
             disp('no results')
             continue;
         else
            n=array2table(res_for_plot{i},'VariableNames',varname);
            fname=fullfile(pathstr,strcat(fieldn{i},'.txt'));
            writetable(n,fname);
         end

     end
end

