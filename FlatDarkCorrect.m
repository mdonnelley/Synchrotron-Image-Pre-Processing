function FlatDarkCorrect(expt, imageset, flat, dark);

%
%**********************************************************
% Perform flat and dark correction
%
% Written by: Martin Donnelley
% Date: 16/04/2010
% Last updated: 17/07/2020
%
%******************************************************
%

% Set the base pathname for the current machine
setbasepath;

% Set directories
read_dir = fullfile(basepath,expt.file.raw,expt.info.image{imageset});
fprintf('Read directory %s\n', read_dir);
write_dir = fullfile(basepath,expt.fad.corrected,expt.info.image{imageset});
fprintf('Write directory %s\n', write_dir);
if strcmp(expt.fad.output, 'HIGH') | strcmp(expt.fad.output, 'BOTH')
    mkdir(fullfile(write_dir,expt.fad.FAD_path_high));
end
if strcmp(expt.fad.output, 'LOW') | strcmp(expt.fad.output, 'BOTH')
    mkdir(fullfile(write_dir,expt.fad.FAD_path_low));
end

% Perform the correction
filelist = dir([read_dir,expt.info.imagestart{imageset},'*',expt.naming.type]);
for i = 1:length(filelist),
    
    input_file = [read_dir,filelist(i).name];
    fprintf(['Image ', num2str(i), ' of ', num2str(length(filelist)), '\n']);
    
    % Load the image (images are likely 12 to 16-bit prior to FAD correction)
    if exist(input_file),
        if isfield(expt.fad,'multipage'),
            if expt.fad.multipage,
                [rawimage, t] = ReadFileTime(input_file, i);
            end
        else
            [rawimage, t] = ReadFileTime(input_file);
        end
        inimage = double(rawimage);
        
        % Perform the flat / dark correction
        final = (inimage - dark) ./ (flat - dark);
        final(isnan(final)) = 0;
        final(isinf(final)) = 1;
        
        % Filter image to remove beam movement
        if isfield(expt.fad,'filter') if(expt.fad.filter) final = EvenOutImage(final); end; end
        
        % Anisotropic diffusion to remove noise
        if isfield(expt.fad,'anisodiff')
            num_iter = expt.fad.anisodiff;
            delta_t = 1/7;
            kappa = 30;
            option = 2;
            final = anisodiff2D(final,num_iter,delta_t,kappa,option);
        end
        
        % Rotate, flip and adjust contrast
        if isfield(expt.fad,'rotation') final = imrotate(final,expt.fad.rotation); end
        if isfield(expt.fad,'flipud') if expt.fad.flipud, final = flipud(final); end; end
        if isfield(expt.fad,'fliplr') if expt.fad.fliplr, final = fliplr(final); end; end
        if isfield(expt.fad,'adjust'),
            if islogical(expt.fad.adjust),
                if expt.fad.adjust,
                    final = imadjust(final);
                end;
            else
                final = imadjust(final, expt.fad.adjust);
            end
        end
        
    else
        
        warning(['File "',input_file,'" does not exist: Creating blank.'])
        final = 0.5 * ones(size(inimage));
        
    end
    
    % Crop the output image
    if isfield(expt.fad,'crop') final = final(expt.fad.crop(2):expt.fad.crop(4),expt.fad.crop(1):expt.fad.crop(3)); end
    
    outfile = regexp(filelist(i).name,'_|\.','split');
    
    % Create and save the high quality version (NOTE: the images are now 16-bit, not the original dynamic range)
    if strcmp(expt.fad.output, 'HIGH') | strcmp(expt.fad.output, 'BOTH')
        SixteenBitImage = uint16(final * 65535);
        high = fullfile(write_dir,...
            expt.fad.FAD_path_high,...
            [expt.info.imagestart{imageset},...
            expt.fad.FAD_file_high,...
            outfile{2},...
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
            outfile{2},...
            '.jpg']);       
        imwrite(EightBitImage, low, 'Comment', num2str(t));
    end
 
end