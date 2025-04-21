function matrix = dataCellArrayToMatrix(data)
% dataCellArrayToMatrix - Convert a cell array of data into a matrix.
%
%   matrix = dataCellArrayToMatrix(data) takes a cell array 'data' containing
%   experimental data and converts it into a matrix. Each cell in the input
%   'data' represents an experiment, and the matrix is formed by stacking
%   these experiments vertically.
%
%   Parameters:
%       data: A 2D cell array of experimental data. Each cell represents an
%             experiment and should contain numerical data.
%
%   Returns:
%       matrix: A matrix formed by stacking the experiments from the cell
%               array vertically. The size of the resulting matrix is
%               determined by the size of the input cell array.
%
%   Example:
%       data = { [1 2 3; 4 5 6], [7 8 9; 10 11 12]; 
%                [1 2 3; 4 5 6], [7 8 9; 10 11 12] };
%       matrix = dataCellArrayToMatrix(data);
%       % matrix will be:
%       % 1  2  3
%       % 4  5  6
%       % 7  8  9
%       % 10 11 12
%       % 1  2  3
%       % 4  5  6
%       % 7  8  9
%       % 10 11 12
% 
% 
%   Author: juanmhl
%   Date: 10-04-2024

matrix = [];
for user = 1:size(data,1)
    for trial = 1:size(data,2)
        experiment = data{user,trial};
        matrix = [matrix; experiment];
    end
end
end