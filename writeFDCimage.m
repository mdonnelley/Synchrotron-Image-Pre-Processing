function writeFDCimage(expt, imageset, write_dir, index, final, t)

%
%**********************************************************
% Write the flat/dark corrected images
%
% Written by: Martin Donnelley
% Date: 19/10/2021
% Last updated: 19/10/2021
%
%******************************************************
%

% Create and save the high quality version (NOTE: the images are now 16-bit, not the original dynamic range)
if strcmp(expt.fad.output, 'HIGH') | strcmp(expt.fad.output, 'BOTH')
    SixteenBitImage = uint16(final * 65535);
    high = fullfile(write_dir,...
        expt.fad.FAD_path_high,...
        [expt.info.imagestart{imageset},...
        expt.fad.FAD_file_high,...
        index,...
        '.tif']);
    imwrite(SixteenBitImage, high, 'Description', num2str(t));
end

% Create and save the low quality version
if strcmp(expt.fad.output, 'LOW') | strcmp(expt.fad.output, 'BOTH')
    EightBitImage = uint8(final * 256);
    low = fullfile(write_dir,...
        expt.fad.FAD_path_low,...
        [expt.info.imagestart{imageset},...
        expt.fad.FAD_file_low,...
        index,...
        '.jpg']);
    imwrite(EightBitImage, low, 'Comment', num2str(t));
end