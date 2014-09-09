function Process(experiment, info)

%
%**********************************************************
% Flat dark correct synchrotron data
%
% Written by: Martin Donnelley
% Date: 16/4/2010
% Last updated: 29/04/2011
%
%******************************************************
%

% Process each experiment
for imageset = experiment.runlist,
    
    start = now;
    
    fprintf('Processing imageset %d of %d\n', imageset, length(info.image));
    
    % Load or average all of the flat and dark files
    [flat, dark] = AverageFlatDark(info, experiment, imageset);
    
    % Perform the correction
    FlatDarkCorrect(experiment, info, imageset, flat, dark);
    
    disp(['Total processing time was ', datestr(now - start,'HH:MM:SS:FFF')])
    
end