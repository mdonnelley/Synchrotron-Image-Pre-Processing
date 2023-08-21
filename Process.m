function Process(experiment)

%
%**********************************************************
% Flat dark correct synchrotron data
%
% Written by: Martin Donnelley
% Date: 16/4/2010
% Last updated: 29/09/2014
%
%******************************************************
%

setbasepath;

% Load the metadata from the dataset to analyse
run(experiment);

% Load the info
expt.info = ReadS8Data(expt.file.filelist);

% Record the command window output
diary(fullfile(basepath,expt.fad.corrected,sprintf('FDC %s.txt', datestr(now,'yyyy-mm-dd HH-MM-SS'))));

% Set the movie parameters
framerate = 10;

% Process each experiment
for imageset = expt.fad.runlist,
    
    start = now;
    
    fprintf('Processing imageset number %d (%d remaining)\n', imageset, length(expt.fad.runlist));
    
    % Load or average all of the flat and dark files
    [flat, dark] = AverageFlatDark(expt, imageset);
    
    % Perform the correction
    FlatDarkCorrect(expt, imageset, flat, dark);
    
    % Create movie of FD corrected images
    if ispc && isfield(expt.fad,'movies'),
        
        % Get the input and output file details
        infiles = dir(fullfile(basepath,expt.fad.corrected,expt.info.image{imageset},expt.fad.FAD_path_low,[expt.info.imagestart{imageset},'*']))
        outfolder = fullfile(basepath,expt.fad.movies)
        if ~exist(outfolder), mkdir(outfolder); end
        outfile = fullfile(outfolder,[expt.info.imagestart{imageset},'_mov'])
        
        % Create the video
        Create_Video(infiles,outfile,framerate);
    
    end
    
    disp(['Processing time for this imageset was ', datestr(now - start,'HH:MM:SS:FFF')])
    
end

diary off