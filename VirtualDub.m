function VirtualDub(experiment, info)

%
%**********************************************************
% Create VirtualDub jobs list for movie creation
%
% Written by: Martin Donnelley
% Date: 16/04/2010
% Last updated: 9/5/2011
%
% 
% write = 'I:/SPring-8/2012 A/20XU/MCT/Images/FD Corrected/'
% movies = 'I:/SPring-8/2012 A/20XU/MCT/Images/FD Corrected/Movies/'
% filelist = 'I:/SPring-8/2012 A/20XU/MCT/Images/2012A Data.csv'
% info = ReadS8Data(filelist);
% explist = [1:86];
% VirtualDub(write, movies, info, explist);
% 
%******************************************************
%

% Set input file information
IMAGESET = 'Low/';
FILENAME = 'fad_';
FILETYPE = '.jpg';

% Set file defaults (Change in FlatDarkCorrect too if required)
VD_LOCATION = 'C:\VirtualDub-1.9.11\VirtualDub.exe';
VD_JOB_FILE = 'C:\VirtualDub-1.9.11\VirtualDub.jobs';
INPUTFORMAT = 0;            % Autodetect / same as input
OUTPUTFORMAT = 7;           % RGB888
MODE = 3;                   % Full processing MODE
FRAMERATE = 400/60;         % Set output FRAMERATE

% Check destination directory exists
mkdir(experiment.write);

% Write job list to a file
fid = fopen(VD_JOB_FILE, 'wt');

% Write the file header
fprintf(fid, '// $numjobs %d\n\n', length(experiment.runlist));

% Add each job to the list
for jobnumber = 1:length(experiment.runlist);

    % Determine the file information
	input = sprintf('%s%s%s%s%s%.4d%s',experiment.read,info.image{experiment.runlist(jobnumber)},IMAGESET,info.imagestart{experiment.runlist(jobnumber)},FILENAME,info.imagegofrom(experiment.runlist(jobnumber)),FILETYPE);
    output = sprintf('%s%s.avi',experiment.write,info.imagestart{experiment.runlist(jobnumber)});
    frames = info.imagegoto(experiment.runlist(jobnumber)) - info.imagegofrom(experiment.runlist(jobnumber));
%     frames = length(dir(sprintf('%s%s%s%s%s*%s',experiment.read,info.image{experiment.runlist(jobnumber)},IMAGESET,info.imagestart{experiment.runlist(jobnumber)},FILENAME,FILETYPE)));

    % Write the job information
    fprintf(fid, '// $job "Job %d"\n', jobnumber);
    fprintf(fid, '// $input "%s"\n', input);
    fprintf(fid, '// $output "%s"\n\n', output);

    % Write the script for the job
    fprintf(fid, '// $script\n');
    fprintf(fid, 'VirtualDub.Open(U"%s","",0);\n', input);
    fprintf(fid, 'VirtualDub.video.SetInputFormat(%d);\n', INPUTFORMAT);
    fprintf(fid, 'VirtualDub.video.SetOutputFormat(%d);\n', OUTPUTFORMAT);
    fprintf(fid, 'VirtualDub.video.SetMode(%d);\n', MODE);
    fprintf(fid, 'VirtualDub.video.SetFrameRate2(%d,1,1);\n', FRAMERATE);
    fprintf(fid, 'VirtualDub.video.SetIVTC(0, 0, 0, 0);\n');
%    fprintf(fid, 'VirtualDub.video.SetCompression();\n');   % Uncompressed
%    fprintf(fid, 'VirtualDub.video.SetCompression(0x64697678,0,10000,0);\n');   % Xvid
    fprintf(fid, 'VirtualDub.video.SetCompression(0x64697663,0,10000,0);\n');   % Cinepak
    fprintf(fid, 'VirtualDub.video.filters.Clear();\n');
    fprintf(fid, 'VirtualDub.subset.Clear();\n');
    fprintf(fid, 'VirtualDub.subset.AddRange(0,%d);\n', frames);
    fprintf(fid, 'VirtualDub.project.ClearTextInfo();\n');
    fprintf(fid, 'VirtualDub.SaveAVI(U"%s");\n', output);
    fprintf(fid, 'VirtualDub.Close();\n');
    fprintf(fid, '// $endjob\n\n');
    
end

% Write the file footer
fprintf(fid, '// $done\n');

% Close the job list file
fclose(fid);

% Run the VirtualDub job
VDrun = ['!',VD_LOCATION,' /s"',VD_JOB_FILE,'" &'];
% eval(VDrun);