classdef videoobj<VideoReader
    properties
        res_for_plot           struct
        disp_line_info        int16 %(numberofframe,gf_number,4)
        GF_struct               struct
        GF_table=table
    end
    
    properties         
        curr_Frame=1
        p
        GF                       gf_obj
        wrong_message   
        v_timer      timer
    end
    methods
        function h=videoobj(fname)
             h=h@VideoReader(fname);
             h.disp_line_info=int16(zeros(h.NumberOfFrames,4,1));
             h.v_timer=timer('ExecutionMode', 'fixedRate', ... 
                             'Period', 0.2, ...
                             'TimerFcn', @(~,~)play_movie(h));
         end
    end
    methods
        res = check_displine_info( h )
        h = disp_lines(h,ax)
        h=track_all(h)
        h=add_GF(h,endpoint1,endpoint2,gf_width)
        play_movie(h,ax,drawline,period)
        h=stop_play(h)
        h=update_disp_info(h)
        h= save_result(h,filename)
        gf_res=trackGF(h,gf,max_gap);
        gf_res=fill_GFinfo(h,gf)
        h=export_txt(h,pathstr)
        [res_for_plot] = getdata_for_plot( h )
        export_tracking_res_to_avi(h)
    end
    methods(Static)
        create_avi_from_image()
        create_avi_from_image_par()
        smoth_by_vbm3d(pathstr)
        smooth_by_BM4D()
        de_background_par()
    end
end
