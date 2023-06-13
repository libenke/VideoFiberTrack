function h=draw_line_Callback(h)
        h.b_play.Enable='off';
        h.b_curr_frame.Enable='off';
        h.vdlist.Enable='off';
        try
            for i=1:max(size(h.vd))
                  h.vd{i}.stop_play;
            end
%             if ~isempty(h.new_end_points)
%                 if isvalid(h.new_end_points)
%                     delete(h.new_end_points)
%                 end
%             end
            h.new_end_points=[];
            h.new_end_points=imline(h.b_axes);
            if ~isempty(h.new_end_points)
                p=getPosition(h.new_end_points);
            end
            h.b_board.String=strcat('end-point:',num2str(p));
        catch ME
            msgbox(ME.message);
        end
            h.b_play.Enable='on';
            h.b_curr_frame.Enable='on';
            h.vdlist.Enable='on';
end
