% Script to produce an file list of all files acquired during a beamtime
%
% setbasepath
% S8_15B_XU
% WriteS8DataHIS

% Determine the save location
[FileName,PathName] = uiputfile(expt.file.filelist,'Save file name');

% Get the list of dates in the folder
date_dir = fullfile(basepath,expt.file.raw);

% Get the full filelist for all the date folders
filelist = dir(fullfile(date_dir, ['**\*',expt.naming.type]));
filelist = rmfield(filelist,{'date','bytes','isdir','datenum'});
filelist = orderfields(filelist,{'folder','name'});

for i = 1:length(filelist),
    
    % Work out which are flat, dark, grid
    flat(i) = contains(filelist(i).name, expt.naming.flat_prefix,'IgnoreCase',true);
    dark(i) = contains(filelist(i).name, expt.naming.dark_prefix,'IgnoreCase',true);
    grid(i) = contains(filelist(i).name, expt.naming.grid_prefix,'IgnoreCase',true);
    
    % Remove full path from folder
    filelist(i).folder = [filelist(i).folder(length(fullfile(basepath,expt.file.raw)):length(filelist(i).folder)),'\'];
    filelist(i).name = filelist(i).name(1:length(filelist(i).name)-4);
    
end

images = filelist(~(flat|dark|grid));
flats = filelist(flat);
darks = filelist(dark);
grids = filelist(grid);

data = [images;flats;darks];

% Write out the spreadsheet
writetable(struct2table(data), [PathName,FileName])
