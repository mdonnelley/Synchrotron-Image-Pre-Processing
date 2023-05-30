function his2tif(infile, outfolder)

%
%**********************************************************
% Convert a Hipic HIS file to TIF images using SPring-8 his2tif.exe
%
% Written by: Martin Donnelley
% Date: 19/12/2022
% Last updated: 19/12/2022
%
%******************************************************
%

setbasepath;

% Save current working directory then change to HIS conversion EXE folder
currentFolder = pwd;
cd(fullfile(basepath,'SPring-8\HIS Format\his2tif\'));

% Remove any existing tif image files remaining from previous conversions
delete('a*.tif');

% Call his2tif.exe to do the TIF extraction from the HIS file
command = ['his2tif.exe "',infile,'"'];
system(command);

% Rename/move the output files
[filepath,name,ext] = fileparts(infile);
fileList = dir('a*.tif');
for i = 1:length(fileList),
    src = fileList(i).name;
    dest = fullfile(outfolder,[name,'_',src(2:length(src))]);
    movefile(src,dest);
end

% Change back to the original folder
cd(currentFolder);