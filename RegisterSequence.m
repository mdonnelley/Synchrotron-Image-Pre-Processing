function RegisterSequence(expt, imageset)

%
%**********************************************************
% Register and intensity correct image sequences
%
% Written by: Martin Donnelley
% Date: 20/10/2021
% Last updated: 20/10/2021
%
% Based on original MuCLSreg file (2018) and updated in 2021
%
%**********************************************************
%

% Set the base pathname for the current machine
setbasepath

expt.info = ReadS8Data(expt.file.filelist);
if isfield(expt.naming,'zeropad') zeropad = expt.naming.zeropad; else zeropad = 4; end

% Set directories
inpath = fullfile(basepath,expt.fad.corrected,expt.info.image{imageset},expt.fad.FAD_path_low);
outpath = fullfile(basepath,expt.file.datapath,'Processed/Registered/',expt.info.image{imageset});

% Create directory if it doesn't exist
if ~exist(outpath), mkdir(outpath); end

[optimizer, metric]  = imregconfig('monomodal');

% Get the list of files in the read directory
filelist = dir([inpath,expt.info.imagestart{imageset},'*',expt.fad.FAD_type_low]);

% Read the first image
infile = fullfile(inpath,filelist(1).name);
fixed = imread(infile);
copyfile(infile,outpath);

% Read and register each image
numfiles = length(filelist);
for i = 2:numfiles,

    infile = fullfile(inpath,filelist(i).name);
    fprintf(['Image ', num2str(i), ' of ', num2str(numfiles), '\n']);
    
    % Perform registration and image histogram matching
    moving = imread(infile);
    movingRegistered = imregister(moving,fixed,'translation',optimizer, metric);
    output=imhistmatch(movingRegistered,fixed);
    
    % Write the image
    outfile = fullfile(outpath,...
        [expt.info.imagestart{imageset},...
        expt.fad.FAD_file_low,...
        sprintf(['%.',num2str(zeropad),'d'],i),...
        expt.fad.FAD_type_low]);
    imwrite(output,outfile);
    
end