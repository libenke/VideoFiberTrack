function h= track_all(h)
     if isempty(h.GF_struct)
         return
     end
     n=numel(h.GF_struct);

     for i=1:n
         if ~h.GF_struct(i).tracked
             disp(['start tracking GF:   ',num2str(i)] )
             tic
             h.GF_struct(i)=trackGF(h,h.GF_struct(i));
             disp(['finish tracking GF:   ',num2str(i)] )
             toc
         end
     end
     h=update_disp_info(h);
end

