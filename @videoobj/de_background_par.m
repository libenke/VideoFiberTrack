function de_background_par()
    p=gcp;
    n=p.NumWorkers;
    pathstr=uigetdir();
    a=dir(pathstr);
    vidObj=[];
    fullfoutput={};
    for i=1:numel(a)
        af2=fullfile(a(i).folder,a(i).name);
        af2_out=fullfile(a(i).folder,strcat('deback_',a(i).name));
        if ~exist(af2_out,'file')
            try
                if isempty(vidObj)
                    vidObj=VideoReader(af2);
                else
                    vidObj(numel(vidObj)+1,1)=VideoReader(af2);
                end
                 fullfoutput(numel(vidObj),1)={fullfile(a(i).folder,strcat('deback_',a(i).name))};
            catch
            end
        end
    end
    vdn=numel(vidObj);
    parfor (i=1:vdn,3)
    %for i=1:vdn
        f=fullfoutput{i};
        writerobj=VideoWriter(f);
        writerobj.FrameRate=90;
        writerobj.Quality=90;
        open(writerobj);
        %
        N1=vidObj(i).Height;
        N2=vidObj(i).Width;
        %n1,n2 is the center point
        n1=fix(N1/2);
        n2=fix(N2/2);
        %d0 control the frequecy to be filtered
        d0=4; 
        h=zeros(N1,N2);
        for hi=1:N1
          for hj=1:N2
              d=sqrt((hi-n1)^2+(hj-n2)^2);
              h(hi,hj)=exp(-d*d/(2*d0*d0));
          end
        end
        %
          n=1;
          [~,fn,~]=fileparts(f);
          disp(strcat('start£º',fn));
          for j=1:vidObj(i).NumberOfFrames
                I=read(vidObj(i),j);
                I=I(:,:,1);
                g=fft2(I);
                g=fftshift(g);
                g_deback=h.*g;
                g_deback=ifftshift(g_deback);
                X2=ifft2(g_deback);
                I_background=real(X2);
                I3=double(I)-I_background;
                I_min=min(I3(:));
                I_max=max(I3(:));
                if I_max-I_min>254
                    I4=single((I3-I_min)/(I_max-I_min+1));
                else
                    I4=single((I3-I_min)/255);
                end
                n=n+1;
                if mod(n,1000)==0
                    disp(strcat('finish frames:',num2str(n)));
                end
               writeVideo(writerobj,I4);
          end
          close(writerobj);
          delete(writerobj);
          disp(strcat('finish:',fn));
    end
end

