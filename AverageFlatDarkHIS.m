function [flat, dark] = AverageFlatDarkHIS(expt, imageset)

%
%**********************************************************
% Create average flat and dark images
%
% Written by: Martin Donnelley
% Date: 16/04/2010
% Last updated: 15/12/2023
%
%******************************************************
%

% Set the base pathname for the current machine
setbasepath;

if ~strcmp(expt.naming.type, '.his'),
    error('Input file type is not HIS');
end

%% Load and average all of the flat files
read_dir = fullfile(basepath, expt.file.raw, expt.info.flat{imageset});
flat_files = dir([read_dir, expt.info.flatstart{imageset}, '*']);                                           % UPDATE THIS
flat_average = fullfile(basepath, expt.fad.flatsdarks, [expt.info.flatstart{imageset}, '_FlatAverage.mat'])

if ~exist(fullfile(basepath, expt.fad.flatsdarks)), 
    mkdir(fullfile(basepath, expt.fad.flatsdarks)) 
end

% If there is no flat file listed in the XLS sheet
if isempty(expt.info.flat{imageset}),
    
    flat = 2^15 * ones(2048,2048);

% If the flat files already exist
elseif(exist(flat_average, 'file')),
    
    fprintf('Loading averaged flat file %s\n', flat_average);
    load(flat_average,'flat');
    
% If the flat files must be created
else
    
    fprintf('Processing flat files %s\n', fullfile(basepath,expt.file.raw,expt.info.flat{imageset}));
    flat = 0;

    filelist = dir(fullfile(read_dir,[expt.info.flatstart{imageset},expt.naming.type]));                    % UPDATE THIS
    flatfile = his(fullfile(filelist.folder,filelist.name));
    flatfile = flatfile.openStream();
    for i = 1:flatfile.numFrames,
        fprintf(['Loading flat file ', num2str(i), ' of ', num2str(flatfile.numFrames), '\n']);
        rawimage = flatfile.getFrame(i);
        flat = flat + double(rawimage) / flatfile.numFrames;
    end
    flatfile = flatfile.closeStream();

    fprintf('Flat image is %.1f bits\n', log2(max(max(flat))));
    fprintf('Saving averaged flat file %s\n', flat_average);
    save(flat_average,'flat');
    
end

%% Load and average all of the dark files
read_dir = fullfile(basepath, expt.file.raw, expt.info.dark{imageset});
dark_files = dir([read_dir, expt.info.darkstart{imageset}, '*']);
dark_average = fullfile(basepath, expt.fad.flatsdarks, [expt.info.darkstart{imageset}, '_DarkAverage.mat']);

% If there is no dark file listed in the XLS sheet
if isempty(expt.info.dark{imageset}),
    
    dark = zeros(2048,2048);

% If the flat files already exist
elseif(exist(dark_average, 'file')),
    
    fprintf('Loading averaged dark file %s\n', dark_average);
    load(dark_average,'dark');
    
% If the dark files must be created
else
    
    fprintf('Processing dark files %s\n', fullfile(basepath,expt.file.raw,expt.info.dark{imageset}));
    dark = 0;

    filelist = dir(fullfile(read_dir,[expt.info.darkstart{imageset},expt.naming.type]));
    darkfile = his(fullfile(filelist.folder,filelist.name));
    darkfile = darkfile.openStream();
    for i = 1:darkfile.numFrames,
        fprintf(['Loading dark file ', num2str(i), ' of ', num2str(darkfile.numFrames), '\n']);
        rawimage = darkfile.getFrame(i);
        dark = dark + double(rawimage) / darkfile.numFrames;
    end
    darkfile = darkfile.closeStream();
    
    fprintf('Dark image is %.1f bits\n', log2(max(max(dark))));
    fprintf('Saving averaged dark file %s\n', dark_average);
    save(dark_average,'dark');
    
end