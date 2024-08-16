function FlatDarkCorrectHIS(expt, imageset, flat, dark);

%
%**********************************************************
% Perform flat and dark correction
%
% Written by: Martin Donnelley
% Date: 16/04/2010
% Last updated: 15/08/2023
%
%******************************************************
%

% Set the base pathname for the current machine
setbasepath;

if ~strcmp(expt.naming.type, '.his'),
    error()

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

% Perform the correction for .his files

    infile = his(fullfile(filelist.folder,filelist.name));
    infile = infile.openStream();

    % IF THIS WORKS, THEN SHIFT IT TO BE OUTSIDE THE IF SO IT WORKS FOR ALL FILETYPES?
    outfile = fullfile(outpath,[expt.info.imagestart{imageset},expt.fad.FAD_file_low,expt.fad.FAD_type_low]);
    
    % If there are more than 5000 frames, then save as Big TIFF
    if infile.numFrames > 5000,
        bt = Tiff(outfile,'w8');
    else
        bt = Tiff(outfile,'w');
    end

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

    % Perform FDC
    for i = 1:infile.numFrames,
        fprintf(['Image ', num2str(i), ' of ', num2str(infile.numFrames), '\n']);
        rawimage = infile.getFrame(i);
        inimage = double(rawimage);
        final = (inimage - dark) ./ (flat - dark);
        final = processFDCimage(expt, final);
        
        final = uint8(255*final);
        bt.setTag(tagstruct);
        write(bt,final);
        writeDirectory(bt);

        % index = sprintf('%.4d',i);
        % writeFDCimage(expt, imageset, outpath, index, final, 0);
    end

    close(bt);
    infile = infile.closeStream();
    