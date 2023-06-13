function  create_avi_from_image_par()
%         if ~exist(pathstr,'dir')
%              pathstr=uigetdir();
%         end
        pathstr=uigetdir();
        %p=gcp;
        %n=p.NumWorkers;
        a=dir(pathstr);
        a(1:2)=[];
        for i=1:numel(a)
        %for i=1:numel(a)
            videoname=strcat(a(i).name,'.avi');
            fullfoutput=fullfile(a(i).folder,videoname);
            writerobj=VideoWriter(fullfoutput,'Motion JPEG AVI');
            writerobj.FrameRate=90;
            open(writerobj);
            tifstr='RecordedImage_CM-030GE_00-0C-DF-03-01-88';
            n=0;
            tifname=fullfile(fullfile(a(i).folder,a(i).name),strcat(tifstr,'_',num2str(n,'%03d'),'.tif'));
            while ~exist(tifname,'file')
                n=n+1;
                tifname=fullfile(fullfile(a(i).folder,a(i).name),strcat(tifstr,'_',num2str(n,'%03d'),'.tif'));
            end
            while exist(tifname,'file')
                  writeVideo(writerobj,imread(tifname));
                  n=n+1;
                  tifname=fullfile(fullfile(a(i).folder,a(i).name),strcat(tifstr,'_',num2str(n,'%03d'),'.tif'));
            end
            close(writerobj);
        end
end

