function FlatDarkCorrect(experiment, info, imageset, flat, dark);

%
%**********************************************************
% Perform flat and dark correction
%
% Written by: Martin Donnelley
% Date: 16/04/2010
% Last updated: 27/11/2012
%
%******************************************************
%

fprintf('Read directory %s%s\n', experiment.read, info.image{imageset});
fprintf('Write directory %s%s\n', experiment.write, info.image{imageset});

% Check destination directories exists
if strcmp(experiment.output, 'HIGH') | strcmp(experiment.output, 'BOTH')
    mkdir([experiment.write,info.image{imageset},experiment.FAD_path_high]);
end

if strcmp(experiment.output, 'LOW') | strcmp(experiment.output, 'BOTH')
    mkdir([experiment.write,info.image{imageset},experiment.FAD_path_low]);
end

% Perform the correction
for i = info.imagegofrom(imageset):info.imagegoto(imageset),
    
    fprintf(['Image ', num2str(i), ' of ', num2str(info.imagegoto(imageset)), '\n']);
    
    % Load the image (images are likely 12 to 14-bit prior to FAD correction)
    inimage = double(ReadFile(experiment.read,info.image{imageset},info.imagestart{imageset},info.imageformat{imageset}, info.imagegoto(imageset), i));
    
    % Perform the flat / dark correction
    final = (inimage - dark) ./ (flat - dark);    
    final(isnan(final)) = 0;
    final(isinf(final)) = 1;

    % Rotate the output image
    final = imrotate(final,experiment.rotation);
    
    % Crop the image
    if isfield(experiment,'crop')
        final = final(experiment.crop(2):experiment.crop(4),experiment.crop(1):experiment.crop(3));
    end
    
    % Filter image to remove beam movement
    final = EvenOutImage(final);

    % Create and save the high quality version (NOTE: the images are now 16-bit, not the original dynamic range)
    if strcmp(experiment.output, 'HIGH') | strcmp(experiment.output, 'BOTH')
        SixteenBitImage = uint16(final * 65535);
        high = sprintf('%s%s%s%s%s%.4d%s',experiment.write,info.image{imageset},experiment.FAD_path_high,info.imagestart{imageset},experiment.FAD_file_high,i,experiment.FAD_type_high);
        imwrite(SixteenBitImage, high);
    end
    
    % Create and save the low quality version
    if strcmp(experiment.output, 'LOW') | strcmp(experiment.output, 'BOTH')
        EightBitImage = uint8(final * 256);
        low = sprintf('%s%s%s%s%s%.4d%s',experiment.write,info.image{imageset},experiment.FAD_path_low,info.imagestart{imageset},experiment.FAD_file_low,i,experiment.FAD_type_low);
        imwrite(EightBitImage, low);
    end
    
end