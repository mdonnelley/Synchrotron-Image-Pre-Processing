function convertHIS(infolder)

%
%**********************************************************
% Convert an experimental folder of Hipic HIS files to TIF
% Save from ...\Input\ to ...\Output\
%
% Written by: Martin Donnelley
% Date: 19/12/2022
% Last updated: 19/12/2022
%
% setbasepath
% infolder = fullfile(basepath,'SPring-8\2023 A\Input\Images\')
% convertHIS(infolder)
%
%******************************************************
%

%% HIS files
% Get a recursive file list of all HIS files
cd(infolder);
files = dir('**/*.his');

% Convert each file to TIF
for i = 1:length(files)
   infile = fullfile(files(i).folder,files(i).name)
   outfolder = replace(files(i).folder,'Input','Output');
   if(~exist(outfolder))
       mkdir(outfolder);
       his2tif(infile,outfolder);
   end
end

%% TIF files
% Get a recursive file list of all TIF files
files = dir('**/*.tif')

% Copy all TIF files to the output folder
for i = 1:length(files)
   infile = fullfile(files(i).folder,files(i).name)
   outfolder = replace(files(i).folder,'Input','Output');
   if(~exist(outfolder))
       mkdir(outfolder);
       copyfile(infile,outfolder);
   end
end