function [flat, dark] = AverageFlatDark(expt, imageset)

%
%**********************************************************
% Create average flat and dark images
%
% Written by: Martin Donnelley
% Date: 16/04/2010
% Last updated: 4/04/2018
%
%******************************************************
%

% Set the base pathname for the current machine
setbasepath;
if isfield(expt.naming,'zeropad') zeropad = expt.naming.zeropad; else zeropad = 4; end

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
        if isfield(expt.fad,'multipage'),
            if expt.fad.multipage,
                imagename = [basepath,...
                    expt.file.raw,...
                    expt.info.flat{imageset},...
                    expt.info.flatstart{imageset},...
                    expt.info.flatformat{imageset}];
                [rawimage, t] = ReadFileTime(imagename, i);
            end
        else
            imagename = [basepath,...
                expt.file.raw,...
                expt.info.flat{imageset},...
                expt.info.flatstart{imageset},...
                sprintf(['%.',num2str(zeropad),'d'],i),...
                expt.info.flatformat{imageset}];
            [rawimage, t] = ReadFileTime(imagename);
        end
        inimage = double(rawimage);
        flat = flat + inimage / (expt.info.flatgoto(imageset) - expt.info.flatgofrom(imageset) + 1);
        
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
        if isfield(expt.fad,'multipage'),
            if expt.fad.multipage,
                imagename = [basepath,...
                    expt.file.raw,...
                    expt.info.dark{imageset},...
                    expt.info.darkstart{imageset},...
                    expt.info.darkformat{imageset}];
                [rawimage, t] = ReadFileTime(imagename, i);
            end
        else
            imagename = [basepath,...
                expt.file.raw,...
                expt.info.dark{imageset},...
                expt.info.darkstart{imageset},...
                sprintf(['%.',num2str(zeropad),'d'],i),...
                expt.info.darkformat{imageset}];
            [rawimage, t] = ReadFileTime(imagename);
        end
        inimage = double(rawimage);
        dark = dark + inimage / (expt.info.darkgoto(imageset) - expt.info.darkgofrom(imageset) + 1);
        
    end
    
    fprintf('Dark image is %.1f bits\n', log2(max(max(dark))));
    fprintf('Saving averaged dark file %s\n', matfile);
    save(matfile,'dark');
    
end