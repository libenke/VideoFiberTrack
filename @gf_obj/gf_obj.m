classdef gf_obj
    properties(Access=public)
        start_Frame
        GF_index
        start_endpoint1
        start_endpoint2
        start_time
        start_angle
        start_centerpoint
        GF_width
        tracked
        enddistance
        GFkernel
        mask
        GFkernel2
        kernel_if_filled=false
        track_result
        wrong_message
        box_length
        box_start_xmin
        box_start_ymin
        gf_inbox
        endpointsInBox
        centerpointInBox
        
    end
    properties(Access=protected)
    end
    methods
        function gf=gf_obj(start_Frame,start_endpoint1,start_endpoint2,GF_width)
            if nargin~=4
                return
            end
            if GF_width==0
                GF_width=10;
            end
            if ~isempty(start_endpoint1)
                gf.start_Frame=start_Frame;
                gf.start_endpoint1=start_endpoint1;
                gf.start_endpoint2=start_endpoint2;
                gf.GF_width=GF_width;
                gf.tracked=false;
            end
        end
        gf=fill_GFinfo(gf,vd_obj)
        gf=trackGF(gf,vd_obj,max_gap)
    end
end