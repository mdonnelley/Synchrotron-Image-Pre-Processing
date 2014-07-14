function output = EvenOutImage(input)

%
%******************************************************
% Remove horizontal bands from the beam movement
%
% Written by: Martin Donnelley
%
% Utilises eliptical filter creation function from: 
% http://www.clear.rice.edu/elec301/Projects01/image_filt/matlab.html
%
%******************************************************
%

width = size(input,2);
height = size(input,1);
midw = floor(width/2);
midh = floor(height/2);

% Perform FFT
fftA = fftshift(fft2(input));

% Create the eliptical high-pass filter
filt = 1 - EFilter(size(input), .001, .025, 2);
filt(midh-1:midh+1,:) = 1;

% Apply the filter in the frequency domain
fftA = fftA .* filt;

% Perform inverse FFT
output = abs(ifft2(ifftshift(fftA)));

% Adjust the image brightness to match the input
output = output + (mean2(input) - mean2(output));
