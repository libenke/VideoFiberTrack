function res = check_displine_info( h )
      if numel(h.GF_struct)<3
          res=true;
          return
      end
      numgf=size(h.disp_line_info,2);
      end_GF_struct_res=h.GF_struct(numgf).track_result;
      end_GF_struct_1st_Frame= end_GF_struct_res(1).FrameNum;
      end_GF_struct_endpoint1x=end_GF_struct_res(1).endpoint1(1);
      GF_endpoint1x_map=h.disp_line_info(end_GF_struct_1st_Frame,end,1);
      if GF_endpoint1x_map~=int16(end_GF_struct_endpoint1x)
            res=false;
            return
      else
          res=true;
      end

end

