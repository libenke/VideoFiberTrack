function h=stop_play(h)
   if strcmp(h.v_timer.Running,'on')
        stop(h.v_timer);
    end
end
