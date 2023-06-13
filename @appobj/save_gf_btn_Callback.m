function h=save_gf_btn_Callback(h)
     curr_video=h.curr_video;
     CurrentTime=h.vd{curr_video}.CurrentTime;
     FrameRate=h.vd{curr_video}.FrameRate;
     curr_Frame=round((CurrentTime*FrameRate)+1);
     try
         if ~isempty(h.new_end_points)
             if isvalid(h.new_end_points)
                  endpoints=getPosition(h.new_end_points);
                  endpoint1=endpoints(1,:);
                  endpoint2=endpoints(2,:);
                  gf_width=str2num(h.b_width.String);
                  if isempty(gf_width)
                      gf_width=8;
                  end
                  if gf_width==0
                      gf_width=8;
                  end
                  h.vd{curr_video}.add_GF(endpoint1,endpoint2,gf_width);
             end
         end
         GFnum=numel(h.vd{curr_video}.GF);
         disp(h.vd{curr_video}.Name);
         disp(['GF number:' num2str(GFnum)])
     catch ME
         msgbox(ME.message);
     end
end 
