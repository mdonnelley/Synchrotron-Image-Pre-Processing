function info = ReadS8Data(data)

%
%**********************************************************
% Read data information from an XLSX
%
% written by: Martin Donnelley
% date: 16/04/2010
% last updated: 17/07/2020
%
%******************************************************
%

% Read the data file
[num,txt,raw] = xlsread(data,'','','basic');

% Convert to a matlab cell array
% if size(raw,2) >= 5,
    info.image = txt(:,1);
    info.imagestart = txt(:,2);
%     info.imagegofrom = num(:,1);
%     info.imagegoto = num(:,2);
%     info.imageformat = txt(:,5);
% end

% if size(raw,2) >= 10,
    info.flat = txt(:,6);
    info.flatstart = txt(:,7);
%     info.flatgofrom = num(:,6);
%     info.flatgoto = num(:,7);
%     info.flatformat = txt(:,10);
% end

% if size(raw,2) >= 15,
    info.dark = txt(:,11);
    info.darkstart = txt(:,12);
%     info.darkgofrom = num(:,11);
%     info.darkgoto = num(:,12);
%     info.darkformat = txt(:,15);
% end

% Added for AS-2016-2 data to identify the first image in the breath
if size(num,2) == 14, info.startimage = num(:,14); end