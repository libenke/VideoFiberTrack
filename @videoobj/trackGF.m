function gf_res=trackGF(vd_obj,gfinital,max_gap)
%max_gap is the max change in each cycle.
    if nargin==2
        max_gap=30;
    end
    gf=fill_GFinfo(vd_obj,gfinital);
    if ~gf.kernel_if_filled
        return
    end
%%
    numFrames=vd_obj.NumberOfFrames;
    FrameRate=double(vd_obj.FrameRate);
    width=vd_obj.Width;
    height=vd_obj.Height;
    start_endpoint1=gf.start_endpoint1;
    start_endpoint2=gf.start_endpoint2;
    if iscolumn(start_endpoint1)
        start_endpoint1=start_endpoint1';
    end
    if iscolumn(start_endpoint2)
        start_endpoint2=start_endpoint2';
    end
    start_Frame=double(gf.start_Frame);
    centerpoint_in_image=gf.start_centerpoint;
    start_angle=gf.start_angle;
 %%
    %start_frame
    track_res=[];
    track_res.FrameNum=start_Frame;
    track_res.Time=(start_Frame-1)/FrameRate;
    track_res.centerpoint_in_image=centerpoint_in_image;
    track_res.angle=start_angle;
    track_res.endpoint1=start_endpoint1;
    track_res.endpoint2=start_endpoint2;
    res_i=2;
%%
    for plus_or_minus=-1:2:1
        n=start_Frame;
        theta=round(start_angle);
        %gf_inbox
        gfbi2=mod(theta,360);
        if (gfbi2==0)
             gfbi2=360;
        end
        gf_inbox=gf.gf_inbox(gfbi2);
        %define the Glass Fiber box
        xmin_in_image=gf.box_start_xmin;
        ymin_in_image=gf.box_start_ymin;
        lenBox=gf.box_length;

        
        %theta range
        theta_gap=6;
        max_c=zeros(2*theta_gap+1,1);
        max_ind=zeros(2*theta_gap+1,1);
        d=max_gap;
        while (xmin_in_image-gf_inbox.xmin+1>d+5)&&(xmin_in_image+gf_inbox.xmin-1+gf_inbox.xwidth-1+d<width-5)

          %crop the reference image.
          if (n+plus_or_minus)<1 || (n+plus_or_minus)>numFrames
              break
          end
          % define the reference box
            yd=1;
            if abs(n-start_Frame)<30
                d=max_gap;%
            else
                dx=(track_res(end).centerpoint_in_image(1)-track_res(end-20).centerpoint_in_image(1))/20;
                d=round(abs(dx)+2);
            end
            xminRef=xmin_in_image-d;
            yminRef=ymin_in_image-yd;
            lenRef_y=lenBox+2*yd;
            lenRef_x=lenBox+2*d;%double twice the d
          
              
          %extend the image in x dimension
          x_image_extend=100;
          %I=videoFrames(:,:,1,n+plus_or_minus);
          %vd_obj.CurrentTime=(n+plus_or_minus-1)/FrameRate;
          I=read(vd_obj,n+plus_or_minus);
          I=I(:,:,1);
          I_extend=[zeros(height,x_image_extend), I,zeros(height,x_image_extend)];
          
          if  yminRef>0 && (yminRef+lenRef_y-1<=height)
              ref=imcrop(I_extend,[xminRef+x_image_extend,yminRef,lenRef_x-1,lenRef_y-1]);
          elseif (yminRef<=0) && (yminRef>-100)
               ref=[zeros(abs(yminRef)+1,lenRef_x);...
                    imcrop(I_extend,[xminRef+x_image_extend,1,lenRef_x-1,lenRef_y+yminRef-2])];
          elseif (yminRef+lenRef_y-1>=height) && (yminRef+lenRef_y<height+100)
               ref=[imcrop(I_extend,[xminRef+x_image_extend,yminRef,lenRef_x-1,height-yminRef-1]);...
                   zeros(abs(yminRef+lenRef_y-height),lenRef_x)];
          elseif (yminRef<-100) || (yminRef+lenRef_y>height+100)
               return;
          end
          ref=double(ref);
          %density cross correlation for different theta angle.
          %
          %
          for j=1:(2*theta_gap+1)
                  %mod the theta
                  tj=[theta-theta_gap:theta+theta_gap]';
                  tj=mod(tj,360);
                  tj(tj==0)=360;
                  %density correlation
                  ker=double(gf.GFkernel2(:,:,tj(j)));
                  mask=gf.mask(:,:,tj(j));
                  %
                  %c=normxcorr2(ker,ref);
                  %b=c(lenBox:lenBox+2*d,lenBox:lenBox+2*d);
                  %
                  %one way to calculate b
                  b=zeros(2*yd+1,2*d+1);
                  for bi=1:2*yd+1
                     for bj=1:2*d+1
                        ref_b=ref(bi:bi+lenBox-1,bj:bj+lenBox-1);
                         ref_b_array=ref_b(mask(:));
                         ker_array=ker(mask(:));
                         bc_coef=corrcoef(ref_b_array,ker_array);
                         b(bi,bj)=bc_coef(1,2);
                     end
                  end
                  %
