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

% Load the metadata from the dataset to analyse
eval(experiment);

% Load the info
expt.info = ReadS8Data(expt.file.filelist);

% Process each experiment
for imageset = expt.fad.runlist,
    
    start = now;
    
    fprintf('Processing imageset %d of %d\n', imageset, length(expt.info.image));
    
    % Load or average all of the flat and dark files
    [flat, dark] = AverageFlatDark(expt, imageset);
    
    % Perform the correction
    FlatDarkCorrect(expt, imageset, flat, dark);
    
    disp(['Total processing time was ', datestr(now - start,'HH:MM:SS:FFF')])
    
end

if(ispc && isfield(expt.file,'movies')), VirtualDub(expt.info); end