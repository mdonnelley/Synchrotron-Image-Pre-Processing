function final = processFDCimage(expt, final, previous)

%
%**********************************************************
% Filter, flip rotate, adjust contrast
%
% Written by: Martin Donnelley
% Date: 19/10/2021
% Last updated: 16/08/2024
%
%******************************************************
%

% Remove out of range values
final(isnan(final)) = 0;
final(isinf(final)) = 1;

% Perform subtraction and blanking
if isfield(expt.fad,'subtract') 
    if expt.fad.subtract
        final = final - previous + 0.5;
        if isfield(expt.fad,'blank')
            imsum = sum(sum(abs(final - 0.5)));
            if imsum > 1.5e5
                final = 0.5*ones(size(final));
            end
        end
    end
end

% Rotate and flip
if isfield(expt.fad,'rotation') final = imrotate(final,expt.fad.rotation); end
if isfield(expt.fad,'flipud') if expt.fad.flipud, final = flipud(final); end; end
if isfield(expt.fad,'fliplr') if expt.fad.fliplr, final = fliplr(final); end; end

% Process image to remove beam movement/flicker
if isfield(expt.fad,'evenout') if(expt.fad.evenout) final = EvenOutImage(final); end; end

% Adjust/stretch contrast
if isfield(expt.fad,'adjust')
    s = stretchlim(final);
    s_low = s(1)*0.7;
    s_high = s(2)*1.3;
    if s_high > 1, s_high = 1; end
    final = imadjust(final,[s_low, s_high],[0 1]); % EDITED for 2023B S8-2023B-R08 onwards    
end

% Filter image to remove noise
if isfield(expt.fad,'medfilt') if expt.fad.medfilt, final = medfilt2(final); end; end
if isfield(expt.fad,'anisodiff')
    num_iter = expt.fad.anisodiff;
    delta_t = 1/7;
    kappa = 30;
    option = 2;
    final = anisodiff2D(final,num_iter,delta_t,kappa,option);
end

% Crop the output image
if isfield(expt.fad,'crop') final = final(expt.fad.crop(2):expt.fad.crop(4),expt.fad.crop(1):expt.fad.crop(3)); end