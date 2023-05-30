function final = processFDCimage(expt, final)

%
%**********************************************************
% Filter, flip rotate, adjust contrast
%
% Written by: Martin Donnelley
% Date: 19/10/2021
% Last updated: 19/10/2021
%
%******************************************************
%

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
%             final = imadjust(final);  
            out = final - min(min(final)); % EDITED FOR 2022B
            final = out / max(max(out));
            final = medfilt2(final);
        end;
    else
        final = imadjust(final, expt.fad.adjust);
    end
end

% Crop the output image
if isfield(expt.fad,'crop') final = final(expt.fad.crop(2):expt.fad.crop(4),expt.fad.crop(1):expt.fad.crop(3)); end