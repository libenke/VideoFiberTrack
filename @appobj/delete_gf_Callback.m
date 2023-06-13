function h= delete_gf_Callback(h)
      curr_video=h.curr_video;
      vd=h.vd{curr_video};
      if size(vd.disp_line_info,2)==1
          return
      end
      if isempty(h.gf_to_be_delete.String)
          return
      end
      gf_to_be_delete=str2num(h.gf_to_be_delete.String);
      if (gf_to_be_delete<1)||(gf_to_be_delete>numel(vd.GF_struct))
          msgbox('wrong GF number');
          return
      end
      if gf_to_be_delete>size(vd.disp_line_info,2)
          return
      end
      if ~vd.check_displine_info
          msgbox('error: the display number of gf is wrong');
          return
      else
          vd.GF_struct(gf_to_be_delete)=[];
          vd.disp_line_info(:,gf_to_be_delete,:)=[];
          vd.disp_lines(h.b_axes);
          h.gf_to_be_delete.String='';
      end
end

