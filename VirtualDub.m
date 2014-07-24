function VirtualDub(experiment, info)

%
%**********************************************************
% Create VirtualDub jobs list for movie creation
%
% Written by: Martin Donnelley
% Date: 16/04/2010
% 
%******************************************************
%

% Set input file information
IMAGESET = 'Low/';
FILENAME = 'fad_';
FILETYPE = '.jpg';

% Set file defaults
VD_LOCATION = 'C:\Program Files (x86)\VirtualDub-1.10.4\VirtualDub.exe';
VD_JOB_FILE = 'VirtualDub.jobs';
INPUTFORMAT = 0;            % Autodetect / same as input
OUTPUTFORMAT = 7;           % RGB888
MODE = 3;                   % Full processing MODE
FRAMERATE = 5;              % Set output FRAMERATE
COMPRESSION = 'Cinepak';

% Check destination directory exists
mkdir(experiment.movies);

% Write job list to a file
fid = fopen([experiment.write,VD_JOB_FILE], 'wt');

% Write the file header
fprintf(fid, '// $numjobs %d\n\n', length(experiment.runlist));

% Add each job to the list
for jobnumber = 1:length(experiment.runlist);

    % Determine the file information
	input = sprintf('%s%s%s%s%s%.4d%s',experiment.write,info.image{experiment.runlist(jobnumber)},IMAGESET,info.imagestart{experiment.runlist(jobnumber)},FILENAME,info.imagegofrom(experiment.runlist(jobnumber)),FILETYPE);
    output = sprintf('%s%s%.4d.avi',experiment.movies,info.imagestart{experiment.runlist(jobnumber)},info.imagegofrom(experiment.runlist(jobnumber)));
    frames = info.imagegoto(experiment.runlist(jobnumber)) - info.imagegofrom(experiment.runlist(jobnumber));

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
    switch COMPRESSION
        case 'Uncompressed'
            fprintf(fid, 'VirtualDub.video.SetCompression();\n');
        case 'Xvid'
            fprintf(fid, 'VirtualDub.video.SetCompression(0x64697678,0,10000,0);\n');
        case 'Cinepak'
            fprintf(fid, 'VirtualDub.video.SetCompression(0x64697663,0,10000,0);\n');
    end
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
VDrun = ['!"',VD_LOCATION,'" /s"',[experiment.write,VD_JOB_FILE],'" &'];
eval(VDrun);