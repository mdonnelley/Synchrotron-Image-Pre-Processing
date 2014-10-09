function [flat, dark] = AverageFlatDark(expt, imageset)

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

% Set the base pathname for the current machine
setbasepath;

%% Load and average all of the flat files
matfile = [[basepath,expt.file.raw], expt.info.flat{imageset}, expt.info.flatstart{imageset}, num2str(expt.info.flatgofrom(imageset)), '-', num2str(expt.info.flatgoto(imageset)),'.mat'];

% If the flat files already exist
if(exist(matfile, 'file')),   
    
    fprintf('Loading averaged flat file %s\n', matfile);
    load(matfile,'flat');

% If the flat files must be created
else
    
    fprintf('Processing flat files %s%s\n', [basepath,expt.file.raw], expt.info.flat{imageset});
    flat = 0;
    
    for i = expt.info.flatgofrom(imageset):expt.info.flatgoto(imageset),
        
        fprintf(['Loading flat file ', num2str(i), ' of ', num2str(expt.info.flatgoto(imageset)), '\n']);
        inimage = ReadFile([basepath,expt.file.raw], expt.info.flat{imageset}, expt.info.flatstart{imageset},expt.info.flatformat{imageset}, expt.info.flatgoto(imageset), i);
        flat = flat + double(inimage) / (expt.info.flatgoto(imageset) - expt.info.flatgofrom(imageset) + 1);
        
    end

    fprintf('Flat image is %.1f bits\n', log2(max(max(flat))));
    fprintf('Saving averaged flat file %s\n', matfile);
    save(matfile,'flat');
    
end

%% Load and average all of the dark files
matfile = [[basepath,expt.file.raw], expt.info.dark{imageset}, expt.info.darkstart{imageset}, num2str(expt.info.darkgofrom(imageset)), '-', num2str(expt.info.darkgoto(imageset)),'.mat'];


% If the dark files already exist
if(exist(matfile, 'file')),

    fprintf('Loading averaged dark file %s\n', matfile);
    load(matfile,'dark');

% If the dark files must be created
else
    
    fprintf('Processing dark files %s%s\n', [basepath,expt.file.raw], expt.info.dark{imageset});
    dark = 0;
    
    for i = expt.info.darkgofrom(imageset):expt.info.darkgoto(imageset),
        
        fprintf(['Loading dark file ', num2str(i), ' of ', num2str(expt.info.darkgoto(imageset)), '\n']);
        inimage = ReadFile([basepath,expt.file.raw], expt.info.dark{imageset}, expt.info.darkstart{imageset},expt.info.darkformat{imageset}, expt.info.darkgoto(imageset), i);
        dark = dark + double(inimage) / (expt.info.darkgoto(imageset) - expt.info.darkgofrom(imageset) + 1);
        
    end
    
    fprintf('Dark image is %.1f bits\n', log2(max(max(dark))));
    fprintf('Saving averaged dark file %s\n', matfile);
    save(matfile,'dark');
    
end