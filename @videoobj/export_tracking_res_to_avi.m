function h=export_tracking_res_to_avi(h)
        fname=fullfile(h.Path,strcat('with_lines_',h.Name));
        writerobj=VideoWriter(fname,'Motion JPEG AVI');
        writerobj.FrameRate=30;
        open(writerobj); 
        f=figure;
        ax=axes;
        cla(ax,'reset');
        colormap(gray(256));
        for i=1:h.NumberOfFrames
            imshow(read(h,i));
            h.curr_Frame=i;
            h.disp_lines(ax);
            fframe=getframe(ax);
            I=frame2im(fframe);
            writeVideo(writerobj,I);
        end
        close(writerobj);
        delete(writerobj);
        delete(f);
        f=[];
end

