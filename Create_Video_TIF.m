function Create_Video_TIF(infile,outfile,framerate)

w = waitbar(0,'Setup');

% Open the video object
outputVideo = VideoWriter(outfile,'MPEG-4');
outputVideo.FrameRate = framerate;
open(outputVideo)

% Get info about how many pages in multipage tif
info = imfinfo(infile);

% Write each image as a movie frame
for i = 1:length(info),
    
    waitbar(i/length(info),w,['Adding frame ',num2str(i),' of ',num2str(length(info))]);
    img = imread(infile,i);
    img = insertText(img,[40,40],[num2str(i),'/',num2str(length(info))],'FontSize',50,'TextBoxColor',[0.3010 0.7450 0.9330]);
    % img = uint8(img/2^6);    
    writeVideo(outputVideo,img)
    
end

close(outputVideo)
close(w)

