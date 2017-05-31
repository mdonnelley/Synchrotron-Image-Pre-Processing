function info = ReadS8Data(data)

%
%**********************************************************
% Read data information from an XLSX / CSV file
%
% written by: Martin Donnelley
% date: 16/04/2010
% last updated: 29/04/2011
% 
% The csv files should be exported from the excel files comma separated, with no quotation marks around strings
% 
% File paths in the input csv must be converted to unix format (backslashes converted to forwardslashes)
%
%******************************************************
%

% %% CSV
% 
% % Read the data file
% fid = fopen(data);
% file = textscan(fid, '%s %s %f %f %s %s %s %f %f %s %s %s %f %f %s', 'Delimiter', ',');
% fclose(fid);
% 
% % Convert to a matlab cell array
% info.image = file{1};
% info.imagestart = file{2};
% info.imagegofrom = file{3};
% info.imagegoto = file{4};
% info.imageformat = file{5};
% 
% info.flat = file{6};
% info.flatstart = file{7};
% info.flatgofrom = file{8};
% info.flatgoto = file{9};
% info.flatformat = file{10};
% 
% info.dark = file{11};
% info.darkstart = file{12};
% info.darkgofrom = file{13};
% info.darkgoto = file{14};
% info.darkformat = file{15};

%% XLSX

% Read the data file
[num,txt,raw] = xlsread(data,'','','basic');

% Convert to a matlab cell array
if size(raw,2) >= 5,
    info.image = txt(:,1);
    info.imagestart = txt(:,2);
    info.imagegofrom = num(:,1);
    info.imagegoto = num(:,2);
    info.imageformat = txt(:,5);
end

if size(raw,2) >= 10,
    info.flat = txt(:,6);
    info.flatstart = txt(:,7);
    info.flatgofrom = num(:,6);
    info.flatgoto = num(:,7);
    info.flatformat = txt(:,10);
end

if size(raw,2) >= 15,
    info.dark = txt(:,11);
    info.darkstart = txt(:,12);
    info.darkgofrom = num(:,11);
    info.darkgoto = num(:,12);
    info.darkformat = txt(:,15);
end

% Added for AS-2016-2 data to identify the first image in the breath
if size(num,2) == 14, info.startimage = num(:,14); end