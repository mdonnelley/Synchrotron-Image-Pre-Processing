%% Set read and write directories and the location of the experiment filelist
% NOTE: The read and write folder parameters must be followed by a trailing forwardslash

if(isunix), datapath = '/data/RAID0/exports/processing/';
% if(isunix), datapath = '/media/Synology/Imaging/';
elseif(ispc), datapath = 'P:/'; end

% S8 2009 B
experiment(1).read = [datapath,'SPring-8/2009 B/MCT/Images/Raw/'];
experiment(1).write = [datapath,'SPring-8/2009 B/MCT/Images/FD Corrected/'];
experiment(1).filelist = [datapath,'SPring-8/2009 B/MCT/Images/S8_09B_XU.csv'];
experiment(1).rotation = 90;
experiment(1).runlist = 1:28;
experiment(1).FAD_path_high = 'High/';
experiment(1).FAD_file_high = 'fad_';
experiment(1).FAD_type_high = '.tif';
experiment(1).FAD_path_low = 'Low/';
experiment(1).FAD_file_low = 'fad_';
experiment(1).FAD_type_low = '.jpg';
experiment(1).output = 'BOTH';

% S8 2010 A
experiment(2).read = [datapath,'SPring-8/2010 A/Images/Raw/'];
experiment(2).write = [datapath,'SPring-8/2010 A/Images/FD Corrected/'];
experiment(2).filelist = [datapath,'SPring-8/2010 A/Images/S8_10A_B2.csv'];
experiment(2).rotation = 0;
experiment(2).runlist = [1:10,22:28];
experiment(2).FAD_path_high = 'High/';
experiment(2).FAD_file_high = '_fad_';
experiment(2).FAD_type_high = '.tif';
experiment(2).FAD_path_low = 'Low/';
experiment(2).FAD_file_low = '_fad_';
experiment(2).FAD_type_low = '.jpg';
experiment(2).output = 'BOTH';

% S8 2010 B
experiment(3).read = [datapath,'SPring-8/2010 B/20XU/MCT/Images/Raw/'];
experiment(3).write = [datapath,'SPring-8/2010 B/20XU/MCT/Images/FD Corrected/'];
experiment(3).movies = [datapath,'SPring-8/2010 B/20XU/MCT/Images/FD Corrected/Movies/'];
experiment(3).filelist = [datapath,'SPring-8/2010 B/20XU/MCT/Images/S8_10B_XU.csv'];
experiment(3).rotation = 0;
experiment(3).runlist = 8:72;
experiment(3).FAD_path_high = 'High/';
experiment(3).FAD_file_high = '_fad_';
experiment(3).FAD_type_high = '.tif';
experiment(3).FAD_path_low = 'Low/';
experiment(3).FAD_file_low = '_fad_';
experiment(3).FAD_type_low = '.jpg';
experiment(3).output = 'BOTH';

% S8 2011 A
experiment(4).read = [datapath,'SPring-8/2011 A/20B2/Images/Raw/'];
experiment(4).write = [datapath,'SPring-8/2011 A/20B2/Images/FD Corrected/'];
experiment(4).filelist = [datapath,'SPring-8/2011 A/20B2/Images/S8_11A_B2.csv'];
experiment(4).rotation = 0;
experiment(4).runlist = [1:15,20:22,26:27,34:35,37:46];
experiment(4).FAD_path_high = 'High/';
experiment(4).FAD_file_high = '_fad_';
experiment(4).FAD_type_high = '.tif';
experiment(4).FAD_path_low = 'Low/';
experiment(4).FAD_file_low = '_fad_';
experiment(4).FAD_type_low = '.jpg';
experiment(4).output = 'BOTH';

% S8 2011 B
experiment(5).read = [datapath,'SPring-8/2011 B/20XU/MCT/Images/Raw/'];
experiment(5).write = [datapath,'SPring-8/2011 B/20XU/MCT/Images/FD Corrected/'];
experiment(5).movies = [datapath,'SPring-8/2011 B/20XU/MCT/Images/FD Corrected/Movies/'];
experiment(5).filelist = [datapath,'SPring-8/2011 B/20XU/MCT/Images/S8_11B_XU.csv'];
experiment(5).rotation = 0;
experiment(5).runlist = 4:19;
experiment(5).FAD_path_low = 'Low/';
experiment(5).FAD_file_low = '_fad_';
experiment(5).FAD_type_low = '.jpg';
experiment(5).output = 'LOW';

% S8 2012 A
experiment(6).read = [datapath,'SPring-8/2012 A/20XU/MCT/Images/Raw/'];
experiment(6).write = [datapath,'SPring-8/2012 A/20XU/MCT/Images/FD Corrected/'];
experiment(6).movies = [datapath,'SPring-8/2012 A/20XU/MCT/Images/FD Corrected/Movies/'];
experiment(6).filelist = [datapath,'SPring-8/2012 A/20XU/MCT/Images/S8_12A_XU.csv'];
experiment(6).rotation = 0;
experiment(6).runlist = [1 3 5 7 8 10 11 13 15 17 19 21 23 25 27 29 30 32 34 36 37 39 41 43 44 46 47 49 51 53 54 56 57 59 61 63 65 67 69 71 73 75 77 79 81 83 84 86];
experiment(6).FAD_path_low = 'Low/';
experiment(6).FAD_file_low = 'fad_';
experiment(6).FAD_type_low = '.jpg';
experiment(6).output = 'LOW';

