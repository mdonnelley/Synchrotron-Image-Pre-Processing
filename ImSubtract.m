function ImSubtract(experiment)

%
%**********************************************************
% Flat dark correct synchrotron data
%
% Written by: Martin Donnelley
% Date: 16/4/2010
% Last updated: 26/07/2024
%
%******************************************************
%

setbasepath;

% Load the metadata from the dataset to analyse
run(experiment);

% Load the info
expt.info = ReadS8Data(expt.file.filelist);
if ~exist(fullfile(basepath,expt.fad.corrected)), mkdir(fullfile(basepath,expt.fad.corrected)), end;

% Process each experiment
for imageset = expt.fad.runlist,
    
    start = now;
    
    fprintf('Processing imageset number %d (%d remaining)\n', imageset, length(expt.fad.runlist));

    % Load or average all of the flat and dark files
    [flat, dark] = AverageFlatDark(expt, imageset);

    % Perform the correction
    FlatDarkCorrect(expt, imageset, flat, dark);
    
    % Create movie of FD corrected images
    if ispc && isfield(expt.movie,'movies'),
        
        % Get the input and output file details
        infolder = fullfile(basepath,expt.fad.corrected,expt.info.image{imageset});
        infile = fullfile(infolder,expt.fad.FAD_path_low,[expt.info.imagestart{imageset},expt.fad.FAD_file_low,expt.fad.FAD_type_low]);
        % infiles = dir(fullfile(basepath,expt.fad.corrected,expt.info.image{imageset},expt.fad.FAD_path_low,[expt.info.imagestart{imageset},'*']))
        outfolder = fullfile(basepath,expt.movie.movies);
        outfile = fullfile(outfolder,[expt.info.imagestart{imageset},'_mov']);
        if ~exist(outfolder), mkdir(outfolder); end
        
        % Create the video
        % Create_Video(infiles,outfile,expt.movie.framerate);
        Create_Video_TIF(infile,outfile,expt.movie.framerate);
    
    end
    
    disp(['Processing time for this imageset was ', datestr(now - start,'HH:MM:SS:FFF')])
    
end

diary off