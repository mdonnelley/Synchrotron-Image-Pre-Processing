function [imNumber,dt] = DateStampPCO(input);
% http://www.pco.de/fileadmin/user_upload/pco-manuals/MA_PCOEDGE_0103.pdf
% 
% A time stamp can be placed into the upper left corner of the image. It can 
% be either off, binary, or binary with text. The time resolution is 1µs.
% In  binary  mode  the  first  16  pixels  will  be  filled  with  the  time  stamp
% information (binary code). The numbers are coded in BCD with one byte per 
% pixel, which means that every pixel can hold 2 digits. If the pixels have more 
% resolution as 8 bits, then the BCD digits are right bound adjusted  and the 
% upper bits are zero. For further information please refer to the SDK.
% In binary and  ASCII  mode  text will be placed into the image  replacing the 
% content of the image (271x 8 pixels).
%
% t = 86400 * datenum(dt); % To get time since 1 Jan 1900 in seconds

% Read the first 16 pixels and convert each 8-bit BCD value to an integer
for i = 1:16,
    
    dt(2*i-1) = bitshift(input(1,i),-4);
    dt(2*i) = bitand(input(1,i),15);
    
end

% Extract the image number
imNumber = str2num(sprintf('%1d',dt(1:8)));

% Extract the time/date stamp
DateVector = [...
    str2num(sprintf('%1d',dt(9:12))),...          % Year
    str2num(sprintf('%1d',dt(13:14))),...         % Month
    str2num(sprintf('%1d',dt(15:16))),...         % Date
    str2num(sprintf('%1d',dt(17:18))),...         % Hour
    str2num(sprintf('%1d',dt(19:20))),...         % Minute
    str2num(sprintf('%1d',dt(21:22))) + ...       % Seconds
    str2num(sprintf('%1d',dt(23:25))) / 1000];    % Milliseconds

% Convert the date to human readable format
dt = datetime(DateVector);

% Check that the conversion was successful
if(size(dt,1) ~= 1) warning('No time stamp detected in PCO file'); end