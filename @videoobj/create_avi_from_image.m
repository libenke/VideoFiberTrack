function  create_avi_from_image()
      [f,p] = uigetfile('*.tif','choose the first image');
      if isempty(f) 
          return
      end
      fullf=fullfile(p,f);
      fullf(end-3:end)=[];
      c=strsplit(fullf,'_');
      n=str2num(c{end});

      [foutput,poutput] = uiputfile('*.avi','export the avi',fullf);
      if ~isempty(foutput)
            fullfoutput=fullfile(poutput,foutput);
            writerobj=VideoWriter(fullfoutput,'Motion JPEG AVI');
            %writerobj=VideoWriter(fullfoutput);
            writerobj.FrameRate=30;
            open(writerobj);
            while exist(strcat(strjoin({c{1:end-1},num2str(n,'%03d')},'_'),'.tif'),'file')
                  fullf=strcat(strjoin({c{1:end-1},num2str(n,'%03d')},'_'),'.tif');
                  %writeVideo(writerobj,flip(imread(fullf),2));
                  if mod(n,6)==0
                  writeVideo(writerobj,imread(fullf));
                  end
                  n=n+1;
            end
            close(writerobj);
      end
end