%                   %another way to calculate b;
%                   %
%                   ker_array=ker(mask(:));
%                   ref_m=zeros(numel(ker_array),(2*d+1)*(2*d+1));
%                   b_size=[2*d+1,2*d+1];
%                   for ci=1:2*d+1
%                       for cj=1:2*d+1
%                           ref_c=ref(ci:ci+lenBox-1,cj:cj+lenBox-1);
%                           ref_c_array=ref_c(mask(:));
%                           ref_m(:,sub2ind(b_size,ci,cj))=ref_c_array;
%                       end
%                   end
%                   %b=conv2(ref_m,ker_array,'valid')/sqrt((std(ker_array)*std(ref_m)));
%                   c=normxcorr2(ker_array,ref_m);
%                   b=c(numel(ker_array),:);
                  b=reshape(b,[2*yd+1,2*d+1]);
                  [max_c(j),max_ind(j)]=max(b(:));
          end
          [~,k]=max(max_c);
          theta=theta-theta_gap+k-1;
          [ypeak,xpeak]=ind2sub(size(b),max_ind(k,1));
          yoffset_in_ref=(ypeak-(yd+1));
          xoffset_in_ref=(xpeak-(d+1));

          %update 'xmin_in_image', 'ymin_in_image' of GFkernel
          xmin_in_image=xmin_in_image+xoffset_in_ref;
          ymin_in_image=ymin_in_image+yoffset_in_ref;

          %update the Reference box in the next frame:
          xminRef=xmin_in_image-d;
          yminRef=ymin_in_image-yd;

          %update the fiber infomation
          center_in_image=gf.centerpointInBox+[xmin_in_image, ymin_in_image]-[1,1];
          [xo,yo]=pol2cart((-theta)/180*pi,gf.enddistance/2);
          endpoint1=center_in_image-[xo,yo];
          endpoint2=center_in_image+[xo,yo];
          %gf_inbox
          gfbi=mod(theta,360);
          if (gfbi==0)
              gfbi=360;
          end
          gf_inbox=gf.gf_inbox(gfbi);
          %update the track cell
          % FrameNum  Time  centerpoint_In_Image  angle endpoint1 endpoint2
          track_res(res_i).FrameNum=n+plus_or_minus;
          track_res(res_i).Time=n/FrameRate;
          track_res(res_i).centerpoint_in_image=center_in_image;
          track_res(res_i).angle=theta;
          track_res(res_i).endpoint1=endpoint1;
          track_res(res_i).endpoint2=endpoint2;
          res_i=res_i+1;
          
%           if mod(res_i,100)==0
%               disp(strcat('res_i',num2str(res_i)));
%           end
          %
          n=n+plus_or_minus;
        end
    end
%%
    gfinital.track_result=track_res;
    gfinital.tracked=true;
    gf_res=gfinital;
end