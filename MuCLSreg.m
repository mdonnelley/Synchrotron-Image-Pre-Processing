setbasepath
run('MuCLS_2017_9');
expt.info = ReadS8Data(expt.file.filelist);
if isfield(expt.naming,'zeropad') zeropad = expt.naming.zeropad; else zeropad = 4; end

[optimizer, metric]  = imregconfig('monomodal');
imageset = 1;

w = waitbar(0,'Loading image 1');

outpath = [basepath,...
    expt.file.datapath,...
    'Processed/Registered/'...
    expt.info.image{imageset}];
if ~exist(outpath), mkdir(outpath); end

% Read the first image
i = expt.info.imagegofrom(imageset);
imagename = [basepath,...
    expt.fad.corrected,...
    expt.info.image{imageset},...
    expt.info.imagestart{imageset},...
    sprintf(['%.',num2str(zeropad),'d'],i),...
    expt.naming.type];
fixed = imread(imagename);
copyfile(imagename,outpath);

% Read and register each image
for i = expt.info.imagegofrom(imageset)+1:expt.info.imagegoto(imageset),
    
    waitbar(i/expt.info.imagegoto(imageset),w,['Registering image ',num2str(i),' of ', num2str(expt.info.imagegoto(imageset) - expt.info.imagegofrom(imageset))]);
    
    imagename = [basepath,...
        expt.fad.corrected,...
        expt.info.image{imageset},...
        expt.info.imagestart{imageset},...
        sprintf(['%.',num2str(zeropad),'d'],i),...
        expt.naming.type];
    
    if(exist(imagename)),
        
        moving = imread(imagename);
        movingRegistered = imregister(moving,fixed,'translation',optimizer, metric);
        output=imadjust(movingRegistered);
        
        imagename = [outpath,...
            expt.info.imagestart{imageset},...
            sprintf(['%.',num2str(zeropad),'d'],i),...
            expt.naming.type];
        imwrite(output,imagename);
        
    else
        
        warning([imagename,' Does not exist!'])
        
    end
    
end

close(w)