setbasepath
run('MuCLS_2017_9');
expt.info = ReadS8Data(expt.file.filelist);
if isfield(expt.naming,'zeropad') zeropad = expt.naming.zeropad; else zeropad = 4; end

imageset = 1;

w = waitbar(0,'Loading image 1');

outpath = [basepath,...
    expt.file.datapath,...
    'Processed/Equalised/'...
    expt.info.image{imageset}];
if ~exist(outpath), mkdir(outpath); end

% Read and equalis each image
for i = expt.info.imagegofrom(imageset):expt.info.imagegoto(imageset),
    
    waitbar(i/expt.info.imagegoto(imageset),w,['Equalising image ',num2str(i),' of ', num2str(expt.info.imagegoto(imageset))]);

    imagename = [basepath,...
        expt.fad.corrected,...
        expt.info.image{imageset},...
        expt.info.imagestart{imageset},...
        sprintf(['%.',num2str(zeropad),'d'],i),...
        expt.naming.type];
    
    if(exist(imagename)),
        
        input = imread(imagename);

        output=imadjust(input);

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