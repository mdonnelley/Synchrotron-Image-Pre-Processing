function FlatDarkCorrect(expt, imageset, flat, dark);

%
%**********************************************************
% Perform flat and dark correction
%
% Written by: Martin Donnelley
% Date: 16/04/2010
% Last updated: 30/07/2024
%
%******************************************************
%

% Set the base pathname for the current machine
setbasepath;

% Set up TIFF tags
tagstruct.ImageLength = size(flat,1);
tagstruct.ImageWidth = size(flat,2);
tagstruct.SampleFormat = 1; % uint
tagstruct.Photometric = Tiff.Photometric.MinIsBlack;
tagstruct.BitsPerSample = 8;
tagstruct.SamplesPerPixel = 1;
tagstruct.Compression = Tiff.Compression.JPEG;
tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
tagstruct.Software = 'MATLAB';

% Set directories
inpath = fullfile(basepath,expt.file.raw,expt.info.image{imageset});
outpath = fullfile(basepath,expt.fad.corrected,expt.info.image{imageset});
fprintf('Read directory %s\n', inpath);
fprintf('Write directory %s\n', outpath);

% Create directories if they don't exist
if strcmp(expt.fad.output, 'HIGH') | strcmp(expt.fad.output, 'BOTH')
    mkdir(fullfile(outpath,expt.fad.FAD_path_high));
end
if strcmp(expt.fad.output, 'LOW') | strcmp(expt.fad.output, 'BOTH')
    mkdir(fullfile(outpath,expt.fad.FAD_path_low));
end

% Get the list of files in the read directory
filelist = dir([inpath,expt.info.imagestart{imageset},'*',expt.naming.type]);

% Set previous to white
previous = double(zeros(size(flat)));

% Perform the correction for .his files
if strcmp(expt.naming.type, '.his'),
    infile = his(fullfile(filelist.folder,filelist.name));
    infile = infile.openStream();
    outfile = fullfile(outpath,[expt.info.imagestart{imageset},expt.fad.FAD_file_low,expt.fad.FAD_type_low]);
    
    % If there are more than 5000 frames, then save as Big TIFF
    if infile.numFrames > 5000, type = 'w8'; else type = 'w'; end
    t = Tiff(outfile,type);

    % Perform FDC
    for i = 1:infile.numFrames,
        fprintf(['Image ', num2str(i), ' of ', num2str(infile.numFrames), '\n']);
        rawimage = infile.getFrame(i);
        inimage = double(rawimage);
        FDC = (inimage - dark) ./ (flat - dark);
        final = processFDCimage(expt, FDC, previous);
        final = uint8(255*final);
        t.setTag(tagstruct);
        t.write(final);
        t.writeDirectory();
        previous = FDC;
    end

    % Close the input and output files
    close(t);
    infile = infile.closeStream();
    
% Perform the correction for multipage image files
elseif strcmp(expt.naming.type, '.tif') & isfield(expt.fad,'multipage'),
    infile = fullfile(inpath,filelist.name);
    numfiles = length(imfinfo(infile));
    for i = 1:numfiles,
        fprintf(['Image ', num2str(i), ' of ', num2str(numfiles), '\n']);
        [rawimage, t] = ReadFileTime(infile, i);
        inimage = double(rawimage);
        FDC = (inimage - dark) ./ (flat - dark);
        final = processFDCimage(expt, FDC, previous);
        index = sprintf('%.4d',i);
        writeFDCimage(expt, imageset, outpath, index, final, t);
        previous = FDC;
    end
    
% Perform the correction for single image files
elseif strcmp(expt.naming.type, '.tif')
    numfiles = length(filelist);
    for i = 1:numfiles,
        infile = fullfile(inpath,filelist(i).name)
        fprintf(['Image ', num2str(i), ' of ', num2str(numfiles), '\n']);
        [rawimage, t] = ReadFileTime(infile);
        inimage = double(rawimage);
        FDC = (inimage - dark) ./ (flat - dark);
        final = processFDCimage(expt, FDC, previous);
        outfile = regexp(filelist(i).name,'_|\.','split');
        index = outfile{2};
        writeFDCimage(expt, imageset, outpath, index, final, t);
        previous = FDC;
    end
end