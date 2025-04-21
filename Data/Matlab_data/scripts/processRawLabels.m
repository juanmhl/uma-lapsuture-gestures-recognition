function labels = processRawLabels(rawLabels,length)
% processRawLabels - Process raw label data into a format suitable for further analysis.
%
% Usage:
%   labels = processRawLabels(rawLabels, length)
%
% Inputs:
%   rawLabels - Raw label data containing information about frames and gestures.
%               It should be a doubles array with dimensions (N x 3), where N is
%               the number of rows and each row contains information about a
%               gesture, with the first column representing the starting frame,
%               the second column representing the ending frame, and the third
%               column containing the gesture label for that frames region.
%   length    - Length of the output array (total number of frames).
%
% Output:
%   labels    - Processed labels represented as a numeric array of size (length x 1).
%               Each element of the array corresponds to a frame, containing the
%               gesture label for that frame. Frames without a gesture label will
%               have a value of zero (0).
%
% Notes:
%   - The function processes the raw label data by extracting information about
%     the starting frame, ending frame, and gesture label from each row of the
%     rawLabels array, and then assigns the gesture label to the corresponding
%     frames in the output array.
%   - If the rawLabels data is found to be corrupt (e.g., empty), the output
%     array will be empty as well.
%
% Example:
%   rawLabels = {'10', '20', 'G1'; '25', '30', 'G2'; '35', '40', 'G3'};
%   length = 50;
%   labels = processRawLabels(rawLabels, length);
%
%   In this example, the function will generate a labels array of length 50
%   where frames 10 to 20 will have label 1, frames 25 to 30 will have label 2,
%   frames 35 to 40 will have label 3, and the remaining frames will have a
%   label of zero.
%
% See also:
%   extract
%
% Author: Juan María Herrera López
% Created: 08-04-2024

labels = zeros(length,1);

for row = 1:size(rawLabels,1)
    % Extract info from raw data
    firstFrame = str2num(rawLabels(row,1));
    lastFrame = str2num(rawLabels(row,2));
    gesture = convertStringsToChars(rawLabels(row,3));
    gesture = str2num(gesture(2:end));
    % Insert into output array
    labels(firstFrame:lastFrame) = gesture;
end

% Handle the case in which rawLabels data is corrupt (Suturing_H002)
if size(rawLabels,1) < 1
    labels = [];
end

end