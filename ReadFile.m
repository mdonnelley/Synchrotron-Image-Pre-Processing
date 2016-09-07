function image = ReadFile(filepath, base, start, format, magnitude, i)

%
%**********************************************************
% Read a Hammamatsu IMG file, multipage TIF or standard file format
%
% Written by: Martin Donnelley
% Date: 30/7/2010
% Last updated: 3/12/2010
%
%**********************************************************
%

%% Single page TIFF or IMG

% Get the filename
formatSpec = ['%s%s%s%.',num2str(magnitude),'d%s'];
current = sprintf(formatSpec,filepath,base,start,i,format);

% Load the image
if(exist(current)),
    
    if(format == '.img')
        
        % Open the file
        fid = fopen(current);
        
        % Read the file header
        header = fread(fid, 64, '*uint16', 'native');
        offset = header(2);
        width = header(3);
        height = header(4);
     
        % Read the image data
        fseek(fid, 64 + offset, 'bof');
        image = fread(fid, [width, height], '*uint16', 'native');
        
        % Transpose the image
        image = image';
        
        % Close the file
        fclose(fid);
        return;
        
    else
        
        % Read file types other than .img
        image = imread(current);
        return;
        
    end
    
    error('Check file format');
    
end

%% Multi page TIFF

% FRAMES_PER_SET = 100;
FRAMES_PER_SET = 193;

% Determine the set and index of the current image
set = floor((i - 1) / FRAMES_PER_SET);
idx = rem(i - 1, FRAMES_PER_SET) + 1;

% Get the filename
if(set > 0),
    current = sprintf('%s%s%s@%.4d%s',filepath,base,start,set,format);
else
    current = sprintf('%s%s%s%s',filepath,base,start,format);
end

% Load the image
if(exist(current))
    
    image = imread(current, idx);
    return;
    
end

%% Otherwise

error(['File / Image: ',current,' does not exist']);