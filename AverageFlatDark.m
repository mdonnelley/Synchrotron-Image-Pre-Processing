function [flat, dark] = AverageFlatDark(info, experiment, imageset)

%
%**********************************************************
% Create average flat and dark images
%
% Written by: Martin Donnelley
% Date: 16/04/2010
% Last updated: 29/04/2011
%
%******************************************************
%

%% Load and average all of the flat files
matfile = [experiment.read, info.flat{imageset}, info.flatstart{imageset}, num2str(info.flatgofrom(imageset)), '-', num2str(info.flatgoto(imageset)),'.mat'];

% If the flat files already exist
if(exist(matfile, 'file')),   
    
    fprintf('Loading averaged flat file %s\n', matfile);
    load(matfile,'flat');

% If the flat files must be created
else
    
    fprintf('Processing flat files %s%s\n', experiment.read, info.flat{imageset});
    flat = 0;
    
    for i = info.flatgofrom(imageset):info.flatgoto(imageset),
        
        fprintf(['Loading flat file ', num2str(i), ' of ', num2str(info.flatgoto(imageset)), '\n']);
        inimage = ReadFile(experiment.read, info.flat{imageset}, info.flatstart{imageset},info.flatformat{imageset}, info.flatgoto(imageset), i);
        flat = flat + double(inimage) / (info.flatgoto(imageset) - info.flatgofrom(imageset) + 1);
        
    end

    fprintf('Flat image is %.1f bits\n', log2(max(max(flat))));
    fprintf('Saving averaged flat file %s\n', matfile);
    save(matfile,'flat');
    
end

%% Load and average all of the dark files
matfile = [experiment.read, info.dark{imageset}, info.darkstart{imageset}, num2str(info.darkgofrom(imageset)), '-', num2str(info.darkgoto(imageset)),'.mat'];


% If the dark files already exist
if(exist(matfile, 'file')),

    fprintf('Loading averaged dark file %s\n', matfile);
    load(matfile,'dark');

% If the dark files must be created
else
    
    fprintf('Processing dark files %s%s\n', experiment.read, info.dark{imageset});
    dark = 0;
    
    for i = info.darkgofrom(imageset):info.darkgoto(imageset),
        
        fprintf(['Loading dark file ', num2str(i), ' of ', num2str(info.darkgoto(imageset)), '\n']);
        inimage = ReadFile(experiment.read, info.dark{imageset}, info.darkstart{imageset},info.darkformat{imageset}, info.darkgoto(imageset), i);
        dark = dark + double(inimage) / (info.darkgoto(imageset) - info.darkgofrom(imageset) + 1);
        
    end
    
    fprintf('Dark image is %.1f bits\n', log2(max(max(dark))));
    fprintf('Saving averaged dark file %s\n', matfile);
    save(matfile,'dark');
    
end