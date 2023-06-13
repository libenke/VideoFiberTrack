 function h=add_GF(h,endpoint1,endpoint2,gf_width)
        curr_Frame=h.curr_Frame;
        if size(endpoint1,1)==1
            endpoint1=endpoint1';
            endpoint2=endpoint2';
        end
        if isempty(gf_width)
            return
        end
        if gf_width==0
            gf_width=10;
        end
        if isempty(h.GF)
            h.GF=gf_obj(curr_Frame,endpoint1,endpoint2,gf_width);
            h.GF_struct=[h.GF_struct;struct(h.GF)];
            return
        end
        g=h.GF;
        endpoint_logic=cell2mat({g.start_endpoint1})==endpoint1;
        endpoint_logic=(all(endpoint_logic,1))';
        start_Frame_logic=(cell2mat({g.start_Frame})==curr_Frame)';
        g=g(start_Frame_logic & endpoint_logic);
        if isempty(g)
            GF=gf_obj(curr_Frame,endpoint1,endpoint2,gf_width);
            h.GF=[h.GF;GF];
            h.GF_struct=[h.GF_struct;struct(GF)];
        end
 end