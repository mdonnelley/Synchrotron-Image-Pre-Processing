function info = ReadS8Data(data)

%
%**********************************************************
% Read data information from an CSV file
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

% Read the data file
fid = fopen(data);
file = textscan(fid, '%s %s %f %f %s %s %s %f %f %s %s %s %f %f %s', 'Delimiter', ',');
fclose(fid);

% Convert to a matlab cell array
info.image = file{1};
info.imagestart = file{2};
info.imagegofrom = file{3};
info.imagegoto = file{4};
info.imageformat = file{5};

info.flat = file{6};
info.flatstart = file{7};
info.flatgofrom = file{8};
info.flatgoto = file{9};
info.flatformat = file{10};

info.dark = file{11};
info.darkstart = file{12};
info.darkgofrom = file{13};
info.darkgoto = file{14};
info.darkformat = file{15};