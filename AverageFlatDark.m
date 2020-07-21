function [flat, dark] = AverageFlatDark(expt, imageset)

%
%**********************************************************
% Create average flat and dark images
%
% Written by: Martin Donnelley
% Date: 16/04/2010
% Last updated: 20/07/2020
%
%******************************************************
%

% Set the base pathname for the current machine
setbasepath;

%% Load and average all of the flat files
read_dir = fullfile(basepath, expt.file.raw, expt.info.flat{imageset});
flat_files = dir([read_dir, expt.info.flatstart{imageset}, '*']);
flat_average = fullfile(read_dir, [expt.info.flatstart{imageset}, 'Average.mat']);

% If the flat files already exist
if(exist(flat_average, 'file')),
    
    fprintf('Loading averaged flat file %s\n', flat_average);
    load(flat_average,'flat');
    
% If the flat files must be created
else
    
    fprintf('Processing flat files %s\n', fullfile(basepath,expt.file.raw,expt.info.flat{imageset}));
    flat = 0;
    filelist = dir([read_dir,expt.info.flatstart{imageset},'*',expt.naming.type]);
    
    for i = 1:length(filelist),
        input_file = fullfile(read_dir,filelist(i).name);
        fprintf(['Loading flat file ', num2str(i), ' of ', num2str(length(filelist)), '\n']);
        if isfield(expt.fad,'multipage'),
            if expt.fad.multipage,
                [rawimage, t] = ReadFileTime(input_file, i);
            end
        else
            [rawimage, t] = ReadFileTime(input_file);
        end
        inimage = double(rawimage);
        flat = flat + inimage / length(filelist);   
    end
    
    fprintf('Flat image is %.1f bits\n', log2(max(max(flat))));
    fprintf('Saving averaged flat file %s\n', flat_average);
    save(flat_average,'flat');
    
end

%% Load and average all of the dark files
read_dir = fullfile(basepath, expt.file.raw, expt.info.dark{imageset});
dark_files = dir([read_dir, expt.info.darkstart{imageset}, '*']);
dark_average = fullfile(read_dir, [expt.info.darkstart{imageset}, 'Average.mat']);

% If the dark files already exist
if(exist(dark_average, 'file')),
    
    fprintf('Loading averaged dark file %s\n', dark_average);
    load(dark_average,'dark');
    
% If the dark files must be created
else
    
    fprintf('Processing dark files %s\n', fullfile(basepath,expt.file.raw,expt.info.dark{imageset}));
    dark = 0;
	filelist = dir([read_dir,expt.info.darkstart{imageset},'*',expt.naming.type]);
    
    for i = 1:length(filelist),
        input_file = fullfile(read_dir,filelist(i).name);
        fprintf(['Loading dark file ', num2str(i), ' of ', num2str(length(filelist)), '\n']);
        if isfield(expt.fad,'multipage'),
            if expt.fad.multipage,
                [rawimage, t] = ReadFileTime(input_file, i);
            end
        else
            [rawimage, t] = ReadFileTime(input_file);
        end
        inimage = double(rawimage);
        dark = dark + inimage / length(filelist);
    end
    
    fprintf('Dark image is %.1f bits\n', log2(max(max(dark))));
    fprintf('Saving averaged dark file %s\n', dark_average);
    save(dark_average,'dark');
    
end