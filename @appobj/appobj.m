classdef appobj<matlab.mixin.SetGet
     properties(Access=public)
         vd                        cell %videoobj
         video_info                table
         new_end_points=[];
         curr_video=1
         f_par                   parallel.FevalFuture
         %
         f                              matlab.ui.Figure
         b_axes                     matlab.graphics.axis.Axes
         p_axes                     matlab.graphics.axis.Axes
         b_play                      matlab.ui.control.UIControl
         b_stop                     matlab.ui.control.UIControl
         b_curr_frame            matlab.ui.control.UIControl
         b_disp_line               matlab.ui.control.UIControl
         b_draw_line              matlab.ui.control.UIControl
         b_width                    matlab.ui.control.UIControl
         b_track                    matlab.ui.control.UIControl
         b_board                   matlab.ui.control.UIControl
         vdlist                        matlab.ui.control.UIControl
         openfile                    matlab.ui.control.UIControl
         savefile                    matlab.ui.control.UIControl
         fps                        matlab.ui.control.UIControl
         delete_gf                 matlab.ui.control.UIControl
         gf_to_be_delete       matlab.ui.control.UIControl
         ifparallel                  matlab.ui.control.UIControl
         open_res                 matlab.ui.control.UIControl
         export_txt               matlab.ui.control.UIControl
         update_disp_info         matlab.ui.control.UIControl
         plot_res                 matlab.ui.control.UIControl
         Plot_gf_res           matlab.ui.control.UIControl
         Frame_num_tobe_cut    matlab.ui.control.UIControl
         cut_Framenum          matlab.ui.control.UIControl
         gf_n_to_be_plot         matlab.ui.control.UIControl
         open_folder                    matlab.ui.control.UIControl
    end
     methods (Access=public)
                     h=show(h)
                     h=load_video(h,fname)
                     h= save_result(h,filename,vdi)
        function h=appobj(fname)
            h=h@matlab.mixin.SetGet();
            if nargin==1
                 load_video(h,fname);
            end
            h=show(h);
        end

    end
     methods(Access=protected)
                     h= vdlist_Callback(h)
                     h = savefile_Callback(h)
                     h= openfile_Callback(h)
                     h=draw_line_Callback(h)
                     h=save_gf_btn_Callback(h)
                     h=play_btn_Callback(h)
                     track_btn_Callback(h)
                     h=open_res_Callback(h)
                     h=update_disp_info_Callback(h)
                     h=Plot_gf_result_Callback(h)
                     [ h ] = plot_res_Callback( h )
                     [ h ] = cut_Framenum_Callback( h )
                     h=open_folder_Callback(h)
        function h=Delete_f_Callback(h)
            for i=1:size(h.vd,2)
                h.vd{i}.stop_play;
            end
        end
 

        function h=stop_btn_Callback(h)
            if numel(h.vd)==0
                return
            end
            for i=1:max(size(h.vd))
                  h.vd{i}.stop_play;
            end
            curr_vd=h.vd{h.curr_video};
            h.b_curr_frame.String=num2str(curr_vd.CurrentTime.*curr_vd.FrameRate);
            h.curr_Frame_Callback;
        end
        function h=curr_Frame_Callback(h)
            curr_Frame=abs(round(str2num(h.b_curr_frame.String)));
            if curr_Frame>h.vd{h.curr_video}.NumberOfFrames || curr_Frame<1
                msgbox('wrong Frame Number');
                return
            end
            curr_vd=h.vd{h.curr_video};
            curr_vd.curr_Frame=curr_Frame;
            ax=h.b_axes;
            curr_vd.disp_lines(ax);
        end
     end
end