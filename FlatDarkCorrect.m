function FlatDarkCorrect(expt, imageset, flat, dark);

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

% Set the base pathname for the current machine
setbasepath;

fprintf('Read directory %s%s\n', [basepath,expt.file.raw], expt.info.image{imageset});
fprintf('Write directory %s%s\n', [basepath,expt.fad.corrected], expt.info.image{imageset});

% Check destination directories exists
if strcmp(expt.fad.output, 'HIGH') | strcmp(expt.fad.output, 'BOTH')
    mkdir([[basepath,expt.fad.corrected],expt.info.image{imageset},expt.fad.FAD_path_high]);
end

if strcmp(expt.fad.output, 'LOW') | strcmp(expt.fad.output, 'BOTH')
    mkdir([[basepath,expt.fad.corrected],expt.info.image{imageset},expt.fad.FAD_path_low]);
end

% Perform the correction
for i = expt.info.imagegofrom(imageset):expt.info.imagegoto(imageset),
    
    fprintf(['Image ', num2str(i), ' of ', num2str(expt.info.imagegoto(imageset)), '\n']);
    
    % Load the image (images are likely 12 to 14-bit prior to FAD correction)
    inimage = double(ReadFile([basepath,expt.file.raw],expt.info.image{imageset},expt.info.imagestart{imageset},expt.info.imageformat{imageset}, 4, i));
    
    % Perform the flat / dark correction
    final = (inimage - dark) ./ (flat - dark);    
    final(isnan(final)) = 0;
    final(isinf(final)) = 1;
    
    % Filter image to remove beam movement
    if isfield(expt.fad,'filter') if(expt.fad.filter) final = EvenOutImage(final); end; end
    
    % Rotate, flip and crop the output image and adjust contrast
    if isfield(expt.fad,'rotation') final = imrotate(final,expt.fad.rotation); end
    if isfield(expt.fad,'flipud') if(expt.fad.flipud) final = flipud(final); end; end
    if isfield(expt.fad,'fliplr') if(expt.fad.fliplr) final = fliplr(final); end; end
    if isfield(expt.fad,'crop') final = final(expt.fad.crop(2):expt.fad.crop(4),expt.fad.crop(1):expt.fad.crop(3)); end
    if isfield(expt.fad,'adjust')   final = imadjust(final,expt.fad.adjust); end

    % Create and save the high quality version (NOTE: the images are now 16-bit, not the original dynamic range)
    if strcmp(expt.fad.output, 'HIGH') | strcmp(expt.fad.output, 'BOTH')
        SixteenBitImage = uint16(final * 65535);
        high = sprintf('%s%s%s%s%s%.4d%s',[basepath,expt.fad.corrected],expt.info.image{imageset},expt.fad.FAD_path_high,expt.info.imagestart{imageset},expt.fad.FAD_file_high,i,expt.fad.FAD_type_high);
        imwrite(SixteenBitImage, high);
    end
    
    % Create and save the low quality version
    if strcmp(expt.fad.output, 'LOW') | strcmp(expt.fad.output, 'BOTH')
        EightBitImage = uint8(final * 256);
        low = sprintf('%s%s%s%s%s%.4d%s',[basepath,expt.fad.corrected],expt.info.image{imageset},expt.fad.FAD_path_low,expt.info.imagestart{imageset},expt.fad.FAD_file_low,i,expt.fad.FAD_type_low);
        imwrite(EightBitImage, low);
    end
    
end