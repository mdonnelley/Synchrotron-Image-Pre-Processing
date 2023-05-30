function [flat, dark] = AverageFlatDark(expt, imageset)

%
%**********************************************************
% Create average flat and dark images
%
% Written by: Martin Donnelley
% Date: 16/04/2010
% Last updated: 19/10/2021
%
%******************************************************
%

% Set the base pathname for the current machine
setbasepath;

%% Load and average all of the flat files
read_dir = fullfile(basepath, expt.file.raw, expt.info.flat{imageset});
flat_files = dir([read_dir, expt.info.flatstart{imageset}, '*']);
flat_average = fullfile(basepath, expt.fad.flatsdarks, [expt.info.flatstart{imageset}, '_FlatAverage.mat'])

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
    filelist = dir(fullfile(read_dir,[expt.info.flatstart{imageset},'*',expt.naming.type]));

    if isfield(expt.fad,'multipage'),
        input_file = fullfile(read_dir,filelist.name);
        numfiles = length(imfinfo(input_file));
        for i = 1:numfiles,
            fprintf(['Loading flat file ', num2str(i), ' of ', num2str(numfiles), '\n']);
            [rawimage, t] = ReadFileTime(input_file, i);
            flat = flat + double(rawimage) / numfiles;
        end
    else
        numfiles = length(filelist);
        for i = 1:numfiles,
            input_file = fullfile(read_dir,filelist(i).name)
            fprintf(['Loading flat file ', num2str(i), ' of ', num2str(numfiles), '\n']);
            [rawimage, t] = ReadFileTime(input_file);
            flat = flat + double(rawimage) / numfiles;
        end
    end

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
    filelist = dir(fullfile(read_dir,[expt.info.darkstart{imageset},'*',expt.naming.type]));

    if isfield(expt.fad,'multipage'),
        input_file = fullfile(read_dir,filelist.name);
        numfiles = length(imfinfo(input_file));
        for i = 1:numfiles,
            fprintf(['Loading dark file ', num2str(i), ' of ', num2str(numfiles), '\n']);
            [rawimage, t] = ReadFileTime(input_file, i);
            dark = dark + double(rawimage) / numfiles;
        end
    else
        numfiles = length(filelist);
        for i = 1:numfiles,
            input_file = fullfile(read_dir,filelist(i).name)
            fprintf(['Loading dark file ', num2str(i), ' of ', num2str(numfiles), '\n']);
            [rawimage, t] = ReadFileTime(input_file);
            dark = dark + double(rawimage) / numfiles;
        end
    end
    
    fprintf('Dark image is %.1f bits\n', log2(max(max(dark))));
    fprintf('Saving averaged dark file %s\n', dark_average);
    save(dark_average,'dark');
    
end