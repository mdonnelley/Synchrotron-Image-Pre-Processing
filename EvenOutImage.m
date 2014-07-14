function output = EvenOutImage(input)

%
%**********************************************************
% Perform image flattening
%
% Written by: Martin Donnelley
% Date: 27/11/2012
% Last updated: 27/11/2012
%
% From Andreas Fouras - Nov 26 2012
% Looking at the data 1 row at a time, adjust each pixel intensity so that
% the row has an average intensity of 1 (or some other value, such as the
% original image average intensity). Then do the same along each column of
% the image.  There is some advantage of perhaps repeating another once or
% twice. Let me know how this goes, or if there are any questions etc. (if
% it works, a citation might be nice.)
%
%******************************************************

% The intended image mean
IMAGEMEAN = 0.5;
REPEAT = 2;

output = double(input);

for i = 1:REPEAT,
    
    % Adjust each pixels intensity so that the row has an average intensity of imageMean
    rowMean = mean(output,2);
    denominator = repmat(rowMean,1,size(output,2));
    output = IMAGEMEAN .* output ./ denominator;
    
    % Adjust each pixels intensity so that the column has an average intensity of imageMean
    colMean = mean(output,1);
    denominator = repmat(colMean,size(output,1),1);
    output = IMAGEMEAN .* output ./ denominator;
    
end