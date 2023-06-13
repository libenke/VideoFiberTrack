function  h= track_all_par(h)
     gf_track_logic=~cell2mat({h.GF_struct.tracked});
     gf=h.GF_struct(gf_track_logic);
     if isempty(gf)
         return
     end
     n=4;
     h.p=gcp;
%      if ~isempty(h.p)
%          if ~isvalid(h.p)
%              h.p=parpool(n);
%          end
%      else
%          h.p=parpool(n);
%      end
    %gfn=floor(numel(gf)/n);
    fname=fullfile(h.Path,h.Name);
%     spmd
%         parvd=videoobj(fname);
%     end
%     spmd
%         if labindex~=n
%             gfpar=gf((labindex-1)*gfn+1:labindex*gfn);
%         elseif labindex==n
%             gfpar=gf((labindex-1)*gfn+1:end);
%         end
%     end
    vd=videoobj(fname);
    parfor i=1:numel(gf)
        disp(['start tracking GF:   ',num2str(i)] )
         tic
         gf(i)=vd.trackGF(gf(i),10);
         disp(['finish tracking GF:   ',num2str(i)] )
         toc
    end 
    
    h.GF_struct(gf_track_logic)=gf;
    h=h.update_disp_info;
    h.save_result();
%     spmd
%          for j=1:numel(gfpar)
%              if ~gfpar(j).tracked
%                  disp(['start tracking GF:   ',num2str(j)] )
%                  tic
%                  gfpar(j)=parvd.trackGF(gfpar(j),10);
%                  disp(['finish tracking GF:   ',num2str(j)] )
%                  toc
%              end
%          end
%     end
%   gfpar;
end

