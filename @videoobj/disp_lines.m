function h = disp_lines(h,ax)
     if nargin==1
        ax=gca;
     end
     if h.curr_Frame>h.NumberOfFrames
         return
     end
     image(ax,read(h,h.curr_Frame));
     if size(h.disp_line_info,3)<2
         return
     end
     if ~h.check_displine_info
            disp('error: the display number of gf is wrong');
            return
     end
    disp_info=h.disp_line_info;
    [~,gf_index,~]=find(disp_info(h.curr_Frame,:,1)~=0);
    if isempty(gf_index)
        return
    end
    gf_mat=[gf_index',...
        disp_info(h.curr_Frame,gf_index,1)',...
        disp_info(h.curr_Frame,gf_index,2)',...
        disp_info(h.curr_Frame,gf_index,3)',...
        disp_info(h.curr_Frame,gf_index,4)'];
    if ~isempty(gf_mat)
    line(ax,[gf_mat(:,2), gf_mat(:,4)]',[gf_mat(:,3), gf_mat(:,5)]','Color','red');
    text(ax,double((gf_mat(:,2)+gf_mat(:,4)))/2,double((gf_mat(:,3)+gf_mat(:,5)))/2,...
            num2str(gf_mat(:,1)),'FontSize',20,'Color','red');
    end
end