% S8 2012 B
experiment(7).read = [datapath,'SPring-8/2012 B/MCT/Images/Raw/'];
experiment(7).write = [datapath,'SPring-8/2012 B/MCT/Images/FD Corrected/'];
experiment(7).movies = [datapath,'SPring-8/2012 B/MCT/Images/FD Corrected/Movies/'];
experiment(7).filelist = [datapath,'SPring-8/2012 B/MCT/Images/S8_12B_XU.csv'];
experiment(7).rotation = -90;
experiment(7).runlist = 1:17;
experiment(7).FAD_path_low = 'Low/';
experiment(7).FAD_file_low = 'fad_';
experiment(7).FAD_type_low = '.jpg';
experiment(7).output = 'LOW';

% AS 2013-1
experiment(7).read = [datapath,'Australian Synchrotron/2013-1/Images/Raw/'];
experiment(7).write = [datapath,'Australian Synchrotron/2013-1/Images/FD Corrected/'];
experiment(7).filelist = [datapath,'Australian Synchrotron/2013-1/Images/AS_2013-1.csv'];
experiment(7).rotation = 0;
experiment(7).runlist = 1:17;
experiment(7).FAD_path_low = 'Low/';
experiment(7).FAD_file_low = 'fad_';
experiment(7).FAD_type_low = '.jpg';
experiment(7).output = 'LOW';

% S8 2013 A: 20XU
experiment(9).read = [datapath,'SPring-8/2013 A/20XU/MCT/Images/Raw/'];
experiment(9).write = [datapath,'SPring-8/2013 A/20XU/MCT/Images/FD Corrected/'];
experiment(9).movies = [datapath,'SPring-8/2013 A/20XU/MCT/Images/FD Corrected/Movies/'];
experiment(9).filelist = [datapath,'SPring-8/2013 A/20XU/MCT/Images/S8_13A_XU.csv'];
experiment(9).rotation = 0;
experiment(9).runlist = [1:8,11:12,14:22,25:28,30:36,38:42,47:58,60:67];
experiment(9).FAD_path_low = 'Low/';
experiment(9).FAD_file_low = 'fad_';
experiment(9).FAD_type_low = '.jpg';
experiment(9).output = 'LOW';

% S8 2013 A: 20B2
experiment(10).read = [datapath,'SPring-8/2013 A/20B2/Images/Raw/'];
experiment(10).write = [datapath,'SPring-8/2013 A/20B2/Images/FD Corrected/'];
experiment(10).filelist = [datapath,'SPring-8/2013 A/20B2/Images/S8_13A_B2.csv'];
experiment(10).rotation = 0;
experiment(10).runlist = 1:2;
experiment(10).FAD_path_high = 'High/';
experiment(10).FAD_file_high = 'fad_';
experiment(10).FAD_type_high = '.tif';
experiment(10).output = 'HIGH';

% S8 2013 B: 20XU
experiment(11).read = [datapath,'SPring-8/2013 B/MCT/Images/Raw/'];
experiment(11).write = [datapath,'SPring-8/2013 B/MCT/Images/FD Corrected/'];
experiment(11).filelist = [datapath,'SPring-8/2013 B/MCT/Images/S8_13B_XU.csv'];
experiment(11).rotation = 90;
experiment(11).runlist = 1:64;
experiment(11).FAD_path_low = 'Low/';
experiment(11).FAD_file_low = 'fad_';
experiment(11).FAD_type_low = '.jpg';
experiment(11).output = 'LOW';

% S8 2014 A: 20XU
experiment(12).read = [datapath,'SPring-8/2014 A/MCT/Images/Raw/'];
experiment(12).write = [datapath,'SPring-8/2014 A/MCT/Images/FD Corrected/'];
experiment(12).filelist = [datapath,'SPring-8/2014 A/MCT/Images/S8_14A_XU.csv'];
experiment(12).rotation = 0;
experiment(12).runlist = 28:48;
experiment(12).FAD_path_low = 'Low/';
experiment(12).FAD_file_low = 'fad_';
experiment(12).FAD_type_low = '.jpg';
experiment(12).output = 'LOW';

%% Perform the analysis

% Set the experiments to analyse
exptlist = [12];

for expts = exptlist,
    
    % Determine the data to process
    info = ReadS8Data(experiment(expts).filelist);
    
    % Process each experiment
    Process(experiment(expts), info);

%     % Create movies from selected FAD files in the filelist using VirtualDub
%     if(ispc), VirtualDub(experiment(expts), info); end
    
end