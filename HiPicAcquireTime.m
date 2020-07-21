function t = HiPicAcquireTime(filename)

% Function to extract image acquire time from TIF images saved by HiPic
% software. The return value is the number of seconds that have elapsed
% since the first image in the sequence was captured.

info = imfinfo(filename);
HiPicMetadata = info.ImageDescription;

timeString = regexp(HiPicMetadata,'Time="(.*)ms"','tokens');
if isempty(timeString),
    t = 0;
else
    t = str2num(string(timeString)) / 1000;
end