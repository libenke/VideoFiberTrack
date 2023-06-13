function gf_res=fill_GFinfo(vd_obj,gf)
      delete(gf.wrong_message);
      gf.wrong_message=[];
      start_Frame=gf.start_Frame;
      start_endpoint1=(gf.start_endpoint1)';
      start_endpoint2=(gf.start_endpoint2)';
      widthpixel=gf.GF_width;
      FrameRate=vd_obj.FrameRate;
      height=vd_obj.Height;
      start_time=(start_Frame-1)/FrameRate;
      I=read(vd_obj,start_Frame);
      I=I(:,:,1);
       %try
          %location of the Glass Fiber in the image at Start Time.
           startEndpoints=[start_endpoint1;start_endpoint2];
           start_angle=-180/pi*atan((start_endpoint1(2)-start_endpoint2(2))/(start_endpoint1(1)-start_endpoint2(1)));
           if start_angle<0
               start_angle=start_angle+180;
           end
           start_centerpoint=(sum(startEndpoints,1)/2);
           enddistance=norm(start_endpoint1-start_endpoint2);
           xminstart=round(start_centerpoint(1)-enddistance/2)-7;
           yminstart=round(start_centerpoint(2)-enddistance/2)-7;
           boxlength=round(enddistance)+14;
           startCropRect=[xminstart, yminstart, boxlength-1,boxlength-1];

           %location of the Glass Fiber in the rectangle box cropped from the image.
           endpointsInBox=[startEndpoints(:,1)-xminstart+1, startEndpoints(:,2)-yminstart+1];
           centerpointInBox=start_centerpoint-[xminstart, yminstart]+[1,1];

           %crop the selected Glass Fiber from the image at the Start Time.
           if yminstart<=0 
               %I=[I(1:abs(yminstart)+1,:);I];
               cropGF=imcrop(I,[xminstart,1,boxlength,boxlength+yminstart-1]);
               cropGF=[cropGF(1:abs(yminstart)+1,:);cropGF];
           elseif yminstart+boxlength>height
               I=[I;zeros(abs(yminstart+boxlength-height)+2,size(I,2))];
               cropGF=imcrop(I,startCropRect);
           else
           cropGF=imcrop(I,startCropRect);
           end
           num=numel(cropGF);
           [y,x]=ind2sub(size(cropGF),(1:num)');
           P=[x,y];%all the location of the pixel points in the box.
           for i=1:num
                %distance from the points P to the line.
                dline(i) = abs(det([endpointsInBox(1,:)-endpointsInBox(2,:);P(i,:)-endpointsInBox(1,:)]))/enddistance;%distance from the point to the line by: d=area/length

                %distance form the points P to the endpoints.  
                dpoint(i)=norm(P(i,:)-centerpointInBox);
        %         %distance form the points P to the endpoints.
        %         dpoint1(i)=norm((P(i,:)-endpointsInBox(1,:)),2);
        %         dpoint2(i)=norm((P(i,:)-endpointsInBox(2,:)),2);
           end
           logicArray=(dpoint<=(enddistance/2+3))...
                              &(dline<=widthpixel/2+1);   
            %    logicArray=(dpoint1<=norm([widthpixel/2,enddistance])+2)...
            %                       &(dpoint2<=norm([widthpixel/2,enddistance])+2)...
            %                       &(dline<=widthpixel/2+2);
           logicMat=reshape(logicArray,size(cropGF));
           %extract the Glass Fiber only.
           extractGF=imcomplement(cropGF);
           extractGF(~logicMat)=0;
           GFkernel=zeros([size(extractGF),360]);
           mask=false(size(GFkernel));
           GFkernel2=zeros(size(GFkernel));
           % calculate the GF kernels matrices of the Glass Fiber in different orientation angle.
           for i=1:360
                GFkernel(:,:,i)=imcomplement(imrotate(extractGF,-start_angle+i,'bilinear','crop'));
                mask(:,:,i)=logical(GFkernel(:,:,i)~=255);
                Im=double(imrotate(cropGF,-start_angle+i,'bilinear','crop'));
                Im(~mask(:,:,i))=nan;
                Imean=mean(Im(:),'omitnan');
                Im(~mask(:,:,i))=Imean;
                GFkernel2(:,:,i)=Im;
                %find the GF region in the box; the info is stored in the gf_inbox
                %structure.
                GFboundingbox=regionprops(~(imcomplement(GFkernel(:,:,i))==0),'BoundingBox');
                gf_inbox(i).xmin=ceil(GFboundingbox(1).BoundingBox(1));
                gf_inbox(i).ymin=ceil(GFboundingbox(1).BoundingBox(2));
                gf_inbox(i).xwidth=(GFboundingbox(1).BoundingBox(3));
                gf_inbox(i).ywidth=(GFboundingbox(1).BoundingBox(4));
           end
           gf.box_length=boxlength;
           gf.box_start_xmin=xminstart;
           gf.box_start_ymin=yminstart;
           %gf.GFkernel=GFkernel;
           gf.GFkernel2=GFkernel2;
           gf.mask=mask;
           gf.start_time=start_time;
           gf.start_angle=start_angle;
           gf.start_centerpoint=start_centerpoint;
           gf.enddistance=enddistance;
           gf.box_length=boxlength;
           gf.box_start_xmin=xminstart;
           gf.box_start_ymin=yminstart;
           gf.gf_inbox=gf_inbox;
           gf.endpointsInBox=endpointsInBox;
           gf.centerpointInBox=centerpointInBox;
           gf.kernel_if_filled=true;
           
           gf_res=gf;
       %catch ME
%            gf.wrong_message=[gf.wrong_message;ME];
%            gf.kernel_if_filled=false;
       %end
end