function play_movie(h,ax,drawline,period)
    if nargin==1
        ax=gca;
        drawline=true;
        period=0.2;
    elseif nargin==2 
        drawline=true;
        period=0.2;
    elseif nargin==3
        period=0.2;
    end
    if h.curr_Frame>h.NumberOfFrames
         h.curr_Frame=1;
    end
    if drawline
        h.disp_lines(ax);
    else
        image(ax,read(h,h.curr_Frame));
    end
    h.curr_Frame=mod(h.curr_Frame,h.NumberOfFrames)+1;
    if strcmp(h.v_timer.Running,'off')
        h.v_timer.TimerFcn=@(~,~)play_movie(h,ax,drawline,period);
        h.v_timer.Period=period;
        start(h.v_timer);
    end
end